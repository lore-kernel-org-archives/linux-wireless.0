Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091FF361975;
	Fri, 21 Aug 2026 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281728; cv=none; b=LW2wmu9AagEmdk39dhhNnJ0xiUO4J6Nm/yrmKgs6021J3fNyF95dMCYJRAW+Y/SxtgeT/JcRY6/1HrKhq0BI2rh0hZe8GmM1f1ZMg/0HEaYQoiua6Twr0kKHxBentuONsjYhqQzYGwYN85XaNsq0AUnUyFSkuYUyE1Ql60t9GxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281728; c=relaxed/simple;
	bh=CpQsft4bkU5IPa2Odpd88k7pfvX0/CNch9+XSKc/gVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIRmMsv1lvDOzCVUazBBHquxGhEU+NhB7uB6/lWYnfMj2As8vy0L9ZblCKtVWkijsXuQvvi+k7FaArPNd0sZcGNal034NNyQEJbjQdmvqs8QSwDnQdXtK0/VQp9TXvt4W3sh6WRikUwBZLr8DF2g00M8/vLOwGM7m7qIcpxNCK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wxFca-000000005Tw-1lMy;
	Fri, 21 Aug 2026 03:08:44 +0000
Date: Fri, 21 Aug 2026 04:08:41 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: [PATCH v3 2/4] wifi: iwlwifi: use device_schedule_reprobe()
Message-ID: <e74b8797e31fcd3ee156f78881d9a7db1a7b243c.1787281239.git.daniel@makrotopia.org>
References: <cover.1787281239.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787281239.git.daniel@makrotopia.org>

iwl_trans_schedule_reprobe() open-codes a deferred re-probe: it takes
a module reference, allocates a work item, and the work function calls
device_reprobe() and then ends with put_device(); kfree();
module_put(THIS_MODULE); in module text. That final module_put() is
racy: once the reference count is decremented a concurrent rmmod can
free the module text before the work function's epilogue has finished
executing. The work also does not synchronize against shutdown or
unbind, so a stale re-probe could undo an administrative unbind or
detach a device whose ->shutdown() callback has already run.

Convert to the new device_schedule_reprobe() helper, whose work
function is builtin text and which skips the re-probe when the device
was removed, shutdown reached it, or it is no longer bound to the
driver that scheduled the re-probe. Both call sites keep their delays
(IWL_TRANS_TOP_FOLLOWER_WAIT for the TOP follower case, 0 for the
escalated firmware error case).

Behavioral changes:

- A pending re-probe no longer pins the module: rmmod with a re-probe
  pending now succeeds immediately and the re-probe becomes a no-op,
  instead of rmmod failing with EBUSY. The "Module is being unloaded -
  abort" path disappears together with the try_module_get().

- A re-probe scheduled before a system shutdown or before an
  administrative unbind no longer detaches and rebinds the device
  afterwards.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v3: no changes
v2: no changes
v1: initial RFC

 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 40 +------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 73aae1125042..5ae734cb9027 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -78,47 +78,11 @@ void iwl_trans_free_restart_list(void)
 	}
 }
 
-struct iwl_trans_reprobe {
-	struct device *dev;
-	struct delayed_work work;
-};
-
-static void iwl_trans_reprobe_wk(struct work_struct *wk)
-{
-	struct iwl_trans_reprobe *reprobe;
-
-	reprobe = container_of(wk, typeof(*reprobe), work.work);
-
-	if (device_reprobe(reprobe->dev))
-		dev_err(reprobe->dev, "reprobe failed!\n");
-	put_device(reprobe->dev);
-	kfree(reprobe);
-	module_put(THIS_MODULE);
-}
-
 static void iwl_trans_schedule_reprobe(struct iwl_trans *trans,
 				       unsigned int delay_ms)
 {
-	struct iwl_trans_reprobe *reprobe;
-
-	/*
-	 * get a module reference to avoid doing this while unloading
-	 * anyway and to avoid scheduling a work with code that's
-	 * being removed.
-	 */
-	if (!try_module_get(THIS_MODULE)) {
-		IWL_ERR(trans, "Module is being unloaded - abort\n");
-		return;
-	}
-
-	reprobe = kzalloc_obj(*reprobe);
-	if (!reprobe) {
-		module_put(THIS_MODULE);
-		return;
-	}
-	reprobe->dev = get_device(trans->dev);
-	INIT_DELAYED_WORK(&reprobe->work, iwl_trans_reprobe_wk);
-	schedule_delayed_work(&reprobe->work, msecs_to_jiffies(delay_ms));
+	if (device_schedule_reprobe(trans->dev, delay_ms))
+		IWL_ERR(trans, "Could not schedule reprobe\n");
 }
 
 #define IWL_TRANS_RESET_OK_TIME	7 /* seconds */
-- 
2.55.0

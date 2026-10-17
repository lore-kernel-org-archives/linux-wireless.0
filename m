Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C113E3546EA;
	Sat, 17 Oct 2026 08:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792227407; cv=none; b=e2qmzogL2N9w4XBEU5PRwZlzBotvNMGZClSGs2YKP3bPDtgGRabTYXf8gDJYydZTNA4oxomFTLLqUMiSLfn/w4lxs7g7rKreqmONtn/bKrhH/Bl6j0Z+4qVkhaW+BzR2gxX2o9RXbqe7Sqbi27ebutGQG71ToCCJJLeDqeB4Bos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792227407; c=relaxed/simple;
	bh=H6NeQQYMoADmgPF0SUwSFUEc3vfc1ufsYvNhMJSMT/8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmKuGaKGA5w7Yz7oHRHMBuYI6XHpP6GNCKPXNgTIT5VHevdegkDQsQXlZD+mEau3GpD4WoaoHS8BTRicWDxmZOlkM+11x2W20VzBBlFshKui+kALQU9JGYHXL99fjbe4lrfmGbetkOo33FQDoEKLIPXFCL01Byc8yawntlEK5lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256:X25519MLKEM768)
	 (Exim 4.100.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1xI0Db-000000004Gj-2AfR;
	Sat, 17 Oct 2026 08:56:43 +0000
Date: Sat, 17 Oct 2026 09:56:40 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Hans de Goede <hansg@kernel.org>, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 2/4] wifi: iwlwifi: use device_schedule_reprobe()
Message-ID: <b577a14960d05c7a43b1190ec8a392f5378833ae.1792203271.git.daniel@makrotopia.org>
References: <cover.1792203271.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1792203271.git.daniel@makrotopia.org>

iwl_trans_schedule_reprobe() runs device_reprobe() from a work item in
module text that ends with module_put(THIS_MODULE), so a concurrent
rmmod can free the module while the work still runs, and a stale
re-probe can undo an unbind. With the work held just past module_put()
by a test-only delay, rmmod ends in a lockdep oops on the work's lock
class, freed with the module. Use device_schedule_reprobe(); both
callers run in iwl_trans_restart_wk(), which ->remove() cancels
synchronously.

A pending re-probe no longer pins the module: rmmod succeeds and
cancels it.

Fixes: ac1ed4163b5a ("iwlwifi: mvm: reprobe device on firmware error during restart")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v4: commit message updated for the reworked helper; add Fixes:
v3: no changes
v2: no changes
v1: initial RFC

 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 40 +------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 73aae11250421..5ae734cb90272 100644
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
2.56.0

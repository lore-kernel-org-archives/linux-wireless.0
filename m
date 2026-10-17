Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3AF3B8D79;
	Sat, 17 Oct 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792227418; cv=none; b=ZVV3X1joaDc7c2XKvnMCvL9Hfn9epKZUlhfDA1evkVpeHdj8BnzSj36pxrP+Xb7LF3RIoryDWZOek38cYoDH23klxSZ54PO5ycN6CCur9mizLUZ1+BgIkjxr7TjnJORdDPhRS8ckUypKPnE8KODWOkU+DWEUT0Po/38KWtesHw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792227418; c=relaxed/simple;
	bh=A4IfISFm3h7bHEEkoBPwxnVxiMuU7gHxsAV8yzFOq+Q=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDLxZ4c727gT+52JVHnf74ZtV4aZ40upNhuY8Eaevw/S8qQXeiENl2HYHbxTH8WvdRF9KPlM8pC+J3nvIoYWQztgSPw4euQ4KItXAAdM29Aw1bt8xwd8gLnEJv088RjtwDmUkphcRhk+52iJ7aRRUmzvcZXIELXu3P9MnuV/Akg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256:X25519MLKEM768)
	 (Exim 4.100.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1xI0Dm-000000004H4-2lHH;
	Sat, 17 Oct 2026 08:56:54 +0000
Date: Sat, 17 Oct 2026 09:56:51 +0100
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
Subject: [PATCH v4 3/4] Bluetooth: hci_h5: use device_schedule_reprobe()
Message-ID: <4527ba8c1bcdd073a92e7b64e2d68b2a2224d610.1792203271.git.daniel@makrotopia.org>
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

h5_btrtl_resume() runs device_reprobe() from a work item in module text
that ends with module_put(THIS_MODULE), so a concurrent rmmod can free
the module while the work still runs, and a stale re-probe can undo an
unbind. Use device_schedule_reprobe(), which may be called from the
resume callback with the device lock held.

The re-probe now runs once tasks are thawed, after the resume has
unblocked probing.

Fixes: 8589086f4efd ("Bluetooth: hci_h5: Turn off RTL8723BS on suspend, reprobe on resume")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
---
v4: commit message updated for the reworked helper; add Fixes:; code
    unchanged, so Hans de Goede's tags, given with the v3 helper, stay
v3: picked up Hans de Goede's Tested-by/Reviewed-by
v2: also correct the stale device_reprobe() reference in the
    h5_btrtl_open() comment
v1: initial RFC

 drivers/bluetooth/hci_h5.c | 43 ++++++--------------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 37f4d9327e724..fb819d769dd52 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -989,7 +989,7 @@ static int h5_btrtl_setup(struct h5 *h5)
 static void h5_btrtl_open(struct h5 *h5)
 {
 	/*
-	 * Since h5_btrtl_resume() does a device_reprobe() the suspend handling
+	 * Since h5_btrtl_resume() schedules a device re-probe the suspend handling
 	 * done by the hci_suspend_notifier is not necessary; it actually causes
 	 * delays and a bunch of errors to get logged, so disable it.
 	 */
@@ -1048,46 +1048,15 @@ static int h5_btrtl_suspend(struct h5 *h5)
 	return 0;
 }
 
-struct h5_btrtl_reprobe {
-	struct device *dev;
-	struct work_struct work;
-};
-
-static void h5_btrtl_reprobe_worker(struct work_struct *work)
-{
-	struct h5_btrtl_reprobe *reprobe =
-		container_of(work, struct h5_btrtl_reprobe, work);
-	int ret;
-
-	ret = device_reprobe(reprobe->dev);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(reprobe->dev, "Reprobe error %d\n", ret);
-
-	put_device(reprobe->dev);
-	kfree(reprobe);
-	module_put(THIS_MODULE);
-}
-
 static int h5_btrtl_resume(struct h5 *h5)
 {
-	if (test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
-		struct h5_btrtl_reprobe *reprobe;
-
-		reprobe = kzalloc_obj(*reprobe);
-		if (!reprobe)
-			return -ENOMEM;
-
-		__module_get(THIS_MODULE);
+	if (test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+		return device_schedule_reprobe(&h5->hu->serdev->dev, 0);
 
-		INIT_WORK(&reprobe->work, h5_btrtl_reprobe_worker);
-		reprobe->dev = get_device(&h5->hu->serdev->dev);
-		queue_work(system_long_wq, &reprobe->work);
-	} else {
-		gpiod_set_value_cansleep(h5->device_wake_gpio, 1);
+	gpiod_set_value_cansleep(h5->device_wake_gpio, 1);
 
-		if (test_bit(H5_HW_FLOW_CONTROL, &h5->flags))
-			serdev_device_set_flow_control(h5->hu->serdev, true);
-	}
+	if (test_bit(H5_HW_FLOW_CONTROL, &h5->flags))
+		serdev_device_set_flow_control(h5->hu->serdev, true);
 
 	return 0;
 }
-- 
2.56.0

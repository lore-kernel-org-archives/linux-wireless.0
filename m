Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63798 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2CIE0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 23:26:11 -0500
Received: by iagz16 with SMTP id z16so1692806iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 20:26:11 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: [PATCH 1/5 V2] b43legacy: Load firmware from work queue instead of from probe routine
Date: Thu,  8 Mar 2012 22:25:57 -0600
Message-Id: <1331267157-19476-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120309_052616_822085_93A864FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes in udev are causing problems for drivers that load firmware
from the probe routine. As b43legacy has such a structure, it must be changed.
As this driver loads 3 or 4 firmware files, changing to the asynchronous routine
request_firmware_nowait() would be complicated. In this implementation, the probe
routine starts a work queue that calls the firmware loading routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - Change from delayed to ordinary work queue

John,

I think this patch should stay in wireless-testing and ultimately be pushed
to 3.5.

Larry
---

 drivers/net/wireless/b43legacy/b43legacy.h |    3 ++
 drivers/net/wireless/b43legacy/main.c      |   32 ++++++++++++++++-----------
 2 files changed, 22 insertions(+), 13 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing-new/drivers/net/wireless/b43legacy/b43legacy.h
@@ -581,6 +581,9 @@ struct b43legacy_wl {
 	struct mutex mutex;		/* locks wireless core state */
 	spinlock_t leds_lock;		/* lock for leds */
 
+	/* firmware loading work */
+	struct work_struct firmware_load;
+
 	/* We can only have one operating interface (802.11 core)
 	 * at a time. General information about this interface follows.
 	 */
Index: wireless-testing-new/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing-new/drivers/net/wireless/b43legacy/main.c
@@ -1557,8 +1557,15 @@ err_format:
 	return -EPROTO;
 }
 
-static int b43legacy_request_firmware(struct b43legacy_wldev *dev)
+static int b43legacy_one_core_attach(struct ssb_device *dev,
+				     struct b43legacy_wl *wl);
+static void b43legacy_one_core_detach(struct ssb_device *dev);
+
+static void b43legacy_request_firmware(struct work_struct *work)
 {
+	struct b43legacy_wl *wl = container_of(work,
+				  struct b43legacy_wl, firmware_load);
+	struct b43legacy_wldev *dev = wl->current_dev;
 	struct b43legacy_firmware *fw = &dev->fw;
 	const u8 rev = dev->dev->id.revision;
 	const char *filename;
@@ -1624,8 +1631,14 @@ static int b43legacy_request_firmware(st
 		if (err)
 			goto err_load;
 	}
+	err = ieee80211_register_hw(wl->hw);
+	if (err)
+		goto err_one_core_detach;
+	return;
 
-	return 0;
+err_one_core_detach:
+	b43legacy_one_core_detach(dev->dev);
+	goto error;
 
 err_load:
 	b43legacy_print_fw_helptext(dev->wl);
@@ -1639,7 +1652,7 @@ err_no_initvals:
 
 error:
 	b43legacy_release_firmware(dev);
-	return err;
+	return;
 }
 
 static int b43legacy_upload_microcode(struct b43legacy_wldev *dev)
@@ -2153,9 +2166,6 @@ static int b43legacy_chip_init(struct b4
 	macctl |= B43legacy_MACCTL_INFRA;
 	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
 
-	err = b43legacy_request_firmware(dev);
-	if (err)
-		goto out;
 	err = b43legacy_upload_microcode(dev);
 	if (err)
 		goto out; /* firmware is released later */
@@ -3860,17 +3870,13 @@ static int b43legacy_probe(struct ssb_de
 	if (err)
 		goto err_wireless_exit;
 
-	if (first) {
-		err = ieee80211_register_hw(wl->hw);
-		if (err)
-			goto err_one_core_detach;
-	}
+	/* setup and start work to load firmware */
+	INIT_WORK(&wl->firmware_load, b43legacy_request_firmware);
+	schedule_work(&wl->firmware_load);
 
 out:
 	return err;
 
-err_one_core_detach:
-	b43legacy_one_core_detach(dev);
 err_wireless_exit:
 	if (first)
 		b43legacy_wireless_exit(dev, wl);
@@ -3885,6 +3891,7 @@ static void b43legacy_remove(struct ssb_
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
+	cancel_work_sync(&wl->firmware_load);
 
 	B43legacy_WARN_ON(!wl);
 	if (wl->current_dev == wldev)

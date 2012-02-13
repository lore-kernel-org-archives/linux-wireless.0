Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34958 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab2BMThb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:37:31 -0500
Received: by yenm8 with SMTP id m8so2576797yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 11:37:31 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: [RFC/RFT 1/5] b43legacy: Load firmware from work queue instead of from probe routine
Date: Mon, 13 Feb 2012 13:37:02 -0600
Message-Id: <1329161826-11135-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120213_203734_272669_3BE39B51)
In-Reply-To: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes in udev are causing problems for drivers that load firmware
from the probe routine. As b43legacy has such a structure, it must be changed.
As this driver loads 3 or 4 firmware files, changing to the asynchronous routine
request_firmware_nowait() would be complicated. In this implementation, the probe
routine starts a delayed_work queue that calls the firmware loading routines when
the delay (1 sec) expires..

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/b43legacy/b43legacy.h |    3 ++
 drivers/net/wireless/b43legacy/main.c      |   32 ++++++++++++++++-----------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/b43legacy.h b/drivers/net/wireless/b43legacy/b43legacy.h
index 98e3d44..e9337e5 100644
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -581,6 +581,9 @@ struct b43legacy_wl {
 	struct mutex mutex;		/* locks wireless core state */
 	spinlock_t leds_lock;		/* lock for leds */
 
+	/* delayed firmware loading */
+	struct delayed_work firmware_load;
+
 	/* We can only have one operating interface (802.11 core)
 	 * at a time. General information about this interface follows.
 	 */
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 75e70bc..99d1237 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
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
+	struct b43legacy_wl *wl = container_of(to_delayed_work(work),
+				  struct b43legacy_wl, firmware_load);
+	struct b43legacy_wldev *dev = wl->current_dev;
 	struct b43legacy_firmware *fw = &dev->fw;
 	const u8 rev = dev->dev->id.revision;
 	const char *filename;
@@ -1624,8 +1631,14 @@ static int b43legacy_request_firmware(struct b43legacy_wldev *dev)
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
@@ -2153,9 +2166,6 @@ static int b43legacy_chip_init(struct b43legacy_wldev *dev)
 	macctl |= B43legacy_MACCTL_INFRA;
 	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
 
-	err = b43legacy_request_firmware(dev);
-	if (err)
-		goto out;
 	err = b43legacy_upload_microcode(dev);
 	if (err)
 		goto out; /* firmware is released later */
@@ -3860,17 +3870,13 @@ static int b43legacy_probe(struct ssb_device *dev,
 	if (err)
 		goto err_wireless_exit;
 
-	if (first) {
-		err = ieee80211_register_hw(wl->hw);
-		if (err)
-			goto err_one_core_detach;
-	}
+	/* setup and start delayed work to load firmware */
+	INIT_DELAYED_WORK(&wl->firmware_load, b43legacy_request_firmware);
+	schedule_delayed_work(&wl->firmware_load, HZ);
 
 out:
 	return err;
 
-err_one_core_detach:
-	b43legacy_one_core_detach(dev);
 err_wireless_exit:
 	if (first)
 		b43legacy_wireless_exit(dev, wl);
-- 
1.7.7


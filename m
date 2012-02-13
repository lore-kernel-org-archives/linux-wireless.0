Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48817 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab2BMThf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:37:35 -0500
Received: by ghrr11 with SMTP id r11so2581605ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 11:37:34 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: [RFC/RFT 2/5] b43: Load firmware from a work queue and not from the probe routine
Date: Mon, 13 Feb 2012 13:37:03 -0600
Message-Id: <1329161826-11135-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120213_203737_600862_49580521)
In-Reply-To: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes in udev are causing problems for drivers that load firmware
from the probe routine. As b43 has such a structure, it must be changed.
As this driver loads more than 1 firmware file, changing to the asynchronous routine
request_firmware_nowait() would be complicated. In this implementation, the probe
routine starts a delayed_work queue that calls the firmware loading routines when
the delay (1 sec) expires..

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/b43/b43.h  |    3 +++
 drivers/net/wireless/b43/main.c |   38 ++++++++++++++++++++++----------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 835462d..532ba79 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -932,6 +932,9 @@ struct b43_wl {
 	/* Flag that implement the queues stopping. */
 	bool tx_queue_stopped[B43_QOS_QUEUE_NUM];
 
+	/* delayed firmware loading */
+	struct delayed_work firmware_load;
+
 	/* The device LEDs. */
 	struct b43_leds leds;
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1b540d2..903e1ea 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2390,8 +2390,14 @@ error:
 	return err;
 }
 
-static int b43_request_firmware(struct b43_wldev *dev)
+static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl);
+static void b43_one_core_detach(struct b43_bus_dev *dev);
+
+static void b43_request_firmware(struct work_struct *work)
 {
+	struct b43_wl *wl = container_of(to_delayed_work(work),
+			    struct b43_wl, firmware_load);
+	struct b43_wldev *dev = wl->current_dev;
 	struct b43_request_fw_context *ctx;
 	unsigned int i;
 	int err;
@@ -2399,13 +2405,13 @@ static int b43_request_firmware(struct b43_wldev *dev)
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return -ENOMEM;
+		return;
 	ctx->dev = dev;
 
 	ctx->req_type = B43_FWTYPE_PROPRIETARY;
 	err = b43_try_request_fw(ctx);
 	if (!err)
-		goto out; /* Successfully loaded it. */
+		goto start_ieee80211; /* Successfully loaded it. */
 	err = ctx->fatal_failure;
 	if (err)
 		goto out;
@@ -2413,7 +2419,7 @@ static int b43_request_firmware(struct b43_wldev *dev)
 	ctx->req_type = B43_FWTYPE_OPENSOURCE;
 	err = b43_try_request_fw(ctx);
 	if (!err)
-		goto out; /* Successfully loaded it. */
+		goto start_ieee80211; /* Successfully loaded it. */
 	err = ctx->fatal_failure;
 	if (err)
 		goto out;
@@ -2427,9 +2433,17 @@ static int b43_request_firmware(struct b43_wldev *dev)
 	b43_print_fw_helptext(dev->wl, 1);
 	err = -ENOENT;
 
+start_ieee80211:
+	err = ieee80211_register_hw(wl->hw);
+	if (err)
+		goto err_one_core_detach;
+	goto out;
+
+err_one_core_detach:
+	b43_one_core_detach(dev->dev);
+
 out:
 	kfree(ctx);
-	return err;
 }
 
 static int b43_upload_microcode(struct b43_wldev *dev)
@@ -3021,9 +3035,6 @@ static int b43_chip_init(struct b43_wldev *dev)
 	macctl |= B43_MACCTL_INFRA;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 
-	err = b43_request_firmware(dev);
-	if (err)
-		goto out;
 	err = b43_upload_microcode(dev);
 	if (err)
 		goto out;	/* firmware is released later */
@@ -5391,18 +5402,13 @@ int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 	if (err)
 		goto err_wireless_exit;
 
-	if (first) {
-		err = ieee80211_register_hw(wl->hw);
-		if (err)
-			goto err_one_core_detach;
-		b43_leds_register(wl->current_dev);
-	}
+	/* setup and start delayed work to load firmware */
+	INIT_DELAYED_WORK(&wl->firmware_load, b43_request_firmware);
+	schedule_delayed_work(&wl->firmware_load, HZ);
 
       out:
 	return err;
 
-      err_one_core_detach:
-	b43_one_core_detach(dev);
       err_wireless_exit:
 	if (first)
 		b43_wireless_exit(dev, wl);
-- 
1.7.7


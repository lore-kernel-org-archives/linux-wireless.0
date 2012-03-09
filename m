Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36449 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2CIE1z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 23:27:55 -0500
Received: by iagz16 with SMTP id z16so1694300iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 20:27:55 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: [PATCH 2/5 V2] b43: Load firmware from a work queue and not from the probe routine
Date: Thu,  8 Mar 2012 22:27:46 -0600
Message-Id: <1331267266-19543-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120309_052804_367452_31DB43EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes in udev are causing problems for drivers that load firmware
from the probe routine. As b43 has such a structure, it must be changed.
As this driver loads more than 1 firmware file, changing to the asynchronous routine
request_firmware_nowait() would be complicated. In this implementation, the probe
routine starts a queue that calls the firmware loading routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - Change from delayed to ordinary work queue
     Fixed some incorrect error returns when firmware loading fails
     Cleaned up some error processing
     Modified the bcma probe routine to use the work queue

John,

Again, this patch should be applied to 3.5.

Larry
---

 drivers/net/wireless/b43/b43.h  |    3 +++
 drivers/net/wireless/b43/main.c |   38 ++++++++++++++++++++++----------------
 2 files changed, 25 insertions(+), 16 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/b43.h
+++ wireless-testing-new/drivers/net/wireless/b43/b43.h
@@ -932,6 +932,9 @@ struct b43_wl {
 	/* Flag that implement the queues stopping. */
 	bool tx_queue_stopped[B43_QOS_QUEUE_NUM];
 
+	/* firmware loading work */
+	struct work_struct firmware_load;
+
 	/* The device LEDs. */
 	struct b43_leds leds;
 
Index: wireless-testing-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing-new/drivers/net/wireless/b43/main.c
@@ -2390,8 +2390,14 @@ error:
 	return err;
 }
 
-static int b43_request_firmware(struct b43_wldev *dev)
+static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl);
+static void b43_one_core_detach(struct b43_bus_dev *dev);
+
+static void b43_request_firmware(struct work_struct *work)
 {
+	struct b43_wl *wl = container_of(work,
+			    struct b43_wl, firmware_load);
+	struct b43_wldev *dev = wl->current_dev;
 	struct b43_request_fw_context *ctx;
 	unsigned int i;
 	int err;
@@ -2399,23 +2405,23 @@ static int b43_request_firmware(struct b
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return -ENOMEM;
+		return;
 	ctx->dev = dev;
 
 	ctx->req_type = B43_FWTYPE_PROPRIETARY;
 	err = b43_try_request_fw(ctx);
 	if (!err)
-		goto out; /* Successfully loaded it. */
-	err = ctx->fatal_failure;
-	if (err)
+		goto start_ieee80211; /* Successfully loaded it. */
+	/* Was fw version known? */
+	if (ctx->fatal_failure)
 		goto out;
 
+	/* proprietary fw not found, try open source */
 	ctx->req_type = B43_FWTYPE_OPENSOURCE;
 	err = b43_try_request_fw(ctx);
 	if (!err)
-		goto out; /* Successfully loaded it. */
-	err = ctx->fatal_failure;
-	if (err)
+		goto start_ieee80211; /* Successfully loaded it. */
+	if(ctx->fatal_failure)
 		goto out;
 
 	/* Could not find a usable firmware. Print the errors. */
@@ -2425,11 +2431,20 @@ static int b43_request_firmware(struct b
 			b43err(dev->wl, errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
-	err = -ENOENT;
+	goto out;
+
+start_ieee80211:
+	err = ieee80211_register_hw(wl->hw);
+	if (err)
+		goto err_one_core_detach;
+	b43_leds_register(wl->current_dev);
+	goto out;
+
+err_one_core_detach:
+	b43_one_core_detach(dev->dev);
 
 out:
 	kfree(ctx);
-	return err;
 }
 
 static int b43_upload_microcode(struct b43_wldev *dev)
@@ -3021,9 +3036,6 @@ static int b43_chip_init(struct b43_wlde
 	macctl |= B43_MACCTL_INFRA;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 
-	err = b43_request_firmware(dev);
-	if (err)
-		goto out;
 	err = b43_upload_microcode(dev);
 	if (err)
 		goto out;	/* firmware is released later */
@@ -4153,6 +4165,7 @@ redo:
 	mutex_unlock(&wl->mutex);
 	cancel_delayed_work_sync(&dev->periodic_work);
 	cancel_work_sync(&wl->tx_work);
+	cancel_work_sync(&wl->firmware_load);
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (!dev || b43_status(dev) < B43_STAT_STARTED) {
@@ -5315,16 +5328,13 @@ static int b43_bcma_probe(struct bcma_de
 	if (err)
 		goto bcma_err_wireless_exit;
 
-	err = ieee80211_register_hw(wl->hw);
-	if (err)
-		goto bcma_err_one_core_detach;
-	b43_leds_register(wl->current_dev);
+	/* setup and start work to load firmware */
+	INIT_WORK(&wl->firmware_load, b43_request_firmware);
+	schedule_work(&wl->firmware_load);
 
 bcma_out:
 	return err;
 
-bcma_err_one_core_detach:
-	b43_one_core_detach(dev);
 bcma_err_wireless_exit:
 	ieee80211_free_hw(wl->hw);
 	return err;
@@ -5391,18 +5401,13 @@ int b43_ssb_probe(struct ssb_device *sde
 	if (err)
 		goto err_wireless_exit;
 
-	if (first) {
-		err = ieee80211_register_hw(wl->hw);
-		if (err)
-			goto err_one_core_detach;
-		b43_leds_register(wl->current_dev);
-	}
+	/* setup and start work to load firmware */
+	INIT_WORK(&wl->firmware_load, b43_request_firmware);
+	schedule_work(&wl->firmware_load);
 
       out:
 	return err;
 
-      err_one_core_detach:
-	b43_one_core_detach(dev);
       err_wireless_exit:
 	if (first)
 		b43_wireless_exit(dev, wl);

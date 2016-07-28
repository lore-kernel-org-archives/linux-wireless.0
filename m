Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52505 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbcG1IFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:34 -0400
From: Daniel Wagner <wagi@monom.org>
To: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 5/8] ath9k_htc: use firmware_stat instead of completion
Date: Thu, 28 Jul 2016 09:55:09 +0200
Message-Id: <1469692512-16863-6-git-send-email-wagi@monom.org> (sfid-20160728_100603_022696_D9AF28F7)
In-Reply-To: <1469692512-16863-1-git-send-email-wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Loading firmware is an operation many drivers implement in various ways
around the completion API. And most of them do it almost in the same
way. Let's reuse the firmware_stat API which is used also by the
firmware_class loader. Apart of streamlining the firmware loading states
we also document it slightly better.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/hif_usb.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e1c338c..0a05d68 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1067,7 +1067,7 @@ static void ath9k_hif_usb_firmware_fail(struct hif_device_usb *hif_dev)
 	struct device *dev = &hif_dev->udev->dev;
 	struct device *parent = dev->parent;
 
-	complete_all(&hif_dev->fw_done);
+	fw_loading_abort(hif_dev->fw_st);
 
 	if (parent)
 		device_lock(parent);
@@ -1192,7 +1192,7 @@ static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 
 	release_firmware(fw);
 	hif_dev->flags |= HIF_USB_READY;
-	complete_all(&hif_dev->fw_done);
+	fw_loading_done(hif_dev->fw_st);
 
 	return;
 
@@ -1287,7 +1287,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 #endif
 	usb_set_intfdata(interface, hif_dev);
 
-	init_completion(&hif_dev->fw_done);
+	firmware_stat_init(&hif_dev->fw_st);
 
 	ret = ath9k_hif_request_firmware(hif_dev, true);
 	if (ret)
@@ -1330,7 +1330,7 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 	if (!hif_dev)
 		return;
 
-	wait_for_completion(&hif_dev->fw_done);
+	fw_loading_wait(hif_dev->fw_st);
 
 	if (hif_dev->flags & HIF_USB_READY) {
 		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
@@ -1363,7 +1363,7 @@ static int ath9k_hif_usb_suspend(struct usb_interface *interface,
 	if (!(hif_dev->flags & HIF_USB_START))
 		ath9k_htc_suspend(hif_dev->htc_handle);
 
-	wait_for_completion(&hif_dev->fw_done);
+	fw_loading_wait(hif_dev->fw_st);
 
 	if (hif_dev->flags & HIF_USB_READY)
 		ath9k_hif_usb_dealloc_urbs(hif_dev);
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 7c2ef7e..0af9fe4 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -111,7 +111,7 @@ struct hif_device_usb {
 	const struct usb_device_id *usb_device_id;
 	const void *fw_data;
 	size_t fw_size;
-	struct completion fw_done;
+	struct firmware_stat fw_st;
 	struct htc_target *htc_handle;
 	struct hif_usb_tx tx;
 	struct usb_anchor regout_submitted;
-- 
2.7.4

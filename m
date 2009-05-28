Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZE1VgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 17:36:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org, jal2@gmx.de,
	Peter.Grabienski@Atheros.com, Stephen.Chen@Atheros.com,
	Michael.Fortin@Atheros.com, Johnny.Cheng@Atheros.com,
	Yuan-Gu.Wei@atheros.com, otus-devel@lists.madwifi-project.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] ar9170: add AVM FRITZ devices
Date: Thu, 28 May 2009 17:36:05 -0400
Message-Id: <1243546565-19404-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
References: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds:

USB 0x057C:0x8401       AVM FRITZ!WLAN USB Stick N
USB 0x057C:0x8402       AVM FRITZ!WLAN USB Stick N 2.4

These devices require the 1-stage firmware, if not present we
don't continue.

Cc: Peter Grabienski <Peter.Grabienski@Atheros.com>
Cc: Stephen Chen <Stephen.Chen@Atheros.com>
Cc: Michael Fortin <Michael.Fortin@Atheros.com>
Cc: Johnny Cheng <Johnny.Cheng@Atheros.com>
Cc: Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>
Cc: Joerg Albert <jal2@gmx.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/usb.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ar9170/usb.h |    2 ++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 3c97c09..71579e4 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -55,6 +55,10 @@ MODULE_FIRMWARE("ar9170.fw");
 MODULE_FIRMWARE("ar9170-1.fw");
 MODULE_FIRMWARE("ar9170-2.fw");
 
+enum ar9170_requirements {
+	AR9170_REQ_FW1_ONLY = 1,
+};
+
 static struct usb_device_id ar9170_usb_ids[] = {
 	/* Atheros 9170 */
 	{ USB_DEVICE(0x0cf3, 0x9170) },
@@ -82,6 +86,10 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x2019, 0x5304) },
 	/* IO-Data WNGDNUS2 */
 	{ USB_DEVICE(0x04bb, 0x093f) },
+	/* AVM FRITZ!WLAN USB Stick N */
+	{ USB_DEVICE(0x057C, 0x8401) },
+	/* AVM FRITZ!WLAN USB Stick N 2.4 */
+	{ USB_DEVICE(0x057C, 0x8402), .driver_info = AR9170_REQ_FW1_ONLY },
 
 	/* terminate */
 	{}
@@ -512,6 +520,12 @@ static int ar9170_usb_request_firmware(struct ar9170_usb *aru)
 		return 0;
 	}
 
+	if (aru->req_one_stage_fw) {
+		dev_err(&aru->udev->dev, "ar9170.fw firmware file "
+			"not found and is required for this device\n");
+		return -EINVAL;
+	}
+
 	dev_err(&aru->udev->dev, "ar9170.fw firmware file "
 		"not found, trying old firmware...\n");
 
@@ -668,6 +682,15 @@ err_out:
 	return err;
 }
 
+static bool ar9170_requires_one_stage(const struct usb_device_id *id)
+{
+	if (!id->driver_info)
+		return false;
+	if (id->driver_info == AR9170_REQ_FW1_ONLY)
+		return true;
+	return false;
+}
+
 static int ar9170_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
@@ -688,6 +711,8 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	aru->intf = intf;
 	ar = &aru->common;
 
+	aru->req_one_stage_fw = ar9170_requires_one_stage(id);
+
 	usb_set_intfdata(intf, aru);
 	SET_IEEE80211_DEV(ar->hw, &udev->dev);
 
diff --git a/drivers/net/wireless/ath/ar9170/usb.h b/drivers/net/wireless/ath/ar9170/usb.h
index ac42586..69f4bce 100644
--- a/drivers/net/wireless/ath/ar9170/usb.h
+++ b/drivers/net/wireless/ath/ar9170/usb.h
@@ -62,6 +62,8 @@ struct ar9170_usb {
 	struct usb_anchor rx_submitted;
 	struct usb_anchor tx_submitted;
 
+	bool req_one_stage_fw;
+
 	spinlock_t cmdlock;
 	struct completion cmd_wait;
 	int readlen;
-- 
1.6.0.6


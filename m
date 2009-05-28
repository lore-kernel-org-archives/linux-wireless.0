Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56626 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946AbZE1Bsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 21:48:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: jal2@gmx.de, Peter.Grabienski@Atheros.com,
	Stephen.Chen@Atheros.com, Michael.Fortin@Atheros.com,
	Johnny.Cheng@Atheros.com, Yuan-Gu.Wei@atheros.com,
	otus-devel@lists.madwifi-project.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 2/2] ar9170: add AVM FRITZ devices
Date: Wed, 27 May 2009 21:48:46 -0400
Message-Id: <1243475326-28867-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
References: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
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
 drivers/net/wireless/ath/ar9170/usb.c |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ar9170/usb.h |    2 ++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 3c97c09..45b5291 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -82,6 +82,10 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x2019, 0x5304) },
 	/* IO-Data WNGDNUS2 */
 	{ USB_DEVICE(0x04bb, 0x093f) },
+	/* AVM FRITZ!WLAN USB Stick N */
+	{ USB_DEVICE(0x057C, 0x8401) },
+	/* AVM FRITZ!WLAN USB Stick N 2.4 */
+	{ USB_DEVICE(0x057C, 0x8402) },
 
 	/* terminate */
 	{}
@@ -512,6 +516,12 @@ static int ar9170_usb_request_firmware(struct ar9170_usb *aru)
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
 
@@ -668,6 +678,22 @@ err_out:
 	return err;
 }
 
+static bool ar9170_requires_one_stage(const struct usb_device_id *id)
+{
+	/* AVM FRITZ only */
+	if (id->idVendor != 0x057C)
+		return false;
+
+	switch (id->idProduct) {
+		case 0x8401: /* AVM FRITZ!WLAN USB Stick N */
+		case 0x8402: /* AVM FRITZ!WLAN USB Stick N 2.4 */
+			return true;
+		default:
+			return false;
+	}
+	return false;
+}
+
 static int ar9170_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
@@ -688,6 +714,8 @@ static int ar9170_usb_probe(struct usb_interface *intf,
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


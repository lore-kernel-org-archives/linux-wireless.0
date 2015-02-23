Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:58607 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbBWAfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 19:35:25 -0500
Received: by mail-qg0-f46.google.com with SMTP id z107so22130840qgd.5
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 16:35:24 -0800 (PST)
From: Leon Nardella <leon.nardella@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	farry.finger@lwfinger.net, Leon Nardella <leon.nardella@gmail.com>
Subject: [PATCH] ath9k_htc: Add new USB ID
Date: Sun, 22 Feb 2015 21:35:10 -0300
Message-Id: <1424651710-5196-1-git-send-email-leon.nardella@gmail.com> (sfid-20150223_013549_234864_6000362C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This device is a dongle made by Philips to enhance their TVs with wireless capabilities,
but works flawlessly on any upstream kernel, provided that the ath9k_htc module is attached to it.
It's correctly recognized by lsusb as "0471:209e Philips (or NXP) PTA01 Wireless Adapter" and the
patch has been tested on real hardware.

Signed-off-by: Leon Nardella <leon.nardella@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8e7153b..10c02f5 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -40,6 +40,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquiti WifiStation Ext */
 	{ USB_DEVICE(0x0cf3, 0xb002) }, /* Ubiquiti WifiStation */
 	{ USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
+	{ USB_DEVICE(0x0471, 0x209e) }, /* Philips (or NXP) PTA01 */
 
 	{ USB_DEVICE(0x0cf3, 0x7015),
 	  .driver_info = AR9287_USB },  /* Atheros */
-- 
2.1.0


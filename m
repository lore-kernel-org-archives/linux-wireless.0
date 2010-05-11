Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38200 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab0EKJT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 05:19:56 -0400
Received: by pwi5 with SMTP id 5so2120561pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 02:19:55 -0700 (PDT)
MIME-Version: 1.0
From: Steve Tanner <steve.tanner@gmail.com>
Date: Tue, 11 May 2010 02:19:35 -0700
Message-ID: <AANLkTilNQBE7zwSaNjcaHG4YPD_zfK63aepIzccWIdSj@mail.gmail.com>
Subject: [PATCH] ar9170usb:add vendor and device ID for Qwest/Actiontec 802AIN
	Wireless N USB Network Adapter
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* add support for the Qwest/Actiontec 802AIN Wireless N USB Network Adapter.

lsusb identifies the device as: "ID 1668:1200 Actiontec Electronics, Inc. [hex]"

usb_modeswitch package and appropriate rules are required to switch
the device from "ID 0ace:20ff ZyDas"

Changes-licensed-under: GPL
---
diff --git a/linux-source-2.6.32.orig/drivers/net/wireless/ath/ar9170/usb.c
b/linux-source-2.6.32/drivers/net/wireless/ath/ar9170/usb.c
index f141a4f..1070313 100644
--- a/linux-source-2.6.32.orig/drivers/net/wireless/ath/ar9170/usb.c
+++ b/linux-source-2.6.32/drivers/net/wireless/ath/ar9170/usb.c
@@ -94,6 +94,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
        { USB_DEVICE(0x057C, 0x8401) },
        /* AVM FRITZ!WLAN USB Stick N 2.4 */
        { USB_DEVICE(0x057C, 0x8402), .driver_info = AR9170_REQ_FW1_ONLY },
+       /* Qwest/Actiontec 802AIN Wireless N USB Network Adapter */
+       { USB_DEVICE(0x1668, 0x1200) },

        /* terminate */
        {}

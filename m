Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59787 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0EKVei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 17:34:38 -0400
Received: by pvh11 with SMTP id 11so48453pvh.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 14:34:37 -0700 (PDT)
MIME-Version: 1.0
From: Steve Tanner <steve.tanner@gmail.com>
Date: Tue, 11 May 2010 14:34:16 -0700
Message-ID: <AANLkTikc-ywwl9R1Sn4PMh_GkD3l8mS3POK-gTaYm6hs@mail.gmail.com>
Subject: [PATCH 2.6.32 1/1] ar9170usb: add vendor and device ID for
	Qwest/Actiontec 802AIN Wireless N USB Network Adapter
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
Signed-off-by: Steve Tanner <steve.tanner@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c
b/drivers/net/wireless/ath/ar9170/usb.c
index f141a4f..1070313 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -94,6 +94,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
        { USB_DEVICE(0x057C, 0x8401) },
        /* AVM FRITZ!WLAN USB Stick N 2.4 */
        { USB_DEVICE(0x057C, 0x8402), .driver_info = AR9170_REQ_FW1_ONLY },
+       /* Qwest/Actiontec 802AIN Wireless N USB Network Adapter */
+       { USB_DEVICE(0x1668, 0x1200) },

        /* terminate */
        {}

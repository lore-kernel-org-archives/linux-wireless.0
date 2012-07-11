Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8156 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GKTha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:37:30 -0400
Date: Wed, 11 Jul 2012 14:37:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Change buffer allocation for
 synchronous reads
Message-ID: <4ffdd5f8.5hRqOnoOvP9pdbc5%Larry.Finger@lwfinger.net> (sfid-20120711_213733_994243_172F93E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit a7959c1, the USB part of rtlwifi was switched to convert
_usb_read_sync() to using a preallocated buffer rather than one
that has been acquired using kmalloc. Although this routine is named
as though it were synchronous, there seem to be simultaneous users,
and the selection of the index to the data buffer is not multi-user
safe. This situation is addressed by adding a new spinlock. The routine
cannot sleep, thus a mutex is not allowed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

This patch needs to be applied to stable; however, I would prefer that it
resides in -next for a while, thus push it for 3.6.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -131,15 +131,19 @@ static u32 _usb_read_sync(struct rtl_pri
 	u8 request;
 	u16 wvalue;
 	u16 index;
-	__le32 *data = &rtlpriv->usb_data[rtlpriv->usb_data_index];
+	__le32 *data;
+	unsigned long flags;
 
+	spin_lock_irqsave(&rtlpriv->locks.usb_lock, flags);
+	if (++rtlpriv->usb_data_index >= RTL_USB_MAX_RX_COUNT)
+		rtlpriv->usb_data_index = 0;
+	data = &rtlpriv->usb_data[rtlpriv->usb_data_index];
+	spin_unlock_irqrestore(&rtlpriv->locks.usb_lock, flags);
 	request = REALTEK_USB_VENQT_CMD_REQ;
 	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
 
 	wvalue = (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	if (++rtlpriv->usb_data_index >= RTL_USB_MAX_RX_COUNT)
-		rtlpriv->usb_data_index = 0;
 	return le32_to_cpu(*data);
 }
 
@@ -951,6 +955,10 @@ int __devinit rtl_usb_probe(struct usb_i
 				    GFP_KERNEL);
 	if (!rtlpriv->usb_data)
 		return -ENOMEM;
+
+	/* this spin lock must be initialized early */
+	spin_lock_init(&rtlpriv->locks.usb_lock);
+
 	rtlpriv->usb_data_index = 0;
 	init_completion(&rtlpriv->firmware_loading_complete);
 	SET_IEEE80211_DEV(hw, &intf->dev);
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1555,6 +1555,7 @@ struct rtl_locks {
 	spinlock_t rf_ps_lock;
 	spinlock_t rf_lock;
 	spinlock_t waitq_lock;
+	spinlock_t usb_lock;
 
 	/*Dual mac*/
 	spinlock_t cck_and_rw_pagea_lock;


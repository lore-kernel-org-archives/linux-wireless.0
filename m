Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48279 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2GEVrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 17:47:03 -0400
Received: by yenl2 with SMTP id l2so7951673yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 14:47:03 -0700 (PDT)
Message-ID: <4FF60B53.4070603@lwfinger.net> (sfid-20120705_234708_685068_80969E72)
Date: Thu, 05 Jul 2012 16:46:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Moore <spasysheep@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: RTL8192CU / TRENDnet TEW-648UBM V1.1 USB Wireless
References: <CAJrANNJutyjAUPeQsLK4M30oe0PqArHJUVeJKUUJ6GExSEv6Eg@mail.gmail.com>
In-Reply-To: <CAJrANNJutyjAUPeQsLK4M30oe0PqArHJUVeJKUUJ6GExSEv6Eg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070602070007040105070706"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070602070007040105070706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/05/2012 04:34 PM, David Moore wrote:
> - TRENDware/TRENDnet TEW-648UBM V1.1 USB Wireless doesn't work properly
> - Driver (RTL8192CU) loads, device appears to work, but will not pick
> up most networks and will not connect to any. Fails with bad
> passphrase if connected through Wicd or DHCPCD times out waiting for
> carrier carrier if connected manually (WPA2-PSK)
> - Linux version 3.4.4-2-ARCH (tobias@T-POWA-LX) (gcc version 4.7.1
> (GCC) ) #1 SMP PREEMPT Sun Jun 24 18:59:47 CEST 2012
> - Recreated by trying to connect to wireless networks with TEW-648UBM V1.1
> - http://www.wikidevi.com/wiki/TRENDnet_TEW-648UBM
> - http://ubuntuforums.org/showthread.php?t=1667682

Does the attached patch help?

Larry




--------------070602070007040105070706
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_sequence_buffer"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_sequence_buffer"

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


--------------070602070007040105070706--

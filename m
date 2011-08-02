Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1HBVwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:52:36 -0400
Date: Tue, 02 Aug 2011 16:52:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: gentoo.lubomir@googlemail.com, s.L-H@gmx.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl892cu: New USB IDs
Message-ID: <4e3871a1.eNDdeH4ZkLsNMODL%Larry.Finger@lwfinger.net> (sfid-20110802_235239_845962_6E8D50F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes several problems in the USB_DEVICE table, including missing IDs,
reversed vendor/product codes, and a duplicate ID.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -281,6 +281,8 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817d, rtl92cu_hal_cfg)},
 	/* 8188CE-VAU USB minCard (b/g mode only) */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817e, rtl92cu_hal_cfg)},
+	/* 8188RU in Alfa AWUS036NHR */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
 	/* 8188 Combo for BC4 */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8754, rtl92cu_hal_cfg)},
 
@@ -303,20 +305,23 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	/* HP - Lite-On ,8188CUS Slim Combo */
 	{RTL_USB_DEVICE(0x103c, 0x1629, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(0x13d3, 0x3357, rtl92cu_hal_cfg)}, /* AzureWave */
 	{RTL_USB_DEVICE(0x2001, 0x3308, rtl92cu_hal_cfg)}, /*D-Link - Alpha*/
 	{RTL_USB_DEVICE(0x2019, 0xab2a, rtl92cu_hal_cfg)}, /*Planex - Abocom*/
 	{RTL_USB_DEVICE(0x2019, 0xed17, rtl92cu_hal_cfg)}, /*PCI - Edimax*/
 	{RTL_USB_DEVICE(0x20f4, 0x648b, rtl92cu_hal_cfg)}, /*TRENDnet - Cameo*/
 	{RTL_USB_DEVICE(0x7392, 0x7811, rtl92cu_hal_cfg)}, /*Edimax - Edimax*/
-	{RTL_USB_DEVICE(0x3358, 0x13d3, rtl92cu_hal_cfg)}, /*Azwave 8188CE-VAU*/
+	{RTL_USB_DEVICE(0x13d3, 0x3358, rtl92cu_hal_cfg)}, /*Azwave 8188CE-VAU*/
 	/* Russian customer -Azwave (8188CE-VAU  b/g mode only) */
-	{RTL_USB_DEVICE(0x3359, 0x13d3, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(0x13d3, 0x3359, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(0x4855, 0x0090, rtl92cu_hal_cfg)}, /* Feixun */
+	{RTL_USB_DEVICE(0x4855, 0x0091, rtl92cu_hal_cfg)}, /* NetweeN-Feixun */
+	{RTL_USB_DEVICE(0x9846, 0x9041, rtl92cu_hal_cfg)}, /* Netgear Cameo */
 
 	/****** 8192CU ********/
 	{RTL_USB_DEVICE(0x0586, 0x341f, rtl92cu_hal_cfg)}, /*Zyxel -Abocom*/
 	{RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
 	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
-	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Abocom -Abocom*/
 	{RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
 	{RTL_USB_DEVICE(0x2001, 0x3309, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1JRWvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 18:51:52 -0400
Date: Tue, 18 Oct 2011 17:52:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192cu: Add new device IDs
Message-ID: <4e9e0311.6XtUs05Yxq4ad0yi%Larry.Finger@lwfinger.net> (sfid-20111019_005206_287256_3F82F12E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest vendor (non-mac80211) driver of 9/22/2011 shows some new
device IDs for rtl8192cu. In addition, some typos in the table are
fixed and one duplicate is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -274,6 +274,8 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8191, rtl92cu_hal_cfg)},
 
 	/****** 8188CU ********/
+	/* RTL8188CTV */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x018a, rtl92cu_hal_cfg)},
 	/* 8188CE-VAU USB minCard */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8170, rtl92cu_hal_cfg)},
 	/* 8188cu 1*1 dongle */
@@ -290,14 +292,14 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817e, rtl92cu_hal_cfg)},
 	/* 8188RU in Alfa AWUS036NHR */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
+	/* RTL8188CUS-VL */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x818a, rtl92cu_hal_cfg)},
 	/* 8188 Combo for BC4 */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8754, rtl92cu_hal_cfg)},
 
 	/****** 8192CU ********/
-	/* 8191cu 1*2 */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8177, rtl92cu_hal_cfg)},
 	/* 8192cu 2*2 */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817b, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8178, rtl92cu_hal_cfg)},
 	/* 8192CE-VAU USB minCard */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817c, rtl92cu_hal_cfg)},
 
@@ -308,13 +310,17 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
-	{RTL_USB_DEVICE(0x0Df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	/* HP - Lite-On ,8188CUS Slim Combo */
 	{RTL_USB_DEVICE(0x103c, 0x1629, rtl92cu_hal_cfg)},
 	{RTL_USB_DEVICE(0x13d3, 0x3357, rtl92cu_hal_cfg)}, /* AzureWave */
 	{RTL_USB_DEVICE(0x2001, 0x3308, rtl92cu_hal_cfg)}, /*D-Link - Alpha*/
+	{RTL_USB_DEVICE(0x2019, 0x4902, rtl92cu_hal_cfg)}, /*Planex - Etop*/
 	{RTL_USB_DEVICE(0x2019, 0xab2a, rtl92cu_hal_cfg)}, /*Planex - Abocom*/
+	/*SW-WF02-AD15 -Abocom*/
+	{RTL_USB_DEVICE(0x2019, 0xab2e, rtl92cu_hal_cfg)},
 	{RTL_USB_DEVICE(0x2019, 0xed17, rtl92cu_hal_cfg)}, /*PCI - Edimax*/
 	{RTL_USB_DEVICE(0x20f4, 0x648b, rtl92cu_hal_cfg)}, /*TRENDnet - Cameo*/
 	{RTL_USB_DEVICE(0x7392, 0x7811, rtl92cu_hal_cfg)}, /*Edimax - Edimax*/
@@ -325,14 +331,36 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x4855, 0x0091, rtl92cu_hal_cfg)}, /* NetweeN-Feixun */
 	{RTL_USB_DEVICE(0x9846, 0x9041, rtl92cu_hal_cfg)}, /* Netgear Cameo */
 
+	/****** 8188 RU ********/
+	/* Netcore */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x317f, rtl92cu_hal_cfg)},
+
+	/****** 8188CUS Slim Solo********/
+	{RTL_USB_DEVICE(0x04f2, 0xaff7, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaff9, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaffa, rtl92cu_hal_cfg)}, /*Xavi*/
+
+	/****** 8188CUS Slim Combo ********/
+	{RTL_USB_DEVICE(0x04f2, 0xaff8, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaffb, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaffc, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x2019, 0x1201, rtl92cu_hal_cfg)}, /*Planex-Vencer*/
+
 	/****** 8192CU ********/
+	{RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)}, /*Belcom-Sercomm*/
+	{RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)}, /*Belcom-Edimax*/
 	{RTL_USB_DEVICE(0x0586, 0x341f, rtl92cu_hal_cfg)}, /*Zyxel -Abocom*/
 	{RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
 	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
+	{RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
+	{RTL_USB_DEVICE(0x0b05, 0x17ab, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0061, rtl92cu_hal_cfg)}, /*Sitecom-Edimax*/
+	{RTL_USB_DEVICE(0x0e66, 0x0019, rtl92cu_hal_cfg)}, /*Hawking-Edimax*/
 	{RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
 	{RTL_USB_DEVICE(0x2001, 0x3309, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
+	{RTL_USB_DEVICE(0x20f4, 0x624d, rtl92cu_hal_cfg)}, /*TRENDNet*/
 	{RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
 	{}
 };

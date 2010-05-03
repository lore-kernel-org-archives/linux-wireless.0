Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:40902 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab0ECLLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 07:11:53 -0400
Received: by fg-out-1718.google.com with SMTP id d23so997606fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 04:11:52 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com, xose.vazquez@gmail.com
Subject: [PATCH 1/1] wireless: rt2x00: rt2800usb: be in sync with latest windows drivers.
Date: Mon,  3 May 2010 13:11:38 +0200
Message-Id: <1272885098-6836-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0x07d1,0x3c17 D-Link Wireless N 150 USB Adapter DWA-125
0x1b75,0x3071 Ovislink Airlive WN-301USB
0x1d4d,0x0011 Pegatron Ralink RT3072 802.11b/g/n Wireless Lan USB Device
0x083a,0xf511 Arcadyan 802.11 USB Wireless LAN Card
0x13d3,0x3322 AzureWave 802.11 n/g/b USB Wireless LAN Card

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 95c8a61..df82b52 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1027,7 +1027,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
 	 * Unclear what kind of devices these are (they aren't supported by the
-	 * vendor driver).
+	 * vendor linux driver).
 	 */
 	/* Amigo */
 	{ USB_DEVICE(0x0e0b, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -1040,6 +1040,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3284), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x13d3, 0x3322), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x825a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Buffalo */
@@ -1058,6 +1059,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c0b), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c13), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c15), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c17), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Gemtek */
@@ -1074,11 +1076,13 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Motorola */
 	{ USB_DEVICE(0x100d, 0x9032), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ovislink */
+	{ USB_DEVICE(0x1b75, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1b75, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Pegatron */
 	{ USB_DEVICE(0x05a6, 0x0101), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x0002), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1d4d, 0x0011), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab24), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Qcom */
@@ -1087,6 +1091,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x083a, 0xa512), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xc522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xd522), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0xf511), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sweex */
 	{ USB_DEVICE(0x177f, 0x0153), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x177f, 0x0313), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.6.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXIAEfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:12 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 53A5C618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:12 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 10/35] Add minimal support to 505AMX
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:11 -0400
Message-ID: <20070901043511.2498.30700.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use inline functions for board classification.  Drop "_2958" from
BOARD_505A_2958, it's implied.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   65 +++++++++++++++++++--------------------
 drivers/net/wireless/at76_usb.h |    2 +
 2 files changed, 32 insertions(+), 35 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 41f28dc..206fa90 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -56,7 +56,7 @@ static struct fwentry firmwares[] = {
 	[BOARD_503_ACC] = {"atmel_at76c503-rfmd-acc.bin"},
 	[BOARD_505] = {"atmel_at76c505-rfmd.bin"},
 	[BOARD_505_2958] = {"atmel_at76c505-rfmd2958.bin"},
-	[BOARD_505A_2958] = {"atmel_at76c505a-rfmd2958.bin"},
+	[BOARD_505A] = {"atmel_at76c505a-rfmd2958.bin"},
 	[BOARD_505AMX] = {"atmel_at76c505amx-rfmd.bin"},
 };
 
@@ -171,11 +171,11 @@ static struct usb_device_id dev_table[] = {
 	 * at76c505a-rfmd2958
 	 */
 	/* Generic AT76C505A device */
-	{USB_DEVICE(VID_ATMEL, 0x7614), .driver_info = BOARD_505A_2958},
+	{USB_DEVICE(VID_ATMEL, 0x7614), .driver_info = BOARD_505A},
 	/* Generic AT76C505AS device */
-	{USB_DEVICE(VID_ATMEL, 0x7617), .driver_info = BOARD_505A_2958},
+	{USB_DEVICE(VID_ATMEL, 0x7617), .driver_info = BOARD_505A},
 	/* Siemens Gigaset USB WLAN Adapter 11 */
-	{USB_DEVICE(VID_GIGASET, 0x0701), .driver_info = BOARD_505A_2958},
+	{USB_DEVICE(VID_GIGASET, 0x0701), .driver_info = BOARD_505A},
 	/*
 	 * at76c505amx-rfmd
 	 */
@@ -241,6 +241,21 @@ struct dfu_status {
 	unsigned char string;
 } __attribute__((packed));
 
+static inline int at76_is_intersil(enum board_type board)
+{
+	return (board == BOARD_503_ISL3861 || board == BOARD_503_ISL3863);
+}
+
+static inline int at76_is_503rfmd(enum board_type board)
+{
+	return (board == BOARD_503 || board == BOARD_503_ACC);
+}
+
+static inline int at76_is_505a(enum board_type board)
+{
+	return (board == BOARD_505A || board == BOARD_505AMX);
+}
+
 /* Load a block of the first (internal) part of the firmware */
 static int at76_load_int_fw_block(struct usb_device *udev, int blockno,
 				  void *block, int size)
@@ -618,45 +633,29 @@ static int at76_get_hw_config(struct at76_priv *priv)
 	if (!hwcfg)
 		return -ENOMEM;
 
-	switch (priv->board_type) {
-
-	case BOARD_503_ISL3861:
-	case BOARD_503_ISL3863:
+	if (at76_is_intersil(priv->board_type)) {
 		ret = at76_get_hw_cfg_intersil(priv->udev, hwcfg,
 					       sizeof(hwcfg->i));
 		if (ret < 0)
-			break;
+			goto exit;
 		memcpy(priv->mac_addr, hwcfg->i.mac_addr, ETH_ALEN);
 		priv->regulatory_domain = hwcfg->i.regulatory_domain;
-		break;
-
-	case BOARD_503:
-	case BOARD_503_ACC:
+	} else if (at76_is_503rfmd(priv->board_type)) {
 		ret = at76_get_hw_cfg(priv->udev, hwcfg, sizeof(hwcfg->r3));
 		if (ret < 0)
-			break;
+			goto exit;
 		memcpy(priv->mac_addr, hwcfg->r3.mac_addr, ETH_ALEN);
 		priv->regulatory_domain = hwcfg->r3.regulatory_domain;
-		break;
-
-	case BOARD_505:
-	case BOARD_505_2958:
-	case BOARD_505A_2958:
+	} else {
 		ret = at76_get_hw_cfg(priv->udev, hwcfg, sizeof(hwcfg->r5));
 		if (ret < 0)
-			break;
+			goto exit;
 		memcpy(priv->mac_addr, hwcfg->r5.mac_addr, ETH_ALEN);
 		priv->regulatory_domain = hwcfg->r5.regulatory_domain;
-		break;
-
-	default:
-		err("Bad board type set (%d).  Unable to get hardware config.",
-		    priv->board_type);
-		ret = -EINVAL;
 	}
 
+exit:
 	kfree(hwcfg);
-
 	if (ret < 0)
 		err("Get HW Config failed (%d)", ret);
 
@@ -2445,8 +2444,7 @@ static int at76_iw_handler_get_scan(struct net_device *netdev,
 		iwe->u.qual.level = (curr_bss->rssi * 100 / 42);
 		if (iwe->u.qual.level > 100)
 			iwe->u.qual.level = 100;
-		if ((priv->board_type == BOARD_503_ISL3861) ||
-		    (priv->board_type == BOARD_503_ISL3863))
+		if (at76_is_intersil(priv->board_type))
 			iwe->u.qual.qual = curr_bss->link_qual;
 		else {
 			iwe->u.qual.qual = 0;
@@ -3596,8 +3594,8 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 		blockno++;
 	} while (bsize > 0);
 
-	if (fwe->board_type == BOARD_505A_2958) {
-		at76_dbg(DBG_DEVSTART, "200 ms delay for board type 7");
+	if (at76_is_505a(fwe->board_type)) {
+		at76_dbg(DBG_DEVSTART, "200 ms delay for 505a");
 		schedule_timeout_interruptible(HZ / 5 + 1);
 	}
 
@@ -3612,7 +3610,7 @@ exit:
 static int at76_load_internal_fw(struct usb_device *udev, struct fwentry *fwe)
 {
 	int ret;
-	int need_remap = (fwe->board_type != BOARD_505A_2958);
+	int need_remap = !at76_is_505a(fwe->board_type);
 
 	ret = at76_usbdfu_download(udev, fwe->intfw, fwe->intfw_size,
 				   need_remap ? 0 : 2000);
@@ -4688,8 +4686,7 @@ static void at76_calc_level(struct at76_priv *priv, struct at76_rx_buffer *buf,
 static void at76_calc_qual(struct at76_priv *priv, struct at76_rx_buffer *buf,
 			   struct iw_quality *qual)
 {
-	if ((priv->board_type == BOARD_503_ISL3861) ||
-	    (priv->board_type == BOARD_503_ISL3863))
+	if (at76_is_intersil(priv->board_type))
 		qual->qual = buf->link_quality;
 	else {
 		unsigned long msec;
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 71b7c22..fbae175 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -70,7 +70,7 @@ enum board_type {
 	BOARD_503_ACC = 4,
 	BOARD_505 = 5,
 	BOARD_505_2958 = 6,
-	BOARD_505A_2958 = 7,
+	BOARD_505A = 7,
 	BOARD_505AMX = 8
 };
 

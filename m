Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:44332 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbYGDDer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 23:34:47 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: luisca@cozybit.com
Subject: [PATCH] zd1211rw: beacon config error checking
Message-Id: <20080704033050.25C1A72C001@zog.reactivated.net> (sfid-20080704_053452_947519_5BCE709F)
Date: Fri,  4 Jul 2008 04:30:49 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some error checking to the new beacon configuration code.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

Index: linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/net/wireless/zd1211rw/zd_mac.c
+++ linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -475,43 +475,66 @@ static void cs_set_control(struct zd_mac
 	/* FIXME: Management frame? */
 }
 
-void zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
+static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
+	int r;
 	u32 tmp, j = 0;
 	/* 4 more bytes for tail CRC */
 	u32 full_len = beacon->len + 4;
-	zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 0);
-	zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+
+	r = zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 0);
+	if (r < 0)
+		return r;
+	r = zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+	if (r < 0)
+		return r;
+
 	while (tmp & 0x2) {
-		zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+		r = zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+		if (r < 0)
+			return r;
 		if ((++j % 100) == 0) {
 			printk(KERN_ERR "CR_BCN_FIFO_SEMAPHORE not ready\n");
 			if (j >= 500)  {
 				printk(KERN_ERR "Giving up beacon config.\n");
-				return;
+				return -ETIMEDOUT;
 			}
 		}
 		msleep(1);
 	}
 
-	zd_iowrite32(&mac->chip, CR_BCN_FIFO, full_len - 1);
-	if (zd_chip_is_zd1211b(&mac->chip))
-		zd_iowrite32(&mac->chip, CR_BCN_LENGTH, full_len - 1);
+	r = zd_iowrite32(&mac->chip, CR_BCN_FIFO, full_len - 1);
+	if (r < 0)
+		return r;
+	if (zd_chip_is_zd1211b(&mac->chip)) {
+		r = zd_iowrite32(&mac->chip, CR_BCN_LENGTH, full_len - 1);
+		if (r < 0)
+			return r;
+	}
 
-	for (j = 0 ; j < beacon->len; j++)
-		zd_iowrite32(&mac->chip, CR_BCN_FIFO,
+	for (j = 0 ; j < beacon->len; j++) {
+		r = zd_iowrite32(&mac->chip, CR_BCN_FIFO,
 				*((u8 *)(beacon->data + j)));
+		if (r < 0)
+			return r;
+	}
 
-	for (j = 0; j < 4; j++)
-		zd_iowrite32(&mac->chip, CR_BCN_FIFO, 0x0);
+	for (j = 0; j < 4; j++) {
+		r = zd_iowrite32(&mac->chip, CR_BCN_FIFO, 0x0);
+		if (r < 0)
+			return r;
+	}
+
+	r = zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 1);
+	if (r < 0)
+		return r;
 
-	zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 1);
 	/* 802.11b/g 2.4G CCK 1Mb
 	 * 802.11a, not yet implemented, uses different values (see GPL vendor
 	 * driver)
 	 */
-	zd_iowrite32(&mac->chip, CR_BCN_PLCP_CFG, 0x00000400 |
+	return zd_iowrite32(&mac->chip, CR_BCN_PLCP_CFG, 0x00000400 |
 			(full_len << 19));
 }
 
@@ -780,14 +803,19 @@ static int zd_op_config_interface(struct
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	int associated;
+	int r;
 
 	if (mac->type == IEEE80211_IF_TYPE_MESH_POINT) {
 		associated = true;
 		if (conf->beacon) {
-			zd_mac_config_beacon(hw, conf->beacon);
-			kfree_skb(conf->beacon);
-			zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS |
+			r = zd_mac_config_beacon(hw, conf->beacon);
+			if (r < 0)
+				return r;
+			r = zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS |
 					hw->conf.beacon_int);
+			if (r < 0)
+				return r;
+			kfree_skb(conf->beacon);
 		}
 	} else
 		associated = is_valid_ether_addr(conf->bssid);

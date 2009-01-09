Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:51226 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZAIUFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:05:35 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] p54: refactor p54_alloc_skb
Date: Fri, 9 Jan 2009 21:05:31 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901092105.31722.chunkeey@web.de> (sfid-20090109_210549_301019_2E384CD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Old firmwares had no problems processing frames which filled eighth of the memory window.
However we have to be a bit more careful with fat frames when we talk to new firmwares.
Apart from that, I confess the old logic was a bit weird and not very sophisticated. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-01-08 21:04:43.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-01-09 19:12:47.000000000 +0100
@@ -1080,25 +1080,29 @@ static int p54_assign_address(struct iee
 	return 0;
 }
 
-static struct sk_buff *p54_alloc_skb(struct ieee80211_hw *dev,
-		u16 hdr_flags, u16 len, u16 type, gfp_t memflags)
+static struct sk_buff *p54_alloc_skb(struct ieee80211_hw *dev, u16 hdr_flags,
+				     u16 payload_len, u16 type, gfp_t memflags)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr;
 	struct sk_buff *skb;
+	size_t frame_len = sizeof(*hdr) + payload_len;
 
-	skb = __dev_alloc_skb(len + priv->tx_hdr_len, memflags);
+	if (frame_len > P54_MAX_CTRL_FRAME_LEN)
+		return NULL;
+
+	skb = __dev_alloc_skb(priv->tx_hdr_len + frame_len, memflags);
 	if (!skb)
 		return NULL;
 	skb_reserve(skb, priv->tx_hdr_len);
 
 	hdr = (struct p54_hdr *) skb_put(skb, sizeof(*hdr));
 	hdr->flags = cpu_to_le16(hdr_flags);
-	hdr->len = cpu_to_le16(len - sizeof(*hdr));
+	hdr->len = cpu_to_le16(payload_len);
 	hdr->type = cpu_to_le16(type);
 	hdr->tries = hdr->rts_tries = 0;
 
-	if (unlikely(p54_assign_address(dev, skb, hdr, len))) {
+	if (p54_assign_address(dev, skb, hdr, frame_len)) {
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -1108,7 +1112,6 @@ static struct sk_buff *p54_alloc_skb(str
 int p54_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
-	struct p54_hdr *hdr = NULL;
 	struct p54_eeprom_lm86 *eeprom_hdr;
 	struct sk_buff *skb;
 	size_t eeprom_size = 0x2020, offset = 0, blocksize, maxblocksize;
@@ -1121,9 +1124,9 @@ int p54_read_eeprom(struct ieee80211_hw 
 	else
 		maxblocksize -= 0x4;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL, sizeof(*hdr) +
-			    sizeof(*eeprom_hdr) + maxblocksize,
-			    P54_CONTROL_TYPE_EEPROM_READBACK, GFP_KERNEL);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL, sizeof(*eeprom_hdr) +
+			    maxblocksize, P54_CONTROL_TYPE_EEPROM_READBACK,
+			    GFP_KERNEL);
 	if (!skb)
 		goto free;
 	priv->eeprom = kzalloc(EEPROM_READBACK_LEN, GFP_KERNEL);
@@ -1179,9 +1182,8 @@ static int p54_set_tim(struct ieee80211_
 	struct sk_buff *skb;
 	struct p54_tim *tim;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
-		      sizeof(struct p54_hdr) + sizeof(*tim),
-		      P54_CONTROL_TYPE_TIM, GFP_KERNEL);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*tim),
+			    P54_CONTROL_TYPE_TIM, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1198,9 +1200,8 @@ static int p54_sta_unlock(struct ieee802
 	struct sk_buff *skb;
 	struct p54_sta_unlock *sta;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
-		sizeof(struct p54_hdr) + sizeof(*sta),
-		P54_CONTROL_TYPE_PSM_STA_UNLOCK, GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*sta),
+			    P54_CONTROL_TYPE_PSM_STA_UNLOCK, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1240,9 +1241,8 @@ static int p54_tx_cancel(struct ieee8021
 	struct p54_hdr *hdr;
 	struct p54_txcancel *cancel;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
-		sizeof(struct p54_hdr) + sizeof(*cancel),
-		P54_CONTROL_TYPE_TXCANCEL, GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*cancel),
+			    P54_CONTROL_TYPE_TXCANCEL, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1524,9 +1524,8 @@ static int p54_setup_mac(struct ieee8021
 	struct p54_setup_mac *setup;
 	u16 mode;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*setup) +
-			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SETUP,
-			    GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*setup),
+			    P54_CONTROL_TYPE_SETUP, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1604,9 +1603,8 @@ static int p54_scan(struct ieee80211_hw 
 	__le16 freq = cpu_to_le16(dev->conf.channel->center_freq);
 	int band = dev->conf.channel->band;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*chan) +
-			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SCAN,
-			    GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*chan),
+			    P54_CONTROL_TYPE_SCAN, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1686,9 +1684,8 @@ static int p54_set_leds(struct ieee80211
 	struct sk_buff *skb;
 	struct p54_led *led;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*led) +
-			sizeof(struct p54_hdr),	P54_CONTROL_TYPE_LED,
-			GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*led),
+			    P54_CONTROL_TYPE_LED, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1715,9 +1712,8 @@ static int p54_set_edcf(struct ieee80211
 	struct sk_buff *skb;
 	struct p54_edcf *edcf;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*edcf) +
-			sizeof(struct p54_hdr), P54_CONTROL_TYPE_DCFINIT,
-			GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*edcf),
+			    P54_CONTROL_TYPE_DCFINIT, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -1754,9 +1750,8 @@ static int p54_set_ps(struct ieee80211_h
 	else
 		mode = P54_PSM_CAM;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*psm) +
-			sizeof(struct p54_hdr), P54_CONTROL_TYPE_PSM,
-			GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*psm),
+			    P54_CONTROL_TYPE_PSM, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -2059,10 +2054,8 @@ static int p54_init_xbow_synth(struct ie
 	struct sk_buff *skb;
 	struct p54_xbow_synth *xbow;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*xbow) +
-			    sizeof(struct p54_hdr),
-			    P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
-			    GFP_KERNEL);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*xbow),
+			    P54_CONTROL_TYPE_XBOW_SYNTH_CFG, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
@@ -2091,7 +2084,7 @@ static void p54_work(struct work_struct 
 	 *      2. cancel stuck frames / reset the device if necessary.
 	 */
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL, sizeof(struct p54_hdr) +
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL,
 			    sizeof(struct p54_statistics),
 			    P54_CONTROL_TYPE_STAT_READBACK, GFP_KERNEL);
 	if (!skb)
@@ -2202,9 +2195,8 @@ static int p54_set_key(struct ieee80211_
 	}
 
 	mutex_lock(&priv->conf_mutex);
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*rxkey) +
-			sizeof(struct p54_hdr),	P54_CONTROL_TYPE_RX_KEYCACHE,
-			GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*rxkey),
+			    P54_CONTROL_TYPE_RX_KEYCACHE, GFP_ATOMIC);
 	if (!skb) {
 		mutex_unlock(&priv->conf_mutex);
 		return -ENOMEM;
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2009-01-08 21:04:43.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2009-01-09 15:29:36.000000000 +0100
@@ -44,6 +44,8 @@ enum p54_control_frame_types {
 	P54_CONTROL_TYPE_BT_OPTIONS = 35
 };
 
+#define P54_MAX_CTRL_FRAME_LEN		0x1000
+
 #define P54_HDR_FLAG_CONTROL		BIT(15)
 #define P54_HDR_FLAG_CONTROL_OPSET	(BIT(15) + BIT(0))
 

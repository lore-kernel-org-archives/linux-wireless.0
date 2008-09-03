Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:50097 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbYICUWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 16:22:23 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: set_filter refactoring
Date: Wed, 3 Sep 2008 22:25:20 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809032225.21224.chunkeey@web.de> (sfid-20080903_222237_144590_097EFF6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54_set_filter has a way too many unnecessary "magic" parameters and values.
This patch axes all superfluous parameters and gives most of the magic values appropriate names. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-02 21:29:47.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-03 20:29:27.000000000 +0200
@@ -788,8 +788,7 @@ static int p54_tx(struct ieee80211_hw *d
 }
 
 static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
-			  const u8 *dst, const u8 *src, u8 antenna,
-			  u32 magic3, u32 magic8, u32 magic9)
+			  const u8 *bssid)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
@@ -808,19 +807,19 @@ static int p54_set_filter(struct ieee802
 	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*filter));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_FILTER_SET);
 
-	filter->filter_type = cpu_to_le16(filter_type);
-	memcpy(filter->dst, dst, ETH_ALEN);
-	if (!src)
-		memset(filter->src, ~0, ETH_ALEN);
+	priv->filter_type = filter->filter_type = cpu_to_le16(filter_type);
+	memcpy(filter->mac_addr, priv->mac_addr, ETH_ALEN);
+	if (!bssid)
+		memset(filter->bssid, ~0, ETH_ALEN);
 	else
-		memcpy(filter->src, src, ETH_ALEN);
-	filter->antenna = antenna;
-	filter->magic3 = cpu_to_le32(magic3);
+		memcpy(filter->bssid, bssid, ETH_ALEN);
+
+	filter->rx_antenna = priv->rx_antenna;
+	filter->basic_rate_mask = cpu_to_le32(0x15F);
 	filter->rx_addr = cpu_to_le32(priv->rx_end);
 	filter->max_rx = cpu_to_le16(priv->rx_mtu);
 	filter->rxhw = cpu_to_le16(priv->rxhw);
-	filter->magic8 = cpu_to_le16(magic8);
-	filter->magic9 = cpu_to_le16(magic9);
+	filter->wakeup_timer = cpu_to_le16(500);
 
 	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*filter), 1);
 	return 0;
@@ -1046,12 +1045,11 @@ static int p54_add_interface(struct ieee
 
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 1, 0, 0, 0xF642);
+	p54_set_filter(dev, 0, NULL);
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
-		p54_set_filter(dev, 1, priv->mac_addr, NULL, 0, 0x15F, 0x1F4, 0);
+		p54_set_filter(dev, 1, NULL);
 		break;
 	default:
 		BUG();	/* impossible */
@@ -1069,7 +1067,7 @@ static void p54_remove_interface(struct 
 	struct p54_common *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_set_filter(dev, 0, priv->mac_addr, NULL, 2, 0, 0, 0);
+	p54_set_filter(dev, 0, NULL);
 }
 
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -1078,6 +1076,8 @@ static int p54_config(struct ieee80211_h
 	struct p54_common *priv = dev->priv;
 
 	mutex_lock(&priv->conf_mutex);
+	priv->rx_antenna = (conf->antenna_sel_rx == 0) ?
+		2 : conf->antenna_sel_tx - 1;
 	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
 	p54_set_vdcf(dev);
 	mutex_unlock(&priv->conf_mutex);
@@ -1091,8 +1091,7 @@ static int p54_config_interface(struct i
 	struct p54_common *priv = dev->priv;
 
 	mutex_lock(&priv->conf_mutex);
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 0, 1, 0, 0xF642);
-	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 2, 0, 0, 0);
+	p54_set_filter(dev, 0, conf->bssid);
 	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 	mutex_unlock(&priv->conf_mutex);
@@ -1110,11 +1109,9 @@ static void p54_configure_filter(struct 
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_set_filter(dev, 0, priv->mac_addr,
-				       NULL, 2, 0, 0, 0);
+			p54_set_filter(dev, 0, NULL);
 		else
-			p54_set_filter(dev, 0, priv->mac_addr,
-				       priv->bssid, 2, 0, 0, 0);
+			p54_set_filter(dev, 0, priv->bssid);
 	}
 }
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-02 19:39:10.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-09-03 20:17:51.000000000 +0200
@@ -214,17 +214,17 @@ struct p54_tx_control_allocdata {
 
 struct p54_tx_control_filter {
 	__le16 filter_type;
-	u8 dst[ETH_ALEN];
-	u8 src[ETH_ALEN];
-	u8 antenna;
-	u8 debug;
-	__le32 magic3;
-	u8 rates[8];	// FIXME: what's this for?
+	u8 mac_addr[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
+	u8 rx_antenna;
+	u8 rx_align;
+	__le32 basic_rate_mask;
+	u8 rts_rates[8];
 	__le32 rx_addr;
 	__le16 max_rx;
 	__le16 rxhw;
-	__le16 magic8;
-	__le16 magic9;
+	__le16 wakeup_timer;
+	__le16 unalloc;
 } __attribute__ ((packed));
 
 struct p54_tx_control_channel {
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-02 19:39:26.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-03 20:28:20.000000000 +0200
@@ -63,6 +63,7 @@ struct p54_common {
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
+	__le16 filter_type;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
 	struct pda_channel_output_limit *output_limit;
@@ -70,6 +71,7 @@ struct p54_common {
 	struct pda_pa_curve_data *curve_data;
 	u16 rxhw;
 	u8 version;
+	u8 rx_antenna;
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;


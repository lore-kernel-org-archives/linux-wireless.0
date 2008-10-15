Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39851 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYJOCDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 22:03:46 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] p54: borrow some setup code from stlc45xx
Date: Wed, 15 Oct 2008 04:07:56 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810150407.56189.chunkeey@web.de> (sfid-20081015_040350_719536_488CE00C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch initialize all remaining values which are necessary for SPI firmwares.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-15 02:39:03.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-15 03:04:38.000000000 +0200
@@ -1018,43 +1018,48 @@ static int p54_tx(struct ieee80211_hw *d
 	return 0;
 }
 
-static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
-			  const u8 *bssid)
+static int p54_setup_mac(struct ieee80211_hw *dev, u16 mode, const u8 *bssid)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	struct p54_tx_control_filter *filter;
-	u16 data_len = sizeof(struct p54_control_hdr) + sizeof(*filter);
+	struct p54_setup_mac *setup;
 
-	if (priv->fw_var < 0x500)
-		data_len += P54_TX_CONTROL_FILTER_V1_LEN;
-	else
-		data_len += P54_TX_CONTROL_FILTER_V2_LEN;
-
-	skb = p54_alloc_skb(dev, 0x8001, data_len, P54_CONTROL_TYPE_FILTER_SET,
+	skb = p54_alloc_skb(dev, 0x8001, sizeof(struct p54_tx_control_hdr) +
+			    sizeof(*setup), P54_CONTROL_TYPE_SETUP,
 			    GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
-	filter = (struct p54_tx_control_filter *) skb_put(skb, sizeof(*filter));
-	filter->filter_type = priv->filter_type = cpu_to_le16(filter_type);
-	memcpy(filter->mac_addr, priv->mac_addr, ETH_ALEN);
+	setup = (struct p54_tx_control_filter *) skb_put(skb, sizeof(*filter));
+	priv->mac_mode = mode;
+	setup->mac_mode = cpu_to_le16(mode);
+	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
 	if (!bssid)
-		memset(filter->bssid, ~0, ETH_ALEN);
+		memset(setup->bssid, ~0, ETH_ALEN);
 	else
-		memcpy(filter->bssid, bssid, ETH_ALEN);
-	filter->rx_antenna = priv->rx_antenna;
+		memcpy(setup->bssid, bssid, ETH_ALEN);
+	setup->rx_antenna = priv->rx_antenna;
 	if (priv->fw_var < 0x500) {
-		filter->v1.basic_rate_mask = cpu_to_le32(0x15f);
-		filter->v1.rx_addr = cpu_to_le32(priv->rx_end);
-		filter->v1.max_rx = cpu_to_le16(priv->rx_mtu);
-		filter->v1.rxhw = cpu_to_le16(priv->rxhw);
-		filter->v1.wakeup_timer = cpu_to_le16(500);
+		setup->v1.basic_rate_mask = cpu_to_le32(0x15f);
+		setup->v1.rx_addr = cpu_to_le32(priv->rx_end);
+		setup->v1.max_rx = cpu_to_le16(priv->rx_mtu);
+		setup->v1.rxhw = cpu_to_le16(priv->rxhw);
+		setup->v1.wakeup_timer = cpu_to_le16(500);
+		setup->v1.unalloc0 = cpu_to_le16(0);
 	} else {
-		filter->v2.rx_addr = cpu_to_le32(priv->rx_end);
-		filter->v2.max_rx = cpu_to_le16(priv->rx_mtu);
-		filter->v2.rxhw = cpu_to_le16(priv->rxhw);
-		filter->v2.timer = cpu_to_le16(1000);
+		setup->v2.rx_addr = cpu_to_le32(priv->rx_end);
+		setup->v2.max_rx = cpu_to_le16(priv->rx_mtu);
+		setup->v2.rxhw = cpu_to_le16(priv->rxhw);
+		setup->v2.timer = cpu_to_le16(1000);
+		setup->v2.truncate = cpu_to_le16(48896);
+		setup->v2.basic_rate_mask = cpu_to_le32(0x15f);
+		setup->v2.sbss_offset = 0;
+		setup->v2.mcast_window = 0;
+		setup->v2.rx_rssi_threshold = 0;
+		setup->v2.rx_ed_threshold = 0;
+		setup->v2.ref_clock = cpu_to_le32(644245094);
+		setup->v2.lpf_bandwidth = cpu_to_le16(65535);
+		setup->v2.osc_start_delay = cpu_to_le16(65535);
 	}
 	priv->tx(dev, skb, 1);
 	return 0;
@@ -1272,11 +1277,11 @@ static int p54_add_interface(struct ieee
 
 	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 
-	p54_set_filter(dev, 0, NULL);
+	p54_setup_mac(dev, 0, NULL);
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
-		p54_set_filter(dev, 1, NULL);
+		p54_setup_mac(dev, 1, NULL);
 		break;
 	default:
 		BUG();	/* impossible */
@@ -1294,7 +1299,7 @@ static void p54_remove_interface(struct 
 	struct p54_common *priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
-	p54_set_filter(dev, 0, NULL);
+	p54_setup_mac(dev, 0, NULL);
 }
 
 static int p54_config(struct ieee80211_hw *dev, u32 changed)
@@ -1320,7 +1325,7 @@ static int p54_config_interface(struct i
 	struct p54_common *priv = dev->priv;
 
 	mutex_lock(&priv->conf_mutex);
-	p54_set_filter(dev, 0, conf->bssid);
+	p54_setup_mac(dev, 0, conf->bssid);
 	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 	mutex_unlock(&priv->conf_mutex);
@@ -1342,20 +1347,16 @@ static void p54_configure_filter(struct 
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type),
-				 NULL);
+			p54_setup_mac(dev, priv->mac_mode, NULL);
 		else
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type),
-				 priv->bssid);
+			p54_setup_mac(dev, priv->mac_mode, priv->bssid);
 	}
 
 	if (changed_flags & FIF_PROMISC_IN_BSS) {
 		if (*total_flags & FIF_PROMISC_IN_BSS)
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type) |
-				0x8, NULL);
+			p54_setup_mac(dev, priv->mac_mode | 0x8, NULL);
 		else
-			p54_set_filter(dev, le16_to_cpu(priv->filter_type) &
-				~0x8, priv->bssid);
+			p54_setup_mac(dev, priv->mac_mode & ~0x8, priv->bssid);
 	}
 }
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-10-14 22:24:00.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-10-15 02:22:59.000000000 +0200
@@ -219,8 +219,8 @@ struct p54_tx_control_allocdata {
 	u8 align[0];
 } __attribute__ ((packed));
 
-struct p54_tx_control_filter {
-	__le16 filter_type;
+struct p54_setup_mac {
+	__le16 mac_mode;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	u8 rx_antenna;
@@ -240,15 +240,19 @@ struct p54_tx_control_filter {
 			__le16 max_rx;
 			__le16 rxhw;
 			__le16 timer;
-			__le16 unalloc0;
-			__le32 unalloc1;
+			__le16 truncate;
+			__le32 basic_rate_mask;
+			u8 sbss_offset;
+			u8 mcast_window;
+			u8 rx_rssi_threshold;
+			u8 rx_ed_threshold;
+			__le32 ref_clock;
+			__le16 lpf_bandwidth;
+			__le16 osc_start_delay;
 		} v2 __attribute__ ((packed));
 	} __attribute__ ((packed));
 } __attribute__ ((packed));
 
-#define P54_TX_CONTROL_FILTER_V1_LEN (sizeof(struct p54_tx_control_filter))
-#define P54_TX_CONTROL_FILTER_V2_LEN (sizeof(struct p54_tx_control_filter)-8)
-
 struct p54_tx_control_channel {
 	__le16 flags;
 	__le16 dwell;
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-10-14 22:24:00.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-10-15 03:03:57.000000000 +0200
@@ -15,7 +15,7 @@
  */
 
 enum control_frame_types {
-	P54_CONTROL_TYPE_FILTER_SET = 0,
+	P54_CONTROL_TYPE_SETUP = 0,
 	P54_CONTROL_TYPE_CHANNEL_CHANGE,
 	P54_CONTROL_TYPE_FREQDONE,
 	P54_CONTROL_TYPE_DCFINIT,
@@ -80,7 +80,7 @@ struct p54_common {
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
-	__le16 filter_type;
+	u16 mac_mode;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
 	struct pda_channel_output_limit *output_limit;

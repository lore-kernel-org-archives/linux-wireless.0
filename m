Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:43890 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYJHSsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 14:48:21 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: honour bss_info_changed's short slot time settings
Date: Wed, 8 Oct 2008 20:52:22 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810082052.22847.chunkeey@web.de> (sfid-20081008_204825_624783_85483A5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch was made on behalf of Johannes request.
"mac80211 and IEEE80211_CONF_SHORT_SLOT_TIME"

Of course, bss_info_changed provides some more useful data.
e.g.: basic_rates, dtim_period, beacon_int and maybe even more.
Everything can be hooked up if it's necessary.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 1d0704f..8da4d30 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -81,6 +81,7 @@ struct p54_common {
 	unsigned int output_limit_len;
 	struct pda_pa_curve_data *curve_data;
 	unsigned int filter_flags;
+	bool use_short_slot;
 	u16 rxhw;
 	u8 version;
 	u8 rx_antenna;
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 117c7d3..726cba9 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -909,12 +909,10 @@ static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
 		memset(filter->bssid, ~0, ETH_ALEN);
 	else
 		memcpy(filter->bssid, bssid, ETH_ALEN);
-
 	filter->rx_antenna = priv->rx_antenna;
-
 	if (priv->fw_var < 0x500) {
 		data_len = P54_TX_CONTROL_FILTER_V1_LEN;
-		filter->v1.basic_rate_mask = cpu_to_le32(0x15F);
+		filter->v1.basic_rate_mask = cpu_to_le32(0x15f);
 		filter->v1.rx_addr = cpu_to_le32(priv->rx_end);
 		filter->v1.max_rx = cpu_to_le16(priv->rx_mtu);
 		filter->v1.rxhw = cpu_to_le16(priv->rxhw);
@@ -926,7 +924,6 @@ static int p54_set_filter(struct ieee80211_hw *dev, u16 filter_type,
 		filter->v2.rxhw = cpu_to_le16(priv->rxhw);
 		filter->v2.timer = cpu_to_le16(1000);
 	}
-
 	hdr->len = cpu_to_le16(data_len);
 	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + data_len);
 	priv->tx(dev, hdr, sizeof(*hdr) + data_len, 1);
@@ -1096,7 +1093,7 @@ static void p54_set_vdcf(struct ieee80211_hw *dev)
 
 	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
 
-	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
+	if (priv->use_short_slot) {
 		vdcf->slottime = 9;
 		vdcf->magic1 = 0x10;
 		vdcf->magic2 = 0x00;
@@ -1143,7 +1140,6 @@ static int p54_start(struct ieee80211_hw *dev)
 		priv->mode = NL80211_IFTYPE_MONITOR;
 
 	p54_init_vdcf(dev);
-
 	mod_timer(&priv->stats_timer, jiffies + HZ);
 	return err;
 }
@@ -1359,6 +1355,19 @@ static int p54_get_tx_stats(struct ieee80211_hw *dev,
 	return 0;
 }
 
+static void p54_bss_info_changed(struct ieee80211_hw *dev,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_bss_conf *info,
+				 u32 changed)
+{
+	struct p54_common *priv = dev->priv;
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		priv->use_short_slot = info->use_short_slot;
+		p54_set_vdcf(dev);
+	}
+}
+
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx,
 	.start			= p54_start,
@@ -1367,6 +1376,7 @@ static const struct ieee80211_ops p54_ops = {
 	.remove_interface	= p54_remove_interface,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
+	.bss_info_changed	= p54_bss_info_changed,
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
@@ -1393,7 +1403,6 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-
 	priv->tx_stats[0].limit = 1;
 	priv->tx_stats[1].limit = 1;
 	priv->tx_stats[2].limit = 1;

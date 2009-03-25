Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57443 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbZCYCKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 22:10:09 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] p54: add beacon filtering support
Date: Wed, 25 Mar 2009 03:12:49 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903250312.49624.chunkeey@web.de> (sfid-20090325_031020_307226_B0B42381)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds beacon filtering support to p54.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 0954044..53d3ed8 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -134,6 +134,7 @@ struct p54_led_dev {
 
 struct p54_common {
 	struct ieee80211_hw *hw;
+	struct ieee80211_vif *vif;
 	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 3766d33..b6ebd48 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1044,6 +1044,7 @@ static void p54_rx_stats(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 static void p54_rx_trap(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	struct p54_trap *trap = (struct p54_trap *) hdr->data;
 	u16 event = le16_to_cpu(trap->event);
@@ -1057,6 +1058,8 @@ static void p54_rx_trap(struct ieee80211_hw *dev, struct sk_buff *skb)
 			wiphy_name(dev->wiphy), freq);
 		break;
 	case P54_TRAP_NO_BEACON:
+		if (priv->vif)
+			ieee80211_beacon_loss(priv->vif);
 		break;
 	case P54_TRAP_SCAN:
 		break;
@@ -1939,7 +1942,8 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 	int i;
 
 	if (dev->conf.flags & IEEE80211_CONF_PS)
-		mode = P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC;
+		mode = P54_PSM | P54_PSM_BEACON_TIMEOUT | P54_PSM_DTIM |
+		       P54_PSM_CHECKSUM | P54_PSM_MCBC;
 	else
 		mode = P54_PSM_CAM;
 
@@ -1957,9 +1961,10 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 		psm->intervals[i].periods = cpu_to_le16(1);
 	}
 
-	psm->beacon_rssi_skip_max = 60;
+	psm->beacon_rssi_skip_max = 200;
 	psm->rssi_delta_threshold = 0;
-	psm->nr = 0;
+	psm->nr = 10;
+	psm->exclude[0] = 0;
 
 	priv->tx(dev, skb);
 
@@ -2114,6 +2119,8 @@ static int p54_add_interface(struct ieee80211_hw *dev,
 		return -EOPNOTSUPP;
 	}
 
+	priv->vif = conf->vif;
+
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
@@ -2138,6 +2145,7 @@ static void p54_remove_interface(struct ieee80211_hw *dev,
 	struct p54_common *priv = dev->priv;
 
 	mutex_lock(&priv->conf_mutex);
+	priv->vif = NULL;
 	if (priv->cached_beacon)
 		p54_tx_cancel(dev, priv->cached_beacon);
 	priv->mode = NL80211_IFTYPE_MONITOR;
@@ -2592,7 +2600,8 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_SIGNAL_DBM |
-		     IEEE80211_HW_NOISE_DBM;
+		     IEEE80211_HW_NOISE_DBM |
+		     IEEE80211_HW_BEACON_FILTER;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				      BIT(NL80211_IFTYPE_ADHOC) |

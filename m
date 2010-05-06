Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51244 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab0EFUzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 16:55:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] rtl8180: add software-based support for IBSS mode
Date: Thu,  6 May 2010 16:49:40 -0400
Message-Id: <1273178980-11046-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device documentation suggests that hardware support for beaconing
is available.  But I implemented software-based beacon generation
as an experiment and it seems better to have that working now rather
than waiting for something better to materialize.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180.h     |    8 +++
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   82 ++++++++++++++++++++++++----
 2 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180.h
index b92d678..4baf0cf 100644
--- a/drivers/net/wireless/rtl818x/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180.h
@@ -55,6 +55,14 @@ struct rtl8180_tx_ring {
 	struct sk_buff_head queue;
 };
 
+struct rtl8180_vif {
+	struct ieee80211_hw *dev;
+
+	/* beaconing */
+	struct delayed_work beacon_work;
+	bool enable_beacon;
+};
+
 struct rtl8180_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr __iomem *map;
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index a6fb9a6..56dc816 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -663,10 +663,59 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
 		rtl8180_free_tx_ring(dev, i);
 }
 
+static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	return rtl818x_ioread32(priv, &priv->map->TSFT[0]) |
+	       (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
+}
+
+void rtl8180_beacon_work(struct work_struct *work)
+{
+	struct rtl8180_vif *vif_priv =
+		container_of(work, struct rtl8180_vif, beacon_work.work);
+	struct ieee80211_vif *vif =
+		container_of((void *)vif_priv, struct ieee80211_vif, drv_priv);
+	struct ieee80211_hw *dev = vif_priv->dev;
+	struct ieee80211_mgmt *mgmt;
+	struct sk_buff *skb;
+	int err = 0;
+
+	/* don't overflow the tx ring */
+	if (ieee80211_queue_stopped(dev, 0))
+		goto resched;
+
+	/* grab a fresh beacon */
+	skb = ieee80211_beacon_get(dev, vif);
+
+	/*
+	 * update beacon timestamp w/ TSF value
+	 * TODO: make hardware update beacon timestamp
+	 */
+	mgmt = (struct ieee80211_mgmt *)skb->data;
+	mgmt->u.beacon.timestamp = cpu_to_le64(rtl8180_get_tsf(dev));
+
+	/* TODO: use actual beacon queue */
+	skb_set_queue_mapping(skb, 0);
+
+	err = rtl8180_tx(dev, skb);
+	WARN_ON(err);
+
+resched:
+	/*
+	 * schedule next beacon
+	 * TODO: use hardware support for beacon timing
+	 */
+	schedule_delayed_work(&vif_priv->beacon_work,
+			usecs_to_jiffies(1024 * vif->bss_conf.beacon_int));
+}
+
 static int rtl8180_add_interface(struct ieee80211_hw *dev,
 				 struct ieee80211_vif *vif)
 {
 	struct rtl8180_priv *priv = dev->priv;
+	struct rtl8180_vif *vif_priv;
 
 	/*
 	 * We only support one active interface at a time.
@@ -676,6 +725,7 @@ static int rtl8180_add_interface(struct ieee80211_hw *dev,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -683,6 +733,12 @@ static int rtl8180_add_interface(struct ieee80211_hw *dev,
 
 	priv->vif = vif;
 
+	/* Initialize driver private area */
+	vif_priv = (struct rtl8180_vif *)&vif->drv_priv;
+	vif_priv->dev = dev;
+	INIT_DELAYED_WORK(&vif_priv->beacon_work, rtl8180_beacon_work);
+	vif_priv->enable_beacon = false;
+
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->MAC[0],
 			  le32_to_cpu(*(__le32 *)vif->addr));
@@ -716,8 +772,11 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 				     u32 changed)
 {
 	struct rtl8180_priv *priv = dev->priv;
+	struct rtl8180_vif *vif_priv;
 	int i;
 
+	vif_priv = (struct rtl8180_vif *)&vif->drv_priv;
+
 	if (changed & BSS_CHANGED_BSSID) {
 		for (i = 0; i < ETH_ALEN; i++)
 			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
@@ -732,7 +791,16 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT && priv->rf->conf_erp)
-	        priv->rf->conf_erp(dev, info);
+		priv->rf->conf_erp(dev, info);
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED)
+		vif_priv->enable_beacon = info->enable_beacon;
+ 
+	if (changed & (BSS_CHANGED_BEACON_ENABLED | BSS_CHANGED_BEACON)) {
+		cancel_delayed_work_sync(&vif_priv->beacon_work);
+		if (vif_priv->enable_beacon)
+			schedule_work(&vif_priv->beacon_work.work);
+	}
 }
 
 static u64 rtl8180_prepare_multicast(struct ieee80211_hw *dev, int mc_count,
@@ -773,14 +841,6 @@ static void rtl8180_configure_filter(struct ieee80211_hw *dev,
 	rtl818x_iowrite32(priv, &priv->map->RX_CONF, priv->rx_conf);
 }
 
-static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
-{
-	struct rtl8180_priv *priv = dev->priv;
-
-	return rtl818x_ioread32(priv, &priv->map->TSFT[0]) |
-	       (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
-}
-
 static const struct ieee80211_ops rtl8180_ops = {
 	.tx			= rtl8180_tx,
 	.start			= rtl8180_start,
@@ -916,7 +976,9 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_UNSPEC;
-	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	dev->vif_data_size = sizeof(struct rtl8180_vif);
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+					BIT(NL80211_IFTYPE_ADHOC);
 	dev->queues = 1;
 	dev->max_signal = 65;
 
-- 
1.6.6.1


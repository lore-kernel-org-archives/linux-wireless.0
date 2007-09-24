Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34647 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752240AbXIXPHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 11:07:07 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] adm8211: Adapt to filter configuration API
Date: Mon, 24 Sep 2007 11:06:04 -0400
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
Message-Id: <200709241106.04902.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes p54 use the new filter configuration API in mac80211.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/p54.h       |    3 +
 drivers/net/wireless/p54common.c |   80 ++++++++++++++++++++++++++++----------
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
index e558d69..744c866 100644
--- a/drivers/net/wireless/p54.h
+++ b/drivers/net/wireless/p54.h
@@ -52,7 +52,8 @@ struct p54_common {
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
-	u8 *mac_addr;
+	u8 mac_addr[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
 	struct pda_channel_output_limit *output_limit;
diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index b05b5c5..9befd6c 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -774,15 +774,39 @@ static void p54_set_vdcf(struct ieee80211_hw *dev)
 	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*vdcf), 0);
 }
 
+static int p54_start(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	int err;
+
+	err = priv->open(dev);
+	if (!err)
+		priv->mode = IEEE80211_IF_TYPE_MNTR;
+
+	return err;
+}
+
+static void p54_stop(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
+	while ((skb = skb_dequeue(&priv->tx_queue))) {
+		struct memrecord *range = (struct memrecord *)&skb->cb;
+		if (range->control)
+			kfree(range->control);
+		kfree_skb(skb);
+	}
+	priv->stop(dev);
+	priv->mode = IEEE80211_IF_TYPE_MGMT;
+}
+
 static int p54_add_interface(struct ieee80211_hw *dev,
 			     struct ieee80211_if_init_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
-	int err;
 
-	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT)
-		return -1;
+	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
+		return -EOPNOTSUPP;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
@@ -792,23 +816,18 @@ static int p54_add_interface(struct ieee80211_hw *dev,
 		return -EOPNOTSUPP;
 	}
 
-	priv->mac_addr = conf->mac_addr;
-
-	err = priv->open(dev);
-	if (err) {
-		priv->mode = IEEE80211_IF_TYPE_MGMT;
-		skb_queue_purge(&priv->tx_queue);
-		return err;
-	}
+	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 
 	p54_set_filter(dev, 0, priv->mac_addr, NULL, 0, 1, 0, 0xF642);
 	p54_set_filter(dev, 0, priv->mac_addr, NULL, 1, 0, 0, 0xF642);
-	p54_set_vdcf(dev);
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
 		p54_set_filter(dev, 1, priv->mac_addr, NULL, 0, 0x15F, 0x1F4, 0);
 		break;
+	default:
+		BUG();	/* impossible */
+		break;
 	}
 
 	p54_set_leds(dev, 1, 0, 0);
@@ -820,15 +839,9 @@ static void p54_remove_interface(struct ieee80211_hw *dev,
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
-	struct sk_buff *skb;
-	while ((skb = skb_dequeue(&priv->tx_queue))) {
-		struct memrecord *range = (struct memrecord *)&skb->cb;
-		if (range->control)
-			kfree(range->control);
-		kfree_skb(skb);
-	}
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
-	priv->stop(dev);
+	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	memset(priv->mac_addr, 0, ETH_ALEN);
+	p54_set_filter(dev, 0, priv->mac_addr, NULL, 2, 0, 0, 0);
 }
 
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -848,9 +861,29 @@ static int p54_config_interface(struct ieee80211_hw *dev, int if_id,
 	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 0, 1, 0, 0xF642);
 	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 2, 0, 0, 0);
 	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
+	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 	return 0;
 }
 
+static void p54_configure_filter(struct ieee80211_hw *dev,
+				 unsigned int changed_flags,
+				 unsigned int *total_flags,
+				 int mc_count, struct dev_mc_list *mclist)
+{
+	struct p54_common *priv = dev->priv;
+
+	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
+
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+			p54_set_filter(dev, 0, priv->mac_addr,
+				       NULL, 2, 0, 0, 0);
+		else
+			p54_set_filter(dev, 0, priv->mac_addr,
+				       priv->bssid, 2, 0, 0, 0);
+	}
+}
+
 static int p54_conf_tx(struct ieee80211_hw *dev, int queue,
 		       const struct ieee80211_tx_queue_params *params)
 {
@@ -893,10 +926,13 @@ static int p54_get_tx_stats(struct ieee80211_hw *dev,
 
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx,
+	.start			= p54_start,
+	.stop			= p54_stop,
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
+	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
 	.get_tx_stats		= p54_get_tx_stats


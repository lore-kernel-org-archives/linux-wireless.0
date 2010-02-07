Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34312 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0BGIVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:53 -0500
Subject: [PATCH 08/10] p54: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Christian Lamparter <chunkeey@web.de>
Date: Sun, 07 Feb 2010 10:21:46 +0200
Message-ID: <20100207082146.31474.70086.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

p54 uses struct ieee80211_tx_queue_stats also internally, so create a new
identical struct p54_tx_queue_stats which the driver can use.

Compile-tested only.

Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/p54/main.c |   11 -----------
 drivers/net/wireless/p54/p54.h  |    8 +++++++-
 drivers/net/wireless/p54/txrx.c |    2 +-
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 26428e4..3fe6366 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -358,16 +358,6 @@ static int p54_get_stats(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static int p54_get_tx_stats(struct ieee80211_hw *dev,
-			    struct ieee80211_tx_queue_stats *stats)
-{
-	struct p54_common *priv = dev->priv;
-
-	memcpy(stats, &priv->tx_stats[P54_QUEUE_DATA],
-	       sizeof(stats[0]) * dev->queues);
-	return 0;
-}
-
 static void p54_bss_info_changed(struct ieee80211_hw *dev,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
@@ -522,7 +512,6 @@ static const struct ieee80211_ops p54_ops = {
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
-	.get_tx_stats		= p54_get_tx_stats
 };
 
 struct ieee80211_hw *p54_init_common(size_t priv_data_len)
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 1afc394..43a3b2e 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -157,6 +157,12 @@ struct p54_led_dev {
 
 #endif /* CONFIG_P54_LEDS */
 
+struct p54_tx_queue_stats {
+	unsigned int len;
+	unsigned int limit;
+	unsigned int count;
+};
+
 struct p54_common {
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
@@ -183,7 +189,7 @@ struct p54_common {
 	/* (e)DCF / QOS state */
 	bool use_short_slot;
 	spinlock_t tx_stats_lock;
-	struct ieee80211_tx_queue_stats tx_stats[8];
+	struct p54_tx_queue_stats tx_stats[8];
 	struct p54_edcf_queue_param qos_params[8];
 
 	/* Radio data */
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index b6dda2b..0e8f694 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -183,7 +183,7 @@ static int p54_tx_qos_accounting_alloc(struct p54_common *priv,
 				       struct sk_buff *skb,
 				       const u16 p54_queue)
 {
-	struct ieee80211_tx_queue_stats *queue;
+	struct p54_tx_queue_stats *queue;
 	unsigned long flags;
 
 	if (WARN_ON(p54_queue > P54_QUEUE_NUM))


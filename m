Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:59849 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0BGIVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:08 -0500
Subject: [PATCH 03/10] ar9170: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Christian Lamparter <chunkeey@web.de>
Date: Sun, 07 Feb 2010 10:21:00 +0200
Message-ID: <20100207082100.31474.30105.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

Because ar9170 uses ieee80211_tx_queue_stats internally, create a new
identical struct ar9170_tx_queue_stats which the driver can use.

Compile-tested only.

Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/ath/ar9170/ar9170.h |    8 +++++++-
 drivers/net/wireless/ath/ar9170/main.c   |   13 -------------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 04525ff..dc662b7 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -144,6 +144,12 @@ struct ar9170_sta_tid {
 	bool active;
 };
 
+struct ar9170_tx_queue_stats {
+	unsigned int len;
+	unsigned int limit;
+	unsigned int count;
+};
+
 #define AR9170_QUEUE_TIMEOUT		64
 #define AR9170_TX_TIMEOUT		8
 #define AR9170_BA_TIMEOUT		4
@@ -212,7 +218,7 @@ struct ar9170 {
 
 	/* qos queue settings */
 	spinlock_t tx_stats_lock;
-	struct ieee80211_tx_queue_stats tx_stats[5];
+	struct ar9170_tx_queue_stats tx_stats[5];
 	struct ieee80211_tx_queue_params edcf[5];
 
 	spinlock_t cmdlock;
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index b8a482c..2b67b03 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2396,18 +2396,6 @@ static int ar9170_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int ar9170_get_tx_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_tx_queue_stats *tx_stats)
-{
-	struct ar9170 *ar = hw->priv;
-
-	spin_lock_bh(&ar->tx_stats_lock);
-	memcpy(tx_stats, ar->tx_stats, sizeof(tx_stats[0]) * hw->queues);
-	spin_unlock_bh(&ar->tx_stats_lock);
-
-	return 0;
-}
-
 static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			  const struct ieee80211_tx_queue_params *param)
 {
@@ -2509,7 +2497,6 @@ static const struct ieee80211_ops ar9170_ops = {
 	.set_key		= ar9170_set_key,
 	.sta_notify		= ar9170_sta_notify,
 	.get_stats		= ar9170_get_stats,
-	.get_tx_stats		= ar9170_get_tx_stats,
 	.ampdu_action		= ar9170_ampdu_action,
 };
 


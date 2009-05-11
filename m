Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40378 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbZELADv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 20:03:51 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ar9170: stop data queues on channel switch
Date: Tue, 12 May 2009 01:09:09 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200905120109.09906.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we didn't check if there are still pending frames

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index a66aa7d..8c8f45b 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1299,6 +1299,37 @@ static void ar9170_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&ar->mutex);
 }
 
+static int ar9170_stop_and_flush_queues(struct ar9170 *ar)
+{
+	int err;
+
+	ieee80211_stop_queues(ar->hw);
+
+	err = ar->flush(ar);
+	if (err) {
+		printk(KERN_ERR "%s: device is not responding (%d)!\n",
+		       wiphy_name(ar->hw->wiphy), err);
+
+		/* FIXME: purge tx_status queues and reset */
+	}
+
+	return err;
+}
+
+static void ar9170_wake_queues(struct ar9170 *ar)
+{
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ar->tx_stats_lock, flags);
+	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
+		if ((ar->tx_stats[i].len < ar->tx_stats[i].limit) &&
+		    (ieee80211_queue_stopped(ar->hw, i)))
+			ieee80211_wake_queue(ar->hw, i);
+	}
+	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
+}
+
 static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ar9170 *ar = hw->priv;
@@ -1344,6 +1375,9 @@ static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		err = ar9170_stop_and_flush_queues(ar);
+		if (err)
+			goto out;
 
 		/* adjust slot time for 5 GHz */
 		err = ar9170_set_slot_time(ar);
@@ -1359,10 +1393,12 @@ static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
 				nl80211_to_ar9170(hw->conf.channel_type));
 		if (err)
 			goto out;
+
 	}
 
 out:
 	mutex_unlock(&ar->mutex);
+	ar9170_wake_queues(ar);
 	return err;
 }
 

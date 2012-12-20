Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab2LTNcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:32:17 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/3] iwlegacy: add flush callback
Date: Thu, 20 Dec 2012 14:31:51 +0100
Message-Id: <1356010313-9782-1-git-send-email-sgruszka@redhat.com> (sfid-20121220_143219_397553_5B87C95F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dump implementation of flush, which just wait until all TX queues
become empty.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 +
 drivers/net/wireless/iwlegacy/4965-mac.c |    1 +
 drivers/net/wireless/iwlegacy/common.c   |   36 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlegacy/common.h   |    1 +
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index d604b40..962400a 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3474,6 +3474,7 @@ struct ieee80211_ops il3945_mac_ops = {
 	.sta_add = il3945_mac_sta_add,
 	.sta_remove = il_mac_sta_remove,
 	.tx_last_beacon = il_mac_tx_last_beacon,
+	.flush = il_mac_flush,
 };
 
 static int
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c3fbf67..7d462d8 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6306,6 +6306,7 @@ const struct ieee80211_ops il4965_mac_ops = {
 	.sta_remove = il_mac_sta_remove,
 	.channel_switch = il4965_mac_channel_switch,
 	.tx_last_beacon = il_mac_tx_last_beacon,
+	.flush = il_mac_flush,
 };
 
 static int
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 7e16d10..56b8021 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4707,6 +4707,42 @@ out:
 }
 EXPORT_SYMBOL(il_mac_change_interface);
 
+void
+il_mac_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct il_priv *il = hw->priv;
+	unsigned long timeout = jiffies + msecs_to_jiffies(500);
+	int i;
+
+	mutex_lock(&il->mutex);
+	D_MAC80211("enter\n");
+
+	if (il->txq == NULL)
+		goto out;
+
+	for (i = 0; i < il->hw_params.max_txq_num; i++) {
+		struct il_queue *q;
+
+		if (i == il->cmd_queue)
+			continue;
+
+		q = &il->txq[i].q;
+		if (q->read_ptr == q->write_ptr)
+			continue;
+
+		if (time_after(jiffies, timeout)) {
+			IL_ERR("Failed to flush queue %d\n", q->id);
+			break;
+		}
+
+		msleep(20);
+	}
+out:
+	D_MAC80211("leave\n");
+	mutex_unlock(&il->mutex);
+}
+EXPORT_SYMBOL(il_mac_flush);
+
 /*
  * On every watchdog tick we check (latest) time stamp. If it does not
  * change during timeout period and queue is not empty we reset firmware.
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index a9a569f..37fe553 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1723,6 +1723,7 @@ void il_mac_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 int il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    enum nl80211_iftype newtype, bool newp2p);
+void il_mac_flush(struct ieee80211_hw *hw, bool drop);
 int il_alloc_txq_mem(struct il_priv *il);
 void il_free_txq_mem(struct il_priv *il);
 
-- 
1.7.1


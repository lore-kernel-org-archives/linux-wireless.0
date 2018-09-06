Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728272AbeIFNyd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 24/42] mt76x0: enable per-sta tx queueing
Date: Thu,  6 Sep 2018 11:18:40 +0200
Message-Id: <1536225538-16454-25-git-send-email-sgruszka@redhat.com> (sfid-20180906_112007_198917_37812F62)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Initialize wake_tx_queue function pointer in ieee80211_ops
in order to enable per-sta tx queueing. Moreover set driver
private txq size

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 1f4a0fff684b..7cd939c97efe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -684,6 +684,9 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
 
+	hw->txq_data_size = sizeof(struct mt76_txq);
+	hw->max_tx_fragments = 16;
+
 	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
 
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index b0a1f7a7209a..8c8a0f676228 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -180,4 +180,5 @@ const struct ieee80211_ops mt76x0_ops = {
 	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.set_rts_threshold = mt76x0_set_rts_threshold,
+	.wake_tx_queue = mt76_wake_tx_queue,
 };
-- 
2.7.5

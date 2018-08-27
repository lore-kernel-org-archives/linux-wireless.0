Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbeH0SoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 14:44:09 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 12/17] mt76x0: use mt76_wcid_free in mt76x0
Date: Mon, 27 Aug 2018 16:56:26 +0200
Message-Id: <1535381791-14908-13-git-send-email-sgruszka@redhat.com> (sfid-20180827_170843_647133_E6BEF0DE)
In-Reply-To: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use helper from util instead of custom code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index a5bdd324f6ec..66e8389d489f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -197,7 +197,7 @@ mt76x0_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&dev->mt76.mutex);
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
-	dev->wcid_mask[idx / BITS_PER_LONG] &= ~BIT(idx % BITS_PER_LONG);
+	mt76_wcid_free(dev->wcid_mask, idx);
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mt76x0_mac_set_ampdu_factor(dev);
 	mutex_unlock(&dev->mt76.mutex);
-- 
2.7.5

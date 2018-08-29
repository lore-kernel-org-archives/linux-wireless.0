Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728359AbeH2PNl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 11:13:41 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 11/16] mt76x0: use mt76_wcid_free in mt76x0
Date: Wed, 29 Aug 2018 13:16:42 +0200
Message-Id: <1535541407-27149-12-git-send-email-sgruszka@redhat.com> (sfid-20180829_131720_219315_4CE70104)
In-Reply-To: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
References: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
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

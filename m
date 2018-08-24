Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbeHXOuJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:50:09 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 12/17] mt76x0: use mt76_wcid_free in mt76x0
Date: Fri, 24 Aug 2018 13:15:16 +0200
Message-Id: <1535109321-17126-13-git-send-email-sgruszka@redhat.com> (sfid-20180824_131601_272787_EE0BCC93)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use helper from util instead of custom code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 29784f2f3797..79e236d814c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -197,7 +197,7 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&dev->mt76.mutex);
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	mt76xx_mac_wcid_set_drop(&dev->mt76, idx, true);
-	dev->wcid_mask[idx / BITS_PER_LONG] &= ~BIT(idx % BITS_PER_LONG);
+	mt76_wcid_free(dev->wcid_mask, idx);
 	mt76xx_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mt76x0_mac_set_ampdu_factor(dev);
 	mutex_unlock(&dev->mt76.mutex);
-- 
1.9.3

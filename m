Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:04 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 04/22] mt76x0: fix wrong usage of wcid_mask in remove_interface
Date: Tue,  4 Sep 2018 16:40:57 +0200
Message-Id: <1536072075-6990-5-git-send-email-sgruszka@redhat.com> (sfid-20180904_164158_998933_2B39308C)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We wrongly use wcid_mask instead of vif_mask

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 12884504c833..1b0ddba96ea1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -74,9 +74,8 @@ static void mt76x0_remove_interface(struct ieee80211_hw *hw,
 {
 	struct mt76x0_dev *dev = hw->priv;
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	unsigned int wcid = mvif->group_wcid.idx;
 
-	dev->mt76.wcid_mask[wcid / BITS_PER_LONG] &= ~BIT(wcid % BITS_PER_LONG);
+	dev->vif_mask &= ~BIT(mvif->idx);
 	mt76_txq_remove(&dev->mt76, vif->txq);
 }
 
-- 
2.7.5

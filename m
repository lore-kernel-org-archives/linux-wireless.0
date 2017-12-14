Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40482 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdLNMDh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:03:37 -0500
Received: by mail-wm0-f66.google.com with SMTP id f206so10884439wmf.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Dec 2017 04:03:37 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: dan.carpenter@oracle.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
Date: Thu, 14 Dec 2017 13:03:16 +0100
Message-Id: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com> (sfid-20171214_130342_138571_5AF7C511)
In-Reply-To: <cover.1513252573.git.lorenzo.bianconi@redhat.com>
References: <cover.1513252573.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize mt76_txq pointer after ieee80211_txq pointer check.
Remove space after the pointer cast

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 2cef48edb275..33469e32567b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -450,13 +450,15 @@ mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt76x2_dev *dev = hw->priv;
 	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
 	struct ieee80211_txq *txq = sta->txq[params->tid];
-	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
 	u16 tid = params->tid;
 	u16 *ssn = &params->ssn;
+	struct mt76_txq *mtxq;
 
 	if (!txq)
 		return -EINVAL;
 
+	mtxq = (struct mt76_txq *)txq->drv_priv;
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
-- 
2.13.6

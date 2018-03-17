Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33091 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbeCQL3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 07:29:35 -0400
Received: by mail-wr0-f193.google.com with SMTP id z73so9771976wrb.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2018 04:29:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix possible NULL pointer dereferencing in mt76x2_tx()
Date: Sat, 17 Mar 2018 12:29:27 +0100
Message-Id: <20180317112927.18299-1-lorenzo.bianconi@redhat.com> (sfid-20180317_123042_008421_8EBF6EF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a theoretical NULL pointer dereferencing in mt76x2_tx routine that
can occurs for injected frames in a monitor vif since vif pointer could
be NULL for that interfaces

Fixes: 23405236460b ("mt76: fix transmission of encrypted mgmt frames")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 534e4bf9a34c..e46eafc4c436 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -36,9 +36,12 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 
 		msta = (struct mt76x2_sta *) control->sta->drv_priv;
 		wcid = &msta->wcid;
+		/* sw encrypted frames */
+		if (!info->control.hw_key && wcid->hw_key_idx != -1)
+			control->sta = NULL;
 	}
 
-	if (vif || (!info->control.hw_key && wcid->hw_key_idx != -1)) {
+	if (vif && !control->sta) {
 		struct mt76x2_vif *mvif;
 
 		mvif = (struct mt76x2_vif *) vif->drv_priv;
-- 
2.16.2

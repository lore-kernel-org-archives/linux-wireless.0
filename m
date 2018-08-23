Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:45986 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbeHXA7S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 20:59:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mt76: Fix comparisons with invalid hardware key index
Date: Thu, 23 Aug 2018 23:27:38 +0200
Message-Id: <20180823212738.18431-1-geert@linux-m68k.org> (sfid-20180823_232813_045507_03CBCA57)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With gcc 4.1.2:

    drivers/net/wireless/mediatek/mt76/mt76x0/tx.c: In function ‘mt76x0_tx’:
    drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:169: warning: comparison is always true due to limited range of data type
    drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c: In function ‘mt76x2_tx’:
    drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35: warning: comparison is always true due to limited range of data type

While assigning -1 to a u8 works fine, comparing with -1 does not work
as expected.

Fix this by comparing with 0xff, like is already done in some other
places.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested only.
---
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c        | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 751b49c28ae53f0f..c45d05d5aab1d207 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -166,7 +166,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	if (sta) {
 		msta = (struct mt76_sta *) sta->drv_priv;
 		wcid = &msta->wcid;
-	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != -1)) {
+	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != 0xff)) {
 		struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
 
 		wcid = &mvif->group_wcid;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index 36afb166fa3ffd29..c0ca0df84ed8b86a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -32,7 +32,7 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		msta = (struct mt76x2_sta *)control->sta->drv_priv;
 		wcid = &msta->wcid;
 		/* sw encrypted frames */
-		if (!info->control.hw_key && wcid->hw_key_idx != -1)
+		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
 			control->sta = NULL;
 	}
 
-- 
2.17.1

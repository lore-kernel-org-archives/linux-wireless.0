Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49836 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752881AbeDCTw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:52:58 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/7] mt76: add missing VHT maximum A-MPDU length capability
Date: Tue,  3 Apr 2018 21:52:49 +0200
Message-Id: <20180403195254.87700-2-nbd@nbd.name> (sfid-20180403_215306_182733_87E12436)
In-Reply-To: <20180403195254.87700-1-nbd@nbd.name>
References: <20180403195254.87700-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signficantly improves throughput with some clients

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 962ed8234065..ec531ce50d01 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -213,7 +213,8 @@ mt76_init_sband(struct mt76_dev *dev, struct mt76_sband *msband,
 	vht_cap->vht_supported = true;
 	vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC |
 			IEEE80211_VHT_CAP_RXSTBC_1 |
-			IEEE80211_VHT_CAP_SHORT_GI_80;
+			IEEE80211_VHT_CAP_SHORT_GI_80 |
+			(3 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT);
 
 	return 0;
 }
-- 
2.14.2

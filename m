Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45554 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753360AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 13/14] mt76x2: configure rx filter based on monitor mode setting
Date: Thu, 14 Dec 2017 16:39:17 +0100
Message-Id: <20171214153918.43774-14-nbd@nbd.name> (sfid-20171214_163928_567650_AC3B7334)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to an unrelated issue, the MT_RX_FILTR_CFG_PROMISC flag is currently
unset, which means that monitor mode is unconditionally enabled.
Toggle this flag based on the mac80211 monitor mode setting instead

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 240e11508ecd..a69d441d9a47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -146,6 +146,15 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&dev->mutex);
 
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
+			dev->rxfilter |= MT_RX_FILTR_CFG_PROMISC;
+		else
+			dev->rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
+
+		mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		dev->txpower_conf = hw->conf.power_level * 2;
 
-- 
2.14.2

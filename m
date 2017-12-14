Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45532 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753292AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 08/14] mt76x2: convert between per-chain tx power and combined output
Date: Thu, 14 Dec 2017 16:39:12 +0100
Message-Id: <20171214153918.43774-9-nbd@nbd.name> (sfid-20171214_163945_481294_673476C3)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using both chains adds max. 3 dBm. A similar worst-case calculation is
being used in ath9k as well to ensure that the hardware stays within
regulatory limits

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 0755b451829e..3e3a01b6f2ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -785,6 +785,9 @@ mt76x2_init_txpower(struct mt76x2_dev *dev,
 		chan->max_power = mt76x2_get_max_rate_power(&t) +
 				  target_power;
 		chan->max_power /= 2;
+
+		/* convert to combined output power on 2x2 devices */
+		chan->max_power += 3;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 02dd2cafa52f..8098a2b82c5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -155,6 +155,9 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		dev->txpower_conf = hw->conf.power_level * 2;
 
+		/* convert to per-chain power for 2x2 devices */
+		dev->txpower_conf -= 6;
+
 		if (test_bit(MT76_STATE_RUNNING, &dev->mt76.state)) {
 			mt76x2_phy_set_txpower(dev);
 			mt76x2_tx_set_txpwr_auto(dev, dev->txpower_conf);
@@ -443,6 +446,10 @@ mt76x2_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int *dbm)
 	struct mt76x2_dev *dev = hw->priv;
 
 	*dbm = dev->txpower_cur / 2;
+
+	/* convert from per-chain power to combined output on 2x2 devices */
+	*dbm += 3;
+
 	return 0;
 }
 
-- 
2.14.2

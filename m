Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45548 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753330AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 06/14] mt76x2: add channel argument to eeprom tx power functions
Date: Thu, 14 Dec 2017 16:39:10 +0100
Message-Id: <20171214153918.43774-7-nbd@nbd.name> (sfid-20171214_163931_184885_68FAF3B7)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for exposing maximum power to mac80211

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 30 +++++++++++++---------
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h |  6 +++--
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    |  7 ++---
 3 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 29dc52ef629d..8fef400cb58e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -425,12 +425,13 @@ mt76x2_rate_power_val(u8 val)
 	return mt76x2_sign_extend_optional(val, 7);
 }
 
-void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t)
+void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
+			   struct ieee80211_channel *chan)
 {
 	bool is_5ghz;
 	u16 val;
 
-	is_5ghz = dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ;
+	is_5ghz = chan->band == NL80211_BAND_5GHZ;
 
 	memset(t, 0, sizeof(*t));
 
@@ -484,9 +485,9 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t)
 
 static void
 mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
-		       int chain, int offset)
+		         struct ieee80211_channel *chan, int chain, int offset)
 {
-	int channel = dev->mt76.chandef.chan->hw_value;
+	int channel = chan->hw_value;
 	int delta_idx;
 	u8 data[6];
 	u16 val;
@@ -511,9 +512,9 @@ mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 
 static void
 mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
-		       int chain, int offset)
+		         struct ieee80211_channel *chan, int chain, int offset)
 {
-	int channel = dev->mt76.chandef.chan->hw_value;
+	int channel = chan->hw_value;
 	enum mt76x2_cal_channel_group group;
 	int delta_idx;
 	u16 val;
@@ -559,7 +560,8 @@ mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 }
 
 void mt76x2_get_power_info(struct mt76x2_dev *dev,
-			   struct mt76x2_tx_power_info *t)
+			   struct mt76x2_tx_power_info *t,
+			   struct ieee80211_channel *chan)
 {
 	u16 bw40, bw80;
 
@@ -568,13 +570,17 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 	bw40 = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW40);
 	bw80 = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW80);
 
-	if (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ) {
+	if (chan->band == NL80211_BAND_5GHZ) {
 		bw40 >>= 8;
-		mt76x2_get_power_info_5g(dev, t, 0, MT_EE_TX_POWER_0_START_5G);
-		mt76x2_get_power_info_5g(dev, t, 1, MT_EE_TX_POWER_1_START_5G);
+		mt76x2_get_power_info_5g(dev, t, chan, 0,
+					 MT_EE_TX_POWER_0_START_5G);
+		mt76x2_get_power_info_5g(dev, t, chan, 1,
+					 MT_EE_TX_POWER_1_START_5G);
 	} else {
-		mt76x2_get_power_info_2g(dev, t, 0, MT_EE_TX_POWER_0_START_2G);
-		mt76x2_get_power_info_2g(dev, t, 1, MT_EE_TX_POWER_1_START_2G);
+		mt76x2_get_power_info_2g(dev, t, chan, 0,
+					 MT_EE_TX_POWER_0_START_2G);
+		mt76x2_get_power_info_2g(dev, t, chan, 1,
+					 MT_EE_TX_POWER_1_START_2G);
 	}
 
 	if (mt76x2_tssi_enabled(dev) || !field_valid(t->target_power))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index 063d6c8451c9..6db2c6e47569 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -146,9 +146,11 @@ mt76x2_eeprom_get(struct mt76x2_dev *dev, enum mt76x2_eeprom_field field)
 	return get_unaligned_le16(dev->mt76.eeprom.data + field);
 }
 
-void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t);
+void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
+			   struct ieee80211_channel *chan);
 void mt76x2_get_power_info(struct mt76x2_dev *dev,
-			   struct mt76x2_tx_power_info *t);
+			   struct mt76x2_tx_power_info *t,
+			   struct ieee80211_channel *chan);
 int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t);
 bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band);
 void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index fe3a4b6a19cc..81cea7e8414e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -117,11 +117,12 @@ mt76x2_get_max_power(struct mt76_rate_power *r)
 void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 {
 	enum nl80211_chan_width width = dev->mt76.chandef.width;
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	struct mt76x2_tx_power_info txp;
 	int txp_0, txp_1, delta = 0;
 	struct mt76_rate_power t = {};
 
-	mt76x2_get_power_info(dev, &txp);
+	mt76x2_get_power_info(dev, &txp, chan);
 
 	if (width == NL80211_CHAN_WIDTH_40)
 		delta = txp.delta_bw40;
@@ -131,7 +132,7 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	if (txp.target_power > dev->txpower_conf)
 		delta -= txp.target_power - dev->txpower_conf;
 
-	mt76x2_get_rate_power(dev, &t);
+	mt76x2_get_rate_power(dev, &t, chan);
 	mt76x2_add_rate_power_offset(&t, txp.chain[0].target_power +
 				   txp.chain[0].delta);
 	mt76x2_limit_rate_power(&t, dev->txpower_conf);
@@ -675,7 +676,7 @@ mt76x2_phy_tssi_compensate(struct mt76x2_dev *dev)
 			return;
 
 		dev->cal.tssi_comp_pending = false;
-		mt76x2_get_power_info(dev, &txp);
+		mt76x2_get_power_info(dev, &txp, chan);
 
 		if (mt76x2_ext_pa_enabled(dev, chan->band))
 			t.pa_mode = 1;
-- 
2.14.2

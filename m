Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52454 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbeIVRjH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id l7-v6so628130wme.2
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:48 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/9] mt76: move mt76_rate_power in mt76_dev
Date: Sat, 22 Sep 2018 13:45:29 +0200
Message-Id: <20180922114537.24004-2-lorenzo.bianconi@redhat.com> (sfid-20180922_134902_124628_9548A653)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76_rate_power data structure from mt76x2_dev to mt76_dev in order
to share it with mt76x0 driver. Moreover move txpower_conf and
txpower_cur in mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     | 30 +++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  3 --
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   | 20 ++++++-------
 .../mediatek/mt76/mt76x2_mac_common.c         |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_main.c  |  8 ++---
 .../mediatek/mt76/mt76x2_phy_common.c         |  6 ++--
 .../wireless/mediatek/mt76/mt76x2_tx_common.c | 14 ++++-----
 .../net/wireless/mediatek/mt76/mt76x2u_main.c |  4 +--
 8 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index dc6a5f075f3d..15a5b0c89d86 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -275,6 +275,19 @@ struct mt76_sband {
 	struct mt76_channel_state *chan;
 };
 
+struct mt76_rate_power {
+	union {
+		struct {
+			s8 cck[4];
+			s8 ofdm[8];
+			s8 stbc[10];
+			s8 ht[16];
+			s8 vht[10];
+		};
+		s8 all[48];
+	};
+};
+
 /* addr req mask */
 #define MT_VEND_TYPE_EEPROM	BIT(31)
 #define MT_VEND_TYPE_CFG	BIT(30)
@@ -395,6 +408,10 @@ struct mt76_dev {
 	struct debugfs_blob_wrapper otp;
 	struct mt76_hw_cap cap;
 
+	struct mt76_rate_power rate_power;
+	int txpower_conf;
+	int txpower_cur;
+
 	u32 debugfs_reg;
 
 	struct led_classdev led_cdev;
@@ -418,19 +435,6 @@ enum mt76_phy_type {
 	MT_PHY_TYPE_VHT,
 };
 
-struct mt76_rate_power {
-	union {
-		struct {
-			s8 cck[4];
-			s8 ofdm[8];
-			s8 stbc[10];
-			s8 ht[16];
-			s8 vht[10];
-		};
-		s8 all[48];
-	};
-};
-
 struct mt76_rx_status {
 	struct mt76_wcid *wcid;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 784962913d9a..a6dd35d00968 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -82,8 +82,6 @@ struct mt76x2_dev {
 	struct mutex mutex;
 
 	const u16 *beacon_offsets;
-	int txpower_conf;
-	int txpower_cur;
 
 	u8 txdone_seq;
 	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
@@ -113,7 +111,6 @@ struct mt76x2_dev {
 
 	s8 target_power;
 	s8 target_power_delta[2];
-	struct mt76_rate_power rate_power;
 	bool enable_tpc;
 
 	u8 coverage_class;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 45f3439a6563..527c94d07d67 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -55,16 +55,16 @@ static int read_txpower(struct seq_file *file, void *data)
 
 	mt76_seq_puts_array(file, "Delta", dev->target_power_delta,
 			    ARRAY_SIZE(dev->target_power_delta));
-	mt76_seq_puts_array(file, "CCK", dev->rate_power.cck,
-			    ARRAY_SIZE(dev->rate_power.cck));
-	mt76_seq_puts_array(file, "OFDM", dev->rate_power.ofdm,
-			    ARRAY_SIZE(dev->rate_power.ofdm));
-	mt76_seq_puts_array(file, "STBC", dev->rate_power.stbc,
-			    ARRAY_SIZE(dev->rate_power.stbc));
-	mt76_seq_puts_array(file, "HT", dev->rate_power.ht,
-			    ARRAY_SIZE(dev->rate_power.ht));
-	mt76_seq_puts_array(file, "VHT", dev->rate_power.vht,
-			    ARRAY_SIZE(dev->rate_power.vht));
+	mt76_seq_puts_array(file, "CCK", dev->mt76.rate_power.cck,
+			    ARRAY_SIZE(dev->mt76.rate_power.cck));
+	mt76_seq_puts_array(file, "OFDM", dev->mt76.rate_power.ofdm,
+			    ARRAY_SIZE(dev->mt76.rate_power.ofdm));
+	mt76_seq_puts_array(file, "STBC", dev->mt76.rate_power.stbc,
+			    ARRAY_SIZE(dev->mt76.rate_power.stbc));
+	mt76_seq_puts_array(file, "HT", dev->mt76.rate_power.ht,
+			    ARRAY_SIZE(dev->mt76.rate_power.ht));
+	mt76_seq_puts_array(file, "VHT", dev->mt76.rate_power.vht,
+			    ARRAY_SIZE(dev->mt76.rate_power.vht));
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 126650742ba4..ed4f56a3aae9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -100,7 +100,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 	}
 	spin_unlock_bh(&dev->mt76.lock);
 
-	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, dev->txpower_conf,
+	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, dev->mt76.txpower_conf,
 					    max_txpwr_adj);
 	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 7f0a89be154c..24b13eeba8af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -106,14 +106,14 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		dev->txpower_conf = hw->conf.power_level * 2;
+		dev->mt76.txpower_conf = hw->conf.power_level * 2;
 
 		/* convert to per-chain power for 2x2 devices */
-		dev->txpower_conf -= 6;
+		dev->mt76.txpower_conf -= 6;
 
 		if (test_bit(MT76_STATE_RUNNING, &dev->mt76.state)) {
 			mt76x2_phy_set_txpower(dev);
-			mt76x2_tx_set_txpwr_auto(dev, dev->txpower_conf);
+			mt76x2_tx_set_txpwr_auto(dev, dev->mt76.txpower_conf);
 		}
 	}
 
@@ -206,7 +206,7 @@ mt76x2_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int *dbm)
 {
 	struct mt76x2_dev *dev = hw->priv;
 
-	*dbm = dev->txpower_cur / 2;
+	*dbm = dev->mt76.txpower_cur / 2;
 
 	/* convert from per-chain power to combined output on 2x2 devices */
 	*dbm += 3;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index fba01e179f56..e6baad9f4316 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -192,8 +192,8 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 
 	mt76x2_get_rate_power(dev, &t, chan);
 	mt76x2_add_rate_power_offset(&t, txp.chain[0].target_power);
-	mt76x2_limit_rate_power(&t, dev->txpower_conf);
-	dev->txpower_cur = mt76x2_get_max_rate_power(&t);
+	mt76x2_limit_rate_power(&t, dev->mt76.txpower_conf);
+	dev->mt76.txpower_cur = mt76x2_get_max_rate_power(&t);
 
 	base_power = mt76x2_get_min_rate_power(&t);
 	delta += base_power - txp.chain[0].target_power;
@@ -215,7 +215,7 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	dev->target_power = txp.chain[0].target_power;
 	dev->target_power_delta[0] = txp_0 - txp.chain[0].target_power;
 	dev->target_power_delta[1] = txp_1 - txp.chain[0].target_power;
-	dev->rate_power = t;
+	dev->mt76.rate_power = t;
 
 	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0, txp_0);
 	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1, txp_1);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index dbb3071bed1b..1ec3c293e2c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -57,23 +57,23 @@ s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *mdev,
 		u8 mcs = ieee80211_rate_get_vht_mcs(rate);
 
 		if (mcs == 8 || mcs == 9) {
-			max_txpwr = dev->rate_power.vht[8];
+			max_txpwr = mdev->rate_power.vht[8];
 		} else {
 			u8 nss, idx;
 
 			nss = ieee80211_rate_get_vht_nss(rate);
 			idx = ((nss - 1) << 3) + mcs;
-			max_txpwr = dev->rate_power.ht[idx & 0xf];
+			max_txpwr = mdev->rate_power.ht[idx & 0xf];
 		}
 	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
-		max_txpwr = dev->rate_power.ht[rate->idx & 0xf];
+		max_txpwr = mdev->rate_power.ht[rate->idx & 0xf];
 	} else {
 		enum nl80211_band band = dev->mt76.chandef.chan->band;
 
 		if (band == NL80211_BAND_2GHZ) {
 			const struct ieee80211_rate *r;
 			struct wiphy *wiphy = mt76_hw(dev)->wiphy;
-			struct mt76_rate_power *rp = &dev->rate_power;
+			struct mt76_rate_power *rp = &mdev->rate_power;
 
 			r = &wiphy->bands[band]->bitrates[rate->idx];
 			if (r->flags & IEEE80211_RATE_SHORT_PREAMBLE)
@@ -81,7 +81,7 @@ s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *mdev,
 			else
 				max_txpwr = rp->ofdm[r->hw_value & 0x7];
 		} else {
-			max_txpwr = dev->rate_power.ofdm[rate->idx & 0x7];
+			max_txpwr = mdev->rate_power.ofdm[rate->idx & 0x7];
 		}
 	}
 
@@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(mt76x2_tx_get_max_txpwr_adj);
 
 s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj)
 {
-	txpwr = min_t(s8, txpwr, dev->txpower_conf);
+	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
 	txpwr -= (dev->target_power + dev->target_power_delta[0]);
 	txpwr = min_t(s8, txpwr, max_txpwr_adj);
 
@@ -109,7 +109,7 @@ void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr)
 	s8 txpwr_adj;
 
 	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, txpwr,
-					    dev->rate_power.ofdm[4]);
+					    dev->mt76.rate_power.ofdm[4]);
 	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
 		       MT_PROT_AUTO_TX_CFG_PROT_PADJ, txpwr_adj);
 	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 620aeb3eb79f..a80704568780 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -128,10 +128,10 @@ mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		dev->txpower_conf = hw->conf.power_level * 2;
+		dev->mt76.txpower_conf = hw->conf.power_level * 2;
 
 		/* convert to per-chain power for 2x2 devices */
-		dev->txpower_conf -= 6;
+		dev->mt76.txpower_conf -= 6;
 
 		if (test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
 			mt76x2_phy_set_txpower(dev);
-- 
2.18.0

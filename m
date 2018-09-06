Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:05 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 36/42] mt76x0: use mt76_register_device for device registration
Date: Thu,  6 Sep 2018 11:18:52 +0200
Message-Id: <1536225538-16454-37-git-send-email-sgruszka@redhat.com> (sfid-20180906_112036_108385_B5C4C677)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Use mt76_register_device routine for device registration.
mt76_register_device allows to enable VHT support on 5GHz band.
Overwrite unsupported vht features with mt76x0_vht_cap_mask routine.
Remove macaddr field of mt76x0_dev data structure and
use the mt76_dev one. Moreover remove following unused routines:
- mt76_init_sband
- mt76_init_sband_2g
- mt76_init_sband_5g

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 187 ++++-----------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   1 -
 3 files changed, 39 insertions(+), 162 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 0fd178d84277..2ce27de511f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -160,18 +160,19 @@ static int
 mt76x0_set_macaddr(struct mt76x0_dev *dev, const u8 *eeprom)
 {
 	const void *src = eeprom + MT_EE_MAC_ADDR;
+	u8 *dst = dev->mt76.macaddr;
 
-	ether_addr_copy(dev->macaddr, src);
+	ether_addr_copy(dev->mt76.macaddr, src);
 
-	if (!is_valid_ether_addr(dev->macaddr)) {
-		eth_random_addr(dev->macaddr);
+	if (!is_valid_ether_addr(dst)) {
+		eth_random_addr(dst);
 		dev_info(dev->mt76.dev,
 			 "Invalid MAC address, using random address %pM\n",
-			 dev->macaddr);
+			 dst);
 	}
 
-	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->macaddr));
-	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(dev->macaddr + 4) |
+	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dst));
+	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(dst + 4) |
 		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index d075b29977e3..44fcad2315a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -23,6 +23,24 @@
 
 #include "initvals.h"
 
+static void mt76x0_vht_cap_mask(struct ieee80211_supported_band *sband)
+{
+	struct ieee80211_sta_vht_cap *vht_cap = &sband->vht_cap;
+	u16 mcs_map = 0;
+	int i;
+
+	vht_cap->cap &= ~IEEE80211_VHT_CAP_RXLDPC;
+	for (i = 0; i < 8; i++) {
+		if (!i)
+			mcs_map |= (IEEE80211_VHT_MCS_SUPPORT_0_7 << (i * 2));
+		else
+			mcs_map |=
+				(IEEE80211_VHT_MCS_NOT_SUPPORTED << (i * 2));
+	}
+	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
+}
+
 static void
 mt76x0_set_wlan_state(struct mt76x0_dev *dev, u32 val, bool enable)
 {
@@ -488,125 +506,10 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 	return dev;
 }
 
-#define CHAN2G(_idx, _freq) {			\
-	.band = NL80211_BAND_2GHZ,		\
-	.center_freq = (_freq),			\
-	.hw_value = (_idx),			\
-	.max_power = 30,			\
-}
-
-static const struct ieee80211_channel mt76_channels_2ghz[] = {
-	CHAN2G(1, 2412),
-	CHAN2G(2, 2417),
-	CHAN2G(3, 2422),
-	CHAN2G(4, 2427),
-	CHAN2G(5, 2432),
-	CHAN2G(6, 2437),
-	CHAN2G(7, 2442),
-	CHAN2G(8, 2447),
-	CHAN2G(9, 2452),
-	CHAN2G(10, 2457),
-	CHAN2G(11, 2462),
-	CHAN2G(12, 2467),
-	CHAN2G(13, 2472),
-	CHAN2G(14, 2484),
-};
-
-#define CHAN5G(_idx, _freq) {			\
-	.band = NL80211_BAND_5GHZ,		\
-	.center_freq = (_freq),			\
-	.hw_value = (_idx),			\
-	.max_power = 30,			\
-}
-
-static const struct ieee80211_channel mt76_channels_5ghz[] = {
-	CHAN5G(36, 5180),
-	CHAN5G(40, 5200),
-	CHAN5G(44, 5220),
-	CHAN5G(46, 5230),
-	CHAN5G(48, 5240),
-	CHAN5G(52, 5260),
-	CHAN5G(56, 5280),
-	CHAN5G(60, 5300),
-	CHAN5G(64, 5320),
-
-	CHAN5G(100, 5500),
-	CHAN5G(104, 5520),
-	CHAN5G(108, 5540),
-	CHAN5G(112, 5560),
-	CHAN5G(116, 5580),
-	CHAN5G(120, 5600),
-	CHAN5G(124, 5620),
-	CHAN5G(128, 5640),
-	CHAN5G(132, 5660),
-	CHAN5G(136, 5680),
-	CHAN5G(140, 5700),
-};
-
-static int
-mt76_init_sband(struct mt76x0_dev *dev, struct ieee80211_supported_band *sband,
-		const struct ieee80211_channel *chan, int n_chan,
-		struct ieee80211_rate *rates, int n_rates)
-{
-	struct ieee80211_sta_ht_cap *ht_cap;
-	void *chanlist;
-	int size;
-
-	size = n_chan * sizeof(*chan);
-	chanlist = devm_kmemdup(dev->mt76.dev, chan, size, GFP_KERNEL);
-	if (!chanlist)
-		return -ENOMEM;
-
-	sband->channels = chanlist;
-	sband->n_channels = n_chan;
-	sband->bitrates = rates;
-	sband->n_bitrates = n_rates;
-
-	ht_cap = &sband->ht_cap;
-	ht_cap->ht_supported = true;
-	ht_cap->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-		      IEEE80211_HT_CAP_GRN_FLD |
-		      IEEE80211_HT_CAP_SGI_20 |
-		      IEEE80211_HT_CAP_SGI_40 |
-		      (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
-
-	ht_cap->mcs.rx_mask[0] = 0xff;
-	ht_cap->mcs.rx_mask[4] = 0x1;
-	ht_cap->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-	ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_2;
-
-	return 0;
-}
-
-static int
-mt76_init_sband_2g(struct mt76x0_dev *dev)
-{
-	dev->mt76.hw->wiphy->bands[NL80211_BAND_2GHZ] = &dev->mt76.sband_2g.sband;
-
-	WARN_ON(dev->ee->reg.start - 1 + dev->ee->reg.num >
-		ARRAY_SIZE(mt76_channels_2ghz));
-
-
-	return mt76_init_sband(dev, &dev->mt76.sband_2g.sband,
-			       mt76_channels_2ghz, ARRAY_SIZE(mt76_channels_2ghz),
-			       mt76x02_rates, ARRAY_SIZE(mt76x02_rates));
-}
-
-static int
-mt76_init_sband_5g(struct mt76x0_dev *dev)
-{
-	dev->mt76.hw->wiphy->bands[NL80211_BAND_5GHZ] = &dev->mt76.sband_5g.sband;
-
-	return mt76_init_sband(dev, &dev->mt76.sband_5g.sband,
-			       mt76_channels_5ghz, ARRAY_SIZE(mt76_channels_5ghz),
-			       mt76x02_rates + 4, ARRAY_SIZE(mt76x02_rates) - 4);
-}
-
-
 int mt76x0_register_device(struct mt76x0_dev *dev)
 {
-	struct ieee80211_hw *hw = dev->mt76.hw;
+	struct mt76_dev *mdev = &dev->mt76;
+	struct ieee80211_hw *hw = mdev->hw;
 	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
@@ -625,27 +528,16 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	/* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
 	 * entry no. 1 like it does in the vendor driver.
 	 */
-	dev->mt76.wcid_mask[0] |= 1;
+	mdev->wcid_mask[0] |= 1;
 
 	/* init fake wcid for monitor interfaces */
-	dev->mt76.global_wcid.idx = 0xff;
-	dev->mt76.global_wcid.hw_key_idx = -1;
+	mdev->global_wcid.idx = 0xff;
+	mdev->global_wcid.hw_key_idx = -1;
 
-	SET_IEEE80211_DEV(hw, dev->mt76.dev);
+	/* init antenna configuration */
+	mdev->antenna_mask = 1;
 
 	hw->queues = 4;
-	ieee80211_hw_set(hw, SIGNAL_DBM);
-	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
-	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
-	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
-	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
-	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
-	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
-	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
-	ieee80211_hw_set(hw, TX_AMSDU);
-	ieee80211_hw_set(hw, TX_FRAG_LIST);
-	ieee80211_hw_set(hw, MFP_CAPABLE);
-
 	hw->max_rates = 1;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
@@ -654,36 +546,21 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
 
-	hw->txq_data_size = sizeof(struct mt76_txq);
-	hw->max_tx_fragments = 16;
-
-	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
-
-	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
-	if (dev->mt76.cap.has_2ghz) {
-		ret = mt76_init_sband_2g(dev);
-		if (ret)
-			return ret;
-	}
-
-	if (dev->mt76.cap.has_5ghz) {
-		ret = mt76_init_sband_5g(dev);
-		if (ret)
-			return ret;
-	}
-
-	dev->mt76.chandef.chan = &dev->mt76.sband_2g.sband.channels[0];
-
 	INIT_DELAYED_WORK(&dev->mac_work, mt76x0_mac_work);
 
-	ret = ieee80211_register_hw(hw);
+	ret = mt76_register_device(mdev, true, mt76x02_rates,
+				   ARRAY_SIZE(mt76x02_rates));
 	if (ret)
 		return ret;
 
+	/* overwrite unsupported features */
+	if (mdev->cap.has_5ghz)
+		mt76x0_vht_cap_mask(&dev->mt76.sband_5g.sband);
+
 	/* check hw sg support in order to enable AMSDU */
-	if (mt76u_check_sg(&dev->mt76))
+	if (mt76u_check_sg(mdev))
 		hw->max_tx_fragments = MT_SG_MAX_SIZE;
 	else
 		hw->max_tx_fragments = 1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index cd260317de27..2918abc95c71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -88,7 +88,6 @@ struct mt76x0_dev {
 
 	const u16 *beacon_offsets;
 
-	u8 macaddr[ETH_ALEN];
 	struct mt76x0_eeprom_params *ee;
 
 	struct mutex reg_atomic_mutex;
-- 
2.7.5

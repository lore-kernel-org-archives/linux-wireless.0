Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45557 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbeBXPy2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 10:54:28 -0500
Received: by mail-wr0-f195.google.com with SMTP id p104so16935362wrc.12
        for <linux-wireless@vger.kernel.org>; Sat, 24 Feb 2018 07:54:28 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76: add mt76_init_stream_cap routine
Date: Sat, 24 Feb 2018 16:54:13 +0100
Message-Id: <20180224155414.31063-3-lorenzo.bianconi@redhat.com> (sfid-20180224_165444_105689_21A9C038)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76_init_stream_cap utility routine to set ht/vht sta capabilities
related to number of streams currently used by the device
(it will be used by mac80211 set_antenna callback)

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 56 +++++++++++++++++++--------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ec94b86a37fd..a2a382a13466 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -119,6 +119,43 @@ static int mt76_led_init(struct mt76_dev *dev)
 	return devm_led_classdev_register(dev->dev, &dev->led_cdev);
 }
 
+static void mt76_init_stream_cap(struct mt76_dev *dev,
+				 struct ieee80211_supported_band *sband,
+				 bool vht)
+{
+	struct ieee80211_sta_ht_cap *ht_cap = &sband->ht_cap;
+	int i, nstream = __sw_hweight8(dev->antenna_mask);
+	struct ieee80211_sta_vht_cap *vht_cap;
+	u16 mcs_map = 0;
+
+	if (nstream > 1)
+		ht_cap->cap |= IEEE80211_HT_CAP_TX_STBC;
+	else
+		ht_cap->cap &= ~IEEE80211_HT_CAP_TX_STBC;
+
+	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
+		ht_cap->mcs.rx_mask[i] = i < nstream ? 0xff : 0;
+
+	if (!vht)
+		return;
+
+	vht_cap = &sband->vht_cap;
+	if (nstream > 1)
+		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
+	else
+		vht_cap->cap &= ~IEEE80211_VHT_CAP_TXSTBC;
+
+	for (i = 0; i < 8; i++) {
+		if (i < nstream)
+			mcs_map |= (IEEE80211_VHT_MCS_SUPPORT_0_9 << (i * 2));
+		else
+			mcs_map |=
+				(IEEE80211_VHT_MCS_NOT_SUPPORTED << (i * 2));
+	}
+	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
+}
+
 static int
 mt76_init_sband(struct mt76_dev *dev, struct mt76_sband *msband,
 		const struct ieee80211_channel *chan, int n_chan,
@@ -128,7 +165,6 @@ mt76_init_sband(struct mt76_dev *dev, struct mt76_sband *msband,
 	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap;
 	void *chanlist;
-	u16 mcs_map;
 	int size;
 
 	size = n_chan * sizeof(*chan);
@@ -153,34 +189,20 @@ mt76_init_sband(struct mt76_dev *dev, struct mt76_sband *msband,
 		       IEEE80211_HT_CAP_GRN_FLD |
 		       IEEE80211_HT_CAP_SGI_20 |
 		       IEEE80211_HT_CAP_SGI_40 |
-		       IEEE80211_HT_CAP_TX_STBC |
 		       (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
 
-	ht_cap->mcs.rx_mask[0] = 0xff;
-	ht_cap->mcs.rx_mask[1] = 0xff;
 	ht_cap->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_4;
 
+	mt76_init_stream_cap(dev, sband, vht);
+
 	if (!vht)
 		return 0;
 
 	vht_cap = &sband->vht_cap;
 	vht_cap->vht_supported = true;
-
-	mcs_map = (IEEE80211_VHT_MCS_SUPPORT_0_9 << (0 * 2)) |
-		  (IEEE80211_VHT_MCS_SUPPORT_0_9 << (1 * 2)) |
-		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (2 * 2)) |
-		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (3 * 2)) |
-		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (4 * 2)) |
-		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (5 * 2)) |
-		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (6 * 2)) |
-		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (7 * 2));
-
-	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
-	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
 	vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC |
-			IEEE80211_VHT_CAP_TXSTBC |
 			IEEE80211_VHT_CAP_RXSTBC_1 |
 			IEEE80211_VHT_CAP_SHORT_GI_80;
 
-- 
2.16.2

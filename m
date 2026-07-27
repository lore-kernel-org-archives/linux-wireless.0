Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576D941DE0C
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=p/Mt+6zMvhzAwYoTl51PNEgd13tTkXPsfj5anGxCWRJXgYPaR8gXfYN41q4xPQyI3bOcGYted3NbUnDNqWuZ0OLuYmpzaYgjW1JAegDDtdQPF3NEUjRHL3u0UwH/OW0k6Zhq3eKEIKgmKriRwaLH67G0KAa4dj6HMUenVz8ijPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=QzrLsMPzLJ1DKoQOfRr36gIYlx10yOLWVkWycEJrzfw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUGJCscD4YVif1cxl4NL/SI4hgJIZ92SVRdFtHHRbX3RtjCChgs35lEKgz8o7YvE/4bSZbZOkBpbFSBNCGtHw9Lh2pldHbGz6TdYZXyxl2osMAN+QsdzxSWRPYe/lkyxECtSmjbihSveNtt/LpgrRa6AGCAYzNtB033Uu5WqOWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=MxB9UVbd; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="MxB9UVbd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5OoyvlPDf5lJF022LIdF/dc+Otp3l3FJv4zkuS+flpA=; b=MxB9UVbdf8Jn6WToWZJe//evhg
	cSzrB1+5YUjYqb2oFI6DXJxgQAB2PREvGOadyk1o5vWWKnZkXlBTT4KDf6lzvFK2cZIS2y0F1BoWd
	Z+mJycnXt7YT+7ZNuO7Ncw8xJmfFoz8Hj+3eyXtzSRAjMy7cAwlteZ6ilb9INF8JpJb4=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsk-008KN0-25
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 08/15] wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1
Date: Mon, 27 Jul 2026 15:04:27 +0000
Message-ID: <20260727150434.1778520-8-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On single-adie mt7986 the only phy is bound to band 1, but its chainmask
is stored unshifted, because dev->chainshift is still zero while the
eeprom is parsed for the main phy. mt7915_set_antenna() on the other
hand shifts by chainshift * band_idx, so the representation of the
chainmask changed as soon as the antenna configuration was touched.
Until then, mt7915_mcu_set_chan_info() passed rx_path = 0 to the
firmware, since shifting the unshifted mask down clears all bits.

Keep the unshifted form for that case and add helpers for the band local
chainmask, so that only the band 1 phy of a dbdc device uses the shifted
form.

Fixes: 3eb50cc90534 ("wifi: mt76: mt7915: rely on band_idx of mt76_phy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7915/eeprom.c |  2 +-
 .../net/wireless/mediatek/mt76/mt7915/main.c   |  6 +++---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt7915/mt7915.h | 18 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt7915/testmode.c   |  5 +----
 5 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index eb92cbf1a284..fe7b29ebc0bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -257,7 +257,7 @@ void mt7915_eeprom_parse_hw_cap(struct mt7915_dev *dev,
 	nss = min_t(u8, min_t(u8, nss_max, nss), path);
 
 	mphy->chainmask = BIT(path) - 1;
-	if (band)
+	if (band && dev->dbdc_support)
 		mphy->chainmask <<= dev->chainshift;
 	mphy->antenna_mask = BIT(nss) - 1;
 	dev->chainmask |= mphy->chainmask;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index d2130226de64..4783e5f52d22 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1138,7 +1138,7 @@ mt7915_set_antenna(struct ieee80211_hw *hw, int radio_idx, u32 tx_ant, u32 rx_an
 	struct mt7915_dev *dev = mt7915_hw_dev(hw);
 	struct mt7915_phy *phy = mt7915_hw_phy(hw);
 	int max_nss = hweight8(hw->wiphy->available_antennas_tx);
-	u8 chainshift = dev->chainshift;
+	u8 shift = mt7915_band_chainshift(phy);
 	u8 band = phy->mt76->band_idx;
 
 	if (!tx_ant || tx_ant != rx_ant || ffs(tx_ant) > max_nss)
@@ -1151,9 +1151,9 @@ mt7915_set_antenna(struct ieee80211_hw *hw, int radio_idx, u32 tx_ant, u32 rx_an
 	/* handle a variant of mt7916/mt7981 which has 3T3R but nss2 on 5 GHz band */
 	if ((is_mt7916(&dev->mt76) || is_mt7981(&dev->mt76)) &&
 	    band && hweight8(tx_ant) == max_nss)
-		phy->mt76->chainmask = (dev->chainmask >> chainshift) << chainshift;
+		phy->mt76->chainmask = (dev->chainmask >> shift) << shift;
 	else
-		phy->mt76->chainmask = tx_ant << (chainshift * band);
+		phy->mt76->chainmask = tx_ant << shift;
 
 	mt76_set_stream_caps(phy->mt76, true);
 	mt7915_set_stream_vht_txbf_caps(phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index c7c1b37e5bbf..f232f689389d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2796,7 +2796,7 @@ int mt7915_mcu_set_chan_info(struct mt7915_phy *phy, int cmd)
 		.center_ch = ieee80211_frequency_to_channel(freq1),
 		.bw = mt76_connac_chan_bw(chandef),
 		.tx_path_num = hweight16(phy->mt76->chainmask),
-		.rx_path = phy->mt76->chainmask >> (dev->chainshift * band),
+		.rx_path = mt7915_band_chainmask(phy),
 		.band_idx = band,
 		.channel_band = ch_band[chandef->chan->band],
 	};
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 0f7e871dc7a1..30fb119ce872 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -399,6 +399,24 @@ mt7915_ext_phy(struct mt7915_dev *dev)
 	return phy->priv;
 }
 
+/* without dbdc, the chainmask is stored unshifted, even if the phy is
+ * bound to band 1
+ */
+static inline u8 mt7915_band_chainshift(struct mt7915_phy *phy)
+{
+	struct mt7915_dev *dev = phy->dev;
+
+	if (!dev->dbdc_support)
+		return 0;
+
+	return phy->mt76->band_idx * dev->chainshift;
+}
+
+static inline u16 mt7915_band_chainmask(struct mt7915_phy *phy)
+{
+	return phy->mt76->chainmask >> mt7915_band_chainshift(phy);
+}
+
 static inline u32 mt7915_check_adie(struct mt7915_dev *dev, bool sku)
 {
 	u32 mask = sku ? MT_CONNINFRA_SKU_MASK : MT_ADIE_TYPE_MASK;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
index 618a5c2bdd29..7576973f4d4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
@@ -694,9 +694,7 @@ mt7915_tm_set_params(struct mt76_phy *mphy, struct nlattr **tb,
 {
 	struct mt76_testmode_data *td = &mphy->test;
 	struct mt7915_phy *phy = mphy->priv;
-	struct mt7915_dev *dev = phy->dev;
-	u32 chainmask = mphy->chainmask, changed = 0;
-	bool ext_phy = phy != &dev->phy;
+	u32 chainmask = mt7915_band_chainmask(phy), changed = 0;
 	int i;
 
 	BUILD_BUG_ON(NUM_TM_CHANGED >= 32);
@@ -705,7 +703,6 @@ mt7915_tm_set_params(struct mt76_phy *mphy, struct nlattr **tb,
 	    td->state == MT76_TM_STATE_OFF)
 		return 0;
 
-	chainmask = ext_phy ? chainmask >> dev->chainshift : chainmask;
 	if (td->tx_antenna_mask > chainmask)
 		return -EINVAL;
 
-- 
2.53.0


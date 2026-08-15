Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6102119F12D
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 12:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786798029; cv=none; b=cXEYgR5flKJ5xtQrULokCd7+dQ6PycUPyNBo0kXsVgjPhX66IHZjipYUUcUtqMe6g8jzBVfDt/bGyS2OTwGCJSZ+imJvzM9M+i7G8UsY8BDdJaosCY2Ypm7lw28BysnbNsnpFpjBub/7aOK/eXnFhDRyvygLHkb0YtT20zlqzWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786798029; c=relaxed/simple;
	bh=xqoxQQ7WZ2nnphgzHgGNzJH7tixpgDPJzhzltuchHQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bRuAobBOuU5C3qsb1xRPUucg4HUXkenNuDbj3O3jgbrta5WsfmEa8XCciaID+Ss14v+QhTv7O/LpUVXyIGkcjJlqQplDLVfAmCgSDfAS/Nk5kUA+qpfygbUNC5cSlDZOVH65kCvvx5PXrfgNnE36z1LgxqcRZeHpIyUl0aU+9qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BcdRrtsI; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcdRrtsI"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c9e7391839cso1772332a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786798026; x=1787402826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UovdtwbKOZJYgbPU5yoW/I+C9znrZRaPv34XykRkKzU=;
        b=BcdRrtsIZSqaAmpjlXoe/hQzcK4WGUOCrgn3+LOh3EX9AYuQGZVTG7iJPOXuX7SrtJ
         8HRGcQ3xEB1duPnfwK3Cc7kedBN7z33wQl6jw2WZTYZjYmFOcNWIV8nnNPR+sd0rv/45
         NTOrwdnRLdAFm4d4itFCcQC71sjhJC/hIQ9mv1u/pFwlwFZ2HVTgOYZc7BZ4oQH6ZFup
         GfRKeNp2pomK4Wc6I3WghFpAbdWU/cYTpcWrhYXlWvPUteYGLJBFjAS1utT+qbs+Wglv
         3hEEg6IFz1klVG1ixlTEF6SRNqS82yZEKupPDBY0W9cloEDCvrDmoUsqQrM/O9RdYHPU
         URoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786798027; x=1787402827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UovdtwbKOZJYgbPU5yoW/I+C9znrZRaPv34XykRkKzU=;
        b=fAiXpI3UVwM02unB2QaG71617AjvGeLHCTyoVV2d79PQMKhI27erwhpuekYjWFji03
         pl3OYOCRzUdYgKJsYnNLu2gLWko6aLfVnCZz4Sc1kKpfBSRXaUDe3py5ropuMcxOkk6n
         SWpzDPm5loySYggI0htFB2ypULpIWYA2C3h7uKAuWrTZu1bjb678YT7fguoiGrCYqhzd
         Fud1qd0UdUsCo8mADNhdmaba+WTUFAy7Wuf1QkFh7l+hf+oN1E5PXMaftIn9Dp78STPk
         vWPg2P7drYREKypaK8MzgnyqW902ih8EhD6paE+aTsQ1kyH/wzfPUZw87FIVT4mq09g3
         VqeA==
X-Gm-Message-State: AOJu0YyE/cOWSj5HNKaG+DaI6pNUvZRPwrMrRksRw9bGt78p2Z+7gETT
	UMSKKgh2rhcNCuarO4SMQ0wpuLv7xaeg2MEfvIY8UJOTKc8q/qZLdLijEl03jmVC
X-Gm-Gg: AR+sD12rmGVvdbhAcFPbYhiloBTtvgwMXOA19nESbQXiYg0OQmZ2IjRobfEQnGRSV93
	UvTlezAPZ1jaaHuEl83n9mUlvqz2Tl61QdTjN55RwGmynouUjItalHaAR/bhnXbUjX9QwCYLbfX
	LrDAI5mg0x1b2oCp5ZrGYZfWJ5/9UjBTu5Bmd+nEu2T/53G6M0jwPbZ61C1JHuLhwNDmbd9eKUZ
	P71AMx2i0Wefr/3VcSChR5mMBdjYz0xfKY3vKZ0Yx2TG0TXVPKENG/8lhYIU1UsG98EKSEAvgrv
	RVZnRyf2nurss9/H0Eg6n6ApFyO5t5HIch9MQ7FcVD9I2bY5Yp5KU/YdU6OHZvVgJ/gRm4Oetc2
	eSFVFHIz56tb/CZ95Yt/KAlGs0LnAzR2++Ch+3Ewm/rdcAMs6N+Tgk5NQtnf/lmawuWDU4cCAN6
	upz1sQKTBi3DD0BwQ+LuKEsmjQ37BhbCaapox3RYSx3XCcSKSv0t7RNcKQTzZ2K95bKP/AkfsEO
	gKAoo2dwZI=
X-Received: by 2002:a05:6a20:7290:b0:3cc:54a6:8a44 with SMTP id adf61e73a8af0-3cc71cd9e2amr13949926637.29.1786798026370;
        Sat, 15 Aug 2026 05:47:06 -0700 (PDT)
Received: from cachyos-x8664.nitc.ac.in ([117.250.237.105])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea302649sm13943893eec.24.2026.08.15.05.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 05:47:05 -0700 (PDT)
From: John Robin <johnrobin044@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: John Robin <johnrobin044@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless-next] wifi: mt76: mt7601u: add support for AP and P2P concurrent modes
Date: Sat, 15 Aug 2026 18:11:48 +0530
Message-ID: <20260815124547.329654-1-johnrobin044@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable Access Point (AP) and Wi-Fi Direct (P2P_GO/P2P_CLIENT) interface
modes on MT7601U device, allowing concurrent Station and AP.

Register AP, P2P_GO, P2P_CLIENT, and ADHOC modes and
defined an interface combination to support 2 concurrent modes.
Set NEEDS_UNIQUE_STA_ADDR to allow mac80211 to generate MACs for
virtual interfaces.

Implement start_ap() and stop_ap() to clear WCID tables and
manage the hardware Pre-TBTT timer. Update mt7601u_bss_info_changed()
to handle BSS_CHANGED_BEACON and BSS_CHANGED_BEACON_ENABLED.

Add beacon frame handling through mt7601u_mac_set_beacon() and
set appropriate SYNC Modes for AP and ADHOC interfaces.

Add bounds checking to rate->idx to prevent out of bounds access and
safely fall back to CCK rates.

Route management and injected frames to the Voice (VO) queue
to bypass firmware queue suspension also avoid requesting ACKs for
multicast frames and skip data rate fallbacks for management frames

All implemented modes were verified to be working. Tested AP mode and
simultaneous STA+AP with iperf3 to verify stability.

Signed-off-by: John Robin <johnrobin044@gmail.com>
---
 drivers/net/wireless/mediatek/mt7601u/init.c  | 31 ++++++-
 drivers/net/wireless/mediatek/mt7601u/mac.c   | 91 +++++++++++++++----
 drivers/net/wireless/mediatek/mt7601u/mac.h   |  3 +-
 drivers/net/wireless/mediatek/mt7601u/main.c  | 56 +++++++++++-
 .../net/wireless/mediatek/mt7601u/mt7601u.h   |  3 +-
 drivers/net/wireless/mediatek/mt7601u/tx.c    | 19 +++-
 6 files changed, 175 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 5d9e952b29664..e871f7b63cb35 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -12,6 +12,25 @@
 
 #include "initvals.h"
 
+static const struct ieee80211_iface_limit if_limits[] = {
+	{ .max = 1, .types = BIT(NL80211_IFTYPE_ADHOC) },
+	{ .max = 8,
+	  .types = BIT(NL80211_IFTYPE_STATION) |
+#ifdef CONFIG_MAC80211_MESH
+		   BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+		   BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO) |
+		   BIT(NL80211_IFTYPE_AP) },
+};
+
+static const struct ieee80211_iface_combination if_comb[] = { {
+	.limits = if_limits,
+	.n_limits = ARRAY_SIZE(if_limits),
+	.max_interfaces = 2,
+	.num_different_channels = 1,
+	.beacon_int_infra_match = true,
+} };
+
 static void
 mt7601u_set_wlan_state(struct mt7601u_dev *dev, u32 val, bool enable)
 {
@@ -599,6 +618,7 @@ int mt7601u_register_device(struct mt7601u_dev *dev)
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
 	hw->max_rates = 1;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
@@ -607,9 +627,16 @@ int mt7601u_register_device(struct mt7601u_dev *dev)
 	hw->vif_data_size = sizeof(struct mt76_vif);
 
 	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
-
+	wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+		BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO) |
+		BIT(NL80211_IFTYPE_ADHOC);
+	wiphy->iface_combinations = if_comb;
+	wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
-	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index ca9cf628eb10d..5e2dec131331c 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -118,19 +118,27 @@ u16 mt76_mac_tx_rate_val(struct mt7601u_dev *dev,
 		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 			bw = 1;
 	} else {
-		const struct ieee80211_rate *r;
-		int band = dev->chandef.chan->band;
-		u16 val;
-
-		r = &dev->hw->wiphy->bands[band]->bitrates[rate->idx];
-		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-			val = r->hw_value_short;
-		else
-			val = r->hw_value;
 
-		phy = val >> 8;
-		rate_idx = val & 0xff;
-		bw = 0;
+		int band = dev->chandef.chan->band;
+		struct ieee80211_supported_band *sband =
+			dev->hw->wiphy->bands[band];
+
+		if (rate->idx < 0 || rate->idx >= sband->n_bitrates) {
+			phy = MT_PHY_TYPE_CCK;
+			rate_idx = 0;
+		} else {
+			const struct ieee80211_rate *r =
+				&sband->bitrates[rate->idx];
+			u16 val;
+
+			if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+				val = r->hw_value_short;
+			else
+				val = r->hw_value;
+
+			phy = val >> 8;
+			rate_idx = val & 0xff;
+		}
 	}
 
 	rateval = FIELD_PREP(MT_RXWI_RATE_MCS, rate_idx);
@@ -264,13 +272,13 @@ void mt7601u_mac_set_short_preamble(struct mt7601u_dev *dev, bool short_preamb)
 		mt76_clear(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
 }
 
-void mt7601u_mac_config_tsf(struct mt7601u_dev *dev, bool enable, int interval)
+void mt7601u_mac_config_tsf(struct mt7601u_dev *dev, struct ieee80211_vif *vif,
+			    bool enable, int interval)
 {
 	u32 val = mt7601u_rr(dev, MT_BEACON_TIME_CFG);
 
-	val &= ~(MT_BEACON_TIME_CFG_TIMER_EN |
-		 MT_BEACON_TIME_CFG_SYNC_MODE |
-		 MT_BEACON_TIME_CFG_TBTT_EN);
+	val &= ~(MT_BEACON_TIME_CFG_TIMER_EN | MT_BEACON_TIME_CFG_SYNC_MODE |
+		 MT_BEACON_TIME_CFG_TBTT_EN | MT_BEACON_TIME_CFG_BEACON_TX);
 
 	if (!enable) {
 		mt7601u_wr(dev, MT_BEACON_TIME_CFG, val);
@@ -279,9 +287,22 @@ void mt7601u_mac_config_tsf(struct mt7601u_dev *dev, bool enable, int interval)
 
 	val &= ~MT_BEACON_TIME_CFG_INTVAL;
 	val |= FIELD_PREP(MT_BEACON_TIME_CFG_INTVAL, interval << 4) |
-		MT_BEACON_TIME_CFG_TIMER_EN |
-		MT_BEACON_TIME_CFG_SYNC_MODE |
-		MT_BEACON_TIME_CFG_TBTT_EN;
+	       MT_BEACON_TIME_CFG_TIMER_EN | MT_BEACON_TIME_CFG_TBTT_EN;
+
+	/* AP Mode */
+	if (vif && (vif->type == NL80211_IFTYPE_AP ||
+		    vif->type == NL80211_IFTYPE_P2P_GO))
+		val |= FIELD_PREP(MT_BEACON_TIME_CFG_SYNC_MODE, 3) |
+		       MT_BEACON_TIME_CFG_BEACON_TX;
+	/* IBSS / Ad-Hoc Mode */
+	else if (vif && vif->type == NL80211_IFTYPE_ADHOC)
+		val |= FIELD_PREP(MT_BEACON_TIME_CFG_SYNC_MODE, 2) |
+		       MT_BEACON_TIME_CFG_BEACON_TX;
+	/* Station mode */
+	else
+		val |= FIELD_PREP(MT_BEACON_TIME_CFG_SYNC_MODE, 1);
+
+	mt7601u_wr(dev, MT_BEACON_TIME_CFG, val);
 }
 
 static void mt7601u_check_mac_err(struct mt7601u_dev *dev)
@@ -393,6 +414,38 @@ void mt7601u_mac_set_ampdu_factor(struct mt7601u_dev *dev)
 		   FIELD_PREP(MT_MAX_LEN_CFG_AMPDU, min_factor));
 }
 
+int mt7601u_mac_set_beacon(struct mt7601u_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_bss_conf *info)
+{
+	struct sk_buff *skb = ieee80211_beacon_get(dev->hw, vif, 0);
+	struct mt76_txwi *txwi;
+	int err, words;
+
+	if (!skb)
+		return 0;
+
+	/* USB devices already reserve enough skb headroom */
+	err = skb_cow_head(skb, sizeof(struct mt76_txwi));
+	if (err) {
+		dev_kfree_skb(skb);
+		return err;
+	}
+
+	txwi = (struct mt76_txwi *)skb_push(skb, sizeof(struct mt76_txwi));
+	memset(txwi, 0, sizeof(*txwi));
+
+	txwi->wcid = 0;
+	txwi->len_ctl = cpu_to_le16(skb->len - sizeof(struct mt76_txwi));
+	txwi->rate_ctl = cpu_to_le16(0);
+
+	words = DIV_ROUND_UP(skb->len, 4);
+	err = mt7601u_burst_write_regs(dev, MT_BEACON_BASE,
+				       (const u32 *)skb->data, words);
+	dev_kfree_skb(skb);
+
+	return err;
+}
+
 static void
 mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 {
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.h b/drivers/net/wireless/mediatek/mt7601u/mac.h
index 54bd4fac54d83..528756ccf4725 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.h
@@ -167,5 +167,6 @@ struct mt76_tx_status
 mt7601u_mac_fetch_tx_status(struct mt7601u_dev *dev);
 void mt76_send_tx_status(struct mt7601u_dev *dev, struct mt76_tx_status *stat);
 void mt7601u_set_macaddr(struct mt7601u_dev *dev, const u8 *addr);
-
+int mt7601u_mac_set_beacon(struct mt7601u_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_bss_conf *info);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index 05ba43e1985c8..4389e332dfe19 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -149,7 +149,7 @@ mt7601u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 *	 rt2x00 doesn't seem to be bothered though.
 		 */
 		if (is_zero_ether_addr(info->bssid))
-			mt7601u_mac_config_tsf(dev, false, 0);
+			mt7601u_mac_config_tsf(dev, vif, false, 0);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
@@ -161,7 +161,20 @@ mt7601u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INT)
-		mt7601u_mac_config_tsf(dev, true, info->beacon_int);
+		mt7601u_mac_config_tsf(dev, vif, true, info->beacon_int);
+
+	if ((changed & BSS_CHANGED_BEACON) && vif->type == NL80211_IFTYPE_AP)
+		mt7601u_mac_set_beacon(dev, vif, info);
+
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
+	    vif->type == NL80211_IFTYPE_AP) {
+		if (info->enable_beacon)
+			mt76_set(dev, MT_BEACON_TIME_CFG,
+				 MT_BEACON_TIME_CFG_BEACON_TX);
+		else
+			mt76_clear(dev, MT_BEACON_TIME_CFG,
+				   MT_BEACON_TIME_CFG_BEACON_TX);
+	}
 
 	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
 		mt7601u_mac_set_protection(dev, info->use_cts_prot,
@@ -183,6 +196,43 @@ mt7601u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&dev->mutex);
 }
 
+static int mt7601u_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_bss_conf *link_conf)
+{
+	struct mt7601u_dev *dev = hw->priv;
+	int err = 0;
+
+	mutex_lock(&dev->mutex);
+
+	/* Clear the wcid Table */
+	for (int i = 1; i < 128; i++)
+		mt7601u_mac_wcid_setup(dev, i, 0, NULL);
+
+	/* Set pre TBTT to 6ms */
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT, 6);
+	mt76_set(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN);
+
+	mt7601u_mac_config_tsf(dev, vif, true, link_conf->beacon_int);
+
+	mutex_unlock(&dev->mutex);
+
+	return err;
+}
+
+static void mt7601u_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_bss_conf *link_conf)
+{
+	struct mt7601u_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mutex);
+
+	mt7601u_mac_config_tsf(dev, vif, false, 0);
+
+	mt76_clear(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN);
+
+	mutex_unlock(&dev->mutex);
+}
+
 static int
 mt76_wcid_alloc(struct mt7601u_dev *dev)
 {
@@ -419,6 +469,8 @@ const struct ieee80211_ops mt7601u_ops = {
 	.config = mt7601u_config,
 	.configure_filter = mt76_configure_filter,
 	.bss_info_changed = mt7601u_bss_info_changed,
+	.start_ap = mt7601u_start_ap,
+	.stop_ap = mt7601u_stop_ap,
 	.sta_add = mt7601u_sta_add,
 	.sta_remove = mt7601u_sta_remove,
 	.sta_notify = mt7601u_sta_notify,
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index 118d437078537..7366e1c476339 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -359,7 +359,8 @@ void mt7601u_mac_work(struct work_struct *work);
 void mt7601u_mac_set_protection(struct mt7601u_dev *dev, bool legacy_prot,
 				int ht_mode);
 void mt7601u_mac_set_short_preamble(struct mt7601u_dev *dev, bool short_preamb);
-void mt7601u_mac_config_tsf(struct mt7601u_dev *dev, bool enable, int interval);
+void mt7601u_mac_config_tsf(struct mt7601u_dev *dev, struct ieee80211_vif *vif,
+			    bool enable, int interval);
 void
 mt7601u_mac_wcid_setup(struct mt7601u_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
 void mt7601u_mac_set_ampdu_factor(struct mt7601u_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt7601u/tx.c b/drivers/net/wireless/mediatek/mt7601u/tx.c
index 5aeeac0dd9fe7..47c78c4ff5144 100644
--- a/drivers/net/wireless/mediatek/mt7601u/tx.c
+++ b/drivers/net/wireless/mediatek/mt7601u/tx.c
@@ -27,6 +27,14 @@ static u8 q2hwq(u8 q)
 static u8 skb2q(struct sk_buff *skb)
 {
 	int qid = skb_get_queue_mapping(skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (ieee80211_is_mgmt(hdr->frame_control) ||
+	    (info->flags & IEEE80211_TX_CTL_INJECTED)) {
+		skb_set_queue_mapping(skb, MT_TXQ_VO);
+		return q2hwq(MT_TXQ_VO);
+	}
 
 	if (WARN_ON(qid >= MT_TXQ_PSD)) {
 		qid = MT_TXQ_BE;
@@ -134,6 +142,9 @@ mt7601u_push_txwi(struct mt7601u_dev *dev, struct sk_buff *skb,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct mt76_txwi *txwi;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	bool is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
+	bool is_mcast = is_multicast_ether_addr(hdr->addr1);
 	unsigned long flags;
 	bool is_probe;
 	u32 pkt_id;
@@ -148,14 +159,14 @@ mt7601u_push_txwi(struct mt7601u_dev *dev, struct sk_buff *skb,
 				       info->control.rates, 1);
 
 	spin_lock_irqsave(&dev->lock, flags);
-	if (rate->idx < 0 || !rate->count)
+	if (!is_mgmt && (rate->idx < 0 || !rate->count))
 		rate_ctl = wcid->tx_rate;
 	else
 		rate_ctl = mt76_mac_tx_rate_val(dev, rate, &nss);
 	spin_unlock_irqrestore(&dev->lock, flags);
 	txwi->rate_ctl = cpu_to_le16(rate_ctl);
 
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) && sta && !is_mcast)
 		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
 		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
@@ -197,6 +208,8 @@ void mt7601u_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	struct mt76_sta *msta = NULL;
 	struct mt76_wcid *wcid = dev->mon_wcid;
 	struct mt76_txwi *txwi;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	bool is_mcast = is_multicast_ether_addr(hdr->addr1);
 	int pkt_len = skb->len;
 	int hw_q = skb2q(skb);
 
@@ -211,7 +224,7 @@ void mt7601u_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	if (sta) {
 		msta = (struct mt76_sta *) sta->drv_priv;
 		wcid = &msta->wcid;
-	} else if (vif) {
+	} else if (vif && is_mcast) {
 		struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
 
 		wcid = &mvif->group_wcid;
-- 
2.55.0


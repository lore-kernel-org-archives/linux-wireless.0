Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893853163A
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072035; cv=none; b=n0Ol5LULvPx8YL2dXA2H+K5OVhELIp+aezgQEkh8FpRzAxELZs3mi9D7XZAK+GQLhj4g8nWvzWYIJON8eDlDwMlkfPtDt7li7CjtvQ8REEtO8gT3XAR2dnKB6ghTSjJqPA50EfCc2TYZMbbMGFQasHoOcFPeTiknTnLVdiody1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072035; c=relaxed/simple;
	bh=Yndj3FdWcc4xKFPHheyQ6YA1iat0suHexOzi3/oq7/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0JPABLjcJ91Bsf49ZIUWZem57aIBu5wOVq3IynvOjlBmdJ4LLiXWMXrcqPBoFxr4sdQu9Ir5QxoF59IGFgS8TlyGwKyLiTnIrI+R85gcIUikAoBb9A4tfgYa/70QvlsxIOXf7RcfK3zHl5R8wR3l49lsKGkTRg2MDx0qPRuN3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=BtYqXEL3; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="BtYqXEL3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zOiRwo0ERhcZ56lLLtppPsET2rdsLjygXP/ilnk9PME=; b=BtYqXEL3fVS2XW5rg+PSVXo5x3
	BmjnxEPeIETuj9MWYuVaFIBQWiwNY4uX9AY1dS6+g4aDIv5y0txYiu7hnRX+wAXk9XlHnookUoFg2
	oiHrOeoU0VN1MBkw9Sp+8S9tcJd35EE8+Xe5minZAwCK3W6scVzt6S0J3WUiq0xkXZxw=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVW-00807z-1b;
	Tue, 22 Sep 2026 12:13:50 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 16/16] wifi: mt76: mt7996: support SCS and MSCS
Date: Tue, 22 Sep 2026 12:13:43 +0200
Message-ID: <3788e2e605155c0753afbee78f17e0aaa8b13155.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
References: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise both extended features and the SCS Traffic Description Support
EHT MAC capability. mac80211 classifies frames in software, so the
driver only needs to pass the QoS Characteristics element of an SCS
stream to the firmware, which uses it to schedule the uplink traffic of
the stream.

The firmware only supports uplink streams, so descriptors with a
downlink or direct link traffic description are declined. A removal, or
a change without a traffic description, deletes the stream from the
firmware.

SCS descriptors belong to the MLD, while a firmware stream belongs to a
link station entry. Program each stream on every active link and decline
the descriptor if any link fails.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 64 +++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 39 +++++++++-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |  4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  2 +-
 5 files changed, 112 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index fb635a092584..ca161d644d72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -526,6 +526,8 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_SET_SCAN_DWELL);
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_SCS);
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_MSCS);
 
 	if (mt7996_eeprom_has_background_radar(dev) &&
 	    (!mdev->dev->of_node ||
@@ -1580,6 +1582,7 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 
 	eht_cap_elem->mac_cap_info[0] =
 		IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
+		IEEE80211_EHT_MAC_CAP0_SCS_TRAFFIC_DESC |
 		u8_encode_bits(IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_11454,
 			       IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_MASK);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index e218856b0c45..6b2d24fe70f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2051,6 +2051,69 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
+/* SCS descriptors belong to the MLD, firmware streams to a link */
+static int mt7996_sta_scs_program(struct mt7996_dev *dev,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta,
+				  const struct cfg80211_scs_desc *desc,
+				  bool del)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct ieee80211_link_sta *link_sta;
+	unsigned int link_id;
+	bool any = false;
+	int ret = 0;
+
+	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+		struct mt7996_sta_link *msta_link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (!msta_link || !msta_link->wcid.sta)
+			continue;
+
+		any = true;
+		if (mt7996_mcu_set_scs(dev, msta_link->wcid.idx, desc, del))
+			ret = -EIO;
+	}
+
+	return any ? ret : -EIO;
+}
+
+static int mt7996_sta_set_scs(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct cfg80211_scs_desc * const *desc,
+			      struct cfg80211_scs_result *res, u8 n_desc)
+{
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	u8 i;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	for (i = 0; i < n_desc; i++) {
+		const struct cfg80211_scs_desc *d = desc[i];
+		bool del = d->req_type == NL80211_SCS_REQ_REMOVE ||
+			   !d->qos_char;
+
+		/* The firmware only supports uplink streams */
+		if (!del && ieee80211_qos_char_direction(d->qos_char) !=
+			    IEEE80211_QOS_CHAR_DIR_UPLINK) {
+			res[i].status = WLAN_STATUS_REQUEST_DECLINED;
+			continue;
+		}
+
+		if (!mt7996_sta_scs_program(dev, vif, sta, d, del) || del)
+			continue;
+
+		mt7996_sta_scs_program(dev, vif, sta, d, true);
+		res[i].status = WLAN_STATUS_REQUEST_DECLINED;
+	}
+
+	mutex_unlock(&dev->mt76.mutex);
+
+	return 0;
+}
+
 static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 struct ieee80211_sta *sta,
@@ -2588,6 +2651,7 @@ const struct ieee80211_ops mt7996_ops = {
 	.set_coverage_class = mt7996_set_coverage_class,
 	.sta_statistics = mt7996_sta_statistics,
 	.sta_set_4addr = mt7996_sta_set_4addr,
+	.sta_set_scs = mt7996_sta_set_scs,
 	.sta_set_decap_offload = mt7996_sta_set_decap_offload,
 	.add_twt_setup = mt7996_mac_add_twt_setup,
 	.twt_teardown_request = mt7996_twt_teardown_request,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index cd7587ce5b8a..fceffdeb8ca5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2616,6 +2616,45 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev, struct mt7996_sta *msta,
 	return ret;
 }
 
+int mt7996_mcu_set_scs(struct mt7996_dev *dev, u16 wlan_idx,
+		       const struct cfg80211_scs_desc *desc, bool del)
+{
+#define MURU_QOS_FLAG_UPDATE	20
+#define MURU_QOS_FLAG_DELETE	21
+	struct {
+		u8 __rsv1[4];
+
+		__le16 tag;
+		__le16 len;
+		__le32 qos_flag;
+		__le16 wlan_idx;
+		u8 __rsv2[12];
+		u8 dir;
+		u8 __rsv3[4];
+		u8 scs_id;
+		u8 qos_ie[44];
+	} __packed req = {
+		.tag = cpu_to_le16(UNI_CMD_MURU_SET_QOS_CFG),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.wlan_idx = cpu_to_le16(wlan_idx),
+		.scs_id = desc->id,
+	};
+
+	if (del) {
+		req.qos_flag = cpu_to_le32(MURU_QOS_FLAG_DELETE);
+	} else {
+		if (desc->qos_char_len > sizeof(req.qos_ie))
+			return -EINVAL;
+
+		req.qos_flag = cpu_to_le32(MURU_QOS_FLAG_UPDATE);
+		req.dir = ieee80211_qos_char_direction(desc->qos_char);
+		memcpy(req.qos_ie, desc->qos_char, desc->qos_char_len);
+	}
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_WMWA_UNI_CMD(MURU), &req,
+				 sizeof(req), true);
+}
+
 static int
 mt7996_mcu_add_group(struct mt7996_dev *dev, struct mt7996_vif_link *link,
 		     struct mt76_wcid *wcid)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 74b70fb6da3d..efd474cf8da9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -991,6 +991,10 @@ enum {
 };
 
 enum {
+	UNI_CMD_MURU_SET_QOS_CFG = 0xfe,
+};
+
+enum {
 	UNI_VOW_DRR_CTRL,
 	UNI_VOW_RX_AT_AIRTIME_EN = 0x0b,
 	UNI_VOW_RX_AT_AIRTIME_CLR_EN = 0x0e,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 2a0cdb56f822..ebd55d8da654 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -754,6 +754,8 @@ int mt7996_mcu_set_fixed_rate_ctrl(struct mt7996_dev *dev,
 				   void *data, u16 version);
 int mt7996_mcu_set_fixed_field(struct mt7996_dev *dev, struct mt7996_sta *msta,
 			       void *data, u8 link_id, u32 field);
+int mt7996_mcu_set_scs(struct mt7996_dev *dev, u16 wlan_idx,
+		       const struct cfg80211_scs_desc *desc, bool del);
 int mt7996_mcu_set_eeprom(struct mt7996_dev *dev);
 int mt7996_mcu_get_eeprom(struct mt7996_dev *dev, u32 offset, u8 *buf, u32 buf_len,
 			  enum mt7996_eeprom_mode mode);
-- 
git-series 0.9.1

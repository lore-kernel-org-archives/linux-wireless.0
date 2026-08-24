Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40E72BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601220; cv=none; b=izkw7LAzXj6DlYfVgm2e/jm6DkjSsPlSXm+jqN/2bXcStl6S6FapUJP5A6xJ9hglXtbuFXrlpNoIYYllDMtwWOrIDYuIdcppPKd76sEI0ycp2yaBMJ1vDrAR8wz/z3uery9aLyhgVQrYMFMSZBP17LSSH4xifD5A2sqb0EucGsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601220; c=relaxed/simple;
	bh=QD6QRDvhWfi8pymVePzdu2Uv71sIPsj43L1erlNXmkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnUSaKaWcIEu0c/Oo2f06wWnQDL0jl2pCOitjGN9BlQifUk1jVx9YpF8ZDPw83OmxpcVo8nI5d7M0ufx0UkICk2o+hL/kKDu8kkH4hqguNnB6jsbjiG183AmaRP6ONtkXWui0HKNvUo6/F4kxljF48KJFnTjLM6hKbNGuyinV/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-44aeefa1c00so88113fac.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601218; x=1788206018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JIDeRFyrO7Kp+QOJ1Y/KCDJtxTfEq+gujQbLv/1UDNU=;
        b=gQcXai+uNjem2WdvW4KJW1SxMZn98V27RPnAgWYfwOLsGx3Eslis4NJyC10lSPw08u
         qSUySasEXZR0ESQBFpnpF121PSAGEREXvezEfeZuQAXYHnfdeANnIXva4Lv6XlU1uCOt
         z31h9ioz/e1ExDdSRPnulIY+emcewSEQzJpQ23+mbO6XZy98v4QgwlJ12sUjAKA8OMp7
         4/qjkp5n3NBsqpqLsUn+6r8t7kFoycDsQsJRTG80AOMq6wbxZ300yvBMWCAVo59YOl06
         S53BBtI0Gj67lCc5CO/R3WmrIou/rc8poxOgfWt/kHPsoRs/QaG366hHkoAxs44cAXZ7
         IuyA==
X-Gm-Message-State: AFuF++lkQmRr+cIjCXNnMZZTzgvc68V/+Epe/OO7U+iQWzWIvjwZ0iZq
	+V/Pp+WecVgNfzjOMHockTWSqATsXM2Ve0xJL9mYwYOFzLVnDDjDU0q4
X-Gm-Gg: AR+sD13fA5JxikxmcbdE5ZUHpEYRnmJ7oeN5G1IbBw4IFlWBJDun8lK6tZfdCEkhwvc
	ee+dHzPSZ7mXAxtingT4Y/BS3CgYxKWF/RtFm6+hhCqYIy7PVFJvypXwmXfa2MSa7IjPXEKmlKT
	Cc36qNjOPPrw0N9bESxqebMsWuMdvKAJjNqEC8SoFgiqzyo2lCTQ0HNSjUFYZigkyXwPZF8NNE5
	EkdtpS8hClOpr8M9UC5DY61WyvHSZyxCkd6roIaWclQTis4FpqCTWij/29Z5MqytBnHBIGRSLJt
	XrervYg8DEdG3KKjukc1gTSpiK3hZgFGsk/jtYz2RMuDbmi5CjX5FTILofdd2bBBq/EvGUk6uuv
	ieCHh8f7ymPgLT7omXgV0ym+B4JA6F3F2ul/+xpaBy7Liu/7+VwxeO4cVvG1w8G/YUkqnesfmG+
	T9dmIf5DXamvfh+BAOmCfvWjgX0C5fi6EeDAsYp4WNCOADX3P/s9xwa+PMZ2O7Jx3nYRPKnIuU5
	cBftdde2+sr6pSGcyBKQWSzJSgYOmFYZL1TW/4mtp5Y
X-Received: by 2002:a05:6870:b289:b0:43b:516f:5f0e with SMTP id 586e51a60fabf-46448da7a64mr1225925fac.9.1787601217452;
        Mon, 24 Aug 2026 12:53:37 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:36 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 13/15] wifi: mt76: mt7925: configure NAN PHY setting on enable
Date: Mon, 24 Aug 2026 14:52:25 -0500
Message-ID: <20260824195227.12589-14-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824195227.12589-1-sean.wang@kernel.org>
References: <20260824195227.12589-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stella Liu <yu-ching.liu@mediatek.com>

Implement NAN_UNI_CMD_UPDATE_PHY_SETTING (tag=18) to configure the
BSS-level PHY parameters that the FW NAN scheduler uses when it
switches channels.

The command carries separate 2G and 5G PHY settings, each with its
own phy type, rate sets and protection modes.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  6 +-
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 74 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   | 29 ++++++++
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 77420bb6f977..93de42c2bfd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2593,8 +2593,12 @@ static int mt7925_start_nan(struct ieee80211_hw *hw,
 		goto out;
 
 	err = mt7925_nan_enable(vif, dev, conf);
-	if (err)
+	if (err) {
 		mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf, NULL, false);
+		goto out;
+	}
+
+	err = mt7925_nan_update_phy_setting(dev);
 
 out:
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 53736b156f69..1f695f0c4473 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -193,6 +193,80 @@ mt7925_nan_sync_rssi_tlv(struct sk_buff *skb, struct cfg80211_nan_conf *conf)
 	return 0;
 }
 
+/* FW rate set bit definitions (matches FW wlan_def_cmm.h) */
+#define NAN_RATE_SET_BIT_1M	BIT(0)
+#define NAN_RATE_SET_BIT_2M	BIT(1)
+#define NAN_RATE_SET_BIT_5_5M	BIT(2)
+#define NAN_RATE_SET_BIT_11M	BIT(3)
+#define NAN_RATE_SET_BIT_6M	BIT(6)
+#define NAN_RATE_SET_BIT_9M	BIT(7)
+#define NAN_RATE_SET_BIT_12M	BIT(8)
+#define NAN_RATE_SET_BIT_18M	BIT(9)
+#define NAN_RATE_SET_BIT_24M	BIT(10)
+#define NAN_RATE_SET_BIT_36M	BIT(11)
+#define NAN_RATE_SET_BIT_48M	BIT(12)
+#define NAN_RATE_SET_BIT_54M	BIT(13)
+
+#define NAN_RATE_SET_ALL_A	(NAN_RATE_SET_BIT_6M | NAN_RATE_SET_BIT_9M | \
+				 NAN_RATE_SET_BIT_12M | NAN_RATE_SET_BIT_18M | \
+				 NAN_RATE_SET_BIT_24M | NAN_RATE_SET_BIT_36M | \
+				 NAN_RATE_SET_BIT_48M | NAN_RATE_SET_BIT_54M)
+
+/* 5G basic: 6M+12M+24M (OFDM) */
+#define NAN_BASIC_RATE_SET_5G	(NAN_RATE_SET_BIT_6M | NAN_RATE_SET_BIT_12M | \
+				 NAN_RATE_SET_BIT_24M)
+
+/* GF_MODE_DISALLOWED = 2, RIFS_MODE_DISALLOWED = 1 */
+#define NAN_GF_MODE_DISALLOWED		2
+#define NAN_RIFS_MODE_DISALLOWED	1
+
+int mt7925_nan_update_phy_setting(struct mt792x_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mphy;
+	struct ieee80211_supported_band *sband_5g;
+	struct mt7925_nan_phy_setting *phy;
+	struct {
+		u8 rsv[4];
+		struct mt7925_nan_update_phy_setting_tlv tlv;
+	} req = {};
+
+	sband_5g = mphy->hw->wiphy->bands[NL80211_BAND_5GHZ];
+
+	req.tlv.tag = cpu_to_le16(NAN_UNI_CMD_UPDATE_PHY_SETTING);
+	req.tlv.len = cpu_to_le16(sizeof(req.tlv));
+
+	/* 2G: ERP + HT (no CCK/HR_DSSS - NAN uses OFDM only) */
+	phy = &req.tlv.phy_2g;
+	phy->phy_type_set = PHY_TYPE_BIT_ERP | PHY_TYPE_BIT_HT;
+	phy->non_ht_basic_phy_type = PHY_TYPE_ERP_INDEX;
+	phy->use_short_preamble = 1;
+	phy->use_short_slot_time = 1;
+	phy->operational_rate_set = cpu_to_le16(NAN_RATE_SET_ALL_A);
+	phy->bss_basic_rate_set = cpu_to_le16(NAN_BASIC_RATE_SET_5G);
+	phy->gf_operation_mode = cpu_to_le32(NAN_GF_MODE_DISALLOWED);
+	phy->rifs_operation_mode = cpu_to_le32(NAN_RIFS_MODE_DISALLOWED);
+
+	/* 5G: OFDM + HT + VHT (NAN_MODE_11A) */
+	phy = &req.tlv.phy_5g;
+	phy->phy_type_set = PHY_TYPE_BIT_OFDM | PHY_TYPE_BIT_HT |
+			    PHY_TYPE_BIT_VHT;
+	phy->non_ht_basic_phy_type = PHY_TYPE_OFDM_INDEX;
+	phy->use_short_preamble = 1;
+	phy->use_short_slot_time = 1;
+	phy->operational_rate_set = cpu_to_le16(NAN_RATE_SET_ALL_A);
+	phy->bss_basic_rate_set = cpu_to_le16(NAN_BASIC_RATE_SET_5G);
+	phy->gf_operation_mode = cpu_to_le32(NAN_GF_MODE_DISALLOWED);
+	phy->rifs_operation_mode = cpu_to_le32(NAN_RIFS_MODE_DISALLOWED);
+
+	/* VHT basic MCS set from sband capability */
+	if (sband_5g && sband_5g->vht_cap.vht_supported)
+		phy->vht_basic_mcs_set =
+			sband_5g->vht_cap.vht_mcs.rx_mcs_map;
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(NAN),
+				 &req, sizeof(req), true);
+}
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index c9207b5c899e..1e8f5b76fc3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -83,6 +83,7 @@ enum nan_uni_cmd_tag {
 	NAN_UNI_CMD_MANAGE_PEER_SCH_RECORD	= 12,
 	NAN_UNI_CMD_MAP_STA_RECORD		= 13,
 	NAN_UNI_CMD_UPDATE_ULW			= 16,
+	NAN_UNI_CMD_UPDATE_PHY_SETTING		= 18,
 	NAN_UNI_CMD_UPDATE_AVAILABILITY_CTRL	= 20,
 	NAN_UNI_CMD_UPDATE_PEER_CAPABILITY	= 21,
 	NAN_UNI_CMD_CHANGE_NMI_ADDRESS		= 24,
@@ -439,6 +440,34 @@ struct mt7925_nan_sched_map_sta_rec_tlv {
 	u8 reserved[2];
 } __packed __aligned(4);
 
+/* Matches FW NAN_PHY_SETTING_T (enum fields are 4 bytes on ARM) */
+struct mt7925_nan_phy_setting {
+	u8 phy_type_set;
+	u8 non_ht_basic_phy_type;
+	u8 use_short_preamble;
+	u8 use_short_slot_time;
+	__le16 operational_rate_set;
+	__le16 bss_basic_rate_set;
+	__le16 vht_basic_mcs_set;
+	u8 erp_protect_mode;
+	u8 ht_op_info1;
+	__le16 ht_op_info2;
+	__le16 ht_op_info3;
+	__le32 ht_protect_mode;
+	__le32 gf_operation_mode;
+	__le32 rifs_operation_mode;
+} __packed;
+
+/* Matches FW NAN_SCHED_CMD_UPDATE_PHY_PARAM_T */
+struct mt7925_nan_update_phy_setting_tlv {
+	__le16 tag;
+	__le16 len;
+	struct mt7925_nan_phy_setting phy_2g;
+	struct mt7925_nan_phy_setting phy_5g;
+} __packed __aligned(4);
+
+int mt7925_nan_update_phy_setting(struct mt792x_dev *dev);
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf);
-- 
2.43.0


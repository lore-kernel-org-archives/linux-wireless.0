Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD153ACA5B
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883076; cv=none; b=iBALmqxI2NE04L1VV6OJ/tApUQYV3bJsW+JPkEZrVY2qkCdrl393AUkj4qfpPcXNAPE8RL4LXKd9GV3uv8gipNfizDUf1DahuDE6Qwc/xjYs4Ro7oHX+xjFBafVzXGp+QLoN6xYe1o30ud3K5LECDh84qrxPRorE6x6AXNFXy7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883076; c=relaxed/simple;
	bh=ze5FFbtRX4ws2qC6Y4WNn1gqRHX46DzKfU/L4jNF95I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ddw4K1ZLKy0b9m5OC0gQ41e3O1KS1pV/5v0TX8ves1p0hUncMlNZbufgjtfBiTTHgMklN9HQpQ95U0A/w/1+ciujAQiGkcNeXg4bdoMpT5RJjAts8nNnj/x3dksnau/TM86ByQSwtbKpK9fyfkp5HJdT92Mc7A+07nvmO09TKpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nce+SbSm; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nce+SbSm"
X-UUID: cecef6a0873c11f18dc8c9802ae25ab1-20260724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Ofjw5KpwRcWqy4KTbzRwNRFGmNPljX+/Kwy0ky5mHr8=;
	b=nce+SbSme3kGA24nXLx88TNiljWykknxf77uu5M5iABXTIjjQuesskK9En6v0fqtU4cCraLYkcwUJpTbSuV1UO+2VV751xbx1il0jWY3jdnpU6PiH6Sv6keLXWo4Y5P9cQbhU8bhHOwgi+jn1cFDBiBmZ0IefVQ8tMe+2Un0iV4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:9527df3c-22ad-4d05-bb57-c762d8d5597d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:b5078219-ab14-4403-9336-76696324c5a8,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cecef6a0873c11f18dc8c9802ae25ab1-20260724
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1693244723; Fri, 24 Jul 2026 16:51:06 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Jul 2026 16:51:05 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Jul 2026 16:51:05 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: connac3: implement 6GHz power type detection and dynamic CLC filtering
Date: Fri, 24 Jul 2026 16:51:03 +0800
Message-ID: <20260724085103.3155942-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

This patch enhances 6GHz regulatory handling by implementing proper
power type detection and selective CLC (Country Location Configuration)
table filtering.

Changes in main.c:
1. Add mt7925_regd_set_6ghz_power_type() with multi-source channel
   detection fallback mechanism:
   - Primary: link_conf->chanreq.oper.chan (per-link BSS config)
   - Secondary: vif->bss_conf.chanreq.oper.chan (default link)
   - Tertiary: phy->mt76->chandef.chan (PHY layer)
2. Move mt7925_calc_vif_num() and mt7925_regd_set_6ghz_power_type()
   before mt7925_mac_link_sta_add() to avoid implicit declaration
3. Call mt7925_regd_set_6ghz_power_type() in station add/remove paths

Changes in mcu.c:
1. Add power_type_change parameter to __mt7925_mcu_set_clc() and
   related functions to distinguish between regulatory updates and
   power type changes
2. Implement CLC table filtering logic:
   - When power_type_change=false (from mt7925_mcu_regd_update):
     Send 2/5G ('-'), 6G LPI ('0'), and 6G VLP ('2') tables
   - When power_type_change=true (from mt7925_regd_set_6ghz_power_type):
     Send only the specific 6G power table matching current power_type
3. Map power_type to CLC type codes:
   MT_AP_LPI -> '0', MT_AP_SP -> '1', MT_AP_VLP -> '2'
4. Add env_6g field to CLC request structure to pass power type to FW

This fixes the issue where vif->bss_conf.chanreq.oper.chan was NULL
during early connection stages, and enables proper 6GHz power type
switching based on regulatory requirements.

Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 84 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 46 ++++++++--
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  4 +-
 .../net/wireless/mediatek/mt76/mt7925/regd.c  | 10 +--
 4 files changed, 133 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a9059866b701..5f6ad84da70a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -884,6 +884,86 @@ mt7925_get_rates_table(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return mvif->basic_rates_idx;
 }
 
+static void
+mt7925_calc_vif_num(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	u32 *num = priv;
+
+	if (!priv)
+		return;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		*num += 1;
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+mt7925_regd_set_6ghz_power_type(struct ieee80211_vif *vif,
+				struct ieee80211_bss_conf *link_conf,
+				bool is_add)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt792x_phy *phy = mvif->phy;
+	struct mt792x_dev *dev = phy->dev;
+	struct ieee80211_channel *chan = NULL;
+	u32 valid_vif_num = 0;
+	enum mt792x_reg_power_type old_power_type;
+	bool power_type_changed = false;
+
+	old_power_type = phy->power_type;
+
+	/* Try to get channel from link_conf first, then vif->bss_conf, then phy */
+	if (link_conf && link_conf->chanreq.oper.chan)
+		chan = link_conf->chanreq.oper.chan;
+	else if (vif->bss_conf.chanreq.oper.chan)
+		chan = vif->bss_conf.chanreq.oper.chan;
+	else if (phy->mt76->chandef.chan)
+		chan = phy->mt76->chandef.chan;
+
+	ieee80211_iterate_active_interfaces(mt76_hw(dev),
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
+					    mt7925_calc_vif_num, &valid_vif_num);
+
+	if (valid_vif_num > 1) {
+		phy->power_type = MT_AP_DEFAULT;
+		goto out;
+	}
+
+	if (!is_add)
+		vif->bss_conf.power_type = IEEE80211_REG_UNSET_AP;
+
+	switch (vif->bss_conf.power_type) {
+	case IEEE80211_REG_SP_AP:
+		phy->power_type = MT_AP_SP;
+		break;
+	case IEEE80211_REG_VLP_AP:
+		phy->power_type = MT_AP_VLP;
+		break;
+	case IEEE80211_REG_LPI_AP:
+		phy->power_type = MT_AP_LPI;
+		break;
+	case IEEE80211_REG_UNSET_AP:
+		phy->power_type = MT_AP_UNSET;
+		break;
+	default:
+		phy->power_type = MT_AP_DEFAULT;
+		break;
+	}
+
+out:
+	power_type_changed = (old_power_type != phy->power_type);
+
+	if (power_type_changed && chan && chan->band == NL80211_BAND_6GHZ)
+		mt7925_mcu_apply_regd(dev, dev->mt76.alpha2, dev->country_ie_env, true);
+}
+
 static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_link_sta *link_sta,
@@ -1006,6 +1086,8 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 			goto out_pm;
 	}
 
+	mt7925_regd_set_6ghz_power_type(vif, link_conf, true);
+
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 
 	return 0;
@@ -1279,6 +1361,8 @@ static void mt7925_mac_link_sta_remove(struct mt76_dev *mdev,
 	mt76_wcid_cleanup(mdev, wcid);
 	mt76_wcid_mask_clear(mdev->wcid_mask, idx);
 
+	mt7925_regd_set_6ghz_power_type(vif, link_conf, false);
+
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 9678ab50dbe6..a12b939b6123 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3496,7 +3496,7 @@ EXPORT_SYMBOL_GPL(mt7925_mcu_set_channel_domain);
 static int
 __mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		     enum environment_cap env_cap,
-		     struct mt7925_clc *clc, u8 idx)
+		     struct mt7925_clc *clc, u8 idx, bool power_type_change)
 {
 	struct mt7925_clc_segment *seg;
 	struct sk_buff *skb;
@@ -3514,19 +3514,38 @@ __mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		u8 pad1;
 		u8 alpha2[2];
 		u8 type[2];
-		u8 rsvd[64];
+		u8 env_6g;
+		u8 rsvd[63];
 	} __packed req = {
 		.tag = cpu_to_le16(0x3),
 
 		.idx = idx,
 		.env = env_cap,
+		.env_6g = dev->phy.power_type,
 	};
 	int ret, valid_cnt = 0;
 	u8 *pos, *last_pos;
+	u8 target_6g_type;
 
 	if (!clc)
 		return 0;
 
+	/* Determine target 6G power type based on phy->power_type */
+	switch (dev->phy.power_type) {
+	case MT_AP_LPI:
+		target_6g_type = '0';
+		break;
+	case MT_AP_SP:
+		target_6g_type = '1';
+		break;
+	case MT_AP_VLP:
+		target_6g_type = '2';
+		break;
+	default:
+		target_6g_type = '0'; /* default to LPI */
+		break;
+	}
+
 	req.ver = clc->ver;
 	pos = clc->data + sizeof(*seg) * clc->t0.nr_seg;
 	last_pos = clc->data + le32_to_cpu(*(__le32 *)(clc->data + 4));
@@ -3538,6 +3557,23 @@ __mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		    rule->alpha2[1] != alpha2[1])
 			continue;
 
+		/* Filter power tables based on call source:
+		 * power_type_change == false: from mt7925_mcu_regd_update()
+		 *   - Send 2/5G ('-') and 6G LPI ('0') and 6G VLP ('2')
+		 * power_type_change == true: from mt7925_regd_set_6ghz_power_type()
+		 *   - Send only the specific 6G power table based on power_type
+		 */
+		if (power_type_change) {
+			/* Only send the specific 6G power table */
+			if (rule->type[0] != target_6g_type)
+				continue;
+		} else {
+			/* Send 2/5G and 6G LPI and VLP only */
+			if (rule->type[0] != '-' && rule->type[0] != '0' &&
+			    rule->type[0] != '2')
+				continue;
+		}
+
 		seg = (struct mt7925_clc_segment *)clc->data
 			  + rule->seg_idx - 1;
 
@@ -3571,7 +3607,7 @@ __mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 }
 
 int mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
-		       enum environment_cap env_cap)
+		       enum environment_cap env_cap, bool power_type_change)
 {
 	struct mt792x_phy *phy = (struct mt792x_phy *)&dev->phy;
 	int i, ret;
@@ -3586,13 +3622,13 @@ int mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 			continue;
 
 		ret = __mt7925_mcu_set_clc(dev, alpha2, env_cap,
-					   phy->clc[i], i);
+					   phy->clc[i], i, power_type_change);
 
 		/* If no country found, set "00" as default */
 		if (ret == -ENOENT)
 			ret = __mt7925_mcu_set_clc(dev, "00",
 						   ENVIRON_INDOOR,
-						   phy->clc[i], i);
+						   phy->clc[i], i, power_type_change);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 321e732347f2..e3fef41cbb33 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -385,7 +385,9 @@ int mt7925_set_tx_sar_pwr(struct ieee80211_hw *hw,
 
 int mt7925_mcu_regval(struct mt792x_dev *dev, u32 regidx, u32 *val, bool set);
 int mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
-		       enum environment_cap env_cap);
+		       enum environment_cap env_cap, bool power_type_change);
+int mt7925_mcu_apply_regd(struct mt792x_dev *dev, u8 *alpha2,
+			  enum environment_cap env, bool power_type_change);
 int mt7925_mcu_set_mlo_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 			   u16 sel_links, int duration, u8 token_id);
 int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/regd.c b/drivers/net/wireless/mediatek/mt76/mt7925/regd.c
index 3eb3f172dba4..a039ec3ee47b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regd.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regd.c
@@ -137,14 +137,14 @@ mt7925_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 	}
 }
 
-static int mt7925_mcu_apply_regd(struct mt792x_dev *dev, u8 *alpha2,
-				  enum environment_cap env)
+int mt7925_mcu_apply_regd(struct mt792x_dev *dev, u8 *alpha2,
+			  enum environment_cap env, bool power_type_change)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
-	ret = mt7925_mcu_set_clc(dev, alpha2, env);
+	ret = mt7925_mcu_set_clc(dev, alpha2, env, power_type_change);
 	if (ret < 0)
 		return ret;
 
@@ -167,7 +167,7 @@ int mt7925_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
 
 	mt792x_mutex_acquire(dev);
 	if (dev->regd_change)
-		ret = mt7925_mcu_apply_regd(dev, alpha2, country_ie_env);
+		ret = mt7925_mcu_apply_regd(dev, alpha2, country_ie_env, false);
 	mt792x_mutex_release(dev);
 	dev->regd_change = false;
 	dev->regd_in_progress = false;
@@ -407,7 +407,7 @@ int mt7925_regd_change(struct mt792x_phy *phy, char *alpha2)
 	} else if (phy->chip_cap & MT792x_CHIP_CAP_11D_EN) {
 		return regulatory_hint(wiphy, alpha2);
 	} else {
-		return mt7925_mcu_set_clc(dev, alpha2, ENVIRON_INDOOR);
+		return mt7925_mcu_set_clc(dev, alpha2, ENVIRON_INDOOR, false);
 	}
 }
 EXPORT_SYMBOL_GPL(mt7925_regd_change);
-- 
2.18.0


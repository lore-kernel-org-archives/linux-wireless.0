Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B132BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601201; cv=none; b=nPdSCbWb+48P5iSDp4QMOhqdWUAR5JPifzYYQj3nIVEKwxkM8mf5RhnBieKwsDVI/V7upb3HaV/4VW3xQyw4mm5pZnDgoXfINrg/cB5aVAkFx6owizDLTKE0unctTfpINyWTRvYBPj5v/c0xCg6u42Clp36URIQPpydmP4j5Zd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601201; c=relaxed/simple;
	bh=Jc2DON91C5MhFHrhRfVX29JuE8FfK65e3tnBqQahQl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMMDFTARewj+mE5rQj4li4p4s8heOKZTUoaLuDYnOKcYVSjLp501rO7O1mcNBgyQrJhc40h2spxoQ2DHMI6cJN+1HhV7LgX8MGkfbyYPKzF2d2e1/tcTbchReQhS9ZPMBReVVU6fjDYokuVzM9F10Z5Tm7OnF0VU3dySlNJTuLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7f42ef0b693so2646537a34.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601199; x=1788205999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E2CdWedcFXTOLIczD0jNEGO3XZoMTmOxEBl5WwUArUU=;
        b=O/cy5Lg2zpH4eGLgvncoyscy42xbRT4jU7ysd0MiF+Z+8JBcVfSyjNWrCSRMD0U5MK
         t5i3T+4LIQmnpf/o4ffGXKYbSPbE4ZbnQfIa895+Va8mrMnCSHm7ooKCtbowIWihd5Ft
         sa2F1aEmeqCzhM9fwlzTTeuX9BSa/G3SQiOZ2ltbwMhVHFWQkghwArprIurF+Y12NNzf
         pp9NkhgYDh7GA5kBB8ehPIzSEMPvXv0NvLqQHdG/9el6tHqNNWseNwKZC+ixOiHmvioe
         GWdE1MqPC8jS4B0xEsaedMa3U2/6vNV/cLtNSWSn8exI035VpDFFqE6QLpF2GVDk6NcJ
         Ki1Q==
X-Gm-Message-State: AFuF++nMw1Lc6vido+QCcPKm6sWqgEBVXReyGjgqd5q0JcbevVVP7Wtd
	A8EvJaejsjWMYbYhahJUoy+OSMYyxdDw/qDJV55QYtEBrNgc6uEWrHoC
X-Gm-Gg: AR+sD12aEH6IIQ/3lMRh0yC0RA6Ye7GgJecLENHHMRKp7NZUVRjYmVCvCIM8Ty+vmks
	2AMdM1YF2ickBTEWKQHUTm/n/3U7yrwdMbfEnPUdTCpJfr+oL0Rs1/9K5kvwPaIsHNWYMiKnwrO
	QBaO1QOTYGKKmxy1CrdVmILs7zw73YIkJfkOu56MhKUrocZZkqrnHKXTp6FhnMAMMemQGNBDllB
	6YzHLHdQHLUOzgjiwrx5iaowFjVP4yG5Wh//K6DTsBm29/hjXhI9N+wYrNv4/RajHhsbXSYjE7G
	c0TAKG3P4kNE3a3Skmyh/x4eiWXLA/IYJJR/pfNSx7lczlrmnc5g3JG6QoWiTbuwdZdhrpyGpvA
	GCjcA1+hvwkulJhS++T1UA+VdJNUUzuyGr7zillMFCnoFamonCL6Q0+Cadkv5syph/8xiOTy51E
	sTUiAK+/Hokw+2GDVcCMnEMrKaf8qGlutbSQmnO3zovR2MgVccpuyP91rWVeaZiLzknRGDWia9m
	yVp8MgoGTFOibuVj2BlInUL3sc79suMYkhJHOCo8VyE
X-Received: by 2002:a05:6820:8687:b0:6ac:98de:f087 with SMTP id 006d021491bc7-6b16b26bb26mr14080205eaf.12.1787601199259;
        Mon, 24 Aug 2026 12:53:19 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:18 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 08/15] wifi: mt76: mt7925: share TLV setup for NAN enable command
Date: Mon, 24 Aug 2026 14:52:20 -0500
Message-ID: <20260824195227.12589-9-sean.wang@kernel.org>
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

Refactor mt7925_nan_enable() to build the MCU command from separate
TLVs via skb instead of inline fields in the enable request struct.
The cluster ID, DW interval, discovery beacon interval and RSSI
threshold settings are now shared with mt7925_nan_change_configure()
through the common TLV helpers, avoiding duplicated setup code.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 190 +++++++-----------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |   6 +
 2 files changed, 77 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index e6d6af4fc681..527cdb3a4ed7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -42,63 +42,6 @@ static void mt7925_nan_set_5g_channel(struct mt792x_dev *dev,
 	req->channel_5g_val = cpu_to_le32(ch5g);
 }
 
-static void mt7925_nan_set_cluster_id(struct mt7925_nan_enable_req_tlv *req,
-				      const u8 *cluster_id)
-{
-	if (!cluster_id)
-		return;
-
-	req->cluster_high = cpu_to_le16(cluster_id[4] | cluster_id[5] << 8);
-	req->cluster_low = cpu_to_le16((u16)cluster_id[3]);
-}
-
-static void mt7925_nan_set_dw_interval(struct mt7925_nan_enable_req_tlv *req,
-				       struct cfg80211_nan_conf *conf)
-{
-	if (conf->band_cfgs[NL80211_BAND_2GHZ].awake_dw_interval > 0) {
-		req->config_dw.config_2dot4g_dw_band = 1;
-		req->config_dw.dw_2dot4g_interval_val =
-			cpu_to_le32(conf->band_cfgs[NL80211_BAND_2GHZ].awake_dw_interval);
-	}
-
-	if (conf->band_cfgs[NL80211_BAND_5GHZ].awake_dw_interval > 0) {
-		req->config_dw.config_5g_dw_band = 1;
-		req->config_dw.dw_5g_interval_val =
-			cpu_to_le32(conf->band_cfgs[NL80211_BAND_5GHZ].awake_dw_interval);
-	}
-}
-
-static void mt7925_nan_set_disc_beacon(struct mt7925_nan_enable_req_tlv *req,
-				       struct cfg80211_nan_conf *conf)
-{
-	if (conf->discovery_beacon_interval > 0) {
-		req->config_2dot4g_beacons = true;
-		req->beacon_2dot4g_val = conf->discovery_beacon_interval;
-	}
-}
-
-static void mt7925_nan_set_rssi_thresholds(struct mt7925_nan_enable_req_tlv *req,
-					   struct cfg80211_nan_conf *conf)
-{
-	if (conf->band_cfgs[NL80211_BAND_2GHZ].chan) {
-		req->config_2dot4g_rssi_close = 1;
-		req->rssi_close_2dot4g_val =
-			abs(conf->band_cfgs[NL80211_BAND_2GHZ].rssi_close);
-		req->config_2dot4g_rssi_middle = 1;
-		req->rssi_middle_2dot4g_val =
-			abs(conf->band_cfgs[NL80211_BAND_2GHZ].rssi_middle);
-	}
-
-	if (conf->band_cfgs[NL80211_BAND_5GHZ].chan) {
-		req->config_5g_rssi_close = 1;
-		req->rssi_close_5g_val =
-			abs(conf->band_cfgs[NL80211_BAND_5GHZ].rssi_close);
-		req->config_5g_rssi_middle = 1;
-		req->rssi_middle_5g_val =
-			abs(conf->band_cfgs[NL80211_BAND_5GHZ].rssi_middle);
-	}
-}
-
 static void mt7925_nan_set_scan_params(struct mt7925_nan_enable_req_tlv *req,
 				       struct cfg80211_nan_conf *conf)
 {
@@ -132,68 +75,6 @@ mt7925_nan_update_conf(struct mt792x_vif *mvif,
 	memcpy(mvif->nan.conf.cluster_id, conf->cluster_id, ETH_ALEN);
 }
 
-int mt7925_nan_enable(struct ieee80211_vif *vif,
-		      struct mt792x_dev *dev,
-		      struct cfg80211_nan_conf *conf)
-{
-	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
-	struct mt76_dev *mdev = &dev->mt76;
-	struct {
-		u8 rsv[4];
-		struct mt7925_nan_enable_req_tlv nan_req_tlv;
-	} nan_cmd = {
-		.rsv = { 0 },
-		.nan_req_tlv = {
-			.tag = cpu_to_le16(NAN_UNI_CMD_ENABLE_REQUEST),
-			.len = cpu_to_le16(sizeof(struct mt7925_nan_enable_req_tlv)),
-			.config_random_factor_force = 0,
-			.random_factor_force_val = 0,
-			.config_hop_count_force = 0,
-			.hop_count_force_val = 0,
-		},
-	};
-	struct mt7925_nan_enable_req_tlv *p_nan_req_tlv = &nan_cmd.nan_req_tlv;
-	int ret;
-
-	if (!vif || !dev || !conf)
-		return -EINVAL;
-
-	p_nan_req_tlv->master_pref = conf->master_pref;
-
-	mt7925_nan_set_5g_channel(dev, p_nan_req_tlv, conf);
-	mt7925_nan_set_cluster_id(p_nan_req_tlv, conf->cluster_id);
-	mt7925_nan_set_dw_interval(p_nan_req_tlv, conf);
-	mt7925_nan_set_disc_beacon(p_nan_req_tlv, conf);
-	mt7925_nan_set_rssi_thresholds(p_nan_req_tlv, conf);
-	mt7925_nan_set_scan_params(p_nan_req_tlv, conf);
-
-	mt7925_nan_update_conf(mvif, conf);
-
-	ret = mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nan_cmd, sizeof(nan_cmd), true);
-
-	return ret;
-}
-
-int mt7925_nan_disable(struct ieee80211_vif *vif, struct mt792x_dev *dev)
-{
-	struct mt76_dev *mdev = &dev->mt76;
-	struct {
-		u8 rsv[4];
-		struct tlv nan_dis_tlv;
-	} nan_cmd = {
-		.rsv = { 0 },
-		.nan_dis_tlv = {
-			.tag = cpu_to_le16(NAN_UNI_CMD_DISABLE_REQUEST),
-			.len = cpu_to_le16(sizeof(struct tlv)),
-		},
-	};
-
-	if (!dev)
-		return -EINVAL;
-
-	return mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nan_cmd, sizeof(nan_cmd), true);
-}
-
 static int
 mt7925_nan_mp_tlv(struct sk_buff *skb, u8 master_pref)
 {
@@ -312,6 +193,77 @@ mt7925_nan_sync_rssi_tlv(struct sk_buff *skb, struct cfg80211_nan_conf *conf)
 	return 0;
 }
 
+int mt7925_nan_enable(struct ieee80211_vif *vif,
+		      struct mt792x_dev *dev,
+		      struct cfg80211_nan_conf *conf)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt76_dev *mdev = &dev->mt76;
+	struct mt7925_nan_common_hdr *hdr;
+	struct mt7925_nan_enable_req_tlv *req;
+	struct sk_buff *skb;
+
+	if (!vif || !dev || !conf)
+		return -EINVAL;
+
+	skb = mt76_mcu_msg_alloc(mdev, NULL, MT7925_NAN_ENABLE_MAX_SIZE);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = (struct mt7925_nan_common_hdr *)skb_put(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(*hdr));
+
+	/* Set cluster id before joining cluster */
+	if (mt7925_nan_cluster_id_tlv(skb, conf->cluster_id)) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	/* NAN enable request tlv */
+	req = (struct mt7925_nan_enable_req_tlv *)
+		mt76_connac_mcu_add_tlv(skb, NAN_UNI_CMD_ENABLE_REQUEST,
+					sizeof(*req));
+	if (!req) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	req->master_pref = conf->master_pref;
+
+	mt7925_nan_set_5g_channel(dev, req, conf);
+	mt7925_nan_set_scan_params(req, conf);
+
+	if (mt7925_nan_dw_tlv(skb, conf) ||
+	    mt7925_nan_sync_rssi_tlv(skb, conf)) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	mt7925_nan_update_conf(mvif, conf);
+
+	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
+}
+
+int mt7925_nan_disable(struct ieee80211_vif *vif, struct mt792x_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct {
+		u8 rsv[4];
+		struct tlv nan_dis_tlv;
+	} nan_cmd = {
+		.rsv = { 0 },
+		.nan_dis_tlv = {
+			.tag = cpu_to_le16(NAN_UNI_CMD_DISABLE_REQUEST),
+			.len = cpu_to_le16(sizeof(struct tlv)),
+		},
+	};
+
+	if (!dev)
+		return -EINVAL;
+
+	return mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nan_cmd, sizeof(nan_cmd), true);
+}
+
 int mt7925_nan_change_configure(struct ieee80211_vif *vif,
 				struct mt792x_dev *dev,
 				struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index fab10b829eaa..8ddb0a6d73b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -28,6 +28,12 @@
 #define NAN_MAX_CONN_CFG		8
 #define NAN_MAX_NDP_CXT			4
 
+#define MT7925_NAN_ENABLE_MAX_SIZE					\
+	(sizeof(struct mt7925_nan_common_hdr) +				\
+	 sizeof(struct mt7925_nan_enable_req_tlv) +			\
+	 sizeof(struct mt7925_nan_dw_interval_tlv) +			\
+	 sizeof(struct mt7925_nan_cluster_id_tlv) +			\
+	 sizeof(struct mt7925_nan_sync_rssi_tlv))
 #define MT7925_NAN_CONF_MAX_SIZE					\
 	(sizeof(struct mt7925_nan_common_hdr) +				\
 	 sizeof(struct mt7925_nan_master_preference_tlv) +		\
-- 
2.43.0


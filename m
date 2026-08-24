Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA32BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601226; cv=none; b=qk2eyjJQbaacL4/0XvQMijR6WpBR2017PDSQw01wKfOHNUoW/Jmt+s64tn+rejAJaV0QOu+BKV02a1TY0mGGdrgG7tPC1CmMt32klfsiT813/ZuULF3CjZNdeWVL7vPVpEcduL28QjQqebccNJCS3P8TILtr56Iq4v8P38ySJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601226; c=relaxed/simple;
	bh=M80Z4fuSbr1BZl2M1jNBL1AhjX8+fE5RuEPj7zechJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAqmnqh0Qahwkus9fuHmqbRIqZS4s+tt/wi6skDlj4Chn0neqld2xaux6UrC/GCbDKpaH5fm4XPFBm3GNjLrAUQq8HmsmsdyaUQMN1haAy6S4Ot4Ca+HhrATasIYF7ShemwhIbCa2rT3sOlcG0ZmpxGnwRZb+iwtdfVdZDLcutc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-45e2fd33133so2835874fac.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601224; x=1788206024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MwmqByqgOjaj+boW8Byl/XAhEHD4P6qPLmf+pApdFow=;
        b=aLWJdP1/nCYdyEz+X6NqN1qmOsfuGdLq0jBhsz5HXBvF1/EGdPJNdEVDgBu/WvtSPK
         hcWWgg1mqvaF6S362KhNg8ss0oa708ikJVlqmprhhBea3GYfj5Hr2bCrCI+7l9UT7Hco
         3pEewTeItc+IcAgz3fEWDZB0ZTDANkGRZYQLGKCpMaakHnPlV7WqmsVsuY77zgYkCaAN
         RG3ecGxS3DQun+T3JK26XcDlK77MjRDFz5vcNLRgCUhsEUJneuUoAgmdedwcMeT3+7Uv
         lJWlVUAD0+HxvwAQm+tCHtvT7h/iwH3qkoNbXOx+tovLakPDmiTjev9ER+M6x1C8+VL0
         tABA==
X-Gm-Message-State: AFuF++ls/oPH9lA159i34S3bIxOzjZ0vjJOLMEfgA9gU6yZICpFFmPHf
	9G0xBY0wfCl7oP8IoSrlMqyllDbVO7JdKBq2X4zI9IhoN8nC7VzJZkj6
X-Gm-Gg: AR+sD13iXlNeqq94M6o7LVz4NYztCTMOKyPyz9wgouQtNt9WYVVJfQaclp3YLyjkW7O
	lOnB5vkVXnlLrES+fLEnHjHK/sm67XoG1yx0B0QRW4X70rIL53t4i5gtdKz6ZddNOYx9WK11WMy
	cM7DYBJHkyk3R/mCepLxtdlPF3YmcITnXD7I2Tys0v2/kvvFzemB0uKvrd7WY3o37hWj9EJzISx
	ox4/s75hDOtA+udyoVOeVcmP4sBotuhvg95UAg9bIkFq6KUtGrjSdJY+3jvWLQBjO6CLDvspSX6
	jUyfM1VL4sR7eo7tflOt2s8EsUm6eu5A00nq6HrVTQ5Egq75stYKuxrfpC9JNs7TUcUzZQU5bFI
	84i5z0VE9qvZP12PkBkXrDJ+qKlqCLG7+PCR+FDbDxuflQu5S9XH1btE2rX5AyWgO7li+0sgpge
	owaWhsEzS1Edr2SPZGYZU/jrPVwKrJbpWgtBvN0eP6XRGyZC/WAy3cR8lI2gWJP/3BQnZf8mI9u
	wGJsuUzTDNgricemACypwi+ZHJTMXinKuZ2/hqMZZJj
X-Received: by 2002:a05:6870:2e84:b0:44c:3269:4d40 with SMTP id 586e51a60fabf-46350f85256mr27114382fac.7.1787601224083;
        Mon, 24 Aug 2026 12:53:44 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:43 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 15/15] wifi: mt76: mt7925: fix HT/VHT caps and rates for NAN NDP peers
Date: Mon, 24 Aug 2026 14:52:27 -0500
Message-ID: <20260824195227.12589-16-sean.wang@kernel.org>
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

From: Jacobs Wu <jacobs.wu@mediatek.com>

NAN NDP peers were added with bare link_sta caps: no HT cap or QoS
flag (so no BA/A-MPDU), no VHT cap / bandwidth / rx_nss, a data BSS
phy mode that still read legacy when the firmware built the peer's
rate table, and caps filtered down by the currently committed
schedule.

Push the NAN_DATA BSS phymode before sta_update, force the HT cap and
QoS flag, seed VHT80 / bandwidth / rx_nss=2 from the BSS RLM, fix the
NDP HT/VHT rate selection and stop filtering the link_sta caps by the
schedule, so rate control always sees the peer's real capabilities.

Bench (MT7925<->MT7925 NDP, 5 GHz ch149): 866.7M VHT80 MCS9 NSS2 link
rate, UDP ~290 Mbit/s.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 19 +++++-
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 62 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  4 ++
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index e1c688af7c59..051a0c8aed58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -964,6 +964,21 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 
 	link_conf = mt792x_vif_to_bss_conf(vif, link_id);
 
+	/* NAN_DATA (NDI) peers skip association - fill link_sta caps
+	 * from sband and push BSS_INFO with correct phymode + RLM.
+	 */
+	if (vif->type == NL80211_IFTYPE_NAN_DATA) {
+		struct ieee80211_chanctx_conf *nan_ctx;
+
+		nan_ctx = mt7925_nan_seed_link_sta(dev, link_sta);
+		mconf->mt76.ctx = nan_ctx;
+
+		ret = mt7925_mcu_add_bss_info(&dev->phy, nan_ctx,
+					      link_conf, link_sta, true);
+		if (ret)
+			goto out_pm;
+	}
+
 	/* should update bss info before STA add */
 	if (vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls) {
 		struct mt792x_link_sta *mlink_bc;
@@ -2587,8 +2602,8 @@ static int mt7925_start_nan(struct ieee80211_hw *hw,
 	cfg80211_chandef_create(&link_conf->chanreq.oper, chan,
 				NL80211_CHAN_NO_HT);
 
-	err = mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf,
-				      NULL, true);
+	err = mt7925_mcu_add_bss_info(&dev->phy, NULL,
+				      link_conf, NULL, true);
 	if (err < 0)
 		goto out;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 4b479edab018..8a59f7b1aee2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -267,6 +267,68 @@ int mt7925_nan_update_phy_setting(struct mt792x_dev *dev)
 				 &req, sizeof(req), true);
 }
 
+struct ieee80211_chanctx_conf *
+mt7925_nan_seed_link_sta(struct mt792x_dev *dev,
+			 struct ieee80211_link_sta *link_sta)
+{
+	struct ieee80211_supported_band *sband_2g, *sband_5g;
+	struct ieee80211_chanctx_conf *nan_ctx = NULL;
+	struct ieee80211_vif *nan_vif = dev->nan_vif;
+
+	/* Fill HT cap from 2G sband */
+	sband_2g = dev->mphy.hw->wiphy->bands[NL80211_BAND_2GHZ];
+	sband_5g = dev->mphy.hw->wiphy->bands[NL80211_BAND_5GHZ];
+	if (sband_2g)
+		link_sta->ht_cap = sband_2g->ht_cap;
+
+	link_sta->sta->wme = true;
+	link_sta->rx_nss = hweight8(dev->mphy.antenna_mask);
+
+	/* Get chanctx from NAN schedule.
+	 * Prefer 5G committed slot for wider BW (VHT), fallback
+	 * to first valid slot if no 5G data slot is scheduled.
+	 */
+	if (nan_vif) {
+		struct ieee80211_nan_channel **slots =
+			nan_vif->cfg.nan_sched.schedule;
+		int i;
+
+		for (i = 0; i < CFG80211_NAN_SCHED_NUM_TIME_SLOTS; i++) {
+			struct ieee80211_chanctx_conf *ctx;
+
+			if (!slots[i] || IS_ERR(slots[i]) ||
+			    !slots[i]->chanctx_conf)
+				continue;
+
+			ctx = slots[i]->chanctx_conf;
+			if (!nan_ctx)
+				nan_ctx = ctx;
+			if (ctx->def.chan->band == NL80211_BAND_5GHZ) {
+				nan_ctx = ctx;
+				break;
+			}
+		}
+	}
+
+	/* Capability describes what the device can do and must not be
+	 * filtered by the current schedule - firmware gates the VHT rate
+	 * mode per the data schedule and re-derives it on schedule
+	 * change, which only works if the caps are present up front.
+	 */
+	if (sband_5g)
+		link_sta->vht_cap = sband_5g->vht_cap;
+
+	/* Bandwidth here is the capability ceiling, not the operating
+	 * width - the per-slot operating bandwidth follows the current
+	 * slot channel via the firmware RLM sync, so deriving it from
+	 * the schedule at STA-add time would cap a later 5 GHz schedule
+	 * at the bring-up width.
+	 */
+	link_sta->bandwidth = IEEE80211_STA_RX_BW_80;
+
+	return nan_ctx;
+}
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index c78a1350c456..d81d84a222d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -477,6 +477,10 @@ struct mt7925_nan_update_phy_setting_tlv {
 
 int mt7925_nan_update_phy_setting(struct mt792x_dev *dev);
 
+struct ieee80211_chanctx_conf *
+mt7925_nan_seed_link_sta(struct mt792x_dev *dev,
+			 struct ieee80211_link_sta *link_sta);
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf);
-- 
2.43.0


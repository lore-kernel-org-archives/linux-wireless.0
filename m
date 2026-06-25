Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C054E1FCFEF
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 00:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782346776; cv=none; b=g2Yp30dVHUjMFQZxhCta4490LgngSQn6FG/nS4TQTr6NBqanOqH+aQHvTCxJY16IDsTfb0zpXRi6CJ3nxhq5QQco3pAtvn8mbh6UEGB7ZjXoTET6k5sKQK4BDdVW1y+DC8+Ooqw992pRj87+1ndu6mngxfB9a6fKTKvRNtSCVz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782346776; c=relaxed/simple;
	bh=+ZUju/5hbWFBWSkrIolTMVS1qvJd+9kW0flO1W8ttd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHUsSkKpg0/6NrxEIAWbs3VAo9DnXfjtDwmeHoyLfpjWMMjsGU1dLFpaSrLYkHdsupCHGRSgYiTogZkahA5P/ZZJNwnIPOHQILqlQAqAjQBi4vU4INmsZCvQ87QIGD6dvzgbRxVo9J+y3qMkQj95edRUa0coV1A6sptBAWWXqSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c8b49639fbaso1104394a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 17:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782346774; x=1782951574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AyPmpTYq94Jn9nTAUSFDOvDYbqnAtTblCK+8XVszBnQ=;
        b=fy0j9xPHsx/vsDMDWQI53CkmAxynsA3bITcndqDyNSjpMiDeTuIatGfheGDgRPw9Wd
         Bx523ejl6YT9wgI5glUGO35el0iDcXiWdgCkARqBGiHgwvSDx23RtT5RwAoZNfzr0BIK
         7iP8+loyIHMGXPzSfEBbJh8slNRpvPoyX/1a4BDR+t/MZ3PbMwUnLd7ZK4k6IyqSDc/t
         4ewnQCsP+7p+xJk+B1dDVjVsqmHZLXknyiTiDujBa7NMiZ1ynZUcbP7CaM5yE6weJ05w
         ud/kw8Ql9xiS/53djNaSunHmdcBueUWHveNeOtoVXG7lLEUF9ZVcQi6SzoZ9uYyKAU67
         pqjw==
X-Forwarded-Encrypted: i=1; AFNElJ+tJ866r3ATsjvO1HPiCn83P0zw7LtfzZ0Xf/V6uBvDb9aIXwsmnYcKXh2GiSDGkzArN0RGtD3lIK3DON1ESA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuxbU/JAL+SjkJOa/p/H9BOK9DqRTBQ9plqPhmkJuaAYWidQK/
	6YBIp5Zagmx2bHopK500A2AlXprKc6p35Rzvj3LVcb87Y6fTqGIv8oOt
X-Gm-Gg: AfdE7clP+tb2fP9RbOENNNNdst/9TXEa9MJjCkuVqgv5WATteKpLRXPYzaa8e1UsdaZ
	FId0aKbaTOqRr+WY+8wZmze7mxD6JmOwT6+DzLBLspVYWoINcjRGutMDSAcQE6FBAsKkM4v1s9+
	i8kCOdyyh1OyjaMt1cUTkb+I5swXU2AI2CGw2a7StRVkMJwDkAbQFalEFCmZnSLykYar696GSje
	7rT1/hRRLHXfM47WkjKMsBR2eiKoB3eWtiqBEMNaandpaGXzVorgbJao9qqxmdvBOsZ5ESHhzum
	Lx8otyLoxALTiuyrsuBzFHakxSbv5t0QRfyUsvZy5bgABdSL5X+FxqEDQQoz9upB6AHknfu0bRx
	Xiw8Jqz1C8Z1vMIaS3x+upgSKnRuIpF9muu/FTkJmGXN3UOHGOcEc5EtaU2YlfQHNhelARF1U5M
	IykvrWwuDZnD0xEf0B/U3h+RBHBQnnYhrl5U71XpTPJebVFe1PvP6TA+BXoGECEwZ/hGiZdiYfd
	4KhYmZHA5k3Wio/VZWTu1H28aq/5w==
X-Received: by 2002:a05:6a20:6a0d:b0:3b4:87c0:d90 with SMTP id adf61e73a8af0-3bd4ae3a935mr289934637.28.1782346774031;
        Wed, 24 Jun 2026 17:19:34 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.. (114-34-228-194.hinet-ip.hinet.net. [114.34.228.194])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bc1e0d10sm586839a12.21.2026.06.24.17.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 17:19:33 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: chengwei.yu@mediatek.com,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v2 2/9] wifi: mt76: mt7925: guard BSS capability lookups
Date: Wed, 24 Jun 2026 19:18:27 -0500
Message-ID: <20260625001834.475094-3-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625001834.475094-1-sean.wang@kernel.org>
References: <20260625001834.475094-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

mt7925 BSS setup may dereference missing channel data or query HE 6 GHz
capabilities for an iftype without HE support.

Guard both lookups before adding NAN paths that can use partially
configured BSS state.

Co-developed-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Co-developed-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 26 ++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index e94fa544ff20..cff91b4eeac6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2364,11 +2364,18 @@ void mt7925_mcu_bss_rlm_tlv(struct sk_buff *skb, struct mt76_phy *phy,
 {
 	struct cfg80211_chan_def *chandef = ctx ? &ctx->def :
 						  &link_conf->chanreq.oper;
-	int freq1 = chandef->center_freq1, freq2 = chandef->center_freq2;
-	enum nl80211_band band = chandef->chan->band;
 	struct bss_rlm_tlv *req;
+	enum nl80211_band band;
+	int freq1, freq2;
 	struct tlv *tlv;
 
+	if (WARN_ON_ONCE(!chandef || !chandef->chan))
+		return;
+
+	freq1 = chandef->center_freq1;
+	freq2 = chandef->center_freq2;
+	band = chandef->chan->band;
+
 	tlv = mt76_connac_mcu_add_tlv(skb, UNI_BSS_INFO_RLM, sizeof(*req));
 	req = (struct bss_rlm_tlv *)tlv;
 	req->control_channel = chandef->chan->hw_value;
@@ -2506,8 +2513,8 @@ mt7925_get_phy_mode_ext(struct mt76_phy *phy, struct ieee80211_vif *vif,
 			enum nl80211_band band,
 			struct ieee80211_link_sta *link_sta)
 {
-	struct ieee80211_he_6ghz_capa *he_6ghz_capa;
-	const struct ieee80211_sta_eht_cap *eht_cap;
+	struct ieee80211_he_6ghz_capa *he_6ghz_capa = NULL;
+	const struct ieee80211_sta_eht_cap *eht_cap = NULL;
 	__le16 capa = 0;
 	u8 mode = 0;
 
@@ -2515,11 +2522,18 @@ mt7925_get_phy_mode_ext(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		he_6ghz_capa = &link_sta->he_6ghz_capa;
 		eht_cap = &link_sta->eht_cap;
 	} else {
+		const struct ieee80211_sta_he_cap *he_cap;
 		struct ieee80211_supported_band *sband;
 
 		sband = phy->hw->wiphy->bands[band];
-		capa = ieee80211_get_he_6ghz_capa(sband, vif->type);
-		he_6ghz_capa = (struct ieee80211_he_6ghz_capa *)&capa;
+
+		he_cap = (band == NL80211_BAND_6GHZ) ?
+			 ieee80211_get_he_iftype_cap(sband, vif->type) : NULL;
+
+		if (he_cap) {
+			capa = ieee80211_get_he_6ghz_capa(sband, vif->type);
+			he_6ghz_capa = (struct ieee80211_he_6ghz_capa *)&capa;
+		}
 
 		eht_cap = ieee80211_get_eht_iftype_cap(sband, vif->type);
 	}
-- 
2.43.0


Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A049280A5B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Mar 2026 23:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772668256; cv=none; b=h5LG9JihoAfM5WXrrXGuSGf7tHWKUhClZaPWsPtIMNHtEtd6kJpD/OO0ff8SBFxD4KP5jgI94nk0KvctCs+wnQN2LA1a+bIj7eMae+5nVMJ7XRKswRRnMnlHabKT1Jl02PJfsD7khaqSatnC4AL0x2lRK9+pK2XUAcUZ0+eVbCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772668256; c=relaxed/simple;
	bh=A+RkIBJCIBt7oAwpwzOsIz1BDNWz81PeRCHUjO1XMFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuEJ1invurAixTmHlurXaHqmsCsSAd7Ya3LxImvLfJrHXvZH/ldsXeqJ+d7MOxbOHlltQvqgFRsoCgocZc6NPI0AoC00mT346N2tF1YAAtWPiHjYyzTMYFvMY4iYDAyzj80kr154NyizRVrZOTvtU29lK1oJSolsDU5CyKRgwwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-66ee7b9af94so3208456eaf.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2026 15:50:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772668254; x=1773273054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yQJt/N82hxCdQBdnW9TOeW6Hzsl+OXAfpLbBSMq+lAU=;
        b=K/NnT7Gx86RTC58+a2+A0gSaD7wbkdUc9cbE65c5numXomlpDBnEt/N1MiwpoH2YYJ
         Zd5q0ZMddlGd/PcCgRqH4c+An2L7lHYS8tSpSyKuxyS/KBGS2grbPxljHjUS7RJtYJXe
         6lcLCSQFIVJZC8V/iFMrxuerxIyvs6Q77qqs296QWVV6v+uvmbS5vAwCff/xi5cAVisZ
         gSffqPFlyXktJom59I9rYVQnpHlrxlsh631umSA96DtKdp3Mvt4cna6T2jJ3SGIHXnSq
         9QwV3K6rEyqjgJoOqvZR6UTzlSuXx9jOgLn3blVEzbBG8ggpxgt6oKdwfxsx3DFoAwVi
         nlhg==
X-Gm-Message-State: AOJu0YwlK1EuiX62yv8IkTvVfZ20oekNtU2lgk3EK/QWMe+RysdVyCPy
	RS69aB4D00XVDocqlKhMSYjCOy/5ltHBH9RxD/iUQ63xhFliRURMS6Ff
X-Gm-Gg: ATEYQzwcb95OK9qdAdY5qXV8atDNflFLpXPidR4iM1JFa9Wsn3pPX0iSnPPKd1m+TPd
	/UBa2+xGCNJ8l0VGg/cEWa3OX4Q8zVJuUFsqmEodkSKY21+oo1qWyYR3x7AaUvC31oJGUqmxUGW
	kfK1vz/jTmVvZ5EphUqCocYbyZeK0VQnawgpHU0MuTxR2tkh4OyX+S7iC96iX7yHWEaFxIK0vtG
	p0k0SwBpPZNWUjRY5wbyKQUsqhULuIk/0OTXwcKg1tkG+mHRRru1oTVjzWDB2xVXhlmf3lexYaz
	swGbuTQe7ecyCqHueQidC1HcZdmpwA8yna3wwAuv0t9Pzn35r/AFkjWI/+tO1l01igHQzzsap+5
	ZTy8VOVXMOM3H1vFTQWeXxn1Rle+4mTR3bLL+UE8gQqh/hXQ74S2Ucl66BmYjQ3B6p9CfDn1NeQ
	P5uLJq722Vw0oNjOZV6erRW9LDN65g40SPOXpfUFRBj+XJolY=
X-Received: by 2002:a05:6820:460d:b0:677:bd4a:8f75 with SMTP id 006d021491bc7-67b1e9033c7mr1661314eaf.61.1772668254388;
        Wed, 04 Mar 2026 15:50:54 -0800 (PST)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm14410687eaf.7.2026.03.04.15.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 15:50:54 -0800 (PST)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	yuchi.wang@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 3/7] wifi: mt76: mt7925: guard HE 6 GHz capa lookup by HE iftype caps
Date: Wed,  4 Mar 2026 17:50:16 -0600
Message-ID: <20260304235020.40451-3-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260304235020.40451-1-sean.wang@kernel.org>
References: <20260304235020.40451-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

ieee80211_get_he_6ghz_capa() WARNs if the iftype has no sband iftype_data
or lacks HE. Probe HE support first with ieee80211_get_he_iftype_cap()
and only then query the 6 GHz capa. And initialize he_6ghz_capa/eht_cap
to avoid uninitialized use.

Co-developed-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index e050c2795cb4..261ed6528808 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2436,8 +2436,8 @@ mt7925_get_phy_mode_ext(struct mt76_phy *phy, struct ieee80211_vif *vif,
 			enum nl80211_band band,
 			struct ieee80211_link_sta *link_sta)
 {
-	struct ieee80211_he_6ghz_capa *he_6ghz_capa;
-	const struct ieee80211_sta_eht_cap *eht_cap;
+	struct ieee80211_he_6ghz_capa *he_6ghz_capa = NULL;
+	const struct ieee80211_sta_eht_cap *eht_cap = NULL;
 	__le16 capa = 0;
 	u8 mode = 0;
 
@@ -2445,11 +2445,18 @@ mt7925_get_phy_mode_ext(struct mt76_phy *phy, struct ieee80211_vif *vif,
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


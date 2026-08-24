Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B502BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601199; cv=none; b=gGpIqyexSpnkLM9zrX+0EeFi8Kvf8q/xpdXDZ7NpTkc93bKyRnhSl/UZ9Bq+ES4W9t1dYXIRHjlmIE+hDHyz/tRc914+Yv6lPpMogC2m6A0qst6G6j54ew2y9OYlHzkhDZQfkKwtH++oULthNmhgUa8zxLaD+UDszoDaFMSRBCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601199; c=relaxed/simple;
	bh=+/+j2CqtolqSNbZrsCVfaAd6gXLQkb28x+wdYj0/G38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb09I8h1p0r6DCEeAH6zuRd3UCsOm0UaZ07KUnEpUP7D1LgvhLIJgYchGND95PkVtyp0Qg+ZbONrN8oLwP+K2L6A64bydxfs98CpniYE4Y7xoyU3TwC1KQOOCNF8e2QqMAM07GDTxyq/DWofoyoYWpah9Un5FglZDnVlf2sNLyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-43bf9548df4so3853544fac.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601197; x=1788205997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3zRODFxdmf59Gw6k7LfttFOtYBeiiAkZasq3H4MbfRQ=;
        b=Aco3F7AZ5Ev4hYCshdq4KQ4MxHkkhp7qSc9vEEBYufl8FGSFqpfgyeT9Ynw4y+rkPT
         PBWjTb6xXFjtO7cZDSQ7ttyieob2ALQBGtPWllXDroy5xzUDk3QSXtgPVg2/vDsEfRZF
         aVcrKfIqAXcMcYQZzKbyCYrcrQDPdWGJzA5CIUzeyU0kxUkwmVvqITRgmWKwgLXYLXlk
         GXDBL8LruH05bip1b3uvcdaBCrQbe1v+Ijvnu3h9cABI9Tt4Gmz3GPuScK04ZVGl/HIx
         QSQKqC4veBVZvDZ8WgElqfGbgGl1iFcLHSwvz3DOpufvPLppCNn8B218RCEZ9tx1Vhak
         sg7g==
X-Gm-Message-State: AFuF++kjVotsAx0szjem8a9wYphTrHeTF3l/zJOIa1BPsUhi+wO0NEwj
	uyKLW2YnGWnb/dmV343TkWZybaDBnwuDNA0Hzz+wVdkhuLGvWPLI3VW9
X-Gm-Gg: AR+sD12i12/LZBsgwr625XezmruYpu67tL3f0Q27IqabRFMmIOFU0kOL9fJBt/HAiwl
	UL/Y5SxjpOWtZ+Gb9EKCZhCN6n/g06uj/uARzE+Ugev3Umtc4qJfsBEcl5NY18VIfk4gJqfoKrA
	g6nFLqMwqy75Uwnnxm9+hM3AO0RnqsbsQ5mH3wMi9KalylsASG7hyLAPCN0a6BGe+bZuTp1u9Qz
	LJC4sVK0Aodc5Ypw9EUAz0c3dGw7B5PDATOWnXtdpL0I/ASMJ3VmEpNQchKVDV6Fxy4Iz1SJluj
	1E1jBz+B22Aj3d2gwrwqGpccKsXCrgdSlmmneXxweeystKyxSjz8hrHlNVzHH6I+8oiZn0ImXa+
	an/BH3tjimHJCnwBM7yDDBT/Mg0fX1+KiZN5g4h96XvKtA0i3BmuLQu+8n8j3CsyfV0tLyFbdvl
	K3gA+XOnujstKLbIft7QiAqQZwDKTUqq7iQK0mtRnQfb0WKIi4sejAqsnyuUCRBw/mG+tRGkfLq
	mQVF2juKICayAQ55Vhkv9E9lcE8ihTDdlZkk3yqk6Hn
X-Received: by 2002:a05:6871:2ecc:b0:448:9052:f436 with SMTP id 586e51a60fabf-46350fcdcefmr28945639fac.8.1787601197217;
        Mon, 24 Aug 2026 12:53:17 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:16 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 07/15] wifi: mt76: mt7925: use OFDM-only PHY mode for NAN STA records
Date: Mon, 24 Aug 2026 14:52:19 -0500
Message-ID: <20260824195227.12589-8-sean.wang@kernel.org>
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

NAN operates with OFDM and does not support CCK, so the phy, rate
control and BSS rate TLVs must not fall back to 2.4 GHz. Borrow the
5 GHz band lookup to keep the STA records OFDM-only.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index fa29c486a455..1cfc209f9be5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1914,11 +1914,9 @@ mt7925_mcu_sta_phy_tlv(struct sk_buff *skb,
 	phy = (struct sta_rec_phy *)tlv;
 
 	if (mt7925_vif_is_nan(vif)) {
-		enum nl80211_band band = chandef->chan ? chandef->chan->band
-						       : NL80211_BAND_2GHZ;
 		phy->phy_type = PHY_TYPE_BIT_OFDM | PHY_TYPE_BIT_ERP;
 		phy->phy_type |= mt76_connac_get_phy_mode_v2(mvif->phy->mt76, vif,
-							     band,
+							     NL80211_BAND_5GHZ,
 							     link_sta);
 	} else {
 		phy->phy_type = mt76_connac_get_phy_mode_v2(mvif->phy->mt76, vif,
@@ -2003,7 +2001,11 @@ mt7925_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb,
 	ra_info = (struct sta_rec_ra_info *)tlv;
 
 	if (mt7925_vif_is_nan(vif))
-		band = chandef->chan ? chandef->chan->band : NL80211_BAND_2GHZ;
+		/* NAN is OFDM-only per spec; borrow the 5 GHz band lookup to
+		 * avoid PHY_TYPE_BIT_HR_DSSS/CCK bits being added to phy_type.
+		 * NAN interfaces have no chanctx, so chandef->chan is always NULL.
+		 */
+		band = NL80211_BAND_5GHZ;
 	else
 		band = chandef->chan->band;
 
@@ -2847,7 +2849,7 @@ mt7925_mcu_bss_bmc_tlv(struct sk_buff *skb, struct mt792x_phy *phy,
 	bmc = (struct bss_rate_tlv *)tlv;
 
 	if (mt7925_vif_is_nan(vif))
-		band = chandef->chan ? chandef->chan->band : NL80211_BAND_2GHZ;
+		band = NL80211_BAND_5GHZ;
 	else
 		band = chandef->chan->band;
 
-- 
2.43.0


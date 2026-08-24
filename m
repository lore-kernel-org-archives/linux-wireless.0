Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862C128B7EA
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601187; cv=none; b=heZegk61L4v8aW8GQKIdHwTQ4yS7Mzok0hOv/tK6IgPp8xUZWmDaHytdpMslMVBeZA9jDusRVH+cgMdD7b2KoVSOE7oCNvbHTNmZUIQxbsdRjUu9dja9lhFjeJNCvp/+QM8IavXCDKrKzgADe6ERKnKNQ9g8LUxlU5ocecVo7IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601187; c=relaxed/simple;
	bh=njUzlv6BHrYi2qlCC3I6+JDqjvxOesMYl9uIdXpV6xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaTG9OllFTFOd7Y0sUPr2Dc7c23GHwlHJ/7oMH1Op783muGRj3kPNwFm6QbhLilSxxHFcdyMSAiUgcxdceBirf5uf+ZrMKJBZrpt82mG2zsO9qlD/r2ypbcK4qMndntFupXpGarppOsiiuY6dckqr3zkfJ7bmhYTkrqCEVyaxnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43b7e186a0cso1607581fac.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601185; x=1788205985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/cWhV2VXNAcEM4e3yqDd+mmFtduEPM2FheFVFeRGh6w=;
        b=erAhc+3cyvgWTr7kdR9AHXqECQtXqxrhd6m+IqjCyiMzh3L56hY1QWIkVM3xERncgp
         k30KtFsEJzmXx1oM7xu43UjOVe9m3LEXbVOACkJuuIPyDNL+0+UPUAS8MyxS/mhR3wVa
         D/q/MID8y8DKJqAILKfZlaGJVbF0AepoiEYtQhgYoPFIVAjjohHDN9h4Ll4foPP3G2N7
         X8P2cIw6H6YFuaTyTTTP78dTCxyb9WOLDR4RbCJCNd9D+Pz+pPA5CdyXf3CyWlSPi7Ze
         bAfnnjNAN2sQfn68JyBdLlu76rA15UfobgafwQjbmChC2HHha063s4yT9VI9Yer9iasG
         mc3A==
X-Gm-Message-State: AFuF++lQCPbVWfS5n8r506pgL+75lxs7dyteLSwA4Fza7/ju0VgKlxRL
	UA7iFrQYYR58js/fPsjHzZbq+78XSS45qdz4oo+0soV0yMf/HadQltAs
X-Gm-Gg: AR+sD11WhLg02RI00xUCLXNJmtwlZ6Hj5S0uqRBQG1JyxVefXpv9eDB3dMH5YAJRce3
	sN9JUEIPKGTisHFFpbFc+pBiyVbwDOTvZ/DwBtaquFbOODanHmuOFjbtKrWdfzM4WmtuWCkE3U1
	xvEsRKk6EYZ0wyfz6cqg7W9pOUN3Jz40UF2EEVGq5kcn4avwh73DlKIrCJMr6RgDiHlbnGOELnd
	5jaCbeBhPa705EZxj/LkUICp40nr810NA+qRdqOiCgMmRmwzvNbPgb9j7jWM4POEx9Z33C6axJN
	EwsBjCjYoUbOEwjR/tt3jpuUnuF0S+2bfjYmvhJWaWHscrzO0E3+SNeNNQIr8dB2fv4oArET+sq
	kO8Q24DjQJN6ybuMW1Hx6m+MQMeq9TjWXDfma2yILDpYkBwkEn9BS757VP96dT9TKInU6ECBOim
	8whMEAOUH2jIjUNVJnfACw1qvQ0/PWVcNiU3osLfFsf2X38TqUxDCoV7MBChOTziceQwj+xv9RS
	4/y7zhVba8TOVzmQqS0ZhbLfHNOhjI8CNzkFjkIy4qn
X-Received: by 2002:a05:6870:f290:b0:456:f700:dd75 with SMTP id 586e51a60fabf-4637fa674admr19731643fac.7.1787601185375;
        Mon, 24 Aug 2026 12:53:05 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:04 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 04/15] wifi: mt76: mt7925: report only 2.4 GHz NAN supported band
Date: Mon, 24 Aug 2026 14:52:16 -0500
Message-ID: <20260824195227.12589-5-sean.wang@kernel.org>
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

The firmware only checks the 2.4 GHz bit of the local device capability
supported_bands field, so set it directly and drop the unused helper.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 20 +------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index e51e91f08b49..c04b12cbf076 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -680,23 +680,6 @@ static int mt7925_nan_peer_rec_tlv(struct sk_buff *skb,
 	return 0;
 }
 
-static u8 mt7925_nan_get_supported_bands(struct mt792x_vif *mvif)
-{
-	struct wiphy *wiphy;
-	u8 bands = 0;
-
-	if (!mvif || !mvif->phy)
-		return BIT(NAN_SUPPORTED_BAND_ID_2P4G);
-
-	wiphy = mvif->phy->mt76->hw->wiphy;
-	if (wiphy->nan_supported_bands & BIT(NL80211_BAND_2GHZ))
-		bands |= BIT(NAN_SUPPORTED_BAND_ID_2P4G);
-	if (wiphy->nan_supported_bands & BIT(NL80211_BAND_5GHZ))
-		bands |= BIT(NAN_SUPPORTED_BAND_ID_5G);
-
-	return bands ?: BIT(NAN_SUPPORTED_BAND_ID_2P4G);
-}
-
 static int mt7925_nan_peer_cap_tlv(struct sk_buff *skb,
 				   struct ieee80211_sta *sta,
 				   struct mt792x_sta *msta)
@@ -723,8 +706,7 @@ static int mt7925_nan_peer_cap_tlv(struct sk_buff *skb,
 
 	peer_cap_tlv = (struct mt7925_nan_sched_update_peer_cap_tlv *)tlv;
 	peer_cap_tlv->sch_idx = cpu_to_le32(msta->nan_sched.sch_idx);
-	peer_cap_tlv->supported_bands =
-		mt7925_nan_get_supported_bands(msta->vif);
+	peer_cap_tlv->supported_bands = BIT(NAN_SUPPORTED_BAND_ID_2P4G);
 	peer_cap_tlv->max_chnl_switch_time = cpu_to_le16(sched->max_chan_switch);
 
 	for (i = 0; i < sched->n_channels; i++) {
-- 
2.43.0


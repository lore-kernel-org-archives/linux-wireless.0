Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253161;
	b=J9bfjHcgzLbjoY46TjjUFu7FYwo1umyf9PCjrHoIqE88O3Av0IgppeMVApUh9j9B8mZG
	 pT8i4prBJJqrhBN7v4MoFVacNd7zfzBSgWiVxiD635H2Xi3uexz7yzakwR2R/TViRtgrl
	 1WnL3DK3pdpENRehUadFnoFV8wqYUHWWs19E1TCm7j1wbmba5Nk2BfXlpFtAjr6+e/+ib
	 BeDjqv9glumacIznsAV3rliGevmdT1WEzEhVb0KhQ/LTFzQgHiYb1+iBgfM6c1hVUrBdQ
	 E+cxyoGwX4UZdbTYkQjAiCDJ7HYY5UGYRB8wJd8n15NIOR0iJuGrzZbdtKO5ip1xpwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xr1LjWVaWfr7wmZpwhIZF79+9c7ND1pbwxs/kLwML6I=;
	b=AYObIkPlzhP4q87Vy2Po+byQm3HLg37UzNBH2T5ZpSGlByAICWAoCvYjudsg6MFUhwI5
	 kUByyJkPRCc4rsq/4b4PX52xeMNw1g4Ns+6KToIb/YAfLHxca4GMNm9zvie72D7xgV2/b
	 Tj5Tpw36ZwD21iVhWIDy+422oPxAYJef+K5naJ+HsBziafXcarb3FM6nKalornNYWQ75V
	 K014k4xVRApese9jR0HzvotQ8P8gobde6RrDkISB2oOsG3TdRsFDGUBBgy5evw8fTJyLK
	 JJ89CaH5M/nVADYsKSw5ZAYt8RBz6z0rsSfmzknJb9CWGaWYbfCPDPp7t8kVdMaGy5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="sJ/U7brZ";
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CF6606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:52:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0CF6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sJ/U7brZ
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd5d2dafeccso954929a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253160; x=1793857960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xr1LjWVaWfr7wmZpwhIZF79+9c7ND1pbwxs/kLwML6I=;
        b=sJ/U7brZlauFjsSJ/D4pFbzU7Yppcgxs2LUxksBK4eWLfoaqWrhMriDavinEXCKnYd
         nC5/VOl7FxVpi6ttKM/R3LVZBKeRDXBbrYB3lTi7mAFJ4gqYyIfgF2ic5xi6dc1ro6Li
         e4IeZ2I5vRRlSnjI5nS6xv1vY6+lghQSKTj+6zK92EZC1FY8mCsPM2ym8G3SS/TZ8Das
         C5+kz0DSa19Hxc6Z9kJQqUEpxGUuigugCrKBv3tqADut9u+xaR9hm6RYqBoENWxKEnPr
         Py9bo0vYTWpgj/cK3y3vf9ycGAuPMJuhPWm78jciahfA4xVh3xY+3AvUOBpM4V1zwzL5
         +Uiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253160; x=1793857960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xr1LjWVaWfr7wmZpwhIZF79+9c7ND1pbwxs/kLwML6I=;
        b=jTdx8aCGTRgRpvhI4zCWWzmbB6KIpEnKYxmtJai8jIXGopG/lWOJCR2hMTN0b0VGec
         aWEEgKdAqGQqkAYtWMtZr8Kkuk0OrVy3ftMig/B4KC2cwNY7WumQcnEd5oqEADhN6/Zw
         4MAF8s9lv9Jf3SI66ZxHQcy4lJRKfJs58i/zsVAqFgWo/iQJgL/CLhZNbgYeqFmWmipY
         CqoZAAxXlQsDrU/S8dlup5sRVqM/T3eKrlOk6L94+/wu+v+Rj7bHF7UHoBDR61cmIF3M
         RozES87THvLrVVNvxYxAh2VuhBIsIvvJrFIB7bIJGzgHsk11K79SKH47PSw7IZ0Ml8CE
         1FhQ==
X-Gm-Message-State: AFq9FYKgVYdCQ0IUYWg3So/F7XXmpkFwJbEwNkmXf4R15IDSS0La8Mtq
	kh4A9RpTZ+2whEDVhBrRDGX8zzknZPh4hy7bCCDvUSFEy3TKWlzEl2aa
X-Gm-Gg: AYBFou3yd27bGREKZU9jxbEBCdXai1EVluKOo3vgvd3JJaEJ/J0wxT7MWH6M1q1AAtr
	12PMb57t2M3nMZDp2yPAOnhICt+hmhY1Xu7IkL610FhfdaiDr9Zwo6O2cRLRigtufpwvD5bOiU2
	XxSZBG87XwD/8VZPTMlpOgX32/vC8JQ2rDS/73JfzsuWQQ0il0xZd0YtmdSzcRLoyhCXvyjFV6E
	mj7g5he6HrpUou//+SlvzBx2TKZEg4HkZJgKlekAp9knah2BF7m/hWWf9IxMZZwWQu5Q03YfZIn
	61JlGPuEFWoTObEnQ0YujDOIByryoj1OQGXQ/GWPz/E9tjTdMR2RG/GizmJG3t6d0bDlgZ9mr54
	FeTDmJ4U3Hqi1Vg6paavlLVYpVvnL79c+Jn0hzGUuO12YczcOiUiyAra7jTxrBxd3r+WSXZyHAT
	xP080lM9KluJTGpckQ3jpGxXtBwW+r0ZpHVmTgHPVSnddGuxoMCRKGMDljDPiCN6xu/5IKDhI3u
	yrye2VPXslciXgfCpVf57rglUCznTLDWPU9qFwZrARO7LnMAHsau59HhVFRV0/IY2y0dgAtsSKD
	j6dRPWdB51O/NQaHVwEIZmdns6oDUphh8H8pTe4io+AYOB/8Xgxmhl2JIGU69SNOnzAmlrl7/yX
	F/sPg
X-Received: by 2002:a17:90b:53c5:b0:3ac:a11a:7c7f with SMTP id 98e67ed59e1d1-3ae581006c1mr3078857a91.23.1793253160214;
        Wed, 28 Oct 2026 22:52:40 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2523531a91.0.2026.10.28.22.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 22:52:39 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] wifi: rtw88: 8812a, 8814a: enable STBC for HT transmissions
Date: Thu, 29 Oct 2026 13:52:03 +0800
Message-ID: <20261029055212.84711-2-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261029055212.84711-1-hjf3108@gmail.com>
References: <20261029055212.84711-1-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

8812a and 8814a support STBC, enable it.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c     | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8812a.c | 1 +
 drivers/net/wireless/realtek/rtw88/rtw8814a.c | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498b5c96e..f7d7b66844862 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1585,7 +1585,7 @@ static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
 
 	if (rtw_chip_has_rx_ldpc(rtwdev))
 		ht_cap->cap |= IEEE80211_HT_CAP_LDPC_CODING;
-	if (rtw_chip_has_tx_stbc(rtwdev))
+	if (rtw_chip_has_tx_stbc(rtwdev) && rtwdev->hal.rf_path_num > 1)
 		ht_cap->cap |= IEEE80211_HT_CAP_TX_STBC;
 
 	if (efuse->hw_cap.bw & BIT(RTW_CHANNEL_WIDTH_40))
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index 781b66ccde675..55f1d3d3240be 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -1077,6 +1077,7 @@ const struct rtw_chip_info rtw8812a_hw_spec = {
 	.rfe_defs = rtw8812a_rfe_defs,
 	.rfe_defs_size = ARRAY_SIZE(rtw8812a_rfe_defs),
 	.rx_ldpc = false,
+	.tx_stbc = true,
 	.amsdu_in_ampdu = true,
 	.hw_feature_report = false,
 	.c2h_ra_report_size = 4,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8814a.c b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
index fa02aa299b5e9..5bb55606f14a1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8814a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
@@ -2200,6 +2200,7 @@ const struct rtw_chip_info rtw8814a_hw_spec = {
 	.txgi_factor = 1,
 	.is_pwr_by_rate_dec = true,
 	.rx_ldpc = true,
+	.tx_stbc = true,
 	.max_power_index = 0x3f,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_2,
 	.amsdu_in_ampdu = false, /* RX speed is better without AMSDU */
-- 
2.55.0


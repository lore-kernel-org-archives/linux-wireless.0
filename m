Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430618;
	b=JpNCMu1KsmJBppkUo7Bal3+2s/ElvxHFyiqurALaAexb1cIqzqbsa1gPzglcpzmwLktK
	 bvntmAEkeji8XXI1K3gKra4lrcar5ddncxp/sU723orbBsFd0ocEHT2wwF+45hqlOo2C6
	 54dkJK2jytPB0IeRxfbSQNUogF/dbiUdQIAEo1DglNvyj+Qrk1B9WymjPOgkl8HkkjNCt
	 YIlclyMfeRcsYX91ne1HUJs+6xOoGWTEg8INpTy9jc5MOCkTnI17cM3Pd/T4qReRnPb6B
	 5xR6zQ82szvosfBcLp8xFdqfyMzTwv6Bf9Pg6g4oXeEohe6PhB8Sy6LUJw/Qq+TzoSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430618;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7sbNY/WAMdhZH7Xnw9o8nY/TwGJho7QORrZFGT4Ce9s=;
	b=lplirCa38uoL2v/PlIbet2ZFQbVveKGLJSFS8aSg7qusbdbq4bAlG+zB1X1JQGmIvatH
	 t9+Q0M3bWSzwoiuauoX+46Qm1ii95pO4IPYIHSFkAypPOB4XPrTAtHrr9NAMKaFQQZn0c
	 z4vSf0JRiZq4Bx8V0/NT0mfDBpmnY+9juXHR9vgvPJhV3cczKMV44Ng542DRBNQCAaphK
	 ZCkDOV9rIQVVPa1vMn9Qg9G484+r2p4WwsSet0rI+v7ctZTY8GMEVfFc2uKh9UQYFN7Hk
	 TpYSPpF/YsjNOdWa2AF7YqM8gR2f6/7igmO1SQL3QeTRps5LBOHHkaTiFtkJJXrtqPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NLM4ZQqN;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519EE606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 519EE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NLM4ZQqN
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d577so1104816a91.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430618; x=1794035418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7sbNY/WAMdhZH7Xnw9o8nY/TwGJho7QORrZFGT4Ce9s=;
        b=NLM4ZQqNONPnpKieAdDSk9C/hRkzE8HmIXy8q/e7aW58dZ9rbH8X/YHnCZP7Jo7OHv
         +YRmTGoGtWVHK0Cl3zWH+Ucf7KvCrU+P5n/x/zobyRgMyoSgPA6v0S/s2MtYvU9N0M0n
         35d/QUI1i6PunuDhQrQzH68J4ip4ebn40U9QjRJZhwPGNg7ZsrBDVpSkZmXitZWPJuJO
         H1X5MSXbN9hXXW9isG52mxdmAjj8H9gXBI8zTv9PRIaXTdznlVY9Nlw/a1T+ahrGIrl+
         /mC0WfdrklOwn18QOFroTtBa8RambCw+e97xBGyu65JKtr9rTrrJ4fFdRTZJUMgU6OGU
         goFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430618; x=1794035418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7sbNY/WAMdhZH7Xnw9o8nY/TwGJho7QORrZFGT4Ce9s=;
        b=vIs4C5MHaJPOv4t482PhffRFddlL60atN2t5yuMZMSN0hH27qoIr9AFzeoj3CUUxef
         ntJ/QF2dJUhmALN7v7Oi9a6QUsAX/jRy6JrmZAii3B4kdB10ihC/tX1nZLVcPeDjw68p
         AhJgLGdDGqo1yg/xklkGs92sRFr7fFSpqGa+ooQvXHkW54E2eIfA3mCRwKCdeAqPZk1K
         dk6GLYLiDn2kgaw8XuK1G335Pl2XhOri+1pbIJFI0S/UwYGbOECMz+SNc2h999wO6EvZ
         LIh1bYABq0KJwb4ttVGWsPtJQk+WzonDtHPbEQl+p4+sfr3sJUmY0odnhFX4ivgRptzC
         c1Uw==
X-Gm-Message-State: AFq9FYL5OfvVa3zFL9l85woY1i0xnvVAg0oWc0rMr0Awe2cHFZOYYzc6
	ltjzUZ/LXMtNlfjF9K2161CfiKf1YUQudyBiPRIrv/5s1Fan1/gwPvGsx5ke5Unq
X-Gm-Gg: AYBFou1+n5h272Zi84Odn5YTQP4svZwRHqZDRUl32bporBKHWZWoCnE78SooxhpSk1J
	Pvj9Gg071roBlHKv9VUKvqwOxONEb8UlTrtB/QpkDyNrP86Z2J03hvOK4lvw7UHrUpU2n4Dzzok
	hh5Tl25NPn9FcBaA00mn7js4XmLbk13XcKKppzgOnb8Fyk12c4ChC7QCJHgDUZWVE06Upen+7O7
	ngzblZhsu2spC3QTTxjUnps0Detyn4fXcUbkW+HiUYRIPcj6/25aD0dRbTtkE6gE7YYqoTgj5m8
	vx8zJWuhlEBe1G41YsmT6VnUVBqNIaEPpH81Ux5DF8ZYepNRbS0BuPvmvyDjQBqUKBCfosgDtap
	gEr+DxG6oBok/RYm+VavIJn2WdXpIb4ji/9Gi4Bc7u0/HHtbm/Klb2iYIuLT0PawVomAxOdSm26
	irz+MJXN5pPZiR9co8ZgGjIkI2ztwKi5a9NRv6bp0z3loljMFfoHdP+6gcG+0nUOOHvaCZC7N87
	XLa4/ioe4rxZ5Q75hdyYGZ+JkZOKMUkFY+vBDNR9WTEZ6gtUIysz1jgdwbVBsclAiQByDznaBrP
	z7Ry8j+32M7V0sNED4759RFmzz60nhjwMbrzVpsiCJqIsgiOBkxSplXBEM1yS13/CaYAHIKPCxA
	AULO3
X-Received: by 2002:a17:90b:390c:b0:3ab:e588:c2a8 with SMTP id 98e67ed59e1d1-3ae8985c4e4mr3656477a91.64.1793430617736;
        Sat, 31 Oct 2026 00:10:17 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm6670459a91.3.2026.10.31.00.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:10:17 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2 1/7] wifi: rtw88: 8812a, 8814a: enable STBC for HT transmissions
Date: Sat, 31 Oct 2026 15:09:41 +0800
Message-ID: <20261031070950.425176-2-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261031070950.425176-1-hjf3108@gmail.com>
References: <20261031070950.425176-1-hjf3108@gmail.com>
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
index 0f23498b5c96e406581c06a524e9f270873866ae..f7d7b66844862ff01533b8b640ed35738169673d 100644
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
index 781b66ccde675a96c41f69cfb80484ba67c20c16..55f1d3d3240be24580bdc4a7b3456b8ff8340e70 100644
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
index fa02aa299b5e9925428f591a609db2d9f8627ca8..5bb55606f14a126806acb354658c150150ae0cce 100644
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


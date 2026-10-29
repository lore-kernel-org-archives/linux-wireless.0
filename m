Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253178;
	b=RB04EzafNWPJWs8OIcBP8hoECOoYlx4/9yo37ki68wDkNINQkJPUnTVf6LGh86IzAyDu
	 e4jWWFE/d5apyKl/3cQUFNVzHw9iwEpCMESH6EuapDUkjVpaCTxCROWVyXz1SCJeJL52S
	 3xsgsX+0tjLLET00x2Sg9vc+8xUUcdMqksTIljQO5kna+GLkWTUMkzNQOU6ndCwOwu0u1
	 FtrkrZ8xLNeo5exvEinDY4xw139SlClMOAYVxUe8NuJ5hHvS0UfyATgrFkwLEAQqcL7oi
	 +3nPjdf5yhRCIpHGe4qUymXbiw8J6VIMCeHPTaKxP88HtvDRdGr+aIpg6QuaEPv0rcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=M8bCmThDt0YJFHXDpul2iss+Vx2FuxVtz2FwcpBia2k=;
	b=CP9Qi+3fZ+a73YMq0wDX9nAAHhSqyocJuxHIqVra+xX6fkwW5WNZUZbvTCA/3KoAKxLJ
	 0eh2wChPDRlVo34VY3tTnSyu5cSOtlIhKD/KfotTcA+ik0QHlz7/pMYtsKa0psro1aJGV
	 g9ObdM+yjJM+UfxWyT/K4eCv/vDMlOUF+CqsIT1cAvtik0Ce4rvxIVy8vmdAIXgZnnopm
	 hKMdZfsd03Hbx/SIFACrK3RHna3sQQ13YUjWU+OuiRJQ6JmkfP4ngfbMfeNtfr5YOn6FG
	 MilMN1gwzmuuDitp/DuRfeSFsdWE6zVLneITeIy6Osm46avwueEWB10e3CCKlO9B8wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sypdpnbf;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C66606A33B
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91C66606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sypdpnbf
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ea138a3497so10168755ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253178; x=1793857978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8bCmThDt0YJFHXDpul2iss+Vx2FuxVtz2FwcpBia2k=;
        b=Sypdpnbfmr9IshLjrviK+HWbHU5ZWjp27KamLdhvZ31Itwh/VFpma19KQQmM32nUCS
         QsrWBtSzAwKFIni3hrdBtxQIx8EOOorWIgKtfh376z0iR2lKHkyq41lk8NSbbB2X9zSy
         qQCLP3FewE2BN06Wl5RXJ+Iqlzb07uThZnUStmabsKCKj2MLzARsolWeyOpJN4xnV2SU
         CQ0nR9fJOpmwIBv4SEeR/c/AW8yD3KkmiIxFPgU1K390T2xufNjaSdP9tR3m4n+86Dgs
         Hz6WK2yTesvbOlINTtA64bYmsnzasGVLNGdwGvZ0FChtW4gbj8OnZefOYPHwpW8/9U8m
         Rd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253178; x=1793857978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8bCmThDt0YJFHXDpul2iss+Vx2FuxVtz2FwcpBia2k=;
        b=dh1mAKze+NNy45fUK2a9hCvbuBNG7zwnrOz8hHReKnKpIp3ugxDn+gbwigU9VsA/YB
         RziAn9Z1Uiqu0K3z+3BH4AkQSW6MfeZpmxCtHGfweoXDYJGG0wW6N5Fo0xziQuqhU3Ct
         sP/OLxX2RjVLbWk+hZk6UFvI7Tcb7MkazNes+Z7pEb1zQCVTOHapRvEVcYGrLFf1JQ4H
         UcFIZbn8TF8fVv3xaTnMpdBvc3uIQnpsmCbqSfhSuCkdWugNrN1Nn3oBieDRTXzLpzTp
         r2Cd7lbJKh9YKxLgVx2rVQ1L2XK7lfx556lM/ol7wU39v3+q4ZMPzTsoGQsoKCSKLmUl
         7tgQ==
X-Gm-Message-State: AFq9FYKUgQWFl2J3o2rBtWPdPZOX94Q18EAFv05Wp7weRNXaHjlDbDQX
	bgjO8TtYLMa9AeaiXBAHNauKxCIUbGEnScJuJXFGeGrs95n/XfcGJ4oI
X-Gm-Gg: AYBFou0n7+EDkDNjMON2xop3+6ZVxjEraXG4sOdknZSjt1A9jHWDpmZVsVqgkfuu7xa
	5cDw2rYTxeDkLgYWMuszvzZmfvM38ukgQRTTGk7ZwrKHDxpD0eRStFTu9ufYaP4Z6TBn/fwq5qF
	5NbWQIWGd559c0xri6TKi0JbPd99ljduaTOHDQYDIhHZJWEmcWELpZwxRXr/q/VlY2S/C3m2MbR
	tw6mM5YQsv3d57TkRMqnh5XI0XHuGOkjoOYnTnrZlhzxrZ9MRlsbylU25LSt1dhpl3KwIAjUdqI
	aixlBQ3duaZJomdmadOa0ga1S5gssb6EZpwqtdSLhCwmklZqiVs6cT6P86EK3q4djhkulth+I8J
	+qx0nZw+t5rilye7RzE+BTQhVuRBI0R4x+e82svTub2j14JQNy+kuprtDLQnt4qiyPGKmtBBNJx
	hisv9BA3z+s14s3UYG/W0R/WGnG551sKzqddXkpyv2k3WIqX9FbwPM3WI9G0jXrD+5zw8HR53pq
	l3au8g8sCfn+AkubkIT7NMrATMfaizfkCyCA+SqG15GohGyk5KWwdjsr20luCqsMVRQEZ06l0IU
	oF71TDws5Rr4jQBYVwsS3KLHcuHZserGTF8Nuic3N0xBQ+m13R4P1M6zEqMkekMnliY3nM/bCDE
	HpDHO
X-Received: by 2002:a17:90b:1e42:b0:3a8:cb54:e135 with SMTP id 98e67ed59e1d1-3ae580a9d74mr3463593a91.19.1793253177827;
        Wed, 28 Oct 2026 22:52:57 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2523531a91.0.2026.10.28.22.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 22:52:57 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] wifi: rtw88: 8812a, 8821a: respect peer A-MPDU size limits
Date: Thu, 29 Oct 2026 13:52:08 +0800
Message-ID: <20261029055212.84711-7-hjf3108@gmail.com>
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

Honor the peer-advertised receive limit for transmitted A-MPDUs.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8812a.c | 9 ++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index d93c4776e0303..a3b5fae5608e0 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -78,6 +78,13 @@ static void rtw8812a_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
 {
 }
 
+static void rtw8812a_set_ampdu_factor(struct rtw_dev *rtwdev, u8 factor)
+{
+	factor = min_t(u8, factor, IEEE80211_VHT_MAX_AMPDU_128K);
+
+	rtw_write32(rtwdev, REG_AMPDU_MAX_LENGTH, (8192 << factor) - 1);
+}
+
 static void rtw8812a_do_lck(struct rtw_dev *rtwdev)
 {
 	u32 cont_tx, lc_cal, i;
@@ -926,7 +933,7 @@ static const struct rtw_chip_ops rtw8812a_ops = {
 	.set_tx_power_index	= rtw88xxa_set_tx_power_index,
 	.cfg_ldo25		= rtw8812a_cfg_ldo25,
 	.efuse_grant		= rtw88xxa_efuse_grant,
-	.set_ampdu_factor	= NULL,
+	.set_ampdu_factor	= rtw8812a_set_ampdu_factor,
 	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
 	.phy_calibration	= rtw8812a_phy_calibration,
 	.cck_pd_set		= rtw_phy_cck_pd_set,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
index f7391f6aa3039..f597edec290f6 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
@@ -49,6 +49,13 @@ static void rtw8821a_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
 {
 }
 
+static void rtw8821a_set_ampdu_factor(struct rtw_dev *rtwdev, u8 factor)
+{
+	factor = min_t(u8, factor, IEEE80211_HT_MAX_AMPDU_64K);
+
+	rtw_write32(rtwdev, REG_AMPDU_MAX_LENGTH, (8192 << factor) - 1);
+}
+
 #define CAL_NUM_8821A 3
 #define MACBB_REG_NUM_8821A 8
 #define AFE_REG_NUM_8821A 4
@@ -872,7 +879,7 @@ static const struct rtw_chip_ops rtw8821a_ops = {
 	.set_tx_power_index	= rtw88xxa_set_tx_power_index,
 	.cfg_ldo25		= rtw8821a_cfg_ldo25,
 	.efuse_grant		= rtw88xxa_efuse_grant,
-	.set_ampdu_factor	= NULL,
+	.set_ampdu_factor	= rtw8821a_set_ampdu_factor,
 	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
 	.phy_calibration	= rtw8821a_phy_calibration,
 	.cck_pd_set		= rtw_phy_cck_pd_set,
-- 
2.55.0


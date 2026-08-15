Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E04632F76D
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 09:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786786774; cv=none; b=fT6QxzztgywVK3GrXxTUY2QU3GAqnTsRyoggXQb62GrqRVpcnoGVS4hwzXZGIbwQCgjllGG1f1zmCFlbUKURQ+P/B6U60I/v3hXkM++QHFHb4y6Mel5aRq1MlQuY1ZrbuSKg9FPA8VD0EKYMdmmaBg4dYe8uU3JVNmm77smZ/pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786786774; c=relaxed/simple;
	bh=J7WWIorQALvl1TB/piLk+5x36QCOVw2Ew4N4qt78e6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpB1bHBeeEbqbM2sLpWA6+q7F6VADE2Hu7IfTPEUpGAA7LWX7E2/pqNW1HpaqTWX1U5fIjKhNKXKndYE8QkgC21Eg5tMROm5vyIv8bGZT8R2bGkVeiEwHu9eTcOgnqHpVm1P1OuLFo/j32gIghHRdS+5d8Z4oRU0mnFczcX/xC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fuzL0rFX; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fuzL0rFX"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b0f19bea2fso1962076e87.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 02:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786786771; x=1787391571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mTp5tt6o5viHIfZHu8ddHYkmMFpAt4nOgEqLQ0bcKso=;
        b=fuzL0rFXF1ZQtSNWdjtc8Fte1XIpMIiweE75ygP7c3n5uFD1NBjKjLauc+OcrQrfg/
         GcJBi476SIMloCGRsxN1b8XD48te61VP5Vq4Wchncdj8LPFUW9BBOmTGkYgHoEdSgCyd
         dCCOW4GNe9NmLjgfA0fvJP5hTFnxfQhL2ESh/Yx2Fp2HAd+vSmQO/jaH9j1NnAQ1aQ/E
         soEr38uHocweQ04SpUyZCwTEZf8MZddP/hDZkDRC+t7bh62HFotA89iva9e+Szlmq+uk
         wpengDXB5JvfB60higZnHnIP4bmVSvTED3VF5bUznht3lCQHf1DHvZtWWGlRyHqnw1/h
         uzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786786771; x=1787391571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mTp5tt6o5viHIfZHu8ddHYkmMFpAt4nOgEqLQ0bcKso=;
        b=lCE1muEXlBZL6sQTQV7ETLqfLJmdcw1ANx6WQQyQVG+I8a3jqVcU72BgDUdndSwpbV
         +iqfxXbcCcyM81dzUJ9kRoB8sDjRBWqOQcwql1GSMjp88i0thK2okCtfI1xKmkwZRUlj
         QPdd1O13vXtD5jNM4+bUCyXbelcjmQNj5tCT0rH5F97JedyVPrSWV/5AqYk0yd/KxMJS
         f5xCfNyUZwn6fC1IBowgph5UzFxmitGxwWkw/CpWcQXJJZS6X/UwvHKaSyAOC/62qE1P
         Oclo6dknNmHGJqfB1nSIuShI+gcAQV+QjdW0qa79pXFJHzc5BuvEH9HFMcCGlHm55yhm
         Fh9w==
X-Gm-Message-State: AOJu0Yxx3VjbNaWzE/fh/uUgUPpgcFHeudQtdZr1OQOdptTIO6mcHncK
	cnP6ZUqDHmvgyysDOUbe64AIz67pEl6YYTCEANnqQq4Mp1brZG9hpn8y
X-Gm-Gg: AR+sD10mv1BOOfdwsuK92VI8CHWKQo0J83JEVZmnSyaAU93/n8116AuHC3Gfu/IqFS8
	mugjpv0a4j1imA9Pv8/U05iYIC3ipu70Z5PQhntBiIDAsdMiWgsS8jO6GToKsGQ4Nfcpind+k2k
	F6bCFnvB8hYbunYDhaedYe1P9os0dFcGIM/cbB6IZkarfK3SDTw49DcEz+XUEApOAjzfjoi2MJK
	RHVBIIh2edsnGmbpO1spDc++1NOdyUidRNvUBvLjMYBUn9mDJUg2gwv4FUW4yD1h+OhtirmB26u
	kr3UyklGbjKwI/5eJwfN4Wcj/ZgPtlM5ACi1R00/IgN5HcZZAZnTc1qtMhxapoN4bLaW5FPFTdN
	AXHTC0WRsCqrVs5qW6reW8aVf+pwwcm2imMihVG+DCep1VI7s1oMQKeAa/s82vIRq7fpX/hwoSo
	1SSnTui0ZWxhgAcIHnfTDT5DSA5AoQmKUx0NHxiArz1GqHItn8720GEULfieFv5gPBKsAHkOrrU
	qviOVt36hxrB8vsruUVR6xtcAJd15UBiF3JOZWt48sThM1fphB2bO0BF8bgzg==
X-Received: by 2002:a05:6512:6891:10b0:5b4:508b:de9 with SMTP id 2adb3069b0e04-5b459182ae0mr1046879e87.25.1786786770986;
        Sat, 15 Aug 2026 02:39:30 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bedf9fsm1040316e87.46.2026.08.15.02.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 02:39:30 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v6 1/3] wifi: rtw88: rtw8822c: Use bitfield macros for DAC IQ sampling
Date: Sat, 15 Aug 2026 16:39:22 +0700
Message-ID: <b23c1d0c33b79728f5717b0f15d0cb7541bd9493.1786784750.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1786784750.git.ulijg308@gmail.com>
References: <cover.1786784750.git.ulijg308@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define proper GENMASK constants for the In-phase (I) and Quadrature
(Q) components of the DAC IQ data register in the header file.
Replace manual bit shifting, masking, and rtw_read32_mask() with
standard rtw_read32() and the FIELD_GET() macro to improve code
readability.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 18 +++++++++---------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |  3 +++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 244c80264..137544649 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -291,9 +291,9 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
-		temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-		iv[i] = (temp & 0x3ff000) >> 12;
-		qv[i] = temp & 0x3ff;
+		temp = rtw_read32(rtwdev, 0x2dbc);
+		iv[i] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
+		qv[i] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
 
 		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
 		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
@@ -344,12 +344,12 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
 
 		if (i_delta > 5 || q_delta > 5) {
-			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[0] = (temp & 0x3ff000) >> 12;
-			qv[0] = temp & 0x3ff;
-			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[DACK_SN_8822C - 1] = (temp & 0x3ff000) >> 12;
-			qv[DACK_SN_8822C - 1] = temp & 0x3ff;
+			temp = rtw_read32(rtwdev, 0x2dbc);
+			iv[0] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
+			qv[0] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
+			temp = rtw_read32(rtwdev, 0x2dbc);
+			iv[DACK_SN_8822C - 1] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
+			qv[DACK_SN_8822C - 1] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
 		} else {
 			break;
 		}
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index fc62b67a1..7bea99614 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -141,6 +141,9 @@ const struct rtw_table name ## _tbl = {			\
 #define DACK_RF_8822C		1
 #define DACK_SN_8822C		100
 
+#define RTW8822C_DAC_IV_MASK GENMASK(21, 12)
+#define RTW8822C_DAC_QV_MASK GENMASK(9, 0)
+
 /* phy status page0 */
 #define GET_PHY_STAT_P0_PWDB_A(phy_stat)                                       \
 	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
-- 
2.55.0


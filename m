Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6146D2CE
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786545976; cv=none; b=QvrrKrARk97rdVoK/f8NVmmbbF1nl/U7+M2H6yKcXFjjn5m9aigQu/g/bJwagBeXPgMq7O1u5LqHMWSanQBl8e7L4zMTBO1s/OEsJ+skOxSGbNd4O+90YtmRs93jArPeGkYKtchiEPj9S8pT3c6VQ+wZGoCkiUvH1hxqNEIIWS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786545976; c=relaxed/simple;
	bh=mD4MIu7A6RBKLGLZhcQN38rVB6TQlU0KUw0OmGTmwG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDf92oODTJRq73VKgF0BAcPPX9iU8gFZxckw7JJIkPhh7mcnOp+scXpuWCJVKiXDLVVqzZKnfvbXtYQ8e+QS4c2sRTkRYYP1MERVBVvfvmuHXAC/Je5itsn9EYqjXbUXiKbP1N83oLpdnG3PyE9/fS1b8pXV0kw4/NPPFJ2Lo5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M1j2/GdM; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1j2/GdM"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b2a4359d16so1004254e87.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786545973; x=1787150773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kRTl+sLRqkpeXssOlH0oy3ZfbvcTh31CRPscib/8rhE=;
        b=M1j2/GdMTfpUeUlBGIcPbm2mPw/U0VSRHlD/+bdXIENCitM+tew85g3Cwu8qC0zCv9
         wZlE6fw5K/rANb7hYkJJu/9kV+0Dj3pnaDQVSmP4lbyXaAq2185hJKmArt2W1GlSa7iq
         PW4n9XYXQ9ro8QdfH8JM5TjaZKW5OEPH1WG9MGPoPI6+rUJdq0OZYuL46EBVels3ElvE
         AAsj2iqQLQrx0Hze/SfxyvTZ4z1t3hFmf0EO03OddKA+vdvRG7C9+iu44iM4QJ9ba73S
         4+DhargWc5HyxLClKrtPBbbuZm12d7jGhoigGCpG3gJqk1tlZ15606fV47Me5i/iMU2r
         2cSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786545973; x=1787150773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kRTl+sLRqkpeXssOlH0oy3ZfbvcTh31CRPscib/8rhE=;
        b=ewwYL+DoqrZ6pzC3MVlnjFv/elz/DcwNSIwc5wnyZDZr4DwAEfL0aO1FUIx6ffYvzm
         Sz8Zcb1qsDC0x5OEx4/JEuOVzYM1akg/fEpDCJwIq1L3NYW984sw68/9S/1NC4gnx8A6
         Em0+22KlSRvm6Tyw9K8bgdzal7QZFP3UZJ0BmBNhv1jww9hbEVfqaF1dkxZwAcwHpl0u
         bBmm/owREgdX/k5AiCTngcl8E3saJMZHuhJbPaL3sqWFWLyqyX61ySh5rBGsJ463vgGy
         q3LZ9bRojwdJh9eauv4jeQD7PqHE7lgomEYpPdG4bM8ra3sRjMCUNYqX74Yyp4pbX0Aw
         OlLA==
X-Gm-Message-State: AOJu0Yx9uN+iPaWFykKeC7zn4xOfS7h7MoBhJyzirLZMxecMwWzrLlu6
	En30JZVppRBCUIQ7BZH87miO56WpI6FHSRSbDuxc1Bbu7X+P9vns6w5T
X-Gm-Gg: AR+sD13mQ+Lw+BG7Xpzs6fG2FHtfkrbSt2QpmAtFvI7r6DFk7RSauiPpto2eKaGlbYU
	+ZSIrLN9oNLMSxAqZWI+Vs48zlNLZbpTnKSFw95UweOUAjdUYioSu6HzYRD0ljdrTf4qHgKvMUf
	pyk4LBVV/FWpZ5/TlBGq43tllgsk4etxJ8eQgw+OyEMjnXzvgGpjCGb/0SlIbE1joHxK0kGthCX
	BbjUNTjKpLhPOmoqzDunPdxREaBDJCtSX2Q3XG1eXwAv+L4nmXMQGeo5ahRecQdAM9h5vauATqc
	a7gRIfKj2cEnUBJ5uIXkMtMWjG/IgBlP0/KWWWW2xa/qW+UWY3wcVPWOpKuR4xTFv26H/IEtoJU
	VwCogtwv1TAVAIH1sDM82vx4xIBuwN2oG7StOcyhSwYN1D+dYvhbt5ia61LmBj2xuRB9j4YZcAn
	si2VdiD5s/hwdtaIrWJ8oJiQSBKF06VSESS0ACXNhaoTLIpCvxs6bIwYGdaA7mU5u6Rt2ZlkXf/
	6ov+aNbvm6FaPDvBzg7fT8YhicW8tqZDMan5axPSmOCq0oqM+fxTDC7z0xKpKYF7VpE7OuG
X-Received: by 2002:ac2:4e94:0:b0:5b0:162e:127f with SMTP id 2adb3069b0e04-5b44e311c71mr557961e87.29.1786545972703;
        Wed, 12 Aug 2026 07:46:12 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b44cfc27besm552179e87.21.2026.08.12.07.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:46:12 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH 4/4] wifi: rtw88: rtw8822c: simplify amplitude search and offset via s32
Date: Wed, 12 Aug 2026 21:45:46 +0700
Message-ID: <0bb6e2fb78d0b2def623210938204a0efbbe2034.1786545572.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1786545572.git.ulijg308@gmail.com>
References: <cover.1786545572.git.ulijg308@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complete the signed data transition by removing the complex
rtw8822c_rf_minmax_cmp() helper. On a true linear s32 scale, finding
the delta amplitude simplifies to a direct difference (max - min)
without any nested circular wrap-around conditions.

Refactor rtw8822c_dac_iq_offset() to directly calculate the trimmed
arithmetic mean, casting back to the hardware register's offset
orientation only at the final assignment using a ternary operator.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 103 +++++-------------
 1 file changed, 25 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 642ac2e2b..6fcdfc64c 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -155,38 +155,6 @@ static void rtw8822c_dac_restore_reg(struct rtw_dev *rtwdev,
 	}
 }
 
-static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, s32 value_s32,
-				   s32 *min_s32, s32 *max_s32)
-{
-	u32 value = (u32)value_s32;
-	u32 *min = (u32 *)min_s32;
-	u32 *max = (u32 *)max_s32;
-	if (value >= 0x200) {
-		if (*min >= 0x200) {
-			if (*min > value)
-				*min = value;
-		} else {
-			*min = value;
-		}
-		if (*max >= 0x200) {
-			if (*max < value)
-				*max = value;
-		}
-	} else {
-		if (*min < 0x200) {
-			if (*min > value)
-				*min = value;
-		}
-
-		if (*max  >= 0x200) {
-			*max = value;
-		} else {
-			if (*max < value)
-				*max = value;
-		}
-	}
-}
-
 static int rtw8822c_dac_iq_cmp_s32(const void *a, const void *b)
 {
 	s32 va = *(const s32 *)a;
@@ -201,31 +169,16 @@ static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 	sort(qv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
 }
 
-static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec_s32, u32 *val)
+static s32 rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec)
 {
-	u32 *vec = (u32 *)vec_s32;
-	u32 p, m, t, i;
+	s32 sum = 0;
 
-	m = 0;
-	p = 0;
-	for (i = 10; i < DACK_SN_8822C - 10; i++) {
-		if (vec[i] > 0x200)
-			m = (0x400 - vec[i]) + m;
-		else
-			p = vec[i] + p;
-	}
+	for (u32 i = 10; i < DACK_SN_8822C - 10; i++)
+		sum += vec[i];
 
-	if (p > m) {
-		t = p - m;
-		t = t / (DACK_SN_8822C - 20);
-	} else {
-		t = m - p;
-		t = t / (DACK_SN_8822C - 20);
-		if (t != 0x0)
-			t = 0x400 - t;
-	}
+	s32 avg = sum / (DACK_SN_8822C - 20);
 
-	*val = t;
+	return avg >= 0 ? avg : 0x400 + avg;
 }
 
 static u32 rtw8822c_get_path_write_addr(u8 path)
@@ -280,7 +233,7 @@ static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value)
 static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 {
 	u32 temp;
-	int i = 0, cnt = 0;
+	u32 i = 0, cnt = 0;
 
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
@@ -298,34 +251,28 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 				       s32 *iv, s32 *qv,
 				       u32 *i_value, u32 *q_value)
 {
-	u32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
-	u32 i_delta, q_delta;
+	s32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
 	u32 temp;
-	int i, cnt = 0;
+	u32 i, cnt = 0;
 
 	do {
-		i_min = (u32)iv[0];
-		i_max = (u32)iv[0];
-		q_min = (u32)qv[0];
-		q_max = (u32)qv[0];
+		i_min = iv[0];
+		i_max = iv[0];
+		q_min = qv[0];
+		q_max = qv[0];
 		for (i = 0; i < DACK_SN_8822C; i++) {
-			rtw8822c_rf_minmax_cmp(rtwdev, iv[i], (s32 *)&i_min, (s32 *)&i_max);
-			rtw8822c_rf_minmax_cmp(rtwdev, qv[i], (s32 *)&q_min, (s32 *)&q_max);
+			if (iv[i] < i_min)
+				i_min = iv[i];
+			if (iv[i] > i_max)
+				i_max = iv[i];
+			if (qv[i] < q_min)
+				q_min = qv[i];
+			if (qv[i] > q_max)
+				q_max = qv[i];
 		}
 
-		if (i_max < 0x200 && i_min < 0x200)
-			i_delta = i_max - i_min;
-		else if (i_max >= 0x200 && i_min >= 0x200)
-			i_delta = i_max - i_min;
-		else
-			i_delta = i_max + (0x400 - i_min);
-
-		if (q_max < 0x200 && q_min < 0x200)
-			q_delta = q_max - q_min;
-		else if (q_max >= 0x200 && q_min >= 0x200)
-			q_delta = q_max - q_min;
-		else
-			q_delta = q_max + (0x400 - q_min);
+		u32 i_delta = (u32)(i_max - i_min);
+		u32 q_delta = (u32)(q_max - q_min);
 
 		rtw_dbg(rtwdev, RTW_DBG_RFK,
 			"[DACK] i: min=0x%08x, max=0x%08x, delta=0x%08x\n",
@@ -348,8 +295,8 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 		}
 	} while (cnt++ < 100);
 
-	rtw8822c_dac_iq_offset(rtwdev, iv, i_value);
-	rtw8822c_dac_iq_offset(rtwdev, qv, q_value);
+	*i_value = rtw8822c_dac_iq_offset(rtwdev, iv);
+	*q_value = rtw8822c_dac_iq_offset(rtwdev, qv);
 }
 
 static void rtw8822c_dac_cal_rf_mode(struct rtw_dev *rtwdev,
-- 
2.55.0


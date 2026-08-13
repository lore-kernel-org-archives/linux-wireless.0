Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C2742BC43
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603975; cv=none; b=YTRH13XH2gAdNx5NOZzJeMjG5EVOaB6zXM7AvaOykulSKXe5vy8RPxMfKNTD9esn8IpCMrp4XXEC9SyfywmQnnGKq0UBo0ZLMrGwSayYWHkM0tTa5KfUn33sAx8rzV85nGHlzkYzi3pqueq9q8CgK1WWikdgl0VY6yQyoVhgKXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603975; c=relaxed/simple;
	bh=mD4MIu7A6RBKLGLZhcQN38rVB6TQlU0KUw0OmGTmwG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAX6fm+dXRTBCBAXC9rO0faeYXKqSy6Tvpz409XaOGHgL1gKNc382O7y0YFAkiGx0RF79G7TFnOghJq6/GUjUhFneW3OQfxXvnkWlmwsmGCqDzrpXF/UsiIs85Y8nRbhiG+6Ze965eW1tYke3xAOltfM36tR27KToZPBLgE3Slw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SWhuLZyR; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SWhuLZyR"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b013aa02b2so803713e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 23:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786603971; x=1787208771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kRTl+sLRqkpeXssOlH0oy3ZfbvcTh31CRPscib/8rhE=;
        b=SWhuLZyRh657YJrnjpn4S3tebS0WdScj1A8xkz8NDEqnTpuaSfmZaZ2dUwKSP6qH6Z
         4gev1e4NupWGuzRo+MjwHNTheemSC9qm6WYEmrlGZ8ZnWj5kwCANicNXJIDdxPgPFxuY
         B4W+CsZRI7LivIHBUMMvekFYaC3Fjo9F8UKSYke8QVAXv4Vvnau56qbsp/qyaFKa5DbA
         Tin0vTKKS3BbwBjLb5tYgF6i1zolS0hwbiz6HC05LtNe2YzqdD8vs4eYaKjZXbZk/5q1
         uH/G74H3a3/Y918aszNQxloUc24xM1yAxY1rlunn7lANLpqIX+sawsW5mRT9b/6d6OYX
         kc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786603971; x=1787208771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kRTl+sLRqkpeXssOlH0oy3ZfbvcTh31CRPscib/8rhE=;
        b=SCDdnm36yDkViiycqjcJ6RC7vnw2ZfZyfjphTK8VC83XewwVSYIB/lboJrhjoLNfkP
         c9/fiPATofwIjBAm4hf0224YB2toiMWE0FLSZO9BCQKjU92wBz/7XJvoQn4XyG/XvoU4
         SQM6EA66nrThac9AIKMPLCyMDr0XJ6rrkOBai5YFfTfh1fhLXUUgHaYTGy5BRoKYUK0+
         21Fkh/qnD2vUdkBSkY+R0tdx/64HYwct8lX8vfCkE6YMgwYCsf6oqn6CqzQVjcynPnas
         VM3UURlfNi+fHn44Gmvuv0Ojq+VcMoJ/Fl6kIO7k0HzuoFyBx3/Do2nkVY12AKXw/N7X
         WLEQ==
X-Gm-Message-State: AOJu0YxG6lr3mckLygUE57NCzcChin6aHI4wm5yRHlvpyohnn3+OT+Kh
	yjkhCrgyNJINa/QxeenFSVghyUa9SxeMicqG0gFZi8x5gvI8E8xrrerw
X-Gm-Gg: AR+sD11+2eWZ7kG3Nm3WJ+f53Vd9h5IgSOYqCN6XUkc5p6eG+gw1+fT+fO9IHVSI3mi
	oRAyBgmzWAbHtDqxeePWLXwmMcuqnSK34POr/0dXTJN4D+9VonYICpInpSOELU8iYO+LM7+LNjx
	0zrEu0zM1LxXXkmuT+4zuWFDUM2jZbiokg4zcGVL7UJGreDSd8ccKZ3AyZt1HkQAcwjE1adhxZi
	1c09E1WAyslHofIJ98y3tNyJHLA9MmUVYGJXRNEjgC8gbJKraHv9p059yuIcyk5Q0MadUwyOzib
	JM8V/70P0DKJQNh5mdwaFHHlP40QvaAwVBTKI6J/kmZp/g/Ci7s/N8Soldp30c+o01VZdN5uANW
	pnn2EK0dZQlmdwjjS+bLYok2F6kSnZcoccY5T7BO09LAVzFXVgG3KBtO0tOArHaZlL/hcfmNDdW
	XGSfXWPNlfD694WLmXvNW4BKzkLSdlH1criu+ye+r5HAh5S3D6XePnL4i7xV6zOa8QE2deAM+WZ
	TY/wRFaM9dMDCvz8ctUMCIcd5rTFBu+dLW7Ok4zid/inlB7K8tvWw3VLpZ73A==
X-Received: by 2002:a05:6512:239c:b0:5b2:aa5d:9ce7 with SMTP id 2adb3069b0e04-5b453cc56afmr627846e87.10.1786603971325;
        Wed, 12 Aug 2026 23:52:51 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b453a54adasm270076e87.38.2026.08.12.23.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:52:51 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v3 4/4] wifi: rtw88: rtw8822c: simplify amplitude search and offset via s32
Date: Thu, 13 Aug 2026 13:52:35 +0700
Message-ID: <0bb6e2fb78d0b2def623210938204a0efbbe2034.1786603749.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1786603749.git.ulijg308@gmail.com>
References: <cover.1786603749.git.ulijg308@gmail.com>
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


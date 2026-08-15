Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DA33403E3
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772132; cv=none; b=Jb/xO5UwVJTBHgWUj0cl1udpoI/rzMa6m49Lg5UVYJje1NcEH8iuNWp8HZ9sbR2sKpX319jZJxqrEhaPEG8Bp90oOgIK7wCazIzZ6S0/XdAQpaJsKlChLuTjkXDwtg26PSUrkjkCu/DaiVSsx8IxTu9ZAnni05ROinWX/4QcVfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772132; c=relaxed/simple;
	bh=HByq9m7lBxfCNopVjZgb9eKta/j3QpPqZjE7P5Sg6po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnFq3ianGQQXXjfV09wXml7LlgvzRVWHfkcQvGosuPFGh/wqLhqDh33GsQQbIGYB5bdL/L0caTSxTV82jbrpquskYmCvj540Q0NVCYTFdPuuuV/Ahg4/auNR93s04t8OBl5odJDuS16MpMD9hvl4Ad4GSRrJLhiQbMBLxqdw0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nynrHd8E; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nynrHd8E"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2b92065ffso1639605e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772127; x=1787376927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VBjBB39CWHysKIWdHjezan94xorylFai+aoWWBeQxGI=;
        b=nynrHd8EadYsg7qP7IkIcyhZZoqob1QfpRQIkiHLcUtpezpHksXAz9Lg8QPnMTPooc
         jzkMg4j49hbNQMiVe6e6FR/Qm7UgC2YqIOl1tozO1n69WkJne8IN0awdRmGGfGdaOGDD
         5Tg1rsLn4SeeNelU8Y596x4NYcFDOduJaBUCuIP12YiVLE4iiNjknwEJD+Z7wJt/i3Zp
         dItbQKbP3y3BX+SHEMzYEBJAPbuPh7hrSxWH4UrZ7FuVsjdyAzuo+SPq1f0dzcqvVKQH
         BivHcB9TJq4nj+cAjG6ffgVwrS1kueROvUCibbkgZ2c/+hcV+HWORCoSzf0lKiEEbqdk
         38ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772127; x=1787376927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VBjBB39CWHysKIWdHjezan94xorylFai+aoWWBeQxGI=;
        b=h2pxuhCnjjVygMG6BzbQx/YPjkwuMbRaYeaw0crD66L+m4RloRPK9tB0IRswY0en68
         XHDZexngevrT+VryNOJPlsAFbOcUXk+cC1XeiyUAbn6EwtrRPkvg25ub2JypdVdwUg/W
         DGdRsbbRfdnNy61dRw5syG+9ZuYVmZM8wpwaBd7rDBUBB59uP/NTeIRuGcgVIvUz5Wkx
         yGLICt5JvJ5/KQAgL5yxQMZvOmGe/oJ/ECByLwWSVrM/yKAX2Zf6qqbRL5JsWcIVjLCD
         xbw/RrSyLrIZWhh01mK5Be47kYhG7SNXbD0Q4BcZc6tt9uvhc8nlTsTufvxZ8hRlZnHB
         g7wQ==
X-Gm-Message-State: AOJu0YzrVgoVE0JtS/rOmK0w2YOeSwwII/8xEUWV0tjVXFZy/oDJpPO3
	70/JBBdN/A23Yu9q0bWKdbxcLoZSDoXLzk8YDiGCstUTuW4M+mFoDRDV
X-Gm-Gg: AR+sD136dEpTxIUQN3g6PevTNEJux8oo1pz3+DYTBzSvpSgE3AP6kwLaHeT5ry3UAPW
	mVrjBYkCuoc93A3+N7sfvZBoWdo23uII9r4L2BE1lRdRddAoCsff/TTc3qE36ES8K04wmS2/YiT
	X2dButgwmm2J5VLJEbfXcJ4Y2yeYfGK+5r5GfUw5UnD5WqAdLNoQGjjNxWgy54DEn7z9BztV1RH
	Yg95lMdsFGSl/6QdRiMqUK+TO1pR15aFcPh+JMtqpOFMcNnY8nUknole65bj5m1lG5bficYiWfC
	suuYekavM9mBvsya3wL4s1uhqUlPe5QSH7Q/GoBdyywTF2QSDvswH1C1SpbgBw0gV2DEIdTGzI0
	wuO8hL7d7+eWONnmUp6hr/46MSdc3Tpqm7ym97TG83E/Gp4YroYBbYWRT30ZM5r6lXK+wkME/Mb
	KPAcvwK4Qb+SCgxXjjwz3fx11VjDV25zzQPnXxXpoEwS3lshuXdzg02ZybKxA+pCAR0fRBu0GMx
	oQ/TYKeF0eEYWFYo2tA8HnovhiJ0j1VZpQjmxtfo8BMlHo0OOAhviyXyCNM7g==
X-Received: by 2002:a05:6512:8358:b0:5b2:a600:e496 with SMTP id 2adb3069b0e04-5b45916c885mr1091834e87.24.1786772126410;
        Fri, 14 Aug 2026 22:35:26 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458c0a033sm932577e87.67.2026.08.14.22.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:35:26 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v4 2/3] fi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed math
Date: Sat, 15 Aug 2026 12:35:18 +0700
Message-ID: <c80e63320a2a5a1d0041cd64751ba7d2328ceec0.1786771562.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1786771562.git.ulijg308@gmail.com>
References: <cover.1786771562.git.ulijg308@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the temporary stack arrays 'iv' and 'qv' from u32 to s32.
Update all internal function signatures to accept s32 pointers and
handle signed values natively.

Use sign_extend32() combined with FIELD_GET() to properly interpret
the 10-bit hardware values as signed integers. This allows flattening
the complex nested unsigned boundary conditions in
rtw8822c_dac_iq_check() into a simple amplitude boundary check. Ensure
rtw8822c_dac_iq_offset() properly maps the signed average back to a
10-bit unsigned format expected by the hardware registers.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 127 +++++-------------
 1 file changed, 36 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 3bf9291d6..6ad90d321 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -153,49 +153,14 @@ static void rtw8822c_dac_restore_reg(struct rtw_dev *rtwdev,
 	}
 }
 
-static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, u32 value,
-				   u32 *min, u32 *max)
+static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *v1, s32 *v2)
 {
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
-static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *v1, u32 *v2)
-{
-	if (*v1 >= 0x200 && *v2 >= 0x200) {
-		if (*v1 > *v2)
-			swap(*v1, *v2);
-	} else if (*v1 < 0x200 && *v2 < 0x200) {
-		if (*v1 > *v2)
-			swap(*v1, *v2);
-	} else if (*v1 < 0x200 && *v2 >= 0x200) {
+	if (*v1 > *v2)
 		swap(*v1, *v2);
-	}
+
 }
 
-static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 {
 	u32 i, j;
 
@@ -207,30 +172,16 @@ static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 	}
 }
 
-static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, u32 *vec, u32 *val)
+static u32 rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec)
 {
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
+	return avg >= 0 ? (u32)avg : (u32)(0x400 + avg);
 }
 
 static u32 rtw8822c_get_path_write_addr(u8 path)
@@ -271,20 +222,18 @@ static u32 rtw8822c_get_path_read_addr(u8 path)
 	return base_addr;
 }
 
-static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, u32 value)
+static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value)
 {
-	bool ret = true;
 
-	if ((value >= 0x200 && (0x400 - value) > 0x64) ||
-	    (value < 0x200 && value > 0x64)) {
-		ret = false;
+	if (value > 100 || value < -100) {
 		rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] Error overflow\n");
+		return false;
 	}
 
-	return ret;
+	return true;
 }
 
-static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 {
 	u32 temp;
 	int i = 0, cnt = 0;
@@ -292,8 +241,8 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
 		temp = rtw_read32(rtwdev, 0x2dbc);
-		iv[i] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
-		qv[i] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
+		iv[i] = FIELD_GET_SIGNED(RTW8822C_DAC_IV_MASK, temp);
+		qv[i] = FIELD_GET_SIGNED(RTW8822C_DAC_QV_MASK, temp);
 
 		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
 		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
@@ -305,10 +254,10 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 				       u32 *iv, u32 *qv,
 				       u32 *i_value, u32 *q_value)
 {
-	u32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
+	s32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
 	u32 i_delta, q_delta;
 	u32 temp;
-	int i, cnt = 0;
+	u32 i, cnt = 0;
 
 	do {
 		i_min = iv[0];
@@ -316,23 +265,19 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 		q_min = qv[0];
 		q_max = qv[0];
 		for (i = 0; i < DACK_SN_8822C; i++) {
-			rtw8822c_rf_minmax_cmp(rtwdev, iv[i], &i_min, &i_max);
-			rtw8822c_rf_minmax_cmp(rtwdev, qv[i], &q_min, &q_max);
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
+		i_delta = i_max - i_min;
+		q_delta = q_max - q_min;
 
-		if (q_max < 0x200 && q_min < 0x200)
-			q_delta = q_max - q_min;
-		else if (q_max >= 0x200 && q_min >= 0x200)
-			q_delta = q_max - q_min;
-		else
-			q_delta = q_max + (0x400 - q_min);
 
 		rtw_dbg(rtwdev, RTW_DBG_RFK,
 			"[DACK] i: min=0x%08x, max=0x%08x, delta=0x%08x\n",
@@ -345,24 +290,24 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 
 		if (i_delta > 5 || q_delta > 5) {
 			temp = rtw_read32(rtwdev, 0x2dbc);
-			iv[0] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
-			qv[0] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
+			iv[0] = FIELD_GET_SIGNED(RTW8822C_DAC_IV_MASK, temp);
+			qv[0] = FIELD_GET_SIGNED(RTW8822C_DAC_QV_MASK, temp);
 			temp = rtw_read32(rtwdev, 0x2dbc);
-			iv[DACK_SN_8822C - 1] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
-			qv[DACK_SN_8822C - 1] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
+			iv[DACK_SN_8822C - 1] = FIELD_GET_SIGNED(RTW8822C_DAC_IV_MASK, temp);
+			qv[DACK_SN_8822C - 1] = FIELD_GET_SIGNED(RTW8822C_DAC_QV_MASK, temp);
 		} else {
 			break;
 		}
 	} while (cnt++ < 100);
 
-	rtw8822c_dac_iq_offset(rtwdev, iv, i_value);
-	rtw8822c_dac_iq_offset(rtwdev, qv, q_value);
+	*i_value = rtw8822c_dac_iq_offset(rtwdev, iv);
+	*q_value = rtw8822c_dac_iq_offset(rtwdev, qv);
 }
 
 static void rtw8822c_dac_cal_rf_mode(struct rtw_dev *rtwdev,
 				     u32 *i_value, u32 *q_value)
 {
-	u32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
+	s32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
 	u32 rf_a, rf_b;
 
 	rf_a = rtw_read_rf(rtwdev, RF_PATH_A, 0x0, RFREG_MASK);
-- 
2.55.0


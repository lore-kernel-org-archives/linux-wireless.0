Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EB03E7BC4
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 10:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788602760; cv=none; b=fVjqC8giNh2lXUzzb7EIob00DVYNHe4xE9u0VRH9BfKH6HBtdGQ1Ipt+al9Pwx6AukO5Vnm+Bw4rL6ny/rtYE2ru1yN9bId9Dwokb1be120BjTfAXNVL0gKoyCOQG7mtxynhNJRP2o09iJAafJXUshlzIibvi6iv7YmjwmL6/Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788602760; c=relaxed/simple;
	bh=Whe7LKSU7peul1T6lvFdN+CuWYm1rV468che/7NJ/GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNiYr/2PXcs7O6tgnsVRtyVJUtImwh/m9NEfrEfr7v4Ny3R96NAW9pFcmnBk7KgJZuGuzWJop6Cur9gnPJ4OjLobA3dE8xfw3TRaFDrWKEWhjQrsvdF7baDp51iNqiW6X5T6UXO5QgCaHcYn329bxO4/OFh7SL1FqupdTCegrAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eAfw8dIh; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eAfw8dIh"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3a309f92daaso16988691fa.3
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 03:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788602757; x=1789207557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UVZO7xqLMmMI/VAYMXFHUsaCZa1hDMcAPBs6DtMLFLo=;
        b=eAfw8dIhGw8bftvcNa8mnM8sc2anksqW3+rs1HfRs47Y78SJ6TKB8AEc3Rb7fUr2s2
         ooAwRGbxwe4CeAvDJkfAFlzehcu9S09MJGoEWChm/GpB/aUIKlUZLgvCvQFOV5FbZPHu
         s3LWdgSXYSlu/GQCsjYtu/p2fOn+KDYI59iTcbPAbc7UuC/5d627VB7ddYx4ycHIY5d3
         V7jZ0smtBGa1frq6wdSQ+hccynRPWZWfK/S2eB83cIFEpdgF0xzUlH9R+gzLPF/UFuIt
         0qqUfV0eSo8vXm8/U6lIQZGedFAhBFMYPsnxvW1tm9b76Lqmd58xAtmfuL/pjXoWrEPb
         MICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788602757; x=1789207557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UVZO7xqLMmMI/VAYMXFHUsaCZa1hDMcAPBs6DtMLFLo=;
        b=swftTDwSmAhDaj76yN7UUgWjcGr+Mxjstgf0oxNcxnwxrFKJytMTSuzDPXh8oly95U
         lsovNP3GNTKVrRDNcCZspA6UfVt825YOc1WqTvH855CKihXrUPysA9ZjF/YkAtNM7yJm
         /s7P5g30yQ4rz41R0JPmcva0VGRpKpniJQH0BX7WtxoT08910FcuIAfonPuuQv0zmhl7
         HyP8uWh8v00t7WGJemWPrhsOLU62zZK5wkc+LnssAiRLlNDoWN/AgREMAQbL2lRqLJUt
         YBVFuGLvKiam1AuKvAO884CxCLkWG0w0BaEHhnK2Ud3r7+wcd6BEtBMmgeDt199MNvwa
         hVTQ==
X-Gm-Message-State: AFuF++mjCtnOqqT2lQvxpvSrE86gEWeG1y3kZ37uQqOEvJ0RkoESpHoX
	fVLy+SjKvld9lTUSKfMyeNvvrvbSLCZw+3rpsjztwBxP5jLh9mnLpiF5QW95Kyl2+Ks=
X-Gm-Gg: AYBFou3QH2/fbDc8KQhI5VS+3cM96ESjqsjcgPQc4DfLc8QFEUWCRLSfXYYqZdGUJBf
	BR67tSNCt3DYpLNi560ot9N71YDbGZi1lPKc95oxgFvxjVeb0PJllrSLnD3XOcTQsmvGjETGpVw
	9l0zn5bg2WIsAeShrr+D2LN08BY061yXDGWjO4e5jS5d4UHq/JTM6RjdaF7oFxZC91zdgYcqrs5
	brhJVW53psi9j82AGb349zYkOE5JiJB3AnJtuda1H37cjc/aifxI4d+GsWaJ5FKdGfN0UJK6ovv
	9fI+weMz7W6VlK5OxMjSyBNrBu+H3bfk7ymfmb7XhbGoWK7Jsn3zRhu1t0pQwpJF9EWCKyDhOiX
	Osxwwfm/hghAHTalSM34LxPx+mwCCzWkaWjjriOc05BPhCfoLtzx4MpFiMrZKgPSzUsS1jSucKD
	ZKJOuHWXlDzOe3DUsdJqFbJpm6xQt0JcxvOfuSYfs4zYEL1bIkaaXEVilPGn3hBKw7M/LGOxE69
	ShrJ+J9vR4OvvJC1D3QsSWymrop2Z5T3ocRr+98gHKC9UQbomp/8ZpeMm9i8g==
X-Received: by 2002:a05:651c:1543:b0:3a3:4997:ec3c with SMTP id 38308e7fff4ca-3a375b328cbmr9829791fa.2.1788602756438;
        Sat, 05 Sep 2026 03:05:56 -0700 (PDT)
Received: from archlinux ([94.180.80.42])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a3705868a0sm13107741fa.19.2026.09.05.03.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 03:05:56 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v8 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed math
Date: Sat,  5 Sep 2026 17:05:47 +0700
Message-ID: <afafa518cf4f34ff906927eeae488fb25d9aa7bb.1788601784.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788601784.git.ulijg308@gmail.com>
References: <cover.1788601784.git.ulijg308@gmail.com>
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

Use sign_extend32() combined with FIELD_GET_SIGNED() to properly interpret
the 10-bit hardware values as signed integers. This allows flattening
the complex nested unsigned boundary conditions in
rtw8822c_dac_iq_check() into a simple amplitude boundary check. Ensure
rtw8822c_dac_iq_offset() properly maps the signed average back to a
10-bit unsigned format expected by the hardware registers via GENMASK().

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 141 ++++++------------
 1 file changed, 46 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 137544649..4b8a7e777 100644
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
 
@@ -207,30 +172,22 @@ static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 	}
 }
 
-static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, u32 *vec, u32 *val)
+static u32 rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec)
 {
-	u32 p, m, t, i;
+	s32 sum = 0;
+	s32 avg;
+	u32 i;
 
-	m = 0;
-	p = 0;
-	for (i = 10; i < DACK_SN_8822C - 10; i++) {
-		if (vec[i] > 0x200)
-			m = (0x400 - vec[i]) + m;
-		else
-			p = vec[i] + p;
-	}
+	for (i = 10; i < DACK_SN_8822C - 10; i++)
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
+	avg = sum / (DACK_SN_8822C - 20);
 
-	*val = t;
+	/*
+	 * Map the signed average back to a 10-bit hardware format.
+	 * Example: avg = -1, returns 0x3FF (signed 10-bit value)
+	 */
+	return avg & GENMASK(9, 0);
 }
 
 static u32 rtw8822c_get_path_write_addr(u8 path)
@@ -271,20 +228,18 @@ static u32 rtw8822c_get_path_read_addr(u8 path)
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
@@ -292,8 +247,8 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
 		temp = rtw_read32(rtwdev, 0x2dbc);
-		iv[i] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
-		qv[i] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
+		iv[i] = FIELD_GET_SIGNED(RTW8822C_DAC_IV_MASK, temp);
+		qv[i] = FIELD_GET_SIGNED(RTW8822C_DAC_QV_MASK, temp);
 
 		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
 		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
@@ -302,67 +257,63 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 }
 
 static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
-				       u32 *iv, u32 *qv,
+				       s32 *iv, s32 *qv,
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
 		i_max = iv[0];
 		q_min = qv[0];
 		q_max = qv[0];
-		for (i = 0; i < DACK_SN_8822C; i++) {
-			rtw8822c_rf_minmax_cmp(rtwdev, iv[i], &i_min, &i_max);
-			rtw8822c_rf_minmax_cmp(rtwdev, qv[i], &q_min, &q_max);
+		for (i = 1; i < DACK_SN_8822C; i++) {
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
-			"[DACK] i: min=0x%08x, max=0x%08x, delta=0x%08x\n",
+			"[DACK] i: min=%d, max=%d, delta=%d\n",
 			i_min, i_max, i_delta);
 		rtw_dbg(rtwdev, RTW_DBG_RFK,
-			"[DACK] q: min=0x%08x, max=0x%08x, delta=0x%08x\n",
+			"[DACK] q: min=%d, max=%d, delta=%d",
 			q_min, q_max, q_delta);
 
 		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
 
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


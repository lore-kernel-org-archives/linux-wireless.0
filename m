Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBDD1BC08F
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772814; cv=none; b=ENJueqW2uj3PO8r0TXkSX9GqG1O7PU0xjrVhMynsV5F5gfsDXwIV530GsFU+a1cqL1Cb/Qm9xZuxOsBTBVEDChTIJtUzYe/OVw5+G7oC/6v5cpp9SECH0LV9lPHobQmE4+l5krdq5iiQbM3iyRCkvFVGwLvsSUMovqksBfdHzYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772814; c=relaxed/simple;
	bh=HByq9m7lBxfCNopVjZgb9eKta/j3QpPqZjE7P5Sg6po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGJtfmlG66WwNc0EV2XGqhgVvXpXHUFeEkCA+URVlmxaHHdA+PpF4MBWL3p6bEOw/9bxMcybjUaDKz3pyLajPyljsWYafayUxmJuf0VO6/7Fpz29KhdzECANsTT30TQk8RZZrv89okjmoI7ZzyMOVIoTm1zlpd+p2yPKQAAB2mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRMF2hPX; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRMF2hPX"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b2b92065ffso1643837e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772811; x=1787377611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VBjBB39CWHysKIWdHjezan94xorylFai+aoWWBeQxGI=;
        b=PRMF2hPXk/flTqPTFp40hd6hZXSFBmI6c+Oh5Alnl2jjeeKp+SVT2LI14y+DwTLw5B
         XT3jwWZ8RWgywwMKXl7bViZv+U1vsbosHeD/vQTedJn/oUGIGyZT0lAcZnLzFvmIrrNb
         UasW7ITV0ku88KAr5KnI04fUyEReFpDEXQ+9Np6fEzrvDW2aP5zXeXJfIxi6rC9kH7f6
         +tuFJ8zUeTVrI113VTcDznBqF63VYhbDMkWkSwzSYXKslYM/+ehJqDlAV4LXpJ9vCUQQ
         jH0IVv2FODa21YfRbtzdHgRaGuT3lWSlCk1PSeo9sRi9utPa9JAmSWCW4/86iBYqFg1W
         BLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772811; x=1787377611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VBjBB39CWHysKIWdHjezan94xorylFai+aoWWBeQxGI=;
        b=gAPO+6xhSoNXQe9OfwGGcCmzqi63ewZTQZVJPbtV337S4HlWHgHm+mMkAYPnBdYIBb
         tp+PsfH0bK3/GNVXVMSIjiVNTWscj+QRP4qIjpkmHlDQ5QSK/tlGjYufbYy+Lmb1CMcO
         OvK1nm+zO1vTsxDs1O78b7ngbrK8xtFns74+jpwjR8999jiHGS+HKKNiS6FfbYTQWOOF
         qRneHMipt3ayJrrkGD/xIjh93mJxP9OlKUnKqxWbt6kRhXvC8M+AqX1whOVHYnUxCzF7
         pqF7vkd4u0aI0W/4/iAUE0S/KwQFZ2RsfeU3OvCKe7vXVOR/LE9GAmfDNwW4hNAIdCKV
         fSEQ==
X-Gm-Message-State: AOJu0Yz1+y0xZFFiR9AJsRJUuAr5gv79vJcCutxDIqRz85v6w9/EOZ4O
	407rI67wVh4ooiKxVCuZy6qZyLDV8yVT6fppYBQlE3I9h53H+yrWTxGDCEXCZeNn
X-Gm-Gg: AR+sD13EGkBE41//IklOuD4jEd331cEPwUTerOiqFRYStjrtjnAgjRhtykAyJVMJFKj
	xpV84NKIA6SfJub+AZTciTdP3kDkZ5HHGGfuzseKdkTyC0a50eucvlEymxSnCAaidu52T3ZnB9J
	Bij4UyYTUEbsVwppwQYivSAkB1dHR3Cxma/NJSc/UGruMt2onedS/8rDaHbiJuP7ulGBtQgEKvT
	tu+PyW+Xs1oMK3pfE8pofVAXura4/iJ0N8XwRUZBUGgii4NCSRjA2r1gtAtWhDNXQiAzguOOAZf
	ArIdcLX9GZjKBpWH0OOfqwJ0Yiw+d2O6PrfiPYLuoK2koMIduk35KbD4hyfxs45JomNF8oX+rfi
	5AbJ8wJ4ZeswRLHcAQsN8gASq7zj2osq5JoL+2Fw37MMGAtzosRszINoeumys78g1zd8dVMtGLX
	BpJ4EmmeQV3oszIWiYXw5LgveOPRm4s/Elo/OB8fwZZcJoqjxVauNlhwGBaS72HU5qWxU7E6sAj
	8inUxX51eWqw2sUULjU7iTyoLzYVxvIhdZYR+RG9LAHKDU+lt0yJdzsPCKAfQ==
X-Received: by 2002:a05:6512:ac4:b0:5b0:1ae2:8b7a with SMTP id 2adb3069b0e04-5b45918c5c5mr1732903e87.45.1786772810424;
        Fri, 14 Aug 2026 22:46:50 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bed96esm967527e87.40.2026.08.14.22.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:46:46 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v5 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed mat
Date: Sat, 15 Aug 2026 12:46:33 +0700
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
Message-ID: <20260815054633.XLMSvbP8KXnUZzfiERTdPCFeVPT2XnWzXyRC7UpOTxo@z>

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


Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01BA36EA80
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 09:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786786776; cv=none; b=t9u53Nkj8FFLEzlQg/tvFUAwDlP6G8tieYetEaVbLzRbOahnW4igfF1NIS+HxP4udsSYeYMVjvvgoBvniSKqe/o5Z6/KXOPTHTmOLG24GWohWdFfDbcHxrLIHshMj+NTzEeButBCuyhS038QENDCZjij4Z2EHzn3SgQef48kKXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786786776; c=relaxed/simple;
	bh=4qplkvBZsGER0LAMyfgo6U3buh+0dwWDdImZZtj33Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ugl4wGjYcLtM5l0N9tYmbuMEWRM1/873HG4pHQGxE/GiXIeHPS/rXe8RfEFlG5sqn60Sp3E7gZBr8dcP1KNKwzk5a0oZETBQFr+kZw3kd9BCMIA97QaY3ujYZ8wQxT4OtilGU+fyfRc1UmXiM1DZEPLx68N0+p9LNVtN3HUr5vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iukKQ3om; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iukKQ3om"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b0148201fbso1608336e87.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 02:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786786772; x=1787391572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/1MG8NaRvzloJQN7VFYJKU5QXqKP1nT9wFsviKvdhxs=;
        b=iukKQ3omG6gTysorGqkiJfBZDNqIfQRr0UJ9pIEkeFk051YAnZPP7QADSJXshUcIps
         S9WAL8GRUEJp3f9TWrXOrREGAW7bKiJfJr2ajN2C7CZakK3cDcwhMwn35I1mWQYLnfgZ
         /HuFImGG0+VYCdHV2BpOGHlCPNxPZQm5a57YrOX0QhgqrTaLXQnaxXO2Pp2iFWRreC6B
         4/LMNBE+lUBJMzYOPYxsdO80IThdRnA4Ly2sZ6J8iYcXY9mrsCOwnGPauSvjuOsVaw+P
         KuY7iJ1wlkMtK+kUtS/B3WJ/7U811ziIeJvrqQ/Y6rcrbvAYMmjaqWcxtUeJan/M94pE
         jDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786786772; x=1787391572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/1MG8NaRvzloJQN7VFYJKU5QXqKP1nT9wFsviKvdhxs=;
        b=hI4xMvVqw7JrvgW3nH/Uhhw+EHPiJ9TnG73ue2wICGs7+GoKA+fKMM4HSMuBxUexp+
         0QT/ebh9NBWGil743GZ1xAvnbRMgpHM5nO4NnDjCVKvHB4pl/svLHoGKcckjyVkFxqGS
         lJ8sUN5NlTR+TmnrRSv4LtDREI/fSWVxBJRzWNb9PdyjuqBALxqRMc3Z7stLF4g1TlB0
         eH8PMBE0yDH17s5TbFUk90nQEKMEFx5da8JakXemfhF/qZPZsFe0svmovIHqSJdB/371
         uXuXnhJG48hFwgYsVnaguixXdtxQ1rhRKpR7BoTPbBg88/Ezqw7UwYIUx6/zny8nHXgQ
         /aGA==
X-Gm-Message-State: AOJu0YwHqTUO7GE+eYdV7Z8bv7WAA1YlIfI9TUGh/uJ14Vdk5kHZDWZX
	YQGDbder/mzJk/GWFb+VSjJn3vRODC8fZDjBl/Rq6B0ZEAD/uTSGCG3O
X-Gm-Gg: AR+sD10xzWTinZ3h8rCp/PCMjL2izoNzBI7ZGoQ7n+cgESLZm+OKtlAJmq9SwpwvTMn
	xSydad+I/8Am7GuWcmpZ9uStWHH3TGp1oVYkyW0gLeKelGOkV3ZrTUaEcoLX3zMRtc0g/o2nJLd
	Imcl5gr1AWOOMeQSnatevthUIl/2b9cUaGvGbM8wj7CPKEvv8duw5iibkB1Kdf2+LQU1dNQGXXh
	oEYNx5srIGh+em8rXNNIotFtkmryjEsq20iEDmnx7rLECbmkzZyewkA/GWsAsziHuWv4X1iR1n9
	1XpLKDaDW7ze2H65SAR0gCWWEzBB7iMna5sRCoKdeUGQTjucnPeDwEJDhc6HTsUeTjqRcK/QLEr
	Iner17Ep1bXN2HhRoYDZisFor3IEG/dpvd6h2DGXvMdRH0uFeLs/UY5NwtjHoX4B8CbA5f9Hl7Y
	C9XvZvbMeefz5jSHDYxFqgZcP5YvSs1JxNjSCPV7CiGO5SYlTa+o9ZqQT+/5leLM07UY3DVGYlR
	pmtdVyBYOCe1bjLehLleuDXQUHmS+5iGhbEcTY/DeXGPRd5AiqGBXQuswCrJw==
X-Received: by 2002:a05:6512:1310:b0:5b2:b004:ab9b with SMTP id 2adb3069b0e04-5b45913c3bcmr1772424e87.33.1786786771987;
        Sat, 15 Aug 2026 02:39:31 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bedf9fsm1040316e87.46.2026.08.15.02.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 02:39:31 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v6 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed math
Date: Sat, 15 Aug 2026 16:39:23 +0700
Message-ID: <cf7aaa2f7ff162f3d3a729a5bec9c572277b805c.1786784750.git.ulijg308@gmail.com>
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
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 135 ++++++------------
 1 file changed, 40 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 137544649..a10e87d6e 100644
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
@@ -302,67 +251,63 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
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


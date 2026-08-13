Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773B9415F1D
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600086; cv=none; b=GVe6AfyjdIWIr4UGZClWtZA71620FxUP15wc8qooTaLWeSu/b4zaJL+M47lzqmK3OZOHdFTKhF0z1OJgVDthz448dfy26usvcaI0M8YsVy/ki3yySC1727GZQFaf8xtYkyfzt3DQVUQ5fEDD8rHNqgRRJ9nOfzzTdWjUgrUA1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600086; c=relaxed/simple;
	bh=mD4MIu7A6RBKLGLZhcQN38rVB6TQlU0KUw0OmGTmwG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBFy9AnNA28d+vO0xIBAqdrbgaw7aFq1ZA/RTIeTfFBQjNFsOB/2+Qw5cgBEUEz6l6N03BA69CNTp/Zj6IrZyDVaXq4/g3bmbwD4I9DXac6IkSvZ466Rn97Cxi5vF/jQbsbWJ9tfg1EzIHEw4NOgaeK2jBjzj3BwmIdXLvouBFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4Nsc2y3; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4Nsc2y3"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b011edaf7dso1929104e87.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 22:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786600082; x=1787204882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kRTl+sLRqkpeXssOlH0oy3ZfbvcTh31CRPscib/8rhE=;
        b=J4Nsc2y3iENYzhb5m2kEf/CAqf0tJxkXL5jwWOEwfdXgM94BEcTSJDKAn92YBvhLb+
         JNwp5G+j48qorZo0lCDG+41Dc89VfWQMBHjf6zOcomwvxwE67dM1/mySuUw8n8ecr/yo
         idhn8J03Yizd1FbeWd29CXIwteV6orBht4a5j0IxUeciPzAJqdGURPaoGKHq4bcVdYb2
         rN92uc+G0FcTvRwXioFZ1D02IcCh++gU47nCcCcf9L4KnEIa48ixdbkE9hw2K0Kf6Pk3
         MfKYnsMyGTK5QRbGrVnVpl8KweCmCTR6Koiqq4q61lMjZMhrDUItQwlg56d/0ZvzFgVS
         YPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786600082; x=1787204882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kRTl+sLRqkpeXssOlH0oy3ZfbvcTh31CRPscib/8rhE=;
        b=mN8wZTSvK6oWd+DRDF6xw0ZeIdXLUjy37P2za5aDIj70eRpLF3KasrdVxG5Ebx/hpM
         a2qx0cvIAEXSNcxl+lxg331I++IPqUxQxsPI5Lx/k4PqGPVI4quGuaAC8x0yWT/eWExT
         +Xb0fWxuZ+fBXj+3vJXQKcij/sHKPyS/GFBeK8a0sBwCePIirrd11oI0GNqgjtL4K5ji
         1ftwpfpA1ioAHflLTtATNto6894OudY5ugnLaVFZaUzMMNpHzNJ/aQWA0JyFNHampeAg
         Rqv3+eQ+A+suwpOIFaxkc8e4KM8005TCZl87HNsrSBwpa6qOoyvxXHlV9Aa+nhDoNkxV
         oyAw==
X-Gm-Message-State: AOJu0YxEy9os0AVR6/slnexiiCAfrre9Bazwc8KcBnaANBLvyXRge4BD
	VcZlIV0e1DOSDrrBpEvS9i3jT5JUKWLO+Py/MoqIHpLj4703UvsXcIF7
X-Gm-Gg: AR+sD137HT18Ei3pT8DNkKcEaoMXO/Pd4KVINjmfIeAbzaS/h0FSHSfOBboZxiheGZO
	PzLcBOB35tO9g/NhhKfaJtIpr8V07LS83LQ98vUf1QbV0P2JdDHUh2ucuWUNCz6LvzTMyUpN99C
	/6v62EGYJZJrZpcxzZnODTjh8g186FiScJi2nbSlFZngjkjY6+kAoRiroqYiNhMMqbvk4ZSJowm
	k2tz5L+0q21obXLIV/YEfBNy8jYlA9aVKpINCHA2Tyosv/0eK2Yqwi1y2dTt0F6v6Zy6SL4/aks
	N6susSZDpgRDmoz/yirbQPvm6RaPfKxvxwyz4Zj6r/aZ+2gviwrMlStK8pZ5+lSgiZKRBAhGBpY
	GXrNTTKYe6b+O0xz+snKJVsWdryxqZGACD7NRgUqtKfkEElPt1N024S53ZaQSE9Zi+kwlQVGy30
	lCYInBG4djtfwkBItV9nZnSvmkKNuPLjT4pwQgZnV1r7Ti6gaPBQfJoLbO1lr5Y+XOzv2TUec1W
	fdpmDcBZTefdkyiHismKxm8u4hjkuahtWOsGq3IQgnZeaLcTRAL3r/9QoyzuzQctBCO8BOY
X-Received: by 2002:a05:6512:a496:b0:5b2:9c9d:6448 with SMTP id 2adb3069b0e04-5b453f4e6a8mr263010e87.12.1786600082355;
        Wed, 12 Aug 2026 22:48:02 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b4539e9673sm252483e87.23.2026.08.12.22.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 22:48:02 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH wireless-next v2 4/4] wifi: rtw88: rtw8822c: simplify amplitude search and offset via s32
Date: Thu, 13 Aug 2026 12:47:32 +0700
Message-ID: <0bb6e2fb78d0b2def623210938204a0efbbe2034.1786599645.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1786599645.git.ulijg308@gmail.com>
References: <cover.1786599645.git.ulijg308@gmail.com>
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


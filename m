Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8D63C2B92
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 05:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895640; cv=none; b=m9ln+ty1QPcNlLwsI5OY87Z+k+xmzDYOaRxxKpqkhvsytdzyHBJ6M1KCJQmBzQSQWI0e8FXQT6POT4Dc+pDn74Me+fUaTd+iwBHThNxI9/ZAzThY+kSVwOBz4i+NXnMIMKzbYcz2o5RYeq89jpOIFw7+7D0pYUkD/gKdZpzIHOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895640; c=relaxed/simple;
	bh=WFXr7ZsgrCcpgJCvdkcA6+OvapKYowHM11dQQTeDjko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBx96hjPTTXXBg1KWU9qIgzLbe/27xZ0pRrMKTj7nstqt/0Ecdha+Oru1oWrn56JWgdhN9/W17LWYlayGaeKvIHlUcma5S9eNIx++6cjCzWwmBZKSNkbq1oCb3zdntZYmMt2LIIk0GlaYz+G1kbTg34Ov+TcA1lkafEOnTiAbHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ItnT//fP; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ItnT//fP"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b4adcce4b1so590079e87.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 22:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787895633; x=1788500433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gz2/HZ3jIrnlU0ErxVb8NXWvR+9S7JqXinG7AEu3Ys0=;
        b=ItnT//fPcuJTho/NjVAFrDdZ1ZvcDR0op0ebZxxNPo3ZV69Z5UgVPeYT1GjsKRv/9c
         OoCwqyQyiuZqyVnvEH0janG9xBnxkhxFNrBHm0/u7LG12y3IPRVbrXjV7LJB58Ol/eiq
         wkuUHvChULXEhaBsNsMapdE4mnOC/sUurUQZP+wCDa6Z7FICrlLzpHRYUz8NW3LtVRe6
         8YEwTAZKu28JzlCvsD/YBMsBYMELRlt82yzP6bvzBA4mXJUocll8rT2eSYU5CKPeFwJc
         yzyh+Woljrt9YSWkg4o0/jr90+mQnbNaCXE+El0wppOmCzj8lokKeVPb/glKCGH5CJ5q
         CDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895633; x=1788500433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gz2/HZ3jIrnlU0ErxVb8NXWvR+9S7JqXinG7AEu3Ys0=;
        b=MfHdyw1Q2Mu8yvUHejB/zc1alcWAp2xA1ME8i8Q7xxIH69/c0yPN26WwWrEPmpMmqC
         tSzqYmKbKivAew9/j3S2FQedKIzJEMl8j2DEHhxHkwo/4No5REAZuZ8ugJo7RBAWvMj0
         jy+3Y6nMXA66GikaqZPUgpdox5UpQE/K64ScjyXtG27w5PexiVyHZfk6sFSmsRICJ5GW
         7tL/kTQMWWlMy/Cwn0t8IHAEvH2IJXIiPXXJgem6Z5Neq52YEvvy7hiUkxkVmp67Sx/x
         SIXTSBnAlhANAPqwB/V1qky/5cefhHjzco+T6ihyaje6uH2i4RvcpnZOrUUvEoRtbYMp
         gdbQ==
X-Gm-Message-State: AFuF++mAo/I+Lw5UAm7DBu8oIAn6bQyKYYW3TyE1zpO3qSUrhhjTj8lz
	//ydFERFLzKZfg1adxjkB59Vgmvcs9rJZRE5faGHGuCa+0J21IHyf4rC
X-Gm-Gg: AR+sD10YGsYdivBQ2TegpbHvbRLRZ2FNkBnHK3U7bnF5XHX8VaxdD54MrHiM9tWLyz/
	5097hfvYGq1y8OnIksfcO4qnM7nukbhhweivRrmVhFLBm1JzPmJyY4sWS9e+yRfwHugDhRc4IOr
	R5qbDmbL8FwgYtwQDrVRhZAFXq69h5lCZY/HBmeuTYK5DbM04mWA0LtEjFywvI1iTp3VL82El0h
	mXJ47K31kJ0CDE59NJ4hW3ne3WvbRbgGMwM4ajVMvjTWaLuxo8VgagLsWfv2bQp0o7ZsUB6RWd8
	ml6amS5XyjSFtuJsZn0nl8nNHPqRBkonhRFrAbkkDO+YKWezNGNSi4lXmO6vjibCcJtG+RZtpJx
	tVbIPeF/wN8Zdp0QFseilhRXSQ6P8tISJi2ULnYGOVztmMpdDwqchuPhyy1MwYdTHTgBDY6jaFK
	R53XfrSzuoyfDWGZvM3yS+PKS44zcpuprVbIFDzzSoQkJJAuVhJRu7Irq4xuBZGeFCls5Mjr9ld
	bHmJSY3BcGMbjLnmzH7A+4/TLUAkmmCXscWn/lNqxtBsP5OVnRGKiuyskzTgg==
X-Received: by 2002:a05:6512:10c5:b0:5b4:7d9d:16d7 with SMTP id 2adb3069b0e04-5b5e68bd188mr1077785e87.11.1787895632359;
        Thu, 27 Aug 2026 22:40:32 -0700 (PDT)
Received: from archlinux ([94.180.48.0])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e8a1a8edsm166172e87.79.2026.08.27.22.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:40:31 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v7 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed math
Date: Fri, 28 Aug 2026 12:40:22 +0700
Message-ID: <86bde9882c56a1245a4c903b607e23d551dde1b9.1787895379.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787895379.git.ulijg308@gmail.com>
References: <cover.1787895379.git.ulijg308@gmail.com>
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
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 140 ++++++------------
 1 file changed, 45 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 137544649..b010e17c9 100644
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
 
@@ -207,30 +172,21 @@ static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
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
+	/* Map the signed average back to a 10-bit hardware format.
+	 * Example: avg = -1, returns 0x3FF (signed 10-bit value)
+	 */
+	return avg & GENMASK(9, 0);
 }
 
 static u32 rtw8822c_get_path_write_addr(u8 path)
@@ -271,20 +227,18 @@ static u32 rtw8822c_get_path_read_addr(u8 path)
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
@@ -292,8 +246,8 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
 		temp = rtw_read32(rtwdev, 0x2dbc);
-		iv[i] = FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
-		qv[i] = FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
+		iv[i] = FIELD_GET_SIGNED(RTW8822C_DAC_IV_MASK, temp);
+		qv[i] = FIELD_GET_SIGNED(RTW8822C_DAC_QV_MASK, temp);
 
 		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
 		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
@@ -302,67 +256,63 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
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


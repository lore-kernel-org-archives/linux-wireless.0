Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA9338F929
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600083; cv=none; b=iDT0utWe9JxLeYvFcOvMTYlOirea+1nD/c8qvCQt1g/DLQYJzyeHu0f9vU1gvZpZEHrvWB1y92QobUJG8uQf0xCuqVFu4pXLyC4OleccrGrWo2jgfRJriYoD9qZ7X9ELaGX8erPHxfg0Q8bPEn2Wc3uUMiKebHgXr0wknTPgL3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600083; c=relaxed/simple;
	bh=jP70uOP2BCSma+JgjdwArgM9EWTT6A1QGv3/F1F0GvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2r9DBAduDgPMjfr6u4OPSIJa4B3yOd/kqB2ajQ1Gy2MP/wfKpV0KkzSCWtidDdcQxPjT30ftrLyl6VwFMqXXv132QKBxdVbrVXLzSjN/5/Im/5Bj0p7Ccn1XVVQhRLEuT4vk1B9P9JIPcJ9tyUYa7D2Q8G3cnYJ+lixBwPwTOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YdPXeqd9; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YdPXeqd9"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b013084dc2so1703621e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 22:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786600079; x=1787204879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xjVce0bOiDbqJh+cO9vi5Yx6lQL92Gy5xiafEpIBLzI=;
        b=YdPXeqd9X8twUHJ3KSxgaJFN/tQxtLoxSRh8LanqPSM8XOCXB42fFHFPKbbWLhIKuj
         pFKHRnQAXRSfVs3MEExFo+TnKFZmSXVPfIZVVtJrKgLCz+DFlOThjLTFvVRoKnp2oZPg
         O9m+L3HGip+aABq3rJ9Kp6vB7gOl2GoFiqI8T6qchZxLemcfKIZU9isvWG6UcVg1J9EU
         KI4Gvm7t/moYht52JoVzdfk3vE0K+dGK1/clSfAa4+PiYhCV6LEqNLDYF5cQHjhkpefI
         iF34W6gL1v1ubdZP0F/wSvo/dgeg6J7fmmXYzHl5dZq4X8qMTJW1Cj+Clf7bbw/PjMlb
         4yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786600079; x=1787204879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xjVce0bOiDbqJh+cO9vi5Yx6lQL92Gy5xiafEpIBLzI=;
        b=GnOXfNAPqKhSoOwKnUsbwqTdtj8FxrQ4oFrIGOZmcoe5+9gMUOuDl+YKnOCaAGjNs4
         GVnBYOf6E/sIpyHm7f9gvRZjexBvxrA+MIICpslXWRKT55ePBDrxPGgGq6eT/g7F62MK
         A9cxoBdEOMwWFqW/ymUDv87o+hozZW6VDACX1YIHDWNHECtWXAFBD9iDzUen1mT9g/+C
         W4Y9TIvQEMUWth2pG3XOf3E4zGLethePhKRpD9SfhBwWx/2UeQ0ffCUzS/adfVEJkrAF
         ZqWaNArWrYFDb7PQiGSyJMX3WY+BnQoMyRk6dIvj2O7lx0HmbSkwv439LZCG5W7yFdVA
         Qkjw==
X-Gm-Message-State: AOJu0Ywp4RJ+xnpxx3E5nupMptCSKwkqF5FnIeMvp5vmDJuzSSbt/coi
	QzsjNIYF/B5T4WJY58tncp6cUwzMbG1a60gPJXXrb8yMJT2uvBkj4hIfeEQ6Jb6k
X-Gm-Gg: AR+sD10xA3uh9fqmFbeUxepUEcI+FoQuTml2YPovaGQfjfWahQLEt+w7+FR9E4lHU/I
	PJJ+LyYNnT6rOumrfSb1oWq0Fa3fmA0RXUVT8A6w9CyEX3XYy9AremP0qbNSVTDnPJWW+xAsebn
	xZR0xpiPSfeJiEwPUUcACxhLGKoAF1SLgonuW+QJcsSBzpO3VOaltxh9vYbaMRq9yxgiFrja3+y
	wYn7DIRzmakVEfzWHwHB2hyussETmdIjhsTWL6fKGSYkFBrz8/dk363gsQ8wgwt5AuvkYqg8nFc
	qKKn9xxnctEZCgIqn1qiTAZqefB93jWf9klhNUScjoR3IGoO1puPVx7Pmj8re3QPospJCEty7La
	wrG9HMF7q+eh9WOg7w4k8vfbYfuJZmaLRDagHO+7J+JL1y134cS+774EuH3jDdGxfBOR4YkOY5q
	7GBQO3otVizBZKT9hFPxLwa18XbzVOcpiUwFnedtiko4rGk4WRgA8uRxmJ4F+7LzAn8ksPpgp2R
	OWczrpfKpv6OECyFdDm6N+3tNYA0gWHt5dKrmgev536vAxtlgZVfmTSIinn/Q==
X-Received: by 2002:a05:6512:3ba3:b0:5ae:b969:417d with SMTP id 2adb3069b0e04-5b453d0bd39mr460817e87.0.1786600078616;
        Wed, 12 Aug 2026 22:47:58 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b4539e9673sm252483e87.23.2026.08.12.22.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 22:47:58 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH wireless-next v2 1/4] wifi: rtw88: rtw8822c: convert DAC IQ buffers and signatures to s32
Date: Thu, 13 Aug 2026 12:47:29 +0700
Message-ID: <12e170032b884c8693a08c780fb8aa677aa4af4c.1786599645.git.ulijg308@gmail.com>
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

Prepare the DAC IQ calibration path for signed math by converting the
temporary stack arrays 'iv' and 'qv' from u32 to s32. Update all
internal function signatures to accept s32 pointers.

To guarantee bisectability, wrap the existing unsigned logic in
temporary casts to u32. This maintains identical mathematical behavior
and avoids any compiler sign-compare warnings.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 49 +++++++++++--------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 244c80264..896e3e7b9 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -153,9 +153,12 @@ static void rtw8822c_dac_restore_reg(struct rtw_dev *rtwdev,
 	}
 }
 
-static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, u32 value,
-				   u32 *min, u32 *max)
+static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, s32 value_s32,
+				   s32 *min_s32, s32 *max_s32)
 {
+	u32 value = (u32)value_s32;
+	u32 *min = (u32 *)min_s32;
+	u32 *max = (u32 *)max_s32;
 	if (value >= 0x200) {
 		if (*min >= 0x200) {
 			if (*min > value)
@@ -182,8 +185,10 @@ static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, u32 value,
 	}
 }
 
-static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *v1, u32 *v2)
+static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *v1_s32, s32 *v2_s32)
 {
+	u32 *v1 = (u32 *)v1_s32;
+	u32 *v2 = (u32 *)v2_s32;
 	if (*v1 >= 0x200 && *v2 >= 0x200) {
 		if (*v1 > *v2)
 			swap(*v1, *v2);
@@ -195,7 +200,7 @@ static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *v1, u32 *v2)
 	}
 }
 
-static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 {
 	u32 i, j;
 
@@ -207,8 +212,9 @@ static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 	}
 }
 
-static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, u32 *vec, u32 *val)
+static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec_s32, u32 *val)
 {
+	u32 *vec = (u32 *)vec_s32;
 	u32 p, m, t, i;
 
 	m = 0;
@@ -271,8 +277,9 @@ static u32 rtw8822c_get_path_read_addr(u8 path)
 	return base_addr;
 }
 
-static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, u32 value)
+static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value_s32)
 {
+	u32 value = (u32)value_s32;
 	bool ret = true;
 
 	if ((value >= 0x200 && (0x400 - value) > 0x64) ||
@@ -284,7 +291,7 @@ static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, u32 value)
 	return ret;
 }
 
-static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 {
 	u32 temp;
 	int i = 0, cnt = 0;
@@ -292,8 +299,8 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
 		temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-		iv[i] = (temp & 0x3ff000) >> 12;
-		qv[i] = temp & 0x3ff;
+		iv[i] = (s32)((temp & 0x3ff000) >> 12);
+		qv[i] = (s32)(temp & 0x3ff);
 
 		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
 		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
@@ -302,7 +309,7 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
 }
 
 static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
-				       u32 *iv, u32 *qv,
+				       s32 *iv, s32 *qv,
 				       u32 *i_value, u32 *q_value)
 {
 	u32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
@@ -311,13 +318,13 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 	int i, cnt = 0;
 
 	do {
-		i_min = iv[0];
-		i_max = iv[0];
-		q_min = qv[0];
-		q_max = qv[0];
+		i_min = (u32)iv[0];
+		i_max = (u32)iv[0];
+		q_min = (u32)qv[0];
+		q_max = (u32)qv[0];
 		for (i = 0; i < DACK_SN_8822C; i++) {
-			rtw8822c_rf_minmax_cmp(rtwdev, iv[i], &i_min, &i_max);
-			rtw8822c_rf_minmax_cmp(rtwdev, qv[i], &q_min, &q_max);
+			rtw8822c_rf_minmax_cmp(rtwdev, iv[i], (s32 *)&i_min, (s32 *)&i_max);
+			rtw8822c_rf_minmax_cmp(rtwdev, qv[i], (s32 *)&q_min, (s32 *)&q_max);
 		}
 
 		if (i_max < 0x200 && i_min < 0x200)
@@ -345,11 +352,11 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 
 		if (i_delta > 5 || q_delta > 5) {
 			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[0] = (temp & 0x3ff000) >> 12;
-			qv[0] = temp & 0x3ff;
+			iv[0] = (s32)((temp & 0x3ff000) >> 12);
+			qv[0] = (s32)(temp & 0x3ff);
 			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[DACK_SN_8822C - 1] = (temp & 0x3ff000) >> 12;
-			qv[DACK_SN_8822C - 1] = temp & 0x3ff;
+			iv[DACK_SN_8822C - 1] = (s32)((temp & 0x3ff000) >> 12);
+			qv[DACK_SN_8822C - 1] = (s32)(temp & 0x3ff);
 		} else {
 			break;
 		}
@@ -362,7 +369,7 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 static void rtw8822c_dac_cal_rf_mode(struct rtw_dev *rtwdev,
 				     u32 *i_value, u32 *q_value)
 {
-	u32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
+	s32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
 	u32 rf_a, rf_b;
 
 	rf_a = rtw_read_rf(rtwdev, RF_PATH_A, 0x0, RFREG_MASK);
-- 
2.55.0


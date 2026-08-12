Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C610383999
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786545973; cv=none; b=hFe1T1ZvVlculVecBzk4h8gJ/sCcnXei9+7zqwvXTpuGR0lEDQ3yqXocRjgB0r02hz7lVwlymybBEBEz8q4N7jyRe6tgcLlyr6C1rrk6X3NFLERBY3hUZ4owpQNO1WIb9EgdTw8kgXlCldHvBvswus5/yW11QIED4878McfM/1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786545973; c=relaxed/simple;
	bh=jP70uOP2BCSma+JgjdwArgM9EWTT6A1QGv3/F1F0GvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHzP3qHcQSB9RQKPIMzGOItwcN54hLMPurehhJOtmPfq+Beh3MvYH8IQ4+3L3vvcHx/JdqTcJcJM8vlq3cAZXJDQJEpWAKIHnWdo5E/LAkFNPZTGuj57rLZquWG1ziKYGtuDczNUfOeBtfKpHT8Wihds5pI4O+GhS0EdXGW3lRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQOsnVf7; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQOsnVf7"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so1591842e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786545969; x=1787150769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xjVce0bOiDbqJh+cO9vi5Yx6lQL92Gy5xiafEpIBLzI=;
        b=JQOsnVf7v6QcV0u8wSvO8L6YzhJcFndrLMjWlXSZ3qhogQM9wnjAgTpo4dPjZcEXnK
         J5+fbuJa/6TszBRFSgv3oFTdW/dkN5GFcyBzD44hP8fYlJG9n2l4UsK2Kv4wNnadHCPg
         +avn0W4o34YEMW2zxJzzA/FdSHcC1cVKfJGl20a7CGro77hL9w3LTGM9KG+hvq1QEzKT
         yoPiOrRgjIuc7t3vIc3LniQkJQVHI+lJGJlk5hotDoo6nJT+wQ3Cpj0CwIg9GmdN6a4p
         5GUjQbi5dQ5CV37QUx99QmqWbC1AecJrX18H8QZyDGiuYudM8s0xPyYT9uvJ/3nYYTGi
         8/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786545969; x=1787150769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xjVce0bOiDbqJh+cO9vi5Yx6lQL92Gy5xiafEpIBLzI=;
        b=sGyeJVel6ysjGMcAiWKiWkd3IM5icxviLarIigbImtPKTDAWxnEPCP0Jfvjt32wAGX
         CHyZi4fmm/+jyJH6rxY/KJu/Fr7yzYQzqsf6v0+lct7rUL4zBicw51FR+8eNkaNIrHQA
         JkYiOLG6mntCAINHQ/euhHtsSLGmQYAiAYr+F4FKPO4E71XRal/OC3K4/AT+DWIyA78p
         ovD0hSa/vCuaROoE+cNWVkIrfWKMhoKJ5dPhA2HTH4W70yztFSUBrBY+vXURh0AaELHS
         Lj2W8PVJ2xIXCsP334qExjjEykuKKbnc670V2vp5oArZMlJ7ZGN3ptT0WkaN198KIuZm
         e4tA==
X-Gm-Message-State: AOJu0Yz39AwqpBGG0xEPm/D1pwUoyTX2MxtzJ9ATOHzocP1q1VDzKRB4
	B0QnnHwhoGnt6RRi9O+obmmpAhrJBHnsZ6+UJjLPKIccjohOes4Q9Tis
X-Gm-Gg: AR+sD11oehmD5D3aI95cKWxscM3NvM2EyjMM3JsQ0CKNuVi0OmL0L96zquNvCof2HzQ
	eqU4HmYiQxBb3fe5npVGcQ47NO2jRlS/oMQmgIt3qqYGuLXJLVmOyFN06t/MIR++ElTRD5BwM5t
	0SDdnsvHsvzRlfp4KkfcIPy8iVEB+YxjqBlbw6yu47A6cosT7M2uu3hFXMuxARssqjpVHGTMWDu
	0/xgod6WnLXPNugDXsTZPxs/0+ipUHNMsao3kX0vUIZ7vZP0f6MLTXcKHiBQyGgUBQnlhwXLjWd
	0rmpxUcRKX7odhTRATXIFUv1WAFR1dmZakhsX8ZV6RwPwesWrXlr8kfrITUr2q0JFNoRBKCwzi4
	/XPjraNZk4CTcfG8tJv8vFLoANzjbVHLmEoUH4Og2HPqtwMvP6UW8Z0ChKM9VJ6Qst6jWAouGh4
	vDxEXo8BvrBe6MudNzoC/3kqER0HnAQ1CY4d+bzAuuNJNjHXA/RHKByd81xX+gVIEQjr4Go6vGv
	BoqwSeL1xf9L5t8tlef+Cnu7uTJdNNAjlJMGkIs5+pCprxJ+fOf9KJX5XItjw==
X-Received: by 2002:ac2:5a02:0:b0:5b0:1879:1b9d with SMTP id 2adb3069b0e04-5b44e31a809mr616228e87.26.1786545969296;
        Wed, 12 Aug 2026 07:46:09 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b44cfc27besm552179e87.21.2026.08.12.07.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:46:08 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH 1/4] wifi: rtw88: rtw8822c: convert DAC IQ buffers and signatures to s32
Date: Wed, 12 Aug 2026 21:45:43 +0700
Message-ID: <12e170032b884c8693a08c780fb8aa677aa4af4c.1786545572.git.ulijg308@gmail.com>
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


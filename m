Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C7F4252C9
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603973; cv=none; b=kTJDzkEY0N9guExnG7FNx4jRVaPZfvcmEHrQbPPlo8u6dQG23ALOs4e/YNH33/jBHxo1/MxiG6wCQSo6RscnYW6rfDmLmG/jnh1xmIb8RGqvKKdmBWb04wOGxKp0gWfiYwU/7YuI4gDd/xruvGTLYhYgNIjGI/YGVz2o+HPOXpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603973; c=relaxed/simple;
	bh=jP70uOP2BCSma+JgjdwArgM9EWTT6A1QGv3/F1F0GvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7pcinkcExEBU9UAEkzkPhNPKy4hKgSnUmI6SVOqEeBe5OvX4BEf34kHzT78gGKpz3mutomqRKnhkk3MK7oQR89G6GhqlZZY0R5oKFcziKt3/Xzd4zGZHYHxBwP+TlwG82nXt8u+q9JUrKkYUi9uEdGmPSfMqXBOIAEWyRvJgT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnHWVHFQ; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnHWVHFQ"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39ee96f8047so3316801fa.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 23:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786603969; x=1787208769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xjVce0bOiDbqJh+cO9vi5Yx6lQL92Gy5xiafEpIBLzI=;
        b=CnHWVHFQnb2s3Lreqc410DNDJiT6wxFbMR0E2IdZkeFdDVMF1RqxekzsYwxssv+aku
         ON9lud9tfl0lE73rffM8NJ6x9B7dwXYSMHPLjCwlu0hU36ty8xSbur3oGwU3TN2jQk3Q
         pbPz1yhqoxkBEwH5hl9uZhXSqqvRb7f9GudVrViqJ7JZ4/XcP0T0vuFb/9B/ZlTBvNbo
         44acdCleLi37GPMMkmFiovuZflIjVKUnT6DwXq+tdbR4unO0Rl7WQn5RcHDPZ18iso71
         sOjAypfmTY3/iQo9L5MBlZSPcZV5yDq11FBDgn2ALgJCJ9dCxXwh02ndfA3pVgjQxmM7
         e+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786603969; x=1787208769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xjVce0bOiDbqJh+cO9vi5Yx6lQL92Gy5xiafEpIBLzI=;
        b=NTqmiJTT/O3LDsS2lVKxfo4lPnrWa9YKygWqrsetJLc2C0WtRSlB52M2+5Nz6PHspL
         8Zvti1Bu0S5Wz3m+mtdc87SP6hdsKRjIZ0snayvtQHjEgvSAOIpXRYUO6WmbGgZ6lvus
         XIyimWOp2SX6kuEQdi45cYi6VZ7fa636Gri28iNRHPQuoSvNgJ1ut2SceZMflWS4uRzD
         FxDb7xuxvdy7p8hnhD+o2zpL6EGuaRcKdytqJzC8c5FqHoWJYfF8ZBud9EJU5oEhSDCX
         LTzAqb4n08xd97p81Yo9Te9wNE5qjIwtZ1TL4St6QjBVUfOf9czXnbjIHJ8x4c4mTSNV
         pN4Q==
X-Gm-Message-State: AOJu0Yx6rPHL74/QfLrzYvlinAa9L0BQuDeqSii2XAiElWQW2FOEi0T0
	L3fT4WWElAIZOW1GGZB5acW2J+UvfvCmVkiVl2ONkuSOQxlhBfr+SoSUfmcYwMh6
X-Gm-Gg: AR+sD13ezz2xlgt5pADLWzl6BsKyUv9bA7RUiQjSfBCKb0NRH2S4jeN5dminfw0Y/7Y
	28ZSSk9/Dgt2A1aY0ZP+GQd0PvSI8KaiDW42QVyNZOBUQ8wNXJp0Rr1NMWZ+pl3VGRutgWKDZAm
	oxKjWpDUw6czTOhaMEHaSf8/puLKHtRLxmC+5GWcJCntMuyIKYOMAWHJJf8EJbYote8lUuIPHlf
	Vl/NEMZ89oXIuUd+7YQ15jhGxxCabbasubBGDcHEydvIHJQ0kNi5TU+yu3h864NPVqOgzg+DYj1
	e4e3jw6khnBZ9DhWtn2M6wAIpJk8DYBgXaMFbcQ5sHRrF+g8QPTXWi/5Vsm9tHI0DZT2Va7p9Hg
	DdY5fxxcPcXx4ELTFNhfYv7lMG35Ejuw5nYOAl52wNjw5RfSi/OhPpKviNv78Ud+x+2+m+qhyH2
	b4C+/UX0/0YEzWdhW+mkrs+EkMbFmUvLi2Jr7n0HnRo+lQCZHl41BLmV08DPlSeoLbPIJSIPx5E
	vesQc6GpS2/knPVsZHrvIbgQ/HQNyS+bqrQ/dg7fQkl1rqhQEvzEnSEeMYkCg==
X-Received: by 2002:a05:651c:210e:b0:39c:6e84:99b6 with SMTP id 38308e7fff4ca-3a11a7a1fd4mr4088271fa.23.1786603968933;
        Wed, 12 Aug 2026 23:52:48 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b453a54adasm270076e87.38.2026.08.12.23.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:52:48 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v3 1/4] wifi: rtw88: rtw8822c: convert DAC IQ buffers and signatures to s32
Date: Thu, 13 Aug 2026 13:52:32 +0700
Message-ID: <12e170032b884c8693a08c780fb8aa677aa4af4c.1786603749.git.ulijg308@gmail.com>
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


Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60A2347537
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772817; cv=none; b=noXJjDAqtpqvowRna1lICkhwULyg+ClSw0EV4h+y9yrWED/dUOBeBCoep72jLBzjkcK6zO4vgLPQVkBe2uurgltzGxMZM2htxHuT9HCEDVHJU5P8Ls4tJ4u+ahZ9g3bC5YMTQ0YnBq45BuK/u3s3S4SFeyAeRr+m1uSsrjRNwrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772817; c=relaxed/simple;
	bh=wFN/aEIy5u0Oqx1IU2Yf+C56vfAH7D/5v6jrUHIg8pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+8Dc4nFgMzdaknwtNWnYfgxA7RFXzd/TBqSPiYUeYf6ttfGE2gJycM912SjJhOYWmIL62wsvfgB8w0yZsq56AavIOfvLyv+lNzau6AOrzpJAm/H2wNwg98z3fuH7CD1q3X8wLHTvAtRCIt6Xmt81O7u0grrJIVnRlpf8HIu7NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQXNX/oR; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQXNX/oR"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aebd52488cso1833914e87.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772814; x=1787377614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H+q6pnwjD32ZGoePq5J852mbrLt3kF3WnMretQXsbMQ=;
        b=VQXNX/oRJLQUZE33QbRPIBAGSX1aSpBds/7AhqrERB8fSKHjV0WbgZMNx3sz8OlPu8
         l8bLgD6aRV1rh7M1szc/paGfg6fnaHdIAZV8FcQRJcAqkTVocSMhTRM7LhmWebMIQ5mI
         rz9tzMFJToC2LSJ37n451sS+9pdtk/sCS4/NGQuhGR2XSas5E5vjq/QkYftD2pQA/Wsc
         ByphHUUxs+Vr+DuZL+a+HIwSJyNjJtD/32MzZeiPFa8CjCVomP6ISYJ96MfU/HFnkHZq
         3zqagsweI5xoH+Jk2GMLfvK2CH0ZtaDgwhTPwZn1so85XBiJzC3O2YlBlTXNsrC8Oq6L
         os2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772814; x=1787377614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H+q6pnwjD32ZGoePq5J852mbrLt3kF3WnMretQXsbMQ=;
        b=Q+Lkf0GF+cGkEqpwWM8PoBKODW1B6J2kvy5+PMs9m8LHn9fbOrPVe0sDt2Gv0KmVNv
         JSZ6jdU+A2d88iN9NcwIfmyZirceNUPiP19gXl156BI16vuV5o97P6yikB2bGg68QGRe
         gyA3lVYU6ikFcioXskiBgxaGkO9tGwu354aO3OeaivjGzcfZi4rexoBwjTH1/Ba3XLYp
         hf4NcvFwYYUFHwsoAFWHmJB0tT5RLsmm71Mc4XbMJ6pUyE4IwwIKv7p9V/v+mwbbLF+l
         RrjDDjVKJApzutFgXeO9/Oo0OEg4pSdLWqhCOQHYod1A8goteo78h/uQI96ox2CYMsH4
         4wIg==
X-Gm-Message-State: AOJu0YxfvDHoet2/8hWgDM/1050+78rxci7GUS0X24r7g/tDXYeLlyZk
	dObK2JGI+ynpqWC9waCsHcAykCWC1SKUcRX5bPMPwqsVLWywzVksv9rY
X-Gm-Gg: AR+sD13Y38soMcSXpOdtN2AGzgZTSJX1Yx4hHjpOWDUw4VihQwsunPKfWgpwukCrXfk
	fiHAZiUZV3odvpBHpe7edoBZQknjo/MiLif4C2q8rV99JTnQ1F7hVnBZXNUYkzC1USrXiiRnn1q
	ZMnAE3fvpg3PzmCHGU0OA8JZaAFl62HJbnVKCyYpgVD8foVFIRJZjTpuRlnEySdh1xNCwEHVPSV
	teFXGvAEJRwg7FUuBDERSa+j6EG9El/jEoyxDx/G2dzva5PCdAIa52iJ9Dy5UcIQ4nRzWxlIBgJ
	dJ1fsIe9lNPHKzU4PKC33+Dkgxshw+LZW8aIIMsJAwpOVnQpyiSblGSRnL4x2++DgqP92f6kwek
	2cnq1y6KR0vExs+O8aAi3i3CodWnGdM64h8TttPnmd//5t9XHzw9C5n4PQiXqY4xKdwK1vB86tW
	3c/qRITHELavpvRt+q1gvri6baTjWNoCeKJJ7FE6OwdAh91gosuyU2OXog6GNtxtmUffDjzvZ8Y
	O67yBm5gqHCf69FdFHYqyHMPG8bWChkGL2jlmk/PXeR9aJoctW/5mk4PoFNAA==
X-Received: by 2002:a05:6512:23a2:b0:5ae:cee7:52bf with SMTP id 2adb3069b0e04-5b459108ae9mr1660538e87.9.1786772813748;
        Fri, 14 Aug 2026 22:46:53 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bed96esm967527e87.40.2026.08.14.22.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:46:51 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v5 3/3] wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort
Date: Sat, 15 Aug 2026 12:46:34 +0700
Message-ID: <fc80d8c348631d4bcf7fe09b9c67c3fd0fa01dc3.1786771562.git.ulijg308@gmail.com>
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
Message-ID: <20260815054634.n-vZ8wmCzOFzDTvW5FHxOm4zueovN1zjK_ix0xnRls8@z>

Replace the custom, nested bubble-sort logic in the calibration loop
with direct calls to the kernel's optimized heapsort implementation
inside rtw8822c_dac_cal_iq_search().

Implement a safe, overflow-proof s32 comparator using the subtraction
of relationals pattern. Since the input values are already properly
sign-extended into signed arrays, the custom circular index sorting
rules and helper functions completely disappear, reducing lines of code.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 24 +++++++------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 6ad90d321..0140f2e64 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sort.h>
 #include "main.h"
 #include "coex.h"
 #include "fw.h"
@@ -153,24 +154,14 @@ static void rtw8822c_dac_restore_reg(struct rtw_dev *rtwdev,
 	}
 }
 
-static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *v1, s32 *v2)
+static int rtw8822c_dac_iq_cmp_s32(const void *a, const void *b)
 {
-	if (*v1 > *v2)
-		swap(*v1, *v2);
+	s32 val_a = *(const s32 *)a;
+	s32 val_b = *(const s32 *)b;
 
+	return (val_a > val_b) - (val_a < val_b);
 }
 
-static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
-{
-	u32 i, j;
-
-	for (i = 0; i < DACK_SN_8822C - 1; i++) {
-		for (j = 0; j < (DACK_SN_8822C - 1 - i) ; j++) {
-			__rtw8822c_dac_iq_sort(rtwdev, &iv[j], &iv[j + 1]);
-			__rtw8822c_dac_iq_sort(rtwdev, &qv[j], &qv[j + 1]);
-		}
-	}
-}
 
 static u32 rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec)
 {
@@ -251,7 +242,7 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 }
 
 static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
-				       u32 *iv, u32 *qv,
+				       s32 *iv, s32 *qv,
 				       u32 *i_value, u32 *q_value)
 {
 	s32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
@@ -286,7 +277,8 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 			"[DACK] q: min=0x%08x, max=0x%08x, delta=0x%08x\n",
 			q_min, q_max, q_delta);
 
-		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
+		sort(iv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
+		sort(qv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
 
 		if (i_delta > 5 || q_delta > 5) {
 			temp = rtw_read32(rtwdev, 0x2dbc);
-- 
2.55.0


Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCBE33EB1A
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772136; cv=none; b=E2JehG/yOctaS6HMvjTohN4LZjlvE+HForowLCjNh+4jlmIz/OmLOgm0NS+Z4IRl0OikJ00mUjxacGmao6bWyilKEgQ5Gg3o5VgCEesQbrqnHHxD7iz5QWijjzzILtrbf90X5tyQMRNzLl04NtG3Y1ePuGy4FtYA79smV0eeVCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772136; c=relaxed/simple;
	bh=wFN/aEIy5u0Oqx1IU2Yf+C56vfAH7D/5v6jrUHIg8pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/VoBh4ns0jFOy0uQJbpdfcOcdcXgwqy34x8ASVzPKbuzrsUT55rbuTDVxiTSAejvdT/BZ9UYCs3KFK4SJJppwG/258xlzIuRXthS2nbE0WgAbL09MVDmK4oGBwV3rZ0Ap/lWOc1lnEWWwImB05Q8CnJWgTfluHZ478x1vIcGX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RouWUL6i; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RouWUL6i"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b29599b81cso2090996e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772128; x=1787376928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H+q6pnwjD32ZGoePq5J852mbrLt3kF3WnMretQXsbMQ=;
        b=RouWUL6iZVulP3vjNRHEakzHQUoS0yPLEjLcWKnXOjr6WhTRqWZEX99HVPqNI3fERC
         2Rsv3bIKR59tktTCC95UUMHGmRBEAfakOiYkYS8jr+qTHauZCg1Tdyop3s2WNrw5f5DI
         vq5ZpMGkd65F6MAZO1YzSGQbCPgpOCJzDeQnzq/z+Bo/2wPBDQxflBYgm814fEGdkSW3
         TpXH98v1qFGrLNEqCbUGWa+KGHz045dkkxwwbVFTqTaaKRI4b4M7+Rw0Ep2XrqAZ/2ko
         8WQ9tio9ZfBitSwyagw0I1ZMUDJKIc25e5A4Mjw+WTJ+W9mQ4ymDa67T1w6C4VSQ/ERi
         aoWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772128; x=1787376928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H+q6pnwjD32ZGoePq5J852mbrLt3kF3WnMretQXsbMQ=;
        b=XH9MhonQiUxq/C9y36ru4yMJa8hmN2E/FrlcFJHQ6W12Oqnq2ZP4QSdLuXgIfCArN8
         kGxXZKWgau2ZjyO9MufKaExjgz+agvZfU3EQ7br6KL5qdzZfDysEp6bdIapl9jJEr4xo
         Po2PWmLN/ZUEjqE6XHMstEYxRj3b1BWgVaVP92/fnlvxlCUCwm0MzitpR4xeJFBfZbyA
         gqnXTGDA0FgPOt0h/zSUS481sURjh6RE5zGp2eetcws6oFx2/ZJdrjQmrYfBoObj/hCV
         gjVcqyaQ9IYKFQbceFlUYpC7WNX4FCYN94u4PXw3MYr/B0EALczlPFVCtk3Ej73hJKDc
         J0Rg==
X-Gm-Message-State: AOJu0YzAorlABo6zas/DYZyFCA9ds4t6FDYsoSRQe3T1jS28Jks+jy2K
	yA2im9GaGpAcyaTZnRR0SJqZ8IOIgLtpXQp6+3g6S84QAx2dz4+VuOoK
X-Gm-Gg: AR+sD110BF/PTUFWpV50SrXHcT33NK3ytA9J60lwKg4DNy4zsySpztZcvmMBLP5ieX1
	MXa5N2mhG1g0VDAbx74YR1YihGaHk3QNgxPfemA0mGmTW6Ia6SVOBPNeOomWle7QGtPHUw9di2J
	cVACgbukpJqKdK51RCJ9JEmI65YLiC/nBk7eHjA1yKoX0S4ISl3oYjEIPy76A8jAwk/w0KUNy0t
	egTluyX701GxwimLxIjctF+RTw/xCgoYuZooIdW/o9tzf9xZqNYpErC23IKqqN0By7dMUcNAYF8
	OAraUG0BEmksV8asBFPryeC8TxuWruaB6kcVAZJADddtAG8GJMux3/2UEphNlxvzTKUbOSg5exe
	eAEbjyB3nF4J3UzxN6zkrSRdQ3AySmbu3kupDH7tTnmAsgWkZ0WUA/n8CWhCNFNm/2Dh6IvZKFz
	xXv/IiOkUIXFoNI5VXTBFGGqXfHA0Z4z2xNdaR1QxB6zc9L4fpPWQ1gPuCDY58Fo7zue9m4kVZK
	D1YqbrB9HnTrwT7rwpq1VPKWtMPBgYQX+SXb0Idwb+9QqJ9d/qO4OirANRzqA==
X-Received: by 2002:a05:6512:1111:b0:5b1:589b:3579 with SMTP id 2adb3069b0e04-5b459108b44mr1569966e87.4.1786772127851;
        Fri, 14 Aug 2026 22:35:27 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458c0a033sm932577e87.67.2026.08.14.22.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:35:27 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v4 3/3] wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort
Date: Sat, 15 Aug 2026 12:35:19 +0700
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


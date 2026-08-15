Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE239DBC9
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 09:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786786777; cv=none; b=Fr5lh0oHS8v0kGh+AkdSFjBD5cMG4nbjxR1WtPPPHxAahwn22MZSNEWLTZhMm9udcZDxP+hHAIAmJgZQQup2U0rUcJbARxWeGg5ZZhRAKWYymsvRUxqz0eLAUpGB0FSc5MyT7KUQYQojn/bKfPaNzwZIRZ4pHsTsOWsCs/Bq2zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786786777; c=relaxed/simple;
	bh=U3SUEsxdYjHql721PjnvBB214zaTsETImm0CrT+KHrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JokLZm4uXj1qxa3HhFDwIkrk0pEPRRfJA6MwN/iVfDMexV9FCo0LvUCibjVJ0+tf4o4G5Qve++ZLw44TSXmqfR/wLPZIOufyPCaXtzNtUlccxXyjRoCz2KzWlE9/R8HZLYgRTikPO2jtIAcWmvX1wNaqcHM9WSHcZot+y0msAyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gy/Lu682; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gy/Lu682"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b15c6fb864so1319990e87.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 02:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786786773; x=1787391573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pEZUcKNKIrK7fREGvv3quxTQpifEJYJafeD8ki/VuhA=;
        b=Gy/Lu682j5tkIP8Cv2l1bFb2BpUjeb+BMvfLu8MtNONI2WvdpPGc5ID8gjfoLL40WG
         1D1AqxirjPLvLqz968hmw3q1UXs0vkpKLiaAZLlqQzlzquHPHbbbSxYoZvdnZx9Qup/b
         XYwtuQ3zd47krI86Rfg7rQIqgHSumGQE/BHBhAWmawfNWHJ3PfCoy0l4ElVreazd8HIn
         hLLuD/YTDEU6noq4pKd52l9ykFRsHl5jv7DkDfgXN6AESZgMG8uQ9pJUIy3B1CPoUYb/
         WPNuJC32lp87BtgclWxOaItQt0tncqcR7B4TALTMQ2xX0sBUwKgTw9fubdfI1ySFK141
         ADvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786786773; x=1787391573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pEZUcKNKIrK7fREGvv3quxTQpifEJYJafeD8ki/VuhA=;
        b=TiGX5bBLi01OXAudtUUl5AkHT2LnyF4rAUbXkBmxwj56hJwsXPMv0Y14YGwUXtKTGW
         lYgMDHA6iNvLSxtnLTztb7LvKOdn+Rx/27c4NbHwFYhC5Ah1WA6Y3ftFN8jS919v5Mf4
         13nV23BzhlIIZuTl8E6RWAnaaaZaPp/zitYr/Nm7z5sg9olmKGHmn8pj5cuXVW4rYd0h
         GEwibJSMHX3QN81KzSImV+rp+wuBmpq9IseMThmEc6B8BSK0s6GG/rPt5rmhvM/AaFut
         zwzyGEgOT/biGtH2LQICKy0oD+Y2L5ex8Uv3w61t+ltXyAS3R85aYNy+SV2EGOPxDDdi
         /qQw==
X-Gm-Message-State: AOJu0YxZ3MzPzGiNYdBKRVtPxnIt0ToOiliM+KifQ4YL4/UGS68IjQHG
	5kauIqZu7oWyA5zabnfxX5WHeiTG6RZVummBp99TyiYv4pBvus63XPdSPMI+J2LV
X-Gm-Gg: AR+sD11RfnOmkabqKID7j7qE9RjMBRWDAyOSz52ffztUDAP4/34Um3+Aj/eFN3Mf9nL
	7J4yzzzAU46CAYbxC/9KpzuU68jWNr4y+Nd53GI0L4DKnrFxFgle8ErrtwNXUzaV7g5yU7QGJ/c
	yxuSDSjm+AVweifQ83L58ZA2lKCmAnjNNJHqpGp5itFwm1v21Hnu1R6Fbm9DJH6VJKNKrZYVCl7
	gIAZ6ayVp9Yy0U6QYZwzflfnLfAiPb5dnQP1uwxvYUyiyPpZWwovCO85zPpZtuHdoiKayOC5IKw
	FgqB+DaoagoDkaNU4esha6V8DJbT97OShaZkL6q+bOEF0AUPLFwrJmk0EhujjaRFTVGoCgDAkI7
	Jpmiw+GueSHMqz30JGmeeP9RK3CullnQSqDi/JHu/tGQhJQ+sY+wF12X8WIUsqi8/dv0XAM5GRM
	0uqOILoCbk2XCv1zVaFjjSNHPXlL/XPtLZPa1i/m+RIDEZwHpb3mGKjthJ8o1JsnsJ1+Wiyv8JK
	XT8bsVjq3sfzlhEwCfTuOqlIYRhOn9cSM34i3RfoQGbcaXhSMKHRmu5QgIEeA==
X-Received: by 2002:a05:6512:10c5:b0:5b2:a967:c0bf with SMTP id 2adb3069b0e04-5b459102923mr1731795e87.10.1786786773221;
        Sat, 15 Aug 2026 02:39:33 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bedf9fsm1040316e87.46.2026.08.15.02.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 02:39:32 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v6 3/3] wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort
Date: Sat, 15 Aug 2026 16:39:24 +0700
Message-ID: <f1a1434ff177a37029fbfb198b6f74160736ca89.1786784750.git.ulijg308@gmail.com>
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

Replace the custom, nested bubble-sort logic in the calibration loop
with direct calls to the kernel's optimized heapsort implementation
inside rtw8822c_dac_cal_iq_search().

Implement a safe, overflow-proof s32 comparator using the subtraction
of relationals pattern. Since the input values are already properly
sign-extended into signed arrays, the custom circular index sorting
rules and helper functions completely disappear, reducing lines of code.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 22 ++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index a10e87d6e..8a6a8bbf9 100644
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
@@ -286,7 +277,8 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 			"[DACK] q: min=%d, max=%d, delta=%d",
 			q_min, q_max, q_delta);
 
-		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
+		sort(iv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
+		sort(qv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
 
 		if (i_delta > 5 || q_delta > 5) {
 			temp = rtw_read32(rtwdev, 0x2dbc);
-- 
2.55.0


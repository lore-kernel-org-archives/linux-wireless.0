Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7510A3C4542
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 05:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895640; cv=none; b=rzr8nrZbgf1i7P2ZETYuDlAIrJOUGGAmylfLPyaZUDZSIzvHgN3amn4k+KHu6uUF4Z52lCdUoSkBhr8W1EXl+OpHLkGIEaezjwV+hZquG0NjDETvs55E37oB1R4w2SybKFLa2ldWo9e3OL3AKi4zd4Hbq/6Zub2axLPUnFoio9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895640; c=relaxed/simple;
	bh=CrsK0MwXr7Oe9+IYQCl8a58FC1Uiv/HYB/SAmXC3HSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+ycECckc52M2+1I44eNeOlyq6n49+/xJoeTQP0vGcFCQaYs+IK8UWKMohQX3uxyzzsRkUWg2AaqWjozfi8kbSf45G+weJW3bpUxOpEzC9qfrf+/OmMA2HGJICz+YXL/zNa2UH0HDhhOFzzlFL7WS2bncHWaGORNf2ABnaG7gvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g6svmCd4; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g6svmCd4"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b159850b16so592595e87.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 22:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787895633; x=1788500433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tQKVsIuuwigFUQGx9DU71mFvKHQtdN6YB39hyzuIzIM=;
        b=g6svmCd4WirSEJ4WLK0kMUUn8yXLs6DwPia/9ewY6Edre3WC8yfUhbosLFmTq6ZBX+
         CxGN6sqbkS6W0J/+omTltH9lyzsyHFzZvedRkHJncEugL3ztbU+e82STLJVMe9W/AFWz
         dNGPiQrKOwJLeDJxZXp9ThmIbYBtJR7W+jcN6dwcr7NDGgK4np9fj88dxzLIb5P5sdo2
         HmCKioqaHhPqgYrEKc58XDFUR+NZRInSnPFcA0A8EmKl1bdU2xKSTSh9gFkKC7mZa86P
         cqFJSC6ZxiGxm2QcqlR5j90Tss9KwwJxNZOBilro9704D4GcpnO2CxpRGXM71O1reP/e
         mvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895633; x=1788500433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tQKVsIuuwigFUQGx9DU71mFvKHQtdN6YB39hyzuIzIM=;
        b=UXkCOiVCpBdsoQ2C4jF/7OxnogcVngFrH02U355lclWKFtqQxbVgQ1WtDKxofCD+06
         M2TGtbuZurfTrW3k6QY5SQ+/25Nd+Hn1zmq2rqUR98TT2GeE5PnCEvU0VYOY+8BLPckl
         gm0l0Q5afgBLW82UGh5fmHc5TU422QM9bd7ATnYUnsN8g5PFrM79Ms3EnOaiQOteF4tW
         Q/zvjY3mJ/THx4BTfirnjkQRFATFAhqVXPt2TNKc9OT1MIrgKybaVGgWyiDUZ9wDw9Zr
         QmbTKOSDT7CBmQTBmL1OgddgvUvTpwcxlfyXD4Ef2Zhc9YNWuDmn58JcnMU+lxKO6/RA
         7TEg==
X-Gm-Message-State: AFuF++kqAXoZaoeBPwTapvFIWRS3+lnWmaGqkVI/oCjSf6VdLacXLG/d
	Tuctfio56VmlV7tZswdwNl9Wfr9iDlC5PnVaYKIMha4fgtxGtfD5M8IIdkfSdRut
X-Gm-Gg: AR+sD12EeqYi745BvEDas8HIBNWo3I75drEGfeXO0P75ySRCL7cRFOsVHzZEDmKeJME
	SjJ9qobYdVjkY5ZKYCHXNGsPblbxegEUCY4UyDM3d4E1m1pZt0ukQhK62n832IbLtqfGby5ewbv
	1VBh2nWGwhO9LzcfHfJGnJOyLU5LxpwIcMpy8NCWdJFjj/oYNPPcy0KQehEfkV0yeQo6KbeHUNY
	datZnY7ZTm947O5tSGCQcTbO9VXnDS2WTTFCzQU0/7mJwn9I058RzLDBv2DytUw99syeJfnUtcA
	PSfoS9vQ21qtwNXln3qxjYoDbzpV1x2ff/LMZhQ4S3Cah0w7OqgRE6xItAPits4/e8Sn91IHT7K
	MG7YDI7eLSWE+hR7DNSfHzhRe4eezcH943BodMrawSzjXsozF4Jlz7Zzd6S9q6oSE6Jew+oOuMK
	5VRuI6peb4hNitJbHV0P/H3DQLLlrSY+mYwmxHCqX4xJ792Dakp1dyU9qVJ8EvJV2Lbzf88MEPj
	2QQdVj+F77RAu+hzvired2qS25b+wUfJwZXwfdyLPB7Ecis050mJ6zgH83ELQ==
X-Received: by 2002:a05:6512:6190:b0:5b4:5880:b50b with SMTP id 2adb3069b0e04-5b5e68af4camr1038303e87.4.1787895633169;
        Thu, 27 Aug 2026 22:40:33 -0700 (PDT)
Received: from archlinux ([94.180.48.0])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e8a1a8edsm166172e87.79.2026.08.27.22.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:40:32 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v7 3/3] wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort
Date: Fri, 28 Aug 2026 12:40:23 +0700
Message-ID: <7d0ab2352317b81df10dca7ddb3e855a303b8be7.1787895379.git.ulijg308@gmail.com>
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
index b010e17c9..bec1bb376 100644
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
@@ -291,7 +282,8 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 			"[DACK] q: min=%d, max=%d, delta=%d",
 			q_min, q_max, q_delta);
 
-		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
+		sort(iv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
+		sort(qv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
 
 		if (i_delta > 5 || q_delta > 5) {
 			temp = rtw_read32(rtwdev, 0x2dbc);
-- 
2.55.0


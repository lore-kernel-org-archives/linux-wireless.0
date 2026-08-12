Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A215B46A5E6
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786545974; cv=none; b=lzQQBltUyXB29n19KzGbwXfp9gHIW/uwI3FN23q2eouIw7/TzahRQstYDBhVcNkmKRW12liEyPdDxNSjq7Ag4eQjeJI61YQcUhtdET8IZAq+wBXbCzWAiYDIRkYxH1eeMyOcKDI9GCrN7Zma+lmHrDkrZoEcDcORlq5LAPpCr94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786545974; c=relaxed/simple;
	bh=ypHI0S+UNvDNhN5cj1MB0lINoArN61phj1Gchrhibgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL/DG/IOblXICirTzasmr2ADINFLpv9h4dRVyQ+LWg8niDHwICfJRKO8mf7+WmOkTBPduCtr7gpeDk70bKriODvbmxiA3ZqI6+fpgZCqE5iCKDHep9hVGAeRE++53HtBD8807ZeFe5cMz/IHSA4olTwDHUhSqGtSxcBkEP/qIbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i3BwMazV; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i3BwMazV"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b01910b499so915687e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786545971; x=1787150771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9SQr3P3H65aB8k8MZd33ziaOzUGlc9kgkH4DtThvPgg=;
        b=i3BwMazV4ynu5kMkxlzSJ29g8LAaQ2k81fUMPYz/u0Q9HGyAd52PXr8T7Mkk1H9Vre
         UQX3pyqej8J0p8hxtfyzEV7bhe4oaLIRAb5OHdkdDASFMbUdhyDrqpjzdH+olFM5PRio
         QHBAg+EEDFpk+7UoqM4h8KS0qoZqhP7eq2FEp+equupIRbmtt/S3hKKdW1cdqAZ9VHyl
         DDwr4cTOBINDH1STmD8CF9Z4MkPvikI8a0tZkIRvjUzSzhJQl6KA3V9uTPI42LlK3xyw
         KPCA5vGFPepQUc0+rrBDpT7JZKQIXTBKK3ENUE62uIJ65eoGM9QBuS06dopPueiLbjEv
         uHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786545971; x=1787150771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9SQr3P3H65aB8k8MZd33ziaOzUGlc9kgkH4DtThvPgg=;
        b=XLvS8iKw6MMx2hnOb8XKhI+Lq0bJ8alhwjzkFhNnxfxEYCF6e4CSlrUhWFZGf4G0Tq
         H+1kcVr31JlGqz0JDi9tDjSiEFoC5Oc+LETDA8KgewndZ3l/1zgYhLofcEm/nu3A0tum
         oFDsI1JM6IqHCPEGe0s8dQbYo51YXRrZBl2CluhNuYaILUGCxucUo2wLBQv43x35Gosg
         tIYHiEyJEPmzff7KIHxYDu3aZnlo90RKaMXM79SvQ2yVAszSsRX7g7buVmFB/fvsp9gz
         XyALzlKuaI2d7t82c6DKviqiK888L8UxhxZ0H1S+JXi5+aLXNgLIETiLc3Czg3kt98z/
         AxMQ==
X-Gm-Message-State: AOJu0YzJPVKasDRbe29Fn5oeiW8IJcvfeaxHIQmt2c+WbawgS/dilrqA
	Aj2C4KP97oLajZigo9PZ8RyPocSJNUzte9hQE0zCz+jXX66wrSkc+/mbuvEPywMX
X-Gm-Gg: AR+sD13eootQU274ArndMf6SNgS2LhM6aOZZQvAGMXLP0GIp4oCP2tJYeheMZKtz8vF
	BHOHo8vfVFRCCnD7o8DIjW+03E35K71wos9XUSCyZ0yPOY/IsBvTQrEq20mj/qESttmefuqv6w3
	qWEeDFi9F7f1pkBnd6EE2PXC5AZwTJdDx9BUGijtOuYlSQlutBPHkqEDF2VGRZ4oQhCHYE4LQ3n
	6dEV3jxNR7ka5BA5pF4wZTtwbmCBDCgmNWB3L4KXCQgZLx/rzN2OcNyyUKSpTEvbx55eyz7KNXM
	1HOsTlrkOghK+r9VkaPshV2lKyaAdoAxiP+uxSengzLRXUiRN9HiLg6KHKxyZpcPwhF2pah2k+g
	P78/6z3OKnu1mLuxlrgwustOTjY6OmROD0rXPI0dXvAgo43z/+vb/tmZZ42JQP1ZUlcqEMqkACn
	NbKYRPBJJi21JCg1vpIfP5bdLXrqZOCG3ohulDv1gJgJjRmoEA9ueCAOMwIyw5+JL3FUiq7bTFQ
	+/tc9UiuadbznY9Qsluc8lCKzqahn6hy5c/xXItq4pe6Mn14sAALxdu1rY4VA==
X-Received: by 2002:a05:6512:481a:b0:5b2:a22c:50ff with SMTP id 2adb3069b0e04-5b44bb42249mr1278206e87.19.1786545970533;
        Wed, 12 Aug 2026 07:46:10 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b44cfc27besm552179e87.21.2026.08.12.07.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:46:09 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH 2/4] wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ validation
Date: Wed, 12 Aug 2026 21:45:44 +0700
Message-ID: <a016d09710dce6f27a60e8fb3c16cdc28ef24a08.1786545572.git.ulijg308@gmail.com>
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

Leverage the kernel's native sign_extend32() macro to properly
interpret the 10-bit raw values from hardware registers as signed
32-bit (s10) integers covering the [-512, 511] range.

This allows us to completely rewrite rtw8822c_dac_iq_check() to use
a simple, clean amplitude boundary check instead of complex, nested
unsigned boundary conditions. Drop the temporary u32 casts inside
the check and sampling routines.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 24 +++++++++----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 896e3e7b9..d06986d09 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/bitops.h>
 #include "main.h"
 #include "coex.h"
 #include "fw.h"
@@ -277,18 +278,15 @@ static u32 rtw8822c_get_path_read_addr(u8 path)
 	return base_addr;
 }
 
-static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value_s32)
+static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value)
 {
-	u32 value = (u32)value_s32;
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
 
 static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
@@ -299,8 +297,8 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 	while (i < DACK_SN_8822C && cnt < 10000) {
 		cnt++;
 		temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-		iv[i] = (s32)((temp & 0x3ff000) >> 12);
-		qv[i] = (s32)(temp & 0x3ff);
+		iv[i] = sign_extend32((temp & 0x3ff000) >> 12, 9);
+		qv[i] = sign_extend32(temp & 0x3ff, 9);
 
 		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
 		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
@@ -352,11 +350,11 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 
 		if (i_delta > 5 || q_delta > 5) {
 			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[0] = (s32)((temp & 0x3ff000) >> 12);
-			qv[0] = (s32)(temp & 0x3ff);
+			iv[0] = sign_extend32((temp & 0x3ff000) >> 12, 9);
+			qv[0] = sign_extend32(temp & 0x3ff, 9);
 			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
-			iv[DACK_SN_8822C - 1] = (s32)((temp & 0x3ff000) >> 12);
-			qv[DACK_SN_8822C - 1] = (s32)(temp & 0x3ff);
+			iv[DACK_SN_8822C - 1] = sign_extend32((temp & 0x3ff000) >> 12, 9);
+			qv[DACK_SN_8822C - 1] = sign_extend32(temp & 0x3ff, 9);
 		} else {
 			break;
 		}
-- 
2.55.0


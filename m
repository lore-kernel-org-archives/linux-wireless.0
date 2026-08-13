Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4415C42C4ED
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603974; cv=none; b=GyOiyb7HDkTiUGYDtwsb3EQyvqXOrFH/W5RFj9Fj93oX+WKqv4MdxpdVTuTo8sp/IMzJqoPBIOb1+dbV2xz8I40IX3gdT7XDnWkIW6ZxIAGCS7/18z/c0Y9LsZkwtRt0D6HwHf2EvQFkCIf4PxhzDKFsFKTStvL+eUPdkumvVRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603974; c=relaxed/simple;
	bh=ypHI0S+UNvDNhN5cj1MB0lINoArN61phj1Gchrhibgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl+GjaqR8vAiCpdZbUudzOYFhNQCuCzq7A9iMkQlkPe+6gANduoGbBMltCPJeySW2rVL8962rhxx1uWJXtszAbq4s1OmhzZKommqwI5aRQ9zn5CLxtM/cas+nT7oeEuOj6zHYoyG1zlwSSgMjsRXPNaQ1F4RrFfYEFF/F2lDBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a57Tib9A; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a57Tib9A"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so860326e87.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 23:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786603970; x=1787208770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9SQr3P3H65aB8k8MZd33ziaOzUGlc9kgkH4DtThvPgg=;
        b=a57Tib9Af6Bn0X4HuQzDLB1A0wRJET2aHF399y25hHdVJfwrfNNvPRNr4GrnZsn+fv
         U/AQ1KxD8nXq3q97kZ3eLvKWEi4zZpfP4V+9vBPqP0/oB1D1wqxrAFP+jND10mw5q7B2
         887WCcRNTWA4XxLfZJLYVgcuf9aq0UxP50ULfGwpkxAHtilJVScMSGQy89uNNLSJwYVA
         a5nvwkL2FtRDOk+ubdzUWm6h/JimxKPCx+2LYIumqO7o3C7KMIVVZBUaMRQ2Rj6SpFbQ
         oDVpjUTPNkOi2SooyTFwVXrOM2DRvCsYmC/gHuJJ3zUHZGinLlkDlG653MB0HEUdmNke
         k4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786603970; x=1787208770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9SQr3P3H65aB8k8MZd33ziaOzUGlc9kgkH4DtThvPgg=;
        b=PW+tr1wCrk+UoYq1M6HaXkPH6+52QkPWQ92SysuF5LJ9uisx0cYO0ocLqV3eENRoEP
         mLnI13dESvgSIYrx7eujSvU22h9g4wkfVHbsNdkI+Ok4M1qevtbVkzEUKtLG+U0LvGOk
         fy9c9Kx3iR4KkBaijXrxwZJfzIldOxqPFKp1zaIcM3ZvxebE9kGYOUGROc+CythFUZ8R
         6TQBEdLMN/bKVLrx0L/SjPfSFufPZouTbD8EYzUGqC5VruwpRRwLaWI8Xxt6A4mg0BME
         PVCGPSGqEA6b5P9EeMAEtkOrrPYyTsbjcWE9vMhpf5s9zUjrPmZx04Hai143XknR2PsY
         rPNw==
X-Gm-Message-State: AOJu0YxXCUcI05B45ZsyJGOymwPA57OTASelIttY9+f8mjKU17qa5kvE
	lnzTjFHHqdGQTtVplbKH8F+mFRwj8s221P2nB4ytwO72p4OplgHnXlsW
X-Gm-Gg: AR+sD13DS52NnLwpRHtEq3cFSkJQ5xguvsqbfX2Lh+C7t88OBDQ7XmrmYLVTpGdUrgs
	5dfOCDv8/Bb0U6+BypIIdc6D6iPZgKI8tZbiJTUCuwZURr+GXHxA0xCMpeiStWARGOIiDG9mGHA
	tdrQWbJKfbgC4qQCCxPvLpQwHK/nlXBp5nh5OjFiRkmFtE/hL3sbV6V/AHjxNsdF3X+ylh9S7/+
	8nq+wwietbN3FppLOS24I6Dyxe06TQ42NnWSmLD4SVEUEJdxJiZp2YGDqX5jEYhNkT3sesL+ncy
	HRotLm0+T+/J8+ixt9Jw2gfgqgeRqq2Any4BY2aM+W2f8uoCAKZzKTOqNSDIQ+ws/Ktd8PYoI2s
	Qz4A0OP1xJsaEioq0HHPH/mhdn7B6QkP4rgf+grCBvX9lE2/H3h1eAlfXKX+VGCaJ1C9YgVwyaN
	MJwK09Z+SzS6wa/buxSpHLa2E2AoYfK2DFspz8nNQt7eB3e3mk9lSIHZO5BIYf95ffPNjzIUinH
	kQ9gvM/uX0u3u3tWZ+cIq6RFrgw5osoKvIXJs5M4dJDsoOJkzrXe9Zsv6uAAA==
X-Received: by 2002:ac2:5b81:0:b0:5b2:a929:cec3 with SMTP id 2adb3069b0e04-5b453cc584fmr395146e87.13.1786603969767;
        Wed, 12 Aug 2026 23:52:49 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b453a54adasm270076e87.38.2026.08.12.23.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:52:49 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v3 2/4] wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ validation
Date: Thu, 13 Aug 2026 13:52:33 +0700
Message-ID: <a016d09710dce6f27a60e8fb3c16cdc28ef24a08.1786603749.git.ulijg308@gmail.com>
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


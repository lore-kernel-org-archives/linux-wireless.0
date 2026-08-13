Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2D6411F8F
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600083; cv=none; b=hUsr6g2uZmWqYg8Vdmc+pHruzhUCCDYYgZT6N4xJbjr031rQuYzMlW03mlSfCWUKa3criOMFeAPUZPeWqYbBsJBoEcUSfH8df4sCmNoParUAnCFGXf/tTI7XRSGq84axrAsU9KFGC3XNWASVfizRnR4GxhEem2rZqSPaKUgzRgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600083; c=relaxed/simple;
	bh=ypHI0S+UNvDNhN5cj1MB0lINoArN61phj1Gchrhibgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjCgLfD0PchCsk2Pxs0Wb/l6UwWGyIKBfV3sJpKVlW43iEBWfnTZRuMcSAjNModgl6DIToYi3hQo6/h9H93uXZztcrUoVFCWOoJ94okGvlYaxOyOfwrSGSnWuCyhNZ93VEqyO0fSO8CvV/nQM2EKL4La+C9oR8zJd0ecDccESgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VShUQGbV; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VShUQGbV"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b0117dda13so1880216e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 22:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786600080; x=1787204880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9SQr3P3H65aB8k8MZd33ziaOzUGlc9kgkH4DtThvPgg=;
        b=VShUQGbVbGaJ1LKM6y505t7KxLeDQDCHnNRBlRMw/i+HXUqAAzvOJNH1n//x2VJ+ha
         T8iegZhhNwDSgzkCdaV3QZzW36285YoNXN53WHWAhaE6O81FJpx4r88YfPmapAstc4aL
         u5tgp3+JJPBr8jmHAYp8cIXiaRdUuW21TAyW+7B6h9Zvw6r/29O9o7G/1VxLhKB7UeUc
         hH+OjNmWIQWbYvdIZ28VoZvL/oFUTOjaEgnAsXeqh9i+NDaExtuSTML6zKsCwDwoa6Xc
         vkbbnrH4cc+w9mUXRLfJk0fckfR6TWX+zRz7SDeW5FHgFKykYg2OwN03sXayeeijmkWB
         IEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786600080; x=1787204880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9SQr3P3H65aB8k8MZd33ziaOzUGlc9kgkH4DtThvPgg=;
        b=adKVDNA+etgIZqsC/PWlW34iQa8Oy+PPorTi9jmTsbZS572W6pfozdV33PpxQKhhle
         axG129Nvq2GIy+QEzY1jNgbuLbRj9uIN+m8WLx2feUaYgaonVXZFTykXNyjIcjIh6XdR
         JKthf0HVhvnrSzHSt+EcOZXXS4cUTVjt1+RjdULDG2f7YCQ4dalt99yjHvMDv/7XOTBY
         J3wO6Zgs3FIwURSSIDvuxp8Ctr0/1+5rAjiYdR2pRAkScmC7+ExMXAo2kMCV4huB+Wxg
         BwHrc7jNpu0twO/wMD8nontgaWxG3ewCZ/4z1kvoHzz3BTJ+jeP56bs94YpjJB5zmknN
         j25w==
X-Gm-Message-State: AOJu0YyXdc4xdLB4c/Vy1iczRec0PsRVfo7X0G8tmtxma4GZQcLKkD03
	+LLuQwOsiaAmVDO8XepwZNEpDjB6IbZOjs9tAeN9icsVF28ZX9hQBB+x
X-Gm-Gg: AR+sD11QmfcFEySTxkgMM6Nu9vBfMXtEPuc0QJlSvBrPU36sDGcmwNnXZO+E6i8TNvq
	80yc/C4WZ7gxGBLdbZDhjo2lVRiU/TLhIYo94xE1pdSoINYQ8wSsL25638m1VjHotigcq5uk4Na
	MdBl3Z4rE3tsNKxgA2UL68pEVEh/ucKHN3/XCaWf4eEpRrUCi/0qwyibpzi7PsQ8ZN9QvVY3gvZ
	uIZuWPX1GzfHGzaAZqFVoKpttKCnKndehn4rfMGQGTBQtS/aIZZJtv3inD9eBKL8mj3b2FKG/ZA
	z2WwtL2vOCY3ugLsxnySq2YKeR3e4Q5xkaxI2hN8+B834w6GD1ks281xjJ3qKauV8ttSj+iUM9/
	k62swZljQH8ZSeV+4hyNBBB1OYIsk45+w3LKxJqqqZDUtec+tRW35WRtemwU7kqBuvpJUdsntMI
	biLuqaoUa1UD8mQev99+MELRDsceiPuxgEk68hMDjUTFcv5Ci2wm9FN7XwshVk6hYpWGR8JenyU
	xD18F+B2pALIxvaqfewRszUqgQVA5xI4EMq7ljEjRvniKRrGhbAlko8xgO4jw==
X-Received: by 2002:a05:6512:3123:b0:5b1:5a2d:55f9 with SMTP id 2adb3069b0e04-5b453f4e69dmr248876e87.21.1786600079932;
        Wed, 12 Aug 2026 22:47:59 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b4539e9673sm252483e87.23.2026.08.12.22.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 22:47:59 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH wireless-next v2 2/4] wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ validation
Date: Thu, 13 Aug 2026 12:47:30 +0700
Message-ID: <a016d09710dce6f27a60e8fb3c16cdc28ef24a08.1786599645.git.ulijg308@gmail.com>
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


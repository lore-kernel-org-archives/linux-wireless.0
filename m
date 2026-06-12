Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F94734BA50
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 22:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781303596; cv=none; b=crM31J4zQyUlqh7dCE6u7Et0OmEWuTGlZ4ilFRMU0SM1r/em3VTYdz4Y8FPLrr5d9n6RAPQcsOCjGzPAp01uH06kffydyfDtiAkepPTcAJs0n+6Ag7vbZZ/HOqmcGNGKUL8ljNd2vGBB9hPFwj77kvoFALsPgjgJDPloMTLRk+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781303596; c=relaxed/simple;
	bh=8RarDYnB49DSB/m6GRZT2epPAy4uTECzP/083LfKcyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fZ9ATX8G4aUbjKbQDe3gKcdoMooTqtsfWQ39ROiXZ0HMoaLzfEKYJFYKzLOy0rWa5zpiWsHC9wij4Z4+864Ji0a/eIEFwmAAakfz0srocYYwLYqk8g+usnL8keJaNjZ6ODg1gC1lkyLfwnQUdeqTJ7dRbqHNxpw5xRoQ2LwlwCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WhfZPwAQ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhfZPwAQ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490b4a8e28bso11420195e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 15:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781303593; x=1781908393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+PCO44MIFHrQyo4QPtlcjg/nLo9zbg8t3eAKWlh4oCo=;
        b=WhfZPwAQ/60XI+hQTYpUCtE2T8MLCzcyt5GubQ2ukM/vhNKKkkuG/wEZZDpA7XHrU8
         P4gtgKVe1y/T6CQzr+njSOnS8Wy+59yOfZdzbmRHLwHuH3XUVn2dV9IP5ev8onFEE41Z
         KzKyY0shvgvsQJMUnwC75Udwb0UDXqI2iE0spAvojWnS/sPj9pUGiQY7xk5bUSwhrOyZ
         wG3oUPTkgECt3Ywl48wFJWGOBjO9UID22jVNiqCeZMHLXrrd3V7yGcjS3iE3Y4JGM/6+
         ASeKaKTErZYmsWemdKoWiAK9niRqkptt/uAO9V+dQoTdQjan//LtFcsWU89YwY2OiX0M
         isLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781303593; x=1781908393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PCO44MIFHrQyo4QPtlcjg/nLo9zbg8t3eAKWlh4oCo=;
        b=mNXL6AnEiE1Iwbbffh82b0iqmwveqlSJbQh0fAe1vSqEUpZhcxdLwOit4eUZo/4+va
         T0NHDfz7MvG5Y+gtrqaM426xyEnTz5Qtl4uOjWi6fPqeBRGMVo1Rg5GzcmxkEALq/dc7
         H2JruWniWKHNlig8iVkNjXeRtYzRfJGw2DEvWMj8FhyQR1u84FF0KFQDzbRh09gP720h
         Na84XseI4w8f52I46bkYh3vPwH2+F8rFdQVPbRYRU3XfdR3L+sgNqB+pGdLJDJR/RF2L
         Yye3kLTTbCuYukiqjp8smaD9Tzn5RSrpxIuGPzFRIuV5p3FgLSwBwe90NWUrZ4o6pdlC
         yG+w==
X-Gm-Message-State: AOJu0Ywjbrg6ERxiKZbBet8ckOjM78nuZvDDVkVoS1mvW5ZTXrGoRi2W
	3ftd1Gq6z+ibBaKrtHj1tvi1liuxxBD2iN8TCgzeoJFX8RTdbT7YIZqV
X-Gm-Gg: Acq92OGX10x1f7LoTdljPYOv2OFUOEtIaOF0diyc6yh5DuCjr9Nau32wTqGJpsWhhVi
	ya3KjLYIr6fg/rB5d221h3hpx2Vk7hxR8Mdwh+1q5qQO2YFC3fWuGwofeQcKSr4lq0ymKM61U2R
	yMPN8AN2JF7AWlLFfsYbAiT55RfeJEI1/RFkiA33zjO3BHYvkvBrfJVPQTm6VLxc8OgRZIdd/83
	faCXwnhnK/Irmxkd3UZiJeyygDTy/olVyN/biE9lm/CWPB2W6rlkJ8Yw9cehz8yyhSmtC8nCXhu
	TVcd4IG3e69Fgy4twSDA5rzuQ0z+FcKbk64/EvIv5tQsyC7WnAhP+rEn3hw2Akh7RaemjWzqwSJ
	yDR8u/BCxFc1xSsjmoyzBcUS64kKgA/aV3whiElVOAXLII6RD2c+Vqu7EvwtmPksbdnqDoqxbZ9
	/VTfVkdODC+HcTe0wHUSEgFEqEiUdP+3vE8E3so//LRtMgt8jxfVgahH7zNG7E9W4=
X-Received: by 2002:a05:600c:314a:b0:490:bcc1:4edb with SMTP id 5b1f17b1804b1-490ec504eb5mr54905105e9.27.1781303593158;
        Fri, 12 Jun 2026 15:33:13 -0700 (PDT)
Received: from fedora ([2a02:586:e909:37df:f656:10e9:a9cb:192c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49220310a58sm23921685e9.4.2026.06.12.15.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 15:33:12 -0700 (PDT)
From: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw89: use str_enable_disable() helper
Date: Sat, 13 Jun 2026 01:30:12 +0300
Message-ID: <20260612223012.504886-1-npetrakopoulos2003@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace "enable"/"disable" strings in ternary expressions
with the str_enable_disable() helper from <linux/string_choices.h>.
This covers the rfkill state log in rtw89_core_rfkill_poll() and
the DPK on/off log in _dpk_onoff().

No functional change intended.

Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/core.c         | 3 ++-
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 68dad6090f87..71b7a1bba6ea 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3,6 +3,7 @@
  */
 #include <linux/ip.h>
 #include <linux/sort.h>
+#include <linux/string_choices.h>
 #include <linux/udp.h>
 
 #include "cam.h"
@@ -7266,7 +7267,7 @@ void rtw89_core_rfkill_poll(struct rtw89_dev *rtwdev, bool force)
 		return;
 
 	rtw89_info(rtwdev, "rfkill hardware state changed to %s\n",
-		   blocked ? "disable" : "enable");
+		   str_enable_disable(!blocked));
 
 	if (blocked)
 		set_bit(RTW89_FLAG_HW_RFKILL_STATE, rtwdev->flags);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
index e574a9950a3b..6aecef51c066 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /* Copyright(c) 2022-2023  Realtek Corporation
  */
+#include <linux/string_choices.h>
 
 #include "coex.h"
 #include "debug.h"
@@ -1874,7 +1875,7 @@ static void _dpk_onoff(struct rtw89_dev *rtwdev, enum rtw89_rf_path path,
 			       0xf0000000, val);
 
 	rtw89_debug(rtwdev, RTW89_DBG_RFK, "[DPK] S%d[%d] DPK %s !!!\n", path,
-		    kidx, val == 0 ? "disable" : "enable");
+		    kidx, str_enable_disable(val));
 }
 
 static void _dpk_init(struct rtw89_dev *rtwdev, enum rtw89_rf_path path)

base-commit: 21352612198c83a8441482abbf3bd45e4f128dd0
-- 
2.54.0


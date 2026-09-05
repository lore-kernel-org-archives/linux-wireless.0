Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAC4442387
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 10:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788602761; cv=none; b=J2l7fYNjDtcCXYPrSdbGOMkuUFyutE0IONPPhOXJuDULQjSiLYxoxkh8J9Gutdkb8wIQw56Op+uDyh1jLWarrNajv7WeZ2K758qTyCo6+v0LWp/8YbZtEeVPiupWizsMKUBdR1urraTYmOJn2g77DgzfCBjTmQ8azw2uz1FnSBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788602761; c=relaxed/simple;
	bh=1qqyq4Syl2WaF6Tg7xUtShvZMNjFH6XqF77gDveVmmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkfQBHHm+Nd6yMJQkpufhG9ITc9GgSBtmtv2PqwQafhmtY3KM42dkLQh7r1Y0rzQiKEG78kCSvOiXN8g4wP4ipxgfCzbGySdADVyKJLMQ9sFffMOI9VEIzsUhDg6bQ7VSlW97sYfkZtyFxgVRuFRU+3KacLRYIrM4llAO3pYfcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rW0BryfE; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rW0BryfE"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3a35920ff96so24433301fa.0
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 03:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788602757; x=1789207557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kBt74xlcxwFLAYYvZBtsSvm1+fx1WiBkga842ECzmFY=;
        b=rW0BryfEH0fs5b76hf0dnTZN9krzoW/8sL/LYmBS0FnOVzI0VMjAiyD9haU2JeyXiO
         14MTRsavsWdXxWzMT7NNpsz4uiB8RYK0VSseVYzMv1vFR0JbyRZ4ElhH6KTS9HRHYBkQ
         tpol+akswe3/iw+z2FC898dJI1DqVqjysyUeoIH7kt5lOMgK9Pkpy0ImFtmWsq+8ke6K
         F7dEeLfhJ5gJfWB+uqVOC8NK9te5E5D0g+sMHeYezB1szMHlulCDmZHHOv8qpgke1/ys
         xeua3o+77m8u6gm/cRt0ISmRyCu1QmIV1bnDdAvk1jnKIpgiVqyDSNUVtOhzlUJl0xMW
         GR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788602757; x=1789207557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kBt74xlcxwFLAYYvZBtsSvm1+fx1WiBkga842ECzmFY=;
        b=aeGgWAi32nwtORjfE7FqXQWmshAWNM2GW7903OIhIVVC4KiMREB+Ul5qU4yTS4eOWY
         1+Ap6xojrnNxqSCZMyZCWTzdtryGsgyaFh1YZHG+G5pPQXYQfNMnHcyEeekiTd9AWTsJ
         bPvPwuV3LiYgXglsOa4283MOUhyLFuGSrcAza23uWYiHWcBxds9jb6U3MS76dWEWGnBs
         HQzzzlSrw/In/8E3p8TbehNeYOczhM27PLlOl1QrOkk0wipx5npUZVI5WByfxlhUSHCg
         hz5XXs0z5++4GZQEoGZua+XJcUKXMjsMX64mj1e/9cDy5irFLC7s87hJS1FlGXziyT21
         W7FA==
X-Gm-Message-State: AFuF++lT/yfnPXCKMiNSiIUBNHDvzBjdPLJhyU0BAEPt3/SD1ecnKRyU
	7a/d/ja2LDXPsBAToSJdwrfyl4KqhURqzODtj/ja1DhufCBJ0NvLwq9A
X-Gm-Gg: AYBFou0VNUA8j87ctZmyx7F4Tr+y7pXvNmp/GUJF0frJQtpdyMhWNrkedaUc4E2pGuZ
	funkHSz0VX5xWctMsJWanickR/NrwgK/rKFBLR1xXUqJ148XRzSFojPgCYeeW/ERVZ0UKyXirrO
	UR44dkH3kY/G8WYdOiRYou27khcVCkuc1K2LErA8CsiCOUO51YWUxMnsdS+ZOo7b+/Fd7PPCJeN
	Ct75W/mQHbIuXLjJchFQX9UGrPwfD6sxuagia4yTv/7pcWH/jJ3xGZNsskQPArlJCh7qUvwnJuL
	SGIuukPr7yF3XX2ZSk6mE3tsILtqfh31JHR7wGjqbBPkSa77qpw/arSrwlUHHiS0J3AoP+npJbU
	vejAdzD6ngFfpMutYc1KzoXPFqmPNnXncw3SgEHRadYmQ1Zmru50tL0R8osrsaEabYfJoll488U
	gHfABBui8j9MFxCYVN8qFME4iIgliKBTIjc8KnBjpCLJ+tyblfW9uBl/3avgICklPAQxc0gkheu
	CmGuoYRlrIa+HtxHV3eDHN3wpHApkBiLLh3ogt5wnXOuzZEo727LN1ZjhEocQ==
X-Received: by 2002:a05:651c:a342:b0:3a1:6a25:1780 with SMTP id 38308e7fff4ca-3a35b58a443mr16719631fa.9.1788602757354;
        Sat, 05 Sep 2026 03:05:57 -0700 (PDT)
Received: from archlinux ([94.180.80.42])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a3705868a0sm13107741fa.19.2026.09.05.03.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 03:05:56 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v8 3/3] wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort
Date: Sat,  5 Sep 2026 17:05:48 +0700
Message-ID: <c7dd6d8327e4f46230c4c175adf5e86393a2a375.1788601784.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788601784.git.ulijg308@gmail.com>
References: <cover.1788601784.git.ulijg308@gmail.com>
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
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 22 ++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 4b8a7e777..4b98e815b 100644
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
@@ -292,7 +283,8 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
 			"[DACK] q: min=%d, max=%d, delta=%d",
 			q_min, q_max, q_delta);
 
-		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
+		sort(iv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
+		sort(qv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
 
 		if (i_delta > 5 || q_delta > 5) {
 			temp = rtw_read32(rtwdev, 0x2dbc);
-- 
2.55.0


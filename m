Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA83413D69
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600085; cv=none; b=tecTADPeB8q0FFhncI+sN50t7Om/+AauCNSKNMWUwAtOEbVyFR+M86k6HYcqXWPZUqmNpFIRzM/+B03PIJRbit8Skz7EFN1kBApxjWV5nCC3HZE9cfIijcBB2GSsbkwQ8PXEV1OpE4ib0doujG6ZxlIknE1DYb42JSoesdLXvzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600085; c=relaxed/simple;
	bh=5TXl+7FhJNDRzik5WEtBDUOOLm+EMBxf4N2AmcSdcd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co3oFRgATXEdnnpaDo1K2MhHUhy9xr94CXMx6RQPQmMthxF+RTPoI2VmNCRJRoZB+d/CZCT0G3CnYE73dKp/LCC/vCeLyPqjE6lFAbjuzJfev/3ciJCsXA/PILe89XEsxf0VKDgLhwcFIRdN6cWQ/RBV8yhie8hgoftOD5yUC6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iju3+zho; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iju3+zho"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b2a22c52c1so380159e87.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 22:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786600081; x=1787204881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6mNXe4icQAHTtL3mT5idpm+v38V2NUoG/qN7vf7IPgA=;
        b=Iju3+zho56ctK2YEnU8OzscVWB7BzDWvsAZ5DJZyxJyBYBzIrKKxVyIN1rVQqzfBiw
         7s2OARX4fe+AK/qA30z/xRyF9E/9hR7CXCFnYPSqcqPK3nNpXSbLWTnOlt2IdMdRN9um
         ihKJ8M+3loA/HWIbnZyVpOsZDaiLiDgS3W5JXUHe4BpappDedKB2SBs6PGpz+aQ/atwa
         nmTkaJoNA4jQfOF4XznYvtHQ531BmG0P0ag9QyMOirOd/giHY2aeQI3WL8aNXj3AsGM4
         iV5Fk1P44pLTyy3cwrrExOksfhtoBir9Mzc4HAnl+NHGJ3g9julc0BgyIHFwY5wv/4G/
         OqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786600081; x=1787204881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6mNXe4icQAHTtL3mT5idpm+v38V2NUoG/qN7vf7IPgA=;
        b=XGwa0ewjOuJcBnPKTTDbiHqU0uSb2glScKz3S7YoYsSedAWswi4t/bdlpMP+m9oh1b
         wT1yrDMCL7PgZzu4eXeRVceIR8R/ATygo7G54rDuWXVeZeqqdE2xqmnlPZaZeR5Kz/aZ
         kWWuyD+JPjwqXWr036iVFCUPegNEYC/aztV1jFBHf/94bwZaroZmkTKKjfZA/e3TbfNv
         UBYvhFlP7yyi9f2SPaVBC5MNFRpXcIBN7MFm6nHcr2BOxvrf2Eg8OO+hvUJ1P0xLzhcw
         cexONAunm0AMcJJjpaKq6MqufkIuuUpAJGO94L3/OoxS49WYlR3YplLsmXfJb5/Bn8vp
         skWQ==
X-Gm-Message-State: AOJu0YybOfDxFWpAlNXIKj2XOFXSCp2jCHiBQaLnnYXaE8rud34nedsq
	jv5ZtUi/p11v4RNGD1SD92xhFodq5D6NuS42HXvPcyO97Yu1Aifbi9SsmHk5iU5f
X-Gm-Gg: AR+sD13MTdbmk9VYlUdSHlg7LqOJyCROg/1Nj2B5Oz69Qkn7uABBLcWjiZyNih/eGS7
	8hK9AtUFnSn30/f4QLflbUq7znfEJEUDSZB+JXzUjd+UHZIpiuEDTKokCYeu7GRJ5dv4/G57bQy
	i+9o4FNAP51YKAY85CL60QY66p8WWiKPzc+uZiEPxQ2U6YcV0vSSWJfRTeDMdDduLv9QHiekGJd
	PEljL75itDLWuKA2FA/NX1OMsFl/Ia4AKOqfDDOQLa9HzAzDs6CknqDht3GIMxm3AYh0kFKurWG
	4D9DBPFHwgeVD0OCeu88IfGCwTJo41qaP3OOewPH1KROwmkHYgSLmCU5qr5Sgb7sCJ7LP3V0biq
	DtTG2ePLTfEiggM2GY4stGQ0Kzf2NABNyJ8kPDEPTalBBC1Z3g6DUEe+n0f6jEqd8BBuYu+obXO
	5oa5Nlqz+AstNgN7cDz+lpGnKpYnAoIJf6cLLJxyHxQxah2R3VZ8gjiz3R2RBmsYkD6ZfFH4Gvz
	Hp2oH0rr/tqZnTgmvhjLcatJUD0dRrZYHogoIM+0CiFXMclpidtNMunkh9d0L2YcpFw9o/I
X-Received: by 2002:a05:6512:66cf:b0:5b4:5352:e2b5 with SMTP id 2adb3069b0e04-5b453f3c39amr285039e87.15.1786600081321;
        Wed, 12 Aug 2026 22:48:01 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b4539e9673sm252483e87.23.2026.08.12.22.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 22:48:00 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH wireless-next v2 3/4] wifi: rtw88: rtw8822c: switch to the kernel's sort() library
Date: Thu, 13 Aug 2026 12:47:31 +0700
Message-ID: <4a0b85003aac26b23fcfc6e414e00b39e0d2aa45.1786599645.git.ulijg308@gmail.com>
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

Replace the custom, nested bubble-sort logic in rtw8822c_dac_iq_sort()
and __rtw8822c_dac_iq_sort() with a call to the kernel's optimized
heapsort implementation.

Implement a concise, localized s32 comparator. Since the previous
patch already guarantees that input values are properly sign-extended
into signed arrays, the custom circular index sorting rules completely
disappear, trimming down lines of code.

Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 28 ++++++-------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index d06986d09..642ac2e2b 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -4,6 +4,7 @@
 
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/sort.h>
 #include "main.h"
 #include "coex.h"
 #include "fw.h"
@@ -186,31 +187,18 @@ static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, s32 value_s32,
 	}
 }
 
-static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *v1_s32, s32 *v2_s32)
+static int rtw8822c_dac_iq_cmp_s32(const void *a, const void *b)
 {
-	u32 *v1 = (u32 *)v1_s32;
-	u32 *v2 = (u32 *)v2_s32;
-	if (*v1 >= 0x200 && *v2 >= 0x200) {
-		if (*v1 > *v2)
-			swap(*v1, *v2);
-	} else if (*v1 < 0x200 && *v2 < 0x200) {
-		if (*v1 > *v2)
-			swap(*v1, *v2);
-	} else if (*v1 < 0x200 && *v2 >= 0x200) {
-		swap(*v1, *v2);
-	}
+	s32 va = *(const s32 *)a;
+	s32 vb = *(const s32 *)b;
+
+	return (va > vb) - (va < vb);
 }
 
 static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *iv, s32 *qv)
 {
-	u32 i, j;
-
-	for (i = 0; i < DACK_SN_8822C - 1; i++) {
-		for (j = 0; j < (DACK_SN_8822C - 1 - i) ; j++) {
-			__rtw8822c_dac_iq_sort(rtwdev, &iv[j], &iv[j + 1]);
-			__rtw8822c_dac_iq_sort(rtwdev, &qv[j], &qv[j + 1]);
-		}
-	}
+	sort(iv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
+	sort(qv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NULL);
 }
 
 static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec_s32, u32 *val)
-- 
2.55.0


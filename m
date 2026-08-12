Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB59E36D517
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786545975; cv=none; b=sb7YJJmzZi5MStcFZChjJkJ80sDnDRFwdDJb4pg+UKv9WaM79yUbqgLJWKpSUAsT8D+Qd9TQVPECTnr7QlP92pBgUdn+AEcBH297thdkWoN3utNvhlGvVGsiWZiMrSnT5b1rugpKRLgJQ5xnifNjAElkjYGXlGoaVBlznNOXXAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786545975; c=relaxed/simple;
	bh=5TXl+7FhJNDRzik5WEtBDUOOLm+EMBxf4N2AmcSdcd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFdLV3vbQSfRJHXOUMSJkYOzebHxasMl5TPV0WvcOL4LCo5t3ANZYkX9UKXO4AXNEA+T0p04oBgVYKy6WEqGbgBPldj/+f7MeB+1whEgGUGtZ3eutyIACyhjxaq0uN4rs3VCtFPmczlhPTw6bBNABFLBcuZwQC+1K3bcTc/J4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/uxJANa; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/uxJANa"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b0115b9e17so1117732e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786545972; x=1787150772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6mNXe4icQAHTtL3mT5idpm+v38V2NUoG/qN7vf7IPgA=;
        b=C/uxJANa7x30ppSlXWTDWBd2Oug0ygp1CX3CW024WyDNE0vRVe/fuQh5taeoJMZegU
         PEh4elltdrpbba5seMomqcVkRgZpPhrWTdOdIEJl5AJe2CClimqrYGY6Ow4jKp2ulX3Z
         CDurUvJT1sjaklCWFVsUY8SEEg4BcbSQkJ3Pahiu6bX7bU4g4oP++vFajP5jyx6QFVJB
         JDXStZKnJzL8m10JXOwtiMLSr+Hti9/8DyZ2JbFDhPSDbZj9UmbJOFrWn9UBlgX4aWjK
         86MGwKGT7MVYFMLxOSqdtj1yDQtZ/KDt0pw/0uPfecfip2K/cBpBeN6ihrgdikqbKQCg
         P0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786545972; x=1787150772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6mNXe4icQAHTtL3mT5idpm+v38V2NUoG/qN7vf7IPgA=;
        b=M52MprrSJbnrCSbg7bOi71ON3dWAnY5OKnR6PMTxEyiYzaVRqzVtZXeJlSBC++2HCI
         mTljRvO8XFJVBWO2yF6TLuzL3fNTi3SMt7nn0614VMbYqT5q93vP5AjPIa80zJqZ7ctI
         Fe8wlnp1aSUfAo6+do+GimaGuV6g07EJhwKb/DSklrl6EV/mQMu9nDtUMBD11WagGs/v
         H1xJ0ohtr0gToTlXyNWGDI9Al0RrbebAbo/jPdslJcSzp1wgL5/JHhfmqtuj4Sy9S9aR
         nwZBOAwOSCj9/RLQ8tumt8CdiagwDHspIHjhg37ajuo8+erUut/XUyD4I+XQzMsRz8YB
         XUsg==
X-Gm-Message-State: AOJu0YwCqTPFxQgqdYeGpxoaVcOZdH6wz4fTdJG0IVIhHT31S+9E18Kg
	XuEZfqJKuMEfBmTQ3Kl0yrjE1jHqE6JZFzZWFZY0i8DmLOM76BAjVRcR
X-Gm-Gg: AR+sD11x8waFm/n1DUtHrt8ow21Rb+sV3f2H6umyW9wSz2XWKpC0bnAKFUZLZrmXqxD
	IzS2aS8zVuSk00M/J1C/77icmUpaIL6ZTOk05izyMr5olXQIWlzsMAEtzrd9fVJzo+eFb4ogSBR
	KJo2fYpTavBZ23/NeoNnuSc41koEWnmO4vA7J3UAzu16f/0SD5Hi32BDEn8DwXx252wNm38BjVC
	cJ5eLQ2QmRScBhZmpunPb9RC3BsIBI5ZJHM03eNrHfK+LkuquCu/NNXDi6wlDrOoPkLax7P5934
	fFH+cEG63pOehB0v3XkGeZJ0eopr4cDDY49FnskdxUyrE87PUnHo3aMrB7Kp245BjErx80lN9jS
	lp3aPmSz9XBsazx076I1eqEGiTDX48G5nqgl7+HdAzShusyT8b7G7nXWlM3/i/sYUXSCxijgJn0
	76KeYypa8a/jcVPhCxLrH3DpV1JU37hIWVtmqbvbx9ia9PW5QmVhljIwEKaC8N80PIAWAv+PHSb
	BIklUe3JbIM6cceclTv9fd8NW3JnYTdlLNl/DjWQ2gc70UFS7+1lEv88F0/6w==
X-Received: by 2002:a05:6512:3b91:b0:5b0:1108:c57d with SMTP id 2adb3069b0e04-5b44e31cef8mr947204e87.46.1786545971733;
        Wed, 12 Aug 2026 07:46:11 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b44cfc27besm552179e87.21.2026.08.12.07.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:46:11 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH 3/4] wifi: rtw88: rtw8822c: switch to the kernel's sort() library
Date: Wed, 12 Aug 2026 21:45:45 +0700
Message-ID: <4a0b85003aac26b23fcfc6e414e00b39e0d2aa45.1786545572.git.ulijg308@gmail.com>
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


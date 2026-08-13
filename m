Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C4A42E8F4
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603974; cv=none; b=l1k8rWSJsDHsQhUUGKOCHlK6FoElt164h3XZ2FLMcTzMPDRXPD6yTHZCZ73F5GBSDfdJZHBe5af6PaBBEnBmwlR3XIDbCP1YWWjByoGCKQmKWQYdMRvOJNGXkuPYIeOYcmcv9cj8nw/eooiz3JwWEKBGma8oqZR5iW+OqUF8O4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603974; c=relaxed/simple;
	bh=5TXl+7FhJNDRzik5WEtBDUOOLm+EMBxf4N2AmcSdcd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/gbRSC4eacaxZFFvHvPHtsK4W5DsGH/zGCv5arUtF7i+/POQOXErCXvM+j1+2aGTBbKjXJXZfvyv8HNl3E4XDqGwZs8m/tK9HWRoQLxo0edZFgYWAlhMznQJXrtgP4VxzvVoEveNYsWBBm6cy94LChoMVbalSmO2qCHHRh+eaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NINENh83; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NINENh83"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b013084dc2so1745451e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 23:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786603970; x=1787208770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6mNXe4icQAHTtL3mT5idpm+v38V2NUoG/qN7vf7IPgA=;
        b=NINENh83K9ldqARdayB4yFqJzgtD6hSUTS2rjaIw8C/8eYzgCgTuVULzteosB3ISCk
         hoYVGuXoGdihgOS9c8DnzwTaDc8FyfMdHqlEXIdn1ta7dpxKTXFSRlrC110XRvVmOTIT
         5Mbj964tjaFIJebflupGClhTY9Eaz75vPGWrfQMTaBNaTMw6QvlDi5M8tQ+eSK2S88PL
         0mnwohLeOGHK+T/mGYtYIw7mVAytmlEMh500yEDBZaTTEZQczcoVDbKZ2mft9S5w+iNz
         yqVLaQJrqnnd0cmJaTxPoy4mR/H3QrUYG5Ny7z0DE9cDYIyMinM0khS+fuijwkcF7AKP
         r/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786603970; x=1787208770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6mNXe4icQAHTtL3mT5idpm+v38V2NUoG/qN7vf7IPgA=;
        b=MPAv4ysqAs/55xjxU0RYCODrH9nqrV+sjEpC2/0mmyysafPzzGFv5SMIP4Y+iLTyHa
         qL6M6LTUdg4gYpr1q3+bVQpzwUQPBWkENZKhHAIe2K7+V/rrFc3aIB5CfSVupiUytfQa
         3NQpIve5f1Jw1u9dRGlhkWUgjn6fAXg+VV+JWj50OPFgNvXCPYu+uouOpJmlZg2RKgJt
         sGx3vFzW1PU5Iw1AAibCt1ctvfLpneurnDyPfkT1MoyZN5orB8fPOoIFpS+dwR2YP9/C
         hL3VZzaV9i4+96v0bEXPanue/nR6bpXWCJfb94lf948PB624RdX/lGhs0sbgLtTNs8yi
         K2Dg==
X-Gm-Message-State: AOJu0YzVrI3Nn7aHU1lXVkqqzYvz/2Ffjf5bz6yatD4DwWlBYnjtqOFb
	HsC6c1iDwtKNRSDr2rpEN/LqX0aLVfRFGhmp0BFJ7pLv+qxmHF2658pdmU91ubQ2
X-Gm-Gg: AR+sD10cfL7m8zzKgwDEQQW7484g1ElTtdR9ZRYw7DFTYu/AuXUB4CK3nRFD/KVCPKZ
	6rAoIgWkxE2E1O18MQifSO+fzV15jSsFXjOYbPrSl3KesOjvC+td6Zue+Dp51MVKPBhLuOdtF+O
	t0O+RKRjHhayzexqwASbATElMNA2ZmB9rxRDojSb8TOMWPds80zgkJ9Bqztq26zZfmiViqZvAqE
	OGrrzyWDcPCnlctTDi9Yh1ullTWKWfSu9vZwa4MrdCpDerkgblA4pTBZeBGgffMXtsL0tqweBLJ
	KAL72o59fiYvAs0OMmYtqTuXzsqnl+wE2rzmPBiDUgDIJ1HINepeuBpCmmds0lLQOvWdB7j3e9U
	MdTRMaHmAlOKqaXTRitz6T/tbbQAyeoFXCLXvyd9udsSLiLVHFNOCT12cTQevvTXUmSUjZvuIIz
	LUzs0aeJ4liqGrIh6RaXeaszZVHbbi7iep4ehP7YDg/nkksh+yYHTxL+jRwzGgDM9GHvDUsehT5
	YJ3GjV+0gfGc9g/8XJc6kEpPXHFzy4EMw5OapQ9Qr/wKsBIxbBcDlrWazJQvg==
X-Received: by 2002:ac2:44b4:0:b0:5b2:1dde:ab15 with SMTP id 2adb3069b0e04-5b453f96774mr294826e87.55.1786603970516;
        Wed, 12 Aug 2026 23:52:50 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b453a54adasm270076e87.38.2026.08.12.23.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:52:50 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v3 3/4] wifi: rtw88: rtw8822c: switch to the kernel's sort() library
Date: Thu, 13 Aug 2026 13:52:34 +0700
Message-ID: <4a0b85003aac26b23fcfc6e414e00b39e0d2aa45.1786603749.git.ulijg308@gmail.com>
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


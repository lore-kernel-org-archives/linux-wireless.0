Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEE1235358
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 07:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198126; cv=none; b=Y4HOSUfr0Nc9JKVZj2gBhRqEdbk9egzKroaTIPYLZhTjzl4lTRhSlaRL7X1Ow/24gON5TARfKbilwLmhIaXZMTEUnf2sT2SZRgw6ZZzVebVIeHboUPFH4sNnpqpeywcO0Jj5rb7bcfeO4jqcDl8DL5w+bVsOoFbLt1Pz7yGxi3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198126; c=relaxed/simple;
	bh=Z9wPS/MfHLphmStRsx47ywqAztRP2hflM8FIhbi5DoI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xbeo/DNiEoJdOk4ybGo7XtYO7ZzJey3hX25jlKSeTukboRS4QoTbCIwfdQ+WXNM9/YxJP8KvE0cukuHOGOFOkHNHNLHfqdSwbkXyhjrXk+MfxIaaOkX9e32OenpUULeMDCLYPTlatglvmhS3w4CPs6WpcURa1rSjuyDjMuOvtFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r2BTW0Tx; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r2BTW0Tx"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b94fce6e8so4316055e9.2
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 00:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789198123; x=1789802923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SXp8lyNVVb74WFu8BWD5kffDqlcHsOtjcWC5AhUADvI=;
        b=r2BTW0TxSKWIvgAWEZmbixpRep9wNqqPhdCZ8cJzKuLWeVu+bd+raYyWWITg2iPYP4
         /nqDRzl56ebQRqYVSCb/vz8184oquvYbjmqXNUqgEcIRpmEpL8WKHAjOl96XdvwtS4Rm
         xsI3fynKEgSGVzLqJYmaiv+qIGU/GYX2ElnafXSuMhjtIODImUr+m6+WR5ctsxnf4z3M
         ueWbNtcgfNx4NO9bsRICfRii3wRee4Y+7sXyychrgTiQHWB+NGbFLy/Ywe+9Zb1+9oY0
         X8C0wWcmaQrI37Vdofj0VOY5e+NaFv9hYXqSWd2XDgHmu7+imSQc0p9DfHVFfEplM7mB
         TJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789198123; x=1789802923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SXp8lyNVVb74WFu8BWD5kffDqlcHsOtjcWC5AhUADvI=;
        b=pp5xkGE66V3tyaC4/4MQxuKxlI00NPZA5mS3ATlTxmUpa6bcxHGshLiaEpMJfSkNmb
         C4vbgIHgjushYyzqXEgLTuoFEef6V0u9PtQ1eLgCQJ8Wfn5jAVWd/HosbjEnwazoqBxf
         YqwPmOg29QubJEUYAQtNe7a8xFjhNu4vOTZ3MfOFWmWZJwvWxmw6fnSzKE4GJCgBKiJx
         aD4ciqFwMEx98o1k3C+pn/6r1zmPJLvLKmWMEzKHL9+wuz5Bog1vGfTwdVUJo/0XGhh4
         U4J+L3UMXE02OEQtY1gjXcL8NGoRp18FZgyYgK1Nl9c577jr4yUN70TJBJ1TWo9JLi8B
         bblA==
X-Forwarded-Encrypted: i=1; AKwUvBxRNdhflUk8Xf99wuuz/ww1KKmFYa5WVikAF02LH2yLzkRRGnGVqPxX+4cZHdVz5M3quJByC2m2ZzwhO5666A==@vger.kernel.org
X-Gm-Message-State: AFuF++k6Vx1wknUrkuvRubaE9g0ISJcAewCQiG/FaMX5wBfmof2/VcyT
	pL6DCsnfgUWkyaXcGh3Wre4CsKwJm8ODi2S2VMjWRvcKJqMrh+ZFn1zQ
X-Gm-Gg: AYBFou1Egcyq1J6QfaB07MF2MBVOmyy2mF2yzUsbE6vmk6wMO5oXvujXCLSEimkpGxj
	iqF3QkXofGzIUo7zclI0ZNy9LsvutuXGJS+RMyXlvyKnMiOARLWwaQbD1YoBqFcJ9qbaMoAP3+H
	yn8isbDx3yzJ2WTl+UO3jDvkA1AwF1XtjENCIy0wDLM5RtylLpmNDzSk4PPnIFCh9JKXvyCnGsv
	F4GjxqatBegZi60R1Vu2E063zBENSfAqR5y1oRvVOZIK6ukg3tEdikZTDVKGT3YNS0/Q/cxmQzY
	Y2chBVc1H8WOJ3SEmRpKOF+/NU8vIGXeeyh9/uzxCvacpjKxBi/pLEVM/No16FP8cwxS38hJG2H
	r7j5q7U1EClSdAQ+9Y/R6MYbMu4teR7G51g70SQ9+Kped0PyW/QsJyJxHP7jBNOECr4lUJE3A30
	6RLTVMUhJmRCuAPI44imtRXR3R2HvHWfjycZxOvTPMCY2beD1Q1/LAfTHcXsfyOjlmCf2H3096E
	VNSDUVxOGrl8OHZh86I3G1j9YGuRw7+2BqRsqj7PPQfLldYu2zBGxK/ElisHVTvDFBWvDrZ/Ksa
	kVzN3epaxnB+B1dWOmmaTAto7nw0gBElVr2uwXnh7cOaftGZ0TwV7RJ7tD76rvwdofor34rEy44
	/R2L0WCw=
X-Received: by 2002:a05:600c:4e0e:b0:49d:7f5:4cdd with SMTP id 5b1f17b1804b1-49e619d4d30mr91931345e9.27.1789198122902;
        Sat, 12 Sep 2026 00:28:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b260-f201-9983-e8c4-aff5-7a36.310.pool.telefonica.de. [2a02:3100:b260:f201:9983:e8c4:aff5:7a36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26be3e0asm235846435e9.1.2026.09.12.00.28.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Sep 2026 00:28:42 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
Date: Sat, 12 Sep 2026 09:28:40 +0200
Message-Id: <20260912072840.50710-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mesh_path_add() has returned the new (or the already existing) struct
mesh_path, or an ERR_PTR(), since commit ae76eef027f7 ("mac80211: return
new mpath from mesh_path_add()"), but its kernel-doc still says
"Returns: 0 on success". Describe the pointer.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 03171cf008557f1eac3845bb2d5d291af04f6249..a9c5a3250edbb350cb5b638ca6595a0553f96bbe 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -673,7 +673,7 @@ void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
  * @sdata: local subif
  * @dst: destination address of the path (ETH_ALEN length)
  *
- * Returns: 0 on success
+ * Returns: the new or the existing path on success, an ERR_PTR() on failure
  *
  * State: the initial state of the new path is set to 0
  */
-- 
2.39.5 (Apple Git-154)


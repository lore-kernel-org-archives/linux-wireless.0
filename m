Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C952A443E3C
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516470; cv=none; b=eCJtzldmjGRBJPMnENuJpgv9niD6pFFfYzDnbuWNZIKjwJr3Coc5t+ezOdtoOL/Mb8nuerWSsSdUZ6qx08asWQ3/koVX/dbXLCv8AmnHpTaFXdLTFSdTE3IDlvOFLuCaId3XpexP6wbUnNChk9YnABlSdNskCBJ6PLdkCESN50w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516470; c=relaxed/simple;
	bh=Ft3kt5GKC/19CksldzATdkZbswLjJjOZII/YcmgTtmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mbRA8ZAKuI09vXLJ+ve0uoLFWvaA96HJiet5LF1kyFr7Y5VRcFckpWZVyNejQFrSukrQdPnRl2O74l0xS0QL19ta07t90Zo/SWzNqK5mgP+NEGELFNsQBrEZgA0mX4g3QhpMat/Ki+pfA7eCtMeQI1s+eJ5ssoIVqG0meKm2Q+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E0uQQYes; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E0uQQYes"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e347638adso1560959a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785516464; x=1786121264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p2e6Hbr3mS3jtYf8ADqm2O2fYI50hKUDyZ+DuMwGlh8=;
        b=E0uQQYesQ//f8FcnStyJG7gUBLbxTQxOzXK7K0tG/R/u0TB3ByyV/GSyVr7k/o32KM
         03xOoXnFcg+/ocl3gJQ0Uz6tMhickcmclOzji8ots4VYxp47XQCEoCZgSOy6CGLts1Xt
         IIvPDdErll4R/NZccc3k+iL15UPZ9TlfdAYEaFvYJi5YxQQKCar1WfGLhI6UAX8+4GMy
         nOS0P5cW7RI8jRjcOCGQjXTtdQdIygyu3mR9GC2CXvrCyaI6hx2Hr+jIpAHyDURHlHo+
         C5ZIq698h0c4kBmIdEad5yebwXv3/ZeyZICpkPhwwHE0Kmuiz/FfGeuhw5ll5NoziI2/
         5UMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785516464; x=1786121264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p2e6Hbr3mS3jtYf8ADqm2O2fYI50hKUDyZ+DuMwGlh8=;
        b=Zb9eA++15gdleMjzBmg7TAJcpIFMJxQY4e7JdUAqpuCvBpVHM/NbsGtHVXAKIIjsHw
         QQI3AbGqSEmEAecC2sPi2ZPa/v8vHNg4GurOeNqrHRLNCuJAAi5tEANU8pFOEdLf0QMl
         7spor+WK+H9x4xCcATW0wIYU96ZKh9sVRleT++rZM/wDqmFYBW410LhXcJbRDTr3ah9E
         cxBUGTVHKwHqZA6ATjZ67r3faDZAZoO0N93DNVooVJNpFBlbjdrfobmO2TqOKgzUOVD1
         vJNdWF9wpJzSF4tkSd9OJDRO+ge0qLpwRvig7VYnZHPRulsI0gBftk/7a08eL1me5PV0
         aE8Q==
X-Forwarded-Encrypted: i=1; AHgh+RqSjo6et/2o0DtCmCHyAJFfao5rmAuIgKB53JSCcj4NfrbiMg35n4tb88yneSP7ye0UjRrnKgWzF77iT1gyoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Y3VviwSsxVKx9l4d2nqvOyFi8NWdhEOn+c33htZjGjZw9Tb4
	rDaT9EV4nmN1yeown7Llt/S/CfOJFdueODhDlX0csd5NxbZtNCKF5+kj
X-Gm-Gg: AR+sD126X5+t5/JC6ZZReo9ySFSE+mTNXZHxILyD71mONrkvbXDhad9jRHRn8nVt/LO
	t8+umQHoZZxcdWaCxoEerVHpcs+Yse35gJngG2CI1MppGY0LRrcw+raGfLxc06DE+jew6dwmgTl
	R0G0E9tMdwiJJC57KlKKtSvJclWrwVKNsuhR6Wsi+GuyBn72UZSmMsKrlupw5DqWJQzq/4FJFZ+
	VAquiRHIRhxtQeOwucSiOkcBNEgrtmAi3dXebrXWjP35WVqrqkT8KVx3/wdd3eUd+uZRBn6VFkv
	ssUxPmqFZv+FcNumjOXAzEuyNryo6plcquk9qsLxmZMyJJvSJEU3155MPHgzbYixfKDKx235wad
	D+y/bjTEmpl6nIDzswupcZf1F/f7BIDeiPa8a4QAATTEoHdg6y4UPcmR2f4oGRRE/Jftz1qordu
	UOUzcndIzAdEDCiTqz3hFkDexsuGdh2gpCELPrvB/h6z+L0ymHkktGPC4=
X-Received: by 2002:a17:90b:5403:b0:38d:b36e:9813 with SMTP id 98e67ed59e1d1-38fbc434501mr587545a91.11.1785516464469;
        Fri, 31 Jul 2026 09:47:44 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2575819sm970637a91.0.2026.07.31.09.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:47:43 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>
Subject: [PATCH] wifi: mt76: mt76x2: use min_not_zero() in mt76x2_get_min_rate_power()
Date: Sat,  1 Aug 2026 01:47:26 +0900
Message-ID: <20260731164729.1210247-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The loop in mt76x2_get_min_rate_power() skips zero entries and picks
the minimum of the rest with the same logic as min_not_zero().

So use min_not_zero() instead.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index a5efa13a892f..89733f3fb1f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -121,15 +121,8 @@ mt76x2_get_min_rate_power(struct mt76x02_rate_power *r)
 	int i;
 	s8 ret = 0;
 
-	for (i = 0; i < sizeof(r->all); i++) {
-		if (!r->all[i])
-			continue;
-
-		if (ret)
-			ret = min(ret, r->all[i]);
-		else
-			ret = r->all[i];
-	}
+	for (i = 0; i < sizeof(r->all); i++)
+		ret = min_not_zero(ret, r->all[i]);
 
 	return ret;
 }
-- 
2.43.0


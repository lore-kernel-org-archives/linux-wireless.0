Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A639E25B0B5
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 01:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782782078; cv=none; b=GhncPEWIghGkfGvMOOWYwplxbv5edzrygqImvFoQ6drqgQC8z3F6TpubhIdo6WEwMXQVtOy1sgAMeEeE3l+lzBo4lG0EUSPPH+axu0zBIIHE2ZYNkDNeS47VYPBjaiGpVZnUIG3AcWnvC91XHFT/Upbh5c2190YHwQTaHBGzuiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782782078; c=relaxed/simple;
	bh=laEbLt5uZW2gyt3+YNSeRGDWszsz6z2Ki2lVxOx69MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2hWrKghGEgO6JCMHm5Obt905mjFveBm3gJjD5AITYE0B2sF5tAN9tz1Yn/xI37J+Zg06PcFUflpjDr9QKBaiGeUotXvpgZ+9Brl8LeFiNIGaXZyxcbXsq6koN/qLgCdpsfdf0t1yETurMeZzChGRmktGhEuJtzuvYsf4M6d6V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nErd7dl+; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nErd7dl+"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51a8f5ef23bso27631551cf.2
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2026 18:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782782067; x=1783386867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aByZm7jR+8Ms3DdCpAHOVCxrhdh4rHnZilW7Sr7olMA=;
        b=nErd7dl+3V1bnTSKXHWN2vd/0S0UrOP47Wi3A4gCycwZI3RpRL02daA69wTZhKrJ/L
         qOrON5ezyUWLzwZnsLWkz3Vi/kEN/+c212xIkJMU8ri4KAJfFL2Nt94UR5nzBtkGRtBI
         U9fJ/PhxnnNkZOoUQix3hBdYhZhg7u92S0Gk9fuzXJ/le4ablt57hzLZPl8xjvsCECUH
         J9AWcf74K8jYDmT54/r/I8cf/0RYYfn9cnhdtVdfewT286f2X7294222cfIS6FDN2x6j
         DFV/HmW+wl2ZFL9t/euX/vVSRxocYWfPxwzrdEf6IEDlcdfmuGoMfxDXO06Zu1gF5jbD
         0r0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782782067; x=1783386867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aByZm7jR+8Ms3DdCpAHOVCxrhdh4rHnZilW7Sr7olMA=;
        b=E1Gdi8B9vTcZ/w70q5QDXAKEGqfO304o7R/Vv+EX8m7OO/NRJIO0PAq6fpZqjIj5iR
         1zBw8EfJIiLCWP/VoSIuQlMk2ZfaQ5eUgQVWkZH+aB9rDzhBD/w1ox4ZCkvoeeREHtmN
         2G3Vc0Gd7SWiyAC7w/BHmxzTPDSmNca3ukGWDofOr4FyTfCXDPwqcuoSA8AnOGvs0R5X
         HN2mOx/2fhvvjoCb7pXbk+fs7OgkxbkC7FAmcq3rY2byG9a7G9TeuwIv1JhWnUze8jUi
         pVuAVjaN8utGKZy8aK3a/HdPdrK1xXwElA4CHFCaLbEV7VkwNM/x93mwVuOxsbeE2To0
         RYmw==
X-Gm-Message-State: AOJu0Yyi6os0jOytedYqRUOa282mM6xw5YMwzvQIqqapyl47QeiklOSx
	JGj5/ZYnYAiem5Ume936AxyM81rEFuAoyBcS6p+FoI+oDrTSTLULiL6s
X-Gm-Gg: AfdE7cniQz0jY/H5IxYsRJdt8axk/tH84kEqrzays/+qeNV3myKqZmvzYpryaKFf36E
	JuugErjL1QhpQeYaEfRKbYTSAs5IynFaDtlepVooQROhA8iUz0LL244mYseI+OqHXcE9gTOceVv
	z6KInqldVtTbeQW2YUkCVVJisFp6KuoAmo4R9QaOeZ1G9kcVZC5CuMw5aLWunvhPm2RMMdiVIgu
	dHn8vFz0MW6bLu1uH16ngEYCpl2+dckIOwfyE7UQB5G+bG1yibQtkUmrRUdNB9dLUYeaguC9tdE
	quw4hV8FYgsw7H/UL4XqmQLXxChk8gsypSHkGuhxnPPKshyhjojQGyC+Z1GtEV5zkuTs2Gy5m6F
	cucRyli+q0S2ZxTL3J6Jl+hs3eu8aTgY+EXZDNYrmtUwUrqlMiAuO4N2bQ3V0palIt2luzCOAMj
	CBjXiSIZi9I0V97ibmqbA/7h7A6J7S95AJsEmHQt2ixtwTOg==
X-Received: by 2002:ac8:7dc3:0:b0:51a:8c97:9383 with SMTP id d75a77b69052e-51c108ed505mr23903811cf.58.1782782067209;
        Mon, 29 Jun 2026 18:14:27 -0700 (PDT)
Received: from dev.lan (c-75-67-38-46.hsd1.ma.comcast.net. [75.67.38.46])
        by smtp.googlemail.com with ESMTPSA id d75a77b69052e-51c1099aca4sm7719801cf.17.2026.06.29.18.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 18:14:26 -0700 (PDT)
From: Andrew LaMarche <andrewjlamarche@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Andrew LaMarche <andrewjlamarche@gmail.com>,
	Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Subject: [PATCH v2 2/2] dt-bindings: wireless: ath12k: drop qcom,ath12k-calibration-variant
Date: Tue, 30 Jun 2026 01:14:13 +0000
Message-ID: <20260630011413.1424654-2-andrewjlamarche@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630011413.1424654-1-andrewjlamarche@gmail.com>
References: <20260630011413.1424654-1-andrewjlamarche@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ath12k-wsi binding documentation describes using the
generation-specific qcom,ath12k-calibration-variant binding as well as
the generation-agnostic qcom,calibration-variant binding to load
board-specific calibration data from the device tree. However, the
driver never implemented either of these.

Given that no devices currently supported use
qcom,ath12k-calibration-variant and the previous patch implements
qcom,calibration-variant, drop the generation-specific version from the
binding to prevent future confusion.

Signed-off-by: Andrew LaMarche <andrewjlamarche@gmail.com>
---
 .../devicetree/bindings/net/wireless/qcom,ath12k-wsi.yaml  | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k-wsi.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k-wsi.yaml
index 589960144fe1..fa64c8aa56f5 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k-wsi.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k-wsi.yaml
@@ -58,13 +58,6 @@ properties:
       String to uniquely identify variant of the calibration data for designs
       with colliding bus and device ids
 
-  qcom,ath12k-calibration-variant:
-    $ref: /schemas/types.yaml#/definitions/string
-    deprecated: true
-    description:
-      String to uniquely identify variant of the calibration data for designs
-      with colliding bus and device ids
-
   qcom,wsi-controller:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
-- 
2.43.0


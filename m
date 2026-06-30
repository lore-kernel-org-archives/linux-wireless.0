Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5030F932
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782826224; cv=none; b=BEvYRF6rEhj5J0KM2xRNqaHrKp14UuGY8ITb+4C5HIJCjVXJdc6GZn8BlCWk5bEIV7T+soENjiCe9hqXLZ+TrqhsO/J5O6B+rCo/qZ7EgpgL+9cLcXw+Kza09m00DTwUWBTZL47JkpV0RRkFCzoFd8IjR+ChyVyT/8JIWZK9G/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782826224; c=relaxed/simple;
	bh=laEbLt5uZW2gyt3+YNSeRGDWszsz6z2Ki2lVxOx69MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpl44bkLL7dMo5hcuo1xwM9Z4NKN55ra3QaiF8Uly8Ne3mKa5uQcwCy30yNnWtPvyWB9A+X0nVhjgfO6QSsRAsJDw9VVNMx0wnk1gCs6XVymXEZcYqx7K8bka78Pi7VP6cR/moNi+MkRp+xHVNyJFRc9zYqFfoVnn/xGlhoTsus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fxqnh+D7; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fxqnh+D7"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ee88fce572so30366516d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 06:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782826222; x=1783431022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aByZm7jR+8Ms3DdCpAHOVCxrhdh4rHnZilW7Sr7olMA=;
        b=Fxqnh+D70XlsBp/izUkMFqyRDzDfuR7I8spwTjkBX/etm2C1YqIzuRwD9yadlSQGv5
         6J9jBzKa5/7nZnfW+IZnWrp/eM/jApgNPjeW569w4VTMI8XKEEdMqXXH+21sakHSMlpN
         j053mHBPL2KwMvHF7vWEqveymJvTn/HAKs6/SeXQObrz1BC2eQYb/OjQanYRFYnyzD3L
         6Z7aD4J/LlDXIrQkUPTJSkYV+l9a3FDnXT/UP6iYYMkvfvmuAxfjpBoZw3PmBri2jWoO
         0IY1av13nDaPnw6L7jqAyv38sVcee/lRBzAZ+3NbdW8x52wrukcnYSER9I2t59pdMBcI
         GAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782826222; x=1783431022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aByZm7jR+8Ms3DdCpAHOVCxrhdh4rHnZilW7Sr7olMA=;
        b=TZ2XhRDVflJKR5onHBAgle0dJOKBmoMNw4qviGZFOqKXkMN2bsNnJ0NouSDoqRiRBl
         V8UgWdrNFLi4ywAwvFHekMTF2W0gwGs8Bgmjtjq3f1zYFlH786So1x1hsKEsvTu6ZbFf
         VLw3+61aW21GXYRQ84z4QLlycTrea8P7GA4JOpAqIOesWcJwRu6yV22+aUR63nbWxV5v
         l1jypIVdMH0HEz+n/0zVzccMVJZpG46CQGotej1mmnTzF64pt6uoyO99tt/ps3VS8oAp
         65BYpVTGvPwRuFrJgerf6S03pkrBx02s87xKZIfx6CxbR+T+E6KitDhtypESzgWJ0V6X
         5eIw==
X-Gm-Message-State: AOJu0Yyme2/SjpM3H+qtqoWvxoh/Eo5NJGe300IEuXlNCCJ3CL0FtGEm
	uA4anZE5Q3L2R8UDh0Z/pTZYrHzfBhpNXbhctB+Gg1qk5Se87mROb0Bo
X-Gm-Gg: AfdE7cniz900wNVD1p4nXX4Vw+sKImR0sIhbZ6ts04mH2Lr0ytSjtRoJL913oJfR6BF
	iKfghiknrB6bxxM0Ta7iuwE8cE11oXPhHfRR0Xeo4fIIHsuxUKpWWLMhZrYSYgpdYV1oszflU01
	kJjy5k/26G78NQc+VGfyls1WmowSNAv0fURtv4dPPo5sMoUeCpQedl6fwZjNoQBEuZcxtOdZRW7
	AO2l0uF22kg0d5h6Jef+Yyrz3Ltm3m7NcCfOl6j95zpgeckTI5bOGzJ72v/AOo8Dnov7Fe/bO44
	ZfwVxa1zG6mr44GyNsbEH3qWsGEuL0SSbfAz37zwQZ9m3FNUS0m/uPcQ7qJCJg+rRYrT/kYx0Aa
	F82uP2OUr97sfmD92gND+EX1+0DCupBGep0q2XWfz1FaHQlNvmPN581PRE74hcwCrF5KvkkR65w
	3pH2qeIAcswLIinrQwJ0BWATN9zzgbcgkJ5zAt4JxxWUiPVQ==
X-Received: by 2002:a05:6214:12cd:b0:8f0:b75:c4ae with SMTP id 6a1803df08f44-8f1b8e6ad8cmr36969156d6.9.1782826218110;
        Tue, 30 Jun 2026 06:30:18 -0700 (PDT)
Received: from dev.lan (c-75-67-38-46.hsd1.ma.comcast.net. [75.67.38.46])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-8f1a7b26b2csm23003536d6.45.2026.06.30.06.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 06:30:17 -0700 (PDT)
From: Andrew LaMarche <andrewjlamarche@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Jeff Johnson <jjohnson@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Andrew LaMarche <andrewjlamarche@gmail.com>,
	Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Subject: [PATCH v2 2/2] dt-bindings: wireless: ath12k: drop qcom,ath12k-calibration-variant
Date: Tue, 30 Jun 2026 13:30:01 +0000
Message-ID: <20260630133001.1426824-2-andrewjlamarche@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
References: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
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


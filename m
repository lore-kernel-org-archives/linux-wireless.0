Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E443CB55D
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 22:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785192796; cv=none; b=NVToAYuK5ErMyGiuCshbexRmgnjL6MK3ED9LrRfPj1uSFJ3LsjuU+jzE38lwjobQ2RNxKvwK7rgn2TFRu2cKtraPBExiaK1EXO3RN1ePMy0SYtMTfJu5/Eq5nl46n8L1muGbcIDS7eVo1mKGsliGk73rAZDsOMgOcyejnNpjnus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785192796; c=relaxed/simple;
	bh=mSN/efPKVmVi+AcOqZJZ9SPgOGC/AZ19K1EaT+rnT4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ipp42VxN8zrHN2Xhp0iQDQsxAY/sXVTFXcn2WoNc2g4r27yntZIPvj0Hn8QKyUsEyO+OPBQlqnbLF6BEgsQN4pFIwEnLDBAvL1Cp/2HrtRBBBhWiVnVgZmd4bRTxaXnH3MR5YNbmDay8USm978+TdtYPDjNni1pbeJSEdHxlGBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eb2qVjQA; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eb2qVjQA"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84867f07d63so3939615b3a.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785192794; x=1785797594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9c2bNkM182eWtMQSsK53z2vdCBlwj9TY54Z48t5tnuA=;
        b=eb2qVjQA03Rb/z30D/Yzbs+zH7aLm0Gb21TTR8HPe0Os1lU94X8yrFf+wMJItMPLl5
         ahRnsJSzvMCnmOqH+FiJ3O9dKzXGZ8KEGFbTtzclU+giMkk8J5cWHAhwciF4ZagOIYw7
         FMJorK2xqjr32o76UTk8EZ39nv4j+7ejRhi11o2EIM0Pp2nHCOkDZUlS27uYPxv7e1zo
         HtD2K9Jd5YJ3ySJdw9zhULXw62foimvQ9VA78uzM5xLEaTiIkVFLZRKjnl7d1NTAuiJl
         2b13K6j90fxLztn4cdeGKLNC0hwYFfaEJN25epgs1Zxf4BenbO5ZgI3gFTxBVLNr+xZ9
         hO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785192794; x=1785797594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9c2bNkM182eWtMQSsK53z2vdCBlwj9TY54Z48t5tnuA=;
        b=QiOOLrrugiGekOMA08JDBYTOCSvBhMrEx3UEkiVvV3l6+38U/XpHX9Pn0FnNaSnsTL
         OoX9K9j7lDJcupYeIE578EsedneyQI1LiQlUmm+es1yZ65QuYkDo0somLqzplERhBWXy
         R9a9jw9FjPb6AXxaJxzyeOtBfJNbzkng5B2ZQVyd+0VRmIJ4m0mY39Q/igbPrKzXsv22
         YU6ony15MDPfpc+HsKp6/k7z9JdtVlmTJhIpu96PH7pDHHQfbkzPvFLOPwaAVS7KiT9q
         iVVEq4tKjUDEvlTwzZjZOwmio+mbCUCSGQB+BL65hp/QHL4Z21hyytVGSH5RSawelEZN
         SeKQ==
X-Forwarded-Encrypted: i=1; AHgh+RqveUorCPIZb333DXbm+a7Bw5z/4svOG+fxrvuWDhUhZlXTI84qKKAGUP6ZEJQBhuWgYpQ++LTZwXNr9xYKrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuMbRKIlch8vgMeyLAl0sesVg5CcisN//s8HY1+gqLx26dngAS
	cMqXFbmyuwvU0k562kMKoLTgQLoI6ZpNEiY0m+xM3D1EzA45DOJUbZS4
X-Gm-Gg: AR+sD13mlEAb0RZ/K9aSGDPC88HVAAY8toiWTtYWPqmEiKgjXVsSkuFKByzO6PMjFrB
	d/UyrPbfc5Tqol5pz63uhZWAW9QHPnTA+yxiGqXq8qZing3UfDq5j4FIyf/h1jUPRvaZX/URjLz
	mAXJgPFKhNcAHRJaOYbee1Oq5peQMPmMVRH4CHENMwobcQO92rGGaVbv8RDSLyhuZWAFKSVJuhF
	TGh1FMElLvWNAURlJRvQ4e0ZePAN5XGKoTdmLUryCaSd7rSbmKHIiZc0Z8pBsQeuEvJZXN35+0r
	eSWr0ABfSKaYcX0xcx+wKb1QXtl6GKvNb9OJMoXbLegXJreLGseTJrdDXAhQglmMq9/HwbGEUuP
	NoIy5BZddgj0xlLx+XCwsxhJQdtKuzlumY/2tX4Fo2T/SSNspVaUpnf6JtBh56SevVLMDToocfO
	6SqYZx6l9F62bdjdzF2O0h5r25FuWsoxdIhRazgPhInZjENaL1enkjg3pVBwCoHS5KWbHYQ9oho
	/sJqdaz1xbZ0O3okR37fptuSrSKvtfsKh0OQdJ9I1WOv8VKSwZ3daRwgF7bdUQ7dQ==
X-Received: by 2002:a05:6a00:999:b0:84a:29a7:f650 with SMTP id d2e1a72fcca58-84e928a9ab5mr39555b3a.0.1785192794215;
        Mon, 27 Jul 2026 15:53:14 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e532ad19csm3601949b3a.26.2026.07.27.15.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 15:53:13 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: devicetree@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dt-bindings: net: wireless: brcm,bcm4329-fmac: add nvmem-consumer reference
Date: Mon, 27 Jul 2026 15:53:11 -0700
Message-ID: <20260727225311.266596-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The brcm,bcm4329-fmac binding has unevaluatedProperties set to false
but does not allow nvmem-cells or nvmem-cell-names, which are used by
DTS files (e.g. bcm4709-linksys-ea9200.dts) to supply MAC addresses.

The driver already supports nvmem-based MAC address retrieval via
of_get_mac_address(), so add the nvmem-consumer schema reference to
document and allow these properties.

Fixes warnings with users:

['brcm,bcm4366-fmac', 'brcm,bcm4329-fmac'] does not contain items matching the given schema
from schema $id: http://devicetree.org/schemas/pci/pci-bus-common.yaml
Unevaluated properties are not allowed ('nvmem-cell-names', 'nvmem-cells' were unexpected)

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 .../devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml      | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index 81fd3e37452a..5d87de6a17bb 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -17,6 +17,7 @@ description:
 
 allOf:
   - $ref: /schemas/net/wireless/wireless-controller.yaml#
+  - $ref: /schemas/nvmem/nvmem-consumer.yaml#
 
 properties:
   compatible:
-- 
2.55.0


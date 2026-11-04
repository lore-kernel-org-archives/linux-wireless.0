Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820657;
	b=F42RNHBienTsnuB4NyzZe9JD/il0EYlPhqfz7xLppkNg8/BieuwVUgkK88aqQTUNgSBe
	 FByTD8F2LcvFAA2P0iwr5HxQKn3t890OadMe3P2Hht3h7tfFH+ZTTTnWBlej+qRDEUtoR
	 B9iNyQhV6zetuEmPJz/eB5pIfXH5S27wMKaplvV9SzKKUkZNYgcI/Vuw56MrFceU5oc5A
	 aDt95ih0kLFwnNIGhBwN/gLk8PYvuTULm/TQe2RrGapN8mT8kzCK5HAK2MICxJxeUdsXp
	 VNvnMqGKaqQ/JiP7Snt6uzEhC+q/XYABWMuBn954iXTS65rVkELEvwHFI7HfI6iZilg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820657;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=yAGcBk+LWAFBvOOewXZ3yZh72Go4Wd+roZLdUKupGgk=;
	b=Xi79VeeIXtl7o9yGDtbyLz8wA01Z2obQAidhtTUHBfmXHHoZXy0HX2HHblQ740Mw+cSB
	 ZQETrsoaBpKFo5WCN7X3S5rYGsr7wVBmR39zIrFrexbpRweI/jM5BEyr5/FCJqJ34IUsv
	 rGyQcSvjcmk7oyZe87MId71kZklaEFXaLZDdYok7evUETciTxeivn7xk6tnoxzjc+4N9M
	 bRWZTnkZJTK8LjP83eTUtt3dsuf6Ulu7fe/IF3uhMuC0rv4lWIAoHJrAIT64p7EGrMaR2
	 goCzokl9XNvuy5yxlcP+yLV8LOeOBxXBvDNLUSlsg9p7yBT4zpiBImp2ZrDzelAYJwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=UZL8mWCH;
	arc=none smtp.remote-ip=62.149.156.56
Received: from smtpcmd0756.aruba.it (smtpcmd0756.aruba.it [62.149.156.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF54606C58B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 19:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DF54606C58B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=UZL8mWCH
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Ogh3xxDlIuuRMOgh4xJX74; Wed, 04 Nov 2026 20:30:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793820646; bh=9BlQvetNuv+4h8j3yTB60v+kh4T8vn8oqQZJG9B3A/M=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=UZL8mWCHKOwCpbC6gfWlA+5BeTEs1ayvScdyQz8QNUoAT3urFv7g8BwLaUqv4ujAP
	 8u7vrhhnqX1pjPk8RjCpIeaS48gDMkMRu9JWi2AiahWZ1BGUedjkW4+gZgFHTNeR/o
	 b79xgmKS3xbUlSz94aY77b981MHI8/AssJ4ylUmGbg+G5RWvD/K0VL9EYHVUCUYIKh
	 Yo8dVQbjH3zVBTR6xyHYSiWGP1FpStmqSJMXkfF8zDinhK01Q9AbOE5fywRa2Bh4Zl
	 EHstQZ8/av8uFy+NyGxaNt+tY2jV07sKBrcCYzsogNWTiAFPpGOQpPOnOqPiypG6Kw
	 6GKSvmAY12RXQ==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 04 Nov 2026 20:30:44 +0100
Subject: [PATCH v4 1/5] dt-bindings: bus: add Broadcom BCM6362 WLAN AXI
 backplane
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-bcm6362-wlan-v4-1-f001f6d75dc3@mythread.it>
References: <20261104-bcm6362-wlan-v4-0-f001f6d75dc3@mythread.it>
In-Reply-To: <20261104-bcm6362-wlan-v4-0-f001f6d75dc3@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfIRwhac84wbXo9VECU0DHaAKnY1rE1DV2KeJfsIi4OYJeMrh9+umvn813y1/n5XC2FHQ4GVjf8Pj5aciqrxd9dax3j2nPWj8q4X3RBqR7cK/jBhExe3m
 QXePPBXU1w7etHk9Wcz3oKxWa5QaDRiCgiA8XKAucsxI5QI0v9Lpwv1gGdZmmeQSGkuBsYLez/R67p8m12cFXMprNa5alhVR6Oz5b6EzzFKUrSa5U8U5mSiv
 mPuEjdWZPuG62z8D2AkU4keIle9hRKxMnImCZ3xWOZgWiLI/kBriRWYIi/IaVxNLVPoqFNS/Cdz8NcDL62wPYLs6QG6Uw/MBnjO2aaALV+a59Epy5y3HUnkQ
 m/H+cwr9sa+O5Bj5QFbmmGXa6FXi1jKk9PNnakVm4aF+qEHT0BjgFwO1L+xJcNGf6HqBdFJAuoCJ7FRKY8Bnw/WA0zkhCJX19wm4N9TRLZJsd0mCrNHexu2h
 hnK+docw7bDqz5ppBlUzlI0hBf9DRlrXeE+i9klhtJgpYCCz0LxwYtqWkme4GgYhjcVJ/0UL7UnGHYqbsBELxIdkkRDdTeJpMeQnAVQgUwPHcVjXOB/c++wv
 3NpKCUVxnGNXxIgO4GsE1LnTCy6IB2piIlPiMBVLhrBh/N5nFOWzRbVduTaRW0UGSx4BDFrYGycCi/wc+Nun3lPF9q5ye3XgZfUjtnaTwXPz9w==

The BCM6362 integrates a WLAN macro on its own AXI backplane.
Unlike the backplanes covered by brcm,bus-axi, its cores have no
wrappers: clock gating and reset are driven through a separate
WLAN control register block, and the macro needs a clock, two
resets and the WLAN pads power domain before the backplane can be
accessed. The backplane registers are big-endian.

Add a binding describing the ChipCommon and WLAN control register
blocks, the clock, resets and power domain, and the interrupt-map
used to route core interrupts, following the brcm,bus-axi
convention.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 .../bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml    | 109 +++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
new file mode 100644
index 000000000000..c27efd719989
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
@@ -0,0 +1,109 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/bus/brcm,bcm6362-wlan-bus-axi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM6362 integrated WLAN AXI backplane
+
+maintainers:
+  - Alessio Ferri <alessio.ferri@mythread.it>
+
+description: |
+  The BCM6362 integrates a WLAN macro on a dedicated AXI backplane
+  (bcma), whose cores are discovered at runtime from the backplane
+  EROM.
+
+  The cores have no DMP wrappers: clock gating and reset of the
+  ChipCommon and 802.11 cores are controlled through a separate WLAN
+  control register block. The backplane registers are big-endian.
+
+  Interrupts of the cores are described with an interrupt-map, as for
+  brcm,bus-axi: bcma looks up each core interrupt with the core base
+  address and the core interrupt index as key. The node has no child
+  nodes; #address-cells only sets the size of the address part of the
+  key.
+
+properties:
+  compatible:
+    const: brcm,bcm6362-wlan-bus-axi
+
+  reg:
+    items:
+      - description: ChipCommon core registers
+      - description: WLAN control registers
+
+  reg-names:
+    items:
+      - const: chipcommon
+      - const: wlan-ctrl
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    items:
+      - description: WLAN macro reset
+      - description: WLAN UBUS interface reset
+
+  reset-names:
+    items:
+      - const: wlan
+      - const: wlan-ubus
+
+  power-domains:
+    maxItems: 1
+
+  "#address-cells":
+    const: 1
+
+  "#interrupt-cells":
+    const: 1
+
+  interrupt-map-mask:
+    items:
+      - const: 0x000fffff
+      - const: 0xffff
+
+  interrupt-map:
+    description:
+      Interrupt of the 802.11 core, keyed by the low 20 bits of the core
+      base address and by the core interrupt index.
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - resets
+  - reset-names
+  - power-domains
+  - "#address-cells"
+  - "#interrupt-cells"
+  - interrupt-map-mask
+  - interrupt-map
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/bcm6362-clock.h>
+    #include <dt-bindings/reset/bcm6362-reset.h>
+    #include <dt-bindings/soc/bcm6362-pm.h>
+
+    bus@10004000 {
+        compatible = "brcm,bcm6362-wlan-bus-axi";
+        reg = <0x10004000 0x1000>, <0x10007000 0x100>;
+        reg-names = "chipcommon", "wlan-ctrl";
+
+        #address-cells = <1>;
+        clocks = <&periph_clk BCM6362_CLK_WLAN_OCP>;
+        #interrupt-cells = <1>;
+        interrupt-map = <0x00005000 0 &periph_intc 7>;
+        interrupt-map-mask = <0x000fffff 0xffff>;
+        power-domains = <&periph_pwr BCM6362_POWER_DOMAIN_WLAN_PADS>;
+        resets = <&periph_rst BCM6362_RST_WLAN_SHIM>,
+                 <&periph_rst BCM6362_RST_WLAN_UBUS>;
+        reset-names = "wlan", "wlan-ubus";
+    };

-- 
2.56.0


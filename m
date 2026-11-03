Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.158.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748669;
	b=Cvt0I1DyyY1jANDZr+77bttzV/j/xIWXaYmANsNJHp+MkRdvBGlRHGlqEeFES5431u+h
	 IckrGHVVkd6MQvG64VmWysTeSiYHvxPEsCxWNQ3bQacdXwIxLRI3iTc6+0nguBWNAo5/u
	 iZvK+S7TCw82VZdVPyqPanbWaHUOtiUnAWUgtNwHWdPhj66uWSbQvg1NJyN535n3fk3+V
	 JWiGb8mWXveXk7T8TU1I5Td8/HpWO6uCBh+rCU2lToTHwu0+w2JibFbB+PAnF0WdFw8Kp
	 3Bincq27XgCHr0VJC+QqD0mGWvYWmn+T/PYLZoffuYewVkf4yIk347k+Nb/AQ/YnP3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748669;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=yAGcBk+LWAFBvOOewXZ3yZh72Go4Wd+roZLdUKupGgk=;
	b=LyKaMgXDrEZKbjTEtFr0yPcM70h6Cyv7SMAJ3+DgyEnm5+UtrnvWZfUBIyhcdj6RF0w1
	 uopojRVDxAMgg8dIodLSRGCOHt6FAGBsAA7h0JLBViq1ACVf/Kywf5jdnOjuON5ZIZTJ0
	 usVc2ek9FKhDoN4zdW74GlD6lKmRB0I/JBarcGH8kh0S3M1isAkvJYL5WWerFfEvicIjH
	 NgX2/wmPr/lcGMdY8XZOdABCsh+3HQJmoscrqBBSI5WEmj//ZwvAN8Ont8yErNSdITDlo
	 XqKokOfuSa4mkkJoGMSqrP6OEnre8aTfiTYu8/S4hs+q3MpnqcoYmoRW/FW+94qsB8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b="iI0/wf3m";
	arc=none smtp.remote-ip=62.149.158.101
Received: from smtpcmd02101.aruba.it (smtpcmd02101.aruba.it [62.149.158.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA04606A32E
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 23:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BA04606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=iI0/wf3m
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id ONxyxz48a7fl5ONxzxPx9E; Wed, 04 Nov 2026 00:30:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793748659; bh=9BlQvetNuv+4h8j3yTB60v+kh4T8vn8oqQZJG9B3A/M=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=iI0/wf3mkz2cU9UTdVmCB8sMft+uel+5dRNASyg+u1jsd6ey1pd0SXiILwLsb/WQo
	 EQ3zkotWwlcOSwEn8jWnaaXnluE5W/U5Ke6woJldNR8jsRl/Ooe3mf6XqBIOb19z7V
	 4X9EWunkl1b1HqtwWTt35K2IsU/rlf1INJmINeR3Iwp/VYf1JBzV6C3d3PB9uizCtB
	 F108L4uCHH7opAGYwdjsVDpH8chlWsBmxuauE+tpWpSXtKskuYSQP966rGCzdhy+Vc
	 0OaQTBl4LUC8m13LSVa8T+gLcy0X+wPReiVqk4IGjnDxv+oe2NXpFbYg3ZYxr13wgk
	 I1uJmdHq6eP4A==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 04 Nov 2026 00:30:57 +0100
Subject: [PATCH v3 1/5] dt-bindings: bus: add Broadcom BCM6362 WLAN AXI
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
Message-Id: <20261104-bcm6362-wlan-v3-1-e46562b2ac12@mythread.it>
References: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
In-Reply-To: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
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
X-CMAE-Envelope: MS4xfCGfJlQk5zHd5tl9/+3/t67H4T9ssLhpKRSdEehXV6IsMyUJNHfeWsrfsRrgaWaCIaRrPYMb0/3MTJjBvq3OjUoxhSct3m9JtfRO6926Rp24KaQdId/M
 bWjr8Nen32TawHDiBbg8e6LcWMVnppCynapVC58RxzsY1eIIyQmcjnxQ4w75AAOMvVvB65qMw1VMsw8uFUNA6aiixDcmljJ0imJJp3tUh1Up0VHmhLTGNtTl
 AqhiqJmjmd5yJEmLr2upiyejlHqrSq7tnqTfjgPHxNHwLzJ3ef3n3yoTDDA1SXpU27D250ztwRCFusVvakoX0Gg39Gm/XVVvKF7/EwEYEt+qs6CVa6dL++BW
 ++5vRgpx5CTxUK8QYx3Eex5r/RdCkd2McjdFHWsutX1pXmQ4ArMJsXnntA9iF3YtcadtUTOQCeXDhvgElXifMYMpG/kghcZ0T15uy9qctbSRPgcTcC2rgSnT
 kM6QpSpcJtnpbWmdYHjYgP75YpanYkw6Dvrflog8Zs27Kz7Gndxy1FJVs/bmVWca1HRoQjFlI3rigDUc001ddm+N8cUEBdjLsqxpJAx6tMwpRQkS3L4LvrOO
 NnyL2XfWfOhgH/r1vvyVZ+7vPV/rA+ikJLiXsd5ZQTB/YYauvSTk8ynqAgGKaZsyTKjdy+mTwzFcV9s+T/ohEnqCfprfXEzlJtAvrZCTa4DWYw==

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


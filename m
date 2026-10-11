Received: from smtpdh17-2.aruba.it (smtpdh17-2.aruba.it [62.149.155.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA1B46A5EC
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758923; cv=none; b=qAvZ4EFH+mFWGEdyGLVJWKOe/lD2fqE1Kem2/CzIZqMcbG/i/isKVE6l3P1tA5GRv6hdiIdnAkm5sNQNnTxi9c2M7fZ18apFjHDIfkP0FYmyhzdmkDivJzCzjk9FnCSKkvPdDEJgHgbyz4S1ImRckoFHS9P9akv+rBUhi9/Rqn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758923; c=relaxed/simple;
	bh=RfOnohMSgQ2TQzDdpa8TykWIKs+y1RLJmVmKg2dTkAs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Vg67vTAVfcUVl0kVP+21RjlhW7791cm3p1l32jY6vKAOEPWhGc/ppqHmgTY/e9/EjWnjE1EvTQpFU5YN+7/SotbfJiCv7wWKs44aRfYbAlOvXU0yzS+VjkT1vDSzxzRdvrrlwmHgDEeaeVivJDMyxlr8hT0SCtfW/Nks4KPBIks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=RdITZVCb; arc=none smtp.client-ip=62.149.155.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="RdITZVCb"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id G2INxu7ww76R9G2INxOsxl; Mon, 12 Oct 2026 00:45:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791758732; bh=RfOnohMSgQ2TQzDdpa8TykWIKs+y1RLJmVmKg2dTkAs=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=RdITZVCbUPqux8tL6vxMNdGwemIBsPcW26pV/qfTKICRIyUlTCCjLSqNOt3/JMpBo
	 ONhJI03RaDNdjG3DEljjurnTRjiIiiie4SxgYtiQzwFN3zd1IzCkDgerwW1zvQurVC
	 y5owSA0wWsH0eJPsL5htuJJAlVctzx48tdFMOzOS572L9v2L/xWXIcdtgf+ZX3Fr86
	 iiSfHwxS3IlZ2PBITJBLimDvIA4TouWyKUPle8YOCMo//yneq5xDW4+rTiTbIwOYy8
	 LRfkmZ4RuWzdyzzsslXKHpj1XFli95YkFuuieo3W0PEZ63qCHIkVU7yj2Gfx2AjBDd
	 lbKg1ppDdZ+Aw==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Mon, 12 Oct 2026 00:45:25 +0200
Subject: [PATCH v2 1/5] dt-bindings: bus: add Broadcom BCM6362 WLAN AXI
 backplane
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-bcm6362-wlan-v2-1-4752da7e0982@mythread.it>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
In-Reply-To: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfP2cNQoSpltEWhkdtWFlmY8vumarz2zBu0G4omizKhl/O1KMs3UROV8wnvfzf9jv66Hka1krNUOchSfVMILfwtz6Xyn3OtJB1FE5YrbbRlYsWbF+UDpA
 aK6Q7XygWRAnrqECHPqKuP+8DC/fVu0/qNNcxJiUhnJRs/5DHC/IlY3+qHvzhRXqLsHs4iLXSxtFxqWUxNZlW4siVByqrbo9Ta/K5KicF9ePdxd+XygdmIBg
 Ho9aP2hKw/UWbH3TgWwS8Uoo7WiNmWG8bRg94CjIvDwxJw8n5rkpdyLID7xWVssf8EmoA6ctW0GTVcHQxb4sBTx9PBoSw2b6EmSQRKNZ4LxEHmCeMMu46v49
 0UOz52wxPZ3qGZrMZo8gDH+PqqxiftVRtbx1yEXQbfFM2xxe9eD5lCxBjLO0lqVbuNsff5G9YPD8PCQKw+74pgwbLTc2BCNaDkhJN8CbRDup1S46QVgSon9y
 uWWou51+3rMjTLqi3oBuv0UctdEv3aqG9uKPLPEVW+/PNyZMZaj1/WxZWXi/7ho7PlER+kE3AYzUFsJathJK+ybAafotwJ99IbBQJwafZnnFtKWabKCkOgeI
 wBpE+zxFRnF863MiU7IPwxzsoj4d6BQLkh5fnYGC2uEez+3OneAKIqHkbxOTqzkamgA=

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

Assisted-by: LLM
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 .../bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml    | 100 +++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
new file mode 100644
index 000000000000..183de28fd032
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
@@ -0,0 +1,100 @@
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
+  Interrupts of the cores are described with an interrupt-map, keyed
+  by the core base address and the core interrupt index, as for
+  brcm,bus-axi.
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
+  interrupt-map-mask: true
+
+  interrupt-map: true
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


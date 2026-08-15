Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D04368D4C
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 08:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786782814; cv=none; b=dzg7T55joMIP2LGjLjtadfSD9qwPc7JE0ei2a+TXci0EyMd8Wl8OZDONET1kB8LS1T1I0xHUPJo1znb8StD++9ZZnne80CkHOxz9iE03H/77Lfyolj3R4D4KwJ0w1Py9hOCo+C/Qvh26yHHOGt1RmRL6Lp5sovPQit/BhDbTg9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786782814; c=relaxed/simple;
	bh=O3pMtBEmXEanZNQxxBczcnzItFMFemOxd1WChVtlbXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T2nk6koW7sqP+IsC8N2Jonuqh7bzNf9TGz64S6WKpo9anXbAB3vLb8tSc9aMH9pY3dpfwMH8fHvSdbED7wEg3JuNJP+7tD63ISBQF39cci4EOSuDa8TBuB9KDubTuqmcu27k5FpCcmynmt4W5p5H8MF3vzDQyAoaoMnqOASypeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o7GLOYrG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o7GLOYrG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49557167508so16959185e9.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 01:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786782811; x=1787387611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yht8Yw3sMnFHO9DzWevf1YnwdQDpdoW5JTYhNzme8ao=;
        b=o7GLOYrG4rdKLzRf0YdHE0CxYoqT8oc0qd4u173c5a+HNsHVuMpjigjB5exP2YF1T1
         NdX23WmBUlRtqDF/UDoPHCE9PlWx67P1UpGuLV4RNI9YX9cVPTAzSaw40ZKrdqV+a/qM
         TcQdSwZeEQ5RjB8OwQfaSAd/oJoYDnOiWLeChvv9p0rlggAVzjxEnErO8+m/5UG05yWT
         iM7hxlx+LWBSmleQDLzlaQ9xtJJm/q6tLDBVaGUju//Ik2rQJVTnuLN3rYd+qd8ktCMt
         ZRvImLgCdTZWgCmZz4X6AXAUwawCkeC6V+6WZRoRGOT0bfNMl4i9j3v08bKdovyNyZ8g
         oyHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786782811; x=1787387611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yht8Yw3sMnFHO9DzWevf1YnwdQDpdoW5JTYhNzme8ao=;
        b=BCFMlAs1DTMR7YrTByXpT3w2dwv10rF0akJfOueKCQDGNPk7DsoT8crAZiMG15qr3g
         WNR9Q8V+VWOP0Ti2+XmrZ5n3DktaFFAEE1LJbemkS5kLkexvVSSvZ4+cXXbGR8OMI+Je
         THnFsMpHUy9RyeMibbV/yaUOYo3zS4aUHx5mK27Q3kKn6hH+8mNRwLAH7l1dIUI5vos4
         VDCxKaHdWDwU7dUk6B+fsxZBtJ9qWBFB0FXNAEScSbmZ/mRXUyOXCDptkuVa+Fd6e5XO
         wfq+2LRp0QXaqm46Mqvw+Cuv8fvdUoxSmHxfz+Jaki6JvdUOyI+YsA9ryIH9rr3GzpBs
         5eUg==
X-Forwarded-Encrypted: i=1; AHgh+RoBlDhlr64XTgP+2UsJGu8Q6cOe6LPaL9F1RGcEZ1s8P5tz6CdvDIrzOgqldB822l/aH62qoZtmMKQcn7hILA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8OuLTaC+AvfyGKhnNpBMhD8iETVc15vhMIVnFhJLYwa8Rcisq
	8Zn8GEp9bk2deL7wLuX6H2s/2OxCFKQktMKiVN862o6J+hp6tspfaGzO
X-Gm-Gg: AR+sD12gvaSxCwDymUnrtbWQd5TnI2iJywM0ex5WwVmwwHpQ09M4tHrs4GSygHbRVnC
	YW4WJ4PIhNvvYYUnUB3yGW9KofXqBF5YCuR2dY91uU6K4tDWt2x4EPkR1QQi5Yb58pCTQtYo5JF
	wV7IT4IL3aAdRZLu74HsFSv3KRw4Xml7LUmeN+ulf2wzhwYcIe25tMMlv3I1BNmPIcFoy3YL9DM
	A/nzylf4ls1C8t1CxSqoLkbbG6VSWefEL//yptZKn634H0zXAr2Xn+gukBZpq2MSFLFkH9CyRyO
	suL+8++Pjd93IAiQeZRn0RjdFU5n5x1bcgaU8CW/u3pVTEDdPiOMkUuU7pEy8tLVFcsDh6kaYUx
	/denLz6H1+J2lLatAuI5alVE3zS/bDJVaYOP5ES9QJ+2IjnfQY9OCPbYiQ84GxYmB+xHhfmXSnS
	KdHXMAjx3r72pLvSx5swkwfFBLJYlT6Vz8CTBAZwhbRPb3tvUgstAn8ajiXDAs3wi7zNX6eyvqa
	Yx3inT60xxB31kg9l+loDFha7qrWz1QlyUBAMONQA==
X-Received: by 2002:a05:600c:228e:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-499879774bamr118261605e9.10.1786782811137;
        Sat, 15 Aug 2026 01:33:31 -0700 (PDT)
Received: from localhost.localdomain ([82.137.32.242])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4815f2ccc00sm14498418f8f.35.2026.08.15.01.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 01:33:30 -0700 (PDT)
From: Eduard Bostina <egbostina@gmail.com>
To: Conor Dooley <conor+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Eduard Bostina <egbostina@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Rob Herring <robh@kernel.org>
Cc: daniel.baluta@nxp.com,
	simona.toaca@nxp.com,
	goledhruva@gmail.com,
	m-chawdhry@ti.com
Subject: [PATCH] dt-bindings: net: wireless: Convert WL1251 to DT schema
Date: Sat, 15 Aug 2026 08:33:26 +0000
Message-ID: <20260815083326.2146602-1-egbostina@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the Texas Instruments WL1251 Wireless LAN Controller bindings to DT
schema.

During the conversion, the following updates were made:
- Added the 'clocks' property. It was missing from the txt binding but
  is used in device trees (omap3-n900.dts).
- Added 'spi-cpol' and 'spi-cpha'. These were present in the original
  txt binding's example but missing from its property list.
- 'vio-supply' and 'spi-max-frequency' are no longer required. The txt
  binding listed them as required, but they are only applicable when
  the chip is connected via SPI.

Signed-off-by: Eduard Bostina <egbostina@gmail.com>
---
 .../bindings/net/wireless/ti,wl1251.txt       | 64 -------------
 .../bindings/net/wireless/ti,wl1251.yaml      | 92 +++++++++++++++++++
 2 files changed, 92 insertions(+), 64 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
deleted file mode 100644
index 88fd28d15eac..000000000000
--- a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
+++ /dev/null
@@ -1,64 +0,0 @@
-* Texas Instruments wl1251 wireless lan controller
-
-The wl1251 chip can be connected via SPI or via SDIO. This
-document describes the binding for the SPI connected chip.
-
-Required properties:
-- compatible :        Should be "ti,wl1251"
-- reg :               Chip select address of device
-- spi-max-frequency : Maximum SPI clocking speed of device in Hz
-- interrupts :        Should contain interrupt line
-- vio-supply :        phandle to regulator providing VIO
-
-Optional properties:
-- ti,wl1251-has-eeprom : boolean, the wl1251 has an eeprom connected, which
-                         provides configuration data (calibration, MAC, ...)
-- ti,power-gpio :	 GPIO connected to chip's PMEN pin if operated in
-			 SPI mode
-- Please consult Documentation/devicetree/bindings/spi/spi-bus.txt
-  for optional SPI connection related properties,
-
-Examples:
-
-&spi1 {
-	wl1251@0 {
-		compatible = "ti,wl1251";
-
-		reg = <0>;
-		spi-max-frequency = <48000000>;
-		spi-cpol;
-		spi-cpha;
-
-		interrupt-parent = <&gpio2>;
-		interrupts = <10 IRQ_TYPE_NONE>; /* gpio line 42 */
-
-		vio-supply = <&vio>;
-		ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>; /* 87 */
-	};
-};
-
-&mmc3 {
-	vmmc-supply = <&wlan_en>;
-
-	bus-width = <4>;
-	non-removable;
-	ti,non-removable;
-	cap-power-off-card;
-
-	pinctrl-names = "default";
-	pinctrl-0 = <&mmc3_pins>;
-
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	wlan: wifi@1 {
-		compatible = "ti,wl1251";
-
-		reg = <1>;
-
-		interrupt-parent = <&gpio1>;
-		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* GPIO_21 */
-
-		ti,wl1251-has-eeprom;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml
new file mode 100644
index 000000000000..1f46f1235035
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml
@@ -0,0 +1,92 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/wireless/ti,wl1251.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Texas Instruments WL1251 Wireless LAN Controller
+
+maintainers:
+  - Eduard Bostina <egbostina@gmail.com>
+
+properties:
+  compatible:
+    const: ti,wl1251
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  vio-supply:
+    description:
+      Phandle to the regulator providing VIO. Required when connected via SPI.
+
+  ti,power-gpio:
+    maxItems: 1
+    description:
+      GPIO connected to chip's PMEN pin if operated in SPI mode.
+
+  ti,wl1251-has-eeprom:
+    type: boolean
+    description:
+      The wl1251 has an EEPROM connected, which provides configuration
+      data (calibration, MAC, ...).
+
+  clocks:
+    maxItems: 1
+
+  spi-max-frequency: true
+  spi-cpol: true
+  spi-cpha: true
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    spi1 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        wl1251@0 {
+            compatible = "ti,wl1251";
+            reg = <0>;
+            spi-max-frequency = <48000000>;
+            spi-cpol;
+            spi-cpha;
+            interrupt-parent = <&gpio2>;
+            interrupts = <10 IRQ_TYPE_NONE>;
+            vio-supply = <&vio>;
+            ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>;
+        };
+    };
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    mmc3 {
+        vmmc-supply = <&wlan_en>;
+        bus-width = <4>;
+        non-removable;
+        ti,non-removable;
+        cap-power-off-card;
+        pinctrl-names = "default";
+        pinctrl-0 = <&mmc3_pins>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        wifi@1 {
+            compatible = "ti,wl1251";
+            reg = <1>;
+            interrupt-parent = <&gpio1>;
+            interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;
+            ti,wl1251-has-eeprom;
+        };
+    };
-- 
2.43.0


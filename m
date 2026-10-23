Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762889;
	b=hGpnD7GDKQzuRd6IT2OFDNVARut69xKsTckzSob6l1/5DqOdMlbsF0lt05u89BPVSbLR
	 D5nn7JMAlX7g+835DEyYqjXoj7mJ3uAxVp41sZ+j8LPyQjx3AuiEj4vSTEeolYzyE4s1p
	 7b96GJzxZk1z+mS9dkmA6BzzFw/qyuvWx9uvC1t2r5LItjOq0UOwk/FeJz9hXLx6EFEqw
	 qM1Zr3YdHUxz2iy5yIydq7AEGXtEg9pL4mfHcBczAb0dYkQlySdMt38a+rVxzcVRb4Sgt
	 p09C4eDZfL9csZzZaSAbROu9fb23vNowXu/icvqPfOBmWxh3JeSsID6ljhQjLNR1+dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762889;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=x9/7eJRYDwbESNpYB8kbCEAUdqr1A0a9ky3Wg4BvjVs=;
	b=b23uTn11GQksigv97vh/DX9EkIJiorMIGb/8fCcug11bkOQ5/emWmepBr7d7rZmOI/ME
	 Uxxb3AFeyxPVBxM50KCQ8iDNvLrUFxl2TEmIx+/DjdqMXIuS0m4DhysvtWmVMte22PEIj
	 3Mn8LJq2Bx1k8OUdRLgMpPJBMaZKL+s986vnTWfRfj2UHDX1WbyqzbkTuD1kuvbXFNzJ4
	 JvsoxJrLydnQSfYQGVxz0VeytsedXCKMv/OIlgZCKuqc2e4amKHleeGuJuiklADyaz6i2
	 /IS32HBTTv5VnqzeMOw1H9AhYZ8Z2sx6Uch1uR30oZN4sUxxzOqt3B29dY4+8ksJQeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=f1arccVH;
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262EE60A2616;
	Fri, 23 Oct 2026 13:41:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 262EE60A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=f1arccVH
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 08F9F9272;
	Fri, 23 Oct 2026 16:41:27 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=x9/7eJRYDwbESNpYB8kb
	CEAUdqr1A0a9ky3Wg4BvjVs=; b=f1arccVH4kFUWema5f/VUktFlatnJe/wcPz8
	QtwOComdyPr2Zd+b5hr50Ec5TI2UZ81phCjO0MZad/WuUR8ELNKLYHZdV0vBXpgf
	bg3GfAp7zyTrrPRqLcAD6HTQpEaSj6gpSjdigVaKzOlFm4VeIosCENaiEDv0kdaZ
	k6skN7I0SGX6ziI1Xx9t2b315hf8IJHXujGi3j4MtUIGBhBqIFv4cL/Vb31Qwf6B
	sFrpMrkiVEYMhls/cCbXCGu6PRwe8GdVksrFInE7ua/iCTrf51hvkR/qfC/ngggy
	R5gAzvvFlm2xMLUaZM1dFwtueAm0SI3LyP0CRIm0R51D1bcJBw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id BD46E9021;
	Fri, 23 Oct 2026 16:41:26 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 16:41:26 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, Konrad Dybcio
	<konradybcio@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>
CC: <ath11k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 4/4] arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6 Enterprise
Date: Fri, 23 Oct 2026 16:37:00 +0300
Message-ID: <d1bd2f947ad986ff3c3fca1ad367aec2f1cec6b1.1792761470.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792761470.git.me@andrei-z.com>
References: <cover.1792761470.git.me@andrei-z.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

The Ubiquiti UniFi U6 Enterprise is a ceiling-mount Wi-Fi 6E access point:

- SoC: Qualcomm IPQ5018
- RAM: 1 GiB
- Flash: SPI NOR (boot chain) and eMMC
- 5 GHz: QCN9074 on PCIe0
- 6 GHz: QCN9074 on PCIe1
- Ethernet: one 2.5GbE PoE port, a QCA8081 PHY behind GMAC1
- Accelerometer: ST LIS2DH12
- Button: reset

Describe what mainline supports today. The Ethernet port and the
IPQ5018's own 2.4 GHz radio are left out until the GMAC and the WCSS
remoteproc have bindings; the LED controller and the board MCU on the
I2C bus have none. The QCN9074s carry the calibration variants their
board data is looked up by. The SoC dtsi gains the pcie1_port0 label, as
pcie0 has, for the 6 GHz radio below that root port. The vendor QSEE
reserves 4 MiB, twice the SoC default.

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 arch/arm64/boot/dts/qcom/Makefile             |   1 +
 .../dts/qcom/ipq5018-ubnt-u6-enterprise.dts   | 235 ++++++++++++++++++
 arch/arm64/boot/dts/qcom/ipq5018.dtsi         |   2 +-
 3 files changed, 237 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/qcom/ipq5018-ubnt-u6-enterprise.dts

diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
index 88230c4e00..aca7d8e415 100644
--- a/arch/arm64/boot/dts/qcom/Makefile
+++ b/arch/arm64/boot/dts/qcom/Makefile
@@ -32,6 +32,7 @@ dtb-$(CONFIG_ARCH_QCOM)	+= hamoa-lenovo-ideacentre-mini-01q8x10.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= hawi-mtp.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= ipq5018-rdp432-c2.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= ipq5018-tplink-archer-ax55-v1.dtb
+dtb-$(CONFIG_ARCH_QCOM)	+= ipq5018-ubnt-u6-enterprise.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= ipq5210-rdp504.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= ipq5332-rdp441.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= ipq5332-rdp442.dtb
diff --git a/arch/arm64/boot/dts/qcom/ipq5018-ubnt-u6-enterprise.dts b/arch/arm64/boot/dts/qcom/ipq5018-ubnt-u6-enterprise.dts
new file mode 100644
index 0000000000..131e89fe61
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/ipq5018-ubnt-u6-enterprise.dts
@@ -0,0 +1,235 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
+
+/dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
+
+#include "ipq5018.dtsi"
+
+/ {
+	model = "Ubiquiti UniFi U6 Enterprise";
+	compatible = "ubnt,u6-enterprise", "qcom,ipq5018";
+
+	aliases {
+		serial0 = &blsp1_uart1;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	keys {
+		compatible = "gpio-keys";
+		pinctrl-0 = <&button_pins>;
+		pinctrl-names = "default";
+
+		button-reset {
+			label = "Reset";
+			gpios = <&tlmm 24 GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_RESTART>;
+		};
+	};
+};
+
+&blsp1_i2c3 {
+	pinctrl-0 = <&i2c_pins>;
+	pinctrl-names = "default";
+
+	status = "okay";
+
+	accelerometer@18 {
+		compatible = "st,lis2dh12-accel";
+		reg = <0x18>;
+	};
+};
+
+&blsp1_spi1 {
+	pinctrl-0 = <&spi_0_pins>;
+	pinctrl-names = "default";
+
+	status = "okay";
+
+	flash@0 {
+		compatible = "jedec,spi-nor";
+		reg = <0>;
+		spi-max-frequency = <50000000>;
+
+		partitions {
+			compatible = "fixed-partitions";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			partition@0 {
+				label = "0:sbl1";
+				reg = <0x000000 0x030000>;
+				read-only;
+			};
+
+			partition@30000 {
+				label = "0:mibib";
+				reg = <0x030000 0x010000>;
+				read-only;
+			};
+
+			partition@40000 {
+				label = "0:bootconfig";
+				reg = <0x040000 0x010000>;
+				read-only;
+			};
+
+			partition@50000 {
+				label = "0:qsee";
+				reg = <0x050000 0x0a0000>;
+				read-only;
+			};
+
+			partition@f0000 {
+				label = "0:devcfg";
+				reg = <0x0f0000 0x010000>;
+				read-only;
+			};
+
+			partition@100000 {
+				label = "0:cdt";
+				reg = <0x100000 0x010000>;
+				read-only;
+			};
+
+			partition@110000 {
+				label = "0:appsblenv";
+				reg = <0x110000 0x010000>;
+			};
+
+			partition@120000 {
+				label = "0:appsbl";
+				reg = <0x120000 0x0a0000>;
+				read-only;
+			};
+
+			partition@1c0000 {
+				label = "0:art";
+				reg = <0x1c0000 0x070000>;
+				read-only;
+			};
+
+			partition@230000 {
+				label = "eeprom";
+				reg = <0x230000 0x010000>;
+				read-only;
+			};
+		};
+	};
+};
+
+/* The bootloader muxes the console pins; GPIO33/34 are I2C on this board. */
+&blsp1_uart1 {
+	status = "okay";
+};
+
+&pcie0 {
+	status = "okay";
+};
+
+&pcie0_phy {
+	status = "okay";
+};
+
+&pcie0_port0 {
+	reset-gpios = <&tlmm 15 GPIO_ACTIVE_LOW>;
+
+	wifi@0,0 {
+		compatible = "pci17cb,1104";
+		reg = <0x10000 0x0 0x0 0x0 0x0>;
+		qcom,calibration-variant = "Ubiquiti-U6-Enterprise-5G";
+	};
+};
+
+&pcie1 {
+	status = "okay";
+};
+
+&pcie1_phy {
+	status = "okay";
+};
+
+&pcie1_port0 {
+	reset-gpios = <&tlmm 18 GPIO_ACTIVE_LOW>;
+
+	wifi@0,0 {
+		compatible = "pci17cb,1104";
+		reg = <0x10000 0x0 0x0 0x0 0x0>;
+		qcom,calibration-variant = "Ubiquiti-U6-Enterprise-6G";
+	};
+};
+
+&sdhc_1 {
+	pinctrl-0 = <&emmc_pins>;
+	pinctrl-names = "default";
+	bus-width = <4>;
+	non-removable;
+	no-sd;
+	no-sdio;
+
+	status = "okay";
+};
+
+&sleep_clk {
+	clock-frequency = <32000>;
+};
+
+&tlmm {
+	button_pins: button-state {
+		pins = "gpio24";
+		function = "gpio";
+		drive-strength = <8>;
+		bias-pull-up;
+	};
+
+	emmc_pins: emmc-state {
+		clk-pins {
+			pins = "gpio9";
+			function = "sdc1_clk";
+			drive-strength = <8>;
+			bias-disable;
+		};
+
+		cmd-pins {
+			pins = "gpio8";
+			function = "sdc1_cmd";
+			drive-strength = <8>;
+			bias-pull-up;
+		};
+
+		data-pins {
+			pins = "gpio4", "gpio5", "gpio6", "gpio7";
+			function = "sdc1_data";
+			drive-strength = <8>;
+			bias-disable;
+		};
+	};
+
+	i2c_pins: i2c-state {
+		pins = "gpio33", "gpio34";
+		function = "blsp2_i2c0";
+		drive-strength = <8>;
+		bias-disable;
+	};
+
+	spi_0_pins: spi-0-state {
+		pins = "gpio10", "gpio11", "gpio12", "gpio13";
+		function = "blsp0_spi";
+		drive-strength = <8>;
+		bias-disable;
+	};
+};
+
+/* The vendor QSEE uses 4 MiB, twice the SoC default. */
+&tz_region {
+	reg = <0x0 0x4ac00000 0x0 0x400000>;
+};
+
+&xo_board_clk {
+	clock-div = <4>;
+	clock-mult = <1>;
+};
diff --git a/arch/arm64/boot/dts/qcom/ipq5018.dtsi b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
index dde5435f69..ee8c0fc03f 100644
--- a/arch/arm64/boot/dts/qcom/ipq5018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
@@ -837,7 +837,7 @@ pcie1: pcie@80000000 {
 
 			status = "disabled";
 
-			pcie@0 {
+			pcie1_port0: pcie@0 {
 				device_type = "pci";
 				reg = <0x0 0x0 0x0 0x0 0x0>;
 				bus-range = <0x01 0xff>;
-- 
2.47.3



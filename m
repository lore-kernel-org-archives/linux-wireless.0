Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:33256 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754340AbbILH2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 03:28:38 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>
Subject: [[linux-nfc] PATCH v1.0 3/3] DT: bindings: net: nfc: ST95HF binding doc
Date: Sat, 12 Sep 2015 03:21:35 -0400
Message-ID: <1442042495-2407-4-git-send-email-shikha.singh@st.com> (sfid-20150912_092841_049353_B9EFFFA2)
In-Reply-To: <1442042495-2407-1-git-send-email-shikha.singh@st.com>
References: <1442042495-2407-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch includes ST95HF binding doc that guides how to
make node entry of ST95HF in DT file of any platform.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 .../devicetree/bindings/net/nfc/st95hf.txt         | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/st95hf.txt b/Documentation/devicetree/bindings/net/nfc/st95hf.txt
new file mode 100644
index 0000000..baa4819
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/st95hf.txt
@@ -0,0 +1,55 @@
+STMicroelectronics NFC Transceiver ST95HF
+-----------------------------------------
+
+ST NFC Transceiver is required to attach with SPI bus.
+ST95HF should be defined in DT as SPI slave device of SPI master
+with which transceiver is physically connected.
+The properties defined below are required to be the part of DT
+to include transceiver into the platform.
+
+Required properties:
+
+- reg: Address of SPI slave "transceiver" on SPI master bus.
+
+- compatible: should be "st,st95hf" for ST NFC transceiver
+
+- spi-max-frequency: Max. operating SPI frequency for transceiver.
+
+- st,st95hf-enable-gpio: GPIO line used to enable transceiver.
+
+- interrupt-parent : Standard way to specify the controller to which
+		transceiver interrupt is routed.
+
+- interrupts : Standard way to define device (transceiver's out) interrupt.
+
+Optional property:
+
+- st95hfvin-supply : This is an optional property.It contains a phandle to
+		transceiver regulator supply node in DT.
+
+Example:
+	 spi@9840000 {
+                        compatible = "st,comms-ssc4-spi";
+                        reg = <0x9840000 0x110>;
+                        interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
+                        clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+                        clock-names = "ssc";
+                        pinctrl-0 = <&pinctrl_spi0_default>;
+                        pinctrl-names = "default";
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+                        cs-gpios = <&pio0 4>;
+                        status = "okay";
+
+                        st95hf@0{
+                                reg = <0>;
+                                compatible = "st,st95hf";
+                                status = "okay";
+                                spi-max-frequency = <1000000>;
+                                st,st95hf-enable-gpio = <&pio4 0>;
+                                interrupt-parent = <&pio0>;
+                                interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
+                        };
+
+                };
+
-- 
1.8.2.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:32372 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965833AbbKFTee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 14:34:34 -0500
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc] PATCH v3 3/3] DT: bindings: net: nfc: Add ST95HF binding doc
Date: Fri, 6 Nov 2015 14:34:02 -0500
Message-ID: <1446838442-10964-4-git-send-email-shikha.singh@st.com> (sfid-20151106_203439_369452_46B5BDB6)
In-Reply-To: <1446838442-10964-1-git-send-email-shikha.singh@st.com>
References: <1446838442-10964-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch includes ST95HF binding doc that guides how to
make node entry of ST95HF in DT file of any platform.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 .../devicetree/bindings/net/nfc/st95hf.txt         | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/st95hf.txt b/Documentation/devicetree/bindings/net/nfc/st95hf.txt
new file mode 100644
index 0000000..ea3178b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/st95hf.txt
@@ -0,0 +1,50 @@
+* STMicroelectronics : NFC Transceiver ST95HF
+
+ST NFC Transceiver is required to attach with SPI bus.
+ST95HF node should be defined in DT as SPI slave device of SPI
+master with which ST95HF transceiver is physically connected.
+The properties defined below are required to be the part of DT
+to include ST95HF transceiver into the platform.
+
+Required properties:
+===================
+- reg: Address of SPI slave "ST95HF transceiver" on SPI master bus.
+
+- compatible: should be "st,st95hf" for ST95HF NFC transceiver
+
+- spi-max-frequency: Max. operating SPI frequency for ST95HF
+	transceiver.
+
+- enable-gpio: GPIO line to enable ST95HF transceiver.
+
+- interrupt-parent : Standard way to specify the controller to which
+	ST95HF transceiver's interrupt is routed.
+
+- interrupts : Standard way to define ST95HF transceiver's out
+	interrupt.
+
+Optional property:
+=================
+- st95hfvin-supply : This is an optional property. It contains a
+	phandle to ST95HF transceiver's regulator supply node in DT.
+
+Example:
+=======
+spi@9840000 {
+	reg = <0x9840000 0x110>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	cs-gpios = <&pio0 4>;
+	status = "okay";
+
+	st95hf@0{
+		reg = <0>;
+		compatible = "st,st95hf";
+		status = "okay";
+		spi-max-frequency = <1000000>;
+		enable-gpio = <&pio4 0>;
+		interrupt-parent = <&pio0>;
+		interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
+	};
+
+};
-- 
1.8.2.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41054 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751015AbdEBGE3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 02:04:29 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <linux-wireless@vger.kernel.org>,
        <linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
        <sylvain.fidelis@st.com>, <raphael.collado@st.com>,
        <shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc][PATCH v1] 5/6] DT: bindings: net: nfc: stnfc binding doc
Date: Tue, 2 May 2017 02:03:42 -0400
Message-ID: <1493705023-8710-6-git-send-email-shikha.singh@st.com> (sfid-20170502_080449_200878_B2CEF1F9)
In-Reply-To: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
References: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds ST NFC binding doc that guides
how to make SPI slave node entry of ST NFC transceiver
in DT file of any platform.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 .../devicetree/bindings/net/nfc/stnfc.txt          | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/stnfc.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/stnfc.txt b/Documentation/devicetree/bindings/net/nfc/stnfc.txt
new file mode 100644
index 0000000..b050b3e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/stnfc.txt
@@ -0,0 +1,50 @@
+* STMicroelectronics : NFC Transceiver
+
+ST NFC Transceiver can be attached with SPI bus.
+ST NFC node should be defined in DT as SPI slave device of SPI
+master with which  transceiver is physically connected.
+The properties defined below are required to be the part of DT
+to include ST NFC transceiver over SPI into the platform.
+
+Required properties:
+===================
+- reg: Address of SPI slave "ST NFC transceiver" on SPI master bus.
+
+- compatible: should be "st,stnfc" for ST NFC transceiver
+
+- spi-max-frequency: Max. operating SPI frequency for ST NFC
+	transceiver.
+
+- enable-gpio: GPIO line to enable ST NFC transceiver.
+
+- interrupt-parent : Standard way to specify the controller to which
+	transceiver's interrupt is routed.
+
+- interrupts : Standard way to define ST NFC transceiver's out
+	interrupt.
+
+Optional property:
+=================
+- nfcstvin : This is an optional property. It contains a
+	phandle to ST NFC transceiver's regulator supply node in DT.
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
+	stnfc@0{
+		reg = <0>;
+		compatible = "st,stnfc";
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

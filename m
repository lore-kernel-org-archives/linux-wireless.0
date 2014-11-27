Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2819 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbaK0MJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 07:09:14 -0500
Subject: [PATCH v4 1/2] dt: bindings: add ath10k wireless device
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <devicetree@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<toshik@chromium.org>
Date: Thu, 27 Nov 2014 14:08:56 +0200
Message-ID: <20141127120856.17546.32014.stgit@potku.adurom.net> (sfid-20141127_130920_943180_1DCBA747)
In-Reply-To: <20141127120727.17546.61202.stgit@potku.adurom.net>
References: <20141127120727.17546.61202.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Document how calibration data can be provided to ath10k via Device Tree.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 .../bindings/net/wireless/qcom,ath10k.txt          |   30 ++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
new file mode 100644
index 000000000000..edefc26c6204
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -0,0 +1,30 @@
+* Qualcomm Atheros ath10k wireless devices
+
+For ath10k devices the calibration data can be provided through Device
+Tree. The node is a child node of the PCI controller.
+
+Required properties:
+-compatible : Should be "qcom,ath10k"
+
+Optional properties:
+- qcom,ath10k-calibration-data : calibration data as an array, the
+				 length can vary between hw versions
+
+
+Example:
+
+pci {
+	pcie@0 {
+		reg = <0 0 0 0 0>;
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		device_type = "pci";
+
+		ath10k@0,0 {
+			reg = <0 0 0 0 0>;
+			device_type = "pci";
+			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
+		};
+	};
+};


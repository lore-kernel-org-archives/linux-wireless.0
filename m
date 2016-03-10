Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21164 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbcCJKOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 05:14:19 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <devicetree@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<robh@kernel.org>, Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] dt: bindings: add new dt entry for pre calibration in qcom,ath10k.txt
Date: Thu, 10 Mar 2016 15:42:04 +0530
Message-ID: <1457604724-14378-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20160310_111442_762372_4048BFC1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There two things done in this patch,

1) Existing device tree entry 'qcom,ath10k-calibration-data' carries
   not only calibration data, it carries board specific data too.
   So, make appropriate update in doc.

2) ipq4019 wifi needs new devie tree entry to carry calibration
   data alone (called pre cal data, it doesn't include any other info).
   Using 'qcom,ath10k-calibration-data' for ipq4019 would alter
   the purpose of it. Hence, add new device tree entry called
   'qcom,ath10k-pre-calibration-data' to carry only pre calibration data.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---

Below patches covers the corresponding changes in the ath10k driver.
It's posted separately to ath10k and linux-wireless mailing list.

  1) ath10k: pass cal data location as an argument to ath10k_download_cal_{file|dt}
  2) ath10k: move cal data len to hw_params
  3) ath10k: incorporate qca4019 cal data download sequence

 .../bindings/net/wireless/qcom,ath10k.txt          | 23 +++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 96aae6b..74d7f0a 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -5,12 +5,18 @@ Required properties:
 	* "qcom,ath10k"
 	* "qcom,ipq4019-wifi"
 
-PCI based devices uses compatible string "qcom,ath10k" and takes only
-calibration data via "qcom,ath10k-calibration-data". Rest of the properties
-are not applicable for PCI based devices.
+PCI based devices uses compatible string "qcom,ath10k" and takes calibration
+data along with board specific data via "qcom,ath10k-calibration-data".
+Rest of the properties are not applicable for PCI based devices.
 
 AHB based devices (i.e. ipq4019) uses compatible string "qcom,ipq4019-wifi"
-and also uses most of the properties defined in this doc.
+and also uses most of the properties defined in this doc (except
+"qcom,ath10k-calibration-data"). It uses "qcom,ath10k-pre-calibration-data"
+to carry pre calibration data.
+
+In general, entry "qcom,ath10k-pre-calibration-data" and
+"qcom,ath10k-calibration-data" conflict with each other and only one
+can be provided per device.
 
 Optional properties:
 - reg: Address and length of the register set for the device.
@@ -35,8 +41,11 @@ Optional properties:
 - qcom,msi_addr: MSI interrupt address.
 - qcom,msi_base: Base value to add before writing MSI data into
 		MSI address register.
-- qcom,ath10k-calibration-data : calibration data as an array, the
-				 length can vary between hw versions
+- qcom,ath10k-calibration-data : calibration data + board specific data
+				 as an array, the length can vary between
+				 hw versions.
+- qcom,ath10k-pre-calibration-data : pre calibration data as an array,
+				     the length can vary between hw versions.
 
 Example (to supply the calibration data alone):
 
@@ -105,5 +114,5 @@ wifi0: wifi@a000000 {
 			  "legacy";
 	qcom,msi_addr = <0x0b006040>;
 	qcom,msi_base = <0x40>;
-	qcom,ath10k-calibration-data = [ 01 02 03 ... ];
+	qcom,ath10k-pre-calibration-data = [ 01 02 03 ... ];
 };
-- 
1.8.1.2


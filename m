Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33237 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbdCJIGz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 03:06:55 -0500
Received: by mail-wm0-f52.google.com with SMTP id v203so1728362wmg.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 00:06:30 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ext.waldemar.rymarkiewicz@tieto.com, kvalo@codeaurora.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 1/2] dt: bindings: add new dt entry for ath10k calibration variant
Date: Fri, 10 Mar 2017 09:06:14 +0100
Message-Id: <20170310080615.22958-1-sven.eckelmann@openmesh.com> (sfid-20170310_090736_398375_17450E8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bus + bmi-chip-id + bmi-board-id is not enough to identify the correct
board data file on QCA4019 based devices. Multiple different boards share
the same values. Only the original reference designs can currently be
identified and loaded from the board-2.bin. But these will not result in
the correct calibration data when combined with the pre-calibration data
from the device.

An additional "variant" information has to be provided (via SMBIOS or DT)
to select the correct board data for a design which was modified by an ODM.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
Since RFC:

 - Split patch in DT doc and ath10k part (thanks Christian Lamparter)
 - Remove the words "bmi-chip-id" and "bmi-board-id" and replace them with
   more generic "device specific ids"
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 74d7f0af209c..3d2a031217da 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -41,6 +41,9 @@ Optional properties:
 - qcom,msi_addr: MSI interrupt address.
 - qcom,msi_base: Base value to add before writing MSI data into
 		MSI address register.
+- qcom,ath10k-calibration-variant: string to search for in the board-2.bin
+				   variant list with the same bus and device
+				   specific ids
 - qcom,ath10k-calibration-data : calibration data + board specific data
 				 as an array, the length can vary between
 				 hw versions.
-- 
2.11.0

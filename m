Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:40794 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753260AbdLHKiB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 05:38:01 -0500
Received: by mail-qt0-f194.google.com with SMTP id u42so24863610qte.7
        for <linux-wireless@vger.kernel.org>; Fri, 08 Dec 2017 02:38:00 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ext.waldemar.rymarkiewicz@tieto.com, kvalo@codeaurora.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH v2 1/2] dt: bindings: add new dt entry for ath10k calibration variant
Date: Fri,  8 Dec 2017 11:37:41 +0100
Message-Id: <20171208103742.3181-2-sven.eckelmann@openmesh.com> (sfid-20171208_113808_645606_ABE66FDE)
In-Reply-To: <20171208103742.3181-1-sven.eckelmann@openmesh.com>
References: <20171208103742.3181-1-sven.eckelmann@openmesh.com>
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

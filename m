Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:36554 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754781AbdCIPZQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 10:25:16 -0500
From: Sven Eckelmann <sven@narfation.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        John Crispin <john@phrozen.org>,
        Simon Wunderlich <simon.wunderlich@openmesh.com>
Subject: [RFC] ath10k: search DT for qcom,ath10k-calibration-variant
Date: Thu,  9 Mar 2017 16:24:16 +0100
Message-Id: <20170309152416.4090-1-sven@narfation.org> (sfid-20170309_162555_916523_D835F6FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sven Eckelmann <sven.eckelmann@openmesh.com>

Board Data File (BDF) is loaded upon driver boot-up procedure. The right
board data file is identified on QCA4019 using bus, bmi-chip-id and
bmi-board-id.

The problem, however, can occur when the (default) board data file cannot
fulfill with the vendor requirements and it is necessary to use a different
board data file.

This problem was solved for SMBIOS by adding a special SMBIOS type 0xF8.
Something similar has to be provided for systems without SMBIOS but with
device trees. No solution was specified by QCA and therefore a new one has
to be found for ath10k.

The device tree requires addition strings to define the variant name

    wifi@a000000 {
    	status = "okay";
    	qcom,ath10k-calibration-variant = "RT-AC58U";
    };

    wifi@a800000 {
    	status = "okay";
    	qcom,ath10k-calibration-variant = "RT-AC58U";
    };

This would create the boarddata identifiers for the board-2.bin search

 *  bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=RT-AC58U
 *  bus=ahb,bmi-chip-id=0,bmi-board-id=17,variant=RT-AC58U

Cc: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: John Crispin <john@phrozen.org>
Cc: Simon Wunderlich <simon.wunderlich@openmesh.com>
---
 .../bindings/net/wireless/qcom,ath10k.txt          |  3 +++
 drivers/net/wireless/ath/ath10k/core.c             | 31 +++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 74d7f0af209c..60f87439308e 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -41,6 +41,9 @@ Optional properties:
 - qcom,msi_addr: MSI interrupt address.
 - qcom,msi_base: Base value to add before writing MSI data into
 		MSI address register.
+- qcom,ath10k-calibration-variant: string to search for in the board-2.bin
+				   variant list with the same bus bmi-chip-id,
+				   and bmi-board-id
 - qcom,ath10k-calibration-data : calibration data + board specific data
 				 as an array, the length can vary between
 				 hw versions.
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0a8e29e9a0eb..6f4c7ccb0dba 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -779,6 +779,31 @@ static int ath10k_core_check_smbios(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_core_check_dt(struct ath10k *ar)
+{
+	struct device_node *node;
+	const char *variant;
+
+	/* don't overwrite the smbios entry */
+	if (ar->id.bdf_ext[0] != '\0')
+		return 0;
+
+	node = ar->dev->of_node;
+	if (!node)
+		return -ENOENT;
+
+	of_property_read_string(node, "qcom,ath10k-calibration-variant",
+				&variant);
+	if (!variant) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "DT bdf variant name not found.\n");
+		return -ENODATA;
+	}
+
+	strscpy(ar->id.bdf_ext, variant, sizeof(ar->id.bdf_ext));
+
+	return 0;
+}
+
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
 	u32 result, address = ar->hw_params.patch_load_addr;
@@ -2221,7 +2246,11 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ret = ath10k_core_check_smbios(ar);
 	if (ret)
-		ath10k_dbg(ar, ATH10K_DBG_BOOT, "bdf variant name not set.\n");
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "SMBIOS bdf variant name not set.\n");
+
+	ret = ath10k_core_check_dt(ar);
+	if (ret)
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "DT bdf variant name not set.\n");
 
 	ret = ath10k_core_fetch_board_file(ar);
 	if (ret) {
-- 
2.11.0

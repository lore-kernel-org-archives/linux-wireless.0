Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18602 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbeASPhZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 10:37:25 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codaurora.org>,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 7/8] wil6210: enlarge FW mac_rgf_ext section for Sparrow D0
Date: Fri, 19 Jan 2018 17:37:03 +0200
Message-Id: <1516376224-13976-8-git-send-email-merez@codeaurora.org> (sfid-20180119_163739_100944_A6A7055D)
In-Reply-To: <1516376224-13976-1-git-send-email-merez@codeaurora.org>
References: <1516376224-13976-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <liord@codeaurora.org>

Sparrow D0 chips have slightly larger mac_rgf_ext section
in order to support extra features such as multiple virtual
interfaces.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 12 +++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c      |  8 ++++++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 750c34e..809092a 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -43,7 +43,7 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 	u8 chip_revision = (wil_r(wil, RGF_USER_REVISION_ID) &
 			    RGF_USER_REVISION_ID_MASK);
 	int platform_capa;
-	struct fw_map *iccm_section;
+	struct fw_map *iccm_section, *sct;
 
 	bitmap_zero(wil->hw_capa, hw_capa_last);
 	bitmap_zero(wil->fw_capabilities, WMI_FW_CAPABILITY_MAX);
@@ -54,6 +54,8 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 
 	switch (jtag_id) {
 	case JTAG_DEV_ID_SPARROW:
+		memcpy(fw_mapping, sparrow_fw_mapping,
+		       sizeof(sparrow_fw_mapping));
 		switch (chip_revision) {
 		case REVISION_ID_SPARROW_D0:
 			wil->hw_name = "Sparrow D0";
@@ -63,6 +65,12 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 
 			if (wil_fw_verify_file_exists(wil, wil_fw_name))
 				wil->wil_fw_name = wil_fw_name;
+			sct = wil_find_fw_mapping("mac_rgf_ext");
+			if (!sct) {
+				wil_err(wil, "mac_rgf_ext section not found in fw_mapping\n");
+				return -EINVAL;
+			}
+			memcpy(sct, &sparrow_d0_mac_rgf_ext, sizeof(*sct));
 			break;
 		case REVISION_ID_SPARROW_B0:
 			wil->hw_name = "Sparrow B0";
@@ -73,8 +81,6 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 			wil->hw_version = HW_VER_UNKNOWN;
 			break;
 		}
-		memcpy(fw_mapping, sparrow_fw_mapping,
-		       sizeof(sparrow_fw_mapping));
 		wil->rgf_fw_assert_code_addr = SPARROW_RGF_FW_ASSERT_CODE;
 		wil->rgf_ucode_assert_code_addr = SPARROW_RGF_UCODE_ASSERT_CODE;
 		break;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 5f9bcfb..836122a 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -355,6 +355,7 @@ struct fw_map {
 
 /* array size should be in sync with actual definition in the wmi.c */
 extern const struct fw_map sparrow_fw_mapping[SPARROW_FW_MAPPING_TABLE_SIZE];
+extern const struct fw_map sparrow_d0_mac_rgf_ext;
 extern const struct fw_map talyn_fw_mapping[TALYN_FW_MAPPING_TABLE_SIZE];
 extern struct fw_map fw_mapping[MAX_FW_MAPPING_TABLE_SIZE];
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 43c5803..b31e251 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -114,6 +114,14 @@
 };
 
 /**
+ * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for Sparrow D0
+ * it is a bit larger to support extra features
+ */
+const struct fw_map sparrow_d0_mac_rgf_ext = {
+	0x88c000, 0x88c500, 0x88c000, "mac_rgf_ext", true
+};
+
+/**
  * @talyn_fw_mapping provides memory remapping table for Talyn
  *
  * array size should be in sync with the declaration in the wil6210.h
-- 
1.9.1

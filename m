Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36313 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933846AbcHBMVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:21:08 -0400
Received: by mail-lf0-f53.google.com with SMTP id g62so136906762lfe.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 05:21:07 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/2] ath10k: add platform regulatory domain support
Date: Tue,  2 Aug 2016 14:20:54 +0200
Message-Id: <1470140454-3899-3-git-send-email-bartosz.markowski@tieto.com> (sfid-20160802_175402_021137_A0FDAEFF)
In-Reply-To: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com>
References: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This overrides whatever regulatory the device
EEPROM contains and uses what the platform says
instead - in this implementation the ACPI driver.

In case the hint is not programmed or corrupted (0xffff)
the device falls back to the eeprom programmed settings.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |   1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 117 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |   2 +-
 3 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 30ae5bf81611..1df7c600a2bb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -692,6 +692,7 @@ struct ath10k {
 	u32 phy_capability;
 	u32 hw_min_tx_power;
 	u32 hw_max_tx_power;
+	u32 hw_eeprom_rd;
 	u32 ht_cap_info;
 	u32 vht_cap_info;
 	u32 num_rf_chains;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fb8e38df9446..b6b8a0b2046b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -19,6 +19,7 @@
 
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
+#include <linux/acpi.h>
 
 #include "hif.h"
 #include "core.h"
@@ -7751,6 +7752,116 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id)
 	return arvif_iter.arvif;
 }
 
+#ifdef CONFIG_ACPI
+#define WRD_METHOD "WRDD"
+#define WRDD_WIFI  (0x07)
+
+static u32 ath10k_mac_wrdd_get_mcc(struct ath10k *ar, union acpi_object *wrdd)
+{
+	union acpi_object *mcc_pkg;
+	union acpi_object *domain_type;
+	union acpi_object *mcc_value;
+	u32 i;
+
+	if (wrdd->type != ACPI_TYPE_PACKAGE ||
+	    wrdd->package.count < 2 ||
+	    wrdd->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    wrdd->package.elements[0].integer.value != 0) {
+		ath10k_warn(ar, "ignoring malformed/unsupported wrdd structure\n");
+		return 0;
+	}
+
+	for (i = 1; i < wrdd->package.count; ++i) {
+		mcc_pkg = &wrdd->package.elements[i];
+
+		if (mcc_pkg->type != ACPI_TYPE_PACKAGE)
+			continue;
+		if (mcc_pkg->package.count < 2)
+			continue;
+		if (mcc_pkg->package.elements[0].type != ACPI_TYPE_INTEGER ||
+		    mcc_pkg->package.elements[1].type != ACPI_TYPE_INTEGER)
+			continue;
+
+		domain_type = &mcc_pkg->package.elements[0];
+		if (domain_type->integer.value != WRDD_WIFI)
+			continue;
+
+		mcc_value = &mcc_pkg->package.elements[1];
+		return mcc_value->integer.value;
+	}
+	return 0;
+}
+
+static u16 ath10k_mac_get_wrdd_regulatory(struct ath10k *ar)
+{
+	u16 rd;
+	acpi_handle root_handle;
+	acpi_handle handle;
+	struct acpi_buffer wrdd = {ACPI_ALLOCATE_BUFFER, NULL};
+	acpi_status status;
+	u32 alpha2_code;
+	char alpha2[3];
+	struct pci_dev *pdev = to_pci_dev(ar->dev);
+
+	root_handle = ACPI_HANDLE(&pdev->dev);
+	if (!root_handle) {
+		ath10k_warn(ar, "failed to get root port acpi handle\n");
+		return -1;
+	}
+
+	status = acpi_get_handle(root_handle, (acpi_string)WRD_METHOD, &handle);
+	if (ACPI_FAILURE(status)) {
+		ath10k_warn(ar, "failed to get wrd method %d\n", status);
+		return -1;
+	}
+
+	status = acpi_evaluate_object(handle, NULL, NULL, &wrdd);
+	if (ACPI_FAILURE(status)) {
+		ath10k_warn(ar, "failed to call wrdc %d\n", status);
+		return -1;
+	}
+
+	alpha2_code = ath10k_mac_wrdd_get_mcc(ar, wrdd.pointer);
+	kfree(wrdd.pointer);
+	if (!alpha2_code)
+		return -1;
+
+	alpha2[0] = (alpha2_code >> 8) & 0xff;
+	alpha2[1] = (alpha2_code >> 0) & 0xff;
+	alpha2[2] = '\0';
+
+	ath10k_info(ar, "regulatory hint from WRDD (alpha2-code): %s\n", alpha2);
+
+	rd = ath_regd_find_country_by_name(alpha2);
+	if (rd == 0xffff)
+		return rd;
+
+	rd |= COUNTRY_ERD_FLAG;
+	return rd;
+}
+
+#else
+static u16 ath10k_mac_get_wrdd_regulatory(struct ath10k *ar)
+{
+	/* fallback to default eeprom settings */
+	return -1;
+}
+#endif
+
+static int ath10k_mac_init_rd(struct ath10k *ar)
+{
+	u16 rd;
+
+	rd = ath10k_mac_get_wrdd_regulatory(ar);
+	if (rd == 0xffff) {
+		ath10k_info(ar, "fallback to eeprom programmed regulatory settings\n");
+		rd = ar->hw_eeprom_rd;
+	}
+
+	ar->ath_common.regulatory.current_rd = rd;
+	return 0;
+}
+
 int ath10k_mac_register(struct ath10k *ar)
 {
 	static const u32 cipher_suites[] = {
@@ -7974,6 +8085,12 @@ int ath10k_mac_register(struct ath10k *ar)
 		      ar->running_fw->fw_file.fw_features))
 		ar->ops->wake_tx_queue = NULL;
 
+	ret = ath10k_mac_init_rd(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to derive regdom: %d\n", ret);
+		goto err_dfs_detector_exit;
+	}
+
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 169cd2e783eb..e9aadc85ad1b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4635,7 +4635,7 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 	ar->fw_version_build = (__le32_to_cpu(arg.sw_ver1) & 0x0000ffff);
 	ar->phy_capability = __le32_to_cpu(arg.phy_capab);
 	ar->num_rf_chains = __le32_to_cpu(arg.num_rf_chains);
-	ar->ath_common.regulatory.current_rd = __le32_to_cpu(arg.eeprom_rd);
+	ar->hw_eeprom_rd = __le32_to_cpu(arg.eeprom_rd);
 
 	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
 			arg.service_map, arg.service_map_len);
-- 
2.1.2


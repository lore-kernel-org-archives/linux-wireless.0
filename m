Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40867 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbbAHL3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:29:51 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so2045877wgg.10
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:29:50 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add additional fw build version to info print
Date: Thu,  8 Jan 2015 12:29:32 +0100
Message-Id: <1420716572-23826-1-git-send-email-michal.kazior@tieto.com> (sfid-20150108_122956_772288_CBA3FCC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wmi-tlv firmware contains additional
versioning info. It may help reporting/debugging.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 4 ++++
 drivers/net/wireless/ath/ath10k/debug.c | 8 ++++++--
 drivers/net/wireless/ath/ath10k/wmi.c   | 4 ++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7b6d9e4..aa12c8a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -458,6 +458,10 @@ struct ath10k {
 	u32 fw_version_minor;
 	u16 fw_version_release;
 	u16 fw_version_build;
+	u32 fw_build_major;
+	u32 fw_build_minor;
+	u32 fw_build_si;
+	u32 fw_build_crm;
 	u32 phy_capability;
 	u32 hw_min_tx_power;
 	u32 hw_max_tx_power;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6ca2442..9a6b358 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d build %u.%u.%u.%u\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
@@ -134,7 +134,11 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->htt.target_version_minor,
 		    ar->wmi.op_version,
 		    ath10k_cal_mode_str(ar->cal_mode),
-		    ar->max_num_stations);
+		    ar->max_num_stations,
+		    ar->fw_build_major,
+		    ar->fw_build_minor,
+		    ar->fw_build_si,
+		    ar->fw_build_crm);
 	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),
 		    config_enabled(CONFIG_ATH10K_DEBUGFS),
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ac74290..8c26c2a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2907,6 +2907,10 @@ void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
 	ar->fw_version_release =
 		(__le32_to_cpu(arg.sw_ver1) & 0xffff0000) >> 16;
 	ar->fw_version_build = (__le32_to_cpu(arg.sw_ver1) & 0x0000ffff);
+	ar->fw_build_major = (__le32_to_cpu(arg.fw_build) & 0xf0000000) >> 28;
+	ar->fw_build_minor = (__le32_to_cpu(arg.fw_build) & 0x0f000000) >> 24;
+	ar->fw_build_si = (__le32_to_cpu(arg.fw_build) & 0x00f00000) >> 20;
+	ar->fw_build_crm = (__le32_to_cpu(arg.fw_build) & 0x00007fff) >> 0;
 	ar->phy_capability = __le32_to_cpu(arg.phy_capab);
 	ar->num_rf_chains = __le32_to_cpu(arg.num_rf_chains);
 	ar->ath_common.regulatory.current_rd = __le32_to_cpu(arg.eeprom_rd);
-- 
1.8.5.3


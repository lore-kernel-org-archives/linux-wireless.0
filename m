Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbZJPFVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:21:25 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 15/16] iwmc3200wifi: Set wiphy firmware version
Date: Fri, 16 Oct 2009 13:18:59 +0800
Message-Id: <1255670340-22565-16-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-15-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-11-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-12-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-13-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-14-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-15-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

Our wiphy firmware version is a combination of the UMAC and LMAC ones.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/fw.c   |    7 +++++++
 drivers/net/wireless/iwmc3200wifi/iwm.h  |    2 ++
 drivers/net/wireless/iwmc3200wifi/main.c |    4 ++++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/fw.c b/drivers/net/wireless/iwmc3200wifi/fw.c
index f02d571..4906709 100644
--- a/drivers/net/wireless/iwmc3200wifi/fw.c
+++ b/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -217,6 +217,13 @@ static int iwm_load_img(struct iwm_priv *iwm, const char *img_name)
 		 IWM_BUILD_YEAR(build_date), IWM_BUILD_MONTH(build_date),
 		 IWM_BUILD_DAY(build_date));
 
+	if (!strcmp(img_name, iwm->bus_ops->umac_name))
+		sprintf(iwm->umac_version, "%02X.%02X",
+			ver->major, ver->minor);
+
+	if (!strcmp(img_name, iwm->bus_ops->lmac_name))
+		sprintf(iwm->lmac_version, "%02X.%02X",
+			ver->major, ver->minor);
 
  err_release_fw:
 	release_firmware(fw);
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index c4a01f2..a9bf6bc 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -294,6 +294,8 @@ struct iwm_priv {
 	int resp_ie_len;
 
 	struct iwm_fw_error_hdr *last_fw_err;
+	char umac_version[8];
+	char lmac_version[8];
 
 	char private[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 97c6f5a..75f105a 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -629,6 +629,7 @@ static int __iwm_up(struct iwm_priv *iwm)
 {
 	int ret;
 	struct iwm_notif *notif_reboot, *notif_ack = NULL;
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
 
 	ret = iwm_bus_enable(iwm);
 	if (ret) {
@@ -690,6 +691,9 @@ static int __iwm_up(struct iwm_priv *iwm)
 		goto err_disable;
 	}
 
+	snprintf(wiphy->fw_version, sizeof(wiphy->fw_version), "L%s_U%s",
+		 iwm->lmac_version, iwm->umac_version);
+
 	/* We configure the UMAC and enable the wifi module */
 	ret = iwm_send_umac_config(iwm,
 			cpu_to_le32(UMAC_RST_CTRL_FLG_WIFI_CORE_EN) |
-- 
1.6.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51995 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1KRKFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 05:05:49 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath6kl: Enable multiple vif support
Date: Fri, 18 Nov 2011 10:05:28 +0530
Message-ID: <1321590928-11646-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111118_110553_729027_58CCE779)
In-Reply-To: <1321590928-11646-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1321590928-11646-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The maximum number of supported virtual interfaces are 3.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c |   18 +++---------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b185564..75b9d0e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -404,7 +404,7 @@ enum ath6kl_hif_type {
  * Driver's maximum limit, note that some firmwares support only one vif
  * and the runtime (current) limit must be checked from ar->vif_max.
  */
-#define ATH6KL_VIF_MAX	1
+#define ATH6KL_VIF_MAX	3
 
 /* vif flags info */
 enum ath6kl_vif_state {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 48544ed..bf159da 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -414,11 +414,7 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 			status = -EIO;
 		}
 
-	/*
-	 * FIXME: Make sure p2p configurations are not applied to
-	 * non-p2p capable interfaces when multivif support is enabled.
-	 */
-	if (ar->p2p) {
+	if (ar->p2p && (ar->vif_max == 1 || idx)) {
 		ret = ath6kl_wmi_info_req_cmd(ar->wmi, idx,
 					      P2P_FLAG_CAPABILITIES_REQ |
 					      P2P_FLAG_MACADDR_REQ |
@@ -431,11 +427,7 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 		}
 	}
 
-	/*
-	 * FIXME: Make sure p2p configurations are not applied to
-	 * non-p2p capable interfaces when multivif support is enabled.
-	 */
-	if (ar->p2p) {
+	if (ar->p2p && (ar->vif_max == 1 || idx)) {
 		/* Enable Probe Request reporting for P2P */
 		ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, idx, true);
 		if (ret) {
@@ -481,11 +473,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		fw_submode |= HI_OPTION_FW_SUBMODE_P2PDEV <<
 			      (i * HI_OPTION_FW_SUBMODE_BITS);
 
-	/*
-	 * FIXME: This needs to be removed once the multivif
-	 * support is enabled.
-	 */
-	if (ar->p2p)
+	if (ar->p2p && ar->vif_max == 1)
 		fw_submode = HI_OPTION_FW_SUBMODE_P2PDEV;
 
 	param = HTC_PROTOCOL_VERSION;
-- 
1.7.0.4


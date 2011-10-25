Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48448 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab1JYKQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:16:40 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 34/34] ath6kl: Enable not more than one interface to workaround target assert
Date: Tue, 25 Oct 2011 15:40:30 +0530
Message-ID: <1319537430-12459-35-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121813_985742_93878B79)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configuring the firmware for three interfaces causes random
target assert. So restrict the number of vifs to just 1
to avoid this issue for now. Once it is fixed in firmware,
this patch would be reverted.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 8702a9c..97d7f11 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -380,7 +380,7 @@ struct ath6kl_req_key {
 	u8 key_len;
 };
 
-#define MAX_NUM_VIF	3
+#define MAX_NUM_VIF	1
 
 /* vif flags info */
 enum ath6kl_vif_state {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 89234d8..eb51947 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -400,7 +400,11 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 			status = -EIO;
 		}
 
-	if (ar->p2p && idx) {
+	/*
+	 * FIXME: Make sure p2p configuration is not applied on other
+	 * non-p2p capable interfaces when multiple vif support is enabled.
+	 */
+	if (ar->p2p) {
 		ret = ath6kl_wmi_info_req_cmd(ar->wmi, idx,
 					      P2P_FLAG_CAPABILITIES_REQ |
 					      P2P_FLAG_MACADDR_REQ |
@@ -413,7 +417,7 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 		}
 	}
 
-	if (ar->p2p && idx) {
+	if (ar->p2p) {
 		/* Enable Probe Request reporting for P2P */
 		ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, idx, true);
 		if (ret) {
@@ -457,6 +461,13 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		fw_submode |= HI_OPTION_FW_SUBMODE_P2PDEV <<
 			      (i * HI_OPTION_FW_SUBMODE_BITS);
 
+	/*
+	 * FIXME: This needs to be removed once multi vif
+	 * support is enabled.
+	 */
+	if (ar->p2p)
+		fw_submode = HI_OPTION_FW_SUBMODE_P2PDEV;
+
 	/* Tell target which HTC version it is used*/
 	param = HTC_PROTOCOL_VERSION;
 	if (ath6kl_bmi_write(ar,
-- 
1.7.0.4


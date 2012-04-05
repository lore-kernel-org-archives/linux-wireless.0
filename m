Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8968 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2DEGpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 02:45:35 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Fix target assert in p2p bringup with multi vif
Date: Thu, 5 Apr 2012 12:16:09 +0530
Message-ID: <1333608369-18301-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120405_084540_039147_E2071D0A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using interface 0 for p2p causes target assert. This is because
interface 0 is always initialized to non-p2p operations. Fix this
issue by initializing all the interfaces for p2p when fw is capable
of dynamic interface switching. When fw is not capable of dynamic
switching, make sure p2p is not brought up on interface which is
not initialized for this purpose.

Reported-by: Naveen Singh navesing@qca.qualcomm.com
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   26 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/init.c     |   31 ++++++++++++++++++----------
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 1272508..26fb3d7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1451,9 +1451,35 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 					struct vif_params *params)
 {
 	struct ath6kl_vif *vif = netdev_priv(ndev);
+	int i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type %u\n", __func__, type);
 
+	/*
+	 * Don't bring up p2p on an interface which is not initialized
+	 * for p2p operation where fw does not have capability to switch
+	 * dynamically between non-p2p and p2p type interface.
+	 */
+	if (!test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+		      vif->ar->fw_capabilities)) {
+		if (type == NL80211_IFTYPE_P2P_CLIENT ||
+		    type == NL80211_IFTYPE_P2P_GO) {
+			if (vif->ar->vif_max > 1) {
+				for (i = vif->ar->max_norm_iface;
+				     i < vif->ar->vif_max; i++) {
+					if (i == vif->fw_vif_idx)
+						break;
+				}
+				if (i == vif->ar->vif_max) {
+					ath6kl_err("Invalid interface to bring up P2P\n");
+					return -EINVAL;
+				}
+			} else
+				if (vif->fw_vif_idx != 0)
+					return -EINVAL;
+		}
+	}
+
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 		vif->next_mode = INFRA_NETWORK;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 5949ab5..edd7788 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -488,22 +488,31 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		fw_mode |= fw_iftype << (i * HI_OPTION_FW_MODE_BITS);
 
 	/*
-	 * By default, submodes :
+	 * Submodes when fw does not support dynamic interface
+	 * switching:
 	 *		vif[0] - AP/STA/IBSS
 	 *		vif[1] - "P2P dev"/"P2P GO"/"P2P Client"
 	 *		vif[2] - "P2P dev"/"P2P GO"/"P2P Client"
+	 * Otherwise, All the interface are initialized to p2p dev.
 	 */
 
-	for (i = 0; i < ar->max_norm_iface; i++)
-		fw_submode |= HI_OPTION_FW_SUBMODE_NONE <<
-			      (i * HI_OPTION_FW_SUBMODE_BITS);
+	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+		     ar->fw_capabilities)) {
+		for (i = 0; i < ar->vif_max; i++)
+			fw_submode |= HI_OPTION_FW_SUBMODE_P2PDEV <<
+				(i * HI_OPTION_FW_SUBMODE_BITS);
+	} else {
+		for (i = 0; i < ar->max_norm_iface; i++)
+			fw_submode |= HI_OPTION_FW_SUBMODE_NONE <<
+				(i * HI_OPTION_FW_SUBMODE_BITS);
 
-	for (i = ar->max_norm_iface; i < ar->vif_max; i++)
-		fw_submode |= HI_OPTION_FW_SUBMODE_P2PDEV <<
-			      (i * HI_OPTION_FW_SUBMODE_BITS);
+		for (i = ar->max_norm_iface; i < ar->vif_max; i++)
+			fw_submode |= HI_OPTION_FW_SUBMODE_P2PDEV <<
+				(i * HI_OPTION_FW_SUBMODE_BITS);
 
-	if (ar->p2p && ar->vif_max == 1)
-		fw_submode = HI_OPTION_FW_SUBMODE_P2PDEV;
+		if (ar->p2p && ar->vif_max == 1)
+			fw_submode = HI_OPTION_FW_SUBMODE_P2PDEV;
+	}
 
 	if (ath6kl_bmi_write_hi32(ar, hi_app_host_interest,
 				  HTC_PROTOCOL_VERSION) != 0) {
-- 
1.7.0.4


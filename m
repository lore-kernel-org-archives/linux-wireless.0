Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16679 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946069Ab2EKVTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 17:19:18 -0400
From: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Add wow multicast firmware capability support
Date: Fri, 11 May 2012 14:19:09 -0700
Message-ID: <1336771149-17063-1-git-send-email-ngangadh@qca.qualcomm.com> (sfid-20120511_231925_141851_BEEC68BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Infrastructure to enable Multicast WOW support based on
firmware capability added to the driver.This enables
different customers or chips to control this feature based
on firmware capability.

kvalo: Firmware capability infrastructure for multicast wow feature.

Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++++--
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +++++++
 drivers/net/wireless/ath/ath6kl/main.c     |    5 ++++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b869a35..937bb15 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2074,7 +2074,9 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	if (wow && (wow->n_patterns > WOW_MAX_FILTERS_PER_LIST))
 		return -EINVAL;
 
-	if (!test_bit(NETDEV_MCAST_ALL_ON, &vif->flags)) {
+	if (!test_bit(NETDEV_MCAST_ALL_ON, &vif->flags) &&
+		test_bit(ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER,
+					      ar->fw_capabilities)) {
 		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi,
 						vif->fw_vif_idx, false);
 		if (ret)
@@ -2209,7 +2211,9 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 
 	ar->state = ATH6KL_STATE_ON;
 
-	if (!test_bit(NETDEV_MCAST_ALL_OFF, &vif->flags)) {
+	if (!test_bit(NETDEV_MCAST_ALL_OFF, &vif->flags) &&
+		test_bit(ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER,
+					ar->fw_capabilities)) {
 		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi,
 					vif->fw_vif_idx, true);
 		if (ret)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 4d9c6f1..79c7055 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -100,6 +100,13 @@ enum ath6kl_fw_capability {
 	/* Firmware has support to override rsn cap of rsn ie */
 	ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
 
+	/*
+	 * Multicast support in WOW and host awake mode.
+	 * Allow all multicast in host awake mode.
+	 * Apply multicast filter in WOW mode.
+	 */
+	ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index e552447..64d0f04 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1167,7 +1167,10 @@ static void ath6kl_set_multicast_list(struct net_device *ndev)
 	else
 		clear_bit(NETDEV_MCAST_ALL_ON, &vif->flags);
 
-	mc_all_on = mc_all_on || (vif->ar->state == ATH6KL_STATE_ON);
+	if (test_bit(ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER,
+					vif->ar->fw_capabilities)) {
+		mc_all_on = mc_all_on || (vif->ar->state == ATH6KL_STATE_ON);
+	}
 
 	if (!(ndev->flags & IFF_MULTICAST)) {
 		mc_all_on = false;
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35578 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2HJAck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 20:32:40 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: configure wow filters per-vif
Date: Thu, 9 Aug 2012 17:32:33 -0700
Message-ID: <1344558753-20253-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120810_023244_210999_A7A5D66A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only WoW filters for the first vif were being set, causing failures to
wake up on any concurrent connected vifs. Handle all per-vif suspend
and resume tasks.

Since cfg80211 issues user wow filters on a per-wiphy basis, set any
custom filters on all connected vifs.

Starting WoW in firmware and setting host sleep mode is still handled on
a global per-phy level. The first vif is always used for bookkeeping
regardless of whether it is connected or not.

WoW is cancelled if no connected vifs are found.

No firmware capability bits or API bump is needed for this patch, as
setting filters for vifs with index > 0 will simply overwrite the index
0 filters in the current implementation. While not correct, this is
identical to the existing behavior.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  145 ++++++++++++++++++----------
 1 files changed, 93 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 91f892c..80fa423 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2092,33 +2092,16 @@ static int ath6kl_cfg80211_host_sleep(struct ath6kl *ar, struct ath6kl_vif *vif)
 	return ret;
 }
 
-static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+static int ath6kl_wow_suspend_vif(struct ath6kl_vif *vif,
+				  struct cfg80211_wowlan *wow, u32 *filter)
 {
+	struct ath6kl *ar = vif->ar;
 	struct in_device *in_dev;
 	struct in_ifaddr *ifa;
-	struct ath6kl_vif *vif;
 	int ret;
-	u32 filter = 0;
 	u16 i, bmiss_time;
-	u8 index = 0;
 	__be32 ips[MAX_IP_ADDRS];
-
-	/* The FW currently can't support multi-vif WoW properly. */
-	if (ar->num_vif > 1)
-		return -EIO;
-
-	vif = ath6kl_vif_first(ar);
-	if (!vif)
-		return -EIO;
-
-	if (!ath6kl_cfg80211_ready(vif))
-		return -EIO;
-
-	if (!test_bit(CONNECTED, &vif->flags))
-		return -ENOTCONN;
-
-	if (wow && (wow->n_patterns > WOW_MAX_FILTERS_PER_LIST))
-		return -EINVAL;
+	u8 index = 0;
 
 	if (!test_bit(NETDEV_MCAST_ALL_ON, &vif->flags) &&
 	    test_bit(ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER,
@@ -2140,7 +2123,7 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	 * the user.
 	 */
 	if (wow)
-		ret = ath6kl_wow_usr(ar, vif, wow, &filter);
+		ret = ath6kl_wow_usr(ar, vif, wow, filter);
 	else if (vif->nw_type == AP_NETWORK)
 		ret = ath6kl_wow_ap(ar, vif);
 	else
@@ -2175,12 +2158,10 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 			return ret;
 	}
 
-	ar->state = ATH6KL_STATE_SUSPENDING;
-
 	/* Setup own IP addr for ARP agent. */
 	in_dev = __in_dev_get_rtnl(vif->ndev);
 	if (!in_dev)
-		goto skip_arp;
+		return 0;
 
 	ifa = in_dev->ifa_list;
 	memset(&ips, 0, sizeof(ips));
@@ -2203,41 +2184,61 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		return ret;
 	}
 
-skip_arp:
-	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, vif->fw_vif_idx,
+	return ret;
+}
+
+static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+{
+	struct ath6kl_vif *first_vif, *vif;
+	int ret = 0;
+	u32 filter = 0;
+	bool connected = false;
+
+	/* enter / leave wow suspend on first vif always */
+	first_vif = ath6kl_vif_first(ar);
+	if (WARN_ON(unlikely(!first_vif)) ||
+	    !ath6kl_cfg80211_ready(first_vif))
+		return -EIO;
+
+	if (wow && (wow->n_patterns > WOW_MAX_FILTERS_PER_LIST))
+		return -EINVAL;
+
+	/* install filters for each connected vif */
+	spin_lock_bh(&ar->list_lock);
+	list_for_each_entry(vif, &ar->vif_list, list) {
+		if (!test_bit(CONNECTED, &vif->flags) ||
+		    !ath6kl_cfg80211_ready(vif))
+			continue;
+		connected = true;
+
+		ret = ath6kl_wow_suspend_vif(vif, wow, &filter);
+		if (ret)
+			break;
+	}
+	spin_unlock_bh(&ar->list_lock);
+
+	if (!connected)
+		return -ENOTCONN;
+	else if (ret)
+		return ret;
+
+	ar->state = ATH6KL_STATE_SUSPENDING;
+
+	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, first_vif->fw_vif_idx,
 					  ATH6KL_WOW_MODE_ENABLE,
 					  filter,
 					  WOW_HOST_REQ_DELAY);
 	if (ret)
 		return ret;
 
-	ret = ath6kl_cfg80211_host_sleep(ar, vif);
-	if (ret)
-		return ret;
-
-	return 0;
+	return ath6kl_cfg80211_host_sleep(ar, first_vif);
 }
 
-static int ath6kl_wow_resume(struct ath6kl *ar)
+static int ath6kl_wow_resume_vif(struct ath6kl_vif *vif)
 {
-	struct ath6kl_vif *vif;
+	struct ath6kl *ar = vif->ar;
 	int ret;
 
-	vif = ath6kl_vif_first(ar);
-	if (!vif)
-		return -EIO;
-
-	ar->state = ATH6KL_STATE_RESUMING;
-
-	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
-						 ATH6KL_HOST_MODE_AWAKE);
-	if (ret) {
-		ath6kl_warn("Failed to configure host sleep mode for wow resume: %d\n",
-			    ret);
-		ar->state = ATH6KL_STATE_WOW;
-		return ret;
-	}
-
 	if (vif->nw_type != AP_NETWORK) {
 		ret = ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx,
 						0, 0, 0, 0, 0, 0, 3, 0, 0, 0);
@@ -2255,13 +2256,11 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 			return ret;
 	}
 
-	ar->state = ATH6KL_STATE_ON;
-
 	if (!test_bit(NETDEV_MCAST_ALL_OFF, &vif->flags) &&
 	    test_bit(ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER,
 		     ar->fw_capabilities)) {
 		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi,
-					vif->fw_vif_idx, true);
+						  vif->fw_vif_idx, true);
 		if (ret)
 			return ret;
 	}
@@ -2271,6 +2270,48 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_wow_resume(struct ath6kl *ar)
+{
+	struct ath6kl_vif *vif;
+	int ret;
+
+	vif = ath6kl_vif_first(ar);
+	if (WARN_ON(unlikely(!vif)) ||
+	    !ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	ar->state = ATH6KL_STATE_RESUMING;
+
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
+						 ATH6KL_HOST_MODE_AWAKE);
+	if (ret) {
+		ath6kl_warn("Failed to configure host sleep mode for "
+			    "wow resume: %d\n", ret);
+		goto cleanup;
+	}
+
+	spin_lock_bh(&ar->list_lock);
+	list_for_each_entry(vif, &ar->vif_list, list) {
+		if (!test_bit(CONNECTED, &vif->flags) ||
+		    !ath6kl_cfg80211_ready(vif))
+			continue;
+		ret = ath6kl_wow_resume_vif(vif);
+		if (ret)
+			break;
+	}
+	spin_unlock_bh(&ar->list_lock);
+
+	if (ret)
+		goto cleanup;
+
+	ar->state = ATH6KL_STATE_ON;
+	return 0;
+
+cleanup:
+	ar->state = ATH6KL_STATE_WOW;
+	return ret;
+}
+
 static int ath6kl_cfg80211_deepsleep_suspend(struct ath6kl *ar)
 {
 	struct ath6kl_vif *vif;
-- 
1.7.4.1


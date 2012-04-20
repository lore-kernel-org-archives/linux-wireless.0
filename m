Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33560 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab2DTTq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 15:46:57 -0400
From: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH v3] ath6kl: Multicast filter support in wow suspend and non-suspend
Date: Fri, 20 Apr 2012 12:46:56 -0700
Message-ID: <1334951216-13792-1-git-send-email-ngangadh@qca.qualcomm.com> (sfid-20120420_214701_142335_516B00FF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables all multicast packets in non suspend mode
and enable multicast filtering in wow suspend mode. This also
fixes a bug in multicast where the driver assumed disable
multicast-all command disabled/filtered all multicast
packets, which was wrong assumption, because firmware will
apply the programmed filter.

Multicast requirements
 - Enable forward all multicast packets(no filtering) in
      non suspend mode.
 - Enable multicast filtering in wow suspend mode for both
      AP and CLIENT.

Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   15 +++++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +
 drivers/net/wireless/ath/ath6kl/main.c     |   36 ++++++++++++++++++++-------
 3 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 86d388f..426fef8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2042,6 +2042,13 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	if (wow && (wow->n_patterns > WOW_MAX_FILTERS_PER_LIST))
 		return -EINVAL;
 
+	if (!test_bit(NETDEV_MCAST_ALL_ON, &vif->flags)) {
+		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi,
+						vif->fw_vif_idx, false);
+		if (ret)
+			return ret;
+	}
+
 	/* Clear existing WOW patterns */
 	for (i = 0; i < WOW_MAX_FILTERS_PER_LIST; i++)
 		ath6kl_wmi_del_wow_pattern_cmd(ar->wmi, vif->fw_vif_idx,
@@ -2170,6 +2177,13 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 
 	ar->state = ATH6KL_STATE_ON;
 
+	if (!test_bit(NETDEV_MCAST_ALL_OFF, &vif->flags)) {
+		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi,
+					vif->fw_vif_idx, true);
+		if (ret)
+			return ret;
+	}
+
 	netif_wake_queue(vif->ndev);
 
 	return 0;
@@ -2263,7 +2277,6 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 		ath6kl_tx_data_cleanup(ar);
 
 		prev_state = ar->state;
-
 		ret = ath6kl_wow_suspend(ar, wow);
 		if (ret) {
 			ar->state = prev_state;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 9d67964..9ff5643 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -502,6 +502,8 @@ enum ath6kl_vif_state {
 	WLAN_ENABLED,
 	STATS_UPDATE_PEND,
 	HOST_SLEEP_MODE_CMD_PROCESSED,
+	NETDEV_MCAST_ALL_ON,
+	NETDEV_MCAST_ALL_OFF,
 };
 
 struct ath6kl_vif {
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 7f3addd..cbad4c2 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1088,7 +1088,7 @@ static int ath6kl_set_features(struct net_device *dev,
 static void ath6kl_set_multicast_list(struct net_device *ndev)
 {
 	struct ath6kl_vif *vif = netdev_priv(ndev);
-	bool mc_all_on = false, mc_all_off = false;
+	bool mc_all_on = false;
 	int mc_count = netdev_mc_count(ndev);
 	struct netdev_hw_addr *ha;
 	bool found;
@@ -1100,24 +1100,40 @@ static void ath6kl_set_multicast_list(struct net_device *ndev)
 	    !test_bit(WLAN_ENABLED, &vif->flags))
 		return;
 
+	/* Enable multicast-all filter. */
 	mc_all_on = !!(ndev->flags & IFF_PROMISC) ||
 		    !!(ndev->flags & IFF_ALLMULTI) ||
 		    !!(mc_count > ATH6K_MAX_MC_FILTERS_PER_LIST);
 
-	mc_all_off = !(ndev->flags & IFF_MULTICAST) || mc_count == 0;
+	if (mc_all_on)
+		set_bit(NETDEV_MCAST_ALL_ON, &vif->flags);
+	else
+		clear_bit(NETDEV_MCAST_ALL_ON, &vif->flags);
 
-	if (mc_all_on || mc_all_off) {
-		/* Enable/disable all multicast */
-		ath6kl_dbg(ATH6KL_DBG_TRC, "%s multicast filter\n",
-			   mc_all_on ? "enabling" : "disabling");
-		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi, vif->fw_vif_idx,
+	mc_all_on = mc_all_on || (vif->ar->state == ATH6KL_STATE_ON);
+
+	if (!(ndev->flags & IFF_MULTICAST)) {
+		mc_all_on = false;
+		set_bit(NETDEV_MCAST_ALL_OFF, &vif->flags);
+	} else {
+		clear_bit(NETDEV_MCAST_ALL_OFF, &vif->flags);
+	}
+
+	/* Enable/disable "multicast-all" filter*/
+	ath6kl_dbg(ATH6KL_DBG_TRC, "%s multicast-all filter\n",
+		    mc_all_on ? "enabling" : "disabling");
+	ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi, vif->fw_vif_idx,
 						  mc_all_on);
-		if (ret)
-			ath6kl_warn("Failed to %s multicast receive\n",
-				    mc_all_on ? "enable" : "disable");
+	if (ret) {
+		ath6kl_warn("Failed to %s multicast-all receive\n",
+			    mc_all_on ? "enable" : "disable");
 		return;
 	}
 
+	if (test_bit(NETDEV_MCAST_ALL_ON, &vif->flags))
+		return;
+
+	/* Keep the driver and firmware mcast list in sync. */
 	list_for_each_entry_safe(mc_filter, tmp, &vif->mc_filter, list) {
 		found = false;
 		netdev_for_each_mc_addr(ha, ndev) {
-- 
1.7.0.4


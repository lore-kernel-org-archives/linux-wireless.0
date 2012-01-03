Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45347 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ACJMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 04:12:12 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 3/3] ath6kl: Implement ndo_set_rx_mode()
Date: Tue, 3 Jan 2012 14:42:01 +0530
Message-ID: <1325581921-5249-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120103_101227_231677_1F1BC51D)
In-Reply-To: <1325581921-5249-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1325581921-5249-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are maximum of seven multicast filter are supported
by hw. When the requested number of filters exceeds the
maximum supported one, multicast filtering is completely
disabled, the requested filters will be configured in
firmware and the only multicast frames that host is interested
in will be passed to host for further processing otherwise.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    9 ++
 drivers/net/wireless/ath/ath6kl/main.c     |  110 ++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d6806be..4777175 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2799,12 +2799,15 @@ static int ath6kl_init_if_data(struct ath6kl_vif *vif)
 	set_bit(WMM_ENABLED, &vif->flags);
 	spin_lock_init(&vif->if_lock);
 
+	INIT_LIST_HEAD(&vif->mc_filter);
+
 	return 0;
 }
 
 void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 {
 	struct ath6kl *ar = vif->ar;
+	struct ath6kl_mc_filter *mc_filter, *tmp;
 
 	aggr_module_destroy(vif->aggr_cntxt);
 
@@ -2813,6 +2816,11 @@ void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 	if (vif->nw_type == ADHOC_NETWORK)
 		ar->ibss_if_active = false;
 
+	list_for_each_entry_safe(mc_filter, tmp, &vif->mc_filter, list) {
+		list_del(&mc_filter->list);
+		kfree(mc_filter);
+	}
+
 	unregister_netdevice(vif->ndev);
 
 	ar->num_vif--;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c095faf..793c6a5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -410,6 +410,13 @@ enum ath6kl_hif_type {
 	ATH6KL_HIF_TYPE_USB,
 };
 
+/* Max number of filters that hw supports */
+#define ATH6K_MAX_MC_FILTERS_PER_LIST 7
+struct ath6kl_mc_filter {
+	struct list_head list;
+	char hw_addr[ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE];
+};
+
 /*
  * Driver's maximum limit, note that some firmwares support only one vif
  * and the runtime (current) limit must be checked from ar->vif_max.
@@ -473,6 +480,8 @@ struct ath6kl_vif {
 	u8 assoc_bss_dtim_period;
 	struct net_device_stats net_stats;
 	struct target_stats target_stats;
+
+	struct list_head mc_filter;
 };
 
 #define WOW_LIST_ID		0
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index ff447b0..f39555f 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1016,11 +1016,121 @@ static struct net_device_stats *ath6kl_get_stats(struct net_device *dev)
 	return &vif->net_stats;
 }
 
+static void ath6kl_set_multicast_list(struct net_device *ndev)
+{
+	struct ath6kl_vif *vif = netdev_priv(ndev);
+	bool mc_all_on = false, mc_all_off = false;
+	int mc_count = netdev_mc_count(ndev);
+	struct netdev_hw_addr *ha;
+	bool found;
+	struct ath6kl_mc_filter *mc_filter, *tmp;
+	struct list_head mc_filter_new;
+	int ret;
+
+	if (!test_bit(WMI_READY, &vif->ar->flag) ||
+	    !test_bit(WLAN_ENABLED, &vif->flags))
+		return;
+
+	mc_all_on = !!(ndev->flags & IFF_PROMISC) ||
+		    !!(ndev->flags & IFF_ALLMULTI) ||
+		    !!(mc_count > ATH6K_MAX_MC_FILTERS_PER_LIST);
+
+	mc_all_off = !(ndev->flags & IFF_MULTICAST) || mc_count == 0;
+
+	if (mc_all_on || mc_all_off) {
+		/* Enable/disable all multicast */
+		ath6kl_dbg(ATH6KL_DBG_TRC, "%s multicast filter\n",
+			  mc_all_on ? "enabling" : "disabling");
+		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi, vif->fw_vif_idx,
+						  mc_all_on);
+		if (ret)
+			ath6kl_warn("Failed to %s multicast receive\n",
+				    mc_all_on ? "enable" : "disable");
+		return;
+	}
+
+	list_for_each_entry_safe(mc_filter, tmp, &vif->mc_filter, list) {
+		found = false;
+		netdev_for_each_mc_addr(ha, ndev) {
+			if (memcmp(ha->addr, mc_filter->hw_addr,
+			    ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE) == 0) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			/*
+			 * Delete the filter which was previously set
+			 * but not in the new request.
+			 */
+			ath6kl_dbg(ATH6KL_DBG_TRC,
+				   "Removing %pM from multicast filter\n",
+				   mc_filter->hw_addr);
+			ret = ath6kl_wmi_add_del_mcast_filter_cmd(vif->ar->wmi,
+					vif->fw_vif_idx, mc_filter->hw_addr,
+					false);
+			if (ret) {
+				ath6kl_warn("Failed to remove multicast filter:%pM\n",
+					     mc_filter->hw_addr);
+				return;
+			}
+
+			list_del(&mc_filter->list);
+			kfree(mc_filter);
+		}
+	}
+
+	INIT_LIST_HEAD(&mc_filter_new);
+
+	netdev_for_each_mc_addr(ha, ndev) {
+		found = false;
+		list_for_each_entry(mc_filter, &vif->mc_filter, list) {
+			if (memcmp(ha->addr, mc_filter->hw_addr,
+			    ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE) == 0) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			mc_filter = kzalloc(sizeof(struct ath6kl_mc_filter),
+					    GFP_ATOMIC);
+			if (!mc_filter) {
+				WARN_ON(1);
+				goto out;
+			}
+
+			memcpy(mc_filter->hw_addr, ha->addr,
+			       ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE);
+			/* Set the multicast filter */
+			ath6kl_dbg(ATH6KL_DBG_TRC,
+				   "Adding %pM to multicast filter list\n",
+				   mc_filter->hw_addr);
+			ret = ath6kl_wmi_add_del_mcast_filter_cmd(vif->ar->wmi,
+					vif->fw_vif_idx, mc_filter->hw_addr,
+					true);
+			if (ret) {
+				ath6kl_warn("Failed to add multicast filter :%pM\n",
+					     mc_filter->hw_addr);
+				kfree(mc_filter);
+				goto out;
+			}
+
+			list_add_tail(&mc_filter->list, &mc_filter_new);
+		}
+	}
+
+out:
+	list_splice_tail(&mc_filter_new, &vif->mc_filter);
+}
+
 static struct net_device_ops ath6kl_netdev_ops = {
 	.ndo_open               = ath6kl_open,
 	.ndo_stop               = ath6kl_close,
 	.ndo_start_xmit         = ath6kl_data_tx,
 	.ndo_get_stats          = ath6kl_get_stats,
+	.ndo_set_rx_mode	= ath6kl_set_multicast_list,
 };
 
 void init_netdev(struct net_device *dev)
-- 
1.7.0.4


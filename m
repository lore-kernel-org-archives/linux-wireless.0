Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46829 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbbB0Jyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 04:54:41 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V3 2/2] ath10k: Fix interrupt storm
Date: Fri, 27 Feb 2015 15:20:06 +0530
Message-ID: <1425030606-21933-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150227_105449_382583_1C5F4404)
In-Reply-To: <1425030606-21933-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1425030606-21933-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Promiscuous mode is enabled when wlan interface is added to
bridge. ath10k creates a monitor mode when promiscuous mode
is enabled. When monitor vdev is runing along with other
vdev(s) there is a huge number of interrupts generated
especially in noisy condition. Fix this by not enabling
promiscuous(monitor) mode when already a vdev is running.
As disabling promiscuous mode may have issues with 4-address
bridging in STA mode, the change is done specific to non-sta/ibss
mode types. This does not change the support of virtual interface of
type monitor along with other vdevs of any type.

This could fix manangement frame drop in fw due to unavailable
buffers because in monitor mode device receives everything seen
on the air. In noisy condition, disabling monitor mode helps assoc
go through without any issue.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   35 +++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3b5aaa3..885e984 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -766,12 +766,36 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 	return 0;
 }
 
+static bool ath10k_disable_promisc_mode(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+
+	if (!ar->num_started_vdevs)
+		return false;
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		/* Disabling promiscuous mode when STA/IBSS is running */
+		if (arvif->vdev_type == WMI_VDEV_TYPE_STA ||
+		    arvif->vdev_type == WMI_VDEV_TYPE_IBSS)
+			return false;
+	}
+
+	return true;
+}
+
 static int ath10k_monitor_recalc(struct ath10k *ar)
 {
 	bool should_start;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if ((ar->filter_flags & FIF_PROMISC_IN_BSS) &&
+	    ath10k_disable_promisc_mode(ar)) {
+		ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac disabling promiscuous mode because vdev is started\n");
+	}
+
 	should_start = ar->monitor ||
 		       ar->filter_flags & FIF_PROMISC_IN_BSS ||
 		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
@@ -969,6 +993,10 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 	ar->num_started_vdevs++;
 	ath10k_recalc_radar_detection(ar);
 
+	ret = ath10k_monitor_recalc(ar);
+	if (ret)
+		ath10k_vdev_stop(arvif);
+
 	return ret;
 }
 
@@ -3476,6 +3504,13 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
+	if (*total_flags & FIF_PROMISC_IN_BSS) {
+		if (ar->num_started_vdevs) {
+			ath10k_dbg(ar, ATH10K_DBG_MAC,
+				   "mac does not enable promiscuous mode when already a vdev is running\n");
+			*total_flags &= ~FIF_PROMISC_IN_BSS;
+		}
+	}
 	ar->filter_flags = *total_flags;
 
 	ret = ath10k_monitor_recalc(ar);
-- 
1.7.9.5


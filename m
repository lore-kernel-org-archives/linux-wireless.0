Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29441 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbbBQHtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 02:49:16 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 2/2] ath10k: Fix interrupt storm
Date: Tue, 17 Feb 2015 13:13:16 +0530
Message-ID: <1424158996-8830-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150217_084921_478413_DF46A45F)
In-Reply-To: <1424158996-8830-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1424158996-8830-1-git-send-email-vthiagar@qti.qualcomm.com>
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
This does not change the support of virtual interface of
type monitor along with other vdevs.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3b5aaa3..66cc0a8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -969,6 +969,15 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 	ar->num_started_vdevs++;
 	ath10k_recalc_radar_detection(ar);
 
+	if (ar->filter_flags & FIF_PROMISC_IN_BSS) {
+		ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac disabling promiscuous mode because vdev is started\n");
+		ret = ath10k_monitor_recalc(ar);
+		if (ret)
+			ath10k_vdev_stop(arvif);
+	}
+
 	return ret;
 }
 
@@ -3476,6 +3485,13 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
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


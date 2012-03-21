Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29694 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2CUJeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 05:34:02 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Isolate host sleep mode config part from ath6kl_wow_suspend
Date: Wed, 21 Mar 2012 15:03:37 +0530
Message-ID: <1332322418-16572-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120321_103429_813758_FF9CB536)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

The piece of code used in ath6kk_wow_suspend function
to configure the host sleep mode is needed in deep sleep
case also.

Moving that portion to a separate function called
ath6kl_update_host_mode() would be helpful to avoid
the duplication of the same code in deep sleep path.

There is no functional change.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   72 ++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/core.h     |   10 ++++
 2 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b605f4a..883a0ca 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1924,12 +1924,50 @@ static int ath6kl_wow_sta(struct ath6kl *ar, struct ath6kl_vif *vif)
 	return 0;
 }
 
+static int ath6kl_cfg80211_host_sleep(struct ath6kl *ar, struct ath6kl_vif *vif)
+{
+	int ret, left;
+
+	clear_bit(HOST_SLEEP_MODE_CMD_PROCESSED, &vif->flags);
+
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
+						 ATH6KL_HOST_MODE_ASLEEP);
+	if (ret)
+		return ret;
+
+	left = wait_event_interruptible_timeout(ar->event_wq,
+						is_hsleep_mode_procsed(vif),
+						WMI_TIMEOUT);
+	if (left == 0) {
+		ath6kl_warn("timeout, didn't get host sleep cmd processed event\n");
+		ret = -ETIMEDOUT;
+	} else if (left < 0) {
+		ath6kl_warn("error while waiting for host sleep cmd processed event %d\n", left);
+		ret = left;
+	}
+
+	if (ar->tx_pending[ar->ctrl_ep]) {
+		left = wait_event_interruptible_timeout(ar->event_wq,
+							is_ctrl_ep_empty(ar),
+							WMI_TIMEOUT);
+		if (left == 0) {
+			ath6kl_warn("clear wmi ctrl data timeout\n");
+			ret = -ETIMEDOUT;
+		} else if (left < 0) {
+			ath6kl_warn("clear wmi ctrl data failed: %d\n", left);
+			ret = left;
+		}
+	}
+
+	return ret;
+}
+
 static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 {
 	struct in_device *in_dev;
 	struct in_ifaddr *ifa;
 	struct ath6kl_vif *vif;
-	int ret, left;
+	int ret;
 	u32 filter = 0;
 	u16 i, bmiss_time;
 	u8 index = 0;
@@ -2030,39 +2068,11 @@ skip_arp:
 	if (ret)
 		return ret;
 
-	clear_bit(HOST_SLEEP_MODE_CMD_PROCESSED, &vif->flags);
-
-	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
-						 ATH6KL_HOST_MODE_ASLEEP);
+	ret = ath6kl_cfg80211_host_sleep(ar, vif);
 	if (ret)
 		return ret;
 
-	left = wait_event_interruptible_timeout(ar->event_wq,
-			test_bit(HOST_SLEEP_MODE_CMD_PROCESSED, &vif->flags),
-			WMI_TIMEOUT);
-	if (left == 0) {
-		ath6kl_warn("timeout, didn't get host sleep cmd "
-			    "processed event\n");
-		ret = -ETIMEDOUT;
-	} else if (left < 0) {
-		ath6kl_warn("error while waiting for host sleep cmd "
-			    "processed event %d\n", left);
-		ret = left;
-	}
-
-	if (ar->tx_pending[ar->ctrl_ep]) {
-		left = wait_event_interruptible_timeout(ar->event_wq,
-				ar->tx_pending[ar->ctrl_ep] == 0, WMI_TIMEOUT);
-		if (left == 0) {
-			ath6kl_warn("clear wmi ctrl data timeout\n");
-			ret = -ETIMEDOUT;
-		} else if (left < 0) {
-			ath6kl_warn("clear wmi ctrl data failed: %d\n", left);
-			ret = left;
-		}
-	}
-
-	return ret;
+	return 0;
 }
 
 static int ath6kl_wow_resume(struct ath6kl *ar)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 17697eb..af9b18b 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -741,6 +741,16 @@ static inline u32 ath6kl_get_hi_item_addr(struct ath6kl *ar,
 	return addr;
 }
 
+static inline int is_hsleep_mode_procsed(struct ath6kl_vif *vif)
+{
+	return test_bit(HOST_SLEEP_MODE_CMD_PROCESSED, &vif->flags);
+}
+
+static inline bool is_ctrl_ep_empty(struct ath6kl *ar)
+{
+	return !ar->tx_pending[ar->ctrl_ep];
+}
+
 int ath6kl_configure_target(struct ath6kl *ar);
 void ath6kl_detect_error(unsigned long ptr);
 void disconnect_timer_handler(unsigned long ptr);
-- 
1.7.1


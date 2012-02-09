Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47006 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2BIJc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 04:32:28 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 1/1] ath6kl: Check wow state before sending control and data pkt
Date: Thu, 9 Feb 2012 15:01:56 +0530
Message-ID: <1328779916-7732-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120209_103235_829755_39699379)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Below two scenarios are taken care in this patch which helped
to fix the firmware crash during wow suspend/resume.

* TX operation (ctrl tx and data tx) has to be controlled based
  on suspend state. i.e, with respect to WOW mode, control packets
  are allowed to send from the host until the suspend state goes
  ATH6KL_STATE_WOW and the data packets are allowed until WOW
  suspend operation starts.

* Similarly, wow resume is NOT allowed if WOW suspend is in progress.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
V2 changes:

* Separate wow sub state introduced in V1 is removed and common
  states (ATH6KL_STATE_SUSPENDING and ATH6KL_STATE_RESUMING)
  are added in enum ath6kl_state.

* netdev queue is stopped while dropping skb in ath6kl_data_tx()
  and resumed back in ath6kl_wow_resume().
 
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   29 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +
 drivers/net/wireless/ath/ath6kl/sdio.c     |    4 +++
 drivers/net/wireless/ath/ath6kl/txrx.c     |   10 +++++++++
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d1922d8..dfd3ba4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1941,6 +1941,8 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	if (ret)
 		return ret;
 
+	ar->state = ATH6KL_STATE_SUSPENDING;
+
 	/* Setup own IP addr for ARP agent. */
 	in_dev = __in_dev_get_rtnl(vif->ndev);
 	if (!in_dev)
@@ -2019,15 +2021,33 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 	if (!vif)
 		return -EIO;
 
+	ar->state = ATH6KL_STATE_RESUMING;
+
 	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
 						 ATH6KL_HOST_MODE_AWAKE);
-	return ret;
+	if (ret) {
+		ath6kl_warn("Failed to configure host sleep mode for "
+			    "wow resume: %d\n", ret);
+		ar->state = ATH6KL_STATE_WOW;
+		return ret;
+	}
+
+	ar->state = ATH6KL_STATE_ON;
+
+	/* Wake up netdev queue if it's stopped in ath6kl_data_tx() */
+	if (test_bit(NETQ_STOPPED, &vif->flags)) {
+		clear_bit(NETQ_STOPPED, &vif->flags);
+		netif_wake_queue(vif->ndev);
+	}
+
+	return 0;
 }
 
 int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 			    enum ath6kl_cfg_suspend_mode mode,
 			    struct cfg80211_wowlan *wow)
 {
+	enum ath6kl_state prev_state;
 	int ret;
 
 	switch (mode) {
@@ -2038,9 +2058,12 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 		/* Flush all non control pkts in TX path */
 		ath6kl_tx_data_cleanup(ar);
 
+		prev_state = ar->state;
+
 		ret = ath6kl_wow_suspend(ar, wow);
 		if (ret) {
 			ath6kl_err("wow suspend failed: %d\n", ret);
+			ar->state = prev_state;
 			return ret;
 		}
 		ar->state = ATH6KL_STATE_WOW;
@@ -2114,7 +2137,6 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 			return ret;
 		}
 
-		ar->state = ATH6KL_STATE_ON;
 		break;
 
 	case ATH6KL_STATE_DEEPSLEEP:
@@ -2188,6 +2210,9 @@ static int __ath6kl_cfg80211_resume(struct wiphy *wiphy)
  */
 void ath6kl_check_wow_status(struct ath6kl *ar)
 {
+	if (ar->state == ATH6KL_STATE_SUSPENDING)
+		return;
+
 	if (ar->state == ATH6KL_STATE_WOW)
 		ath6kl_cfg80211_resume(ar);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c4d66e0..04dfdda 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -521,6 +521,8 @@ enum ath6kl_dev_state {
 enum ath6kl_state {
 	ATH6KL_STATE_OFF,
 	ATH6KL_STATE_ON,
+	ATH6KL_STATE_SUSPENDING,
+	ATH6KL_STATE_RESUMING,
 	ATH6KL_STATE_DEEPSLEEP,
 	ATH6KL_STATE_CUTPOWER,
 	ATH6KL_STATE_WOW,
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 4febee7..402087e 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -901,8 +901,12 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 
 	case ATH6KL_STATE_WOW:
 		break;
+
 	case ATH6KL_STATE_SCHED_SCAN:
 		break;
+
+	default:
+		break;
 	}
 
 	ath6kl_cfg80211_resume(ar);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a3dc694..1336204 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -284,6 +284,9 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	int status = 0;
 	struct ath6kl_cookie *cookie = NULL;
 
+	if (ar->state == ATH6KL_STATE_WOW)
+		return -EACCES;
+
 	spin_lock_bh(&ar->lock);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
@@ -359,6 +362,13 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		return 0;
 	}
 
+	if (WARN_ON_ONCE(ar->state != ATH6KL_STATE_ON)) {
+		set_bit(NETQ_STOPPED, &vif->flags);
+		netif_stop_queue(dev);
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
 	if (!test_bit(WMI_READY, &ar->flag))
 		goto fail_tx;
 
-- 
1.7.1


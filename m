Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1658 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab2IKGh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 02:37:28 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Fix reconnection issue after recovery
Date: Tue, 11 Sep 2012 12:07:00 +0530
Message-ID: <1347345420-16216-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120911_083737_808604_907D4166)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disallowing any wmi commands while re-initializing the
firmware results in connection failures after recovery
is done in open/WEP mode. To fix this, clear WMI_READY,
to make sure no wmi command is tried while fw is down.
Remove ATH6KL_STATE_RECOVERY state check in ath6kl_control_tx()
so that any configuration during fw init time will go through
using wmi commands.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   12 +++++++++---
 drivers/net/wireless/ath/ath6kl/init.c     |    6 +++++-
 drivers/net/wireless/ath/ath6kl/txrx.c     |    3 +--
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 229ebbd..d6e6c2d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -151,6 +151,10 @@ static bool __ath6kl_cfg80211_sscan_stop(struct ath6kl_vif *vif)
 		return false;
 
 	del_timer_sync(&vif->sched_scan_timer);
+
+	if (ar->state == ATH6KL_STATE_RECOVERY)
+		return true;
+
 	ath6kl_wmi_enable_sched_scan_cmd(ar->wmi, vif->fw_vif_idx, false);
 
 	return true;
@@ -3435,8 +3439,9 @@ void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
 		break;
 	}
 
-	if (test_bit(CONNECTED, &vif->flags) ||
-	    test_bit(CONNECT_PEND, &vif->flags))
+	if (vif->ar->state != ATH6KL_STATE_RECOVERY &&
+	    (test_bit(CONNECTED, &vif->flags) ||
+	    test_bit(CONNECT_PEND, &vif->flags)))
 		ath6kl_wmi_disconnect_cmd(vif->ar->wmi, vif->fw_vif_idx);
 
 	vif->sme_state = SME_DISCONNECTED;
@@ -3448,7 +3453,8 @@ void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
 	netif_carrier_off(vif->ndev);
 
 	/* disable scanning */
-	if (ath6kl_wmi_scanparams_cmd(vif->ar->wmi, vif->fw_vif_idx, 0xFFFF,
+	if (vif->ar->state != ATH6KL_STATE_RECOVERY &&
+	    ath6kl_wmi_scanparams_cmd(vif->ar->wmi, vif->fw_vif_idx, 0xFFFF,
 				      0, 0, 0, 0, 0, 0, 0, 0, 0) != 0)
 		ath6kl_warn("failed to disable scan during stop\n");
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6e270fa..424676e 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1697,10 +1697,14 @@ int ath6kl_init_hw_stop(struct ath6kl *ar)
 
 void ath6kl_init_hw_restart(struct ath6kl *ar)
 {
+	clear_bit(WMI_READY, &ar->flag);
+
 	ath6kl_cfg80211_stop_all(ar);
 
-	if (__ath6kl_init_hw_stop(ar))
+	if (__ath6kl_init_hw_stop(ar)) {
+		ath6kl_dbg(ATH6KL_DBG_RECOVERY, "Failed to stop during fw error recovery\n");
 		return;
+	}
 
 	if (__ath6kl_init_hw_start(ar)) {
 		ath6kl_dbg(ATH6KL_DBG_RECOVERY, "Failed to restart during fw error recovery\n");
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index e867193..efee590 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -288,8 +288,7 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	int status = 0;
 	struct ath6kl_cookie *cookie = NULL;
 
-	if (WARN_ON_ONCE(ar->state == ATH6KL_STATE_WOW) ||
-	    ar->state == ATH6KL_STATE_RECOVERY) {
+	if (WARN_ON_ONCE(ar->state == ATH6KL_STATE_WOW)) {
 		dev_kfree_skb(skb);
 		return -EACCES;
 	}
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53342 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1JYKie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:38:34 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 6/7] ath6kl: Perform WOW resume in RX path in case of SDIO IRQ wakeup
Date: Tue, 25 Oct 2011 16:07:26 +0530
Message-ID: <1319539047-8756-7-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_123836_689192_1A42AE20)
In-Reply-To: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   12 ++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |    2 ++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ddef445..241b13d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1602,6 +1602,12 @@ int ath6kl_pm_wow_resume(struct ath6kl *ar)
 	return 0;
 }
 
+void ath6kl_pm_check_wow_status(struct ath6kl *ar)
+{
+	if (ar->wow_state == ATH6KL_WOW_STATE_SUSPENDED)
+		ath6kl_pm_wow_resume(ar);
+}
+
 static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
 				 struct cfg80211_wowlan *wow)
 {
@@ -1636,6 +1642,12 @@ static int ar6k_cfg80211_resume(struct wiphy *wiphy)
 
 	return ath6kl_hif_resume(ar);
 }
+
+#else
+
+void ath6kl_pm_check_wow_status(struct ath6kl *ar)
+{
+}
 #endif
 
 static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index cefb233..4684933 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -651,5 +651,5 @@ void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no,
 			     u8 win_sz);
 void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
-
+void ath6kl_pm_check_wow_status(struct ath6kl *ar);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a9dff01..704ed50 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1081,6 +1081,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		return;
 	}
 
+	ath6kl_pm_check_wow_status(ar);
+
 	if (ept == ar->ctrl_ep) {
 		ath6kl_wmi_control_rx(ar->wmi, skb);
 		return;
-- 
1.7.0.4


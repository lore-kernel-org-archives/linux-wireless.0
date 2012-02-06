Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10284 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2BFN5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 08:57:37 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Check wow state before sending control and data pkt
Date: Mon, 6 Feb 2012 19:26:53 +0530
Message-ID: <1328536613-17521-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120206_145741_085979_2AF6D0D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

* TX operation (ctrl tx and data tx) has to be controlled based on
  WOW suspend state. i.e, control packets are allowed to send from
  the host until the suspend state goes ATH6KL_STATE_WOW and
  the data packets are allowed until WOW suspend operation starts.

* Similary, wow resume is NOT allowed if WOW suspend is in progress.

Both of the above scenarios are taken care in this patch.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.c     |    2 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    7 +++++++
 drivers/net/wireless/ath/ath6kl/txrx.c     |   11 ++++++++++-
 4 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d1922d8..11d9670 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1941,6 +1941,8 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	if (ret)
 		return ret;
 
+	ar->wow_state = ATH6KL_WOW_STATE_SUSPENDING;
+
 	/* Setup own IP addr for ARP agent. */
 	in_dev = __in_dev_get_rtnl(vif->ndev);
 	if (!in_dev)
@@ -2015,10 +2017,15 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 	struct ath6kl_vif *vif;
 	int ret;
 
+	if (ar->wow_state == ATH6KL_WOW_STATE_NONE)
+		return 0;
+
 	vif = ath6kl_vif_first(ar);
 	if (!vif)
 		return -EIO;
 
+	ar->wow_state = ATH6KL_WOW_STATE_NONE;
+
 	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
 						 ATH6KL_HOST_MODE_AWAKE);
 	return ret;
@@ -2041,9 +2048,13 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 		ret = ath6kl_wow_suspend(ar, wow);
 		if (ret) {
 			ath6kl_err("wow suspend failed: %d\n", ret);
+			ar->wow_state = ATH6KL_WOW_STATE_NONE;
 			return ret;
 		}
+
+		ar->wow_state = ATH6KL_WOW_STATE_SUSPENDED;
 		ar->state = ATH6KL_STATE_WOW;
+
 		break;
 
 	case ATH6KL_CFG_SUSPEND_DEEPSLEEP:
@@ -2188,6 +2199,9 @@ static int __ath6kl_cfg80211_resume(struct wiphy *wiphy)
  */
 void ath6kl_check_wow_status(struct ath6kl *ar)
 {
+	if (ar->wow_state == ATH6KL_WOW_STATE_SUSPENDING)
+		return;
+
 	if (ar->state == ATH6KL_STATE_WOW)
 		ath6kl_cfg80211_resume(ar);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 722ca59..b522135 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -154,6 +154,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 	else
 		ar->suspend_mode = 0;
 
+	ar->wow_state = ATH6KL_WOW_STATE_NONE;
+
 	if (uart_debug)
 		ar->conf_flags |= ATH6KL_CONF_UART_DEBUG;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c4d66e0..182ff01 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -527,11 +527,18 @@ enum ath6kl_state {
 	ATH6KL_STATE_SCHED_SCAN,
 };
 
+enum ath6kl_wow_state {
+	ATH6KL_WOW_STATE_NONE,
+	ATH6KL_WOW_STATE_SUSPENDING,
+	ATH6KL_WOW_STATE_SUSPENDED,
+};
+
 struct ath6kl {
 	struct device *dev;
 	struct wiphy *wiphy;
 
 	enum ath6kl_state state;
+	enum ath6kl_wow_state wow_state;
 	unsigned int testmode;
 
 	struct ath6kl_bmi bmi;
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a3dc694..53a2894 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -284,6 +284,10 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	int status = 0;
 	struct ath6kl_cookie *cookie = NULL;
 
+#ifdef CONFIG_PM
+	if (ar->wow_state == ATH6KL_WOW_STATE_SUSPENDED)
+		return -EACCES;
+#endif
 	spin_lock_bh(&ar->lock);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
@@ -352,7 +356,12 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
 		   "%s: skb=0x%p, data=0x%p, len=0x%x\n", __func__,
 		   skb, skb->data, skb->len);
-
+#ifdef CONFIG_PM
+	if (ar->wow_state != ATH6KL_WOW_STATE_NONE) {
+		dev_kfree_skb(skb);
+		return 0;
+	}
+#endif
 	/* If target is not associated */
 	if (!test_bit(CONNECTED, &vif->flags)) {
 		dev_kfree_skb(skb);
-- 
1.7.1


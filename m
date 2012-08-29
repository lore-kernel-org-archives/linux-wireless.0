Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46572 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2H2OLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 10:11:03 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 3/4] ath6kl: Add support to detect fw error through heart beat
Date: Wed, 29 Aug 2012 19:40:27 +0530
Message-ID: <1346249428-24741-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120829_161107_776946_88508B52)
In-Reply-To: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to detect fw error condition by sending
periodic message (heart beat challenge) to firmware. Upon reception
of the message, fw would send a response event to driver. When
there are no reponses from fw for about 5 cmd driver would
trigger the recovery logic assuming that fw has gone into an
error state.

Capable fw will advertise this capability through
ATH6KL_FW_CAPABILITY_HEART_BEAT_POLL bit. This feature
is disabled by default, can be enabled through a modparam
(heart_beat_poll). This modparam also confiures the polling
interval in msecs.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/ath/ath6kl/core.c     |    9 +++
 drivers/net/wireless/ath/ath6kl/core.h     |   16 +++++
 drivers/net/wireless/ath/ath6kl/init.c     |    6 --
 drivers/net/wireless/ath/ath6kl/recovery.c |   89 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |   14 ++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    2 +
 7 files changed, 129 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b4c549d..7c652ff 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2524,7 +2524,7 @@ static int __ath6kl_cfg80211_resume(struct wiphy *wiphy)
 	if (err)
 		return err;
 
-	ar->fw_recovery.enable = true;
+	ath6kl_recovery_resume(ar);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index adcaa96..fd5dd3a 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -33,6 +33,7 @@ static unsigned int wow_mode;
 static unsigned int uart_debug;
 static unsigned int ath6kl_p2p;
 static unsigned int testmode;
+static unsigned int heart_beat_poll;
 
 module_param(debug_mask, uint, 0644);
 module_param(suspend_mode, uint, 0644);
@@ -40,6 +41,9 @@ module_param(wow_mode, uint, 0644);
 module_param(uart_debug, uint, 0644);
 module_param(ath6kl_p2p, uint, 0644);
 module_param(testmode, uint, 0644);
+module_param(heart_beat_poll, uint, 0644);
+MODULE_PARM_DESC(heart_beat_poll, "Enable fw error detection periodic" \
+		 "polling. This also specifies the polling interval in msecs");
 
 void ath6kl_core_tx_complete(struct ath6kl *ar, struct sk_buff *skb)
 {
@@ -202,6 +206,11 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
 		   __func__, wdev->netdev->name, wdev->netdev, ar);
 
+	if (heart_beat_poll &&
+	    test_bit(ATH6KL_FW_CAPABILITY_HEART_BEAT_POLL,
+		     ar->fw_capabilities))
+		ar->fw_recovery.hb_poll = heart_beat_poll;
+
 	ath6kl_recovery_init(ar);
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c7dcdad..b2cbecf 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -130,6 +130,12 @@ enum ath6kl_fw_capability {
 	/* Firmware supports sched scan decoupled from host sleep */
 	ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2,
 
+	/*
+	 * Firmware capability for hang detection through heart beat
+	 * challenge messages.
+	 */
+	ATH6KL_FW_CAPABILITY_HEART_BEAT_POLL,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
@@ -649,8 +655,11 @@ enum ath6kl_state {
 };
 
 /* Fw error recovery */
+#define ATH6KL_HB_RESP_MISS_THRES	5
+
 enum ath6kl_fw_err {
 	ATH6KL_FW_ASSERT,
+	ATH6KL_FW_HB_RESP_FAILURE,
 };
 
 struct ath6kl {
@@ -800,6 +809,11 @@ struct ath6kl {
 		bool enable;
 		struct work_struct recovery_work;
 		unsigned long err_reason;
+		unsigned long hb_poll;
+		struct timer_list hb_timer;
+		u32 seq_num;
+		bool hb_pending;
+		u8 hb_misscnt;
 	} fw_recovery;
 
 #ifdef CONFIG_ATH6KL_DEBUG
@@ -940,7 +954,9 @@ void ath6kl_core_destroy(struct ath6kl *ar);
 /* Fw error recovery */
 void ath6kl_init_hw_restart(struct ath6kl *ar);
 void ath6kl_recovery_err_notify(struct ath6kl *ar, enum ath6kl_fw_err reason);
+void ath6kl_recovery_hb_event(struct ath6kl *ar, u32 cookie);
 void ath6kl_recovery_init(struct ath6kl *ar);
 void ath6kl_recovery_cleanup(struct ath6kl *ar);
 void ath6kl_recovery_suspend(struct ath6kl *ar);
+void ath6kl_recovery_resume(struct ath6kl *ar);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 301443c..6e270fa 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1697,9 +1697,6 @@ int ath6kl_init_hw_stop(struct ath6kl *ar)
 
 void ath6kl_init_hw_restart(struct ath6kl *ar)
 {
-
-	ar->state = ATH6KL_STATE_RECOVERY;
-
 	ath6kl_cfg80211_stop_all(ar);
 
 	if (__ath6kl_init_hw_stop(ar))
@@ -1709,9 +1706,6 @@ void ath6kl_init_hw_restart(struct ath6kl *ar)
 		ath6kl_dbg(ATH6KL_DBG_RECOVERY, "Failed to restart during fw error recovery\n");
 		return;
 	}
-
-	ar->state = ATH6KL_STATE_ON;
-	ar->fw_recovery.err_reason = 0;
 }
 
 /* FIXME: move this to cfg80211.c and rename to ath6kl_cfg80211_vif_stop() */
diff --git a/drivers/net/wireless/ath/ath6kl/recovery.c b/drivers/net/wireless/ath/ath6kl/recovery.c
index c225fc4..9161d84 100644
--- a/drivers/net/wireless/ath/ath6kl/recovery.c
+++ b/drivers/net/wireless/ath/ath6kl/recovery.c
@@ -23,7 +23,18 @@ static void ath6kl_recovery_work(struct work_struct *work)
 	struct ath6kl *ar = container_of(work, struct ath6kl,
 					 fw_recovery.recovery_work);
 
+	ar->state = ATH6KL_STATE_RECOVERY;
+
+	del_timer_sync(&ar->fw_recovery.hb_timer);
+
 	ath6kl_init_hw_restart(ar);
+
+	ar->state = ATH6KL_STATE_ON;
+	ar->fw_recovery.err_reason = 0;
+
+	if (ar->fw_recovery.enable)
+		mod_timer(&ar->fw_recovery.hb_timer, jiffies +
+			  msecs_to_jiffies(ar->fw_recovery.hb_poll));
 }
 
 void ath6kl_recovery_err_notify(struct ath6kl *ar, enum ath6kl_fw_err reason)
@@ -37,18 +48,72 @@ void ath6kl_recovery_err_notify(struct ath6kl *ar, enum ath6kl_fw_err reason)
 		queue_work(ar->ath6kl_wq, &ar->fw_recovery.recovery_work);
 }
 
+void ath6kl_recovery_hb_event(struct ath6kl *ar, u32 cookie)
+{
+	if (cookie == ar->fw_recovery.seq_num)
+		ar->fw_recovery.hb_pending = false;
+}
+
+static void ath6kl_recovery_hb_timer(unsigned long data)
+{
+	struct ath6kl *ar = (struct ath6kl *) data;
+	int err;
+
+	if (!ar->fw_recovery.enable)
+		return;
+
+	if (ar->fw_recovery.hb_pending)
+		ar->fw_recovery.hb_misscnt++;
+	else
+		ar->fw_recovery.hb_misscnt = 0;
+
+	if (ar->fw_recovery.hb_misscnt > ATH6KL_HB_RESP_MISS_THRES) {
+		ar->fw_recovery.hb_misscnt = 0;
+		ar->fw_recovery.seq_num = 0;
+		ar->fw_recovery.hb_pending = false;
+		ath6kl_recovery_err_notify(ar, ATH6KL_FW_HB_RESP_FAILURE);
+		return;
+	}
+
+	ar->fw_recovery.seq_num++;
+	ar->fw_recovery.hb_pending = true;
+
+	err = ath6kl_wmi_get_challenge_resp_cmd(ar->wmi,
+						ar->fw_recovery.seq_num, 0);
+	if (err)
+		ath6kl_warn("Failed to send hb challenge request, err:%d\n",
+			    err);
+
+	if ((ar->state == ATH6KL_STATE_RECOVERY) || !ar->fw_recovery.enable)
+		return;
+
+	mod_timer(&ar->fw_recovery.hb_timer, jiffies +
+		  msecs_to_jiffies(ar->fw_recovery.hb_poll));
+}
+
 void ath6kl_recovery_init(struct ath6kl *ar)
 {
 	struct ath6kl_fw_recovery *recovery = &ar->fw_recovery;
 
 	recovery->enable = true;
 	INIT_WORK(&recovery->recovery_work, ath6kl_recovery_work);
+	recovery->seq_num = 0;
+	recovery->hb_misscnt = 0;
+	ar->fw_recovery.hb_pending = false;
+	ar->fw_recovery.hb_timer.function = ath6kl_recovery_hb_timer;
+	ar->fw_recovery.hb_timer.data = (unsigned long) ar;
+	init_timer_deferrable(&ar->fw_recovery.hb_timer);
+
+	if (ar->fw_recovery.hb_poll)
+		mod_timer(&ar->fw_recovery.hb_timer, jiffies +
+			  msecs_to_jiffies(ar->fw_recovery.hb_poll));
 }
 
 void ath6kl_recovery_cleanup(struct ath6kl *ar)
 {
 	ar->fw_recovery.enable = false;
 
+	del_timer_sync(&ar->fw_recovery.hb_timer);
 	cancel_work_sync(&ar->fw_recovery.recovery_work);
 }
 
@@ -56,7 +121,27 @@ void ath6kl_recovery_suspend(struct ath6kl *ar)
 {
 	ath6kl_recovery_cleanup(ar);
 
+	if (!ar->fw_recovery.err_reason)
+		return;
+
 	/* Process pending fw error detection */
-	if (ar->fw_recovery.err_reason)
-		ath6kl_init_hw_restart(ar);
+	ar->fw_recovery.err_reason = 0;
+	WARN_ON(ar->state != ATH6KL_STATE_ON);
+	ar->state = ATH6KL_STATE_RECOVERY;
+	ath6kl_init_hw_restart(ar);
+	ar->state = ATH6KL_STATE_ON;
+}
+
+void ath6kl_recovery_resume(struct ath6kl *ar)
+{
+	ar->fw_recovery.enable = true;
+
+	if (!ar->fw_recovery.hb_poll)
+		return;
+
+	ar->fw_recovery.hb_pending = false;
+	ar->fw_recovery.seq_num = 0;
+	ar->fw_recovery.hb_misscnt = 0;
+	mod_timer(&ar->fw_recovery.hb_timer,
+		 jiffies + msecs_to_jiffies(ar->fw_recovery.hb_poll));
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index e95b035..2624ce8 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3756,6 +3756,19 @@ int ath6kl_wmi_set_inact_period(struct wmi *wmi, u8 if_idx, int inact_timeout)
 				   NO_SYNC_WMIFLAG);
 }
 
+static void ath6kl_wmi_hb_challenge_resp_event(struct wmi *wmi, u8 *datap,
+					       int len)
+{
+	struct wmix_hb_challenge_resp_cmd *cmd;
+
+	if (len < sizeof(struct wmix_hb_challenge_resp_cmd))
+		return;
+
+	cmd = (struct wmix_hb_challenge_resp_cmd *) datap;
+	ath6kl_recovery_hb_event(wmi->parent_dev,
+				 le32_to_cpu(cmd->cookie));
+}
+
 static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 {
 	struct wmix_cmd_hdr *cmd;
@@ -3780,6 +3793,7 @@ static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 	switch (id) {
 	case WMIX_HB_CHALLENGE_RESP_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "wmi event hb challenge resp\n");
+		ath6kl_wmi_hb_challenge_resp_event(wmi, datap, len);
 		break;
 	case WMIX_DBGLOG_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "wmi event dbglog len %d\n", len);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index a791b1b..3d239b3 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2714,6 +2714,8 @@ int ath6kl_wmi_set_inact_period(struct wmi *wmi, u8 if_idx, int inact_timeout);
 
 void ath6kl_wmi_sscan_timer(unsigned long ptr);
 
+int ath6kl_wmi_get_challenge_resp_cmd(struct wmi *wmi, u32 cookie, u32 source);
+
 struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx);
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
-- 
1.7.0.4


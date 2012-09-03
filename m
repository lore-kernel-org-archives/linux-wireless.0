Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20780 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2ICHUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 03:20:46 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 4/4] ath6kl: Make fw error recovery configurable
Date: Mon, 3 Sep 2012 12:49:37 +0530
Message-ID: <1346656777-15197-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120903_092049_592536_4A82639E)
In-Reply-To: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a modparam to configure recovery. Recovery
from firmware error is disabled by default to debug
the actual issue further. To recovery from error,
modprobe ath6kl_core recovery_enable=1.

Reported-by: Jin Navy <nhjin@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c     |   12 ++++++++++--
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/recovery.c |   12 ++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index fd5dd3a..4b46adb 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -33,6 +33,7 @@ static unsigned int wow_mode;
 static unsigned int uart_debug;
 static unsigned int ath6kl_p2p;
 static unsigned int testmode;
+static unsigned int recovery_enable;
 static unsigned int heart_beat_poll;
 
 module_param(debug_mask, uint, 0644);
@@ -41,9 +42,12 @@ module_param(wow_mode, uint, 0644);
 module_param(uart_debug, uint, 0644);
 module_param(ath6kl_p2p, uint, 0644);
 module_param(testmode, uint, 0644);
+module_param(recovery_enable, uint, 0644);
 module_param(heart_beat_poll, uint, 0644);
-MODULE_PARM_DESC(heart_beat_poll, "Enable fw error detection periodic" \
-		 "polling. This also specifies the polling interval in msecs");
+MODULE_PARM_DESC(recovery_enable, "Enable recovery from firmware error");
+MODULE_PARM_DESC(heart_beat_poll, "Enable fw error detection periodic"   \
+		 "polling. This also specifies the polling interval in"  \
+		 "msecs. Set reocvery_enable for this to be effective");
 
 void ath6kl_core_tx_complete(struct ath6kl *ar, struct sk_buff *skb)
 {
@@ -206,6 +210,10 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
 		   __func__, wdev->netdev->name, wdev->netdev, ar);
 
+	ar->fw_recovery.enable = !!recovery_enable;
+	if (!ar->fw_recovery.enable)
+		return ret;
+
 	if (heart_beat_poll &&
 	    test_bit(ATH6KL_FW_CAPABILITY_HEART_BEAT_POLL,
 		     ar->fw_capabilities))
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 40a7b19..3b2dfc1 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -815,6 +815,7 @@ struct ath6kl {
 		u32 seq_num;
 		bool hb_pending;
 		u8 hb_misscnt;
+		bool enable;
 	} fw_recovery;
 
 #ifdef CONFIG_ATH6KL_DEBUG
diff --git a/drivers/net/wireless/ath/ath6kl/recovery.c b/drivers/net/wireless/ath/ath6kl/recovery.c
index 98b6aa0..3a8d5e9 100644
--- a/drivers/net/wireless/ath/ath6kl/recovery.c
+++ b/drivers/net/wireless/ath/ath6kl/recovery.c
@@ -41,6 +41,9 @@ static void ath6kl_recovery_work(struct work_struct *work)
 
 void ath6kl_recovery_err_notify(struct ath6kl *ar, enum ath6kl_fw_err reason)
 {
+	if (!ar->fw_recovery.enable)
+		return;
+
 	ath6kl_dbg(ATH6KL_DBG_RECOVERY, "Fw error detected, reason:%d\n",
 		   reason);
 
@@ -112,6 +115,9 @@ void ath6kl_recovery_init(struct ath6kl *ar)
 
 void ath6kl_recovery_cleanup(struct ath6kl *ar)
 {
+	if (!ar->fw_recovery.enable)
+		return;
+
 	set_bit(RECOVERY_CLEANUP, &ar->flag);
 
 	del_timer_sync(&ar->fw_recovery.hb_timer);
@@ -120,6 +126,9 @@ void ath6kl_recovery_cleanup(struct ath6kl *ar)
 
 void ath6kl_recovery_suspend(struct ath6kl *ar)
 {
+	if (!ar->fw_recovery.enable)
+		return;
+
 	ath6kl_recovery_cleanup(ar);
 
 	if (!ar->fw_recovery.err_reason)
@@ -135,6 +144,9 @@ void ath6kl_recovery_suspend(struct ath6kl *ar)
 
 void ath6kl_recovery_resume(struct ath6kl *ar)
 {
+	if (!ar->fw_recovery.enable)
+		return;
+
 	clear_bit(RECOVERY_CLEANUP, &ar->flag);
 
 	if (!ar->fw_recovery.hb_poll)
-- 
1.7.0.4


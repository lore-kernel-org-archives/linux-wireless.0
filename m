Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22591 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab2H2OKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 10:10:52 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 2/4] ath6kl: Recover from fw crash
Date: Wed, 29 Aug 2012 19:40:26 +0530
Message-ID: <1346249428-24741-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120829_161055_560681_EB2755A6)
In-Reply-To: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-initialize the target when fw crash is reported.
This would make the device functional again after
target crash. During the target re-initialization
it is made sure that target is not bugged with data/cmd
request, ar->state ATH6KL_STATE_RECOVERY is used
for this purpose.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Makefile   |    1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   17 +++++++-
 drivers/net/wireless/ath/ath6kl/core.c     |    4 ++
 drivers/net/wireless/ath/ath6kl/core.h     |   18 ++++++++
 drivers/net/wireless/ath/ath6kl/debug.h    |    1 +
 drivers/net/wireless/ath/ath6kl/hif.c      |    1 +
 drivers/net/wireless/ath/ath6kl/init.c     |   19 ++++++++
 drivers/net/wireless/ath/ath6kl/recovery.c |   62 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/sdio.c     |    3 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |    3 +-
 10 files changed, 126 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/recovery.c

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 8cae888..cab0ec0 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -34,6 +34,7 @@ ath6kl_core-y += main.o
 ath6kl_core-y += txrx.o
 ath6kl_core-y += wmi.o
 ath6kl_core-y += core.o
+ath6kl_core-y += recovery.o
 ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 
 obj-$(CONFIG_ATH6KL_SDIO) += ath6kl_sdio.o
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fb20ff6..b4c549d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2510,14 +2510,23 @@ static int __ath6kl_cfg80211_suspend(struct wiphy *wiphy,
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
 
+	ath6kl_recovery_suspend(ar);
+
 	return ath6kl_hif_suspend(ar, wow);
 }
 
 static int __ath6kl_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
+	int err;
+
+	err = ath6kl_hif_resume(ar);
+	if (err)
+		return err;
 
-	return ath6kl_hif_resume(ar);
+	ar->fw_recovery.enable = true;
+
+	return 0;
 }
 
 /*
@@ -3441,6 +3450,10 @@ void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
 	clear_bit(CONNECTED, &vif->flags);
 	clear_bit(CONNECT_PEND, &vif->flags);
 
+	/* Stop netdev queues, needed during recovery */
+	netif_stop_queue(vif->ndev);
+	netif_carrier_off(vif->ndev);
+
 	/* disable scanning */
 	if (ath6kl_wmi_scanparams_cmd(vif->ar->wmi, vif->fw_vif_idx, 0xFFFF,
 				      0, 0, 0, 0, 0, 0, 0, 0, 0) != 0)
@@ -3454,7 +3467,7 @@ void ath6kl_cfg80211_stop_all(struct ath6kl *ar)
 	struct ath6kl_vif *vif;
 
 	vif = ath6kl_vif_first(ar);
-	if (!vif) {
+	if (!vif && ar->state != ATH6KL_STATE_RECOVERY) {
 		/* save the current power mode before enabling power save */
 		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 82c4dd2..adcaa96 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -202,6 +202,8 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
 		   __func__, wdev->netdev->name, wdev->netdev, ar);
 
+	ath6kl_recovery_init(ar);
+
 	return ret;
 
 err_rxbuf_cleanup:
@@ -291,6 +293,8 @@ void ath6kl_core_cleanup(struct ath6kl *ar)
 {
 	ath6kl_hif_power_off(ar);
 
+	ath6kl_recovery_cleanup(ar);
+
 	destroy_workqueue(ar->ath6kl_wq);
 
 	if (ar->htc_target)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 8b31b9a..c7dcdad 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -645,6 +645,12 @@ enum ath6kl_state {
 	ATH6KL_STATE_DEEPSLEEP,
 	ATH6KL_STATE_CUTPOWER,
 	ATH6KL_STATE_WOW,
+	ATH6KL_STATE_RECOVERY,
+};
+
+/* Fw error recovery */
+enum ath6kl_fw_err {
+	ATH6KL_FW_ASSERT,
 };
 
 struct ath6kl {
@@ -790,6 +796,12 @@ struct ath6kl {
 
 	bool wiphy_registered;
 
+	struct ath6kl_fw_recovery {
+		bool enable;
+		struct work_struct recovery_work;
+		unsigned long err_reason;
+	} fw_recovery;
+
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
 		struct sk_buff_head fwlog_queue;
@@ -925,4 +937,10 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type);
 void ath6kl_core_cleanup(struct ath6kl *ar);
 void ath6kl_core_destroy(struct ath6kl *ar);
 
+/* Fw error recovery */
+void ath6kl_init_hw_restart(struct ath6kl *ar);
+void ath6kl_recovery_err_notify(struct ath6kl *ar, enum ath6kl_fw_err reason);
+void ath6kl_recovery_init(struct ath6kl *ar);
+void ath6kl_recovery_cleanup(struct ath6kl *ar);
+void ath6kl_recovery_suspend(struct ath6kl *ar);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 49639d8..f97cd4e 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -44,6 +44,7 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_SUSPEND	= BIT(20),
 	ATH6KL_DBG_USB		= BIT(21),
 	ATH6KL_DBG_USB_BULK	= BIT(22),
+	ATH6KL_DBG_RECOVERY	= BIT(23),
 	ATH6KL_DBG_ANY	        = 0xffffffff  /* enable all logs */
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 68ed6c2..029914a 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -136,6 +136,7 @@ static int ath6kl_hif_proc_dbg_intr(struct ath6kl_device *dev)
 
 	ath6kl_hif_dump_fw_crash(dev->ar);
 	ath6kl_read_fwlogs(dev->ar);
+	ath6kl_recovery_err_notify(dev->ar, ATH6KL_FW_ASSERT);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index be27ebe..301443c 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1695,6 +1695,25 @@ int ath6kl_init_hw_stop(struct ath6kl *ar)
 	return 0;
 }
 
+void ath6kl_init_hw_restart(struct ath6kl *ar)
+{
+
+	ar->state = ATH6KL_STATE_RECOVERY;
+
+	ath6kl_cfg80211_stop_all(ar);
+
+	if (__ath6kl_init_hw_stop(ar))
+		return;
+
+	if (__ath6kl_init_hw_start(ar)) {
+		ath6kl_dbg(ATH6KL_DBG_RECOVERY, "Failed to restart during fw error recovery\n");
+		return;
+	}
+
+	ar->state = ATH6KL_STATE_ON;
+	ar->fw_recovery.err_reason = 0;
+}
+
 /* FIXME: move this to cfg80211.c and rename to ath6kl_cfg80211_vif_stop() */
 void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/recovery.c b/drivers/net/wireless/ath/ath6kl/recovery.c
new file mode 100644
index 0000000..c225fc4
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/recovery.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "core.h"
+#include "cfg80211.h"
+#include "debug.h"
+
+static void ath6kl_recovery_work(struct work_struct *work)
+{
+	struct ath6kl *ar = container_of(work, struct ath6kl,
+					 fw_recovery.recovery_work);
+
+	ath6kl_init_hw_restart(ar);
+}
+
+void ath6kl_recovery_err_notify(struct ath6kl *ar, enum ath6kl_fw_err reason)
+{
+	ath6kl_dbg(ATH6KL_DBG_RECOVERY, "Fw error detected, reason:%d\n",
+		   reason);
+
+	set_bit(reason, &ar->fw_recovery.err_reason);
+
+	if (ar->fw_recovery.enable && ar->state != ATH6KL_STATE_RECOVERY)
+		queue_work(ar->ath6kl_wq, &ar->fw_recovery.recovery_work);
+}
+
+void ath6kl_recovery_init(struct ath6kl *ar)
+{
+	struct ath6kl_fw_recovery *recovery = &ar->fw_recovery;
+
+	recovery->enable = true;
+	INIT_WORK(&recovery->recovery_work, ath6kl_recovery_work);
+}
+
+void ath6kl_recovery_cleanup(struct ath6kl *ar)
+{
+	ar->fw_recovery.enable = false;
+
+	cancel_work_sync(&ar->fw_recovery.recovery_work);
+}
+
+void ath6kl_recovery_suspend(struct ath6kl *ar)
+{
+	ath6kl_recovery_cleanup(ar);
+
+	/* Process pending fw error detection */
+	if (ar->fw_recovery.err_reason)
+		ath6kl_init_hw_restart(ar);
+}
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index cc17fe0..a72a4d0 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -931,6 +931,9 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 
 	case ATH6KL_STATE_RESUMING:
 		break;
+
+	case ATH6KL_STATE_RECOVERY:
+		break;
 	}
 
 	ath6kl_cfg80211_resume(ar);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 740a488..cbe1a9d 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -288,7 +288,8 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	int status = 0;
 	struct ath6kl_cookie *cookie = NULL;
 
-	if (WARN_ON_ONCE(ar->state == ATH6KL_STATE_WOW)) {
+	if (WARN_ON_ONCE(ar->state == ATH6KL_STATE_WOW) ||
+	    ar->state == ATH6KL_STATE_RECOVERY) {
 		dev_kfree_skb(skb);
 		return -EACCES;
 	}
-- 
1.7.0.4


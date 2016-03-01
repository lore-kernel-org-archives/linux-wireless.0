Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbcCARSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:47 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 13/15] wil6210: fix no_fw_recovery mode with change_virtual_intf
Date: Tue,  1 Mar 2016 19:18:16 +0200
Message-Id: <1456852698-26808-14-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181903_227450_236AA891)
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

When FW crashed with no_fw_recovery mode enabled, user space
could still call wil_cfg80211_change_iface quickly to change
interface type, and this would cause recovery to proceed and
FW crash logs may be lost.
Fix this problem by not resetting the FW in case no_fw_recovery
is enabled.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  | 2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c | 1 +
 drivers/net/wireless/ath/wil6210/main.c      | 5 +++++
 drivers/net/wireless/ath/wil6210/wil6210.h   | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index e867c76..33e5451 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -306,7 +306,7 @@ static int wil_cfg80211_change_iface(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "%s() type=%d\n", __func__, type);
 
-	if (netif_running(wil_to_ndev(wil))) {
+	if (netif_running(wil_to_ndev(wil)) && !wil_is_recovery_blocked(wil)) {
 		wil_dbg_misc(wil, "interface is up. resetting...\n");
 		mutex_lock(&wil->mutex);
 		__wil_down(wil);
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index ae90295..fe66b2b 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -391,6 +391,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	wil_dbg_irq(wil, "Thread ISR MISC 0x%08x\n", isr);
 
 	if (isr & ISR_MISC_FW_ERROR) {
+		wil->recovery_state = fw_recovery_pending;
 		wil_fw_core_dump(wil);
 		wil_notify_fw_error(wil);
 		isr &= ~ISR_MISC_FW_ERROR;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 05a4ae7..c2a0a66 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -305,6 +305,11 @@ void wil_set_recovery_state(struct wil6210_priv *wil, int state)
 	wake_up_interruptible(&wil->wq);
 }
 
+bool wil_is_recovery_blocked(struct wil6210_priv *wil)
+{
+	return no_fw_recovery && (wil->recovery_state == fw_recovery_pending);
+}
+
 static void wil_fw_error_worker(struct work_struct *work)
 {
 	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 68f60ea..a23dcee 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -716,6 +716,7 @@ void wil_priv_deinit(struct wil6210_priv *wil);
 int wil_reset(struct wil6210_priv *wil, bool no_fw);
 void wil_fw_error_recovery(struct wil6210_priv *wil);
 void wil_set_recovery_state(struct wil6210_priv *wil, int state);
+bool wil_is_recovery_blocked(struct wil6210_priv *wil);
 int wil_up(struct wil6210_priv *wil);
 int __wil_up(struct wil6210_priv *wil);
 int wil_down(struct wil6210_priv *wil);
-- 
1.8.5.2


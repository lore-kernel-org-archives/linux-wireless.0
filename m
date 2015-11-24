Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3306 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbKXHaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 02:30:21 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH] wil6210: prevent external wmi commands during suspend flow
Date: Tue, 24 Nov 2015 09:30:15 +0200
Message-Id: <1448350215-4202-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20151124_083025_414721_E3DFA47B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In __wmi_send we check if fw is ready at the beginning of the function.
While we wait for the completion of the previous command, system suspend
can be invoked and reset the HW, causing __wmi_send to read from HW
registers while it is not ready.
Taking the wmi_mutex in the reset flow when setting the FW ready bit
to zero will prevent the above race condition.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 4 +++-
 drivers/net/wireless/ath/wil6210/wmi.c  | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 48687f1..09b4dae 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -781,8 +781,10 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 	wil_bcast_fini(wil);
 
-	/* prevent NAPI from being scheduled */
+	/* prevent NAPI from being scheduled and prevent wmi commands */
+	mutex_lock(&wil->wmi_mutex);
 	bitmap_zero(wil->status, wil_status_last);
+	mutex_unlock(&wil->wmi_mutex);
 
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 6ed26ba..e3ea74c 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -228,6 +228,10 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	wil_dbg_wmi(wil, "Head 0x%08x -> 0x%08x\n", r->head, next_head);
 	/* wait till FW finish with previous command */
 	for (retry = 5; retry > 0; retry--) {
+		if (!test_bit(wil_status_fwready, wil->status)) {
+			wil_err(wil, "WMI: cannot send command while FW not ready\n");
+			return -EAGAIN;
+		}
 		r->tail = wil_r(wil, RGF_MBOX +
 				offsetof(struct wil6210_mbox_ctl, tx.tail));
 		if (next_head != r->tail)
-- 
1.8.5.2


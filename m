Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35612 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdJYNOW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 09:14:22 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 05/12] wil6210: fix length check in __wmi_send
Date: Wed, 25 Oct 2017 16:14:00 +0300
Message-Id: <1508937247-11890-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171025_151428_034150_F7449A9E)
In-Reply-To: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

The current length check:
sizeof(cmd) + len > r->entry_size
will allow very large values of len (> U16_MAX - sizeof(cmd))
and can cause a buffer overflow. Fix the check to cover this case.
In addition, ensure the mailbox entry_size is not too small,
since this can also bypass the above check.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 22 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.c       |  2 +-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 59def4f..5cf3417 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -358,6 +358,25 @@ static void wil_cache_mbox_regs(struct wil6210_priv *wil)
 	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
 }
 
+static bool wil_validate_mbox_regs(struct wil6210_priv *wil)
+{
+	size_t min_size = sizeof(struct wil6210_mbox_hdr) +
+		sizeof(struct wmi_cmd_hdr);
+
+	if (wil->mbox_ctl.rx.entry_size < min_size) {
+		wil_err(wil, "rx mbox entry too small (%d)\n",
+			wil->mbox_ctl.rx.entry_size);
+		return false;
+	}
+	if (wil->mbox_ctl.tx.entry_size < min_size) {
+		wil_err(wil, "tx mbox entry too small (%d)\n",
+			wil->mbox_ctl.tx.entry_size);
+		return false;
+	}
+
+	return true;
+}
+
 static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
@@ -393,7 +412,8 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	if (isr & ISR_MISC_FW_READY) {
 		wil_dbg_irq(wil, "IRQ: FW ready\n");
 		wil_cache_mbox_regs(wil);
-		set_bit(wil_status_mbox_ready, wil->status);
+		if (wil_validate_mbox_regs(wil))
+			set_bit(wil_status_mbox_ready, wil->status);
 		/**
 		 * Actual FW ready indicated by the
 		 * WMI_FW_READY_EVENTID
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8a780f2..dbdf71d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -448,7 +448,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	uint retry;
 	int rc = 0;
 
-	if (sizeof(cmd) + len > r->entry_size) {
+	if (len > r->entry_size - sizeof(cmd)) {
 		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
 			(int)(sizeof(cmd) + len), r->entry_size);
 		return -ERANGE;
-- 
1.9.1

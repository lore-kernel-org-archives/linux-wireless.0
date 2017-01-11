Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27109 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764089AbdAKQN6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 11:13:58 -0500
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 07/12] wil6210: protect against false interrupt during reset sequence
Date: Wed, 11 Jan 2017 18:12:43 +0200
Message-Id: <1484151168-894-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170111_171433_192173_6D672B42)
In-Reply-To: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

During reset sequence it is seen that device is generating an
interrupt eventhough interrupts are masked at device level.

Add workaround to disable the interrupts from host side during
reset and clear any pending interrupts before re-enabling
the interrupt.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6584960..8135283 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -918,7 +918,10 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	flush_workqueue(wil->wmi_wq);
 
 	wil_bl_crash_info(wil, false);
+	wil_disable_irq(wil);
 	rc = wil_target_reset(wil);
+	wil6210_clear_irq(wil);
+	wil_enable_irq(wil);
 	wil_rx_fini(wil);
 	if (rc) {
 		wil_bl_crash_info(wil, true);
-- 
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8145 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab3CMMNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:25 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/14] wil6210: fix FW error notification
Date: Wed, 13 Mar 2013 14:12:46 +0200
Message-ID: <1363176771-10082-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131347_137819_37153A63)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

user space get notified through kobject_uevent_env(), that might sleep and thus
should run in thread context.

Move user space notification to the thread handler, while mark FW is non-functional
right in the hard IRQ.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index dc97e7b..de9b971 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -257,10 +257,13 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	wil6210_mask_irq_misc(wil);
 
 	if (isr & ISR_MISC_FW_ERROR) {
-		wil_dbg_irq(wil, "IRQ: Firmware error\n");
+		wil_err(wil, "Firmware error detected\n");
 		clear_bit(wil_status_fwready, &wil->status);
-		wil_notify_fw_error(wil);
-		isr &= ~ISR_MISC_FW_ERROR;
+		/*
+		 * do not clear @isr here - we do 2-nd part in thread
+		 * there, user space get notified, and it should be done
+		 * in non-atomic context
+		 */
 	}
 
 	if (isr & ISR_MISC_FW_READY) {
@@ -289,6 +292,11 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 
 	wil_dbg_irq(wil, "Thread ISR MISC 0x%08x\n", isr);
 
+	if (isr & ISR_MISC_FW_ERROR) {
+		wil_notify_fw_error(wil);
+		isr &= ~ISR_MISC_FW_ERROR;
+	}
+
 	if (isr & ISR_MISC_MBOX_EVT) {
 		wil_dbg_irq(wil, "MBOX event\n");
 		wmi_recv_cmd(wil);
-- 
1.7.10.4


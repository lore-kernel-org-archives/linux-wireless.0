Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35734 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750715Ab3ADFZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 00:25:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/5] mwifiex: access interrupt status only while holding lock
Date: Thu,  3 Jan 2013 21:21:28 -0800
Message-Id: <1357276892-32759-2-git-send-email-bzhao@marvell.com> (sfid-20130104_062537_538754_2DE0855A)
In-Reply-To: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
References: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch fixes a bug for few instances where PCIe interrupt
status variable is accessed without holding spin lock.
This can result into missing interrupts.

Fix this by copying interrupt status to a local variable and
then using it for calling specific routine.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 13fbc4e..e4c2cfd 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1594,39 +1594,40 @@ exit:
 static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 {
 	int ret;
-	u32 pcie_ireg = 0;
+	u32 pcie_ireg;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->int_lock, flags);
 	/* Clear out unused interrupts */
-	adapter->int_status &= HOST_INTR_MASK;
+	pcie_ireg = adapter->int_status;
+	adapter->int_status = 0;
 	spin_unlock_irqrestore(&adapter->int_lock, flags);
 
-	while (adapter->int_status & HOST_INTR_MASK) {
-		if (adapter->int_status & HOST_INTR_DNLD_DONE) {
-			adapter->int_status &= ~HOST_INTR_DNLD_DONE;
+	while (pcie_ireg & HOST_INTR_MASK) {
+		if (pcie_ireg & HOST_INTR_DNLD_DONE) {
+			pcie_ireg &= ~HOST_INTR_DNLD_DONE;
 			if (adapter->data_sent) {
 				dev_dbg(adapter->dev, "info: DATA sent intr\n");
 				adapter->data_sent = false;
 			}
 		}
-		if (adapter->int_status & HOST_INTR_UPLD_RDY) {
-			adapter->int_status &= ~HOST_INTR_UPLD_RDY;
+		if (pcie_ireg & HOST_INTR_UPLD_RDY) {
+			pcie_ireg &= ~HOST_INTR_UPLD_RDY;
 			dev_dbg(adapter->dev, "info: Rx DATA\n");
 			ret = mwifiex_pcie_process_recv_data(adapter);
 			if (ret)
 				return ret;
 		}
-		if (adapter->int_status & HOST_INTR_EVENT_RDY) {
-			adapter->int_status &= ~HOST_INTR_EVENT_RDY;
+		if (pcie_ireg & HOST_INTR_EVENT_RDY) {
+			pcie_ireg &= ~HOST_INTR_EVENT_RDY;
 			dev_dbg(adapter->dev, "info: Rx EVENT\n");
 			ret = mwifiex_pcie_process_event_ready(adapter);
 			if (ret)
 				return ret;
 		}
 
-		if (adapter->int_status & HOST_INTR_CMD_DONE) {
-			adapter->int_status &= ~HOST_INTR_CMD_DONE;
+		if (pcie_ireg & HOST_INTR_CMD_DONE) {
+			pcie_ireg &= ~HOST_INTR_CMD_DONE;
 			if (adapter->cmd_sent) {
 				dev_dbg(adapter->dev,
 					"info: CMD sent Interrupt\n");
@@ -1654,8 +1655,6 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 						 "Write register failed\n");
 					return -1;
 				}
-				adapter->int_status |= pcie_ireg;
-				adapter->int_status &= HOST_INTR_MASK;
 			}
 
 		}
-- 
1.7.0.2


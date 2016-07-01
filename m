Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15815 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbcGANVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 09:21:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u61CvOeq013258
	for <linux-wireless@vger.kernel.org>; Fri, 1 Jul 2016 05:58:03 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 23sqaky7tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2016 05:58:03 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix interrupt processing corner case in MSI mode
Date: Fri, 1 Jul 2016 18:26:52 +0530
Message-ID: <1467377812-5716-1-git-send-email-akarwar@marvell.com> (sfid-20160701_152115_809757_3E4EEF4E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

As interrupt is read in interrupt handler as well as interrupt processing
thread, we observed a corner case issue for MSI in which interrupt gets
processed twice.

This patch moves interrupt reading code for MSI mode from
mwifiex_interrupt_status() to mwifiex_pcie_process_int() to avoid the
issue.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 50 ++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 7b17389..2c64b99 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2086,6 +2086,13 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter,
 	unsigned long flags;
 	struct pcie_service_card *card = adapter->card;
 
+	if (card->msi_enable) {
+		spin_lock_irqsave(&adapter->int_lock, flags);
+		adapter->int_status = 1;
+		spin_unlock_irqrestore(&adapter->int_lock, flags);
+		return;
+	}
+
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		return;
 
@@ -2187,15 +2194,44 @@ exit:
 static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
 {
 	int ret;
-	u32 pcie_ireg;
+	u32 pcie_ireg = 0;
 	unsigned long flags;
+	struct pcie_service_card *card = adapter->card;
 
 	spin_lock_irqsave(&adapter->int_lock, flags);
-	/* Clear out unused interrupts */
-	pcie_ireg = adapter->int_status;
+	if (!card->msi_enable) {
+		/* Clear out unused interrupts */
+		pcie_ireg = adapter->int_status;
+	}
 	adapter->int_status = 0;
 	spin_unlock_irqrestore(&adapter->int_lock, flags);
 
+	if (card->msi_enable) {
+		if (mwifiex_pcie_ok_to_access_hw(adapter)) {
+			if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS,
+					     &pcie_ireg)) {
+				mwifiex_dbg(adapter, ERROR,
+					    "Read register failed\n");
+				return -1;
+			}
+
+			if ((pcie_ireg != 0xFFFFFFFF) && (pcie_ireg)) {
+				if (mwifiex_write_reg(adapter,
+						      PCIE_HOST_INT_STATUS,
+						      ~pcie_ireg)) {
+					mwifiex_dbg(adapter, ERROR,
+						    "Write register failed\n");
+					return -1;
+				}
+				if (!adapter->pps_uapsd_mode &&
+				    adapter->ps_state == PS_STATE_SLEEP) {
+					adapter->ps_state = PS_STATE_AWAKE;
+					adapter->pm_wakeup_fw_try = false;
+					del_timer(&adapter->wakeup_timer);
+				}
+			}
+		}
+	}
 	while (pcie_ireg & HOST_INTR_MASK) {
 		if (pcie_ireg & HOST_INTR_DNLD_DONE) {
 			pcie_ireg &= ~HOST_INTR_DNLD_DONE;
@@ -2235,6 +2271,12 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
 				return ret;
 		}
 
+		if (card->msi_enable) {
+			spin_lock_irqsave(&adapter->int_lock, flags);
+			adapter->int_status = 0;
+			spin_unlock_irqrestore(&adapter->int_lock, flags);
+		}
+
 		if (mwifiex_pcie_ok_to_access_hw(adapter)) {
 			if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS,
 					     &pcie_ireg)) {
@@ -2258,7 +2300,7 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
 	mwifiex_dbg(adapter, INTR,
 		    "info: cmd_sent=%d data_sent=%d\n",
 		    adapter->cmd_sent, adapter->data_sent);
-	if (adapter->ps_state != PS_STATE_SLEEP)
+	if (!card->msi_enable && adapter->ps_state != PS_STATE_SLEEP)
 		mwifiex_pcie_enable_host_int(adapter);
 
 	return 0;
-- 
1.9.1


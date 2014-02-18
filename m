Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10483 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaBRXmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 18:42:06 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 3.14 3/3] mwifiex: fix cmd and Tx data timeout issue for PCIe cards
Date: Tue, 18 Feb 2014 15:41:56 -0800
Message-ID: <1392766916-10734-3-git-send-email-bzhao@marvell.com> (sfid-20140219_004215_800104_30E8238F)
In-Reply-To: <1392766916-10734-1-git-send-email-bzhao@marvell.com>
References: <1392766916-10734-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We are sending sleep confirm done interrupt in the middle of
sleep handshake. There is a corner case when Tx done interrupt
is received from firmware during sleep handshake due to which
host and firmware power states go out of sync causing cmd and
Tx data timeout problem.

Hence sleep confirm done interrupt is sent at the end of sleep
handshake to fix the problem.

Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 7936dfa..31d8a9d 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1535,6 +1535,14 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
 			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
 							   skb->len);
+			mwifiex_pcie_enable_host_int(adapter);
+			if (mwifiex_write_reg(adapter,
+					      PCIE_CPU_INT_EVENT,
+					      CPU_INTR_SLEEP_CFM_DONE)) {
+				dev_warn(adapter->dev,
+					 "Write register failed\n");
+				return -1;
+			}
 			while (reg->sleep_cookie && (count++ < 10) &&
 			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
@@ -1981,23 +1989,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		adapter->int_status |= pcie_ireg;
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
 
-		if (pcie_ireg & HOST_INTR_CMD_DONE) {
-			if ((adapter->ps_state == PS_STATE_SLEEP_CFM) ||
-			    (adapter->ps_state == PS_STATE_SLEEP)) {
-				mwifiex_pcie_enable_host_int(adapter);
-				if (mwifiex_write_reg(adapter,
-						      PCIE_CPU_INT_EVENT,
-						      CPU_INTR_SLEEP_CFM_DONE)
-						      ) {
-					dev_warn(adapter->dev,
-						 "Write register failed\n");
-					return;
-
-				}
-			}
-		} else if (!adapter->pps_uapsd_mode &&
-			   adapter->ps_state == PS_STATE_SLEEP &&
-			   mwifiex_pcie_ok_to_access_hw(adapter)) {
+		if (!adapter->pps_uapsd_mode &&
+		    adapter->ps_state == PS_STATE_SLEEP &&
+		    mwifiex_pcie_ok_to_access_hw(adapter)) {
 				/* Potentially for PCIe we could get other
 				 * interrupts like shared. Don't change power
 				 * state until cookie is set */
-- 
1.8.2.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47807 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752559AbcKROBG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 09:01:06 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v4 01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
Date: Fri, 18 Nov 2016 19:30:24 +0530
Message-ID: <1479477634-27841-1-git-send-email-akarwar@marvell.com> (sfid-20161118_150111_371471_0F3D4B1E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

We may get SLEEP event from firmware even if TXDone interrupt
for last Tx packet is still pending. In this case, we may
end up accessing PCIe memory for handling TXDone after power
save handshake is completed. This causes kernel crash with
external abort.

This patch will only allow downloading sleep confirm
when no tx done interrupt is pending in the hardware.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
---
v2: address format issues(Brain)
RESEND v2(Applicable for complete patch series):
    1) Fixed syntax issue "changelog not placed after the  Sign-offs"
       pointed by Brian.
    2) Dropped "[v2,03/12] mwifiex: don't do unbalanced free()'ing in
       cleanup_if()" patch in this series. It was already sent by Brian
       separately.
v4: Same as RESEND v2 and v3
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 5 +++--
 drivers/net/wireless/marvell/mwifiex/init.c   | 1 +
 drivers/net/wireless/marvell/mwifiex/main.h   | 1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c   | 5 +++++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 5347728..25a7475 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1118,13 +1118,14 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 void
 mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 {
-	if (!adapter->cmd_sent &&
+	if (!adapter->cmd_sent && !atomic_read(&adapter->tx_hw_pending) &&
 	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter))
 		mwifiex_dnld_sleep_confirm_cmd(adapter);
 	else
 		mwifiex_dbg(adapter, CMD,
-			    "cmd: Delay Sleep Confirm (%s%s%s)\n",
+			    "cmd: Delay Sleep Confirm (%s%s%s%s)\n",
 			    (adapter->cmd_sent) ? "D" : "",
+			    atomic_read(&adapter->tx_hw_pending) ? "T" : "",
 			    (adapter->curr_cmd) ? "C" : "",
 			    (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 82839d9..b36cb3f 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -270,6 +270,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->adhoc_11n_enabled = false;
 
 	mwifiex_wmm_init(adapter);
+	atomic_set(&adapter->tx_hw_pending, 0);
 
 	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm *)
 					adapter->sleep_cfm->data;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index ae5afe5..904a2ed 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -857,6 +857,7 @@ struct mwifiex_adapter {
 	atomic_t rx_pending;
 	atomic_t tx_pending;
 	atomic_t cmd_pending;
+	atomic_t tx_hw_pending;
 	struct workqueue_struct *workqueue;
 	struct work_struct main_work;
 	struct workqueue_struct *rx_workqueue;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 2ab1d17..cfb45ef 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -516,6 +516,7 @@ static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
 		}
 	}
 
+	atomic_set(&adapter->tx_hw_pending, 0);
 	return 0;
 }
 
@@ -715,6 +716,7 @@ static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
 		card->tx_buf_list[i] = NULL;
 	}
 
+	atomic_set(&adapter->tx_hw_pending, 0);
 	return;
 }
 
@@ -1152,6 +1154,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 							    -1);
 			else
 				mwifiex_write_data_complete(adapter, skb, 0, 0);
+			atomic_dec(&adapter->tx_hw_pending);
 		}
 
 		card->tx_buf_list[wrdoneidx] = NULL;
@@ -1244,6 +1247,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		wrindx = (card->txbd_wrptr & reg->tx_mask) >> reg->tx_start_ptr;
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 		card->tx_buf_list[wrindx] = skb;
+		atomic_inc(&adapter->tx_hw_pending);
 
 		if (reg->pfu_enabled) {
 			desc2 = card->txbd_ring[wrindx];
@@ -1321,6 +1325,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 done_unmap:
 	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 	card->tx_buf_list[wrindx] = NULL;
+	atomic_dec(&adapter->tx_hw_pending);
 	if (reg->pfu_enabled)
 		memset(desc2, 0, sizeof(*desc2));
 	else
-- 
1.9.1

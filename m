Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32796 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755566AbcKJL5j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:57:39 -0500
Received: by mail-pf0-f195.google.com with SMTP id 144so3985432pfv.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:57:39 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH RESEND v2 01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
Date: Thu, 10 Nov 2016 19:57:02 +0800
Message-Id: <1478779032-5165-1-git-send-email-huxinming820@marvell.com> (sfid-20161110_125750_211638_A62B25B1)
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
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: address format issues(Brain)
RESEND v2(Applicable for complete patch series):
    1) Fixed syntax issue "changelog not placed after the  Sign-offs"
       pointed by Brian.
    2) Dropped "[v2,03/12] mwifiex: don't do unbalanced free()'ing in
       cleanup_if()" patch in this series. It was already sent by Brian
       separately.
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
index 11abc49..b0c501d 100644
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
index ba1fa17..509c156 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -522,6 +522,7 @@ static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
 		}
 	}
 
+	atomic_set(&adapter->tx_hw_pending, 0);
 	return 0;
 }
 
@@ -721,6 +722,7 @@ static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
 		card->tx_buf_list[i] = NULL;
 	}
 
+	atomic_set(&adapter->tx_hw_pending, 0);
 	return;
 }
 
@@ -1158,6 +1160,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 							    -1);
 			else
 				mwifiex_write_data_complete(adapter, skb, 0, 0);
+			atomic_dec(&adapter->tx_hw_pending);
 		}
 
 		card->tx_buf_list[wrdoneidx] = NULL;
@@ -1250,6 +1253,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		wrindx = (card->txbd_wrptr & reg->tx_mask) >> reg->tx_start_ptr;
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 		card->tx_buf_list[wrindx] = skb;
+		atomic_inc(&adapter->tx_hw_pending);
 
 		if (reg->pfu_enabled) {
 			desc2 = card->txbd_ring[wrindx];
@@ -1327,6 +1331,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 done_unmap:
 	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 	card->tx_buf_list[wrindx] = NULL;
+	atomic_dec(&adapter->tx_hw_pending);
 	if (reg->pfu_enabled)
 		memset(desc2, 0, sizeof(*desc2));
 	else
-- 
1.8.1.4

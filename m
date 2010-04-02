Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab0DBUjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:39:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: fix DMA allocation warnings
Date: Fri,  2 Apr 2010 13:39:06 -0700
Message-Id: <1270240748-12865-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240748-12865-1-git-send-email-reinette.chatre@intel.com>
References: <1270240748-12865-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Below warning is triggered sometimes at module removal time when
CONFIG_DMA_API_DEBUG is enabled. This should be caused by we didn't
unmap pending commands (enqueued, but no complete notification
received) for the Tx command queue.

[ 1583.107469] ------------[ cut here ]------------
[ 1583.107539] WARNING: at lib/dma-debug.c:688
dma_debug_device_change+0x13c/0x180()
[ 1583.107617] Hardware name: ...
[ 1583.107664] pci 0000:04:00.0: DMA-API: device driver has pending DMA
allocations while released from device [count=1]
[ 1583.107713] Modules linked in: ...
[ 1583.111661] Pid: 16970, comm: modprobe Tainted: G        W
2.6.34-rc1-wl #33
[ 1583.111727] Call Trace:
[ 1583.111779]  [<c02a281c>] ? dma_debug_device_change+0x13c/0x180
[ 1583.111833]  [<c02a281c>] ? dma_debug_device_change+0x13c/0x180
[ 1583.111908]  [<c0138e11>] warn_slowpath_common+0x71/0xd0
[ 1583.111963]  [<c02a281c>] ? dma_debug_device_change+0x13c/0x180
[ 1583.112016]  [<c0138ebb>] warn_slowpath_fmt+0x2b/0x30
[ 1583.112086]  [<c02a281c>] dma_debug_device_change+0x13c/0x180
[ 1583.112142]  [<c03e6c33>] notifier_call_chain+0x53/0x90
[ 1583.112198]  [<c03e1ebe>] ? down_read+0x6e/0x90
[ 1583.112271]  [<c015b229>] __blocking_notifier_call_chain+0x49/0x70
[ 1583.112326]  [<c015b26f>] blocking_notifier_call_chain+0x1f/0x30
[ 1583.112380]  [<c031931c>] __device_release_driver+0x8c/0xa0
[ 1583.112451]  [<c03193bf>] driver_detach+0x8f/0xa0
[ 1583.112538]  [<c0318382>] bus_remove_driver+0x82/0x100
[ 1583.112595]  [<c0319ad9>] driver_unregister+0x49/0x80
[ 1583.112671]  [<c024feb2>] ? sysfs_remove_file+0x12/0x20
[ 1583.112727]  [<c02aa292>] pci_unregister_driver+0x32/0x80
[ 1583.112791]  [<fc13a3c1>] iwl_exit+0x12/0x19 [iwlagn]
[ 1583.112848]  [<c017940a>] sys_delete_module+0x15a/0x210
[ 1583.112870]  [<c015a5db>] ? up_read+0x1b/0x30
[ 1583.112893]  [<c029600c>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1583.112924]  [<c0295ffc>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 1583.112947]  [<c03e6a1f>] ? do_page_fault+0x1ff/0x3c0
[ 1583.112978]  [<c03e36f6>] ? restore_all_notrace+0x0/0x18
[ 1583.113002]  [<c016aa70>] ? trace_hardirqs_on_caller+0x20/0x190
[ 1583.113025]  [<c0102d58>] sysenter_do_call+0x12/0x38
[ 1583.113054] ---[ end trace fc23e059cc4c2ced ]---

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   48 ++++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 8c12311..6aa3090 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -193,10 +193,34 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 	struct iwl_queue *q = &txq->q;
 	struct device *dev = &priv->pci_dev->dev;
 	int i;
+	bool huge = false;
 
 	if (q->n_bd == 0)
 		return;
 
+	for (; q->read_ptr != q->write_ptr;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+		/* we have no way to tell if it is a huge cmd ATM */
+		i = get_cmd_index(q, q->read_ptr, 0);
+
+		if (txq->meta[i].flags & CMD_SIZE_HUGE) {
+			huge = true;
+			continue;
+		}
+
+		pci_unmap_single(priv->pci_dev,
+				 pci_unmap_addr(&txq->meta[i], mapping),
+				 pci_unmap_len(&txq->meta[i], len),
+				 PCI_DMA_BIDIRECTIONAL);
+	}
+	if (huge) {
+		i = q->n_window;
+		pci_unmap_single(priv->pci_dev,
+				 pci_unmap_addr(&txq->meta[i], mapping),
+				 pci_unmap_len(&txq->meta[i], len),
+				 PCI_DMA_BIDIRECTIONAL);
+	}
+
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i <= TFD_CMD_SLOTS; i++)
 		kfree(txq->cmd[i]);
@@ -1049,6 +1073,14 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
+	/* If this is a huge cmd, mark the huge flag also on the meta.flags
+	 * of the _original_ cmd. This is used for DMA mapping clean up.
+	 */
+	if (cmd->flags & CMD_SIZE_HUGE) {
+		idx = get_cmd_index(q, q->write_ptr, 0);
+		txq->meta[idx].flags = CMD_SIZE_HUGE;
+	}
+
 	idx = get_cmd_index(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
@@ -1226,6 +1258,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	bool huge = !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
+	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
@@ -1239,9 +1272,17 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		return;
 	}
 
-	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
-	meta = &priv->txq[IWL_CMD_QUEUE_NUM].meta[cmd_index];
+	/* If this is a huge cmd, clear the huge flag on the meta.flags
+	 * of the _original_ cmd. So that iwl_cmd_queue_free won't unmap
+	 * the DMA buffer for the scan (huge) command.
+	 */
+	if (huge) {
+		cmd_index = get_cmd_index(&txq->q, index, 0);
+		txq->meta[cmd_index].flags = 0;
+	}
+	cmd_index = get_cmd_index(&txq->q, index, huge);
+	cmd = txq->cmd[cmd_index];
+	meta = &txq->meta[cmd_index];
 
 	pci_unmap_single(priv->pci_dev,
 			 pci_unmap_addr(meta, mapping),
@@ -1263,6 +1304,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 			       get_cmd_string(cmd->hdr.cmd));
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
+	meta->flags = 0;
 }
 EXPORT_SYMBOL(iwl_tx_cmd_complete);
 
-- 
1.6.3.3


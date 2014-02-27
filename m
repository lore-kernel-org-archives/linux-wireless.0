Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17603 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaB0OV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:26 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 02/16] wil6210: [DEBUG] allow to query Rx and all Tx VRING descriptors
Date: Thu, 27 Feb 2014 16:20:41 +0200
Message-ID: <1393510855-17566-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152139_021920_7C9ADDAC)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Expand debug capabilities to query all Tx/Rx descriptors. Usefull to analyse
various hardware/software stall situations. Printed is whole descriptor content
and the frame itself.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 40 ++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 1caa319..74bb427 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -26,6 +26,8 @@
 /* Nasty hack. Better have per device instances */
 static u32 mem_addr;
 static u32 dbg_txdesc_index;
+static u32 dbg_vring_index; /* 25 for Rx, 0..24 for Tx */
+#define WIL_DBG_VRING_INDEX_RX (WIL6210_MAX_TX_RINGS + 1)
 
 static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 			    const char *name, struct vring *vring)
@@ -390,25 +392,39 @@ static const struct file_operations fops_reset = {
 	.write = wil_write_file_reset,
 	.open  = simple_open,
 };
-/*---------Tx descriptor------------*/
 
+/*---------Tx/Rx descriptor------------*/
 static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	struct vring *vring = &(wil->vring_tx[0]);
+	struct vring *vring;
+	if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+		vring = &(wil->vring_tx[dbg_vring_index]);
+	else
+		vring = &wil->vring_rx;
 
 	if (!vring->va) {
-		seq_printf(s, "No Tx VRING\n");
+		if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+			seq_printf(s, "No Tx[%2d] VRING\n", dbg_vring_index);
+		else
+			seq_puts(s, "No Rx VRING\n");
 		return 0;
 	}
 
 	if (dbg_txdesc_index < vring->size) {
+		/* use struct vring_tx_desc for Rx as well,
+		 * only field used, .dma.length, is the same
+		 */
 		volatile struct vring_tx_desc *d =
 				&(vring->va[dbg_txdesc_index].tx);
 		volatile u32 *u = (volatile u32 *)d;
 		struct sk_buff *skb = vring->ctx[dbg_txdesc_index].skb;
 
-		seq_printf(s, "Tx[%3d] = {\n", dbg_txdesc_index);
+		if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+			seq_printf(s, "Tx[%2d][%3d] = {\n", dbg_vring_index,
+				   dbg_txdesc_index);
+		else
+			seq_printf(s, "Rx[%3d] = {\n", dbg_txdesc_index);
 		seq_printf(s, "  MAC = 0x%08x 0x%08x 0x%08x 0x%08x\n",
 			   u[0], u[1], u[2], u[3]);
 		seq_printf(s, "  DMA = 0x%08x 0x%08x 0x%08x 0x%08x\n",
@@ -439,8 +455,13 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 		}
 		seq_printf(s, "}\n");
 	} else {
-		seq_printf(s, "TxDesc index (%d) >= size (%d)\n",
-			   dbg_txdesc_index, vring->size);
+		if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+			seq_printf(s, "[%2d] TxDesc index (%d) >= size (%d)\n",
+				   dbg_vring_index, dbg_txdesc_index,
+				   vring->size);
+		else
+			seq_printf(s, "RxDesc index (%d) >= size (%d)\n",
+				   dbg_txdesc_index, vring->size);
 	}
 
 	return 0;
@@ -581,9 +602,12 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 
 	debugfs_create_file("mbox", S_IRUGO, dbg, wil, &fops_mbox);
 	debugfs_create_file("vrings", S_IRUGO, dbg, wil, &fops_vring);
-	debugfs_create_file("txdesc", S_IRUGO, dbg, wil, &fops_txdesc);
-	debugfs_create_u32("txdesc_index", S_IRUGO | S_IWUSR, dbg,
+	debugfs_create_file("desc", S_IRUGO, dbg, wil, &fops_txdesc);
+	debugfs_create_u32("desc_index", S_IRUGO | S_IWUSR, dbg,
 			   &dbg_txdesc_index);
+	debugfs_create_u32("vring_index", S_IRUGO | S_IWUSR, dbg,
+			   &dbg_vring_index);
+
 	debugfs_create_file("bf", S_IRUGO, dbg, wil, &fops_bf);
 	debugfs_create_file("ssid", S_IRUGO | S_IWUSR, dbg, wil, &fops_ssid);
 	debugfs_create_u32("secure_pcp", S_IRUGO | S_IWUSR, dbg,
-- 
1.8.3.2


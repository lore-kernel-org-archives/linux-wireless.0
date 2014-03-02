Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45839 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaCBJVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2014 04:21:23 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 1/2] wil6210: fix buffer overflow in wil_txdesc_debugfs_show()
Date: Sun, 2 Mar 2014 11:20:50 +0200
Message-ID: <1393752051-7611-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140302_102504_419664_BD16E219)
In-Reply-To: <1393752051-7611-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393752051-7611-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrong index comparison logic, found by smatch:

drivers/net/wireless/ath/wil6210/debugfs.c:402 wil_txdesc_debugfs_show() warn: buffer overflow 'wil->vring_tx' 24 <= 24

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 729e774..1d09a4b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -26,8 +26,7 @@
 /* Nasty hack. Better have per device instances */
 static u32 mem_addr;
 static u32 dbg_txdesc_index;
-static u32 dbg_vring_index; /* 25 for Rx, 0..24 for Tx */
-#define WIL_DBG_VRING_INDEX_RX (WIL6210_MAX_TX_RINGS + 1)
+static u32 dbg_vring_index; /* 24+ for Rx, 0..23 for Tx */
 
 static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 			    const char *name, struct vring *vring,
@@ -404,13 +403,14 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct vring *vring;
-	if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+	bool tx = (dbg_vring_index < WIL6210_MAX_TX_RINGS);
+	if (tx)
 		vring = &(wil->vring_tx[dbg_vring_index]);
 	else
 		vring = &wil->vring_rx;
 
 	if (!vring->va) {
-		if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+		if (tx)
 			seq_printf(s, "No Tx[%2d] VRING\n", dbg_vring_index);
 		else
 			seq_puts(s, "No Rx VRING\n");
@@ -426,7 +426,7 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 		volatile u32 *u = (volatile u32 *)d;
 		struct sk_buff *skb = vring->ctx[dbg_txdesc_index].skb;
 
-		if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+		if (tx)
 			seq_printf(s, "Tx[%2d][%3d] = {\n", dbg_vring_index,
 				   dbg_txdesc_index);
 		else
@@ -461,7 +461,7 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 		}
 		seq_printf(s, "}\n");
 	} else {
-		if (dbg_vring_index <= WIL6210_MAX_TX_RINGS)
+		if (tx)
 			seq_printf(s, "[%2d] TxDesc index (%d) >= size (%d)\n",
 				   dbg_vring_index, dbg_txdesc_index,
 				   vring->size);
-- 
1.8.3.2


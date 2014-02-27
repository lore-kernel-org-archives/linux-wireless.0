Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47557 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaB0OV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:26 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 03/16] wil6210: [DEBUG] Improve Vring printing
Date: Thu, 27 Feb 2014 16:20:42 +0200
Message-ID: <1393510855-17566-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152136_312750_5DD3974B)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print '_' for the 'idle' descriptors - this makes vring representation more visible.
Also, for the Tx side, differentiate descriptors having associated skb's - print ones
with skb as 'H' and without as 'h'. Good to represent scattered frames.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 74bb427..6fdab1a 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -30,7 +30,8 @@ static u32 dbg_vring_index; /* 25 for Rx, 0..24 for Tx */
 #define WIL_DBG_VRING_INDEX_RX (WIL6210_MAX_TX_RINGS + 1)
 
 static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
-			    const char *name, struct vring *vring)
+			    const char *name, struct vring *vring,
+			    char _s, char _h)
 {
 	void __iomem *x = wmi_addr(wil, vring->hwtail);
 
@@ -52,8 +53,8 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 			volatile struct vring_tx_desc *d = &vring->va[i].tx;
 			if ((i % 64) == 0 && (i != 0))
 				seq_printf(s, "\n");
-			seq_printf(s, "%s", (d->dma.status & BIT(0)) ?
-					"S" : (vring->ctx[i].skb ? "H" : "h"));
+			seq_printf(s, "%c", (d->dma.status & BIT(0)) ?
+					_s : (vring->ctx[i].skb ? _h : 'h'));
 		}
 		seq_printf(s, "\n");
 	}
@@ -65,14 +66,14 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 	uint i;
 	struct wil6210_priv *wil = s->private;
 
-	wil_print_vring(s, wil, "rx", &wil->vring_rx);
+	wil_print_vring(s, wil, "rx", &wil->vring_rx, 'S', '_');
 
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
 		struct vring *vring = &(wil->vring_tx[i]);
 		if (vring->va) {
 			char name[10];
 			snprintf(name, sizeof(name), "tx_%2d", i);
-			wil_print_vring(s, wil, name, vring);
+			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
 	}
 
-- 
1.8.3.2


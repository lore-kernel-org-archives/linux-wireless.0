Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:41358 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbHPGzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 02:55:54 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 4/7] brcmfmac: add debugfs entry for msgbuf statistics
Date: Sun, 16 Aug 2015 08:55:36 +0200
Message-ID: <1439708139-7527-5-git-send-email-arend@broadcom.com> (sfid-20150816_085613_689649_91FF9CFC)
In-Reply-To: <1439708139-7527-1-git-send-email-arend@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Expose ring buffer read/write pointers and other useful statistics
through debugfs.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 56 ++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 363a31e..d0e1ce5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1360,6 +1360,60 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	}
 }
 
+#ifdef DEBUG
+static int brcmf_msgbuf_stats_read(struct seq_file *seq, void *data)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
+	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+	struct brcmf_commonring *commonring;
+	u16 i;
+	struct brcmf_flowring_ring *ring;
+	struct brcmf_flowring_hash *hash;
+
+	commonring = msgbuf->commonrings[BRCMF_H2D_MSGRING_CONTROL_SUBMIT];
+	seq_printf(seq, "h2d_ctl_submit: rp %4u, wp %4u, depth %4u\n",
+		   commonring->r_ptr, commonring->w_ptr, commonring->depth);
+	commonring = msgbuf->commonrings[BRCMF_H2D_MSGRING_RXPOST_SUBMIT];
+	seq_printf(seq, "h2d_rx_submit:  rp %4u, wp %4u, depth %4u\n",
+		   commonring->r_ptr, commonring->w_ptr, commonring->depth);
+	commonring = msgbuf->commonrings[BRCMF_D2H_MSGRING_CONTROL_COMPLETE];
+	seq_printf(seq, "d2h_ctl_cmplt:  rp %4u, wp %4u, depth %4u\n",
+		   commonring->r_ptr, commonring->w_ptr, commonring->depth);
+	commonring = msgbuf->commonrings[BRCMF_D2H_MSGRING_TX_COMPLETE];
+	seq_printf(seq, "d2h_tx_cmplt:   rp %4u, wp %4u, depth %4u\n",
+		   commonring->r_ptr, commonring->w_ptr, commonring->depth);
+	commonring = msgbuf->commonrings[BRCMF_D2H_MSGRING_RX_COMPLETE];
+	seq_printf(seq, "d2h_rx_cmplt:   rp %4u, wp %4u, depth %4u\n",
+		   commonring->r_ptr, commonring->w_ptr, commonring->depth);
+
+	seq_printf(seq, "\nh2d_flowrings: depth %u\n",
+		   BRCMF_H2D_TXFLOWRING_MAX_ITEM);
+	seq_puts(seq, "Active flowrings:\n");
+	hash = msgbuf->flow->hash;
+	for (i = 0; i < msgbuf->flow->nrofrings; i++) {
+		if (!msgbuf->flow->rings[i])
+			continue;
+		ring = msgbuf->flow->rings[i];
+		if (ring->status != RING_OPEN)
+			continue;
+		commonring = msgbuf->flowrings[i];
+		hash = &msgbuf->flow->hash[ring->hash_id];
+		seq_printf(seq, "id %3u: rp %4u, wp %4u, qlen %4u, blocked %u\n"
+				"        ifidx %u, fifo %u, da %pM\n",
+				i, commonring->r_ptr, commonring->w_ptr,
+				skb_queue_len(&ring->skblist), ring->blocked,
+				hash->ifidx, hash->fifo, hash->mac);
+	}
+
+	return 0;
+}
+#else
+static int brcmf_msgbuf_stats_read(struct seq_file *seq, void *data)
+{
+	return 0;
+}
+#endif
 
 int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 {
@@ -1467,6 +1521,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	spin_lock_init(&msgbuf->flowring_work_lock);
 	INIT_LIST_HEAD(&msgbuf->work_queue);
 
+	brcmf_debugfs_add_entry(drvr, "msgbuf_stats", brcmf_msgbuf_stats_read);
+
 	return 0;
 
 fail:
-- 
1.9.1


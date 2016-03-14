Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33691 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbcCNXVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2016 19:21:33 -0400
Received: by mail-qg0-f45.google.com with SMTP id t4so369963qge.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2016 16:21:32 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: akarwar@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mwifiex: bridged packets cause wmm_tx_pending counter to go negative
Date: Mon, 14 Mar 2016 19:21:23 -0400
Message-Id: <1457997683-14553-1-git-send-email-mfaltesek@google.com> (sfid-20160315_002137_891213_7E127701)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a packet is queued from the bridge, wmm_tx_pending is not
incremented, but when the packet is dequeued the counter is decremented.

---
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index 52f7981..193a809 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -102,6 +102,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	int hdr_chop;
 	struct ethhdr *p_ethhdr;
 	struct mwifiex_sta_node *src_node;
+	int index;
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
 	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd->rx_pkt_offset);
@@ -208,6 +209,9 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	}
 
 	__net_timestamp(skb);
+
+	index = mwifiex_1d_to_wmm_queue[skb->priority];
+	atomic_inc(&priv->wmm_tx_pending[index]);
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
 	atomic_inc(&adapter->tx_pending);
 	atomic_inc(&adapter->pending_bridged_pkts);
-- 
2.7.0.rc3.207.g0ac5344


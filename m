Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:34628 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbcDTET7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 00:19:59 -0400
Received: by mail-qg0-f41.google.com with SMTP id c6so22085150qga.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 21:19:59 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: linux-wireless@vger.kernel.org
Cc: akarwar@marvell.com
Subject: [PATCH v2] mwifiex: bridged packets cause wmm_tx_pending counter to go negative
Date: Wed, 20 Apr 2016 00:19:35 -0400
Message-Id: <1461125975-12002-1-git-send-email-mfaltesek@google.com> (sfid-20160420_062004_211348_1BA77E3A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a packet is queued from the bridge, wmm_tx_pending is not
incremented, but when the packet is dequeued the counter is decremented.

Signed-off-by: Marty Faltesek <mfaltesek@google.com>
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
2.8.0.rc3.226.g39d4020


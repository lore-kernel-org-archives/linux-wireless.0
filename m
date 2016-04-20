Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:33930 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbcDTEWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 00:22:13 -0400
Received: by mail-qg0-f48.google.com with SMTP id c6so22102324qga.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 21:22:13 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: linux-wireless@vger.kernel.org
Cc: akarwar@marvell.com
Subject: [PATCH v2] mwifiex: transmit packet stats incorrect.
Date: Wed, 20 Apr 2016 00:22:01 -0400
Message-Id: <1461126121-12266-1-git-send-email-mfaltesek@google.com> (sfid-20160420_062216_998930_F77DAAF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx_packets counter is incremented for aggregated packets, when it had
already been incremented for the aggregated packet's constituent
parts. Removing the extra count.

Signed-off-by: Marty Faltesek <mfaltesek@google.com>
---
 drivers/net/wireless/marvell/mwifiex/txrx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/txrx.c b/drivers/net/wireless/marvell/mwifiex/txrx.c
index bf6182b..abdd0cf 100644
--- a/drivers/net/wireless/marvell/mwifiex/txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/txrx.c
@@ -297,6 +297,13 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		goto done;
 
 	mwifiex_set_trans_start(priv->netdev);
+
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT)
+		atomic_dec_return(&adapter->pending_bridged_pkts);
+
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
+		goto done;
+
 	if (!status) {
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += tx_info->pkt_len;
@@ -306,12 +313,6 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		priv->stats.tx_errors++;
 	}
 
-	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT)
-		atomic_dec_return(&adapter->pending_bridged_pkts);
-
-	if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
-		goto done;
-
 	if (aggr)
 		/* For skb_aggr, do not wake up tx queue */
 		goto done;
-- 
2.8.0.rc3.226.g39d4020


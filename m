Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:38778 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbeEQXQl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 19:16:41 -0400
Received: by mail-lf0-f67.google.com with SMTP id z142-v6so11178021lff.5
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2018 16:16:41 -0700 (PDT)
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: transmit queued frames after waking queues
Date: Fri, 18 May 2018 01:15:12 +0200
Message-Id: <20180517231512.13085-1-niklas.cassel@linaro.org> (sfid-20180518_011700_365195_5191E860)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following problem was observed when running iperf:

[  3]  0.0- 1.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3]  1.0- 2.0 sec  3.12 MBytes  26.2 Mbits/sec
[  3]  2.0- 3.0 sec  3.25 MBytes  27.3 Mbits/sec
[  3]  3.0- 4.0 sec   655 KBytes  5.36 Mbits/sec
[  3]  4.0- 5.0 sec  0.00 Bytes  0.00 bits/sec
[  3]  5.0- 6.0 sec  0.00 Bytes  0.00 bits/sec
[  3]  6.0- 7.0 sec  0.00 Bytes  0.00 bits/sec
[  3]  7.0- 8.0 sec  0.00 Bytes  0.00 bits/sec
[  3]  8.0- 9.0 sec  0.00 Bytes  0.00 bits/sec
[  3]  9.0-10.0 sec  0.00 Bytes  0.00 bits/sec
[  3]  0.0-10.3 sec  9.01 MBytes  7.32 Mbits/sec

There are frames in the ieee80211_txq and there are frames that have
been removed from from this queue, but haven't yet been sent on the wire
(num_pending_tx).

When num_pending_tx reaches max_num_pending_tx, we will stop the queues
by calling ieee80211_stop_queues().

As frames that have previously been sent for transmission
(num_pending_tx) are completed, we will decrease num_pending_tx and wake
the queues by calling ieee80211_wake_queue(). ieee80211_wake_queue()
does not call wake_tx_queue, so we might still have frames in the
queue at this point.

While the queues were stopped, the socket buffer might have filled up,
and in order for user space to write more, we need to free the frames
in the queue, since they are accounted to the socket. In order to free
them, we first need to transmit them.

In order to avoid trying to flush the queue every time we free a frame,
only do this when there are 3 or less frames pending, and while we
actually have frames in the queue. This logic was copied from
mt76_txq_schedule (mt76), one of few other drivers that are actually
using wake_tx_queue.

Suggested-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index cda164f6e9f6..1d3b2d2c3fee 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -95,6 +95,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
+	if (htt->num_pending_tx <= 3 && !list_empty(&ar->txqs))
+		ath10k_mac_tx_push_pending(ar);
+
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	ath10k_report_offchan_tx(htt->ar, msdu);
-- 
2.17.0

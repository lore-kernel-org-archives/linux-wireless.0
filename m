Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45209 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934575AbeEWWP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 18:15:27 -0400
Received: by mail-wr0-f195.google.com with SMTP id w3-v6so21486290wrl.12
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2018 15:15:27 -0700 (PDT)
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] ath10k: transmit queued frames after processing rx packets
Date: Thu, 24 May 2018 00:15:08 +0200
Message-Id: <20180523221508.26391-1-niklas.cassel@linaro.org> (sfid-20180524_001609_053743_AFCE769E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running iperf on ath10k SDIO, TX can stop working:

iperf -c 192.168.1.1 -i 1 -t 20 -w 10K
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

This problem cannot be reproduced on low-latency devices, e.g. pci,
since they call ath10k_mac_tx_push_pending() from
ath10k_htt_txrx_compl_task(). ath10k_htt_txrx_compl_task() is not called
on high-latency devices.
Fix the problem by calling ath10k_mac_tx_push_pending(), after
processing rx packets, just like for low-latency devices, also in the
SDIO case. Since we are calling ath10k_mac_tx_push_pending() directly,
we also need to export it.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
---
Changes since V2:
Moved ath10k_mac_tx_push_pending() call to ath10k_sdio_irq_handler().

 drivers/net/wireless/ath/ath10k/mac.c  | 1 +
 drivers/net/wireless/ath/ath10k/sdio.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 487a7a7380fd..bfcd9705ed54 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4038,6 +4038,7 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 	rcu_read_unlock();
 	spin_unlock_bh(&ar->txqs_lock);
 }
+EXPORT_SYMBOL(ath10k_mac_tx_push_pending);
 
 /************/
 /* Scanning */
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index d612ce8c9cff..2856c75f9011 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -30,6 +30,7 @@
 #include "debug.h"
 #include "hif.h"
 #include "htc.h"
+#include "mac.h"
 #include "targaddrs.h"
 #include "trace.h"
 #include "sdio.h"
@@ -1342,6 +1343,8 @@ static void ath10k_sdio_irq_handler(struct sdio_func *func)
 			break;
 	} while (time_before(jiffies, timeout) && !done);
 
+	ath10k_mac_tx_push_pending(ar);
+
 	sdio_claim_host(ar_sdio->func);
 
 	if (ret && ret != -ECANCELED)
-- 
2.17.0

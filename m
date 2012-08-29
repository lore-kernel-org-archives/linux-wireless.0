Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2025 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2H2Dyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 23:54:39 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20541.37266.533608.571099@gargle.gargle.HOWL> (sfid-20120829_055520_793707_FC62695D)
Date: Wed, 29 Aug 2012 09:20:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix TX filter usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX filter bit for a station would be set by the HW
when a frame is not acked. A frame would be completed with
ATH9K_TXERR_FILT status only when the corresponding filter bit
for the destination station is already set.

Currently, un-acknowledged  packets are added to the pending queue
and retried, but the "clear_dest_mask" bit in the descriptor is
set only when the TX status has been ATH9K_TXERR_FILT. This results
in packet loss and the log shows:

wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746071
wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746076
wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746377
...
...

This issue can be resolved by making sure that the destination
mask is cleared when the packet is being retried and the earlier
TX status is ATH9K_TXERR_XRETRY.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ef91f6c..b074c3a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -568,7 +568,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (!an->sleeping) {
 			ath_tx_queue_tid(txq, tid);
 
-			if (ts->ts_status & ATH9K_TXERR_FILT)
+			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 				tid->ac->clear_ps_filter = true;
 		}
 	}
-- 
1.7.12


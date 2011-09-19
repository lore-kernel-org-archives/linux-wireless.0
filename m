Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:42121 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab1ISSiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 14:38:50 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 0B1538CB2B
	for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 21:38:49 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id EB69F41BE7
	for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 21:38:45 +0300 (EEST)
Subject: [PATCH] ath6kl: pass only unicast frames for aggregation
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 19 Sep 2011 21:38:44 +0300
Message-ID: <20110919183844.25296.65533.stgit@localhost6.localdomain6> (sfid-20110919_203858_334538_65816777)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When pinging form ar6003 to the AP RTT was high even when power save was
disabled:

100 packets transmitted, 97 received, 3% packet loss, time 99125ms
rtt min/avg/max/mdev = 1.875/46.733/795.506/139.181 ms

After some investigation one reason for this was that received
multicast traffic confused the aggrecation logic and caused 400 ms
timeouts when receiving multicast frames from AP.

A simple way to fix is to pass only unicast frames for aggregation. This
improves RTT:

100 packets transmitted, 99 received, 1% packet loss, time 99144ms
rtt min/avg/max/mdev = 2.083/13.084/403.390/56.794 ms

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index fffd929..348c646 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1230,9 +1230,15 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			ath6kl_data_tx(skb1, ar->net_dev);
 	}
 
-	if (!aggr_process_recv_frm(ar->aggr_cntxt, tid, seq_no,
-				   is_amsdu, skb))
-		ath6kl_deliver_frames_to_nw_stack(ar->net_dev, skb);
+	datap = (struct ethhdr *) skb->data;
+
+	if (is_unicast_ether_addr(datap->h_dest) &&
+	    aggr_process_recv_frm(ar->aggr_cntxt, tid, seq_no,
+				  is_amsdu, skb))
+		/* aggregation code will handle the skb */
+		return;
+
+	ath6kl_deliver_frames_to_nw_stack(ar->net_dev, skb);
 }
 
 static void aggr_timeout(unsigned long arg)
@@ -1249,10 +1255,6 @@ static void aggr_timeout(unsigned long arg)
 		if (!rxtid->aggr || !rxtid->timer_mon || rxtid->progress)
 			continue;
 
-		/*
-		 * FIXME: these timeouts happen quite fruently, something
-		 * line once within 60 seconds. Investigate why.
-		 */
 		stats->num_timeouts++;
 		ath6kl_dbg(ATH6KL_DBG_AGGR,
 			   "aggr timeout (st %d end %d)\n",


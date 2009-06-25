Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZFYK2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 06:28:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/4] iwmc3200wifi: replace netif_rx with netif_rx_ni
Date: Thu, 25 Jun 2009 18:28:30 +0800
Message-Id: <1245925713-14908-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1245925713-14908-1-git-send-email-yi.zhu@intel.com>
References: <1245925713-14908-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch uses netif_rx_ni() over netif_rx() to post buffers to
upper network code because it is always scheduled in a workqueue.
The problem was first observed from a dynamic ticks warning:

    "NOHZ: local_softirq_pending ..."

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 55871da..5d2239f 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1373,7 +1373,7 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 		ndev->stats.rx_packets++;
 		ndev->stats.rx_bytes += skb->len;
 
-		if (netif_rx(skb) == NET_RX_DROP) {
+		if (netif_rx_ni(skb) == NET_RX_DROP) {
 			IWM_ERR(iwm, "Packet dropped\n");
 			ndev->stats.rx_dropped++;
 		}
-- 
1.6.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22283 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2DCInM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 04:43:12 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Support net_stats.multicast
Date: Tue, 3 Apr 2012 14:13:46 +0530
Message-ID: <1333442626-8038-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120403_104319_105275_D3ECF1CF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net_stats.multicast is updated with the count of received multicast packets.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index fdcc6ee..21999dc 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1593,7 +1593,9 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			/* aggregation code will handle the skb */
 			return;
 		}
-	}
+	} else
+		if (!is_broadcast_ether_addr(datap->h_dest))
+			vif->net_stats.multicast++;
 
 	ath6kl_deliver_frames_to_nw_stack(vif->ndev, skb);
 }
-- 
1.7.0.4


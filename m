Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14501 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaB0OVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:52 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 16/16] wil6210: do not reorder groupcast Rx
Date: Thu, 27 Feb 2014 16:20:55 +0200
Message-ID: <1393510855-17566-17-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_154709_364117_8787C88F)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Groupcast frames are not subject for BACK reordering because they are not
ACK'ed and one can't request re-transmitt

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 9b4388b..092081e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -529,8 +529,14 @@ void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 			skb->protocol = htons(ETH_P_802_2);
 			wil_netif_rx_any(skb, ndev);
 		} else {
+			struct ethhdr *eth = (void *)skb->data;
+
 			skb->protocol = eth_type_trans(skb, ndev);
-			wil_rx_reorder(wil, skb);
+
+			if (is_unicast_ether_addr(eth->h_dest))
+				wil_rx_reorder(wil, skb);
+			else
+				wil_netif_rx_any(skb, ndev);
 		}
 
 	}
-- 
1.8.3.2


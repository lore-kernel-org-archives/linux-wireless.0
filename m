Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:62688 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbbG3Kyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:49 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 16/19] wil6210: allow to handle Rx on 2 cores
Date: Thu, 30 Jul 2015 13:52:04 +0300
Message-Id: <1438253527-3372-17-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125458_373405_3587F48E)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>

Allow network stack part of Rx processing to run on separate core,
relaxing CPU utilization on the core used for Rx NAPI.

If RXHASH feature is enabled, the driver sets rxhash of each skb to 1
to enable RPS. The core for processing the rx skb is determined by RPS
mechanism according to rx_cpus bit mask which is configured at user level.
For processing skbs on different core from the core which processes
the interrupts, it is recommended not to enable core 0 in rx_cpus bit mask.

Signed-off-by: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 3 ++-
 drivers/net/wireless/ath/wil6210/txrx.c   | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 25c5116..e3b3c8f 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -174,7 +174,8 @@ void *wil_if_alloc(struct device *dev)
 	ndev->ieee80211_ptr = wdev;
 	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 			    NETIF_F_SG | NETIF_F_GRO |
-			    NETIF_F_TSO | NETIF_F_TSO6;
+			    NETIF_F_TSO | NETIF_F_TSO6 |
+			    NETIF_F_RXHASH;
 
 	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 359121f..6229110 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -541,6 +541,14 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		[GRO_DROP]		= "GRO_DROP",
 	};
 
+	if (ndev->features & NETIF_F_RXHASH)
+		/* fake L4 to ensure it won't be re-calculated later
+		 * set hash to any non-zero value to activate rps
+		 * mechanism, core will be chosen according
+		 * to user-level rps configuration.
+		 */
+		skb_set_hash(skb, 1, PKT_HASH_TYPE_L4);
+
 	skb_orphan(skb);
 
 	if (wdev->iftype == NL80211_IFTYPE_AP && !wil->ap_isolate) {
-- 
2.1.4


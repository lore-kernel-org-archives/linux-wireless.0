Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbbAYIxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:38 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 08/10] wil6210: Tx status
Date: Sun, 25 Jan 2015 10:52:49 +0200
Message-Id: <1422175971-8075-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095345_002846_A1FB52CF)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement Tx status reporting

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  1 +
 drivers/net/wireless/ath/wil6210/txrx.c     | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6b7664d..f65da91 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -858,6 +858,7 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 	wiphy->cipher_suites = wil_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(wil_cipher_suites);
 	wiphy->mgmt_stypes = wil_mgmt_stypes;
+	wiphy->features |= NL80211_FEATURE_SK_TX_STATUS;
 }
 
 struct wireless_dev *wil_cfg80211_init(struct device *dev)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index b58ee52..0499ebc 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1121,6 +1121,22 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NET_XMIT_DROP;
 }
 
+static inline bool wil_need_txstat(struct sk_buff *skb)
+{
+	struct ethhdr *eth = (void *)skb->data;
+
+	return is_unicast_ether_addr(eth->h_dest) && skb->sk &&
+	       (skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS);
+}
+
+static inline void wil_consume_skb(struct sk_buff *skb, bool acked)
+{
+	if (unlikely(wil_need_txstat(skb)))
+		skb_complete_wifi_ack(skb, acked);
+	else
+		acked ? dev_consume_skb_any(skb) : dev_kfree_skb_any(skb);
+}
+
 /**
  * Clean up transmitted skb's from the Tx VRING
  *
@@ -1199,8 +1215,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 					ndev->stats.tx_errors++;
 					stats->tx_errors++;
 				}
-
-				dev_kfree_skb_any(skb);
+				wil_consume_skb(skb, d->dma.error == 0);
 			}
 			memset(ctx, 0, sizeof(*ctx));
 			/* There is no need to touch HW descriptor:
-- 
2.1.0


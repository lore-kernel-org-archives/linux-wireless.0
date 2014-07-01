Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35297 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbaGAVkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 17:40:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"Avinash Patil" <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	"Chin-Ran Lo" <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.16] mwifiex: initialize Tx/Rx info of a packet correctly
Date: Tue, 1 Jul 2014 14:39:04 -0700
Message-ID: <1404250744-24093-1-git-send-email-bzhao@marvell.com> (sfid-20140701_234036_728491_139481FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

There are few places at the begining of Tx/Rx paths where
tx_info/rx_info is not correctly initialized. This patch
takes care of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 1 +
 drivers/net/wireless/mwifiex/cfg80211.c | 1 +
 drivers/net/wireless/mwifiex/cmdevt.c   | 1 +
 drivers/net/wireless/mwifiex/sta_tx.c   | 1 +
 drivers/net/wireless/mwifiex/tdls.c     | 2 ++
 drivers/net/wireless/mwifiex/txrx.c     | 1 +
 drivers/net/wireless/mwifiex/uap_txrx.c | 1 +
 7 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index b4c14b0..8720a3d 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -185,6 +185,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	skb_reserve(skb_aggr, headroom + sizeof(struct txpd));
 	tx_info_aggr =  MWIFIEX_SKB_TXCB(skb_aggr);
 
+	memset(tx_info_aggr, 0, sizeof(*tx_info_aggr));
 	tx_info_aggr->bss_type = tx_info_src->bss_type;
 	tx_info_aggr->bss_num = tx_info_src->bss_num;
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 15fa7b4..6af135f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -188,6 +188,7 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 	tx_info->pkt_len = pkt_len;
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index df42f06..5899eee 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -462,6 +462,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 
 	if (skb) {
 		rx_info = MWIFIEX_SKB_RXCB(skb);
+		memset(rx_info, 0, sizeof(*rx_info));
 		rx_info->bss_num = priv->bss_num;
 		rx_info->bss_type = priv->bss_type;
 	}
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index cf330ba..dab7b33 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -150,6 +150,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		return -1;
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 	tx_info->pkt_len = data_len - (sizeof(struct txpd) + INTF_HEADER_LEN);
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 3efbcbe..a414161 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -604,6 +604,7 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 
@@ -757,6 +758,7 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
 	skb->priority = MWIFIEX_PRIO_VI;
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 	tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 0820568..96a2126 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -55,6 +55,7 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
+	memset(rx_info, 0, sizeof(*rx_info));
 	rx_info->bss_num = priv->bss_num;
 	rx_info->bss_type = priv->bss_type;
 
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index ddfc3c6..ec7309d 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -174,6 +174,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 	tx_info->flags |= MWIFIEX_BUF_FLAG_BRIDGED_PKT;
-- 
1.8.2.3


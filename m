Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60806 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab3LCHSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 08/12] mwifiex: correct TX byte count statistics
Date: Mon, 2 Dec 2013 23:17:55 -0800
Message-ID: <1386055079-6623-9-git-send-email-bzhao@marvell.com> (sfid-20131203_082500_052252_12AD6A50)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

The skb is modified in sending the TX packet. Save the original
packet length to a variable so that we can get the correct
statistics update.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 1 +
 drivers/net/wireless/mwifiex/decl.h     | 1 +
 drivers/net/wireless/mwifiex/main.c     | 1 +
 drivers/net/wireless/mwifiex/sta_tx.c   | 1 +
 drivers/net/wireless/mwifiex/txrx.c     | 2 +-
 5 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 109e475..b2f271e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -222,6 +222,7 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
+	tx_info->pkt_len = pkt_len;
 
 	mwifiex_form_mgmt_frame(skb, buf, len);
 	mwifiex_queue_tx_pkt(priv, skb);
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 5c85d78..3a21bd0 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -130,6 +130,7 @@ struct mwifiex_txinfo {
 	u8 flags;
 	u8 bss_num;
 	u8 bss_type;
+	u32 pkt_len;
 };
 
 enum mwifiex_wmm_ac_e {
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 78e8a66..36c79cf 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -648,6 +648,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
+	tx_info->pkt_len = skb->len;
 
 	/* Record the current time the packet was queued; used to
 	 * determine the amount of time the packet was queued in
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 7b581af..354d64c 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -148,6 +148,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
+	tx_info->pkt_len = data_len - (sizeof(struct txpd) + INTF_HEADER_LEN);
 	skb_reserve(skb, sizeof(struct txpd) + INTF_HEADER_LEN);
 	skb_push(skb, sizeof(struct txpd));
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 8dd145c..3446da6 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -175,7 +175,7 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 	mwifiex_set_trans_start(priv->netdev);
 	if (!status) {
 		priv->stats.tx_packets++;
-		priv->stats.tx_bytes += skb->len;
+		priv->stats.tx_bytes += tx_info->pkt_len;
 		if (priv->tx_timeout_cnt)
 			priv->tx_timeout_cnt = 0;
 	} else {
-- 
1.8.2.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45267 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab3LCHSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 06/12] mwifiex: fix rx_pending count imbalance
Date: Mon, 2 Dec 2013 23:17:53 -0800
Message-ID: <1386055079-6623-7-git-send-email-bzhao@marvell.com> (sfid-20131203_082459_625819_13406690)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

RX packets are handled in different paths. Not all paths have
decrement of rx_pending counter. This patch fixes the counter
imbalance.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c     |  3 ++-
 drivers/net/wireless/mwifiex/main.h     |  2 +-
 drivers/net/wireless/mwifiex/sta_rx.c   | 15 +++------------
 drivers/net/wireless/mwifiex/txrx.c     | 11 +++++++++--
 drivers/net/wireless/mwifiex/uap_txrx.c | 15 +++------------
 drivers/net/wireless/mwifiex/usb.c      |  4 +---
 6 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 6499117..1d0a817 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -643,7 +643,8 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 			if (priv)
 				priv->stats.rx_dropped++;
 
-			adapter->if_ops.data_complete(adapter, skb);
+			dev_kfree_skb_any(skb);
+			adapter->if_ops.data_complete(adapter);
 		}
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1d72f13..dc34457 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -615,7 +615,7 @@ struct mwifiex_if_ops {
 	void (*cleanup_mpa_buf) (struct mwifiex_adapter *);
 	int (*cmdrsp_complete) (struct mwifiex_adapter *, struct sk_buff *);
 	int (*event_complete) (struct mwifiex_adapter *, struct sk_buff *);
-	int (*data_complete) (struct mwifiex_adapter *, struct sk_buff *);
+	int (*data_complete) (struct mwifiex_adapter *);
 	int (*init_fw_port) (struct mwifiex_adapter *);
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	void (*card_reset) (struct mwifiex_adapter *);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index d74192d..0bb510d 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -188,12 +188,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 			"wrong rx packet: len=%d, rx_pkt_offset=%d, rx_pkt_length=%d\n",
 			skb->len, rx_pkt_offset, rx_pkt_length);
 		priv->stats.rx_dropped++;
-
-		if (adapter->if_ops.data_complete)
-			adapter->if_ops.data_complete(adapter, skb);
-		else
-			dev_kfree_skb_any(skb);
-
+		dev_kfree_skb_any(skb);
 		return ret;
 	}
 
@@ -247,12 +242,8 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 	ret = mwifiex_11n_rx_reorder_pkt(priv, seq_num, local_rx_pd->priority,
 					 ta, (u8) rx_pkt_type, skb);
 
-	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
-		if (adapter->if_ops.data_complete)
-			adapter->if_ops.data_complete(adapter, skb);
-		else
-			dev_kfree_skb_any(skb);
-	}
+	if (ret || (rx_pkt_type == PKT_TYPE_BAR))
+		dev_kfree_skb_any(skb);
 
 	if (ret)
 		priv->stats.rx_dropped++;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 8f923d0..8dd145c 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -40,6 +40,7 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct rxpd *local_rx_pd;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	int ret;
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 	/* Get the BSS number from rxpd, get corresponding priv */
@@ -58,9 +59,15 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	rx_info->bss_type = priv->bss_type;
 
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
-		return mwifiex_process_uap_rx_packet(priv, skb);
+		ret = mwifiex_process_uap_rx_packet(priv, skb);
+	else
+		ret = mwifiex_process_sta_rx_packet(priv, skb);
+
+	/* Decrement RX pending counter for each packet */
+	if (adapter->if_ops.data_complete)
+		adapter->if_ops.data_complete(adapter);
 
-	return mwifiex_process_sta_rx_packet(priv, skb);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
 
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index a0bd954..6c0a31a 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -267,12 +267,7 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 			skb->len, le16_to_cpu(uap_rx_pd->rx_pkt_offset),
 			le16_to_cpu(uap_rx_pd->rx_pkt_length));
 		priv->stats.rx_dropped++;
-
-		if (adapter->if_ops.data_complete)
-			adapter->if_ops.data_complete(adapter, skb);
-		else
-			dev_kfree_skb_any(skb);
-
+		dev_kfree_skb_any(skb);
 		return 0;
 	}
 
@@ -326,12 +321,8 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 					 uap_rx_pd->priority, ta, pkt_type,
 					 skb);
 
-	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
-		if (adapter->if_ops.data_complete)
-			adapter->if_ops.data_complete(adapter, skb);
-		else
-			dev_kfree_skb_any(skb);
-	}
+	if (ret || (rx_pkt_type == PKT_TYPE_BAR))
+		dev_kfree_skb_any(skb);
 
 	if (ret)
 		priv->stats.rx_dropped++;
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index edf5b7a..a9240a2 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -938,11 +938,9 @@ static int mwifiex_usb_cmd_event_complete(struct mwifiex_adapter *adapter,
 	return 0;
 }
 
-static int mwifiex_usb_data_complete(struct mwifiex_adapter *adapter,
-				     struct sk_buff *skb)
+static int mwifiex_usb_data_complete(struct mwifiex_adapter *adapter)
 {
 	atomic_dec(&adapter->rx_pending);
-	dev_kfree_skb_any(skb);
 
 	return 0;
 }
-- 
1.8.2.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8680 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbaLEMYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 07:24:30 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 3/4] mwifiex: guard station nodes access by station list lock
Date: Fri, 5 Dec 2014 23:23:41 +0530
Message-ID: <1417802022-7364-3-git-send-email-patila@marvell.com> (sfid-20141205_132445_329937_81E84037)
In-Reply-To: <1417802022-7364-1-git-send-email-patila@marvell.com>
References: <1417802022-7364-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Station node entries should be guarded for whole of their reference
instead of just while getting node entry from station list.
It may happen that station node is retrieved may be deleted by
deauthentication event while it is still in use.

Reported by: Tim Shepard <shep@xplot.org>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           | 4 ++++
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 6 ++++++
 drivers/net/wireless/mwifiex/uap_txrx.c      | 3 +++
 drivers/net/wireless/mwifiex/wmm.c           | 6 +++---
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 62f5dbe..9d4786e 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -544,6 +544,7 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	u32 tx_win_size = priv->add_ba_param.tx_win_size;
 	static u8 dialog_tok;
 	int ret;
+	unsigned long flags;
 	u16 block_ack_param_set;
 
 	dev_dbg(priv->adapter->dev, "cmd: %s: tid %d\n", __func__, tid);
@@ -554,15 +555,18 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	    memcmp(priv->cfg_bssid, peer_mac, ETH_ALEN)) {
 		struct mwifiex_sta_node *sta_ptr;
 
+		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 		sta_ptr = mwifiex_get_sta_entry(priv, peer_mac);
 		if (!sta_ptr) {
 			dev_warn(priv->adapter->dev,
 				 "BA setup with unknown TDLS peer %pM!\n",
 				peer_mac);
+			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 			return -1;
 		}
 		if (sta_ptr->is_11ac_enabled)
 			tx_win_size = MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE;
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 	}
 
 	block_ack_param_set = (u16)((tid << BLOCKACKPARAM_TID_POS) |
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 5ef5a0e..d73fda3 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -351,6 +351,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	new_node->init_win = seq_num;
 	new_node->flags = 0;
 
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 	if (mwifiex_queuing_ra_based(priv)) {
 		dev_dbg(priv->adapter->dev,
 			"info: AP/ADHOC:last_seq=%d start_win=%d\n",
@@ -367,6 +368,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		else
 			last_seq = priv->rx_seq[tid];
 	}
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 
 	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
 	    last_seq >= new_node->start_win) {
@@ -455,22 +457,26 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	u32 rx_win_size = priv->add_ba_param.rx_win_size;
 	u8 tid;
 	int win_size;
+	unsigned long flags;
 	uint16_t block_ack_param_set;
 
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
 	    priv->adapter->is_hw_11ac_capable &&
 	    memcmp(priv->cfg_bssid, cmd_addba_req->peer_mac_addr, ETH_ALEN)) {
+		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 		sta_ptr = mwifiex_get_sta_entry(priv,
 						cmd_addba_req->peer_mac_addr);
 		if (!sta_ptr) {
 			dev_warn(priv->adapter->dev,
 				 "BA setup with unknown TDLS peer %pM!\n",
 				 cmd_addba_req->peer_mac_addr);
+			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 			return -1;
 		}
 		if (sta_ptr->is_11ac_enabled)
 			rx_win_size = MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE;
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 	}
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_RSP);
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index e7d326f..be3a203 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -266,6 +266,7 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u16 rx_pkt_type;
 	u8 ta[ETH_ALEN], pkt_type;
+	unsigned long flags;
 	struct mwifiex_sta_node *node;
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
@@ -294,10 +295,12 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 	memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
 
 	if (rx_pkt_type != PKT_TYPE_BAR && uap_rx_pd->priority < MAX_NUM_TID) {
+		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 		node = mwifiex_get_sta_entry(priv, ta);
 		if (node)
 			node->rx_seq[uap_rx_pd->priority] =
 						le16_to_cpu(uap_rx_pd->seq_num);
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 	}
 
 	if (!priv->ap_11n_enabled ||
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 0dafcb0..ffffd2c 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -147,9 +147,6 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 	struct mwifiex_sta_node *node;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
-	node = mwifiex_get_sta_entry(priv, ra);
-	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		ra_list = mwifiex_wmm_allocate_ralist_node(adapter, ra);
@@ -170,10 +167,13 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 				ra_list->is_11n_enabled = IS_11N_ENABLED(priv);
 			}
 		} else {
+			spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+			node = mwifiex_get_sta_entry(priv, ra);
 			ra_list->is_11n_enabled =
 				      mwifiex_is_sta_11n_enabled(priv, node);
 			if (ra_list->is_11n_enabled)
 				ra_list->max_amsdu = node->max_amsdu;
+			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		}
 
 		dev_dbg(adapter->dev, "data: ralist %p: is_11n_enabled=%d\n",
-- 
1.8.1.4


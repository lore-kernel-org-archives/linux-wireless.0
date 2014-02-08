Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62658 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbaBHAaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:30:55 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 27/30] mwifiex: separate BA params for TDLS link if 11ac is supported
Date: Fri, 7 Feb 2014 16:30:40 -0800
Message-ID: <1391819442-21239-8-git-send-email-bzhao@marvell.com> (sfid-20140208_020008_778621_5C999FDE)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

If TDLS link is 11ac enabled i.e. we as well as peer station
supports VHT, configure seprate TX & RX window sizes during
BA setup. So even if BSS does not support 11ac, we can use VHT
capabilities and higher window sizes on direct link.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           | 22 +++++++++++++++++++---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 21 +++++++++++++++++++--
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 616b1d6..37677af 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -537,16 +537,32 @@ void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
 int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 {
 	struct host_cmd_ds_11n_addba_req add_ba_req;
+	struct mwifiex_sta_node *sta_ptr;
+	u32 tx_win_size = priv->add_ba_param.tx_win_size;
 	static u8 dialog_tok;
 	int ret;
 
 	dev_dbg(priv->adapter->dev, "cmd: %s: tid %d\n", __func__, tid);
 
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	    priv->adapter->is_hw_11ac_capable &&
+	    memcmp(priv->cfg_bssid, peer_mac, ETH_ALEN)) {
+		sta_ptr = mwifiex_get_sta_entry(priv, peer_mac);
+		if (!sta_ptr) {
+			dev_warn(priv->adapter->dev,
+				 "BA setup with unknown TDLS peer %pM!\n",
+				peer_mac);
+			return -1;
+		}
+		if (sta_ptr->is_11ac_enabled)
+			tx_win_size = MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE;
+	}
+
 	add_ba_req.block_ack_param_set = cpu_to_le16(
 		(u16) ((tid << BLOCKACKPARAM_TID_POS) |
-			 (priv->add_ba_param.
-			  tx_win_size << BLOCKACKPARAM_WINSIZE_POS) |
-			 IMMEDIATE_BLOCK_ACK));
+		       tx_win_size << BLOCKACKPARAM_WINSIZE_POS |
+		       IMMEDIATE_BLOCK_ACK));
 	add_ba_req.block_ack_tmo = cpu_to_le16((u16)priv->add_ba_param.timeout);
 
 	++dialog_tok;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 3767399..b361257 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -362,10 +362,28 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 				  *cmd_addba_req)
 {
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp = &cmd->params.add_ba_rsp;
+	struct mwifiex_sta_node *sta_ptr;
+	u32 rx_win_size = priv->add_ba_param.rx_win_size;
 	u8 tid;
 	int win_size;
 	uint16_t block_ack_param_set;
 
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	    priv->adapter->is_hw_11ac_capable &&
+	    memcmp(priv->cfg_bssid, cmd_addba_req->peer_mac_addr, ETH_ALEN)) {
+		sta_ptr = mwifiex_get_sta_entry(priv,
+						cmd_addba_req->peer_mac_addr);
+		if (!sta_ptr) {
+			dev_warn(priv->adapter->dev,
+				 "BA setup with unknown TDLS peer %pM!\n",
+				 cmd_addba_req->peer_mac_addr);
+			return -1;
+		}
+		if (sta_ptr->is_11ac_enabled)
+			rx_win_size = MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE;
+	}
+
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_RSP);
 	cmd->size = cpu_to_le16(sizeof(*add_ba_rsp) + S_DS_GEN);
 
@@ -382,8 +400,7 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	block_ack_param_set &= ~IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK;
 	/* We donot support AMSDU inside AMPDU, hence reset the bit */
 	block_ack_param_set &= ~BLOCKACKPARAM_AMSDU_SUPP_MASK;
-	block_ack_param_set |= (priv->add_ba_param.rx_win_size <<
-					     BLOCKACKPARAM_WINSIZE_POS);
+	block_ack_param_set |= rx_win_size << BLOCKACKPARAM_WINSIZE_POS;
 	add_ba_rsp->block_ack_param_set = cpu_to_le16(block_ack_param_set);
 	win_size = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
 					& IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
-- 
1.8.2.3


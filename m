Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46146 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1CEEYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 23:24:19 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2 v3] mwifiex: remove PRINTM/HEXDUMP and associated
Date: Fri,  4 Mar 2011 20:27:07 -0800
Message-Id: <1299299227-8849-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299299227-8849-1-git-send-email-bzhao@marvell.com>
References: <1299299227-8849-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use dev_dbg/wiphy_dbg/pr_debug families API instead.

MERROR/MFATAL: dev_err/wiphy_err/pr_err
MMSG: dev_err/wiphy_err/pr_err, dev_warn, dev_notice
MDATA/MCMND/MEVENT/MINTR/MINFO: dev_dbg/wiphy_dbg/pr_debug
MWARN: dev_warn, dev_dbg, dev_err
HEXDUMP: simply removed for now. We may add HEXDUMP back after
the dynamic_hexdump_debug/hexdump_debug are in kernel.

drvdbg/ifdbg are also removed from debugfs as they are not needed
any more if we use dynamic debug (CONFIG_DYNAMIC_DEBUG=y).

For messages printed by dev_dbg/whiphy_dbg/pr_debug, they can be
enabled/disabled selectively at run-time. For example,

echo "module mwifiex format 'cmd: ' +p" > /ddebug/dynamic_debug/control
echo "module mwifiex_sdio format 'cmd: ' +p" > /ddebug/dynamic_debug/control

This enables all "cmd" messages in mwifiex/mwifiex_sdio modules.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
---
v3: use pr_fmt(), and dev_dbg/wiphy_dbg wherever possible, etc. (Joe Perches)
v2: add more people to Signed-off-by. No change to the patch itself

 drivers/net/wireless/mwifiex/11n.c           |  116 ++++-----
 drivers/net/wireless/mwifiex/11n_aggr.c      |   18 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   92 ++-----
 drivers/net/wireless/mwifiex/README          |   47 ----
 drivers/net/wireless/mwifiex/cfg80211.c      |  102 ++++----
 drivers/net/wireless/mwifiex/cfp.c           |   52 ++--
 drivers/net/wireless/mwifiex/cmdevt.c        |  242 ++++++++----------
 drivers/net/wireless/mwifiex/debugfs.c       |  111 ++------
 drivers/net/wireless/mwifiex/decl.h          |    3 +
 drivers/net/wireless/mwifiex/init.c          |   45 ++--
 drivers/net/wireless/mwifiex/join.c          |  187 ++++++--------
 drivers/net/wireless/mwifiex/main.c          |   95 +++----
 drivers/net/wireless/mwifiex/scan.c          |  353 ++++++++++---------------
 drivers/net/wireless/mwifiex/sdio.c          |  325 +++++++++++-------------
 drivers/net/wireless/mwifiex/sta_cmd.c       |   54 ++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   98 ++++----
 drivers/net/wireless/mwifiex/sta_event.c     |   89 ++++----
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  184 +++++++------
 drivers/net/wireless/mwifiex/sta_rx.c        |   15 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |   10 +-
 drivers/net/wireless/mwifiex/txrx.c          |    4 +-
 drivers/net/wireless/mwifiex/util.c          |   55 +----
 drivers/net/wireless/mwifiex/util.h          |   72 ------
 drivers/net/wireless/mwifiex/wmm.c           |   77 +++----
 24 files changed, 993 insertions(+), 1453 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 6413853..49876e7 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -41,13 +41,13 @@ int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
 			return -EFAULT;
 		else
 			adapter->usr_dot_11n_dev_cap = *htcap_cfg;
-		PRINTM(MINFO, "UsrDot11nCap 0x%x\n",
-		       adapter->usr_dot_11n_dev_cap);
 	} else {
 		*htcap_cfg = adapter->usr_dot_11n_dev_cap;
-		PRINTM(MINFO, "UsrDot11nCap 0x%x\n", *htcap_cfg);
 	}
 
+	dev_dbg(adapter->dev, "info: usr_dot_11n_dev_cap %#x\n",
+			adapter->usr_dot_11n_dev_cap);
+
 	return 0;
 }
 
@@ -145,14 +145,12 @@ int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
 	int ret = 0;
 
 	if (action == HostCmd_ACT_GEN_GET) {
-		PRINTM(MINFO, "Addba reject GET\n");
-		memcpy(addba_reject, priv->addba_reject,
-		       MAX_NUM_TID);
+		dev_dbg(priv->adapter->dev, "info: GET: addba reject\n");
+		memcpy(addba_reject, priv->addba_reject, MAX_NUM_TID);
 	} else {
 		if (priv->media_connected) {
-			PRINTM(MERROR,
-			       "Can not set aggr priority table in connected"
-			       " state\n");
+			dev_err(priv->adapter->dev,
+				"cannot set addba reject in connected state\n");
 			return -1;
 		}
 
@@ -192,9 +190,8 @@ int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 		}
 	} else {
 		if (priv->media_connected) {
-			PRINTM(MERROR,
-			       "Can not set aggr priority table in connected"
-			       " state\n");
+			dev_err(priv->adapter->dev, "cannot set aggr priority"
+					" table in connected state\n");
 			return -1;
 		}
 
@@ -366,61 +363,62 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 void
 mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
 {
-	PRINTM(MINFO, "GET_HW_SPEC: Maximum MSDU length = %s octets\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Max MSDU len = %s octets\n",
 	       (ISSUPP_MAXAMSDU(cap) ? "7935" : "3839"));
-	PRINTM(MINFO, "GET_HW_SPEC: Beam forming %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Beam forming %s\n",
 	       (ISSUPP_BEAMFORMING(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: Greenfield preamble %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Greenfield preamble %s\n",
 	       (ISSUPP_GREENFIELD(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: AMPDU %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: AMPDU %s\n",
 	       (ISSUPP_AMPDU(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: MIMO Power Save %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: MIMO Power Save %s\n",
 	       (ISSUPP_MIMOPS(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: Rx STBC %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Rx STBC %s\n",
 	       (ISSUPP_RXSTBC(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: Tx STBC %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Tx STBC %s\n",
 	       (ISSUPP_TXSTBC(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: Short GI for 40 Mhz %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Short GI for 40 Mhz %s\n",
 	       (ISSUPP_SHORTGI40(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: Short GI for 20 Mhz %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Short GI for 20 Mhz %s\n",
 	       (ISSUPP_SHORTGI20(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: LDPC coded packet receive %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: LDPC coded packet receive %s\n",
 	       (ISSUPP_RXLDPC(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: Number of Delayed Block Ack streams = %d\n",
+	dev_dbg(adapter->dev,
+		"info: GET_HW_SPEC: Number of Delayed Block Ack streams = %d\n",
 	       GET_DELAYEDBACK(cap));
-	PRINTM(MINFO,
-	       "GET_HW_SPEC: Number of Immediate Block Ack streams = %d\n",
+	dev_dbg(adapter->dev,
+		"info: GET_HW_SPEC: Number of Immediate Block Ack streams = %d\n",
 	       GET_IMMEDIATEBACK(cap));
-	PRINTM(MINFO, "GET_HW_SPEC: 40 Mhz channel width %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 40 Mhz channel width %s\n",
 	       (ISSUPP_CHANWIDTH40(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: 20 Mhz channel width %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 20 Mhz channel width %s\n",
 	       (ISSUPP_CHANWIDTH20(cap) ? "supported" : "not supported"));
-	PRINTM(MINFO, "GET_HW_SPEC: 10 Mhz channel width %s\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 10 Mhz channel width %s\n",
 	       (ISSUPP_CHANWIDTH10(cap) ? "supported" : "not supported"));
 
 	if (ISSUPP_RXANTENNAA(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Rx antennea A\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea A\n");
 
 	if (ISSUPP_RXANTENNAB(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Rx antennea B\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea B\n");
 
 	if (ISSUPP_RXANTENNAC(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Rx antennea C\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea C\n");
 
 	if (ISSUPP_RXANTENNAD(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Rx antennea D\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea D\n");
 
 	if (ISSUPP_TXANTENNAA(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Tx antennea A\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea A\n");
 
 	if (ISSUPP_TXANTENNAB(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Tx antennea B\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea B\n");
 
 	if (ISSUPP_TXANTENNAC(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Tx antennea C\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea C\n");
 
 	if (ISSUPP_TXANTENNAD(cap))
-		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Tx antennea D\n");
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea D\n");
 
 	return;
 }
@@ -431,7 +429,7 @@ mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
 void
 mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support)
 {
-	PRINTM(MINFO, "GET_HW_SPEC: MCSs for %dx%d MIMO\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: MCSs for %dx%d MIMO\n",
 	       GET_RXMCSSUPP(support), GET_TXMCSSUPP(support));
 	return;
 }
@@ -517,10 +515,11 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 						tid,
 						add_ba_rsp->peer_mac_addr);
 		if (tx_ba_tbl) {
-			PRINTM(MINFO, "BA stream complete\n");
+			dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
 			tx_ba_tbl->ba_status = BA_STREAM_SETUP_COMPLETE;
-		} else
-			PRINTM(MERROR, "Stream not created!!!\n");
+		} else {
+			dev_err(priv->adapter->dev, "BA stream not created\n");
+		}
 	} else {
 		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
 						add_ba_rsp->peer_mac_addr,
@@ -576,7 +575,7 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 	tx_buf->action = cpu_to_le16(action);
 	switch (action) {
 	case HostCmd_ACT_GEN_SET:
-		PRINTM(MCMND, "set tx_buf=%d\n", buf_size);
+		dev_dbg(priv->adapter->dev, "cmd: set tx_buf=%d\n", buf_size);
 		tx_buf->buff_size = cpu_to_le16(buf_size);
 		break;
 	case HostCmd_ACT_GEN_GET:
@@ -710,8 +709,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 
 		mwifiex_fill_cap_info(priv, ht_cap);
 
-		HEXDUMP("HT_CAPABILITIES IE", (u8 *) ht_cap,
-			sizeof(struct mwifiex_ie_types_htcap));
 		*buffer += sizeof(struct mwifiex_ie_types_htcap);
 		ret_len += sizeof(struct mwifiex_ie_types_htcap);
 	}
@@ -764,10 +761,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 					  GET_SECONDARYCHAN(bss_desc->
 					  bcn_ht_info->ht_param));
 
-		HEXDUMP("ChanList", (u8 *) chan_list,
-			sizeof(struct mwifiex_ie_types_chan_list_param_set));
-		HEXDUMP("ht_info", (u8 *) bss_desc->bcn_ht_info,
-			sizeof(struct mwifiex_ie_types_htinfo) - 2);
 		*buffer += sizeof(struct mwifiex_ie_types_chan_list_param_set);
 		ret_len += sizeof(struct mwifiex_ie_types_chan_list_param_set);
 	}
@@ -786,8 +779,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		       sizeof(struct ieee_types_header),
 		       le16_to_cpu(bss_co_2040->header.len));
 
-		HEXDUMP("20/40 BSS Coexistence IE", (u8 *) bss_co_2040,
-			sizeof(struct mwifiex_ie_types_2040bssco));
 		*buffer += sizeof(struct mwifiex_ie_types_2040bssco);
 		ret_len += sizeof(struct mwifiex_ie_types_2040bssco);
 	}
@@ -804,8 +795,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		       sizeof(struct ieee_types_header),
 		       le16_to_cpu(ext_cap->header.len));
 
-		HEXDUMP("Extended Capabilities IE", (u8 *) ext_cap,
-			sizeof(struct mwifiex_ie_types_extcap));
 		*buffer += sizeof(struct mwifiex_ie_types_extcap);
 		ret_len += sizeof(struct mwifiex_ie_types_extcap);
 	}
@@ -838,8 +827,8 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 
 	tx_buf = min(priv->adapter->max_tx_buf_size, max_amsdu);
 
-	PRINTM(MINFO, "max_amsdu=%d, maxTxBuf=%d\n", max_amsdu,
-	       priv->adapter->max_tx_buf_size);
+	dev_dbg(priv->adapter->dev, "info: max_amsdu=%d, max_tx_buf=%d\n",
+			max_amsdu, priv->adapter->max_tx_buf_size);
 
 	if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_2K)
 		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
@@ -887,7 +876,7 @@ mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
 		return;
 
-	PRINTM(MINFO, "tx_ba_stream_tbl_ptr %p\n", tx_ba_tsr_tbl);
+	dev_dbg(priv->adapter->dev, "info: tx_ba_tsr_tbl %p\n", tx_ba_tsr_tbl);
 
 	list_del(&tx_ba_tsr_tbl->list);
 
@@ -956,10 +945,6 @@ mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
-		PRINTM(MDAT_D, "get_tx_ba_stream_tbl TID %d\n",
-				tx_ba_tsr_tbl->tid);
-		DBG_HEXDUMP(MDAT_D, "RA", tx_ba_tsr_tbl->ra,
-				MWIFIEX_MAC_ADDR_LENGTH);
 		if ((!memcmp(tx_ba_tsr_tbl->ra, ra, MWIFIEX_MAC_ADDR_LENGTH))
 		    && (tx_ba_tsr_tbl->tid == tid)) {
 			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
@@ -984,14 +969,11 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	unsigned long flags;
 
 	if (!mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ra)) {
-		PRINTM(MDAT_D, "get_tx_ba_stream_tbl TID %d\n", tid);
-		DBG_HEXDUMP(MDAT_D, "RA", ra, MWIFIEX_MAC_ADDR_LENGTH);
-
 		new_node = kzalloc(sizeof(struct mwifiex_tx_ba_stream_tbl),
 					GFP_ATOMIC);
 		if (!new_node) {
-			PRINTM(MERROR, "%s: failed to alloc new_node\n",
-			       __func__);
+			dev_err(priv->adapter->dev,
+				"%s: failed to alloc new_node\n", __func__);
 			return;
 		}
 
@@ -1019,8 +1001,7 @@ mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	static u8 dialog_tok;
 	int ret;
 
-	PRINTM(MCMND, "Send addba: TID %d\n", tid);
-	DBG_HEXDUMP(MCMD_D, "Send addba RA", peer_mac, MWIFIEX_MAC_ADDR_LENGTH);
+	dev_dbg(priv->adapter->dev, "cmd: %s: tid %d\n", __func__, tid);
 
 	add_ba_req.block_ack_param_set = cpu_to_le16(
 		(u16) ((tid << BLOCKACKPARAM_TID_POS) |
@@ -1084,8 +1065,6 @@ mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 	uint16_t del_ba_param_set = le16_to_cpu(cmd_del_ba->del_ba_param_set);
 	int tid;
 
-	DBG_HEXDUMP(MCMD_D, "Delba:", (u8 *) cmd_del_ba, 20);
-
 	tid = del_ba_param_set >> DELBA_TID_POS;
 
 	mwifiex_11n_delete_ba_stream_tbl(priv, tid, cmd_del_ba->peer_mac_addr,
@@ -1170,7 +1149,8 @@ mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		rx_reo_tbl->tid = (u16) tx_ba_tsr_tbl->tid;
-		PRINTM(MDATA, "tid=%d\n", rx_reo_tbl->tid);
+		dev_dbg(priv->adapter->dev, "data: %s tid=%d\n",
+						__func__, rx_reo_tbl->tid);
 		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra,
 				MWIFIEX_MAC_ADDR_LENGTH);
 		rx_reo_tbl++;
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index a9353be..340cc8e 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -200,7 +200,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 
 	/* Sanity test */
 	if (total_pkt_len > MWIFIEX_RX_DATA_BUF_SIZE) {
-		PRINTM(MERROR, "Total packet length greater than tx buffer"
+		dev_err(adapter->dev, "total pkt len greater than buffer"
 		       " size %d\n", total_pkt_len);
 		return -1;
 	}
@@ -213,7 +213,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		pkt_len = ntohs((*(__be16 *)
 				 (data + (2 * MWIFIEX_MAC_ADDR_LENGTH))));
 		if (pkt_len > total_pkt_len) {
-			PRINTM(MERROR, "Error in pkt_len %d %d\n",
+			dev_err(adapter->dev, "pkt_len %d > total_pkt_len %d\n",
 			       total_pkt_len, pkt_len);
 			break;
 		}
@@ -237,7 +237,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 
 		skb_daggr = dev_alloc_skb(pkt_len);
 		if (!skb_daggr) {
-			PRINTM(MERROR, "%s: failed to alloc mbuf_daggr\n",
+			dev_err(adapter->dev, "%s: failed to alloc skb_daggr\n",
 			       __func__);
 			return -1;
 		}
@@ -256,7 +256,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		case -EINPROGRESS:
 			break;
 		case -1:
-			PRINTM(MERROR, "Deaggr, send to mwifiex failed\n");
+			dev_err(adapter->dev, "deaggr: host_to_card failed\n");
 		case 0:
 			mwifiex_recv_packet_complete(adapter, skb_daggr, ret);
 			break;
@@ -300,8 +300,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
 
-	PRINTM(MDAT_D, "Handling Aggr packet\n");
-
 	if (skb_queue_empty(&pra_list->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -311,7 +309,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	tx_info_src = MWIFIEX_SKB_TXCB(skb_src);
 	skb_aggr = dev_alloc_skb(adapter->tx_buf_size);
 	if (!skb_aggr) {
-		PRINTM(MERROR, "Error allocating SKB\n");
+		dev_err(adapter->dev, "%s: alloc skb_aggr\n", __func__);
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		return -1;
@@ -396,12 +394,12 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		PRINTM(MDATA, "-EBUSY is returned\n");
+		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
 		break;
 	case -1:
 		adapter->data_sent = false;
-		PRINTM(MERROR, "Error: mwifiex_write_data_async failed: 0x%X\n",
-		       ret);
+		dev_err(adapter->dev, "%s: host_to_card failed: %#x\n",
+						__func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb_aggr, ret);
 		return 0;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 11a5ddf..ef9b4f4 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -161,8 +161,6 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 
 	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
 
-	PRINTM(MDAT_D, "Delete rx_reor_tbl_ptr: %p\n", rx_reor_tbl_ptr);
-
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_del(&rx_reor_tbl_ptr->list);
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
@@ -229,7 +227,8 @@ mwifiex_flush_data(unsigned long context)
 
 	start_win = mwifiex_11n_find_last_seq_num(reorder_cnxt->ptr);
 	if (start_win >= 0) {
-		PRINTM(MINFO, "Flush data %d\n", start_win);
+		dev_dbg(reorder_cnxt->priv->adapter->dev,
+				"info: flush data %d\n", start_win);
 		mwifiex_11n_dispatch_pkt_until_start_win(reorder_cnxt->priv,
 				reorder_cnxt->ptr,
 				((reorder_cnxt->ptr->start_win +
@@ -265,15 +264,10 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
 							 seq_num);
 	else {
-		PRINTM(MDAT_D, "%s: seq_num %d, tid %d, ta %02x:%02x:%02x:%02x:"
-		       "%02x:%02x, win_size %d\n", __func__,
-		       seq_num, tid, ta[0], ta[1], ta[2], ta[3],
-		       ta[4], ta[5], win_size);
-
 		new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl),
 						GFP_KERNEL);
 		if (!new_node) {
-			PRINTM(MERROR, "%s: failed to alloc new_node\n",
+			dev_err(priv->adapter->dev, "%s: failed to alloc new_node\n",
 			       __func__);
 			return;
 		}
@@ -282,31 +276,28 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		new_node->tid = tid;
 		memcpy(new_node->ta, ta, MWIFIEX_MAC_ADDR_LENGTH);
 		new_node->start_win = seq_num;
-		if (mwifiex_queuing_ra_based(priv)) {
+		if (mwifiex_queuing_ra_based(priv))
 			/* TODO for adhoc */
-			PRINTM(MINFO, "UAP/ADHOC:last_seq=%d start_win=%d\n",
+			dev_dbg(priv->adapter->dev,
+					"info: ADHOC:last_seq=%d start_win=%d\n",
 					last_seq, new_node->start_win);
-		} else {
+		else
 			last_seq = priv->rx_seq[tid];
-		}
-		if (last_seq >= new_node->start_win) {
-			PRINTM(MDAT_D, "Update start_win: last_seq=%d, "
-					"start_win=%d\n",
-					last_seq, new_node->start_win);
+
+		if (last_seq >= new_node->start_win)
 			new_node->start_win = last_seq + 1;
-		}
+
 		new_node->win_size = win_size;
 
 		new_node->rx_reorder_ptr = kzalloc(sizeof(void *) * win_size,
 						GFP_KERNEL);
 		if (!new_node->rx_reorder_ptr) {
 			kfree((u8 *) new_node);
-			PRINTM(MERROR, "%s: failed to alloc reorder_ptr\n",
-			       __func__);
+			dev_err(priv->adapter->dev,
+				"%s: failed to alloc reorder_ptr\n", __func__);
 			return;
 		}
 
-		PRINTM(MDAT_D, "Create ReorderPtr: %p\n", new_node);
 		new_node->timer_context.ptr = new_node;
 		new_node->timer_context.priv = priv;
 
@@ -465,9 +456,6 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			return ret;
 		}
 	} else {
-		if (pkt_type == PKT_TYPE_BAR)
-			PRINTM(MDAT_D, "BAR ");
-
 		start_win = rx_reor_tbl_ptr->start_win;
 		win_size = rx_reor_tbl_ptr->win_size;
 		end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
@@ -475,11 +463,6 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		mod_timer(&rx_reor_tbl_ptr->timer_context.timer, jiffies
 			+ (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
 
-		PRINTM(MDAT_D, "TID %d, TA %02x:%02x:%02x:%02x:%02x:%02x\n",
-		       tid, ta[0], ta[1], ta[2], ta[3], ta[4], ta[5]);
-		PRINTM(MDAT_D,
-		       "1:seq_num %d start_win %d win_size %d end_win %d\n",
-		       seq_num, start_win, win_size, end_win);
 		/*
 		 * If seq_num is less then starting win then ignore and drop the
 		 * packet
@@ -503,10 +486,6 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 				((seq_num + win_size) - 1) & (MAX_TID_VALUE -
 							      1);
 
-		PRINTM(MDAT_D,
-		       "2:seq_num %d start_win %d win_size %d end_win %d\n",
-		       seq_num, start_win, win_size, end_win);
-
 		if (((end_win < start_win) && (seq_num < (TWOPOW11 -
 							  (MAX_TID_VALUE -
 							   start_win)))
@@ -528,18 +507,15 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 				return ret;
 		}
 
-		PRINTM(MDAT_D, "3:seq_num %d start_win %d win_size %d"
-		       " end_win %d\n", seq_num, start_win, win_size, end_win);
 		if (pkt_type != PKT_TYPE_BAR) {
 			if (seq_num >= start_win)
 				pkt_index = seq_num - start_win;
 			else
 				pkt_index = (seq_num+MAX_TID_VALUE) - start_win;
 
-			if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index]) {
-				PRINTM(MDAT_D, "Drop Duplicate Pkt\n");
+			if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index])
 				return -1;
-			}
+
 			rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
 		}
 
@@ -572,24 +548,23 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 	else
 		cleanup_rx_reorder_tbl = (initiator) ? false : true;
 
-	PRINTM(MEVENT, "DELBA: %02x:%02x:%02x:%02x:%02x:%02x tid=%d, "
-	       "initiator=%d\n", peer_mac[0],
-	       peer_mac[1], peer_mac[2],
-	       peer_mac[3], peer_mac[4], peer_mac[5], tid, initiator);
+	dev_dbg(priv->adapter->dev, "event: DELBA: %pM tid=%d, "
+	       "initiator=%d\n", peer_mac, tid, initiator);
 
 	if (cleanup_rx_reorder_tbl) {
-		rx_reor_tbl_ptr =
-			mwifiex_11n_get_rx_reorder_tbl(priv, tid,
+		rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 							peer_mac);
 		if (!rx_reor_tbl_ptr) {
-			PRINTM(MWARN, "TID, TA not found in table!\n");
+			dev_dbg(priv->adapter->dev,
+					"event: TID, TA not found in table\n");
 			return;
 		}
 		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, rx_reor_tbl_ptr);
 	} else {
 		ptx_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, peer_mac);
 		if (!ptx_tbl) {
-			PRINTM(MWARN, "TID, RA not found in table!\n");
+			dev_dbg(priv->adapter->dev,
+					"event: TID, RA not found in table\n");
 			return;
 		}
 
@@ -628,26 +603,13 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 			IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
 			>> BLOCKACKPARAM_WINSIZE_POS;
 
-		PRINTM(MCMND,
-		       "ADDBA RSP: %02x:%02x:%02x:%02x:%02x:%02x tid=%d ",
-		       "ssn = %d win_size = %d\n",
-		       add_ba_rsp->peer_mac_addr[0],
-		       add_ba_rsp->peer_mac_addr[1],
-		       add_ba_rsp->peer_mac_addr[2],
-		       add_ba_rsp->peer_mac_addr[3],
-		       add_ba_rsp->peer_mac_addr[4],
-		       add_ba_rsp->peer_mac_addr[5],
+		dev_dbg(priv->adapter->dev, "cmd: ADDBA RSP: %pM"
+		       " tid=%d ssn=%d win_size=%d\n",
+		       add_ba_rsp->peer_mac_addr,
 		       tid, add_ba_rsp->ssn, win_size);
 	} else {
-		PRINTM(MERROR,
-			"ADDBA RSP: Failed(%02x:%02x:%02x:%02x:%02x:%02x "
-			"tid=%d)\n",
-		       add_ba_rsp->peer_mac_addr[0],
-		       add_ba_rsp->peer_mac_addr[1],
-		       add_ba_rsp->peer_mac_addr[2],
-		       add_ba_rsp->peer_mac_addr[3],
-		       add_ba_rsp->peer_mac_addr[4],
-		       add_ba_rsp->peer_mac_addr[5], tid);
+		dev_err(priv->adapter->dev, "ADDBA RSP: failed %pM tid=%d)\n",
+					add_ba_rsp->peer_mac_addr, tid);
 
 		rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv,
 					tid, add_ba_rsp->peer_mac_addr);
@@ -669,8 +631,6 @@ mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_11n_delba delba;
 
-	DBG_HEXDUMP(MCMD_D, "Event:", (u8 *) event, 20);
-
 	memset(&delba, 0, sizeof(struct host_cmd_ds_11n_delba));
 	memcpy(delba.peer_mac_addr, event->peer_mac_addr,
 	       MWIFIEX_MAC_ADDR_LENGTH);
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 5f1ae33..be52fd2 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -161,53 +161,6 @@ info
 	tx_pending = <number of Tx packet pending>
 	rx_pending = <number of Rx packet pending>
 
-drvdbg
-	This command is used to set/get the bit masks of driver debug message control.
-
-	Usage:
-		cat drvdbg
-		echo "[n] [m]" > drvdbg
-
-	Where the parameter <n> is the generic debug message control bit mask.
-	The following types of driver debug messages can be dynamically enabled or
-	disabled by setting or clearing the corresponding bits,
-		bit 0:  MMSG  		PRINTM(MMSG,...)
-		bit 1:  MFATAL		PRINTM(MFATAL,...)
-		bit 2:  MERROR		PRINTM(MERROR,...)
-		bit 3:  MDATA 		PRINTM(MDATA,...)
-		bit 4:  MCMND 		PRINTM(MCMND,...)
-		bit 5:  MEVENT		PRINTM(MEVENT,...)
-		bit 6:  MINTR 		PRINTM(MINTR,...)
-		...
-		bit 16: MDAT_D		PRINTM(MDAT_D,...), DBG_HEXDUMP(MDAT_D,...)
-		bit 17: MCMD_D		PRINTM(MCMD_D,...), DBG_HEXDUMP(MCMD_D,...)
-		bit 18: MFW_D		PRINTM(MFW_D,...)
-		...
-		bit 29: MWARN 		PRINTM(MWARN,...)
-		bit 30: MINFO 		PRINTM(MINFO,...)
-
-	Where the parameter <m> is the extended interface module debug message control
-	bit mask. The following types of debug messages can be controlled.
-
-		bit 0:  MIF_D 		PRINTM(MIF_D,...),  DBG_HEXDUMP(MIF_D,...)
-
-	By default MMSG, MFATAL and MERROR are enabled. The values of <m> and <n> should
-	be in hex
-
-	Some special debug messages,
-		'*'		// driver ISR is called (bit 6 MINTR enabled)
-		'|'		// PS awake event is received (bit 5 MEVENT enabled)
-		'_'		// PS sleep event is received (bit 5 MEVENT enabled)
-		'+'		// PS sleep confirm is sent (bit 5 MEVENT enabled)
-
-	Examples:
-		cat drvdbg                      : Get the current driver debug masks
-		echo "0 0" > drvdbg             : Disable all the debug messages
-		echo 7 > drvdbg                 : Enable MMSG, MFATAL and MERROR messages,
-		                                  no change for if debug control
-		echo "3 1" > drvdbg             : Enable MMSG and MFATAL messages,
-		                                  enable MIF_D message
-		echo "0xffffffff 0xffffffff" > drvdbg       : Enable all the debug messages
 
 3) FOR DRIVER CONFIGURATION
 mpactrl
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 105543b..1e1b397 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -176,11 +176,11 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 
 	ret = mwifiex_set_encode(priv, 0, NULL, 0, key_index, 1);
 	if (ret) {
-		PRINTM(MERROR, "Error deleting the crypto keys\n");
+		wiphy_err(wiphy, "deleting the crypto keys\n");
 		return -EFAULT;
 	}
 
-	PRINTM(MINFO, "Crypto keys deleted\n");
+	wiphy_dbg(wiphy, "info: crypto keys deleted\n");
 	return 0;
 }
 
@@ -216,8 +216,8 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 
 	if (timeout)
-		PRINTM(MINFO,
-		       "Ignoring the timeout value for ieee power save\n");
+		wiphy_dbg(wiphy,
+			"info: ignoring the timeout value for IEEE power save\n");
 
 	ret = mwifiex_drv_set_power(priv, enabled);
 
@@ -250,7 +250,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 	ret = mwifiex_set_encode(priv, params->cipher, params->key,
 				 params->key_len, key_index, 0);
 
-	PRINTM(MINFO, "Crypto keys added\n");
+	wiphy_dbg(wiphy, "info: crypto keys added\n");
 
 	if (ret)
 		return -EFAULT;
@@ -288,7 +288,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 
 	band = mwifiex_band_to_radio_type(adapter->config_bands);
 	if (!wiphy->bands[band]) {
-		PRINTM(MERROR, "11D: Error setting domain info in FW\n");
+		wiphy_err(wiphy, "11D: setting domain info in FW\n");
 		return -1;
 	}
 
@@ -339,7 +339,7 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 			HostCmd_CMD_802_11D_DOMAIN_INFO,
 			HostCmd_ACT_GEN_SET, 0, NULL, NULL);
 	if (ret)
-		PRINTM(MERROR, "11D: Error setting domain info in FW\n");
+		wiphy_err(wiphy, "11D: setting domain info in FW\n");
 
 	return ret;
 }
@@ -360,8 +360,8 @@ static int mwifiex_reg_notifier(struct wiphy *wiphy,
 	struct mwifiex_private *priv = (struct mwifiex_private *)
 				mwifiex_cfg80211_get_priv(wiphy);
 
-	PRINTM(MINFO, "cfg80211 regulatory domain callback for domain \
-			%c%c\n", request->alpha2[0], request->alpha2[1]);
+	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for domain"
+			" %c%c\n", request->alpha2[0], request->alpha2[1]);
 
 	memcpy(priv->country_code, request->alpha2, sizeof(request->alpha2));
 
@@ -428,8 +428,8 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
 
-	PRINTM(MINFO, "Setting band %d, channel offset %d and mode = %d\n",
-	       config_bands, band_cfg.sec_chan_offset, mode);
+	wiphy_dbg(wiphy, "info: setting band %d, channel offset %d and "
+		"mode %d\n", config_bands, band_cfg.sec_chan_offset, mode);
 
 	if (chan) {
 		memset(&cfp, 0, sizeof(cfp));
@@ -463,7 +463,7 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy,
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 
 	if (mwifiex_get_assoc_status(priv)) {
-		PRINTM(MERROR, "This configuration is valid only when station "
+		wiphy_err(wiphy, "This setting is valid only when station "
 				"is not connected\n");
 		return -EINVAL;
 	}
@@ -591,17 +591,17 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_ADHOC:
 		mode = MWIFIEX_BSS_MODE_IBSS;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_ADHOC;
-		PRINTM(MINFO, "Setting interface type to adhoc\n");
+		wiphy_dbg(wiphy, "info: setting interface type to adhoc\n");
 		break;
 	case NL80211_IFTYPE_STATION:
 		mode = MWIFIEX_BSS_MODE_INFRA;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
-		PRINTM(MINFO, "Setting interface type to managed\n");
+		wiphy_dbg(wiphy, "info: Setting interface type to managed\n");
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 		mode = MWIFIEX_BSS_MODE_AUTO;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
-		PRINTM(MINFO, "Setting interface type to auto\n");
+		wiphy_dbg(wiphy, "info: setting interface type to auto\n");
 		break;
 	default:
 		ret = -EINVAL;
@@ -645,12 +645,12 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	/* Get signal information from the firmware */
 	memset(&signal, 0, sizeof(struct mwifiex_ds_get_signal));
 	if (mwifiex_get_signal_info(priv, MWIFIEX_IOCTL_WAIT, &signal)) {
-		PRINTM(MERROR, "Error getting signal information\n");
+		dev_err(priv->adapter->dev, "getting signal information\n");
 		ret = -EFAULT;
 	}
 
 	if (mwifiex_drv_get_data_rate(priv, &rate)) {
-		PRINTM(MERROR, "Error getting data rate\n");
+		dev_err(priv->adapter->dev, "getting data rate\n");
 		ret = -EFAULT;
 	}
 
@@ -807,8 +807,8 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
 		return -EFAULT;
 
-	PRINTM(MINFO, "Successfully disconnected from %pM: Reason code %d\n",
-	       priv->cfg_bssid, reason_code);
+	wiphy_dbg(wiphy, "info: successfully disconnected from %pM:"
+		" reason code %d\n", priv->cfg_bssid, reason_code);
 
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
 
@@ -918,7 +918,8 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 #define MAX_IE_BUF	2048
 	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
 	if (!ie_buf) {
-		PRINTM(MERROR, "%s: failed to allocate ie_buf\n", __func__);
+		dev_err(priv->adapter->dev, "%s: failed to alloc ie_buf\n",
+						__func__);
 		return -ENOMEM;
 	}
 
@@ -973,8 +974,9 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 			element_len = *(beacon + 1);
 			if (beacon_size < (int) element_len +
 			    sizeof(struct ieee_types_header)) {
-				PRINTM(MERROR, "Get scan: Error in processing"
-				       " IE, bytes left < IE length\n");
+				dev_err(priv->adapter->dev, "%s: in processing"
+					" IE, bytes left < IE length\n",
+					__func__);
 				break;
 			}
 			switch (element_id) {
@@ -1047,13 +1049,13 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 
 	req_ssid.ssid_len = ssid_len;
 	if (ssid_len > IW_ESSID_MAX_SIZE) {
-		PRINTM(MERROR, "Invalid SSID - aborting\n");
+		dev_err(priv->adapter->dev, "invalid SSID - aborting\n");
 		return -EINVAL;
 	}
 
 	memcpy(req_ssid.ssid, ssid, ssid_len);
 	if (!req_ssid.ssid_len || req_ssid.ssid[0] < 0x20) {
-		PRINTM(MERROR, "Invalid SSID - aborting\n");
+		dev_err(priv->adapter->dev, "invalid SSID - aborting\n");
 		return -EINVAL;
 	}
 
@@ -1108,14 +1110,13 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 				mwifiex_is_alg_wep(pairwise_encrypt_mode) |
 				mwifiex_is_alg_wep(group_encrypt_mode);
 			if (alg_is_wep) {
-				PRINTM(MINFO, "Setting wep encryption with "
-						"key len %d\n",
-						sme->key_len);
+				dev_dbg(priv->adapter->dev,
+					"info: setting wep encryption"
+					" with key len %d\n", sme->key_len);
 				ret = mwifiex_set_wep_keys(priv, sme->key,
 							   sme->key_len,
 							   sme->key_idx);
 			}
-
 		}
 	} else {
 		if (privacy) {
@@ -1135,7 +1136,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 
 	/* Do specific SSID scanning */
 	if (mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &req_ssid)) {
-		PRINTM(MERROR, "Scan error\n");
+		dev_err(priv->adapter->dev, "scan error\n");
 		return -EFAULT;
 	}
 
@@ -1153,7 +1154,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			return -EFAULT;
 	}
 
-	PRINTM(MINFO, "Trying to associate to %s and bssid %pM\n",
+	dev_dbg(priv->adapter->dev, "info: trying to associate to %s and bssid %pM\n",
 	       (char *) req_ssid.ssid, ssid_bssid.bssid);
 
 	memcpy(&priv->cfg_bssid, ssid_bssid.bssid, 6);
@@ -1196,14 +1197,14 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
 
 	if (mode == MWIFIEX_BSS_MODE_IBSS) {
-		PRINTM(MERROR, "Received assoc infra request "
+		wiphy_err(wiphy, "received infra assoc request "
 				"when station is in ibss mode\n");
 		goto done;
 	}
 
 	priv->assoc_request = 1;
 
-	PRINTM(MINFO, "Trying to associate to %s and bssid %pM\n",
+	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
 	       (char *) sme->ssid, sme->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
@@ -1235,14 +1236,14 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
 	if (mode != MWIFIEX_BSS_MODE_IBSS) {
-		PRINTM(MERROR, "Request to join ibss received "
+		wiphy_err(wiphy, "request to join ibss received "
 				"when station is not in ibss mode\n");
 		goto done;
 	}
 
 	priv->ibss_join_request = 1;
 
-	PRINTM(MINFO, "Trying to join to %s and bssid %pM\n",
+	wiphy_dbg(wiphy, "info: trying to join to %s and bssid %pM\n",
 	       (char *) params->ssid, params->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
@@ -1271,7 +1272,8 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 
 	priv->disconnect = 1;
 
-	PRINTM(MINFO, "Disconnecting from essid %pM\n", priv->cfg_bssid);
+	wiphy_dbg(wiphy, "info: disconnecting from essid %pM\n",
+			priv->cfg_bssid);
 	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
 		return -EFAULT;
 
@@ -1294,7 +1296,7 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
 
-	PRINTM(MINFO, "Received scan request on %s\n", dev->name);
+	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
 	if (priv->scan_request && priv->scan_request != request)
 		return -EBUSY;
@@ -1385,7 +1387,8 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
-		PRINTM(MERROR, "Error allocating wireless device\n");
+		dev_err(priv->adapter->dev, "%s: allocating wireless device\n",
+						__func__);
 		return -ENOMEM;
 	}
 	wdev->wiphy =
@@ -1426,11 +1429,14 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 
 	ret = wiphy_register(wdev->wiphy);
 	if (ret < 0) {
-		PRINTM(MERROR, "Error registering cfg80211 device\n");
+		dev_err(priv->adapter->dev, "%s: registering cfg80211 device\n",
+						__func__);
 		wiphy_free(wdev->wiphy);
 		return ret;
-	} else
-		PRINTM(MINFO, "Successfully registered wiphy device\n");
+	} else {
+		dev_dbg(priv->adapter->dev,
+				"info: successfully registered wiphy device\n");
+	}
 
 	dev_net_set(dev, wiphy_net(wdev->wiphy));
 	dev->ieee80211_ptr = wdev;
@@ -1495,7 +1501,8 @@ mwifiex_cfg80211_results(struct work_struct *work)
 			ret = -EFAULT;
 done:
 		priv->scan_result_status = ret;
-		PRINTM(MINFO, "Sending scan results\n");
+		dev_dbg(priv->adapter->dev, "info: %s: sending scan results\n",
+							__func__);
 		cfg80211_scan_done(priv->scan_request,
 				(priv->scan_result_status < 0));
 		priv->scan_request = NULL;
@@ -1507,10 +1514,12 @@ done:
 						NULL, 0, NULL, 0,
 						WLAN_STATUS_SUCCESS,
 						GFP_KERNEL);
-			PRINTM(MINFO, "Associated to bssid %pM successfully\n",
+			dev_dbg(priv->adapter->dev,
+				"info: associated to bssid %pM successfully\n",
 			       priv->cfg_bssid);
 		} else {
-			PRINTM(MINFO, "Association to bssid %pM failed\n",
+			dev_dbg(priv->adapter->dev,
+				"info: association to bssid %pM failed\n",
 			       priv->cfg_bssid);
 			memset(priv->cfg_bssid, 0, ETH_ALEN);
 		}
@@ -1522,11 +1531,12 @@ done:
 		if (!priv->ibss_join_result) {
 			cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid,
 					     GFP_KERNEL);
-			PRINTM(MINFO, "Joined/Created adhoc network with bssid"
+			dev_dbg(priv->adapter->dev,
+				"info: joined/created adhoc network with bssid"
 					" %pM successfully\n", priv->cfg_bssid);
 		} else {
-			PRINTM(MINFO, "Failed creating/joining adhoc "
-					"network\n");
+			dev_dbg(priv->adapter->dev,
+				"info: failed creating/joining adhoc network\n");
 		}
 		priv->ibss_join_request = 0;
 		priv->ibss_join_result = 0;
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 43e2fb8..f337af5 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -184,9 +184,8 @@ mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
 		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
 
 	if (!sband) {
-		PRINTM(MERROR, "mwifiex_get_cfp_by_band_and_channel_"
-				"from_cfg80211(): cannot find cfp "
-				"by band %d & channel %d\n", band, channel);
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & channel %d\n", __func__, band, channel);
 		return cfp;
 	}
 
@@ -203,9 +202,8 @@ mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
 		}
 	}
 	if (i == sband->n_channels)
-		PRINTM(MERROR, "mwifiex_get_cfp_by_band_and_channel_"
-				"from_cfg80211(): cannot find cfp "
-				"by band %d & channel %d\n", band, channel);
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & channel %d\n", __func__, band, channel);
 
 	return cfp;
 }
@@ -229,9 +227,8 @@ mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
 		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
 
 	if (!sband) {
-		PRINTM(MERROR, "mwifiex_get_cfp_by_band_and_freq_from_"
-				"cfg80211: cannot find cfp by "
-				"band %d & freq %d\n", band, freq);
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & freq %d\n", __func__, band, freq);
 		return cfp;
 	}
 
@@ -247,9 +244,8 @@ mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
 		}
 	}
 	if (i == sband->n_channels)
-		PRINTM(MERROR, "mwifiex_get_cfp_by_band_and_freq_from_"
-				"cfg80211: cannot find cfp by "
-				"band %d & freq %d\n", band, freq);
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & freq %d\n", __func__, band, freq);
 
 	return cfp;
 }
@@ -306,15 +302,15 @@ mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		/* Infra. mode */
 		switch (adapter->config_bands) {
 		case BAND_B:
-			PRINTM(MINFO, "Infra Band=%d supported_rates_b\n",
-			       adapter->config_bands);
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_b\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_b,
 					       sizeof(supported_rates_b));
 			break;
 		case BAND_G:
 		case BAND_G | BAND_GN:
-			PRINTM(MINFO, "Infra band=%d supported_rates_g\n",
-			       adapter->config_bands);
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_g\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_g,
 					       sizeof(supported_rates_g));
 			break;
@@ -323,28 +319,28 @@ mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		case BAND_A | BAND_B:
 		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN:
 		case BAND_B | BAND_G | BAND_GN:
-			PRINTM(MINFO, "Infra band=%d supported_rates_bg\n",
-			       adapter->config_bands);
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_bg\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_bg,
 					       sizeof(supported_rates_bg));
 			break;
 		case BAND_A:
 		case BAND_A | BAND_G:
-			PRINTM(MINFO, "Infra band=%d supported_rates_a\n",
-			       adapter->config_bands);
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_a\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_a,
 					       sizeof(supported_rates_a));
 			break;
 		case BAND_A | BAND_AN:
 		case BAND_A | BAND_G | BAND_AN | BAND_GN:
-			PRINTM(MINFO, "Infra band=%d supported_rates_a\n",
-			       adapter->config_bands);
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_a\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_a,
 					       sizeof(supported_rates_a));
 			break;
 		case BAND_GN:
-			PRINTM(MINFO, "Infra band=%d supported_rates_n\n",
-			       adapter->config_bands);
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_n\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_n,
 					       sizeof(supported_rates_n));
 			break;
@@ -353,25 +349,25 @@ mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		/* Ad-hoc mode */
 		switch (adapter->adhoc_start_band) {
 		case BAND_B:
-			PRINTM(MINFO, "Adhoc B\n");
+			dev_dbg(adapter->dev, "info: adhoc B\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_b,
 					       sizeof(adhoc_rates_b));
 			break;
 		case BAND_G:
 		case BAND_G | BAND_GN:
-			PRINTM(MINFO, "Adhoc G only\n");
+			dev_dbg(adapter->dev, "info: adhoc G only\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_g,
 					       sizeof(adhoc_rates_g));
 			break;
 		case BAND_B | BAND_G:
 		case BAND_B | BAND_G | BAND_GN:
-			PRINTM(MINFO, "Adhoc BG\n");
+			dev_dbg(adapter->dev, "info: adhoc BG\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_bg,
 					       sizeof(adhoc_rates_bg));
 			break;
 		case BAND_A:
 		case BAND_A | BAND_AN:
-			PRINTM(MINFO, "Adhoc A\n");
+			dev_dbg(adapter->dev, "info: adhoc A\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_a,
 					       sizeof(adhoc_rates_a));
 			break;
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 45e1bf2..41b5d87 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -58,8 +58,7 @@ mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 
 	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
 	if (list_empty(&adapter->cmd_free_q)) {
-		PRINTM(MERROR,
-		       "GET_CMD_NODE: struct cmd_ctrl_node is not available\n");
+		dev_err(adapter->dev, "GET_CMD_NODE: cmd node not available\n");
 		spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
 		return NULL;
 	}
@@ -138,7 +137,7 @@ static int mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
 
 	/* Copy the HOST command to command buffer */
 	memcpy((void *) cmd, pcmd_ptr->cmd, pcmd_ptr->len);
-	PRINTM(MCMND, "Host command size = %d\n", pcmd_ptr->len);
+	dev_dbg(priv->adapter->dev, "cmd: host cmd size = %d\n", pcmd_ptr->len);
 	return 0;
 }
 
@@ -172,9 +171,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	/* Sanity test */
 	if (host_cmd == NULL || host_cmd->size == 0) {
-		PRINTM(MERROR,
-		       "DNLD_CMD: host_cmd is null or command size is zero, "
-		       "Not sending\n");
+		dev_err(adapter->dev, "DNLD_CMD: host_cmd is null"
+			" or cmd size is 0, not sending\n");
 		if (wait_queue)
 			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
@@ -198,12 +196,11 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	skb_trim(cmd_node->cmd_skb, cmd_size);
 
 	do_gettimeofday(&tstamp);
-	PRINTM(MCMND,
-	       "DNLD_CMD (%lu.%lu): 0x%x, act 0x%x, len %d, seqno 0x%x\n",
-	       tstamp.tv_sec, tstamp.tv_usec, cmd_code,
+	dev_dbg(adapter->dev, "cmd: DNLD_CMD: (%lu.%lu): %#x, act %#x, len %d,"
+		" seqno %#x\n",
+		tstamp.tv_sec, tstamp.tv_usec, cmd_code,
 	       le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
 	       le16_to_cpu(host_cmd->seq_num));
-	DBG_HEXDUMP(MCMD_D, "DNLD_CMD", (u8 *) host_cmd, cmd_size);
 
 	skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
 
@@ -212,7 +209,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 					     cmd_node->cmd_skb->len, NULL);
 
 	if (ret == -1) {
-		PRINTM(MERROR, "DNLD_CMD: Host to Card Failed\n");
+		dev_err(adapter->dev, "DNLD_CMD: host to card failed\n");
 		if (wait_queue)
 			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
@@ -254,7 +251,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 {
 	int ret = 0;
-	static u32 i;
 	u16 cmd_len = 0;
 	struct mwifiex_private *priv;
 	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf =
@@ -269,15 +265,13 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 					 priv->bss_type)));
 	adapter->seq_num++;
 
-	DBG_HEXDUMP(MCMD_D, "SLEEP_CFM", &sleep_cfm_buf->ps_cfm_sleep, cmd_len);
-
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
 					     adapter->sleep_cfm->data,
 					     adapter->sleep_cfm->len +
 					     INTF_HEADER_LEN, NULL);
 
 	if (ret == -1) {
-		PRINTM(MERROR, "SLEEP_CFM: failed\n");
+		dev_err(adapter->dev, "SLEEP_CFM: failed\n");
 		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure++;
 		return -1;
 	} else {
@@ -302,11 +296,6 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 					 true);
 			}
 		}
-#define NUM_SC_PER_LINE         16
-		if (++i % NUM_SC_PER_LINE == 0)
-			PRINTM(MEVENT, "+\n");
-		else
-			PRINTM(MEVENT, "+");
 	}
 
 	return ret;
@@ -334,7 +323,8 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	buf_size = sizeof(struct cmd_ctrl_node) * MWIFIEX_NUM_OF_CMD_BUFFER;
 	cmd_array = kzalloc(buf_size, GFP_KERNEL);
 	if (!cmd_array) {
-		PRINTM(MERROR, "%s: failed to alloc cmd_array\n", __func__);
+		dev_err(adapter->dev, "%s: failed to alloc cmd_array\n",
+				__func__);
 		return -1;
 	}
 
@@ -346,8 +336,7 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 		cmd_array[i].skb =
 			dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (!cmd_array[i].skb) {
-			PRINTM(MERROR,
-			       "ALLOC_CMD_BUF: pcmd_buf: out of memory\n");
+			dev_err(adapter->dev, "ALLOC_CMD_BUF: out of memory\n");
 			return -1;
 		}
 	}
@@ -370,8 +359,8 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	u32 i;
 
 	/* Need to check if cmd pool is allocated or not */
-	if (adapter->cmd_pool == NULL) {
-		PRINTM(MINFO, "FREE_CMD_BUF: cmd_pool is Null\n");
+	if (!adapter->cmd_pool) {
+		dev_dbg(adapter->dev, "info: FREE_CMD_BUF: cmd_pool is null\n");
 		return 0;
 	}
 
@@ -380,17 +369,17 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	/* Release shared memory buffers */
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
 		if (cmd_array[i].skb) {
-			PRINTM(MCMND, "Free all the command buffer.\n");
+			dev_dbg(adapter->dev, "cmd: free cmd buffer %d\n", i);
 			dev_kfree_skb_any(cmd_array[i].skb);
 		}
-		if (cmd_array[i].resp_skb) {
-			mwifiex_recv_complete(adapter, cmd_array[i].resp_skb,
-					      0);
-		}
+
+		if (cmd_array[i].resp_skb)
+			mwifiex_recv_complete(adapter,
+						cmd_array[i].resp_skb, 0);
 	}
 	/* Release struct cmd_ctrl_node */
 	if (adapter->cmd_pool) {
-		PRINTM(MCMND, "Free command pool.\n");
+		dev_dbg(adapter->dev, "cmd: free cmd pool\n");
 		kfree(adapter->cmd_pool);
 		adapter->cmd_pool = NULL;
 	}
@@ -440,7 +429,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 
 	if (eventcause != EVENT_PS_SLEEP && eventcause != EVENT_PS_AWAKE) {
 		do_gettimeofday(&tstamp);
-		PRINTM(MEVENT, "%lu.%lu : Event: 0x%x\n",
+		dev_dbg(adapter->dev, "event: %lu.%lu: cause: %#x\n",
 		       tstamp.tv_sec, tstamp.tv_usec, eventcause);
 	}
 
@@ -475,25 +464,24 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct host_cmd_ds_command *cmd_ptr = NULL;
 
-	/* Sanity test */
-	if (adapter->is_suspended) {
-		PRINTM(MERROR, "PREP_CMD: Device in suspended state\n");
+	if (!adapter) {
+		pr_err("PREP_CMD: adapter is NULL\n");
 		return -1;
 	}
 
-	if (adapter == NULL) {
-		PRINTM(MERROR, "PREP_CMD: adapter is NULL\n");
+	if (adapter->is_suspended) {
+		dev_err(adapter->dev, "PREP_CMD: device in suspended state\n");
 		return -1;
 	}
 
 	if (adapter->surprise_removed) {
-		PRINTM(MERROR, "PREP_CMD: Card is Removed\n");
+		dev_err(adapter->dev, "PREP_CMD: card is removed\n");
 		return -1;
 	}
 
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET) {
 		if (cmd_no != HostCmd_CMD_FUNC_INIT) {
-			PRINTM(MERROR, "PREP_CMD: FW is in reset state\n");
+			dev_err(adapter->dev, "PREP_CMD: FW in reset state\n");
 			return -1;
 		}
 	}
@@ -501,8 +489,8 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	/* Get a new command node */
 	cmd_node = mwifiex_get_cmd_node(adapter);
 
-	if (cmd_node == NULL) {
-		PRINTM(MERROR, "PREP_CMD: No free cmd node\n");
+	if (!cmd_node) {
+		dev_err(adapter->dev, "PREP_CMD: no free cmd node\n");
 		return -1;
 	}
 
@@ -510,7 +498,7 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, wait_queue, data_buf);
 
 	if (!cmd_node->cmd_skb) {
-		PRINTM(MERROR, "PREP_CMD: No free cmd buf\n");
+		dev_err(adapter->dev, "PREP_CMD: no free cmd buf\n");
 		return -1;
 	}
 
@@ -532,8 +520,8 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 	/* Return error, since the command preparation failed */
 	if (ret) {
-		PRINTM(MERROR, "PREP_CMD: Command 0x%x preparation failed\n",
-		       cmd_no);
+		dev_err(adapter->dev, "PREP_CMD: cmd %#x preparation failed\n",
+							cmd_no);
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		return -1;
 	}
@@ -596,8 +584,8 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 	unsigned long flags;
 
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
-	if (host_cmd == NULL) {
-		PRINTM(MERROR, "QUEUE_CMD: host_cmd is NULL\n");
+	if (!host_cmd) {
+		dev_err(adapter->dev, "QUEUE_CMD: host_cmd is NULL\n");
 		return;
 	}
 
@@ -621,7 +609,7 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 		list_add(&cmd_node->list, &adapter->cmd_pending_q);
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
-	PRINTM(MCMND, "QUEUE_CMD: cmd=0x%x is queued\n", command);
+	dev_dbg(adapter->dev, "cmd: QUEUE_CMD: cmd=%#x is queued\n", command);
 
 	return;
 }
@@ -648,8 +636,7 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 
 	/* Check if already in processing */
 	if (adapter->curr_cmd) {
-		PRINTM(MERROR,
-		       "EXEC_NEXT_CMD: there is command in processing!\n");
+		dev_err(adapter->dev, "EXEC_NEXT_CMD: cmd in processing\n");
 		return -1;
 	}
 
@@ -672,8 +659,8 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	priv = cmd_node->priv;
 
 	if (adapter->ps_state != PS_STATE_AWAKE) {
-		PRINTM(MERROR, "Cannot send command in sleep state"
-				", this should not happen\n");
+		dev_err(adapter->dev, "%s: cannot send cmd in sleep state,"
+				" this should not happen\n", __func__);
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
 				       cmd_flags);
 		return ret;
@@ -727,7 +714,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_skb) {
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
-		PRINTM(MERROR, "CMD_RESP: NULL curr_cmd, 0x%x\n",
+		dev_err(adapter->dev, "CMD_RESP: NULL curr_cmd, %#x\n",
 		       le16_to_cpu(resp->command));
 		return -1;
 	}
@@ -738,14 +725,10 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	adapter->num_cmd_timeout = 0;
 
-	DBG_HEXDUMP(MCMD_D, "CMD_RESP",
-		    adapter->curr_cmd->resp_skb->data,
-		    adapter->curr_cmd->resp_skb->len);
-
 	resp = (struct host_cmd_ds_command *)
 					adapter->curr_cmd->resp_skb->data;
 	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
-		PRINTM(MERROR, "CMD_RESP: 0x%x been canceled!\n",
+		dev_err(adapter->dev, "CMD_RESP: %#x been canceled\n",
 				le16_to_cpu(resp->command));
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
@@ -758,7 +741,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		/* Copy original response back to response buffer */
 		struct mwifiex_ds_misc_cmd *hostcmd = NULL;
 		uint16_t size = le16_to_cpu(resp->size);
-		PRINTM(MINFO, "host command response size = %d\n", size);
+		dev_dbg(adapter->dev, "info: host cmd resp size = %d\n", size);
 		size = min_t(u16, size, MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (adapter->curr_cmd->data_buf) {
 			hostcmd = (struct mwifiex_ds_misc_cmd *)
@@ -788,13 +771,13 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		orig_cmdresp_no;
 
 	do_gettimeofday(&tstamp);
-	PRINTM(MCMND,
-	       "CMD_RESP (%lu.%lu): 0x%x, result %d, len %d, seqno 0x%x\n",
+	dev_dbg(adapter->dev, "cmd: CMD_RESP: (%lu.%lu): 0x%x, result %d,"
+		" len %d, seqno 0x%x\n",
 	       tstamp.tv_sec, tstamp.tv_usec, orig_cmdresp_no, cmdresp_result,
 	       le16_to_cpu(resp->size), le16_to_cpu(resp->seq_num));
 
 	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
-		PRINTM(MERROR, "CMD_RESP: Invalid response to command!\n");
+		dev_err(adapter->dev, "CMD_RESP: invalid cmd resp\n");
 		if (wait_queue)
 			wait_queue->status = MWIFIEX_ERROR_FW_CMDRESP;
 
@@ -819,8 +802,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	/* Check init command response */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING) {
 		if (ret == -1) {
-			PRINTM(MERROR, "cmd 0x%02x failed during "
-				       "initialization\n", cmdresp_no);
+			dev_err(adapter->dev, "%s: cmd %#x failed during "
+				"initialization\n", __func__, cmdresp_no);
 			mwifiex_init_fw_complete(adapter);
 			return -1;
 		} else if (adapter->last_init_cmd == cmdresp_no)
@@ -857,12 +840,11 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct timeval tstamp;
-	u8 i;
 
 	adapter->num_cmd_timeout++;
 	adapter->dbg.num_cmd_timeout++;
 	if (!adapter->curr_cmd) {
-		PRINTM(MWARN, "CurCmd Empty\n");
+		dev_dbg(adapter->dev, "cmd: empty curr_cmd\n");
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
@@ -879,55 +861,44 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 			adapter->dbg.last_cmd_act[adapter->dbg.
 						    last_cmd_index];
 		do_gettimeofday(&tstamp);
-		PRINTM(MERROR, "Timeout cmd id (%lu.%lu) = 0x%x, act = 0x%x\n",
+		dev_err(adapter->dev, "%s: Timeout cmd id (%lu.%lu) = %#x,"
+			" act = %#x\n", __func__,
 		       tstamp.tv_sec, tstamp.tv_usec,
 		       adapter->dbg.timeout_cmd_id,
 		       adapter->dbg.timeout_cmd_act);
 
-		PRINTM(MERROR, "num_data_h2c_failure = %d\n",
+		dev_err(adapter->dev, "num_data_h2c_failure = %d\n",
 		       adapter->dbg.num_tx_host_to_card_failure);
-		PRINTM(MERROR, "num_cmd_h2c_failure = %d\n",
+		dev_err(adapter->dev, "num_cmd_h2c_failure = %d\n",
 		       adapter->dbg.num_cmd_host_to_card_failure);
 
-		PRINTM(MERROR, "num_cmd_timeout = %d\n",
+		dev_err(adapter->dev, "num_cmd_timeout = %d\n",
 		       adapter->dbg.num_cmd_timeout);
-		PRINTM(MERROR, "num_tx_timeout = %d\n",
+		dev_err(adapter->dev, "num_tx_timeout = %d\n",
 		       adapter->dbg.num_tx_timeout);
 
-		PRINTM(MERROR, "last_cmd_index = %d\n",
+		dev_err(adapter->dev, "last_cmd_index = %d\n",
 		       adapter->dbg.last_cmd_index);
-		PRINTM(MERROR, "last_cmd_id = ");
-		for (i = 0; i < DBG_CMD_NUM; i++)
-			PRINTM(MERROR, "0x%x ", adapter->dbg.last_cmd_id[i]);
-
-		PRINTM(MERROR, "\n");
-		PRINTM(MERROR, "last_cmd_act = ");
-		for (i = 0; i < DBG_CMD_NUM; i++)
-			PRINTM(MERROR, "0x%x ", adapter->dbg.last_cmd_act[i]);
+		print_hex_dump_bytes("last_cmd_id: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_cmd_id, DBG_CMD_NUM);
+		print_hex_dump_bytes("last_cmd_act: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_cmd_act, DBG_CMD_NUM);
 
-		PRINTM(MERROR, "\n");
-		PRINTM(MERROR, "last_cmd_resp_index = %d\n",
+		dev_err(adapter->dev, "last_cmd_resp_index = %d\n",
 		       adapter->dbg.last_cmd_resp_index);
-		PRINTM(MERROR, "last_cmd_resp_id = ");
-		for (i = 0; i < DBG_CMD_NUM; i++) {
-			PRINTM(MERROR, "0x%x ",
-			       adapter->dbg.last_cmd_resp_id[i]);
-		}
-		PRINTM(MERROR, "\n");
+		print_hex_dump_bytes("last_cmd_resp_id: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_cmd_resp_id, DBG_CMD_NUM);
 
-		PRINTM(MERROR, "last_event_index = %d\n",
+		dev_err(adapter->dev, "last_event_index = %d\n",
 		       adapter->dbg.last_event_index);
-		PRINTM(MERROR, "last_event = ");
-		for (i = 0; i < DBG_CMD_NUM; i++)
-			PRINTM(MERROR, "0x%x ", adapter->dbg.last_event[i]);
-
-		PRINTM(MERROR, "\n");
+		print_hex_dump_bytes("last_event: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_event, DBG_CMD_NUM);
 
-		PRINTM(MERROR, "data_sent=%d cmd_sent=%d\n",
+		dev_err(adapter->dev, "data_sent=%d cmd_sent=%d\n",
 		       adapter->data_sent, adapter->cmd_sent);
 
-		PRINTM(MERROR, "ps_mode=%d ps_state=%d\n", adapter->ps_mode,
-		       adapter->ps_state);
+		dev_err(adapter->dev, "ps_mode=%d ps_state=%d\n",
+				adapter->ps_mode, adapter->ps_state);
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
@@ -1089,7 +1060,8 @@ mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter)) {
 		mwifiex_dnld_sleep_confirm_cmd(adapter);
 	} else {
-		PRINTM(MCMND, "Delay Sleep Confirm (%s%s%s)\n",
+		dev_dbg(adapter->dev,
+			"cmd: Delay Sleep Confirm (%s%s%s)\n",
 		       (adapter->cmd_sent) ? "D" : "",
 		       (adapter->curr_cmd) ? "C" : "",
 		       (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
@@ -1107,14 +1079,15 @@ mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 	if (activated) {
 		if (priv->adapter->is_hs_configured) {
 			priv->adapter->hs_activated = true;
-			PRINTM(MEVENT, "hs_actived\n");
+			dev_dbg(priv->adapter->dev, "event: hs_activated\n");
 			priv->adapter->hs_activate_wait_q_woken = true;
 			wake_up_interruptible(
 				&priv->adapter->hs_activate_wait_q);
-		} else
-			PRINTM(MWARN, "hs_activated: HS not configured !!!\n");
+		} else {
+			dev_dbg(priv->adapter->dev, "event: HS not configured\n");
+		}
 	} else {
-		PRINTM(MEVENT, "hs_deactived\n");
+		dev_dbg(priv->adapter->dev, "event: hs_deactivated\n");
 		priv->adapter->hs_activated = false;
 	}
 }
@@ -1131,7 +1104,8 @@ mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv)
 		/* simulate HSCFG_CANCEL command */
 		mwifiex_cancel_hs(priv, MWIFIEX_NO_WAIT);
 	else
-		PRINTM(MWARN, "hs_wakeup: Host Sleep not configured !!!\n");
+		dev_dbg(priv->adapter->dev, "event: %s: HS not configured\n",
+						__func__);
 }
 
 /*
@@ -1156,10 +1130,9 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 		mwifiex_hs_activated_event(priv, true);
 		return 0;
 	} else {
-		PRINTM(MCMND,
-		       "CMD_RESP: HS_CFG cmd reply result=%#x, "
-		       " conditions=0x%x gpio=0x%x gap=0x%x\n", resp->result,
-		       conditions,
+		dev_dbg(adapter->dev, "cmd: CMD_RESP: HS_CFG cmd reply"
+			" result=%#x, conditions=0x%x gpio=0x%x gap=0x%x\n",
+			resp->result, conditions,
 		       phs_cfg->params.hs_config.gpio,
 		       phs_cfg->params.hs_config.gap);
 	}
@@ -1181,8 +1154,9 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 void
 mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 {
-	PRINTM(MINFO, "Auto Cancelling host sleep since there is some "
-			"interrupt from the firmware\n");
+	dev_dbg(adapter->dev, "info: %s: auto cancelling host sleep"
+		" since there is interrupt from the firmware\n", __func__);
+
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
 	adapter->is_hs_configured = false;
@@ -1209,7 +1183,7 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	uint16_t seq_num = le16_to_cpu(cmd->seq_num);
 
 	if (!upld_len) {
-		PRINTM(MERROR, "Command size is 0\n");
+		dev_err(adapter->dev, "%s: cmd size is 0\n", __func__);
 		return;
 	}
 
@@ -1226,15 +1200,15 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	command &= HostCmd_CMD_ID_MASK;
 
 	if (command != HostCmd_CMD_802_11_PS_MODE_ENH) {
-		PRINTM(MERROR, "Received unexpected response for command "
-				"%x, result = %x\n",
+		dev_err(adapter->dev, "%s: received unexpected response for"
+				" cmd %x, result = %x\n", __func__,
 				command, result);
 		return;
 	}
-	PRINTM(MEVENT, "#\n");
 
 	if (result) {
-		PRINTM(MERROR, "Sleep confirm command failed\n");
+		dev_err(adapter->dev, "%s: sleep confirm cmd failed\n",
+						__func__);
 		adapter->pm_wakeup_card_req = false;
 		adapter->ps_state = PS_STATE_AWAKE;
 		return;
@@ -1301,7 +1275,7 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 						   mwifiex_ie_types_header));
 			cmd_size += sizeof(struct mwifiex_ie_types_ps_param);
 			tlv += sizeof(struct mwifiex_ie_types_ps_param);
-			PRINTM(MCMND, "PS Command: Enter PS\n");
+			dev_dbg(adapter->dev, "cmd: PS Command: Enter PS\n");
 			ps_mode->null_pkt_interval =
 				cpu_to_le16(adapter->null_pkt_interval);
 			ps_mode->multiple_dtims =
@@ -1340,7 +1314,8 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 				idletime =
 					((struct mwifiex_ds_auto_ds *)
 					 data_buf)->idle_time;
-			PRINTM(MCMND, "PS Command: Enter Auto Deep Sleep\n");
+			dev_dbg(priv->adapter->dev,
+					"cmd: PS Command: Enter Auto Deep Sleep\n");
 			auto_ds->deep_sleep_timeout = cpu_to_le16(idletime);
 		}
 		cmd->size = cpu_to_le16(cmd_size);
@@ -1367,27 +1342,25 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 	uint16_t auto_ps_bitmap =
 		le16_to_cpu(ps_mode->params.auto_ps.ps_bitmap);
 
-	PRINTM(MINFO, "CMD_RESP: PS_MODE cmd reply result=%#x action=0x%X\n",
-	       resp->result, action);
+	dev_dbg(adapter->dev, "info: %s: PS_MODE cmd reply result=%#x action=%#X\n",
+					__func__, resp->result, action);
 	if (action == EN_AUTO_PS) {
 		if (auto_ps_bitmap & BITMAP_AUTO_DS) {
-			PRINTM(MCMND, "Enabled auto deep sleep\n");
+			dev_dbg(adapter->dev, "cmd: Enabled auto deep sleep\n");
 			priv->adapter->is_deep_sleep = true;
 		}
 		if (auto_ps_bitmap & BITMAP_STA_PS) {
-			PRINTM(MCMND, "Enabled STA power save\n");
-			if (adapter->sleep_period.period) {
-				PRINTM(MCMND,
-				       "Setting uapsd/pps mode to TRUE\n");
-			}
+			dev_dbg(adapter->dev, "cmd: Enabled STA power save\n");
+			if (adapter->sleep_period.period)
+				dev_dbg(adapter->dev, "cmd: set to uapsd/pps mode\n");
 		}
 	} else if (action == DIS_AUTO_PS) {
 		if (ps_bitmap & BITMAP_AUTO_DS) {
 			priv->adapter->is_deep_sleep = false;
-			PRINTM(MDATA, "Disabled auto deep sleep\n");
+			dev_dbg(adapter->dev, "cmd: Disabled auto deep sleep\n");
 		}
 		if (ps_bitmap & BITMAP_STA_PS) {
-			PRINTM(MCMND, "Disabled STA power save\n");
+			dev_dbg(adapter->dev, "cmd: Disabled STA power save\n");
 			if (adapter->sleep_period.period) {
 				adapter->delay_null_pkt = false;
 				adapter->tx_lock_flag = false;
@@ -1400,7 +1373,9 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
 		else
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
-		PRINTM(MCMND, "ps_bitmap=0x%x\n", ps_bitmap);
+
+		dev_dbg(adapter->dev, "cmd: ps_bitmap=%#x\n", ps_bitmap);
+
 		if (data_buf) {
 			/* This section is for get power save mode */
 			struct mwifiex_ds_pm_cfg *pm_cfg = (struct
@@ -1499,14 +1474,12 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	adapter->fw_release_number = le32_to_cpu(hw_spec->fw_release_number);
 	adapter->number_of_antenna = le16_to_cpu(hw_spec->number_of_antenna);
 
-	PRINTM(MINFO, "GET_HW_SPEC: fw_release_number- 0x%X\n",
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: fw_release_number- %#x\n",
 	       adapter->fw_release_number);
-	PRINTM(MINFO, "GET_HW_SPEC: Permanent addr- %2x:%2x:%2x:%2x:%2x:%2x\n",
-	       hw_spec->permanent_addr[0], hw_spec->permanent_addr[1],
-	       hw_spec->permanent_addr[2], hw_spec->permanent_addr[3],
-	       hw_spec->permanent_addr[4], hw_spec->permanent_addr[5]);
-	PRINTM(MINFO, "GET_HW_SPEC: hw_if_version=0x%X  version=0x%X\n",
-	       le16_to_cpu(hw_spec->hw_if_version),
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: permanent addr: %pM\n",
+					hw_spec->permanent_addr);
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: hw_if_version=%#x  version=%#x\n",
+		le16_to_cpu(hw_spec->hw_if_version),
 	       le16_to_cpu(hw_spec->version));
 
 	if (priv->curr_addr[0] == 0xff)
@@ -1524,8 +1497,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	/* If it's unidentified region code, use the default (USA) */
 	if (i >= MWIFIEX_MAX_REGION_CODE) {
 		adapter->region_code = 0x10;
-		PRINTM(MWARN,
-		       "unidentified region code, use the default (USA)\n");
+		dev_dbg(adapter->dev, "cmd: unknown region code, use default (USA)\n");
 	}
 
 	adapter->hw_dot_11n_dev_cap = le32_to_cpu(hw_spec->dot_11n_dev_cap);
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 1a1cb47..35011ea 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -533,7 +533,8 @@ mwifiex_txaggrprio_write(struct file *file,
 
 	}
 	if (i != (MAX_NUM_TID * 2)) {
-		PRINTM(MERROR, "Invalid number of parameters %d\n", i);
+		dev_err(priv->adapter->dev,
+				"invalid number of parameters %d\n", i);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -541,10 +542,12 @@ mwifiex_txaggrprio_write(struct file *file,
 	ret = mwifiex_tx_aggr_prio_tbl(priv, data, (MAX_NUM_TID * 2));
 	if (ret) {
 		ret = -EINVAL;
-		PRINTM(MINFO, "Failed setting tx aggr parameters\n");
+		dev_dbg(priv->adapter->dev,
+				"info: Failed setting tx aggr parameters\n");
 	} else {
 		ret = count;
-		PRINTM(MINFO, "Successfully set tx aggr parameters\n");
+		dev_dbg(priv->adapter->dev,
+				"info: Successfully set tx aggr parameters\n");
 	}
 done:
 	kfree(data);
@@ -716,21 +719,23 @@ mwifiex_hscfg_write(struct file *file,
 		ret = mwifiex_set_hs_cfg(priv, cond, gap, ret, false);
 	else {
 		ret = -EINVAL;
-		PRINTM(MERROR, "Invalid action argument %d\n", action);
+		dev_err(priv->adapter->dev, "invalid action argument %d\n",
+							action);
 		goto done;
 	}
 
 	if (ret) {
 		ret = -EINVAL;
-		PRINTM(MINFO, "Host sleep configuration failed\n");
+		dev_err(priv->adapter->dev, "host sleep configuration failed\n");
 	} else {
 		ret = count;
 		if (cond == HOST_SLEEP_CFG_CANCEL)
-			PRINTM(MINFO, "Host sleep cancelled\n");
+			dev_dbg(priv->adapter->dev, "info: host sleep cancelled\n");
 		else if (action == 0)
-			PRINTM(MINFO, "Host sleep configured\n");
+			dev_dbg(priv->adapter->dev, "info: host sleep configured\n");
 		else
-			PRINTM(MINFO, "Host sleep configured and activated\n");
+			dev_dbg(priv->adapter->dev,
+					"info: host sleep configured & activated\n");
 	}
 done:
 	free_page(addr);
@@ -797,10 +802,10 @@ mwifiex_deepsleep_write(struct file *file,
 	sscanf(buf, "%d", &ds);
 
 	if (ds == DEEP_SLEEP_OFF) {
-		PRINTM(MINFO, "Exit Deep Sleep\n");
+		dev_dbg(priv->adapter->dev, "info: Exit Deep Sleep\n");
 		mwifiex_drv_set_deep_sleep(priv, MWIFIEX_IOCTL_WAIT, false, 0);
 	} else if (ds == DEEP_SLEEP_ON) {
-		PRINTM(MINFO, "Enter Deep Sleep\n");
+		dev_dbg(priv->adapter->dev, "info: Enter Deep Sleep\n");
 		mwifiex_drv_set_deep_sleep(priv, MWIFIEX_IOCTL_WAIT, true, 0);
 	} else {
 		ret = -EINVAL;
@@ -1827,68 +1832,6 @@ done:
 }
 
 /*
- * Proc drvdbg file write handler.
- *
- * This function is called when the 'drvdbg' file is opened for writing
- *
- * This function can be used to set the driver debug level.
- */
-static ssize_t
-mwifiex_drvdbg_write(struct file *file,
-		     const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int drv_dbg = -2, if_dbg = -2; /*-1 is a valid value for these fields */
-	int ret = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	sscanf(buf, "%x %x", &drv_dbg, &ifdbg);
-	if (drv_dbg != -2)
-		drvdbg = drv_dbg;
-	if (if_dbg != -2)
-		ifdbg = if_dbg;
-	ret = count;
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc drvdbg file read handler.
- *
- * This function is called when the 'drvdbg' file is opened for reading
- *
- * This function can be used to get the driver debug level.
- */
-static ssize_t
-mwifiex_drvdbg_read(struct file *file, char __user *ubuf,
-		    size_t count, loff_t *ppos)
-{
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	pos += snprintf(buf, PAGE_SIZE, "%x %x\n", drvdbg, ifdbg);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return ret;
-}
-
-/*
  * Proc txbufcfg file write handler.
  *
  * This function is called when the 'txbufcfg' file is opened for writing
@@ -1999,8 +1942,10 @@ mwifiex_passphrase_write(struct file *file,
 	end = mwifiex_strsep(&begin, ';', '/');
 	if (end)
 		action = mwifiex_atox(end);
+
 	if (action < 0 || action > 2 || end[1] != '\0') {
-		PRINTM(MERROR, "Invalid action argument %s\n", end);
+		dev_err(priv->adapter->dev,
+				"invalid action argument %s\n", end);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -2009,26 +1954,26 @@ mwifiex_passphrase_write(struct file *file,
 		end = mwifiex_strsep(&begin, ';', '/');
 		opt = mwifiex_strsep(&end, '=', '/');
 		if (!opt || !end || !end[0]) {
-			PRINTM(MERROR, "Invalid option\n");
+			dev_err(priv->adapter->dev, "invalid option\n");
 			ret = -EINVAL;
 			break;
 		} else if (!strnicmp(opt, "ssid", strlen(opt))) {
 			if (strlen(end) > MWIFIEX_MAX_SSID_LENGTH) {
-				PRINTM(MERROR, "SSID length exceeds max "
-					       "length\n");
+				dev_err(priv->adapter->dev, "SSID length "
+						"exceeds max length\n");
 				ret = -EFAULT;
 				break;
 			}
 			ds_passphrase.ssid.ssid_len = strlen(end);
 			strcpy((char *)ds_passphrase.ssid.ssid, end);
-			PRINTM(MINFO, "ssid=%s, len=%d\n",
+			dev_dbg(priv->adapter->dev, "info: ssid=%s, len=%d\n",
 					ds_passphrase.ssid.ssid,
 					(int)ds_passphrase.ssid.ssid_len);
 		} else if (!strnicmp(opt, "bssid", strlen(opt))) {
 			mwifiex_mac2u8((u8 *)&ds_passphrase.bssid, end);
 		} else if (!strnicmp(opt, "psk", strlen(opt))) {
 			if (strlen(end) != (MWIFIEX_MAX_PMK_LENGTH * 2)) {
-				PRINTM(MERROR, "Invalid PMK length\n");
+				dev_err(priv->adapter->dev, "invalid PMK length\n");
 				ret = -EINVAL;
 				break;
 			}
@@ -2038,8 +1983,8 @@ mwifiex_passphrase_write(struct file *file,
 		} else if (!strnicmp(opt, "passphrase", strlen(opt))) {
 			if (strlen(end) < MWIFIEX_MIN_PASSPHRASE_LENGTH  ||
 				strlen(end) > MWIFIEX_MAX_PASSPHRASE_LENGTH) {
-				PRINTM(MERROR, "Invalid length for "
-					       "passphrase\n");
+				dev_err(priv->adapter->dev,
+						"invalid passphrase length\n");
 				ret = -EINVAL;
 				break;
 			}
@@ -2047,12 +1992,12 @@ mwifiex_passphrase_write(struct file *file,
 			strcpy(ds_passphrase.psk.passphrase.passphrase, end);
 			ds_passphrase.psk.passphrase.passphrase_len =
 								strlen(end);
-			PRINTM(MINFO, "passphrase=%s, len=%d\n",
+			dev_dbg(priv->adapter->dev, "info: passphrase=%s, len=%d\n",
 				ds_passphrase.psk.passphrase.passphrase,
 				(int)ds_passphrase.psk.passphrase
 				.passphrase_len);
 		} else {
-			PRINTM(MERROR, "Invalid option %s\n", opt);
+			dev_err(priv->adapter->dev, "invalid option %s\n", opt);
 			ret = -EINVAL;
 			break;
 		}
@@ -2219,7 +2164,6 @@ MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(antcfg);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
-MWIFIEX_DFS_FILE_OPS(drvdbg);
 MWIFIEX_DFS_FILE_OPS(txbufcfg);
 MWIFIEX_DFS_FILE_OPS(passphrase);
 MWIFIEX_DFS_FILE_READ_OPS(esuppmode);
@@ -2258,7 +2202,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(antcfg);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
-	MWIFIEX_DFS_ADD_FILE(drvdbg);
 	MWIFIEX_DFS_ADD_FILE(txbufcfg);
 	MWIFIEX_DFS_ADD_FILE(passphrase);
 	MWIFIEX_DFS_ADD_FILE(esuppmode);
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 0085bce..f421e77 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -20,6 +20,9 @@
 #ifndef _MWIFIEX_DECL_H_
 #define _MWIFIEX_DECL_H_
 
+#undef pr_fmt
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/wireless.h>
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 7055973..e505714 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -41,7 +41,8 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 
 	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
 	if (!bss_prio) {
-		PRINTM(MERROR, "%s: failed to alloc bss_prio\n", __func__);
+		dev_err(adapter->dev, "%s: failed to alloc bss_prio\n",
+						__func__);
 		return -1;
 	}
 
@@ -168,7 +169,7 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	buf_size = sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP;
 	temp_scan_table = kzalloc(buf_size, GFP_KERNEL);
 	if (!temp_scan_table) {
-		PRINTM(MERROR, "%s: failed to alloc temp_scan_table\n",
+		dev_err(adapter->dev, "%s: failed to alloc temp_scan_table\n",
 		       __func__);
 		return -1;
 	}
@@ -178,7 +179,8 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	/* Allocate command buffer */
 	ret = mwifiex_alloc_cmd_buffer(adapter);
 	if (ret) {
-		PRINTM(MERROR, "Failed to allocate command buffer\n");
+		dev_err(adapter->dev, "%s: failed to alloc cmd buffer\n",
+		       __func__);
 		return -1;
 	}
 
@@ -187,7 +189,8 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 				+ INTF_HEADER_LEN);
 
 	if (!adapter->sleep_cfm) {
-		PRINTM(MERROR, "Failed to allocate sleep cfm\n");
+		dev_err(adapter->dev, "%s: failed to alloc sleep cfm"
+			" cmd buffer\n", __func__);
 		return -1;
 	}
 	skb_reserve(adapter->sleep_cfm, INTF_HEADER_LEN);
@@ -327,7 +330,7 @@ static void
 mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 {
 	if (!adapter) {
-		PRINTM(MERROR, "The adapter is NULL.\n");
+		pr_err("%s: adapter is NULL\n", __func__);
 		return;
 	}
 
@@ -337,12 +340,12 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 	mwifiex_free_lock_list(adapter);
 
 	/* Free command buffer */
-	PRINTM(MINFO, "Free Command buffer\n");
+	dev_dbg(adapter->dev, "info: free cmd buffer\n");
 	mwifiex_free_cmd_buffer(adapter);
 
 	del_timer(&adapter->cmd_timer);
 
-	PRINTM(MINFO, "Free ScanTable\n");
+	dev_dbg(adapter->dev, "info: free scan table\n");
 	kfree(adapter->scan_table);
 	adapter->scan_table = NULL;
 
@@ -535,12 +538,12 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
 	/* wait for mwifiex_process to complete */
 	if (adapter->mwifiex_processing) {
-		PRINTM(MWARN, "mwifiex main processing is still running\n");
+		dev_warn(adapter->dev, "main process is still running\n");
 		return ret;
 	}
 
 	/* shut down mwifiex */
-	PRINTM(MINFO, "Shutdown mwifiex...\n");
+	dev_dbg(adapter->dev, "info: shutdown mwifiex...\n");
 
 	/* Clean up Tx/Rx queues and delete BSS priority table */
 	for (i = 0; i < adapter->priv_num; i++) {
@@ -587,15 +590,17 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	/* Check if firmware is already running */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num, &winner);
 	if (!ret) {
-		PRINTM(MMSG, "WLAN FW already running! Skip FW download\n");
+		dev_notice(adapter->dev,
+				"WLAN FW already running! Skip FW download\n");
 		goto done;
 	}
 	poll_num = MAX_FIRMWARE_POLL_TRIES;
 
 	/* Check if we are the winner for downloading FW */
 	if (!winner) {
-		PRINTM(MMSG,
-		       "Other interface already running! Skip FW download\n");
+		dev_notice(adapter->dev,
+				"Other interface already running!"
+				" Skip FW download\n");
 		poll_num = MAX_MULTI_INTERFACE_POLL_TRIES;
 		goto poll_fw;
 	}
@@ -603,9 +608,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		/* Download firmware with helper */
 		ret = adapter->if_ops.prog_fw(adapter, pmfw);
 		if (ret) {
-			PRINTM(MERROR, "%s: mwifiex_prog_fw_w_helper failed "
-					"with ret=0x%x\n",
-					__func__, ret);
+			dev_err(adapter->dev, "prog_fw failed ret=%#x\n", ret);
 			return ret;
 		}
 	}
@@ -614,7 +617,7 @@ poll_fw:
 	/* Check if the firmware is downloaded successfully or not */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num, NULL);
 	if (ret) {
-		PRINTM(MFATAL, "FW failed to be active in time!\n");
+		dev_err(adapter->dev, "FW failed to be active in time\n");
 		return -1;
 	}
 done:
@@ -644,8 +647,8 @@ mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 		head = &adapter->bss_prio_tbl[i].bss_prio_head;
 		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
 		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
-		PRINTM(MINFO, "Delete BSS priority table, index = %d, i = %d, "
-			      "head = %p, cur = %p\n",
+		dev_dbg(adapter->dev, "info: delete BSS priority table,"
+				" index = %d, i = %d, head = %p, cur = %p\n",
 			      priv->bss_index, i, head, *cur);
 		if (*cur) {
 			spin_lock_irqsave(lock, flags);
@@ -660,9 +663,9 @@ mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 			list_for_each_entry_safe(bssprio_node, tmp_node, head,
 						 list) {
 				if (bssprio_node->priv == priv) {
-					PRINTM(MINFO, "Delete node, node = %p,"
-						      " next = %p\n",
-						      bssprio_node, tmp_node);
+					dev_dbg(adapter->dev, "info: Delete "
+						"node %p, next = %p\n",
+						bssprio_node, tmp_node);
 					spin_lock_irqsave(lock, flags);
 					list_del(&bssprio_node->list);
 					spin_unlock_irqrestore(lock, flags);
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 1a9e868..4294914 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -51,8 +51,8 @@ mwifiex_cmd_append_generic_ie(struct mwifiex_private *priv, u8 **buffer)
 	 *   parameter buffer pointer.
 	 */
 	if (priv->gen_ie_buf_len) {
-		PRINTM(MINFO, "append generic %d to %p\n", priv->gen_ie_buf_len,
-		       *buffer);
+		dev_dbg(priv->adapter->dev, "info: %s: append generic %d to %p\n",
+				__func__, priv->gen_ie_buf_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
 		ie_header.type = cpu_to_le16(TLV_TYPE_PASSTHROUGH);
@@ -95,7 +95,7 @@ mwifiex_cmd_append_generic_ie(struct mwifiex_private *priv, u8 **buffer)
  * in the MAC for the new association after a reassociation attempt.
  */
 static int
-mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *pmriv, u8 **buffer,
+mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 			   struct mwifiex_bssdescriptor *bss_desc)
 {
 	struct mwifiex_ie_types_tsf_timestamp tsf_tlv;
@@ -120,8 +120,8 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *pmriv, u8 **buffer,
 
 	memcpy(&tsf_val, bss_desc->time_stamp, sizeof(tsf_val));
 
-	PRINTM(MINFO, "ASSOC: TSF offset calc: %016llx - %016llx\n",
-	       tsf_val, bss_desc->network_tsf);
+	dev_dbg(priv->adapter->dev, "info: %s: TSF offset calc: %016llx - "
+			"%016llx\n", __func__, tsf_val, bss_desc->network_tsf);
 
 	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
 	*buffer += sizeof(tsf_val);
@@ -148,7 +148,7 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv,
 
 	tmp = kmalloc(rate1_size, GFP_KERNEL);
 	if (!tmp) {
-		PRINTM(MERROR, "%s: failed to alloc tmp\n", __func__);
+		dev_err(priv->adapter->dev, "failed to alloc tmp buf\n");
 		return -ENOMEM;
 	}
 
@@ -166,10 +166,8 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv,
 		}
 	}
 
-	HEXDUMP("rate1 (AP) Rates", tmp, rate1_size);
-	HEXDUMP("rate2 (Card) Rates", rate2, rate2_size);
-	HEXDUMP("Common Rates", ptr, rate1 - ptr);
-	PRINTM(MINFO, "Tx DataRate is set to 0x%X\n", priv->data_rate);
+	dev_dbg(priv->adapter->dev, "info: Tx data rate set to %#x\n",
+						priv->data_rate);
 
 	if (!priv->is_data_rate_auto) {
 		while (*ptr) {
@@ -179,8 +177,9 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv,
 			}
 			ptr++;
 		}
-		PRINTM(MMSG, "Previously set fixed data rate %#x is not "
-		       "compatible with the network\n", priv->data_rate);
+		dev_err(priv->adapter->dev, "previously set fixed data rate %#x"
+			" is not compatible with the network\n",
+			priv->data_rate);
 
 		ret = -1;
 		goto done;
@@ -213,7 +212,8 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 	    (priv, out_rates, MWIFIEX_SUPPORTED_RATES, card_rates,
 	     card_rates_size)) {
 		*out_rates_size = 0;
-		PRINTM(MERROR, "mwifiex_get_common_rates failed\n");
+		dev_err(priv->adapter->dev, "%s: cannot get common rates\n",
+						__func__);
 		return -1;
 	}
 
@@ -240,7 +240,8 @@ mwifiex_update_tsf_timestamps(struct mwifiex_private *priv,
 
 	tsf_delta = new_tsf_base - new_bss_desc->network_tsf;
 
-	PRINTM(MINFO, "TSF: Update TSF timestamps, 0x%016llx -> 0x%016llx\n",
+	dev_dbg(adapter->dev, "info: TSF: update TSF timestamps, "
+		"0x%016llx -> 0x%016llx\n",
 	       new_bss_desc->network_tsf, new_tsf_base);
 
 	for (table_idx = 0; table_idx < adapter->num_in_scan_table;
@@ -274,8 +275,8 @@ mwifiex_cmd_append_wapi_ie(struct mwifiex_private *priv, u8 **buffer)
 	 *   parameter buffer pointer.
 	 */
 	if (priv->wapi_ie_len) {
-		PRINTM(MCMND, "append wapi ie %d to %p\n", priv->wapi_ie_len,
-		       *buffer);
+		dev_dbg(priv->adapter->dev, "cmd: append wapi ie %d to %p\n",
+				priv->wapi_ie_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
 		ie_header.type = cpu_to_le16(TLV_TYPE_WAPI_IE);
@@ -406,7 +407,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
 	memcpy(rates_tlv->rates, rates, rates_size);
 	pos += sizeof(rates_tlv->header) + rates_size;
-	PRINTM(MINFO, "ASSOC_CMD: Rates size = %d\n", rates_size);
+	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: rates size = %d\n",
+					rates_size);
 
 	/* Add the Authentication type to be used for Auth frames if needed */
 	if (priv->sec_info.authentication_mode != MWIFIEX_AUTH_MODE_AUTO) {
@@ -443,13 +445,13 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		       sizeof(struct mwifiex_chan_scan_param_set));
 		chan_tlv->chan_scan_param[0].chan_number =
 			(bss_desc->phy_param_set.ds_param_set.current_chan);
-		PRINTM(MINFO, "Assoc: TLV Chan = %d\n",
+		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Chan = %d\n",
 		       chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
-		PRINTM(MINFO, "Assoc: TLV Band = %d\n",
+		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Band = %d\n",
 		       chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
@@ -476,9 +478,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 					le16_to_cpu(rsn_ie_tlv->header.len));
 			else
 				return -1;
-			HEXDUMP("ASSOC_CMD: RSN IE", (u8 *) rsn_ie_tlv,
-					sizeof(rsn_ie_tlv->header)
-					+ le16_to_cpu(rsn_ie_tlv->header.len));
+
 			pos += sizeof(rsn_ie_tlv->header)
 				+ le16_to_cpu(rsn_ie_tlv->header.len);
 		} else if (priv->sec_info.ewpa_enabled) {
@@ -513,10 +513,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				else
 					return -1;
 
-				HEXDUMP("ASSOC_CMD: RSN IE", (u8 *) rsn_ie_tlv,
-						sizeof(rsn_ie_tlv->header) +
-						le16_to_cpu(
-						rsn_ie_tlv->header.len));
 				pos += sizeof(rsn_ie_tlv->header) +
 					le16_to_cpu(rsn_ie_tlv->header.len);
 			}
@@ -550,10 +546,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				else
 					return -1;
 
-				HEXDUMP("ASSOC_CMD: RSN IE", (u8 *) rsn_ie_tlv,
-						sizeof(rsn_ie_tlv->header) +
-						le16_to_cpu(
-						rsn_ie_tlv->header.len));
 				pos += sizeof(rsn_ie_tlv->header) +
 					le16_to_cpu(rsn_ie_tlv->header.len);
 			}
@@ -588,7 +580,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		SHORT_SLOT_TIME_DISABLED(tmp_cap);
 
 	tmp_cap &= CAPINFO_MASK;
-	PRINTM(MINFO, "ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
+	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
 	       tmp_cap, CAPINFO_MASK);
 	assoc->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
@@ -669,9 +661,6 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
 
-	HEXDUMP("ASSOC_RESP:", (u8 *) &resp->params,
-		(le16_to_cpu(resp->size) - S_DS_GEN));
-
 	priv->assoc_rsp_size = min(le16_to_cpu(resp->size) - S_DS_GEN,
 				     sizeof(priv->assoc_rsp_buf));
 
@@ -679,7 +668,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	if (le16_to_cpu(assoc_rsp->status_code)) {
 		priv->adapter->dbg.num_cmd_assoc_failure++;
-		PRINTM(MERROR, "ASSOC_RESP: Association Failed, "
+		dev_err(priv->adapter->dev, "ASSOC_RESP: association failed, "
 		       "status code = %d, error = 0x%x, a_id = 0x%x\n",
 		       le16_to_cpu(assoc_rsp->status_code),
 		       le16_to_cpu(assoc_rsp->cap_info_bitmap),
@@ -699,7 +688,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	/* Set the attempted BSSID Index to current */
 	bss_desc = priv->attempted_bss_desc;
 
-	PRINTM(MINFO, "ASSOC_RESP: %s\n", bss_desc->ssid.ssid);
+	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: %s\n",
+						bss_desc->ssid.ssid);
 
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor,
@@ -735,7 +725,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 			= ((bss_desc->wmm_ie.qos_info_bitmap &
 				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD) ? 1 : 0);
 
-	PRINTM(MINFO, "ASSOC_RESP: curr_pkt_filter is 0x%x\n",
+	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: curr_pkt_filter is %#x\n",
 	       priv->curr_pkt_filter);
 	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		priv->wpa_is_gtk_set = false;
@@ -752,8 +742,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	}
 
 	if (enable_data)
-		PRINTM(MINFO, "Post association, re-enabling data flow\n");
-
+		dev_dbg(priv->adapter->dev,
+			"info: post association, re-enabling data flow\n");
 
 	/* Reset SNR/NF/RSSI values */
 	priv->data_rssi_last = 0;
@@ -771,7 +761,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	priv->adapter->dbg.num_cmd_assoc_success++;
 
-	PRINTM(MINFO, "ASSOC_RESP: Associated\n");
+	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: associated\n");
 
 	/* Add the ra_list here for infra mode as there will be only 1 ra
 	   always */
@@ -876,7 +866,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid,
 	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid_len);
 
-	PRINTM(MINFO, "ADHOC_S_CMD: SSID = %s\n", adhoc_start->ssid);
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: SSID = %s\n",
+				adhoc_start->ssid);
 
 	memset(bss_desc->ssid.ssid, 0, IW_ESSID_MAX_SIZE);
 	memcpy(bss_desc->ssid.ssid,
@@ -913,12 +904,12 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	}
 
 	if (!priv->adhoc_channel) {
-		PRINTM(MERROR, "ADHOC_S_CMD: adhoc_channel cannot be 0\n");
+		dev_err(adapter->dev, "ADHOC_S_CMD: adhoc_channel cannot be 0\n");
 		return -1;
 	}
 
-	PRINTM(MINFO, "ADHOC_S_CMD: Creating ADHOC on Channel %d\n",
-	       priv->adhoc_channel);
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: creating ADHOC on channel %d\n",
+				priv->adhoc_channel);
 
 	priv->curr_bss_params.bss_descriptor.channel = priv->adhoc_channel;
 	priv->curr_bss_params.band = adapter->adhoc_start_band;
@@ -957,12 +948,13 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			|| priv->sec_info.wpa_enabled
 			|| priv->sec_info.ewpa_enabled) {
 		/* Ad-Hoc capability privacy on */
-		PRINTM(MINFO, "ADHOC_S_CMD: wep_status set, Privacy to WEP\n");
+		dev_dbg(adapter->dev,
+			"info: ADHOC_S_CMD: wep_status set privacy to WEP\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
 		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
 	} else {
-		PRINTM(MWARN, "ADHOC_S_CMD: wep_status NOT set, Setting "
-				"Privacy to ACCEPT ALL\n");
+		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: wep_status NOT set,"
+				" setting privacy to ACCEPT ALL\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
 	}
 
@@ -976,7 +968,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 					  0, NULL, &priv->curr_pkt_filter);
 
 		if (ret) {
-			PRINTM(MERROR,
+			dev_err(adapter->dev,
 			       "ADHOC_S_CMD: G Protection config failed\n");
 			return -1;
 		}
@@ -993,11 +985,11 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	memcpy(&priv->curr_bss_params.data_rates,
 	       &adhoc_start->DataRate, priv->curr_bss_params.num_of_rates);
 
-	PRINTM(MINFO, "ADHOC_S_CMD: Rates=%02x %02x %02x %02x\n",
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%02x %02x %02x %02x\n",
 	       adhoc_start->DataRate[0], adhoc_start->DataRate[1],
 	       adhoc_start->DataRate[2], adhoc_start->DataRate[3]);
 
-	PRINTM(MINFO, "ADHOC_S_CMD: AD HOC Start command is ready\n");
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
 
 	if (IS_SUPPORT_MULTI_BANDS(adapter)) {
 		/* Append a channel TLV */
@@ -1011,7 +1003,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		chan_tlv->chan_scan_param[0].chan_number =
 			(u8) priv->curr_bss_params.bss_descriptor.channel;
 
-		PRINTM(MINFO, "ADHOC_S_CMD: TLV Chan = %d\n",
+		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Chan = %d\n",
 		       chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type
@@ -1027,7 +1019,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				chan_tlv->chan_scan_param[0].radio_type |=
 					SECOND_CHANNEL_BELOW;
 		}
-		PRINTM(MINFO, "ADHOC_S_CMD: TLV Band = %d\n",
+		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Band = %d\n",
 		       chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
@@ -1063,9 +1055,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		else
 			return -1;
 
-		DBG_HEXDUMP(MCMD_D, "ADHOC_S_CMD: RSN IE", (u8 *) rsn_ie_tlv,
-			    sizeof(rsn_ie_tlv->header) +
-			    le16_to_cpu(rsn_ie_tlv->header.len));
 		pos += sizeof(rsn_ie_tlv->header)
 			    + le16_to_cpu(rsn_ie_tlv->header.len);
 		cmd_append_size +=
@@ -1095,9 +1084,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			ht_cap->ht_cap.ampdu_params_info
 					= MAX_RX_AMPDU_SIZE_64K;
 			ht_cap->ht_cap.mcs.rx_mask[0] = 0xff;
-			HEXDUMP("ADHOC_START: HT_CAPABILITIES IE",
-				(u8 *) ht_cap,
-				sizeof(struct mwifiex_ie_types_htcap));
 			pos += sizeof(struct mwifiex_ie_types_htcap);
 			cmd_append_size +=
 				sizeof(struct mwifiex_ie_types_htcap);
@@ -1121,9 +1107,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			ht_info->ht_info.operation_mode =
 				cpu_to_le16(NON_GREENFIELD_STAS);
 			ht_info->ht_info.basic_set[0] = 0xff;
-			HEXDUMP("ADHOC_START: HT_INFORMATION IE",
-				(u8 *) ht_info,
-				sizeof(struct mwifiex_ie_types_htinfo));
 			pos += sizeof(struct mwifiex_ie_types_htinfo);
 			cmd_append_size +=
 				sizeof(struct mwifiex_ie_types_htinfo);
@@ -1192,7 +1175,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 					  HostCmd_ACT_GEN_SET, 0, NULL,
 					  &curr_pkt_filter);
 		if (ret) {
-			PRINTM(MERROR,
+			dev_err(priv->adapter->dev,
 			       "ADHOC_J_CMD: G Protection config failed\n");
 			return -1;
 		}
@@ -1224,20 +1207,13 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 
 	tmp_cap &= CAPINFO_MASK;
 
-	PRINTM(MINFO, "ADHOC_J_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
-	       tmp_cap, CAPINFO_MASK);
+	dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: tmp_cap=%4X"
+			" CAPINFO_MASK=%4lX\n", tmp_cap, CAPINFO_MASK);
 
 	/* Information on BSSID descriptor passed to FW */
-	PRINTM(MINFO,
-	       "ADHOC_J_CMD: BSSID = %02x-%02x-%02x-%02x-%02x-%02x, "
-	       "SSID = %s\n",
-	       adhoc_join->bss_descriptor.bssid[0],
-	       adhoc_join->bss_descriptor.bssid[1],
-	       adhoc_join->bss_descriptor.bssid[2],
-	       adhoc_join->bss_descriptor.bssid[3],
-	       adhoc_join->bss_descriptor.bssid[4],
-	       adhoc_join->bss_descriptor.bssid[5],
-	       adhoc_join->bss_descriptor.ssid);
+	dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: BSSID = %pM, SSID = %s\n",
+				adhoc_join->bss_descriptor.bssid,
+				adhoc_join->bss_descriptor.ssid);
 
 	for (i = 0; bss_desc->supported_rates[i] &&
 			i < MWIFIEX_SUPPORTED_RATES;
@@ -1251,9 +1227,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 	memcpy(adhoc_join->bss_descriptor.data_rates,
 	       bss_desc->supported_rates, rates_size);
 
-	HEXDUMP("Adapted Rates:", adhoc_join->bss_descriptor.data_rates,
-		rates_size);
-
 	/* Copy the adhoc join rates into Current BSS state structure */
 	priv->curr_bss_params.num_of_rates = rates_size;
 	memcpy(&priv->curr_bss_params.data_rates, bss_desc->supported_rates,
@@ -1278,14 +1251,14 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		       sizeof(struct mwifiex_chan_scan_param_set));
 		chan_tlv->chan_scan_param[0].chan_number =
 			(bss_desc->phy_param_set.ds_param_set.current_chan);
-		PRINTM(MINFO, "ADHOC_J_CMD: TLV Chan = %d\n",
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Chan = %d\n",
 		       chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type
 			=
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
-		PRINTM(MINFO, "ADHOC_J_CMD: TLV Band = %d\n",
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Band = %d\n",
 		       chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
@@ -1311,9 +1284,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		else
 			return -1;
 
-		HEXDUMP("ADHOC_JOIN: RSN IE", (u8 *) rsn_ie_tlv,
-			sizeof(rsn_ie_tlv->header)
-			+ le16_to_cpu(rsn_ie_tlv->header.len));
 		pos += sizeof(rsn_ie_tlv->header)
 			+ le16_to_cpu(rsn_ie_tlv->header.len);
 		cmd_append_size +=
@@ -1343,9 +1313,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			else
 				return -1;
 
-			HEXDUMP("ADHOC_JOIN: RSN IE", (u8 *) rsn_ie_tlv,
-				sizeof(rsn_ie_tlv->header) +
-				le16_to_cpu(rsn_ie_tlv->header.len));
 			pos += sizeof(rsn_ie_tlv->header) +
 				le16_to_cpu(rsn_ie_tlv->header.len);
 			cmd_append_size +=
@@ -1375,9 +1342,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			else
 				return -1;
 
-			HEXDUMP("ADHOC_JOIN: RSN IE", (u8 *) rsn_ie_tlv,
-				sizeof(rsn_ie_tlv->header) +
-				le16_to_cpu(rsn_ie_tlv->header.len));
 			pos += sizeof(rsn_ie_tlv->header) +
 				le16_to_cpu(rsn_ie_tlv->header.len);
 			cmd_append_size +=
@@ -1431,7 +1395,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 	/* Join result code 0 --> SUCCESS */
 	if (result) {
-		PRINTM(MERROR, "ADHOC_RESP Failed\n");
+		dev_err(priv->adapter->dev, "ADHOC_RESP: failed\n");
 		if (priv->media_connected)
 			mwifiex_reset_connect_state(priv);
 
@@ -1446,7 +1410,8 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	priv->media_connected = true;
 
 	if (command == HostCmd_CMD_802_11_AD_HOC_START) {
-		PRINTM(MINFO, "ADHOC_S_RESP  %s\n", bss_desc->ssid.ssid);
+		dev_dbg(priv->adapter->dev, "info: ADHOC_S_RESP %s\n",
+				bss_desc->ssid.ssid);
 
 		/* Update the created network descriptor with the new BSSID */
 		memcpy(bss_desc->mac_address,
@@ -1458,7 +1423,8 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 		 * Now the join cmd should be successful.
 		 * If BSSID has changed use SSID to compare instead of BSSID
 		 */
-		PRINTM(MINFO, "ADHOC_J_RESP  %s\n", bss_desc->ssid.ssid);
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_RESP %s\n",
+				bss_desc->ssid.ssid);
 
 		/*
 		 * Make a copy of current BSSID descriptor, only needed for
@@ -1471,14 +1437,10 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 		priv->adhoc_state = ADHOC_JOINED;
 	}
 
-	PRINTM(MINFO, "ADHOC_RESP: Channel = %d\n", priv->adhoc_channel);
-	PRINTM(MINFO, "ADHOC_RESP: BSSID = %02x:%02x:%02x:%02x:%02x:%02x\n",
-	       priv->curr_bss_params.bss_descriptor.mac_address[0],
-	       priv->curr_bss_params.bss_descriptor.mac_address[1],
-	       priv->curr_bss_params.bss_descriptor.mac_address[2],
-	       priv->curr_bss_params.bss_descriptor.mac_address[3],
-	       priv->curr_bss_params.bss_descriptor.mac_address[4],
-	       priv->curr_bss_params.bss_descriptor.mac_address[5]);
+	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: channel = %d\n",
+				priv->adhoc_channel);
+	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: BSSID = %pM\n",
+	       priv->curr_bss_params.bss_descriptor.mac_address);
 
 	if (!netif_carrier_ok(priv->netdev))
 		netif_carrier_on(priv->netdev);
@@ -1545,10 +1507,11 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	PRINTM(MINFO, "Adhoc Channel = %d\n", priv->adhoc_channel);
-	PRINTM(MINFO, "curr_bss_params.channel = %d\n",
+	dev_dbg(priv->adapter->dev, "info: Adhoc Channel = %d\n",
+		priv->adhoc_channel);
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
 	       priv->curr_bss_params.bss_descriptor.channel);
-	PRINTM(MINFO, "curr_bss_params.band = %d\n",
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
 	       priv->curr_bss_params.band);
 
 	ret = mwifiex_prepare_cmd(priv,
@@ -1570,12 +1533,13 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	PRINTM(MINFO, "mwifiex_adhoc_join: CurBss.ssid =%s\n",
+	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid =%s\n",
 	       priv->curr_bss_params.bss_descriptor.ssid.ssid);
-	PRINTM(MINFO, "mwifiex_adhoc_join: CurBss.ssid_len =%u\n",
+	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid_len =%u\n",
 	       priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
-	PRINTM(MINFO, "mwifiex_adhoc_join: ssid =%s\n", bss_desc->ssid.ssid);
-	PRINTM(MINFO, "mwifiex_adhoc_join: ssid len =%u\n",
+	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid =%s\n",
+		bss_desc->ssid.ssid);
+	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid_len =%u\n",
 	       bss_desc->ssid.ssid_len);
 
 	/* Check if the requested SSID is already joined */
@@ -1584,17 +1548,14 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 			      &priv->curr_bss_params.bss_descriptor.ssid) &&
 	    (priv->curr_bss_params.bss_descriptor.bss_mode ==
 	     MWIFIEX_BSS_MODE_IBSS)) {
-
-		PRINTM(MINFO,
-		       "ADHOC_J_CMD: New ad-hoc SSID is the same as current, "
-		       "not attempting to re-join\n");
-
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: new ad-hoc SSID"
+			" is the same as current; not attempting to re-join\n");
 		return -1;
 	}
 
-	PRINTM(MINFO, "curr_bss_params.channel = %d\n",
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
 	       priv->curr_bss_params.bss_descriptor.channel);
-	PRINTM(MINFO, "curr_bss_params.band = %c\n",
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
 	       priv->curr_bss_params.band);
 
 	ret = mwifiex_prepare_cmd(priv,
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index df97e79..1b9d396 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -50,9 +50,6 @@ static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
 	,
 };
 
-u32 drvdbg = MMSG | MFATAL | MERROR;
-u32 ifdbg;
-
 /*
  * This function registers the device and performs all the necessary
  * initializations.
@@ -102,9 +99,8 @@ static int mwifiex_register(void *card,
 				kzalloc(sizeof(struct mwifiex_private),
 					GFP_KERNEL);
 			if (!adapter->priv[i]) {
-				PRINTM(MERROR,
-				       "%s: failed to allocate priv[]\n",
-				       __func__);
+				dev_err(adapter->dev, "%s: failed to alloc priv[%d]\n",
+				       __func__, i);
 				goto error;
 			}
 
@@ -148,7 +144,7 @@ static int mwifiex_register(void *card,
 	return 0;
 
 error:
-	PRINTM(MINFO, "Leave mwifiex_register with error\n");
+	dev_dbg(adapter->dev, "info: leave mwifiex_register with error\n");
 
 	/* Free lock variables */
 	mwifiex_free_lock_list(adapter);
@@ -364,7 +360,7 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 	}
 
 	if (!drv_mode_ptr) {
-		PRINTM(MERROR, "Invalid drv_mode_ptr=%d\n", drv_mode);
+		pr_err("invalid drv_mode=%d\n", drv_mode);
 		return -1;
 	}
 
@@ -396,12 +392,12 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 {
 	if (!adapter) {
-		PRINTM(MERROR, "The adapter is NULL.\n");
+		pr_err("%s: adapter is NULL\n", __func__);
 		return;
 	}
 
 	mwifiex_unregister(adapter);
-	PRINTM(MINFO, "Free Adapter\n");
+	pr_debug("info: %s: free adapter\n", __func__);
 }
 
 /*
@@ -433,11 +429,11 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	default:
 		break;
 	}
-	err = request_firmware(&adapter->firmware, fw_name, adapter->dev);
 
+	err = request_firmware(&adapter->firmware, fw_name, adapter->dev);
 	if (err < 0) {
-		PRINTM(MFATAL, "request_firmware() failed, error code =%#x\n",
-		       err);
+		dev_err(adapter->dev, "request_firmware() returned"
+				" error code %#x\n", err);
 		ret = -1;
 		goto done;
 	}
@@ -448,7 +444,7 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	if (ret == -1)
 		goto done;
 
-	PRINTM(MMSG, "WLAN FW is active\n");
+	dev_notice(adapter->dev, "WLAN FW is active\n");
 
 	adapter->init_wait_q_woken = false;
 	ret = mwifiex_init_fw(adapter);
@@ -495,11 +491,11 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 	case __constant_htons(ETH_P_IP):
 		iph = ip_hdr(skb);
 		tid = IPTOS_PREC(iph->tos);
-		PRINTM(MDATA, "packet type ETH_P_IP:04x, tid=%#x prio=%#x\n",
+		pr_debug("data: packet type ETH_P_IP: %04x, tid=%#x prio=%#x\n",
 		       eth->h_proto, tid, skb->priority);
 		break;
 	case __constant_htons(ETH_P_ARP):
-		PRINTM(MDATA, "ARP packet04x\n", eth->h_proto);
+		pr_debug("data: ARP packet: %04x\n", eth->h_proto);
 	default:
 		break;
 	}
@@ -551,8 +547,8 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct sk_buff *new_skb = NULL;
 	struct mwifiex_txinfo *tx_info;
 
-	PRINTM(MDATA, "%lu BSS(%d): Data <= kernel\n", jiffies,
-	       priv->bss_index);
+	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d): Data <= kernel\n",
+				jiffies, priv->bss_index);
 
 	if (priv->adapter->surprise_removed) {
 		kfree(skb);
@@ -560,27 +556,28 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return 0;
 	}
 	if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
-		PRINTM(MERROR, "Tx Error: Bad skb lengthd : %d\n",
-		       skb->len, ETH_FRAME_LEN);
+		dev_err(priv->adapter->dev, "Tx: bad skb len %d\n", skb->len);
 		kfree(skb);
 		priv->stats.tx_dropped++;
 		return 0;
 	}
 	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
-		PRINTM(MWARN, "Tx: Insufficient skb headroomd\n",
+		dev_dbg(priv->adapter->dev,
+			"data: Tx: insufficient skb headroom %d\n",
 		       skb_headroom(skb));
 		/* Insufficient skb headroom - allocate a new skb */
 		new_skb =
 			skb_realloc_headroom(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
 		if (unlikely(!new_skb)) {
-			PRINTM(MERROR, "Tx: Cannot allocate skb\n");
+			dev_err(priv->adapter->dev, "Tx: cannot alloca new_skb\n");
 			kfree(skb);
 			priv->stats.tx_dropped++;
 			return 0;
 		}
 		kfree_skb(skb);
 		skb = new_skb;
-		PRINTM(MINFO, "new skb headroomd\n", skb_headroom(skb));
+		dev_dbg(priv->adapter->dev, "info: new skb headroomd %d\n",
+				skb_headroom(skb));
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
@@ -610,17 +607,12 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
 	struct sockaddr *hw_addr = (struct sockaddr *) addr;
 
-	memset(priv->curr_addr, 0, ETH_ALEN);
-	/* dev->dev_addr is 6 bytes */
-	HEXDUMP("dev->dev_addr:", dev->dev_addr, ETH_ALEN);
-
-	HEXDUMP("addr:", (u8 *) hw_addr->sa_data, ETH_ALEN);
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
+
 	if (mwifiex_request_set_mac_address(priv)) {
-		PRINTM(MERROR, "Set MAC address failed\n");
+		dev_err(priv->adapter->dev, "set MAC address failed\n");
 		return -EFAULT;
 	}
-	HEXDUMP("priv->MacAddr:", priv->curr_addr, ETH_ALEN);
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 
 	return 0;
@@ -645,8 +637,8 @@ mwifiex_tx_timeout(struct net_device *dev)
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
 
-	PRINTM(MERROR, "%lu : Tx timeout, bss_index=%d\n", jiffies,
-	       priv->bss_index);
+	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_index=%d\n",
+				jiffies, priv->bss_index);
 	dev->trans_start = jiffies;
 	priv->num_tx_timeout++;
 }
@@ -733,17 +725,17 @@ static struct mwifiex_private *mwifiex_add_interface(
 	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
 			      ether_setup, 1);
 	if (!dev) {
-		PRINTM(MERROR, "No memory available\n");
+		dev_err(adapter->dev, "no memory available for netdevice\n");
 		goto error;
 	}
 	if (dev_alloc_name(dev, dev->name)) {
-		PRINTM(MFATAL, "Unable to allocate name for netdevice\n");
+		dev_err(adapter->dev, "unable to alloc name for netdevice\n");
 		goto error;
 	}
 
 	if (mwifiex_register_cfg80211(dev, adapter->priv[bss_index]->curr_addr,
 				      adapter->priv[bss_index]) != 0) {
-		PRINTM(MERROR, "Cannot register netdevice with cfg80211\n");
+		dev_err(adapter->dev, "cannot register netdevice with cfg80211\n");
 		goto error;
 	}
 	/* Save the priv pointer in netdev */
@@ -762,11 +754,11 @@ static struct mwifiex_private *mwifiex_add_interface(
 
 	/* Register network device */
 	if (register_netdev(dev)) {
-		PRINTM(MERROR, "Cannot register virtual network device!\n");
+		dev_err(adapter->dev, "cannot register virtual network device\n");
 		goto error;
 	}
 
-	PRINTM(MINFO, "%s: Marvell 802.11 Adapter\n", dev->name);
+	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_init(priv);
 #endif
@@ -807,9 +799,8 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 	mwifiex_dev_debugfs_remove(priv);
 #endif
 	/* Last reference is our one */
-	PRINTM(MINFO, "refcnt = %d\n", netdev_refcnt_read(dev));
-
-	PRINTM(MINFO, "netdev_finish_unregister:s%s\n", dev->name);
+	dev_dbg(adapter->dev, "info: %s: refcnt = %d\n",
+				dev->name, netdev_refcnt_read(dev));
 
 	if (dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(dev);
@@ -1049,7 +1040,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		goto exit_sem_err;
 
 	if (mwifiex_init_sw(card, if_ops, (void **) &adapter)) {
-		PRINTM(MFATAL, "Software Init Failed\n");
+		pr_err("%s: software init failed\n", __func__);
 		goto err_init_sw;
 	}
 
@@ -1073,13 +1064,13 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	/* Register the device. Fill up the private data structure with relevant
 	   information from the card and request for the required IRQ. */
 	if (adapter->if_ops.register_dev(adapter)) {
-		PRINTM(MFATAL, "Failed to register mwifiex device!\n");
+		pr_err("%s: failed to register mwifiex device\n", __func__);
 		goto err_registerdev;
 	}
 
 	/* Init FW and HW */
 	if (mwifiex_init_hw_fw(adapter)) {
-		PRINTM(MFATAL, "Firmware Init Failed\n");
+		pr_err("%s: firmware init failed\n", __func__);
 		goto err_init_fw;
 	}
 	/* Add interfaces */
@@ -1103,7 +1094,7 @@ err_add_intf:
 		mwifiex_remove_interface(adapter, i);
 err_init_fw:
 	/* Unregister device */
-	PRINTM(MINFO, "unregister device\n");
+	pr_debug("info: %s: unregister device\n", __func__);
 	adapter->if_ops.unregister_dev(adapter);
 err_registerdev:
 	adapter->surprise_removed = true;
@@ -1111,7 +1102,7 @@ err_registerdev:
 err_kmalloc:
 	if ((adapter->hw_status == MWIFIEX_HW_STATUS_FW_READY) ||
 	    (adapter->hw_status == MWIFIEX_HW_STATUS_READY)) {
-		PRINTM(MINFO, "shutdown mwifiex\n");
+		pr_debug("info: %s: shutdown mwifiex\n", __func__);
 		adapter->init_wait_q_woken = false;
 		status = mwifiex_shutdown_drv(adapter);
 		if (status == -EINPROGRESS)
@@ -1165,18 +1156,17 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		}
 	}
 
-	/* Shutdown firmware */
-	PRINTM(MCMND, "mwifiex_shutdown_drv.....\n");
+	dev_dbg(adapter->dev, "cmd: calling mwifiex_shutdown_drv...\n");
 	adapter->init_wait_q_woken = false;
 	status = mwifiex_shutdown_drv(adapter);
 	if (status == -EINPROGRESS)
 		wait_event_interruptible(adapter->init_wait_q,
 					 adapter->init_wait_q_woken);
-	PRINTM(MCMND, "mwifiex_shutdown_drv done!\n");
+	dev_dbg(adapter->dev, "cmd: mwifiex_shutdown_drv done\n");
 	if (atomic_read(&adapter->rx_pending) ||
 	    atomic_read(&adapter->tx_pending) ||
 	    atomic_read(&adapter->ioctl_pending)) {
-		PRINTM(MERROR, "ERR: rx_pending=%d, tx_pending=%d, "
+		dev_err(adapter->dev, "rx_pending=%d, tx_pending=%d, "
 		       "ioctl_pending=%d\n",
 		       atomic_read(&adapter->rx_pending),
 		       atomic_read(&adapter->tx_pending),
@@ -1190,10 +1180,10 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	mwifiex_terminate_workqueue(adapter);
 
 	/* Unregister device */
-	PRINTM(MINFO, "unregister device\n");
+	dev_dbg(adapter->dev, "info: unregister device\n");
 	adapter->if_ops.unregister_dev(adapter);
 	/* Free adapter structure */
-	PRINTM(MINFO, "Free Adapter\n");
+	dev_dbg(adapter->dev, "info: free adapter\n");
 	mwifiex_free_adapter(adapter);
 
 exit_remove:
@@ -1233,9 +1223,6 @@ mwifiex_cleanup_module(void)
 module_init(mwifiex_init_module);
 module_exit(mwifiex_cleanup_module);
 
-module_param(drvdbg, int, 0);
-MODULE_PARM_DESC(drvdbg, "Driver debug");
-
 MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex Driver version " VERSION);
 MODULE_VERSION(VERSION);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 924d035..19a9494 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -106,7 +106,7 @@ mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
 		}
 	}
 
-	PRINTM(MINFO, "OUI is not found in PTK\n");
+	pr_debug("info: %s: OUI is not found in PTK\n", __func__);
 	return MWIFIEX_OUI_NOT_PRESENT;
 }
 
@@ -227,10 +227,8 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 		memcpy(ssid_bssid, &tmp_ssid_bssid,
 		       sizeof(struct mwifiex_ssid_bssid));
 		mac = (u8 *) &ssid_bssid->bssid;
-		PRINTM(MCMND,
-		       "Find network: ssid=%s, %02x:%02x:%02x:%02x:%02x:%02x\n",
-		       ssid_bssid->ssid.ssid, mac[0], mac[1], mac[2], mac[3],
-		       mac[4], mac[5]);
+		dev_dbg(priv->adapter->dev, "cmd: found network: ssid=%s,"
+				" %pM\n", ssid_bssid->ssid.ssid, mac);
 	}
 
 done:
@@ -287,7 +285,8 @@ int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
 	int status = 0;
 
 	if (down_interruptible(&priv->async_sem)) {
-		PRINTM(MERROR, "Acquire semaphore error, request_scan\n");
+		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
+						__func__);
 		return -1;
 	}
 	priv->scan_pending_on_block = true;
@@ -356,8 +355,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 	    && (bss_desc->bss_mode == MWIFIEX_BSS_MODE_INFRA))
 		return index;
 
-	if (priv->wps.session_enable == true) {
-		PRINTM(MINFO, "Return success directly in WPS period\n");
+	if (priv->wps.session_enable) {
+		dev_dbg(adapter->dev,
+			"info: return success directly in WPS period\n");
 		return index;
 	}
 
@@ -380,8 +380,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 					CIPHER_SUITE_TKIP) ||
 				   mwifiex_is_rsn_oui_present(bss_desc,
 					CIPHER_SUITE_TKIP)) {
-					PRINTM(MINFO, "Disable 11n if AES is"
-						" not supported by AP\n");
+					dev_dbg(adapter->dev,
+						"info: disable 11n if AES "
+						"is not supported by AP\n");
 					bss_desc->disable_11n = true;
 
 				} else {
@@ -390,8 +391,8 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			}
 			return index;
 		} else {
-			PRINTM(MINFO,
-			       "ewpa_enabled: Ignore none WPA/WPA2 AP\n");
+			dev_dbg(adapter->dev,
+				"info: ewpa_enabled: ignore none WPA/WPA2 AP\n");
 			return -1;
 		}
 	}
@@ -400,7 +401,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 	    (bss_desc->bcn_wapi_ie &&
 	     ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id ==
 			WLAN_EID_BSS_AC_ACCESS_DELAY))) {
-		PRINTM(MINFO, "Return success for WAPI AP\n");
+		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
 		return index;
 	}
 
@@ -424,7 +425,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			   && !priv->sec_info.wpa2_enabled
 			   && bss_desc->privacy) {
 			/* Static WEP enabled */
-			PRINTM(MINFO, "Disable 11n in WEP mode.\n");
+			dev_dbg(adapter->dev, "info: Disable 11n in WEP mode.\n");
 			bss_desc->disable_11n = true;
 			return index;
 		} else if (priv->sec_info.wep_status ==
@@ -440,10 +441,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			    */
 			) {
 			/* WPA enabled */
-			PRINTM(MINFO,
-			       "mwifiex_is_network_compatible() WPA: index=%d"
+			dev_dbg(adapter->dev, "info: %s: WPA: index=%d"
 			       " wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			       "EncMode=%#x privacy=%#x\n", index,
+			       "EncMode=%#x privacy=%#x\n", __func__, index,
 			       (bss_desc->bcn_wpa_ie) ?
 			       (*(bss_desc->bcn_wpa_ie)).
 			       vend_hdr.element_id : 0,
@@ -464,8 +464,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 
 				if (mwifiex_is_wpa_oui_present(bss_desc,
 					    CIPHER_SUITE_TKIP)) {
-					PRINTM(MINFO, "Disable 11n if AES is"
-						" not supported by AP\n");
+					dev_dbg(adapter->dev,
+						"info: Disable 11n if AES "
+						"is not supported by AP\n");
 					bss_desc->disable_11n = true;
 				} else {
 					return -1;
@@ -485,10 +486,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			    */
 			) {
 			/* WPA2 enabled */
-			PRINTM(MINFO,
-			       "mwifiex_is_network_compatible() WPA2: index=%d"
+			dev_dbg(adapter->dev, "info: %s: WPA2: index=%d"
 			       " wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			       "EncMode=%#x privacy=%#x\n", index,
+			       "EncMode=%#x privacy=%#x\n", __func__, index,
 			       (bss_desc->bcn_wpa_ie) ?
 			       (*(bss_desc->bcn_wpa_ie)).
 			       vend_hdr.element_id : 0,
@@ -509,8 +509,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 
 				if (mwifiex_is_rsn_oui_present(bss_desc,
 					    CIPHER_SUITE_TKIP)) {
-					PRINTM(MINFO, "Disable 11n if AES is"
-						" not supported by AP\n");
+					dev_dbg(adapter->dev,
+						"info: Disable 11n if AES "
+						"is not supported by AP\n");
 					bss_desc->disable_11n = true;
 				} else {
 					return -1;
@@ -544,10 +545,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			   && priv->sec_info.encryption_mode !=
 			   MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
 			/* Dynamic WEP enabled */
-			PRINTM(MINFO, "mwifiex_is_network_compatible() dynamic "
+			dev_dbg(adapter->dev, "info: %s: dynamic "
 					"WEP: index=%d wpa_ie=%#x wpa2_ie=%#x "
 					"EncMode=%#x privacy=%#x\n",
-					index,
+					__func__, index,
 					(bss_desc->bcn_wpa_ie) ?
 					(*(bss_desc->bcn_wpa_ie)).
 					vend_hdr.element_id : 0,
@@ -560,11 +561,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 		}
 
 		/* Security doesn't match */
-		PRINTM(MINFO,
-		       "mwifiex_is_network_compatible() FAILED: index=%d "
+		dev_dbg(adapter->dev, "info: %s: failed: index=%d "
 		       "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s EncMode"
 		       "=%#x privacy=%#x\n",
-		       index,
+		       __func__, index,
 		       (bss_desc->bcn_wpa_ie) ?
 		       (*(bss_desc->bcn_wpa_ie)).vend_hdr.
 		       element_id : 0,
@@ -598,7 +598,8 @@ mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
 	s32 best_rssi = 0;
 	u32 i;
 
-	PRINTM(MINFO, "Num of BSSIDs = %d\n", adapter->num_in_scan_table);
+	dev_dbg(adapter->dev, "info: num of BSSIDs = %d\n",
+				adapter->num_in_scan_table);
 
 	for (i = 0; i < adapter->num_in_scan_table; i++) {
 		switch (mode) {
@@ -726,7 +727,8 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	u32 done_early;
 
 	if (!scan_cfg_out || !chan_tlv_out || !scan_chan_list) {
-		PRINTM(MINFO, "Scan: Null detect: %p, %p, %p\n",
+		dev_dbg(priv->adapter->dev,
+			"info: Scan: Null detect: %p, %p, %p\n",
 		       scan_cfg_out, chan_tlv_out, scan_chan_list);
 		return -1;
 	}
@@ -760,9 +762,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		while (tlv_idx < max_chan_per_scan
 		       && tmp_chan_list->chan_number && !done_early) {
 
-			PRINTM(MINFO,
-			       "Scan: Chan(%3d), Radio(%d), Mode(%d, %d), "
-			       "Dur(%d)\n",
+			dev_dbg(priv->adapter->dev,
+				"info: Scan: Chan(%3d), Radio(%d),"
+				" Mode(%d, %d), Dur(%d)\n",
 			       tmp_chan_list->chan_number,
 			       tmp_chan_list->radio_type,
 			       tmp_chan_list->chan_scan_mode_bitmap
@@ -837,10 +839,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		/* The total scan time should be less than scan command timeout
 		   value */
 		if (total_scan_time > MWIFIEX_MAX_TOTAL_SCAN_TIME) {
-			PRINTM(MMSG,
-			       "Total scan time %d ms is over limit (%d ms), "
-			       "scan skipped\n",
-			       total_scan_time, MWIFIEX_MAX_TOTAL_SCAN_TIME);
+			dev_err(priv->adapter->dev, "total scan time %dms"
+				" is over limit (%dms), scan skipped\n",
+				total_scan_time, MWIFIEX_MAX_TOTAL_SCAN_TIME);
 			ret = -1;
 			break;
 		}
@@ -993,7 +994,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 			tlv_pos += (sizeof(wildcard_ssid_tlv->header)
 				+ le16_to_cpu(wildcard_ssid_tlv->header.len));
 
-			PRINTM(MINFO, "Scan: ssid_list[%d]: %s, %d\n",
+			dev_dbg(adapter->dev, "info: scan: ssid_list[%d]: %s, %d\n",
 			       ssid_idx,
 			       wildcard_ssid_tlv->ssid,
 			       wildcard_ssid_tlv->max_ssid_length);
@@ -1037,7 +1038,8 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	   add tlv */
 	if (num_probes) {
 
-		PRINTM(MINFO, "Scan: num_probes = %d\n", num_probes);
+		dev_dbg(adapter->dev, "info: scan: num_probes = %d\n",
+						num_probes);
 
 		num_probes_tlv =
 			(struct mwifiex_ie_types_num_probes *) tlv_pos;
@@ -1063,7 +1065,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	memcpy(rates_tlv->rates, rates, rates_size);
 	tlv_pos += sizeof(rates_tlv->header) + rates_size;
 
-	PRINTM(MINFO, "SCAN_CMD: Rates size = %d\n", rates_size);
+	dev_dbg(adapter->dev, "info: SCAN_CMD: Rates size = %d\n", rates_size);
 
 	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
 	    && (priv->adapter->config_bands & BAND_GN
@@ -1074,8 +1076,6 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		ht_cap->header.len =
 				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		mwifiex_fill_cap_info(priv, ht_cap);
-		HEXDUMP("SCAN: HT_CAPABILITIES IE", (u8 *) ht_cap,
-			sizeof(struct mwifiex_ie_types_htcap));
 		tlv_pos += sizeof(struct mwifiex_ie_types_htcap);
 	}
 
@@ -1093,7 +1093,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 
 	if (user_scan_in && user_scan_in->chan_list[0].chan_number) {
 
-		PRINTM(MINFO, "Scan: Using supplied channel list\n");
+		dev_dbg(adapter->dev, "info: Scan: Using supplied channel list\n");
 
 		for (chan_idx = 0;
 		     chan_idx < MWIFIEX_USER_SCAN_CHAN_MAX
@@ -1147,11 +1147,13 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		    && (user_scan_in->chan_list[0].chan_number
 			== priv->curr_bss_params.bss_descriptor.channel)) {
 			*scan_current_only = true;
-			PRINTM(MINFO, "Scan: Scanning current channel only\n");
+			dev_dbg(adapter->dev,
+				"info: Scan: Scanning current channel only\n");
 		}
 
 	} else {
-		PRINTM(MINFO, "Scan: Creating full region channel list\n");
+		dev_dbg(adapter->dev,
+				"info: Scan: Creating full region channel list\n");
 		mwifiex_scan_create_channel_list(priv, user_scan_in,
 						 scan_chan_list,
 						 *filtered_scan);
@@ -1183,7 +1185,8 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 	tlv_buf_left = tlv_buf_size;
 	*tlv_data = NULL;
 
-	PRINTM(MINFO, "SCAN_RESP: tlv_buf_size = %d\n", tlv_buf_size);
+	dev_dbg(adapter->dev, "info: SCAN_RESP: tlv_buf_size = %d\n",
+						tlv_buf_size);
 
 	while (tlv_buf_left >= sizeof(struct mwifiex_ie_types_header)) {
 
@@ -1191,31 +1194,27 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 		tlv_len = le16_to_cpu(current_tlv->header.len);
 
 		if (sizeof(tlv->header) + tlv_len > tlv_buf_left) {
-			PRINTM(MERROR, "SCAN_RESP: TLV buffer corrupt\n");
+			dev_err(adapter->dev, "SCAN_RESP: TLV buffer corrupt\n");
 			break;
 		}
 
 		if (req_tlv_type == tlv_type) {
 			switch (tlv_type) {
 			case TLV_TYPE_TSFTIMESTAMP:
-				PRINTM(MINFO,
-				       "SCAN_RESP: TSF Timestamp TLV, len = "
-				       "%d\n",
-				       tlv_len);
+				dev_dbg(adapter->dev, "info: SCAN_RESP: TSF "
+					"timestamp TLV, len = %d\n", tlv_len);
 				*tlv_data = (struct mwifiex_ie_types_data *)
 					current_tlv;
 				break;
 			case TLV_TYPE_CHANNELBANDLIST:
-				PRINTM(MINFO,
-				       "SCAN_RESP: CHANNEL BAND LIST TLV, len "
-				       "= %d\n",
-				       tlv_len);
+				dev_dbg(adapter->dev, "info: SCAN_RESP: channel"
+					" band list TLV, len = %d\n", tlv_len);
 				*tlv_data = (struct mwifiex_ie_types_data *)
 					current_tlv;
 				break;
 			default:
-				PRINTM(MERROR,
-				       "SCAN_RESP: Unhandled TLV = %d\n",
+				dev_err(adapter->dev,
+					"SCAN_RESP: unhandled TLV = %d\n",
 				       tlv_type);
 				/* Give up, this seems corrupted */
 				return;
@@ -1312,17 +1311,14 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	bytes_left_for_current_beacon = beacon_size;
 
 	memcpy(bss_entry->mac_address, current_ptr, MWIFIEX_MAC_ADDR_LENGTH);
-	PRINTM(MINFO,
-	       "InterpretIE: AP MAC Addr-%02x:%02x:%02x:%02x:%02x:%02x\n",
-	       bss_entry->mac_address[0], bss_entry->mac_address[1],
-	       bss_entry->mac_address[2], bss_entry->mac_address[3],
-	       bss_entry->mac_address[4], bss_entry->mac_address[5]);
+	dev_dbg(adapter->dev, "info: InterpretIE: AP MAC Addr: %pM\n",
+						bss_entry->mac_address);
 
 	current_ptr += MWIFIEX_MAC_ADDR_LENGTH;
 	bytes_left_for_current_beacon -= MWIFIEX_MAC_ADDR_LENGTH;
 
 	if (bytes_left_for_current_beacon < 12) {
-		PRINTM(MERROR, "InterpretIE: Not enough bytes left\n");
+		dev_err(adapter->dev, "InterpretIE: not enough bytes left\n");
 		return -1;
 	}
 
@@ -1333,7 +1329,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 	/* RSSI is 1 byte long */
 	bss_entry->rssi = (s32) (*current_ptr);
-	PRINTM(MINFO, "InterpretIE: RSSI=%02X\n", *current_ptr);
+	dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%02X\n", *current_ptr);
 	current_ptr += 1;
 	bytes_left_for_current_beacon -= 1;
 
@@ -1359,21 +1355,18 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 	/* Capability information is 2 bytes long */
 	memcpy(&fixed_ie.capabilities, current_ptr, 2);
-	PRINTM(MINFO, "InterpretIE: fixed_ie.capabilities=0x%X\n",
+	dev_dbg(adapter->dev, "info: InterpretIE: fixed_ie.capabilities=0x%X\n",
 	       fixed_ie.capabilities);
 	bss_entry->cap_info_bitmap = le16_to_cpu(fixed_ie.capabilities);
 	current_ptr += 2;
 	bytes_left_for_current_beacon -= 2;
 
 	/* Rest of the current buffer are IE's */
-	PRINTM(MINFO, "InterpretIE: IELength for this AP = %d\n",
+	dev_dbg(adapter->dev, "info: InterpretIE: IELength for this AP = %d\n",
 	       bytes_left_for_current_beacon);
 
-	HEXDUMP("InterpretIE: IE info", (u8 *) current_ptr,
-		bytes_left_for_current_beacon);
-
 	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
-		PRINTM(MINFO, "InterpretIE: AP WEP enabled\n");
+		dev_dbg(adapter->dev, "info: InterpretIE: AP WEP enabled\n");
 		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
 	} else {
 		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
@@ -1392,8 +1385,8 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		total_ie_len = element_len + sizeof(struct ieee_types_header);
 
 		if (bytes_left_for_current_beacon < total_ie_len) {
-			PRINTM(MERROR, "InterpretIE: Error in processing IE, "
-			       "bytes left < IE length\n");
+			dev_err(adapter->dev, "err: InterpretIE: in processing"
+				" IE, bytes left < IE length\n");
 			bytes_left_for_current_beacon = 0;
 			ret = -1;
 			continue;
@@ -1404,7 +1397,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->ssid.ssid_len = element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
-			PRINTM(MINFO, "InterpretIE: ssid: %-32s\n",
+			dev_dbg(adapter->dev, "info: InterpretIE: ssid: %-32s\n",
 			       bss_entry->ssid.ssid);
 			break;
 
@@ -1413,8 +1406,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			       element_len);
 			memcpy(bss_entry->supported_rates, current_ptr + 2,
 			       element_len);
-			HEXDUMP("InterpretIE: SupportedRates:",
-				bss_entry->supported_rates, element_len);
 			rate_size = element_len;
 			found_data_rate_ie = true;
 			break;
@@ -1484,9 +1475,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				rate += rate_size;
 				memcpy(rate, current_ptr + 2, bytes_to_copy);
 			}
-			HEXDUMP("InterpretIE: ExtSupportedRates:",
-				bss_entry->supported_rates,
-				element_len + rate_size);
 			break;
 
 		case WLAN_EID_VENDOR_SPECIFIC:
@@ -1503,11 +1491,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				bss_entry->wpa_offset =
 					(u16) (current_ptr -
 						 bss_entry->beacon_buf);
-				HEXDUMP("InterpretIE: Resp WLAN_EID_WPA",
-					(u8 *) bss_entry->bcn_wpa_ie,
-					((*(bss_entry->bcn_wpa_ie))
-					.vend_hdr.len +
-					 sizeof(struct ieee_types_header)));
 			} else if (!memcmp
 				   (vendor_ie->vend_hdr.oui, wmm_oui,
 				    sizeof(wmm_oui))) {
@@ -1523,9 +1506,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					 */
 					memcpy((u8 *) &bss_entry->wmm_ie,
 					       current_ptr, total_ie_len);
-					HEXDUMP("InterpretIE: Resp WMM_IE",
-						(u8 *) &bss_entry->wmm_ie,
-						total_ie_len);
 				}
 			}
 			break;
@@ -1535,10 +1515,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->rsn_offset =
 				(u16) (current_ptr -
 					 bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp WLAN_EID_RSN",
-				(u8 *) bss_entry->bcn_rsn_ie,
-				(*(bss_entry->bcn_rsn_ie)).ieee_hdr.len +
-				sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_BSS_AC_ACCESS_DELAY:
 			bss_entry->bcn_wapi_ie =
@@ -1546,11 +1522,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->wapi_offset =
 				(u16) (current_ptr -
 					 bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: "
-				"Resp WLAN_EID_BSS_AC_ACCESS_DELAY",
-				(u8 *) bss_entry->bcn_wapi_ie,
-				(*(bss_entry->bcn_wapi_ie)).ieee_hdr.len +
-				sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_HT_CAPABILITY:
 			bss_entry->bcn_ht_cap = (struct ieee80211_ht_cap *)
@@ -1559,9 +1530,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->ht_cap_offset = (u16) (current_ptr +
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp HTCAP_IE",
-				(u8 *) bss_entry->bcn_ht_cap,
-				element_len + sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_HT_INFORMATION:
 			bss_entry->bcn_ht_info = (struct ieee80211_ht_info *)
@@ -1570,9 +1538,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->ht_info_offset = (u16) (current_ptr +
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp HTINFO_IE",
-				(u8 *) bss_entry->bcn_ht_info,
-				element_len + sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_BSS_COEX_2040:
 			bss_entry->bcn_bss_co_2040 =
@@ -1580,10 +1545,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->bss_co_2040_offset =
 				(u16) (current_ptr -
 					 bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp 2040BSSCOEXISTANCE_IE",
-				(u8 *) bss_entry->bcn_bss_co_2040,
-				(*(bss_entry->bcn_bss_co_2040)).ieee_hdr.len +
-				sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
 			bss_entry->bcn_ext_cap = (u8 *) (current_ptr +
@@ -1591,9 +1552,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->ext_cap_offset = (u16) (current_ptr +
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp EXTCAP_IE",
-				(u8 *) bss_entry->bcn_ext_cap,
-				element_len + sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
 			bss_entry->bcn_obss_scan =
@@ -1602,11 +1560,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->overlap_bss_offset =
 				(u16) (current_ptr -
 					 bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp HTCAP_IE",
-				(u8 *) bss_entry->bcn_obss_scan,
-				(*(bss_entry->bcn_obss_scan)).
-				ieee_hdr.len +
-				sizeof(struct ieee_types_header));
 			break;
 		default:
 			break;
@@ -1799,13 +1752,13 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				 * storage size. Shrink the alloted storage
 				 * space.
 				 */
-				PRINTM(MINFO,
-				       "AppControl: Smaller Duplicate Beacon "
+				dev_dbg(adapter->dev, "info: AppControl:"
+					" smaller duplicate beacon "
 				       "(%d), old = %d, new = %d, space = %d,"
 				       "left = %d\n",
 				       beacon_idx, old_bcn_size, new_bcn_size,
 				       bcn_space,
-				       (sizeof(adapter->bcn_buf) -
+				       (int)(sizeof(adapter->bcn_buf) -
 					(adapter->bcn_buf_end -
 					 adapter->bcn_buf)));
 
@@ -1847,12 +1800,12 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			 * (bcn_space) and there is enough space left in the
 			 * beaconBuffer to store the additional data
 			 */
-			PRINTM(MINFO,
-			       "AppControl: Larger Duplicate Beacon (%d), "
+			dev_dbg(adapter->dev, "info: AppControl:"
+				" larger duplicate beacon (%d), "
 			       "old = %d, new = %d, space = %d, left = %d\n",
 			       beacon_idx, old_bcn_size, new_bcn_size,
 			       bcn_space,
-			       (sizeof(adapter->bcn_buf) -
+			       (int)(sizeof(adapter->bcn_buf) -
 				(adapter->bcn_buf_end -
 				 adapter->bcn_buf)));
 
@@ -1891,19 +1844,16 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				num_of_ent);
 		} else {
 			/*
-			 * Beacon is larger than the previously allocated space
-			 * , but there is not enough free space to store the
-			 * additional data
+			 * Beacon is larger than the previously allocated space,
+			 * but there is not enough free space to store the
+			 * additional data.
 			 */
-			PRINTM(MERROR,
-			       "AppControl: Failed: Larger Duplicate Beacon "
-			       "(%d), old = %d, new = %d, space = %d, left ="
-			       " %d\n",
-			       beacon_idx, old_bcn_size, new_bcn_size,
-			       bcn_space,
-			       (sizeof(adapter->bcn_buf) -
-				(adapter->bcn_buf_end -
-				 adapter->bcn_buf)));
+			dev_err(adapter->dev, "AppControl: larger duplicate "
+				" beacon (%d), old = %d new = %d, space = %d,"
+				" left = %d\n", beacon_idx, old_bcn_size,
+				new_bcn_size, bcn_space,
+				(int)(sizeof(adapter->bcn_buf) -
+				(adapter->bcn_buf_end - adapter->bcn_buf)));
 
 			/* Storage failure, keep old beacon intact */
 			new_beacon->beacon_buf_size = old_bcn_size;
@@ -2065,28 +2015,21 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			adapter->bcn_buf_end +=
 				new_beacon->beacon_buf_size_max;
 
-			PRINTM(MINFO, "AppControl: Beacon[%02d] sz=%03d, "
-			       " used = %04d, left = %04d\n",
+			dev_dbg(adapter->dev, "info: AppControl: beacon[%02d]"
+				" sz=%03d, used = %04d, left = %04d\n",
 			       beacon_idx,
 			       new_beacon->beacon_buf_size,
-			       (adapter->bcn_buf_end - adapter->bcn_buf),
-			       (sizeof(adapter->bcn_buf) -
+			       (int)(adapter->bcn_buf_end - adapter->bcn_buf),
+			       (int)(sizeof(adapter->bcn_buf) -
 				(adapter->bcn_buf_end -
 				 adapter->bcn_buf)));
 		} else {
 			/* No space for new beacon */
-			PRINTM(MINFO, "AppControl: No space beacon (%d): "
-			       "%02x:%02x:%02x:%02x:%02x:%02x; sz=%03d, "
-			       "left=%03d\n",
-			       beacon_idx,
-			       new_beacon->mac_address[0],
-			       new_beacon->mac_address[1],
-			       new_beacon->mac_address[2],
-			       new_beacon->mac_address[3],
-			       new_beacon->mac_address[4],
-			       new_beacon->mac_address[5],
+			dev_dbg(adapter->dev, "info: AppControl: no space for"
+				" beacon (%d): %pM sz=%03d, left=%03d\n",
+			       beacon_idx, new_beacon->mac_address,
 			       new_beacon->beacon_buf_size,
-			       (sizeof(adapter->bcn_buf) -
+			       (int)(sizeof(adapter->bcn_buf) -
 				(adapter->bcn_buf_end -
 				 adapter->bcn_buf)));
 
@@ -2175,9 +2118,8 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 			priv->curr_bss_params.bss_descriptor.
 				beacon_buf_size_max = 0;
 
-			PRINTM(MINFO,
-			       "Found current ssid/bssid in list @ index #%d\n",
-			       j);
+			dev_dbg(adapter->dev, "info: Found current ssid/bssid"
+				" in list @ index #%d\n", j);
 			/* Make a copy of current BSSID descriptor */
 			memcpy(&priv->curr_bss_params.bss_descriptor,
 			       &adapter->scan_table[j],
@@ -2192,15 +2134,9 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 	}
 
 	for (i = 0; i < adapter->num_in_scan_table; i++)
-		PRINTM(MINFO, "Scan:(%02d) %02x:%02x:%02x:%02x:%02x:%02x, "
+		dev_dbg(adapter->dev, "info: scan:(%02d) %pM "
 		       "RSSI[%03d], SSID[%s]\n",
-		       i,
-		       adapter->scan_table[i].mac_address[0],
-		       adapter->scan_table[i].mac_address[1],
-		       adapter->scan_table[i].mac_address[2],
-		       adapter->scan_table[i].mac_address[3],
-		       adapter->scan_table[i].mac_address[4],
-		       adapter->scan_table[i].mac_address[5],
+		       i, adapter->scan_table[i].mac_address,
 		       (s32) adapter->scan_table[i].rssi,
 		       adapter->scan_table[i].ssid.ssid);
 }
@@ -2249,9 +2185,8 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 	 */
 	beacon_buf_adj = adapter->scan_table[table_idx].beacon_buf_size_max;
 
-	PRINTM(MINFO,
-	       "Scan: Delete Entry %d, beacon buffer removal = %d bytes\n",
-	       table_idx, beacon_buf_adj);
+	dev_dbg(adapter->dev, "info: Scan: Delete Entry %d, beacon buffer "
+		"removal = %d bytes\n", table_idx, beacon_buf_adj);
 
 	/* Check if the table entry had storage allocated for its beacon */
 	if (beacon_buf_adj) {
@@ -2263,13 +2198,12 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 		 */
 		adapter->bcn_buf_end -= beacon_buf_adj;
 
-		PRINTM(MINFO,
-		       "Scan: Delete Entry %d, compact data: %p <- %p "
-		       "(sz = %d)\n",
+		dev_dbg(adapter->dev, "info: scan: delete entry %d,"
+			" compact data: %p <- %p (sz = %d)\n",
 		       table_idx,
 		       beacon_buf,
 		       beacon_buf + beacon_buf_adj,
-		       adapter->bcn_buf_end - beacon_buf);
+		       (int)(adapter->bcn_buf_end - beacon_buf));
 
 		/*
 		 * Compact data storage.  Copy all data after the deleted
@@ -2286,7 +2220,8 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 			adapter->bcn_buf_end - beacon_buf);
 	}
 
-	PRINTM(MINFO, "Scan: Delete Entry %d, num_in_scan_table = %d\n",
+	dev_dbg(adapter->dev,
+		"info: Scan: Delete Entry %d, num_in_scan_table = %d\n",
 	       table_idx, adapter->num_in_scan_table);
 
 	/* Shift all of the entries after the table_idx back by one, compacting
@@ -2392,7 +2327,8 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 	int ret = -1;
 	s32 table_idx;
 
-	PRINTM(MINFO, "Scan: Delete Ssid Entry: %-32s\n", del_ssid->ssid);
+	dev_dbg(priv->adapter->dev, "info: scan: delete ssid entry: %-32s\n",
+			del_ssid->ssid);
 
 	/* If the requested SSID is found in the table, delete it.  Then keep
 	   searching the table for multiple entires for the SSID until no
@@ -2402,7 +2338,8 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 						      NULL,
 						      MWIFIEX_BSS_MODE_AUTO)) >=
 	       0) {
-		PRINTM(MINFO, "Scan: Delete SSID Entry: Found Idx = %d\n",
+		dev_dbg(priv->adapter->dev,
+			"info: Scan: Delete SSID Entry: Found Idx = %d\n",
 		       table_idx);
 		ret = 0;
 		mwifiex_scan_delete_table_entry(priv, table_idx);
@@ -2449,7 +2386,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	}
 
 	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
-		PRINTM(MCMND, "Scan already in process...\n");
+		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
 		return ret;
 	}
 
@@ -2458,14 +2395,15 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
-		PRINTM(MCMND, "Scan is blocked during association...\n");
+		dev_dbg(adapter->dev,
+			"cmd: Scan is blocked during association...\n");
 		return ret;
 	}
 
 	scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
 					GFP_KERNEL);
 	if (!scan_cfg_out) {
-		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
+		dev_err(adapter->dev, "failed to alloc scan_cfg_out\n");
 		return -1;
 	}
 
@@ -2474,7 +2412,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 		MWIFIEX_USER_SCAN_CHAN_MAX;
 	scan_chan_list = kzalloc(buf_size, GFP_KERNEL);
 	if (!scan_chan_list) {
-		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
+		dev_err(adapter->dev, "failed to alloc scan_chan_list\n");
 		kfree(scan_cfg_out);
 		return -1;
 	}
@@ -2624,19 +2562,20 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 
 	if (scan_rsp->number_of_sets > IW_MAX_AP) {
-		PRINTM(MERROR,
-		       "SCAN_RESP: Invalid number of AP returned (%d)!!\n",
+		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
 		       scan_rsp->number_of_sets);
 		ret = -1;
 		goto done;
 	}
 
 	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
-	PRINTM(MINFO, "SCAN_RESP: bss_descript_size %d\n", bytes_left);
+	dev_dbg(adapter->dev, "info: SCAN_RESP: bss_descript_size %d\n",
+						bytes_left);
 
 	scan_resp_size = le16_to_cpu(resp->size);
 
-	PRINTM(MINFO, "SCAN_RESP: returned %d APs before parsing\n",
+	dev_dbg(adapter->dev,
+		"info: SCAN_RESP: returned %d APs before parsing\n",
 	       scan_rsp->number_of_sets);
 
 	num_in_table = adapter->num_in_scan_table;
@@ -2684,7 +2623,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	bss_new_entry = kzalloc(sizeof(struct mwifiex_bssdescriptor),
 				GFP_KERNEL);
 	if (!bss_new_entry) {
-		PRINTM(MERROR, "%s: failed to alloc bss_new_entry\n", __func__);
+		dev_err(adapter->dev, " failed to alloc bss_new_entry\n");
 		return -1;
 	}
 
@@ -2699,15 +2638,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 						       &bss_info,
 						       &bytes_left)) {
 
-			PRINTM(MINFO,
-			       "SCAN_RESP: BSSID = %02x:%02x:"
-			       "%02x:%02x:%02x:%02x\n",
-			       bss_new_entry->mac_address[0],
-			       bss_new_entry->mac_address[1],
-			       bss_new_entry->mac_address[2],
-			       bss_new_entry->mac_address[3],
-			       bss_new_entry->mac_address[4],
-			       bss_new_entry->mac_address[5]);
+			dev_dbg(adapter->dev, "info: SCAN_RESP: BSSID = %pM\n",
+			       bss_new_entry->mac_address);
 
 			/* Search the scan table for the same bssid */
 			for (bss_idx = 0; bss_idx < num_in_table; bss_idx++) {
@@ -2732,10 +2664,10 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					      adapter->scan_table[bss_idx].
 					      ssid.ssid,
 					      bss_new_entry->ssid.ssid_len))) {
-						PRINTM(MINFO,
-						       "SCAN_RESP: Duplicate of"
-						       " index: %d\n",
-						       bss_idx);
+						dev_dbg(adapter->dev, "info: "
+							"SCAN_RESP: duplicate"
+							" of index: %d\n",
+							bss_idx);
 						break;
 					}
 				}
@@ -2816,13 +2748,14 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 			/* Error parsing/interpreting the scan response,
 			   skipped */
-			PRINTM(MERROR, "SCAN_RESP: "
+			dev_err(adapter->dev, "SCAN_RESP: "
 			       "mwifiex_interpret_bss_desc_with_ie "
 			       "returned ERROR\n");
 		}
 	}
 
-	PRINTM(MINFO, "SCAN_RESP: Scanned %2d APs, %d valid, %d total\n",
+	dev_dbg(adapter->dev,
+		"info: SCAN_RESP: Scanned %2d APs, %d valid, %d total\n",
 	       scan_rsp->number_of_sets,
 	       num_in_table - adapter->num_in_scan_table, num_in_table);
 
@@ -2918,7 +2851,7 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 	u8 best_rssi = 0;
 	u32 i;
 
-	PRINTM(MINFO, "Num of Entries in Table = %d\n",
+	dev_dbg(adapter->dev, "info: num of entries in table = %d\n",
 	       adapter->num_in_scan_table);
 
 	/*
@@ -3001,7 +2934,7 @@ mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
 	if (!bssid)
 		return -1;
 
-	PRINTM(MINFO, "FindBSSID: Num of BSSIDs = %d\n",
+	dev_dbg(adapter->dev, "info: FindBSSID: Num of BSSIDs = %d\n",
 	       adapter->num_in_scan_table);
 
 	/*
@@ -3084,12 +3017,9 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 	if (!req_ssid_bssid->ssid.ssid_len)
 		return -1;
 
-	PRINTM(MINFO, "Best network found = [%s], "
-	       "[%02x:%02x:%02x:%02x:%02x:%02x]\n",
-	       req_ssid_bssid->ssid.ssid,
-	       req_ssid_bssid->bssid[0], req_ssid_bssid->bssid[1],
-	       req_ssid_bssid->bssid[2], req_ssid_bssid->bssid[3],
-	       req_ssid_bssid->bssid[4], req_ssid_bssid->bssid[5]);
+	dev_dbg(adapter->dev, "info: Best network found = [%s], "
+	       "[%pM]\n", req_ssid_bssid->ssid.ssid,
+	       req_ssid_bssid->bssid);
 
 	return 0;
 }
@@ -3123,12 +3053,13 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	}
 
 	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
-		PRINTM(MCMND, "Scan already in process...\n");
+		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
 		return ret;
 	}
 
 	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
-		PRINTM(MCMND, "Scan is blocked during association...\n");
+		dev_dbg(adapter->dev,
+			"cmd: Scan is blocked during association...\n");
 		return ret;
 	}
 
@@ -3136,7 +3067,7 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 
 	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
 	if (!scan_cfg) {
-		PRINTM(MERROR, "%s: failed to alloc scan_cfg\n", __func__);
+		dev_err(adapter->dev, "failed to alloc scan_cfg\n");
 		return -1;
 	}
 
@@ -3181,9 +3112,6 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
 				& 0x00FF) + 2);
 			memcpy(vs_param_set->ie, priv->vs_ie[id].ie,
 			       le16_to_cpu(vs_param_set->header.len));
-			HEXDUMP("VENDOR_SPEC_IE", (u8 *) vs_param_set,
-				sizeof(struct mwifiex_ie_types_header) +
-				le16_to_cpu(vs_param_set->header.len));
 			*buffer +=
 				le16_to_cpu(vs_param_set->header.len) +
 				sizeof(struct mwifiex_ie_types_header);
@@ -3226,12 +3154,13 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
 						GFP_KERNEL);
 		if (!priv->curr_bcn_buf)
-			PRINTM(MERROR, "%s: failed to alloc curr_bcn_buf\n",
-			       __func__);
+			dev_err(priv->adapter->dev,
+					"failed to alloc curr_bcn_buf\n");
 		else {
 			memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
 			       curr_bss->beacon_buf_size);
-			PRINTM(MINFO, "current beacon saved %d\n",
+			dev_dbg(priv->adapter->dev,
+				"info: current beacon saved %d\n",
 			       priv->curr_bcn_size);
 		}
 	}
@@ -3308,11 +3237,11 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 
 		spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
 
-		PRINTM(MINFO, "current beacon restored %d\n",
+		dev_dbg(adapter->dev, "info: current beacon restored %d\n",
 		       priv->curr_bcn_size);
 	} else {
-		PRINTM(MWARN,
-		       "curr_bcn_buf not saved or bcn_buf has no space\n");
+		dev_warn(adapter->dev,
+			"curr_bcn_buf not saved or bcn_buf has no space\n");
 	}
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4df8186..4201239 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -50,13 +50,12 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	int ret = 0;
 	struct sdio_mmc_card *card = NULL;
 
-	PRINTM(MINFO, "vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
+	pr_debug("info: vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
 	       func->vendor, func->device, func->class, func->num);
 
 	card = kzalloc(sizeof(struct sdio_mmc_card), GFP_KERNEL);
 	if (!card) {
-		PRINTM(MFATAL,
-		       "Failed to allocate memory in probe function!\n");
+		pr_err("%s: failed to alloc memory\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -69,12 +68,12 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	sdio_release_host(func);
 
 	if (ret) {
-		PRINTM(MFATAL, "sdio_enable_func() failed: ret=%d\n", ret);
+		pr_err("%s: failed to enable function\n", __func__);
 		return -EIO;
 	}
 
 	if (mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops)) {
-		PRINTM(MERROR, "%s failed\n", __func__);
+		pr_err("%s: add card failed\n", __func__);
 		kfree(card);
 		sdio_claim_host(func);
 		ret = sdio_disable_func(func);
@@ -95,7 +94,7 @@ mwifiex_sdio_remove(struct sdio_func *func)
 {
 	struct sdio_mmc_card *card;
 
-	PRINTM(MINFO, "SDIO func=%d\n", func->num);
+	pr_debug("info: SDIO func num=%d\n", func->num);
 
 	if (func) {
 		card = sdio_get_drvdata(func);
@@ -129,24 +128,21 @@ static int mwifiex_sdio_suspend(struct device *dev)
 
 	if (func) {
 		pm_flag = sdio_get_host_pm_caps(func);
-		PRINTM(MCMND, "%s: suspend: PM flag = 0x%x\n",
+		pr_debug("cmd: %s: suspend: PM flag = 0x%x\n",
 		       sdio_func_id(func), pm_flag);
 		if (!(pm_flag & MMC_PM_KEEP_POWER)) {
-			PRINTM(MERROR,
-			       "%s: cannot remain alive while "
-			       "host is suspended\n",
-			       sdio_func_id(func));
+			pr_err("%s: cannot remain alive while host is"
+				" suspended\n", sdio_func_id(func));
 			return -ENOSYS;
 		}
 
 		card = sdio_get_drvdata(func);
 		if (!card || !card->adapter) {
-			PRINTM(MERROR,
-			       "Card or moal_handle structure is not valid\n");
+			pr_err("suspend: invalid card or adapter\n");
 			return 0;
 		}
 	} else {
-		PRINTM(MERROR, "sdio_func is not specified\n");
+		pr_err("suspend: sdio_func is not specified\n");
 		return 0;
 	}
 
@@ -155,7 +151,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	/* Enable the Host Sleep */
 	hs_actived = mwifiex_enable_hs(adapter);
 	if (hs_actived) {
-		PRINTM(MCMND, "suspend with MMC_PM_KEEP_POWER\n");
+		pr_debug("cmd: suspend with MMC_PM_KEEP_POWER\n");
 		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 	}
 
@@ -190,19 +186,18 @@ static int mwifiex_sdio_resume(struct device *dev)
 		pm_flag = sdio_get_host_pm_caps(func);
 		card = sdio_get_drvdata(func);
 		if (!card || !card->adapter) {
-			PRINTM(MERROR,
-			       "Card or moal_handle structure is not valid\n");
+			pr_err("resume: invalid card or adapter\n");
 			return 0;
 		}
 	} else {
-		PRINTM(MERROR, "sdio_func is not specified\n");
+		pr_err("resume: sdio_func is not specified\n");
 		return 0;
 	}
 
 	adapter = card->adapter;
 
 	if (!adapter->is_suspended) {
-		PRINTM(MWARN, "Device already resumed\n");
+		dev_warn(adapter->dev, "device already resumed\n");
 		return 0;
 	}
 
@@ -302,7 +297,8 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
 	if (adapter->is_suspended) {
-		PRINTM(MERROR, "%s is not allowed while suspended\n", __func__);
+		dev_err(adapter->dev,
+			"%s: not allowed while suspended\n", __func__);
 		return -1;
 	}
 
@@ -355,7 +351,7 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	int ret;
 
-	PRINTM(MEVENT, "Wakeup device...\n");
+	dev_dbg(adapter->dev, "event: wakeup device...\n");
 	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, HOST_POWER_UP);
 
 	return ret;
@@ -370,7 +366,7 @@ static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 {
 	int ret;
 
-	PRINTM(MCMND, "Wakeup device completed\n");
+	dev_dbg(adapter->dev, "cmd: wakeup device completed\n");
 	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, 0);
 
 	return ret;
@@ -406,7 +402,7 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 	else
 		return -1;
 
-	PRINTM(MINFO, "SDIO FUNC1 IO port: 0x%x\n", adapter->ioport);
+	pr_debug("info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
 
 	/* Set Host interrupt reset to read to clear */
 	if (!mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg)) {
@@ -439,12 +435,12 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 								port, 0);
 		if (ret) {
 			i++;
-			PRINTM(MERROR, "host_to_card, write iomem (%d) failed:"
-				       " %d\n", i, ret);
+			dev_err(adapter->dev, "host_to_card, write iomem"
+					" (%d) failed: %d\n", i, ret);
 			if (mwifiex_write_reg(adapter,
-					      CONFIGURATION_REG, 0x04)) {
-				PRINTM(MERROR, "write CFG reg failed\n");
-			}
+					CONFIGURATION_REG, 0x04))
+				dev_err(adapter->dev, "write CFG reg failed\n");
+
 			ret = -1;
 			if (i > MAX_WRITE_IOMEM_RETRY)
 				return ret;
@@ -467,7 +463,7 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 	struct sdio_mmc_card *card = adapter->card;
 	u16 rd_bitmap = card->mp_rd_bitmap;
 
-	PRINTM(MDATA, "mwifiex_get_rd_port: mp_rd_bitmap=0x%04x\n", rd_bitmap);
+	dev_dbg(adapter->dev, "data: mp_rd_bitmap=0x%04x\n", rd_bitmap);
 
 	if (!(rd_bitmap & (CTRL_PORT_MASK | DATA_PORT_MASK)))
 		return -1;
@@ -475,8 +471,7 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 	if (card->mp_rd_bitmap & CTRL_PORT_MASK) {
 		card->mp_rd_bitmap &= (u16) (~CTRL_PORT_MASK);
 		*port = CTRL_PORT;
-		PRINTM(MDATA,
-		       "mwifiex_get_rd_port: port=%d mp_rd_bitmap=0x%04x\n",
+		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%04x\n",
 		       *port, card->mp_rd_bitmap);
 	} else {
 		if (card->mp_rd_bitmap & (1 << card->curr_rd_port)) {
@@ -490,7 +485,8 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 			return -1;
 		}
 
-		PRINTM(MDATA, "port=%d mp_rd_bitmap=0x%04x -> 0x%04x\n",
+		dev_dbg(adapter->dev,
+			"data: port=%d mp_rd_bitmap=0x%04x -> 0x%04x\n",
 		       *port, rd_bitmap, card->mp_rd_bitmap);
 	}
 	return 0;
@@ -508,8 +504,7 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 	struct sdio_mmc_card *card = adapter->card;
 	u16 wr_bitmap = card->mp_wr_bitmap;
 
-	PRINTM(MDATA, "mwifiex_get_wr_port_data: mp_wr_bitmap=0x%04x\n",
-	       wr_bitmap);
+	dev_dbg(adapter->dev, "data: mp_wr_bitmap=0x%04x\n", wr_bitmap);
 
 	if (!(wr_bitmap & card->mp_data_port_mask))
 		return -1;
@@ -525,14 +520,14 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 	}
 
 	if (*port == CTRL_PORT) {
-		PRINTM(MERROR, "Invalid data port=%d cur port=%d mp_wr_bitmap="
-				"0x%04x -> 0x%04x\n",
+		dev_err(adapter->dev, "invalid data port=%d cur port=%d"
+				" mp_wr_bitmap=0x%04x -> 0x%04x\n",
 				*port, card->curr_wr_port, wr_bitmap,
 				card->mp_wr_bitmap);
 		return -1;
 	}
 
-	PRINTM(MDATA, "port=%d mp_wr_bitmap=0x%04x -> 0x%04x\n",
+	dev_dbg(adapter->dev, "data: port=%d mp_wr_bitmap=0x%04x -> 0x%04x\n",
 	       *port, wr_bitmap, card->mp_wr_bitmap);
 
 	return 0;
@@ -556,7 +551,7 @@ mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 		udelay(10);
 	}
 
-	PRINTM(MWARN, "mwifiex_sdio_poll_card_status failed, tries = %d\n",
+	dev_err(adapter->dev, "poll card status failed, tries = %d\n",
 	       tries);
 	return -1;
 }
@@ -598,7 +593,7 @@ static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 	host_int_mask &= ~HOST_INT_DISABLE;
 
 	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, host_int_mask)) {
-		PRINTM(MWARN, "Disable host interrupt failed\n");
+		dev_err(adapter->dev, "disable host interrupt failed\n");
 		return -1;
 	}
 
@@ -615,7 +610,7 @@ static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 {
 	/* Simply write the mask to the register */
 	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, HOST_INT_ENABLE)) {
-		PRINTM(MWARN, "Enable host interrupt failed\n");
+		dev_err(adapter->dev, "enable host interrupt failed\n");
 		return -1;
 	}
 	return 0;
@@ -632,27 +627,25 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 	int ret = 0;
 
 	if (!buffer) {
-		PRINTM(MWARN, "skb NULL pointer received!\n");
+		dev_err(adapter->dev, "%s: buffer is NULL\n", __func__);
 		return -1;
 	}
 
 	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 0, 1);
 
 	if (ret) {
-		PRINTM(MERROR, "card_to_host, read iomem failed: %d\n", ret);
+		dev_err(adapter->dev, "%s: read iomem failed: %d\n", __func__,
+				ret);
 		return -1;
 	}
 
 	*nb = le16_to_cpu(*(__le16 *) (buffer));
 	if (*nb > npayload) {
-		PRINTM(MERROR, "invalid packet, *nb=%d, npayload=%d\n", *nb,
-		       npayload);
+		dev_err(adapter->dev, "%s: invalid packet, *nb=%d, npayload=%d\n",
+				__func__, *nb, npayload);
 		return -1;
 	}
 
-	DBG_HEXDUMP(MDAT_D, "SDIO Blk Rd", buffer,
-		    min_t(u32, *nb, MAX_DATA_DUMP_LEN));
-
 	*type = le16_to_cpu(*(__le16 *) (buffer + 2));
 
 	return ret;
@@ -679,18 +672,19 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u32 i = 0;
 
 	if (!firmware_len) {
-		PRINTM(MMSG, "No firmware image found! Terminating download\n");
+		dev_err(adapter->dev, "firmware image not found!"
+				" Terminating download\n");
 		return -1;
 	}
 
-	PRINTM(MINFO, "Downloading FW image (%d bytes)\n", firmware_len);
+	dev_dbg(adapter->dev, "info: downloading FW image (%d bytes)\n",
+			firmware_len);
 
 	/* Assume that the allocated buffer is 8-byte aligned */
 	fwbuf = kzalloc(MWIFIEX_UPLD_SIZE, GFP_KERNEL);
 	if (!fwbuf) {
-		PRINTM(MERROR,
-		       "Unable to allocate buffer for firmware. Terminating "
-		       "download\n");
+		dev_err(adapter->dev, "unable to alloc buffer for firmware."
+				" Terminating download\n");
 		return -1;
 	}
 
@@ -702,10 +696,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 						    CARD_IO_READY |
 						    DN_LD_CARD_RDY);
 		if (ret) {
-			PRINTM(MFATAL,
-			       "FW download with helper poll status timeout @ "
-			       "%d\n",
-			       offset);
+			dev_err(adapter->dev, "FW download with helper:"
+					" poll status timeout @ %d\n", offset);
 			goto done;
 		}
 
@@ -718,22 +710,18 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 						HOST_F1_RD_BASE_0,
 						&base0);
 			if (ret) {
-				PRINTM(MWARN,
-				       "Dev BASE0 register read failed:"
-				       " base0=0x%04X(%d). Terminating "
-				       "download\n",
-				       base0, base0);
+				dev_err(adapter->dev, "dev BASE0 register read"
+					" failed: base0=0x%04X(%d). Terminating "
+				       "download\n", base0, base0);
 				goto done;
 			}
 			ret = mwifiex_read_reg(adapter,
 						 HOST_F1_RD_BASE_1,
 						&base1);
 			if (ret) {
-				PRINTM(MWARN,
-				       "Dev BASE1 register read failed:"
-				       " base1=0x%04X(%d). Terminating "
-				       "download\n",
-				       base1, base1);
+				dev_err(adapter->dev, "dev BASE1 register read"
+					" failed: base1=0x%04X(%d). Terminating "
+				       "download\n", base1, base1);
 				goto done;
 			}
 			len = (u16) (((base1 & 0xff) << 8) | (base0 & 0xff));
@@ -747,9 +735,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		if (!len)
 			break;
 		else if (len > MWIFIEX_UPLD_SIZE) {
-			PRINTM(MFATAL,
-			       "FW download failure @ %d, invalid length %d\n",
-			       offset, len);
+			dev_err(adapter->dev, "FW download failed @ %d,"
+				" invalid length %d\n", offset, len);
 			ret = -1;
 			goto done;
 		}
@@ -759,14 +746,12 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		if (len & BIT(0)) {
 			i++;
 			if (i > MAX_WRITE_IOMEM_RETRY) {
-				PRINTM(MFATAL,
-				       "FW download failure @ %d, over max "
-				       "retry count\n",
-				       offset);
+				dev_err(adapter->dev, "FW download failed @"
+					" %d, over max retry count\n", offset);
 				ret = -1;
 				goto done;
 			}
-			PRINTM(MERROR, "FW CRC error indicated by the helper:"
+			dev_err(adapter->dev, "CRC indicated by the helper:"
 			       " len = 0x%04X, txlen = %d\n", len, txlen);
 			len &= ~BIT(0);
 			/* Setting this to 0 to resend from same offset */
@@ -779,8 +764,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (firmware_len - offset < txlen)
 				txlen = firmware_len - offset;
 
-			PRINTM(MINFO, ".");
-
 			tx_blocks =
 				(txlen + MWIFIEX_SDIO_BLOCK_SIZE -
 				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
@@ -793,13 +776,11 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 					      MWIFIEX_SDIO_BLOCK_SIZE,
 					      adapter->ioport, 0);
 		if (ret) {
-			PRINTM(MERROR,
-			       "FW download, write iomem (%d) failed @ %d\n"
-			       , i, offset);
-			if (mwifiex_write_reg(adapter, CONFIGURATION_REG,
-			    0x04)) {
-				PRINTM(MERROR, "write CFG reg failed\n");
-			}
+			dev_err(adapter->dev, "FW download, write iomem (%d)"
+					" failed @ %d\n", i, offset);
+			if (mwifiex_write_reg(adapter, CONFIGURATION_REG, 0x04))
+				dev_err(adapter->dev, "write CFG reg failed\n");
+
 			ret = -1;
 			goto done;
 		}
@@ -807,7 +788,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		offset += txlen;
 	} while (true);
 
-	PRINTM(MINFO, "\nFW download over, size %d bytes\n", offset);
+	dev_dbg(adapter->dev, "info: FW download over, size %d bytes\n",
+						offset);
 
 	ret = 0;
 done:
@@ -867,19 +849,17 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
 				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0,
 				   0)) {
-		PRINTM(MWARN,
-		       "mwifiex_read_data_sync: read registers failed\n");
+		dev_err(adapter->dev, "read mp_regs failed\n");
 		return;
 	}
 
-	DBG_HEXDUMP(MDAT_D, "SDIO MP Registers", card->mp_regs, MAX_MP_REGS);
 	sdio_ireg = card->mp_regs[HOST_INTSTATUS_REG];
 	if (sdio_ireg) {
 		/*
 		 * DN_LD_HOST_INT_STATUS and/or UP_LD_HOST_INT_STATUS
 		 * Clear the interrupt status register
 		 */
-		PRINTM(MINTR, "sdio_ireg = 0x%x\n", sdio_ireg);
+		dev_dbg(adapter->dev, "int: sdio_ireg = %#x\n", sdio_ireg);
 		spin_lock_irqsave(&adapter->int_lock, flags);
 		adapter->int_status |= sdio_ireg;
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
@@ -902,7 +882,7 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 
 	card = sdio_get_drvdata(func);
 	if (!card || !card->adapter) {
-		PRINTM(MINFO, "%s: func=%p card=%p adapter=%p\n", __func__,
+		pr_debug("int: func=%p card=%p adapter=%p\n",
 		       func, card, card ? card->adapter : NULL);
 		return;
 	}
@@ -936,13 +916,12 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 
 	switch (upld_typ) {
 	case MWIFIEX_TYPE_DATA:
-		PRINTM(MINFO, "--- Rx: Data packet ---\n");
+		dev_dbg(adapter->dev, "info: --- Rx: Data packet ---\n");
 		mwifiex_handle_rx_packet(adapter, skb);
 		break;
 
 	case MWIFIEX_TYPE_CMD:
-		PRINTM(MINFO, "--- Rx: Cmd Response ---\n");
-		DBG_HEXDUMP(MDAT_D, "Cmd RESP BUFFER", skb->data, skb->len);
+		dev_dbg(adapter->dev, "info: --- Rx: Cmd Response ---\n");
 		/* take care of curr_cmd = NULL case */
 		if (!adapter->curr_cmd) {
 			cmd_buf = adapter->upld_buf;
@@ -964,7 +943,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		break;
 
 	case MWIFIEX_TYPE_EVENT:
-		PRINTM(MINFO, "--- Rx: Event ---\n");
+		dev_dbg(adapter->dev, "info: --- Rx: Event ---\n");
 		adapter->event_cause = *(u32 *) skb->data;
 
 		skb_pull(skb, MWIFIEX_EVENT_HEADER_LEN);
@@ -979,7 +958,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		break;
 
 	default:
-		PRINTM(MERROR, "SDIO unknown upload type = 0x%x\n", upld_typ);
+		dev_err(adapter->dev, "unknown upload type %#x\n", upld_typ);
 		dev_kfree_skb_any(skb);
 		break;
 	}
@@ -1011,16 +990,16 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (port == CTRL_PORT) {
 		/* Read the command Resp without aggr */
-		PRINTM(MINFO, "card_2_host_mp_aggr: No "
-			"aggregation for cmd response\n");
+		dev_dbg(adapter->dev, "info: %s: no aggregation for cmd "
+				"response\n", __func__);
 
 		f_do_rx_cur = 1;
 		goto rx_curr_single;
 	}
 
 	if (!card->mpa_rx.enabled) {
-		PRINTM(MINFO, "card_2_host_mp_aggr: rx "
-			"aggregation disabled !\n");
+		dev_dbg(adapter->dev, "info: %s: rx aggregation disabled\n",
+						__func__);
 
 		f_do_rx_cur = 1;
 		goto rx_curr_single;
@@ -1028,7 +1007,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (card->mp_rd_bitmap & (~((u16) CTRL_PORT_MASK))) {
 		/* Some more data RX pending */
-		PRINTM(MINFO, "card_2_host_mp_aggr: Not last packet\n");
+		dev_dbg(adapter->dev, "info: %s: not last packet\n", __func__);
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
 			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len)) {
@@ -1045,7 +1024,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	} else {
 		/* No more data RX pending */
-		PRINTM(MINFO, "card_2_host_mp_aggr: Last packet\n");
+		dev_dbg(adapter->dev, "info: %s: last packet\n", __func__);
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
 			f_do_rx_aggr = 1;
@@ -1062,14 +1041,14 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	}
 
 	if (f_aggr_cur) {
-		PRINTM(MINFO, "Current packet aggregation.\n");
+		dev_dbg(adapter->dev, "info: current packet aggregation\n");
 		/* Curr pkt can be aggregated */
 		MP_RX_AGGR_SETUP(card, skb, port);
 
 		if (MP_RX_AGGR_PKT_LIMIT_REACHED(card) ||
 		    MP_RX_AGGR_PORT_LIMIT_REACHED(card)) {
-			PRINTM(MINFO, "card_2_host_mp_aggr: Aggregation Packet "
-					"limit reached\n");
+			dev_dbg(adapter->dev, "info: %s: aggregated packet "
+					"limit reached\n", __func__);
 			/* No more pkts allowed in Aggr buf, rx it */
 			f_do_rx_aggr = 1;
 		}
@@ -1078,7 +1057,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (f_do_rx_aggr) {
 		/* do aggr RX now */
-		PRINTM(MINFO, "do_rx_aggr: num of packets: %d\n",
+		dev_dbg(adapter->dev, "info: do_rx_aggr: num of packets: %d\n",
 		       card->mpa_rx.pkt_cnt);
 
 		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
@@ -1111,11 +1090,10 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 				mwifiex_decode_rx_packet(adapter, skb_deaggr,
 							 pkt_type);
 			} else {
-				PRINTM(MERROR,
-				       "Wrong aggr packet: type=%d, len=%d,"
-				       "max_len=%d\n",
-				       pkt_type, pkt_len,
-				       card->mpa_rx.len_arr[pind]);
+				dev_err(adapter->dev, "wrong aggr pkt:"
+					" type=%d len=%d max_len=%d\n",
+					pkt_type, pkt_len,
+					card->mpa_rx.len_arr[pind]);
 				dev_kfree_skb_any(skb_deaggr);
 			}
 			curr_ptr += card->mpa_rx.len_arr[pind];
@@ -1125,8 +1103,8 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 rx_curr_single:
 	if (f_do_rx_cur) {
-		PRINTM(MINFO, "RX: f_do_rx_cur: port: %d rx_len: %d\n", port,
-		       rx_len);
+		dev_dbg(adapter->dev, "info: RX: port: %d, rx_len: %d\n",
+			port, rx_len);
 
 		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
 					      (u32 *) &adapter->upld_len,
@@ -1135,7 +1113,6 @@ rx_curr_single:
 			return -1;
 
 		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
-
 	}
 
 	return 0;
@@ -1179,10 +1156,12 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	if (sdio_ireg & DN_LD_HOST_INT_STATUS) {
 		card->mp_wr_bitmap = ((u16) card->mp_regs[WR_BITMAP_U]) << 8;
 		card->mp_wr_bitmap |= (u16) card->mp_regs[WR_BITMAP_L];
-		PRINTM(MINTR, "DNLD: wr_bitmap=0x%04x\n", card->mp_wr_bitmap);
+		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%04x\n",
+				card->mp_wr_bitmap);
 		if (adapter->data_sent &&
 		    (card->mp_wr_bitmap & card->mp_data_port_mask)) {
-			PRINTM(MINFO, " <--- Tx DONE Interrupt --->\n");
+			dev_dbg(adapter->dev,
+				"info:  <--- Tx DONE Interrupt --->\n");
 			adapter->data_sent = false;
 		}
 	}
@@ -1197,34 +1176,37 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			(u16) card->mp_regs[WR_BITMAP_L] & CTRL_PORT_MASK;
 		if (card->mp_wr_bitmap & CTRL_PORT_MASK)
 			adapter->cmd_sent = false;
-
 	}
 
-	PRINTM(MINFO, "cmd_sent=%d data_sent=%d\n",
+	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
 	       adapter->cmd_sent, adapter->data_sent);
 	if (sdio_ireg & UP_LD_HOST_INT_STATUS) {
 		card->mp_rd_bitmap = ((u16) card->mp_regs[RD_BITMAP_U]) << 8;
 		card->mp_rd_bitmap |= (u16) card->mp_regs[RD_BITMAP_L];
-		PRINTM(MINTR, "UPLD: rd_bitmap=0x%04x\n", card->mp_rd_bitmap);
+		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%04x\n",
+				card->mp_rd_bitmap);
 
 		while (true) {
 			ret = mwifiex_get_rd_port(adapter, &port);
 			if (ret) {
-				PRINTM(MINFO, "no more rd_port available\n");
+				dev_dbg(adapter->dev,
+					"info: no more rd_port available\n");
 				break;
 			}
 			len_reg_l = RD_LEN_P0_L + (port << 1);
 			len_reg_u = RD_LEN_P0_U + (port << 1);
 			rx_len = ((u16) card->mp_regs[len_reg_u]) << 8;
 			rx_len |= (u16) card->mp_regs[len_reg_l];
-			PRINTM(MINFO, "RX: port=%d rx_len=%u\n", port, rx_len);
+			dev_dbg(adapter->dev, "info: RX: port=%d rx_len=%u\n",
+					port, rx_len);
 			rx_blocks =
 				(rx_len + MWIFIEX_SDIO_BLOCK_SIZE -
 				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
 			if (rx_len <= INTF_HEADER_LEN
 			    || (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
 			    MWIFIEX_RX_DATA_BUF_SIZE) {
-				PRINTM(MERROR, "invalid rx_len=%d\n", rx_len);
+				dev_err(adapter->dev, "invalid rx_len=%d\n",
+						rx_len);
 				return -1;
 			}
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
@@ -1232,40 +1214,43 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			skb = dev_alloc_skb(rx_len);
 
 			if (!skb) {
-				PRINTM(MERROR, "%s: failed to alloc skb",
+				dev_err(adapter->dev, "%s: failed to alloc skb",
 								__func__);
 				return -1;
 			}
 
 			skb_put(skb, rx_len);
 
-			PRINTM(MINFO, "rx_len = %d skb->len = %d\n", rx_len,
-					skb->len);
+			dev_dbg(adapter->dev, "info: rx_len = %d skb->len = %d\n",
+					rx_len, skb->len);
 
 			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
 							      port)) {
 				u32 cr = 0;
 
-				PRINTM(MERROR,
-				       "Card to host failed: int status=0x%x\n",
-				       sdio_ireg);
+				dev_err(adapter->dev, "card_to_host_mpa failed:"
+						" int status=%#x\n", sdio_ireg);
 				if (mwifiex_read_reg(adapter,
 						     CONFIGURATION_REG, &cr))
-					PRINTM(MERROR, "read CFG reg failed\n");
+					dev_err(adapter->dev,
+							"read CFG reg failed\n");
 
-				PRINTM(MINFO, "Config Reg val = %d\n", cr);
+				dev_dbg(adapter->dev,
+						"info: CFG reg val = %d\n", cr);
 				if (mwifiex_write_reg(adapter,
 						      CONFIGURATION_REG,
 						      (cr | 0x04)))
-					PRINTM(MERROR,
-					       "write CFG reg failed\n");
+					dev_err(adapter->dev,
+							"write CFG reg failed\n");
 
-				PRINTM(MINFO, "write success\n");
+				dev_dbg(adapter->dev, "info: write success\n");
 				if (mwifiex_read_reg(adapter,
 						     CONFIGURATION_REG, &cr))
-					PRINTM(MERROR, "read CFG reg failed\n");
+					dev_err(adapter->dev,
+							"read CFG reg failed\n");
 
-				PRINTM(MINFO, "Config reg val =%x\n", cr);
+				dev_dbg(adapter->dev,
+						"info: CFG reg val =%x\n", cr);
 				dev_kfree_skb_any(skb);
 				return -1;
 			}
@@ -1310,7 +1295,8 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	if (type == MWIFIEX_TYPE_DATA) {
 		ret = mwifiex_get_wr_port_data(adapter, &port);
 		if (ret) {
-			PRINTM(MERROR, "no wr_port available: %d\n", ret);
+			dev_err(adapter->dev, "%s: no wr_port available\n",
+						__func__);
 			return ret;
 		}
 	} else {
@@ -1319,9 +1305,8 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 
 		if (pkt_len <= INTF_HEADER_LEN ||
 		    pkt_len > MWIFIEX_UPLD_SIZE)
-			PRINTM(MWARN, "mwifiex_sdio_host_to_card(): Error: "
-			       "payload=%p, nb=%d\n",
-			       payload, pkt_len);
+			dev_err(adapter->dev, "%s: payload=%p, nb=%d\n",
+					__func__, payload, pkt_len);
 	}
 
 	/* Transfer data to card */
@@ -1348,9 +1333,6 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 			else
 				adapter->data_sent = false;
 		}
-		DBG_HEXDUMP(MDAT_D, "SDIO Blk Wr",
-				payload,
-				min_t(u32, pkt_len, MAX_DATA_DUMP_LEN));
 	}
 
 	return ret;
@@ -1381,12 +1363,9 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_precopy_cur_buf = 0;
 	s32 f_postcopy_cur_buf = 0;
 
-	PRINTM(MDAT_D, "host_2_card_mp_aggr: next_pkt_len: %d curr_port:%d\n",
-	       next_pkt_len, port);
-
 	if ((!card->mpa_tx.enabled) || (port == CTRL_PORT)) {
-		PRINTM(MINFO,
-		       "host_2_card_mp_aggr: tx aggregation disabled !\n");
+		dev_dbg(adapter->dev, "info: %s: tx aggregation disabled\n",
+						__func__);
 
 		f_send_cur_buf = 1;
 		goto tx_curr_single;
@@ -1394,7 +1373,8 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (next_pkt_len) {
 		/* More pkt in TX queue */
-		PRINTM(MINFO, "host_2_card_mp_aggr: More packets in Queue.\n");
+		dev_dbg(adapter->dev, "info: %s: more packets in queue.\n",
+						__func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
 			if (!MP_TX_AGGR_PORT_LIMIT_REACHED(card) &&
@@ -1428,8 +1408,8 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		}
 	} else {
 		/* Last pkt in TX queue */
-		PRINTM(MINFO,
-		       "host_2_card_mp_aggr: Last packet in Tx Queue.\n");
+		dev_dbg(adapter->dev, "info: %s: Last packet in Tx Queue.\n",
+						__func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
 			/* some packs in Aggr buf already */
@@ -1447,21 +1427,20 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	}
 
 	if (f_precopy_cur_buf) {
-		PRINTM(MDATA, "host_2_card_mp_aggr: Precopy current buffer\n");
+		dev_dbg(adapter->dev, "data: %s: precopy current buffer\n",
+						__func__);
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 
 		if (MP_TX_AGGR_PKT_LIMIT_REACHED(card) ||
-		    MP_TX_AGGR_PORT_LIMIT_REACHED(card)) {
-			PRINTM(MDAT_D, "host_2_card_mp_aggr: Aggregation Pkt "
-					"limit reached\n");
+		    MP_TX_AGGR_PORT_LIMIT_REACHED(card))
 			/* No more pkts allowed in Aggr buf, send it */
 			f_send_aggr_buf = 1;
-		}
 	}
 
 	if (f_send_aggr_buf) {
-		PRINTM(MDATA, "host_2_card_mp_aggr: Send aggregation buffer."
-		       "%d %d\n", card->mpa_tx.start_port, card->mpa_tx.ports);
+		dev_dbg(adapter->dev, "data: %s: send aggr buffer: %d %d\n",
+				__func__,
+				card->mpa_tx.start_port, card->mpa_tx.ports);
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
 						 card->mpa_tx.buf_len,
 						 (adapter->ioport | 0x1000 |
@@ -1473,14 +1452,15 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 tx_curr_single:
 	if (f_send_cur_buf) {
-		PRINTM(MDATA, "host_2_card_mp_aggr: Send current buffer %d\n",
-		       port);
+		dev_dbg(adapter->dev, "data: %s: send current buffer %d\n",
+						__func__, port);
 		ret = mwifiex_write_data_to_card(adapter, payload, pkt_len,
 						 adapter->ioport + port);
 	}
 
 	if (f_postcopy_cur_buf) {
-		PRINTM(MDATA, "host_2_card_mp_aggr: Postcopy current buffer\n");
+		dev_dbg(adapter->dev, "data: %s: postcopy current buffer\n",
+						__func__);
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 	}
 
@@ -1498,8 +1478,7 @@ int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 
 	card->mpa_tx.buf = kzalloc(mpa_tx_buf_size, GFP_KERNEL);
 	if (!card->mpa_tx.buf) {
-		PRINTM(MERROR,
-		       "Could not allocate buffer for SDIO MP TX aggr\n");
+		dev_err(adapter->dev, "could not alloc buffer for MP-A TX\n");
 		ret = -1;
 		goto error;
 	}
@@ -1508,8 +1487,7 @@ int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 
 	card->mpa_rx.buf = kzalloc(mpa_rx_buf_size, GFP_KERNEL);
 	if (!card->mpa_rx.buf) {
-		PRINTM(MERROR,
-		       "Could not allocate buffer for SDIO MP RX aggr\n");
+		dev_err(adapter->dev, "could not alloc buffer for MP-A RX\n");
 		ret = -1;
 		goto error;
 	}
@@ -1542,10 +1520,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 		sdio_release_irq(card->func);
 		sdio_disable_func(card->func);
 		sdio_release_host(card->func);
-
 		sdio_set_drvdata(card->func, NULL);
-
-		PRINTM(MWARN, "Making the sdio dev card as NULL\n");
 	}
 }
 
@@ -1568,15 +1543,14 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	/* Request the SDIO IRQ */
 	ret = sdio_claim_irq(func, mwifiex_sdio_interrupt);
 	if (ret) {
-		PRINTM(MFATAL, "sdio_claim_irq failed: ret=%d\n", ret);
+		pr_err("claim irq failed: ret=%d\n", ret);
 		goto disable_func;
 	}
 
 	/* Set block size */
 	ret = sdio_set_block_size(card->func, MWIFIEX_SDIO_BLOCK_SIZE);
 	if (ret) {
-		PRINTM(MERROR,
-		       "sdio_set_block_seize(): cannot set SDIO block size\n");
+		pr_err("cannot set SDIO block size\n");
 		ret = -1;
 		goto release_irq;
 	}
@@ -1659,7 +1633,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	/* Allocate buffers for SDIO MP-A */
 	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_KERNEL);
 	if (!card->mp_regs) {
-		PRINTM(MERROR, "%s: failed to allocate mp_regs\n", __func__);
+		dev_err(adapter->dev, "failed to alloc mp_regs\n");
 		return -1;
 	}
 
@@ -1667,7 +1641,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 					     SDIO_MP_TX_AGGR_DEF_BUF_SIZE,
 					     SDIO_MP_RX_AGGR_DEF_BUF_SIZE);
 	if (ret) {
-		PRINTM(MERROR, "Failed to allocate sdio mp-a buffers\n");
+		dev_err(adapter->dev, "failed to alloc sdio mp-a buffers\n");
 		kfree(card->mp_regs);
 		return -1;
 	}
@@ -1721,7 +1695,7 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 
 	card->curr_wr_port = 1;
 
-	PRINTM(MCMND, "mp_end_port %d, data port mask 0x%x\n",
+	dev_dbg(adapter->dev, "cmd: mp_end_port %d, data port mask 0x%x\n",
 	       port, card->mp_data_port_mask);
 }
 
@@ -1756,11 +1730,11 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 		data[4] = card->mpa_tx.pkt_aggr_limit;
 		data[5] = card->mpa_rx.pkt_aggr_limit;
 
-		PRINTM(MINFO, "Get Param: %d %d %d %d %d %d\n",
+		dev_dbg(adapter->dev, "info: Get Param: %d %d %d %d %d %d\n",
 		       data[0], data[1], data[2], data[3], data[4], data[5]);
 	} else {
 		if (priv->media_connected) {
-			PRINTM(MMSG, "SDIO MPA CTRL: not allowed "
+			dev_err(adapter->dev, "SDIO MPA CTRL: not allowed "
 			       "in connected state\n");
 			return -EINVAL;
 		}
@@ -1810,8 +1784,7 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 							   buf_size,
 							   card->mpa_rx.
 							   buf_size)) {
-				PRINTM(MERROR,
-				       "Failed to allocate "
+				dev_err(adapter->dev, "failed to alloc "
 				       "sdio mp-a buffers\n");
 				return -EINVAL;
 			}
@@ -1836,7 +1809,7 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 			return -EINVAL;
 		}
 
-		PRINTM(MINFO, "New Param: %d %d %d %d %d %d\n",
+		dev_dbg(adapter->dev, "info: new param: %d %d %d %d %d %d\n",
 		       card->mpa_tx.enabled,
 		       card->mpa_rx.enabled,
 		       card->mpa_tx.buf_size,
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 3de93d0..d73108f 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -75,8 +75,8 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 	u16 action = *((u16 *) data_buf);
 
 	if (cmd_action != HostCmd_ACT_GEN_SET) {
-		PRINTM(MERROR,
-		       "mwifiex_cmd_mac_control(): support SET only.\n");
+		dev_err(priv->adapter->dev,
+			"mac_control: only support set cmd\n");
 		return -1;
 	}
 
@@ -111,7 +111,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
 	u32 ul_temp;
 
-	PRINTM(MCMND, "SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
+	dev_dbg(priv->adapter->dev, "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
 		- 1 + S_DS_GEN);
@@ -180,8 +180,9 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	default:
 		break;
 	}
-	PRINTM(MCMND,
-	       "SNMP_CMD: Action=0x%x, OID=0x%x, OIDSize=0x%x, Value=0x%x\n",
+	dev_dbg(priv->adapter->dev,
+		"cmd: SNMP_CMD: Action=0x%x, OID=0x%x, OIDSize=0x%x,"
+		" Value=0x%x\n",
 	       cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
 	       le16_to_cpu(*(__le16 *) snmp_mib->value));
 	return 0;
@@ -357,7 +358,8 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	    != cpu_to_le32(HOST_SLEEP_CFG_CANCEL))
 	    && ((adapter->arp_filter_size > 0)
 		&& (adapter->arp_filter_size <= ARP_FILTER_MAX_BUF_SIZE))) {
-		PRINTM(MCMND, "Attach %d bytes ArpFilter to HSCfg cmd\n",
+		dev_dbg(adapter->dev,
+			"cmd: Attach %d bytes ArpFilter to HSCfg cmd\n",
 		       adapter->arp_filter_size);
 		memcpy(((u8 *) hs_cfg) +
 		       sizeof(struct host_cmd_ds_802_11_hs_cfg_enh),
@@ -382,7 +384,8 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		hs_cfg->params.hs_config.gpio =
 			data_buf->gpio;
 		hs_cfg->params.hs_config.gap = data_buf->gap;
-		PRINTM(MCMND, "HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
+		dev_dbg(adapter->dev,
+			"cmd: HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
 		       hs_cfg->params.hs_config.conditions,
 		       hs_cfg->params.hs_config.gpio,
 		       hs_cfg->params.hs_config.gap);
@@ -497,10 +500,7 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 	/* Set AP MAC address */
 	memcpy(deauth->mac_addr, (u8 *) data_buf, MWIFIEX_MAC_ADDR_LENGTH);
 
-	PRINTM(MCMND, "Deauth: %02x:%02x:%02x:%02x:%02x:%02x\n",
-	       deauth->mac_addr[0], deauth->mac_addr[1], deauth->mac_addr[2],
-	       deauth->mac_addr[3], deauth->mac_addr[4],
-	       deauth->mac_addr[5]);
+	dev_dbg(priv->adapter->dev, "cmd: Deauth: %pM\n", deauth->mac_addr);
 
 	deauth->reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
 
@@ -582,7 +582,8 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 		} else if (!priv->wep_key[i].key_length) {
 			continue;
 		} else {
-			PRINTM(MERROR, "key%d Length = %d is incorrect\n",
+			dev_err(priv->adapter->dev,
+				"key%d Length = %d is incorrect\n",
 			       (i + 1), priv->wep_key[i].key_length);
 			return -1;
 		}
@@ -637,7 +638,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		memset(&key_material->key_param_set, 0,
 		       sizeof(struct mwifiex_ie_type_key_param_set));
 	if (enc_key->is_wapi_key) {
-		PRINTM(MINFO, "Set WAPI Key\n");
+		dev_dbg(priv->adapter->dev, "info: Set WAPI Key\n");
 		key_material->key_param_set.key_type_id =
 			cpu_to_le16(KEY_TYPE_ID_WAPI);
 		if (cmd_oid == KEY_INFO_ENABLED)
@@ -685,7 +686,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		return ret;
 	}
 	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
-		PRINTM(MCMND, "WPA_AES\n");
+		dev_dbg(priv->adapter->dev, "cmd: WPA_AES\n");
 		key_material->key_param_set.key_type_id =
 			cpu_to_le16(KEY_TYPE_ID_AES);
 		if (cmd_oid == KEY_INFO_ENABLED)
@@ -703,7 +704,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			key_material->key_param_set.key_info |=
 				cpu_to_le16(KEY_INFO_AES_MCAST);
 	} else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
-		PRINTM(MCMND, "WPA_TKIP\n");
+		dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
 		key_material->key_param_set.key_type_id =
 			cpu_to_le16(KEY_TYPE_ID_TKIP);
 		key_material->key_param_set.key_info =
@@ -845,8 +846,9 @@ static int mwifiex_cmd_802_11_supplicant_pmk(
 	}
 	if ((cmd_action == HostCmd_ACT_GEN_SET) && ((pssid_tlv || pbssid_tlv)
 				&& (!ppmk_tlv && !ppassphrase_tlv))) {
-		PRINTM(MERROR, "Invalid case,ssid/bssid present without pmk "
-			       "or passphrase\n");
+		dev_err(priv->adapter->dev,
+			"invalid case, ssid/bssid present without"
+			" pmk or passphrase\n");
 		return -1;
 	}
 	cmd->command = cpu_to_le16(HostCmd_CMD_SUPPLICANT_PMK);
@@ -897,16 +899,13 @@ int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 		&domain_info->domain;
 	u8 no_of_triplet = adapter->domain_reg.no_of_triplet;
 
-	PRINTM(MINFO, "11D: no_of_triplet=0x%x\n", no_of_triplet);
+	dev_dbg(adapter->dev, "info: 11D: no_of_triplet=0x%x\n", no_of_triplet);
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11D_DOMAIN_INFO);
 	domain_info->action = cpu_to_le16(cmd_action);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
-		/* Dump domain info */
 		cmd->size = cpu_to_le16(sizeof(domain_info->action) +
-		S_DS_GEN);
-		HEXDUMP("11D: 802_11D_DOMAIN_INFO", (u8 *) cmd,
-				le16_to_cpu(cmd->size));
+							S_DS_GEN);
 		return 0;
 	}
 
@@ -934,9 +933,6 @@ int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 				S_DS_GEN);
 	}
 
-	HEXDUMP("11D: 802_11D_DOMAIN_INFO", (u8 *) cmd,
-			le16_to_cpu(cmd->size));
-
 	return 0;
 }
 
@@ -1337,7 +1333,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 					  data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
-		PRINTM(MCMND, "WMM: WMM_GET_STATUS cmd sent\n");
+		dev_dbg(priv->adapter->dev,
+			"cmd: WMM: WMM_GET_STATUS cmd sent\n");
 		cmd_ptr->command = cpu_to_le16(HostCmd_CMD_WMM_GET_STATUS);
 		cmd_ptr->size =
 			cpu_to_le16(sizeof(struct host_cmd_ds_wmm_get_status) +
@@ -1369,7 +1366,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = 0;
 		break;
 	default:
-		PRINTM(MERROR, "PREP_CMD: unknown command- %#x\n", cmd_no);
+		dev_err(priv->adapter->dev,
+			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
 		ret = -1;
 		break;
 	}
@@ -1488,7 +1486,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 			HostCmd_CMD_802_11_SNMP_MIB,
 			HostCmd_ACT_GEN_SET, DOT11D_I, NULL, &state_11d);
 	if (ret)
-		PRINTM(MERROR, "11D: Failed to enable 11D\n");
+		dev_err(priv->adapter->dev, "11D: failed to enable 11D\n");
 
 	/* set last_init_cmd */
 	priv->adapter->last_init_cmd = HostCmd_CMD_802_11_SNMP_MIB;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 7b96c75..cb56489 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -49,8 +49,8 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
-	PRINTM(MERROR, "CMD_RESP: cmd %#x error, result=%#x\n", resp->command,
-	       resp->result);
+	dev_err(adapter->dev, "CMD_RESP: cmd %#x error, result=%#x\n",
+			resp->command, resp->result);
 	if (wq_buf)
 		wq_buf->status = MWIFIEX_ERROR_FW_CMDRESP;
 
@@ -59,7 +59,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 		{
 			struct host_cmd_ds_802_11_ps_mode_enh *pm =
 				&resp->params.psmode_enh;
-			PRINTM(MERROR, "PS_MODE_ENH command failed: "
+			dev_err(adapter->dev, "PS_MODE_ENH cmd failed: "
 					"result=0x%x action=0x%X\n",
 					resp->result, le16_to_cpu(pm->action));
 			/* We do not re-try enter-ps command in ad-hoc mode. */
@@ -198,23 +198,25 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 	u16 query_type = le16_to_cpu(smib->query_type);
 	u32 ul_temp;
 
-	PRINTM(MINFO, "SNMP_RESP: value of the oid = 0x%x, query_type=0x%x\n",
-	       oid, query_type);
-	PRINTM(MINFO, "SNMP_RESP: Buf size  = 0x%x\n",
-	       le16_to_cpu(smib->buf_size));
+	dev_dbg(priv->adapter->dev, "info: SNMP_RESP: oid value = %#x,"
+			" query_type = %#x, buf size = %#x\n",
+			oid, query_type, le16_to_cpu(smib->buf_size));
 	if (query_type == HostCmd_ACT_GEN_GET) {
 		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
 		if (data_buf)
 			*(u32 *)data_buf = ul_temp;
 		switch (oid) {
 		case FRAG_THRESH_I:
-			PRINTM(MINFO, "SNMP_RESP: FragThsd =%u\n", ul_temp);
+			dev_dbg(priv->adapter->dev,
+				"info: SNMP_RESP: FragThsd =%u\n", ul_temp);
 			break;
 		case RTS_THRESH_I:
-			PRINTM(MINFO, "SNMP_RESP: RTSThsd =%u\n", ul_temp);
+			dev_dbg(priv->adapter->dev,
+				"info: SNMP_RESP: RTSThsd =%u\n", ul_temp);
 			break;
 		case SHORT_RETRY_LIM_I:
-			PRINTM(MINFO, "SNMP_RESP: TxRetryCount=%u\n", ul_temp);
+			dev_dbg(priv->adapter->dev,
+				"info: SNMP_RESP: TxRetryCount=%u\n", ul_temp);
 			break;
 		default:
 			break;
@@ -472,11 +474,12 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 		}
 		break;
 	default:
-		PRINTM(MERROR, "CMD_RESP: unknown command action %d\n", action);
+		dev_err(adapter->dev, "CMD_RESP: unknown cmd action %d\n",
+				action);
 		return 0;
 	}
-	PRINTM(MINFO,
-	       "Current TxPower Level = %d, Max Power=%d, Min Power=%d\n",
+	dev_dbg(adapter->dev,
+		"info: Current TxPower Level = %d, Max Power=%d, Min Power=%d\n",
 	       priv->tx_power_level, priv->max_tx_power_level,
 	       priv->min_tx_power_level);
 
@@ -533,10 +536,8 @@ static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 	memcpy(priv->curr_addr, cmd_mac_addr->mac_addr,
 		MWIFIEX_MAC_ADDR_LENGTH);
 
-	PRINTM(MINFO, "set mac address: %02x:%02x:%02x:%02x:%02x:%02x\n",
-	       priv->curr_addr[0], priv->curr_addr[1], priv->curr_addr[2],
-	       priv->curr_addr[3], priv->curr_addr[4],
-	       priv->curr_addr[5]);
+	dev_dbg(priv->adapter->dev,
+		"info: set mac address: %pM\n", priv->curr_addr);
 
 	return 0;
 }
@@ -624,7 +625,7 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 	if (le16_to_cpu(key->action) == HostCmd_ACT_GEN_SET) {
 		if ((le16_to_cpu(key->key_param_set.key_info) &
 		     KEY_INFO_TKIP_MCAST)) {
-			PRINTM(MINFO, "key: GTK is set\n");
+			dev_dbg(priv->adapter->dev, "info: key: GTK is set\n");
 			priv->wpa_is_gtk_set = true;
 			priv->scan_block = false;
 		}
@@ -636,9 +637,6 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 	memcpy(priv->aes_key.key_param_set.key, key->key_param_set.key,
 	       le16_to_cpu(priv->aes_key.key_param_set.key_len));
 
-	HEXDUMP("CMD_RESP (Key_Material)", priv->aes_key.key_param_set.key,
-		priv->aes_key.key_param_set.key_len);
-
 	return 0;
 }
 
@@ -773,7 +771,8 @@ static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 				}
 			}
 		} else if (action == HostCmd_ACT_GEN_SET) {
-			PRINTM(MINFO, "Esupp PMK set: enable ewpa query\n");
+			dev_dbg(priv->adapter->dev,
+				"info: Esupp PMK set: enable ewpa query\n");
 			priv->ewpa_query = true;
 		}
 	}
@@ -816,7 +815,7 @@ static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 					head;
 				esupp_mode->rsn_mode =
 					le16_to_cpu(encr_proto_tlv->rsn_mode);
-				PRINTM(MINFO, "rsn_mode=0x%x\n",
+				dev_dbg(priv->adapter->dev, "info: rsn_mode=0x%x\n",
 					esupp_mode->rsn_mode);
 				break;
 			case TLV_TYPE_CIPHER:
@@ -826,8 +825,8 @@ static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 					pcipher_tlv->pair_cipher;
 				esupp_mode->act_groupcipher =
 					pcipher_tlv->group_cipher;
-				PRINTM(MINFO, "paircipher=0x%x, "
-					      "groupcipher=0x%x\n",
+				dev_dbg(priv->adapter->dev,
+					"info: paircipher=0x%x, groupcipher=0x%x\n",
 					      esupp_mode->act_paircipher,
 					      esupp_mode->act_groupcipher);
 				break;
@@ -854,22 +853,19 @@ int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	u16 action = le16_to_cpu(domain_info->action);
 	u8 no_of_triplet = 0;
 
-	/* Dump domain info response data */
-	HEXDUMP("11D: DOMAIN Info Rsp Data", (u8 *) resp, resp->size);
-
 	no_of_triplet =
 		(u8) ((le16_to_cpu(domain->header.len) -
 					3) / sizeof(struct
 					ieee80211_country_ie_triplet));
 	/* Country code is 3 bytes */
 
-	PRINTM(MINFO, "11D Domain Info Resp: no_of_triplet=%d\n",
-					no_of_triplet);
+	dev_dbg(priv->adapter->dev, "info: 11D Domain Info Resp:"
+			" no_of_triplet=%d\n", no_of_triplet);
 
 	if (no_of_triplet > MWIFIEX_MAX_TRIPLET_802_11D) {
-		PRINTM(MWARN, "11D: Invalid number of triplets %d "
-				"returned!!\n",
-				no_of_triplet);
+		dev_warn(priv->adapter->dev,
+			"11D: invalid number of triplets %d "
+			"returned!!\n", no_of_triplet);
 		return -1;
 	}
 
@@ -879,8 +875,8 @@ int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	case HostCmd_ACT_GEN_GET:
 		break;
 	default:
-		PRINTM(MERROR, "11D: Invalid Action:%d\n",
-			domain_info->action);
+		dev_err(priv->adapter->dev,
+			"11D: invalid action:%d\n", domain_info->action);
 		return -1;
 	}
 
@@ -902,7 +898,7 @@ static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 	u16 new_channel = le16_to_cpu(rf_channel->current_channel);
 
 	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
-		PRINTM(MCMND, "Channel Switch: %d to %d\n",
+		dev_dbg(priv->adapter->dev, "cmd: Channel Switch: %d to %d\n",
 		       priv->curr_bss_params.bss_descriptor.channel,
 		       new_channel);
 		/* Update the channel again */
@@ -927,7 +923,8 @@ static int mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_rf_antenna *antenna = &resp->params.antenna;
 	u32 *ant = (u32 *)data_buf;
 
-	PRINTM(MINFO, "RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
+	dev_dbg(priv->adapter->dev,
+		"info: RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
 		      le16_to_cpu(antenna->action),
 		      le16_to_cpu(antenna->antenna_mode));
 
@@ -1039,26 +1036,23 @@ static int mwifiex_ret_reg_access(u16 type,
 					*cmd_eeprom =
 					(struct host_cmd_ds_802_11_eeprom_access
 					 *) &resp->params.eeprom;
-				PRINTM(MINFO, "EEPROM read len=%x\n",
+				pr_debug("info: EEPROM read len=%x\n",
 				       cmd_eeprom->byte_count);
 				if (le16_to_cpu(eeprom->byte_count) <
 						le16_to_cpu(
 						cmd_eeprom->byte_count)) {
 					eeprom->byte_count = cpu_to_le16(0);
-					PRINTM(MINFO, "EEPROM read return "
+					pr_debug("info: EEPROM read "
 							"length is too big\n");
 					return -1;
 				}
 				eeprom->offset = cmd_eeprom->offset;
 				eeprom->byte_count = cmd_eeprom->byte_count;
-				if (le16_to_cpu(eeprom->byte_count) > 0) {
+				if (le16_to_cpu(eeprom->byte_count) > 0)
 					memcpy(&eeprom->value,
 					       &cmd_eeprom->value,
 					       le16_to_cpu(eeprom->byte_count));
-					HEXDUMP("EEPROM",
-						(char *) &eeprom->value,
-						eeprom->byte_count);
-				}
+
 				break;
 			}
 		default:
@@ -1085,14 +1079,12 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
 		return 0;
 
-	PRINTM(MINFO, "New BSSID %02x:%02x:%02x:%02x:%02x:%02x\n",
-	       ibss_coal_resp->bssid[0], ibss_coal_resp->bssid[1],
-	       ibss_coal_resp->bssid[2], ibss_coal_resp->bssid[3],
-	       ibss_coal_resp->bssid[4], ibss_coal_resp->bssid[5]);
+	dev_dbg(priv->adapter->dev,
+		"info: new BSSID %pM\n", ibss_coal_resp->bssid);
 
 	/* If rsp has NULL BSSID, Just return..... No Action */
 	if (!memcmp(ibss_coal_resp->bssid, zero_mac, MWIFIEX_MAC_ADDR_LENGTH)) {
-		PRINTM(MMSG, "New BSSID is NULL\n");
+		dev_warn(priv->adapter->dev, "new BSSID is NULL\n");
 		return 0;
 	}
 
@@ -1165,7 +1157,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
 		ret = mwifiex_ret_802_11_scan(priv, resp, wait_queue);
-		PRINTM(MINFO, "CMD_RESP: BG_SCAN result is ready!\n");
+		dev_dbg(adapter->dev,
+			"info: CMD_RESP: BG_SCAN result is ready!\n");
 		break;
 	case HostCmd_CMD_TXPWR_CFG:
 		ret = mwifiex_ret_tx_power_cfg(priv, resp, data_buf);
@@ -1245,7 +1238,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 						MWIFIEX_SDIO_BLOCK_SIZE) *
 						MWIFIEX_SDIO_BLOCK_SIZE;
 		adapter->curr_tx_buf_size = adapter->tx_buf_size;
-		PRINTM(MCMND, "max_tx_buf_size=%d, tx_buf_size=%d\n",
+		dev_dbg(adapter->dev,
+			"cmd: max_tx_buf_size=%d, tx_buf_size=%d\n",
 		       adapter->max_tx_buf_size, adapter->tx_buf_size);
 
 		if (adapter->if_ops.update_mp_end_port)
@@ -1278,7 +1272,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 		ret = mwifiex_ret_11n_cfg(priv, resp, data_buf);
 		break;
 	default:
-		PRINTM(MERROR, "CMD_RESP: Unknown command response %#x\n",
+		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 		       resp->command);
 		break;
 	}
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index d9ace43..bdea2fc 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -49,7 +49,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	if (!priv->media_connected)
 		return;
 
-	PRINTM(MINFO, "Handles disconnect event.\n");
+	dev_dbg(adapter->dev, "info: handles disconnect event\n");
 
 	priv->media_connected = false;
 
@@ -94,10 +94,10 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	 * it could be used for re-assoc
 	 */
 
-	PRINTM(MINFO, "Previous SSID=%s, SSID Length=%u\n",
+	dev_dbg(adapter->dev, "info: previous SSID=%s, SSID len=%u\n",
 	       priv->prev_ssid.ssid, priv->prev_ssid.ssid_len);
 
-	PRINTM(MINFO, "Current SSID=%s, SSID Length=%u\n",
+	dev_dbg(adapter->dev, "info: current SSID=%s, SSID len=%u\n",
 	       priv->curr_bss_params.bss_descriptor.ssid.ssid,
 	       priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
 
@@ -120,8 +120,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	priv->media_connected = false;
 	if (!priv->disconnect) {
 		priv->disconnect = 1;
-		PRINTM(MINFO, "Successfully disconnected from %pM:"
-				" Reason code %d\n", priv->cfg_bssid,
+		dev_dbg(adapter->dev, "info: successfully disconnected from"
+				" %pM: reason code %d\n", priv->cfg_bssid,
 				WLAN_REASON_DEAUTH_LEAVING);
 		cfg80211_disconnected(priv->netdev,
 				WLAN_REASON_DEAUTH_LEAVING, NULL, 0,
@@ -196,11 +196,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
-		PRINTM(MERROR, "Invalid EVENT: DUMMY_HOST_WAKEUP_SIGNAL,"
+		dev_err(adapter->dev, "invalid EVENT: DUMMY_HOST_WAKEUP_SIGNAL,"
 				" ignoring it\n");
 		break;
 	case EVENT_LINK_SENSED:
-		PRINTM(MEVENT, "EVENT: LINK_SENSED\n");
+		dev_dbg(adapter->dev, "event: LINK_SENSED\n");
 		if (!netif_carrier_ok(priv->netdev))
 			netif_carrier_on(priv->netdev);
 		if (netif_queue_stopped(priv->netdev))
@@ -208,29 +208,28 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_DEAUTHENTICATED:
-		PRINTM(MEVENT, "EVENT: Deauthenticated\n");
+		dev_dbg(adapter->dev, "event: Deauthenticated\n");
 		adapter->dbg.num_event_deauth++;
 		if (priv->media_connected)
 			mwifiex_reset_connect_state(priv);
 		break;
 
 	case EVENT_DISASSOCIATED:
-		PRINTM(MEVENT, "EVENT: Disassociated\n");
+		dev_dbg(adapter->dev, "event: Disassociated\n");
 		adapter->dbg.num_event_disassoc++;
 		if (priv->media_connected)
 			mwifiex_reset_connect_state(priv);
 		break;
 
 	case EVENT_LINK_LOST:
-		PRINTM(MEVENT, "EVENT: Link lost\n");
+		dev_dbg(adapter->dev, "event: Link lost\n");
 		adapter->dbg.num_event_link_lost++;
 		if (priv->media_connected)
 			mwifiex_reset_connect_state(priv);
 		break;
 
 	case EVENT_PS_SLEEP:
-		PRINTM(MINFO, "EVENT: SLEEP\n");
-		PRINTM(MEVENT, "_");
+		dev_dbg(adapter->dev, "info: EVENT: SLEEP\n");
 
 		adapter->ps_state = PS_STATE_PRE_SLEEP;
 
@@ -238,13 +237,13 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_PS_AWAKE:
-		PRINTM(MINFO, "EVENT: AWAKE\n");
-		PRINTM(MEVENT, "|");
+		dev_dbg(adapter->dev, "info: EVENT: AWAKE\n");
 		if (!adapter->pps_uapsd_mode &&
 			priv->media_connected &&
 			adapter->sleep_period.period) {
 				adapter->pps_uapsd_mode = true;
-				PRINTM(MEVENT, "PPS/UAPSD mode activated\n");
+				dev_dbg(adapter->dev,
+					"event: PPS/UAPSD mode activated\n");
 		}
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
@@ -268,31 +267,31 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_DEEP_SLEEP_AWAKE:
 		adapter->if_ops.wakeup_complete(adapter);
-		PRINTM(MEVENT, "EVENT: DS_AWAKE\n");
+		dev_dbg(adapter->dev, "event: DS_AWAKE\n");
 		if (adapter->is_deep_sleep)
 			adapter->is_deep_sleep = false;
 		break;
 
 	case EVENT_HS_ACT_REQ:
-		PRINTM(MEVENT, "EVENT: HS_ACT_REQ\n");
+		dev_dbg(adapter->dev, "event: HS_ACT_REQ\n");
 		ret = mwifiex_prepare_cmd(priv,
 					  HostCmd_CMD_802_11_HS_CFG_ENH,
 					  0, 0, NULL, NULL);
 		break;
 
 	case EVENT_MIC_ERR_UNICAST:
-		PRINTM(MEVENT, "EVENT: UNICAST MIC ERROR\n");
+		dev_dbg(adapter->dev, "event: UNICAST MIC ERROR\n");
 		break;
 
 	case EVENT_MIC_ERR_MULTICAST:
-		PRINTM(MEVENT, "EVENT: MULTICAST MIC ERROR\n");
+		dev_dbg(adapter->dev, "event: MULTICAST MIC ERROR\n");
 		break;
 	case EVENT_MIB_CHANGED:
 	case EVENT_INIT_DONE:
 		break;
 
 	case EVENT_ADHOC_BCN_LOST:
-		PRINTM(MEVENT, "EVENT: ADHOC_BCN_LOST\n");
+		dev_dbg(adapter->dev, "event: ADHOC_BCN_LOST\n");
 		priv->adhoc_is_link_sensed = false;
 		mwifiex_clean_txrx(priv);
 		if (!netif_queue_stopped(priv->netdev))
@@ -302,7 +301,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_BG_SCAN_REPORT:
-		PRINTM(MEVENT, "EVENT: BGS_REPORT\n");
+		dev_dbg(adapter->dev, "event: BGS_REPORT\n");
 		/* Clear the previous scan result */
 		memset(adapter->scan_table, 0x00,
 		       sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP);
@@ -314,93 +313,95 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_PORT_RELEASE:
-		PRINTM(MEVENT, "EVENT: PORT RELEASE\n");
+		dev_dbg(adapter->dev, "event: PORT RELEASE\n");
 		break;
 
 	case EVENT_WMM_STATUS_CHANGE:
-		PRINTM(MEVENT, "EVENT: WMM status changed\n");
+		dev_dbg(adapter->dev, "event: WMM status changed\n");
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_WMM_GET_STATUS,
 				0, 0, NULL, NULL);
 		break;
 
 	case EVENT_RSSI_LOW:
-		PRINTM(MEVENT, "EVENT: Beacon RSSI_LOW\n");
+		dev_dbg(adapter->dev, "event: Beacon RSSI_LOW\n");
 		break;
 	case EVENT_SNR_LOW:
-		PRINTM(MEVENT, "EVENT: Beacon SNR_LOW\n");
+		dev_dbg(adapter->dev, "event: Beacon SNR_LOW\n");
 		break;
 	case EVENT_MAX_FAIL:
-		PRINTM(MEVENT, "EVENT: MAX_FAIL\n");
+		dev_dbg(adapter->dev, "event: MAX_FAIL\n");
 		break;
 	case EVENT_RSSI_HIGH:
-		PRINTM(MEVENT, "EVENT: Beacon RSSI_HIGH\n");
+		dev_dbg(adapter->dev, "event: Beacon RSSI_HIGH\n");
 		break;
 	case EVENT_SNR_HIGH:
-		PRINTM(MEVENT, "EVENT: Beacon SNR_HIGH\n");
+		dev_dbg(adapter->dev, "event: Beacon SNR_HIGH\n");
 		break;
 	case EVENT_DATA_RSSI_LOW:
-		PRINTM(MEVENT, "EVENT: Data RSSI_LOW\n");
+		dev_dbg(adapter->dev, "event: Data RSSI_LOW\n");
 		break;
 	case EVENT_DATA_SNR_LOW:
-		PRINTM(MEVENT, "EVENT: Data SNR_LOW\n");
+		dev_dbg(adapter->dev, "event: Data SNR_LOW\n");
 		break;
 	case EVENT_DATA_RSSI_HIGH:
-		PRINTM(MEVENT, "EVENT: Data RSSI_HIGH\n");
+		dev_dbg(adapter->dev, "event: Data RSSI_HIGH\n");
 		break;
 	case EVENT_DATA_SNR_HIGH:
-		PRINTM(MEVENT, "EVENT: Data SNR_HIGH\n");
+		dev_dbg(adapter->dev, "event: Data SNR_HIGH\n");
 		break;
 	case EVENT_LINK_QUALITY:
-		PRINTM(MEVENT, "EVENT: Link Quality\n");
+		dev_dbg(adapter->dev, "event: Link Quality\n");
 		break;
 	case EVENT_PRE_BEACON_LOST:
-		PRINTM(MEVENT, "EVENT: Pre-Beacon Lost\n");
+		dev_dbg(adapter->dev, "event: Pre-Beacon Lost\n");
 		break;
 	case EVENT_IBSS_COALESCED:
-		PRINTM(MEVENT, "EVENT: IBSS_COALESCED\n");
+		dev_dbg(adapter->dev, "event: IBSS_COALESCED\n");
 		ret = mwifiex_prepare_cmd(priv,
 				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
 				HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 		break;
 	case EVENT_ADDBA:
-		PRINTM(MEVENT, "EVENT: ADDBA Request\n");
+		dev_dbg(adapter->dev, "event: ADDBA Request\n");
 		mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
 				    HostCmd_ACT_GEN_SET, 0, NULL,
 				    adapter->event_body);
 		break;
 	case EVENT_DELBA:
-		PRINTM(MEVENT, "EVENT: DELBA Request\n");
+		dev_dbg(adapter->dev, "event: DELBA Request\n");
 		mwifiex_11n_delete_ba_stream(priv, adapter->event_body);
 		break;
 	case EVENT_BA_STREAM_TIEMOUT:
-		PRINTM(MEVENT, "EVENT:  BA Stream timeout\n");
+		dev_dbg(adapter->dev, "event:  BA Stream timeout\n");
 		mwifiex_11n_ba_stream_timeout(priv,
 					      (struct host_cmd_ds_11n_batimeout
 					       *)
 					      adapter->event_body);
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
-		PRINTM(MEVENT, "EVENT:  AMSDU_AGGR_CTRL %d\n",
+		dev_dbg(adapter->dev, "event:  AMSDU_AGGR_CTRL %d\n",
 		       *(u16 *) adapter->event_body);
 		adapter->tx_buf_size =
 			min(adapter->curr_tx_buf_size,
 			    le16_to_cpu(*(__le16 *) adapter->event_body));
-		PRINTM(MEVENT, "tx_buf_size %d\n", adapter->tx_buf_size);
+		dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
+				adapter->tx_buf_size);
 		break;
 
 	case EVENT_WEP_ICV_ERR:
-		PRINTM(MEVENT, "EVENT: WEP ICV error\n");
+		dev_dbg(adapter->dev, "event: WEP ICV error\n");
 		break;
 
 	case EVENT_BW_CHANGE:
-		PRINTM(MEVENT, "EVENT: BW Change\n");
+		dev_dbg(adapter->dev, "event: BW Change\n");
 		break;
 
 	case EVENT_HOSTWAKE_STAIE:
-		PRINTM(MEVENT, "EVENT: HOSTWAKE_STAIE %d\n", eventcause);
+		dev_dbg(adapter->dev, "event: HOSTWAKE_STAIE %d\n", eventcause);
 		break;
 	default:
-		PRINTM(MEVENT, "EVENT: unknown event id: %#x\n", eventcause);
+		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
+						eventcause);
 		break;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 01abe99..a6f0c62 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -66,7 +66,8 @@ mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
 	wait = (struct mwifiex_wait_queue *)
 		kzalloc(sizeof(struct mwifiex_wait_queue), GFP_ATOMIC);
 	if (!wait) {
-		PRINTM(MERROR, "%s:Fail to alloc wait buffer\n", __func__);
+		dev_err(priv->adapter->dev, "%s: fail to alloc buffer\n",
+						__func__);
 		return wait;
 	}
 
@@ -140,7 +141,7 @@ mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
 	}
 	if (cancel_flag) {
 		mwifiex_cancel_pending_ioctl(priv->adapter, wait);
-		PRINTM(MCMND, "IOCTL cancel: wait=%p, wait_option=%d\n",
+		dev_dbg(priv->adapter->dev, "cmd: IOCTL cancel: wait=%p, wait_option=%d\n",
 			wait, wait_option);
 	}
 
@@ -157,7 +158,7 @@ int mwifiex_request_ioctl(struct mwifiex_private *priv,
 {
 	switch (status) {
 	case -EINPROGRESS:
-		PRINTM(MCMND, "IOCTL pending: wait=%p, wait_option=%d\n",
+		dev_dbg(priv->adapter->dev, "cmd: IOCTL pending: wait=%p, wait_option=%d\n",
 				wait, wait_option);
 		atomic_inc(&priv->adapter->ioctl_pending);
 		/* Status pending, wake up main process */
@@ -200,14 +201,11 @@ int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 					       NULL);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (!status) {
+	if (!status)
 		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
-		HEXDUMP("priv->MacAddr:", priv->curr_addr, ETH_ALEN);
-	} else {
-		PRINTM(MERROR,
-		       "set mac address failed! status=%d, error_code=0x%lx\n",
-		       status, wait->status);
-	}
+	else
+		dev_err(priv->adapter->dev, "set mac address failed: status=%d"
+				" error_code=%#x\n", status, wait->status);
 
 	kfree(wait);
 	return status;
@@ -414,7 +412,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	struct mwifiex_ds_hs_cfg hscfg;
 
 	if (adapter->hs_activated) {
-		PRINTM(MCMND, "HS Already actived\n");
+		dev_dbg(adapter->dev, "cmd: HS Already actived\n");
 		return true;
 	}
 
@@ -428,7 +426,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 						       MWIFIEX_BSS_ROLE_STA),
 				      HostCmd_ACT_GEN_SET,
 				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
-		PRINTM(MERROR, "IOCTL request HS enable failed\n");
+		dev_err(adapter->dev, "IOCTL request HS enable failed\n");
 		return false;
 	}
 
@@ -454,13 +452,14 @@ int mwifiex_get_info_signal(struct mwifiex_private *priv,
 	int ret = 0;
 
 	if (!wait) {
-		PRINTM(MERROR, "WAIT information is not present\n");
+		dev_err(priv->adapter->dev, "WAIT information is not present\n");
 		return -1;
 	}
 
 	/* Signal info can be obtained only if connected */
 	if (!priv->media_connected) {
-		PRINTM(MINFO, "Can not get signal in disconnected state\n");
+		dev_dbg(priv->adapter->dev,
+			"info: Can not get signal in disconnected state\n");
 		return -1;
 	}
 
@@ -487,7 +486,7 @@ int mwifiex_get_info_stats(struct mwifiex_private *priv,
 	int ret = 0;
 
 	if (!wait) {
-		PRINTM(MERROR, "MWIFIEX IOCTL information is not present\n");
+		dev_err(priv->adapter->dev, "MWIFIEX IOCTL information is not present\n");
 		return -1;
 	}
 
@@ -734,7 +733,7 @@ int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 		     (u16) (RF_ANTENNA_1 + adapter->number_of_antenna))
 		    && (*antenna != RF_ANTENNA_AUTO
 			|| adapter->number_of_antenna <= 1)) {
-			PRINTM(MERROR, "Invalid antenna setting\n");
+			dev_err(adapter->dev, "invalid antenna setting\n");
 			return -1;
 		}
 	}
@@ -802,7 +801,7 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 		return -1;
 
 	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
-		PRINTM(MINFO, "Enable Promiscuous mode\n");
+		dev_dbg(priv->adapter->dev, "info: Enable Promiscuous mode\n");
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
 		priv->curr_pkt_filter &=
 			~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
@@ -810,14 +809,16 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
 		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
-			PRINTM(MINFO, "Enabling All Multicast!\n");
+			dev_dbg(priv->adapter->dev,
+				"info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
 				HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
 		} else {
 			priv->curr_pkt_filter &=
 				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
 			if (mcast_list->num_multicast_addr) {
-				PRINTM(MINFO, "Set multicast list=%d\n",
+				dev_dbg(priv->adapter->dev,
+					"info: Set multicast list=%d\n",
 				       mcast_list->num_multicast_addr);
 				/* Set multicast addresses to firmware */
 				if (old_pkt_filter == priv->curr_pkt_filter) {
@@ -837,7 +838,8 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 			}
 		}
 	}
-	PRINTM(MINFO, "old_pkt_filter=0x%lx, curr_pkt_filter=0x%lx\n",
+	dev_dbg(priv->adapter->dev,
+		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
 	       old_pkt_filter, priv->curr_pkt_filter);
 	if (old_pkt_filter != priv->curr_pkt_filter) {
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
@@ -923,7 +925,7 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 		}
 	}
 	if (!cfp || !cfp->channel) {
-		PRINTM(MERROR, "Invalid channel/freq\n");
+		dev_err(adapter->dev, "invalid channel/freq\n");
 		return -1;
 	}
 	priv->adhoc_channel = (u8) cfp->channel;
@@ -957,7 +959,8 @@ int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
 	}
 
 	if ((priv->bss_mode == *mode) || (*mode == MWIFIEX_BSS_MODE_AUTO)) {
-		PRINTM(MINFO, "Already set to required mode! No change!\n");
+		dev_dbg(priv->adapter->dev,
+			"info: Already set to required mode! No change!\n");
 		priv->bss_mode = *mode;
 		return 0;
 	}
@@ -1013,8 +1016,8 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		}
 
 		if (i >= 0) {
-			PRINTM(MINFO,
-			       "SSID found in scan list ... associating...\n");
+			dev_dbg(adapter->dev,
+				"info: SSID found in scan list ... associating...\n");
 
 			/* Clear any past association response stored for
 			   application retrieval */
@@ -1036,7 +1039,7 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 			return 0;
 
 		/* Exit Adhoc mode first */
-		PRINTM(MINFO, "Sending Adhoc Stop\n");
+		dev_dbg(adapter->dev, "info: Sending Adhoc Stop\n");
 		ret = mwifiex_deauthenticate(priv, NULL, NULL);
 		if (ret)
 			return ret;
@@ -1055,15 +1058,15 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		}
 
 		if (i >= 0) {
-			PRINTM(MINFO,
-			       "Network found in scan list ... joining ...\n");
+			dev_dbg(adapter->dev, "info: network found in scan"
+							" list. Joining...\n");
 			ret = mwifiex_adhoc_join(priv, wait,
 						 &adapter->scan_table[i]);
 			if (ret)
 				return ret;
 		} else {	/* i >= 0 */
-			PRINTM(MINFO, "Network not found in the list, "
-			       "creating adhoc with ssid = %s\n",
+			dev_dbg(adapter->dev, "info: Network not found in "
+				"the list, creating adhoc with ssid = %s\n",
 			       ssid_bssid->ssid.ssid);
 			ret = mwifiex_adhoc_start(priv, wait,
 						  &ssid_bssid->ssid);
@@ -1141,10 +1144,7 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 					       priv->bss_mode);
 		if (i < 0) {
 			memcpy(mac, ssid_bssid->bssid, sizeof(mac));
-			PRINTM(MERROR, "Can not find bssid "
-					"%02x:%02x:%02x:%02x:%02x:%02x\n",
-					mac[0], mac[1], mac[2],
-					mac[3], mac[4], mac[5]);
+			dev_err(adapter->dev, "cannot find bssid %pM\n", mac);
 			return -1;
 		}
 		bss_desc = &adapter->scan_table[i];
@@ -1155,7 +1155,7 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 					      &ssid_bssid->ssid, NULL,
 					      priv->bss_mode);
 		if (i < 0) {
-			PRINTM(MERROR, "Can not find ssid %s\n",
+			dev_err(adapter->dev, "cannot find ssid %s\n",
 					ssid_bssid->ssid.ssid);
 			return -1;
 		}
@@ -1220,7 +1220,8 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 		ret = 0;
 		goto done;
 	}
-	PRINTM(MCMND, "Updating Channel from %d to %d\n", curr_chan, channel);
+	dev_dbg(priv->adapter->dev, "cmd: updating channel from %d to %d\n",
+			curr_chan, channel);
 
 	if (!bss_info.media_connected) {
 		ret = 0;
@@ -1338,7 +1339,7 @@ static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 			rate_cfg->rate = supported_rates_n[0] & 0x7f;
 			break;
 		default:
-			PRINTM(MMSG, "Invalid Band 0x%x\n",
+			dev_warn(adapter->dev, "invalid band %#x\n",
 			       adapter->config_bands);
 			break;
 		}
@@ -1389,13 +1390,13 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 		mwifiex_get_active_data_rates(priv, rates);
 		rate = rates;
 		for (i = 0; (rate[i] && i < MWIFIEX_SUPPORTED_RATES); i++) {
-			PRINTM(MINFO, "Rate=0x%X  Wanted=0x%X\n", rate[i],
-			       rate_cfg->rate);
+			dev_dbg(adapter->dev, "info: rate=%#x wanted=%#x\n",
+				rate[i], rate_cfg->rate);
 			if ((rate[i] & 0x7f) == (rate_cfg->rate & 0x7f))
 				break;
 		}
 		if (!rate[i] || (i == MWIFIEX_SUPPORTED_RATES)) {
-			PRINTM(MERROR, "The fixed data rate 0x%X is out "
+			dev_err(adapter->dev, "fixed data rate %#x is out "
 			       "of range\n", rate_cfg->rate);
 			return -1;
 		}
@@ -1475,7 +1476,8 @@ static int mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
 			bitmap_rates[i + 2] = 0xFFFF;
 		bitmap_rates[9] = 0x3FFF;
 	} else {
-		PRINTM(MINFO, "Rate index is %d\n", rate_index);
+		dev_dbg(priv->adapter->dev, "info: Rate index is %d\n",
+			rate_index);
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
 		/* Bitmap of HR/DSSS rates */
 		if (rate_index >= MWIFIEX_RATE_INDEX_HRDSSS0 &&
@@ -1495,7 +1497,8 @@ static int mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
 				      16);
 	}
 
-	PRINTM(MINFO, "RateBitmap=%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x, "
+	dev_dbg(priv->adapter->dev, "info: RateBitmap="
+		"%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x, "
 	       "IsRateAuto=%d, DataRate=%d\n",
 	       bitmap_rates[9], bitmap_rates[8],
 	       bitmap_rates[7], bitmap_rates[6],
@@ -1573,8 +1576,8 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 		dbm = (u16) power_cfg->power_level;
 		if ((dbm < priv->min_tx_power_level) ||
 		    (dbm > priv->max_tx_power_level)) {
-			PRINTM(MERROR, "The set txpower value %d dBm is out of "
-					"range (%d dBm-%d dBm)!\n",
+			dev_err(priv->adapter->dev, "txpower value %d dBm"
+					" is out of range (%d dBm-%d dBm)\n",
 					dbm, priv->min_tx_power_level,
 					priv->max_tx_power_level);
 			return -1;
@@ -1582,7 +1585,8 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 	}
 	buf = kzalloc(MWIFIEX_SIZE_OF_CMD_BUFFER, GFP_KERNEL);
 	if (!buf) {
-		PRINTM(MERROR, "%s: failed to alloc cmd buffer\n", __func__);
+		dev_err(priv->adapter->dev, "%s: failed to alloc cmd buffer\n",
+				__func__);
 		return -1;
 	}
 
@@ -1702,8 +1706,8 @@ int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 	switch (action) {
 	case HostCmd_ACT_GEN_SET:
 		if (adapter->pps_uapsd_mode) {
-			PRINTM(MINFO, "Host Sleep IOCTL is blocked in UAPSD/PPS"
-				      " mode\n");
+			dev_dbg(adapter->dev, "info: Host Sleep IOCTL"
+				" is blocked in UAPSD/PPS mode\n");
 			status = -1;
 			break;
 		}
@@ -1790,23 +1794,24 @@ int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
 
 	if (adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
 	    DEEP_SLEEP_ON) {
-		PRINTM(MMSG, "Station already in enhanced deep"
+		dev_err(adapter->dev, "station already in enhanced deep"
 				" sleep mode\n");
 		return -1;
 	} else if (!adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
 		   DEEP_SLEEP_OFF) {
-		PRINTM(MMSG, "Station already not in enhanced "
+		dev_err(adapter->dev, "station already not in enhanced "
 				"deep sleep mode\n");
 		return -1;
 	}
 
 	if (auto_deep_sleep->auto_ds == DEEP_SLEEP_ON) {
 		auto_deep_sleep->auto_ds = DEEP_SLEEP_ON;
-		PRINTM(MINFO, "Auto Deep Sleep: on\n");
+		dev_dbg(adapter->dev, "info: Auto Deep Sleep: on\n");
 		mode = EN_AUTO_PS;
 	} else {
 		auto_deep_sleep->auto_ds = DEEP_SLEEP_OFF;
-		PRINTM(MINFO, "AutoAUTO_DEEP_SLEEP Deep Sleep: off\n");
+		dev_dbg(adapter->dev,
+			"info: AutoAUTO_DEEP_SLEEP Deep Sleep: off\n");
 		mode = DIS_AUTO_PS;
 	}
 
@@ -1854,14 +1859,15 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 {
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wpa_ie)) {
-			PRINTM(MERROR, "failed to copy WPA IE, too big\n");
+			dev_err(priv->adapter->dev,
+				"failed to copy WPA IE, too big\n");
 			return -1;
 		}
 		memcpy(priv->wpa_ie, ie_data_ptr, ie_len);
 		priv->wpa_ie_len = (u8) ie_len;
-		PRINTM(MCMND, "Set Wpa_ie_len=%d IE=%#x\n", priv->wpa_ie_len,
-		       priv->wpa_ie[0]);
-		DBG_HEXDUMP(MCMD_D, "Wpa_ie", priv->wpa_ie, priv->wpa_ie_len);
+		dev_dbg(priv->adapter->dev, "cmd: Set Wpa_ie_len=%d IE=%#x\n",
+				priv->wpa_ie_len, priv->wpa_ie[0]);
+
 		if (priv->wpa_ie[0] == WLAN_EID_WPA) {
 			priv->sec_info.wpa_enabled = true;
 		} else if (priv->wpa_ie[0] == WLAN_EID_RSN) {
@@ -1873,8 +1879,8 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 	} else {
 		memset(priv->wpa_ie, 0, sizeof(priv->wpa_ie));
 		priv->wpa_ie_len = 0;
-		PRINTM(MINFO, "Reset Wpa_ie_len=%d IE=%#x\n", priv->wpa_ie_len,
-		       priv->wpa_ie[0]);
+		dev_dbg(priv->adapter->dev, "info: reset wpa_ie_len=%d IE=%#x\n",
+			priv->wpa_ie_len, priv->wpa_ie[0]);
 		priv->sec_info.wpa_enabled = false;
 		priv->sec_info.wpa2_enabled = false;
 	}
@@ -1894,21 +1900,22 @@ static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
 {
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wapi_ie)) {
-			PRINTM(MINFO, "failed to copy WAPI IE, too big\n");
+			dev_dbg(priv->adapter->dev,
+				"info: failed to copy WAPI IE, too big\n");
 			return -1;
 		}
 		memcpy(priv->wapi_ie, ie_data_ptr, ie_len);
 		priv->wapi_ie_len = ie_len;
-		PRINTM(MCMND, "Set wapi_ie_len=%d IE=%#x\n", priv->wapi_ie_len,
-		       priv->wapi_ie[0]);
-		DBG_HEXDUMP(MCMD_D, "wapi_ie", priv->wapi_ie,
-			    priv->wapi_ie_len);
+		dev_dbg(priv->adapter->dev, "cmd: Set wapi_ie_len=%d IE=%#x\n",
+				priv->wapi_ie_len, priv->wapi_ie[0]);
+
 		if (priv->wapi_ie[0] == WLAN_EID_BSS_AC_ACCESS_DELAY)
 			priv->sec_info.wapi_enabled = true;
 	} else {
 		memset(priv->wapi_ie, 0, sizeof(priv->wapi_ie));
 		priv->wapi_ie_len = ie_len;
-		PRINTM(MINFO, "Reset wapi_ie_len=%d IE=%#x\n",
+		dev_dbg(priv->adapter->dev,
+			"info: Reset wapi_ie_len=%d IE=%#x\n",
 		       priv->wapi_ie_len, priv->wapi_ie[0]);
 		priv->sec_info.wapi_enabled = false;
 	}
@@ -1980,7 +1987,8 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		/* Copy the required key as the current key */
 		wep_key = &priv->wep_key[index];
 		if (!wep_key->key_length) {
-			PRINTM(MERROR, "Key not set, so cannot enable it\n");
+			dev_err(adapter->dev,
+				"key not set, so cannot enable it\n");
 			return -1;
 		}
 		priv->wep_key_curr_index = (u16) index;
@@ -2049,7 +2057,7 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 
 	/* Current driver only supports key length of up to 32 bytes */
 	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
-		PRINTM(MERROR, " Error in key length\n");
+		dev_err(adapter->dev, "key length too long\n");
 		return -1;
 	}
 
@@ -2250,8 +2258,8 @@ int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
 					sizeof(struct mwifiex_802_11_ssid));
 					memset(passphrase->bssid, 0,
 					MWIFIEX_MAC_ADDR_LENGTH);
-					PRINTM(MINFO, "PSK_QUERY: found ssid="
-						      "%s\n",
+					dev_dbg(adapter->dev, "info: PSK_QUERY:"
+							" found ssid=%s\n",
 						      passphrase->ssid.ssid);
 				}
 			} else {
@@ -2319,12 +2327,13 @@ mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 		return -ENOMEM;
 
 	if (bdeep_sleep) {
-		PRINTM(MCMND, "Deep Sleep: sleep\n");
+		dev_dbg(priv->adapter->dev, "cmd: Deep Sleep: sleep\n");
 		auto_deep_sleep.auto_ds = DEEP_SLEEP_ON;
 		if (idle_time)
 			auto_deep_sleep.idle_time = idle_time;
 	} else {
-		PRINTM(MCMND, "%lu : Deep Sleep: wakeup\n", jiffies);
+		dev_dbg(priv->adapter->dev,
+			"cmd: %lu : Deep Sleep: wakeup\n", jiffies);
 		auto_deep_sleep.auto_ds = DEEP_SLEEP_OFF;
 	}
 	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
@@ -2385,7 +2394,7 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 
 	/* HS config is blocked if HS is already activated */
 	if (priv->adapter->is_hs_configured) {
-		PRINTM(MERROR, "HS already configured\n");
+		dev_err(priv->adapter->dev, "HS already configured\n");
 		return -EFAULT;
 	}
 
@@ -2462,10 +2471,11 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
 	if (ret)
-		PRINTM(MERROR, "Failed enabling amsdu aggregation feature\n");
+		dev_err(priv->adapter->dev,
+			"failed enabling amsdu aggr feature\n");
 	else
-		PRINTM(MINFO,
-		       "Successfully enabled amsdu aggregation feature\n");
+		dev_dbg(priv->adapter->dev,
+			"info: Successfully enabled amsdu aggregation feature\n");
 
 	kfree(wait);
 	return ret;
@@ -2643,7 +2653,7 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 
 	snprintf(version, max_len, driver_version, fw_ver);
 
-	PRINTM(MINFO, "MWIFIEX VERSION: %s\n", version);
+	dev_dbg(adapter->dev, "info: MWIFIEX VERSION: %s\n", version);
 
 	return 0;
 }
@@ -2839,7 +2849,8 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 		    cipher != WLAN_CIPHER_SUITE_WEP104 &&
 		    cipher != WLAN_CIPHER_SUITE_TKIP &&
 		    cipher != WLAN_CIPHER_SUITE_CCMP) {
-			PRINTM(MERROR, "Invalid cipher suite specified\n");
+			dev_err(priv->adapter->dev,
+				"invalid cipher suite specified\n");
 			ret = -EINVAL;
 			goto done;
 		}
@@ -3282,7 +3293,8 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 
 	/* TX rate configuration can be set only if media connected */
 	if (!priv->media_connected) {
-		PRINTM(MINFO, "Can not set txratecfg in disconnected state\n");
+		dev_dbg(priv->adapter->dev,
+			"info: Can not set txratecfg in disconnected state\n");
 		return -1;
 	}
 
@@ -3333,7 +3345,8 @@ int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
 	else
 		priv->sec_info.ewpa_enabled = false;
 
-	PRINTM(MINFO, "Set ewpa mode = %d\n", priv->sec_info.ewpa_enabled);
+	dev_dbg(priv->adapter->dev, "info: set ewpa mode = %d\n",
+				priv->sec_info.ewpa_enabled);
 
 	return 0;
 }
@@ -3360,8 +3373,9 @@ mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
 	addba_param.timeout = data[0];
 	addba_param.tx_win_size = data[1];
 	addba_param.rx_win_size = data[2];
-	PRINTM(MINFO, "SET: timeout:%d txwinsize:%d rxwinsize:%d\n", data[0],
-	       data[1], data[2]);
+	dev_dbg(priv->adapter->dev,
+			"info: SET: timeout:%d txwinsize:%d rxwinsize:%d\n",
+			data[0], data[1], data[2]);
 	status = mwifiex_11n_ioctl_addba_param(priv->adapter, wait,
 					       &addba_param,
 					       HostCmd_ACT_GEN_SET);
@@ -3406,8 +3420,9 @@ mwifiex_get_addba_param(struct mwifiex_private *priv, int *addba_timeout,
 	*tx_win_sz = addba_param.tx_win_size;
 	*rx_win_sz = addba_param.rx_win_size;
 
-	PRINTM(MINFO, "GET: timeout:%d txwinsize:%d rxwinsize:%d\n",
-	       addba_timeout, tx_win_sz, rx_win_sz);
+	dev_dbg(priv->adapter->dev,
+			"info: GET: timeout:%d txwinsize:%d rxwinsize:%d\n",
+			*addba_timeout, *tx_win_sz, *rx_win_sz);
 done:
 	kfree(wait);
 	return ret;
@@ -3527,7 +3542,8 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 						&& (!memcmp(pvendor_ie->oui,
 						wps_oui, sizeof(wps_oui)))) {
 					priv->wps.session_enable = true;
-					PRINTM(MINFO, "WPS Session Enabled.\n");
+					dev_dbg(priv->adapter->dev,
+						"info: WPS Session Enabled.\n");
 				}
 
 				/* Append the passed data to the end of the
@@ -3626,18 +3642,16 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		memset(adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 		if (gen_ie->len > ARP_FILTER_MAX_BUF_SIZE) {
 			adapter->arp_filter_size = 0;
-			PRINTM(MERROR, "Invalid ARP Filter Size\n");
+			dev_err(adapter->dev, "invalid ARP filter size\n");
 			return -1;
 		} else {
 			memcpy(adapter->arp_filter, gen_ie->ie_data,
 								gen_ie->len);
 			adapter->arp_filter_size = gen_ie->len;
-			HEXDUMP("ArpFilter", adapter->arp_filter,
-				adapter->arp_filter_size);
 		}
 		break;
 	default:
-		PRINTM(MERROR, "Invalid IE type\n");
+		dev_err(adapter->dev, "invalid IE type\n");
 		return -1;
 	}
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 3f59cf6..f57c481 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -86,10 +86,6 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 		   header that was removed. */
 		hdr_chop = (u8 *) eth_hdr - (u8 *) local_rx_pd;
 	} else {
-		HEXDUMP("RX Data: LLC/SNAP",
-			(u8 *) &rx_pkt_hdr->rfc1042_hdr,
-			sizeof(rx_pkt_hdr->rfc1042_hdr));
-
 		/* Chop off the rxpd */
 		hdr_chop = (u8 *) &rx_pkt_hdr->eth803_hdr -
 			(u8 *) local_rx_pd;
@@ -104,10 +100,8 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 	priv->rxpd_htinfo = local_rx_pd->ht_info;
 
 	ret = mwifiex_recv_packet(adapter, skb);
-	if (ret == -1) {
-		PRINTM(MERROR,
-		       "RX Error: mwifiex_recv_packet" " returns failure\n");
-	}
+	if (ret == -1)
+		dev_err(adapter->dev, "recv packet failed\n");
 
 	return ret;
 }
@@ -144,9 +138,8 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 
 	if ((local_rx_pd->rx_pkt_offset + local_rx_pd->rx_pkt_length) >
 	    (u16) skb->len) {
-		PRINTM(MERROR,
-		       "Wrong rx packet: len=%d, rx_pkt_offset=%d, "
-		       " rx_pkt_length=%d\n", skb->len,
+		dev_err(adapter->dev, "wrong rx packet: len=%d,"
+			" rx_pkt_offset=%d, rx_pkt_length=%d\n", skb->len,
 		       local_rx_pd->rx_pkt_offset, local_rx_pd->rx_pkt_length);
 		priv->stats.rx_dropped++;
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 9b18c45..e171ef3 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -51,7 +51,7 @@ mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 
 	if (!skb->len) {
-		PRINTM(MERROR, "Tx Error: bad packet length: %d\n",
+		dev_err(adapter->dev, "Tx: bad packet length: %d\n",
 		       skb->len);
 		tx_info->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
 		return skb->data;
@@ -157,14 +157,14 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		/* Fall through FAILURE handling */
 	case -1:
 		dev_kfree_skb_any(skb);
-		PRINTM(MERROR,
-		       "TX Error: mwifiex_send_null_packet failed! ret=%d\n",
-		       ret);
+		dev_err(adapter->dev, "%s: host_to_card failed: ret=%d\n",
+						__func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		break;
 	case 0:
 		dev_kfree_skb_any(skb);
-		PRINTM(MDATA, "TX: mwifiex_send_null_packet succeeded!\n");
+		dev_dbg(adapter->dev, "data: %s: host_to_card succeeded\n",
+						__func__);
 		adapter->tx_lock_flag = true;
 		break;
 	case -EINPROGRESS:
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index f6629dc..f10b90c 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -93,11 +93,11 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 				priv->adapter->tx_lock_flag = false;
 				local_tx_pd->flags = 0;
 		}
-		PRINTM(MDATA, "-EBUSY is returned\n");
+		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
 		break;
 	case -1:
 		adapter->data_sent = false;
-		PRINTM(MERROR, "Error: mwifiex_write_data_async failed: 0x%X\n",
+		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, ret);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 2c2198a..fbd3238 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -75,7 +75,7 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 	} else if (func_init_shutdown == MWIFIEX_FUNC_SHUTDOWN) {
 		cmd = HostCmd_CMD_FUNC_SHUTDOWN;
 	} else {
-		PRINTM(MERROR, "Unsupported parameter\n");
+		dev_err(adapter->dev, "unsupported parameter\n");
 		return -1;
 	}
 
@@ -219,44 +219,6 @@ int mwifiex_recv_complete(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function prints the debug messages.
- *
- * Whether a message will be printed or not is decided by this
- * function based upon the currently set driver debug level.
- */
-void
-mwifiex_print(u32 level, s8 *pformat, ...)
-{
-	va_list args;
-
-	if (level & MHEX_DUMP) {
-		u8 *buf = NULL;
-		int len = 0;
-
-		va_start(args, pformat);
-		buf = (u8 *) va_arg(args, u8 *);
-		len = (int) va_arg(args, int);
-		va_end(args);
-
-		if (level & MCMD_D)
-			DBG_HEXDUMP_PRINT(MCMD_D, (char *) pformat, buf, len);
-		if (level & MDAT_D)
-			DBG_HEXDUMP_PRINT(MDAT_D, (char *) pformat, buf, len);
-		if (level & MIF_D)
-			DBG_HEXDUMP_PRINT(MIF_D, (char *) pformat, buf, len);
-		if (level & MFW_D)
-			DBG_HEXDUMP_PRINT(MFW_D, (char *) pformat, buf, len);
-		if (level & MINFO)
-			DBG_HEXDUMP_PRINT(MINFO, (char *) pformat, buf, len);
-	} else if (drvdbg & level) {
-		va_start(args, pformat);
-		vprintk(pformat, args);
-		va_end(args);
-	}
-}
-EXPORT_SYMBOL_GPL(mwifiex_print);
-
-/*
  * IOCTL completion callback handler.
  *
  * This function is called when a pending IOCTL is completed.
@@ -274,22 +236,19 @@ int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
 
 	atomic_dec(&adapter->ioctl_pending);
 
-	PRINTM(MCMND,
-	       "IOCTL completed: status=%d, status_code=0x%lx\n",
-			status, status_code);
+	dev_dbg(adapter->dev, "cmd: IOCTL completed: status=%d,"
+			" status_code=%#x\n", status, status_code);
 
 	if (wait_queue->enabled) {
 		*wait_queue->condition = true;
 		wait_queue->status = status;
-		if (status && (status_code == MWIFIEX_ERROR_CMD_TIMEOUT)) {
-			PRINTM(MERROR, "IOCTL: command timeout\n");
-		} else {
+		if (status && (status_code == MWIFIEX_ERROR_CMD_TIMEOUT))
+			dev_err(adapter->dev, "cmd timeout\n");
+		else
 			wake_up_interruptible(wait_queue->wait);
-		}
 	} else {
 		if (status)
-			PRINTM(MERROR,
-			       "IOCTL failed: status_code=0x%lx\n",
+			dev_err(adapter->dev, "cmd failed: status_code=%#x\n",
 			       status_code);
 		kfree(wait_queue);
 	}
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index c446fb4..c224dfe 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -20,78 +20,6 @@
 #ifndef _MWIFIEX_UTIL_H_
 #define _MWIFIEX_UTIL_H_
 
-
-#define	MMSG        BIT(0)
-#define MFATAL      BIT(1)
-#define MERROR      BIT(2)
-#define MDATA       BIT(3)
-#define MCMND       BIT(4)
-#define MEVENT      BIT(5)
-#define MINTR       BIT(6)
-
-#define MDAT_D      BIT(16)
-#define MCMD_D      BIT(17)
-#define MFW_D       BIT(18)
-
-#define MWARN       BIT(29)
-#define MINFO       BIT(30)
-#define MHEX_DUMP   BIT(31)
-
-#define MAX_DATA_DUMP_LEN	48
-
-void mwifiex_print(u32 level, s8 *format, ...);
-
-extern u32 drvdbg;
-extern u32 ifdbg;
-
-#define MIF_D   BIT(0)
-#define DBG_HEXDUMP_MCMD_D(x, y, z)    do { \
-		if (drvdbg & MCMD_D) { \
-			printk(KERN_DEBUG "%s:\n", x); \
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, y, z); } \
-		} \
-	while (0)
-#define DBG_HEXDUMP_MDAT_D(x, y, z)    do { \
-		if (drvdbg & MDAT_D) { \
-			printk(KERN_DEBUG "%s:\n", x); \
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, y, z); } \
-		} \
-	while (0)
-#define DBG_HEXDUMP_MIF_D(x, y, z)    do { \
-		if (ifdbg & MIF_D) { \
-			printk(KERN_DEBUG "%s:\n", x); \
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, y, z); } \
-		} \
-	while (0)
-#define DBG_HEXDUMP_MFW_D(x, y, z)    do { \
-		if (drvdbg & MFW_D) { \
-			printk(KERN_DEBUG "%s:\n", x); \
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, y, z); } \
-		} \
-	while (0)
-#define DBG_HEXDUMP_MINFO(x, y, z)    do { \
-		if (drvdbg & MINFO) { \
-			printk(KERN_DEBUG "%s:\n", x); \
-			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, y, z); } \
-		} \
-	while (0)
-#define DBG_HEXDUMP_PRINT(level, x, y, z)    DBG_HEXDUMP_##level(x, y, z)
-
-#define PRINTM(level, pformat, args...) \
-do {                                    \
-	mwifiex_print(level, pformat, ## args); \
-} while (0)
-
-#define DBG_HEXDUMP(level, x, y, z)   \
-do {                \
-	mwifiex_print(MHEX_DUMP | level, x, y, z); \
-} while (0)
-
-#define HEXDUMP(x, y, z)   \
-do {                \
-	mwifiex_print(MHEX_DUMP | MINFO, x, y, z); \
-} while (0)
-
 static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
 {
 	return (struct mwifiex_rxinfo *)skb->cb;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index ece8f2c..2195656 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -87,7 +87,7 @@ mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
 {
 	const char *ac_str[] = { "BK", "BE", "VI", "VO" };
 
-	PRINTM(MINFO, "WMM AC_%s: ACI=%d, ACM=%d, Aifsn=%d, "
+	pr_debug("info: WMM AC_%s: ACI=%d, ACM=%d, Aifsn=%d, "
 	       "EcwMin=%d, EcwMax=%d, TxopLimit=%d\n",
 	       ac_str[wmm_aci_to_qidx_map[(ac_param->aci_aifsn_bitmap
 	       & MWIFIEX_ACI) >> 5]],
@@ -112,7 +112,8 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 	ra_list = kzalloc(sizeof(struct mwifiex_ra_list_tbl), GFP_ATOMIC);
 
 	if (!ra_list) {
-		PRINTM(MERROR, "%s: failed to alloc ra_list\n", __func__);
+		dev_err(adapter->dev, "%s: failed to alloc ra_list\n",
+						__func__);
 		return NULL;
 	}
 	INIT_LIST_HEAD(&ra_list->list);
@@ -122,7 +123,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 
 	ra_list->total_pkts_size = 0;
 
-	PRINTM(MINFO, "RAList: Allocating buffers for TID %p\n", ra_list);
+	dev_dbg(adapter->dev, "info: allocated ra_list %p\n", ra_list);
 
 	return ra_list;
 }
@@ -170,7 +171,7 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		ra_list = mwifiex_wmm_allocate_ralist_node(adapter, ra);
-		PRINTM(MINFO, "Creating RA List %p\n", ra_list);
+		dev_dbg(adapter->dev, "info: created ra_list %p\n", ra_list);
 
 		if (!ra_list)
 			break;
@@ -180,8 +181,8 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 		else
 			ra_list->is_11n_enabled = false;
 
-		PRINTM(MDATA, "ralist %p: is_11n_enabled=%d\n", ra_list,
-		       ra_list->is_11n_enabled);
+		dev_dbg(adapter->dev, "data: ralist %p: is_11n_enabled=%d\n",
+			ra_list, ra_list->is_11n_enabled);
 
 		list_add_tail(&ra_list->list,
 				&priv->wmm.tid_tbl_ptr[i].ra_list);
@@ -236,10 +237,7 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		return;
 	}
 
-	HEXDUMP("WMM: setup_queue_priorities: param IE",
-		(u8 *) wmm_ie, sizeof(struct ieee_types_wmm_parameter));
-
-	PRINTM(MINFO, "WMM Parameter IE: version=%d, "
+	dev_dbg(priv->adapter->dev, "info: WMM Parameter IE: version=%d, "
 		"qos_info Parameter Set Count=%d, Reserved=%#x\n",
 		wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
 		IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
@@ -259,17 +257,13 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		priv->wmm.queue_priority[ac_idx] = ac_idx;
 		tmp[ac_idx] = avg_back_off;
 
-		PRINTM(MINFO, "WMM: CWmax=%d CWmin=%d Avg Back-off=%d\n",
+		dev_dbg(priv->adapter->dev, "info: WMM: CWmax=%d CWmin=%d Avg Back-off=%d\n",
 		       (1 << ((wmm_ie->ac_params[num_ac].ecw_bitmap &
 		       MWIFIEX_ECW_MAX) >> 4)) - 1,
 		       cw_min, avg_back_off);
 		mwifiex_wmm_ac_debug_print(&wmm_ie->ac_params[num_ac]);
 	}
 
-	HEXDUMP("WMM: avg_back_off", (u8 *) tmp, sizeof(tmp));
-	HEXDUMP("WMM: queue_priority", priv->wmm.queue_priority,
-		sizeof(priv->wmm.queue_priority));
-
 	/* Bubble sort */
 	for (i = 0; i < num_ac; i++) {
 		for (j = 1; j < num_ac - i; j++) {
@@ -288,10 +282,6 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 	}
 
 	mwifiex_wmm_queue_priorities_tid(priv, priv->wmm.queue_priority);
-
-	HEXDUMP("WMM: avg_back_off, sort", (u8 *) tmp, sizeof(tmp));
-	HEXDUMP("WMM: queue_priority, sort", priv->wmm.queue_priority,
-		sizeof(priv->wmm.queue_priority));
 }
 
 /*
@@ -344,7 +334,7 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 {
 	int ac_val;
 
-	PRINTM(MINFO, "WMM: AC Priorities: BK(0), BE(1), VI(2), VO(3)\n");
+	dev_dbg(priv->adapter->dev, "info: WMM: AC Priorities: BK(0), BE(1), VI(2), VO(3)\n");
 
 	if (!priv->wmm_enabled) {
 		/* WMM is not enabled, default priorities */
@@ -359,7 +349,8 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 							(enum
 							 mwifiex_wmm_ac_e)
 							ac_val);
-			PRINTM(MINFO, "WMM: AC PRIO %d maps to %d\n", ac_val,
+			dev_dbg(priv->adapter->dev, "info: WMM: AC PRIO %d maps to %d\n",
+				ac_val,
 			       priv->wmm.ac_down_graded_vals[ac_val]);
 		}
 	}
@@ -542,7 +533,8 @@ mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 	int i;
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
-		PRINTM(MINFO, "RAList: Freeing buffers for TID %d\n", i);
+		dev_dbg(priv->adapter->dev,
+				"info: ra_list: freeing buf for tid %d\n", i);
 		list_for_each_entry_safe(ra_list, tmp_node,
 				&priv->wmm.tid_tbl_ptr[i].ra_list, list) {
 			list_del(&ra_list->list);
@@ -635,7 +627,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	unsigned long flags;
 
 	if (!priv->media_connected) {
-		PRINTM(MWARN, "Drop packet in disconnect\n");
+		dev_dbg(adapter->dev, "data: drop packet in disconnect\n");
 		mwifiex_write_data_complete(adapter, skb, -1);
 		return;
 	}
@@ -669,7 +661,6 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 		return;
 	}
 
-	PRINTM(MDAT_D, "Adding pkt to ra_list %p %p\n", ra_list, skb);
 	skb_queue_tail(&ra_list->skb_head, skb);
 
 	ra_list->total_pkts_size += skb->len;
@@ -700,8 +691,8 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 	struct ieee_types_wmm_parameter *wmm_param_ie = NULL;
 	struct mwifiex_wmm_ac_status *ac_status;
 
-	PRINTM(MINFO, "WMM: WMM_GET_STATUS cmdresp received: %d\n", resp_len);
-	HEXDUMP("CMD_RESP: WMM_GET_STATUS", curr, resp_len);
+	dev_dbg(priv->adapter->dev, "info: WMM: WMM_GET_STATUS cmdresp received: %d\n",
+			resp_len);
 
 	while ((resp_len >= sizeof(tlv_hdr->header)) && valid) {
 		tlv_hdr = (struct mwifiex_ie_types_data *) curr;
@@ -712,9 +703,9 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			tlv_wmm_qstatus =
 				(struct mwifiex_ie_types_wmm_queue_status *)
 				tlv_hdr;
-			PRINTM(MINFO,
-			       "CMD_RESP: WMM_GET_STATUS: QSTATUS TLV: "
-			       "%d, %d, %d\n",
+			dev_dbg(priv->adapter->dev,
+				"info: CMD_RESP: WMM_GET_STATUS:"
+				" QSTATUS TLV: %d, %d, %d\n",
 			       tlv_wmm_qstatus->queue_index,
 			       tlv_wmm_qstatus->flow_required,
 			       tlv_wmm_qstatus->disabled);
@@ -734,8 +725,6 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			 *   and setup the IEEE IE type and length byte fields
 			 */
 
-			HEXDUMP("WMM: WMM TLV:", (u8 *) tlv_hdr, tlv_len + 4);
-
 			wmm_param_ie =
 				(struct ieee_types_wmm_parameter *) (curr +
 								    2);
@@ -743,8 +732,9 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			wmm_param_ie->vend_hdr.element_id =
 						WLAN_EID_VENDOR_SPECIFIC;
 
-			PRINTM(MINFO, "CMD_RESP: WMM_GET_STATUS: WMM Parameter "
-				"Set Count: %d\n",
+			dev_dbg(priv->adapter->dev,
+				"info: CMD_RESP: WMM_GET_STATUS:"
+				" WMM Parameter Set Count: %d\n",
 				wmm_param_ie->qos_info_bitmap &
 				IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK);
 
@@ -794,7 +784,7 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 	if (!wmm_ie)
 		return 0;
 
-	PRINTM(MINFO, "WMM: process assoc req: bss->wmmIe=0x%x\n",
+	dev_dbg(priv->adapter->dev, "info: WMM: process assoc req: bss->wmmIe=0x%x\n",
 	       wmm_ie->vend_hdr.element_id);
 
 	if ((priv->wmm_required
@@ -818,7 +808,6 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 		ret_len = sizeof(wmm_tlv->header)
 			+ le16_to_cpu(wmm_tlv->header.len);
 
-		HEXDUMP("ASSOC_CMD: WMM IE", (u8 *) wmm_tlv, ret_len);
 		*assoc_buf += ret_len;
 	}
 
@@ -856,8 +845,8 @@ mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 	 */
 	ret_val = (u8) (min(queue_delay, priv->wmm.drv_pkt_delay_max) >> 1);
 
-	PRINTM(MDATA, "WMM: Pkt Delay: %d ms, %d ms sent to FW\n",
-	       queue_delay, ret_val);
+	dev_dbg(priv->adapter->dev, "data: WMM: Pkt Delay: %d ms,"
+				" %d ms sent to FW\n", queue_delay, ret_val);
 
 	return ret_val;
 }
@@ -877,7 +866,6 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 	unsigned long flags;
 	int i, j;
 
-	PRINTM(MDAT_D, "POP\n");
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
 				flags);
@@ -1021,14 +1009,14 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	if (skb_queue_empty(&ptr->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		PRINTM(MDATA, "Nothing to send\n");
+		dev_dbg(adapter->dev, "data: nothing to send\n");
 		return;
 	}
 
 	skb = skb_dequeue(&ptr->skb_head);
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
-	PRINTM(MDATA, "Dequeuing the packet %p %p\n", ptr, skb);
+	dev_dbg(adapter->dev, "data: dequeuing the packet %p %p\n", ptr, skb);
 
 	ptr->total_pkts_size -= skb->len;
 
@@ -1047,8 +1035,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 
 	if (status == -EBUSY) {
 		/* Queue the packet back at the head */
-		PRINTM(MDAT_D, "Queuing pkt back to raList %p %p\n",
-		       ptr, skb);
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
@@ -1147,7 +1133,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 					     &tx_param);
 	switch (ret) {
 	case -EBUSY:
-		PRINTM(MDATA, "-EBUSY is returned\n");
+		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
@@ -1166,8 +1152,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		break;
 	case -1:
 		adapter->data_sent = false;
-		PRINTM(MERROR,
-		       "Error: mwifiex_write_data failed: 0x%X\n", ret);
+		dev_err(adapter->dev, "host_to_card failed: %#x\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
@@ -1215,7 +1200,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 
 	tid = mwifiex_get_tid(priv->adapter, ptr);
 
-	PRINTM(MDATA, "tid=%d\n", tid);
+	dev_dbg(adapter->dev, "data: tid=%d\n", tid);
 
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 	if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-- 
1.7.0.2


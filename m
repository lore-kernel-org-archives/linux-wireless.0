Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40762 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1BVXw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 18:52:28 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove ENTER and LEAVE
Date: Tue, 22 Feb 2011 15:54:56 -0800
Message-Id: <1298418896-15763-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

ENTER/LEAVE makes code meesy and it's not necessary.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |  104 +--------
 drivers/net/wireless/mwifiex/11n.h           |   12 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   14 --
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   60 +-----
 drivers/net/wireless/mwifiex/README          |    1 -
 drivers/net/wireless/mwifiex/cfg80211.c      |   55 +----
 drivers/net/wireless/mwifiex/cfp.c           |   29 +---
 drivers/net/wireless/mwifiex/cmdevt.c        |   70 +------
 drivers/net/wireless/mwifiex/debugfs.c       |  142 +-----------
 drivers/net/wireless/mwifiex/init.c          |   41 ----
 drivers/net/wireless/mwifiex/join.c          |   47 +----
 drivers/net/wireless/mwifiex/main.c          |  107 +--------
 drivers/net/wireless/mwifiex/scan.c          |  144 +-----------
 drivers/net/wireless/mwifiex/sdio.c          |  100 +--------
 drivers/net/wireless/mwifiex/sta_cmd.c       |   65 ------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   72 +------
 drivers/net/wireless/mwifiex/sta_event.c     |   14 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  321 ++------------------------
 drivers/net/wireless/mwifiex/sta_rx.c        |    7 -
 drivers/net/wireless/mwifiex/sta_tx.c        |   10 +-
 drivers/net/wireless/mwifiex/txrx.c          |    9 -
 drivers/net/wireless/mwifiex/util.c          |   15 --
 drivers/net/wireless/mwifiex/util.h          |   11 -
 drivers/net/wireless/mwifiex/wmm.c           |  141 +-----------
 drivers/net/wireless/mwifiex/wmm.h           |    3 -
 25 files changed, 59 insertions(+), 1535 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 1ec734e..525ace6 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -35,8 +35,6 @@ int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_SET) {
 		if (((*htcap_cfg & ~IGN_HW_DEV_CAP) &
 		     adapter->hw_dot_11n_dev_cap)
@@ -51,7 +49,6 @@ int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
 		PRINTM(MINFO, "UsrDot11nCap 0x%x\n", *htcap_cfg);
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -69,15 +66,12 @@ int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
 	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 
-	ENTER();
-
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL, action, 0,
 				  wait_queue, amsdu_aggr_ctrl);
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -95,14 +89,11 @@ int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
 	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 
-	ENTER();
-
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_CFG, action, 0,
 				  wait_queue, tx_cfg);
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -123,8 +114,6 @@ int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
 	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 	u32 timeout;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		addba_param->timeout = priv->add_ba_param.timeout;
 		addba_param->tx_win_size =
@@ -143,7 +132,6 @@ int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
 
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -158,8 +146,6 @@ int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
 	int i = 0;
 	int ret = 0;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		PRINTM(MINFO, "Addba reject GET\n");
 		memcpy(addba_reject, priv->addba_reject,
@@ -169,7 +155,6 @@ int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
 			PRINTM(MERROR,
 			       "Can not set aggr priority table in connected"
 			       " state\n");
-			LEAVE();
 			return -1;
 		}
 
@@ -184,7 +169,6 @@ int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -201,8 +185,6 @@ int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 	int i = 0;
 	int ret = 0;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		for (i = 0; i < MAX_NUM_TID; i++) {
 			aggr_prio_tbl->ampdu[i] =
@@ -215,7 +197,6 @@ int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 			PRINTM(MERROR,
 			       "Can not set aggr priority table in connected"
 			       " state\n");
-			LEAVE();
 			return -1;
 		}
 
@@ -245,7 +226,6 @@ int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -285,8 +265,6 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 	uint16_t ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
 	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->ht_cap.extended_ht_cap_info);
 
-	ENTER();
-
 	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
 	    ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap))
 		SETHT_SUPPCHANWIDTH(ht_cap_info);
@@ -363,8 +341,6 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 
 	ht_cap->ht_cap.cap_info = cpu_to_le16(ht_cap_info);
 	ht_cap->ht_cap.extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
-
-	LEAVE();
 }
 
 /*
@@ -392,8 +368,6 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 void
 mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
 {
-	ENTER();
-
 	PRINTM(MINFO, "GET_HW_SPEC: Maximum MSDU length = %s octets\n",
 	       (ISSUPP_MAXAMSDU(cap) ? "7935" : "3839"));
 	PRINTM(MINFO, "GET_HW_SPEC: Beam forming %s\n",
@@ -450,8 +424,6 @@ mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
 	if (ISSUPP_TXANTENNAD(cap))
 		PRINTM(MINFO, "GET_HW_SPEC: Prescence of Tx antennea D\n");
 
-
-	LEAVE();
 	return;
 }
 
@@ -461,12 +433,8 @@ mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
 void
 mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support)
 {
-	ENTER();
-
 	PRINTM(MINFO, "GET_HW_SPEC: MCSs for %dx%d MIMO\n",
 	       GET_RXMCSSUPP(support), GET_TXMCSSUPP(support));
-
-	LEAVE();
 	return;
 }
 
@@ -488,8 +456,6 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 		(struct host_cmd_ds_11n_delba *) &resp->params.del_ba;
 	uint16_t del_ba_param_set = le16_to_cpu(del_ba->del_ba_param_set);
 
-	ENTER();
-
 	tid = del_ba_param_set >> DELBA_TID_POS;
 	if (del_ba->del_result == BA_RESULT_SUCCESS) {
 		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
@@ -523,7 +489,6 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -543,8 +508,6 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 		(struct host_cmd_ds_11n_addba_rsp *) &resp->params.add_ba_rsp;
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
 
-	ENTER();
-
 	add_ba_rsp->ssn = cpu_to_le16((le16_to_cpu(add_ba_rsp->ssn))
 			& SSN_MASK);
 
@@ -570,7 +533,6 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -586,13 +548,11 @@ int mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
 	struct mwifiex_ds_11n_tx_cfg *tx_cfg = NULL;
 	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
 
-	ENTER();
 	if (data_buf) {
 		tx_cfg = (struct mwifiex_ds_11n_tx_cfg *) data_buf;
 		tx_cfg->tx_htcap = le16_to_cpu(htcfg->ht_tx_cap);
 		tx_cfg->tx_htinfo = le16_to_cpu(htcfg->ht_tx_info);
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -612,7 +572,6 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 	u16 action = (u16) cmd_action;
 	u16 buf_size = *((u16 *) data_buf);
 
-	ENTER();
 	cmd->command = cpu_to_le16(HostCmd_CMD_RECONFIGURE_TX_BUFF);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_txbuf_cfg) + S_DS_GEN);
@@ -627,7 +586,6 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 		tx_buf->buff_size = 0;
 		break;
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -649,8 +607,6 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl =
 		(struct mwifiex_ds_11n_amsdu_aggr_ctrl *) data_buf;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_AMSDU_AGGR_CTRL);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_amsdu_aggr_ctrl)
 				+ S_DS_GEN);
@@ -665,7 +621,6 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 		amsdu_ctrl->curr_buf_size = 0;
 		break;
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -683,8 +638,6 @@ int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
 		&resp->params.amsdu_aggr_ctrl;
 
-	ENTER();
-
 	if (data_buf) {
 		amsdu_aggr_ctrl =
 			(struct mwifiex_ds_11n_amsdu_aggr_ctrl *) data_buf;
@@ -692,7 +645,6 @@ int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 		amsdu_aggr_ctrl->curr_buf_size =
 			le16_to_cpu(amsdu_ctrl->curr_buf_size);
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -744,8 +696,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_extcap *ext_cap;
 	int ret_len = 0;
 
-	ENTER();
-
 	if (!buffer || !*buffer)
 		goto exit;
 
@@ -863,7 +813,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	}
 
 exit:
-	LEAVE();
 	return ret_len;
 }
 
@@ -883,8 +832,6 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 	u16 tx_buf = 0;
 	u16 curr_tx_buf_size = 0;
 
-	ENTER();
-
 	if (bss_desc->bcn_ht_cap) {
 		if (GETHT_MAXAMSDU(le16_to_cpu(bss_desc->bcn_ht_cap->cap_info)))
 			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_8K;
@@ -908,7 +855,6 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 			HostCmd_ACT_GEN_SET, 0,
 			NULL, &tx_buf);
 
-	LEAVE();
 	return;
 }
 
@@ -922,16 +868,11 @@ mwifiex_is_tx_ba_stream_ptr_valid(struct mwifiex_private *priv,
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 
-	ENTER();
-
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
-		if (tx_ba_tsr_tbl == tx_tbl_ptr) {
-			LEAVE();
+		if (tx_ba_tsr_tbl == tx_tbl_ptr)
 			return true;
-		}
 	}
 
-	LEAVE();
 	return false;
 }
 
@@ -945,8 +886,6 @@ void
 mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 		struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl)
 {
-	ENTER();
-
 	if (!tx_ba_tsr_tbl &&
 			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
 		goto exit;
@@ -958,8 +897,7 @@ mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 	kfree(tx_ba_tsr_tbl);
 
 exit:
-
-	LEAVE();
+	return;
 }
 
 /*
@@ -972,8 +910,6 @@ mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
 	struct mwifiex_tx_ba_stream_tbl *del_tbl_ptr, *tmp_node;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
 				 &priv->tx_ba_stream_tbl_ptr, list)
@@ -986,8 +922,6 @@ mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
 		priv->aggr_prio_tbl[i].ampdu_ap =
 			priv->aggr_prio_tbl[i].ampdu_user;
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1001,20 +935,15 @@ mwifiex_11n_get_tx_ba_stream_status(struct mwifiex_private *priv,
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		if (tx_ba_tsr_tbl->ba_status == ba_status) {
 			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
 					       flags);
-			LEAVE();
 			return tx_ba_tsr_tbl;
 		}
 	}
 	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-
-	LEAVE();
 	return NULL;
 }
 
@@ -1029,8 +958,6 @@ mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		PRINTM(MDAT_D, "get_tx_ba_stream_tbl TID %d\n",
@@ -1041,13 +968,10 @@ mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 		    && (tx_ba_tsr_tbl->tid == tid)) {
 			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
 					       flags);
-			LEAVE();
 			return tx_ba_tsr_tbl;
 		}
 	}
 	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-
-	LEAVE();
 	return NULL;
 }
 
@@ -1063,8 +987,6 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	struct mwifiex_tx_ba_stream_tbl *new_node;
 	unsigned long flags;
 
-	ENTER();
-
 	if (!mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ra)) {
 		PRINTM(MDAT_D, "get_tx_ba_stream_tbl TID %d\n", tid);
 		DBG_HEXDUMP(MDAT_D, "RA", ra, MWIFIEX_MAC_ADDR_LENGTH);
@@ -1089,7 +1011,7 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	}
 
 exit:
-	LEAVE();
+	return;
 }
 
 /*
@@ -1102,8 +1024,6 @@ mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	static u8 dialog_tok;
 	int ret;
 
-	ENTER();
-
 	PRINTM(MCMND, "Send addba: TID %d\n", tid);
 	DBG_HEXDUMP(MCMD_D, "Send addba RA", peer_mac, MWIFIEX_MAC_ADDR_LENGTH);
 
@@ -1126,7 +1046,6 @@ mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_ADDBA_REQ,
 				  0, 0, NULL, &add_ba_req);
 
-	LEAVE();
 	return ret;
 }
 
@@ -1141,8 +1060,6 @@ mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	int ret;
 	uint16_t del_ba_param_set;
 
-	ENTER();
-
 	memset(&delba, 0, sizeof(delba));
 	delba.del_ba_param_set = cpu_to_le16(tid << DELBA_TID_POS);
 
@@ -1158,7 +1075,6 @@ mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA,
 				  HostCmd_ACT_GEN_SET, 0, NULL, &delba);
 
-	LEAVE();
 	return ret;
 }
 
@@ -1173,8 +1089,6 @@ mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 	uint16_t del_ba_param_set = le16_to_cpu(cmd_del_ba->del_ba_param_set);
 	int tid;
 
-	ENTER();
-
 	DBG_HEXDUMP(MCMD_D, "Delba:", (u8 *) cmd_del_ba, 20);
 
 	tid = del_ba_param_set >> DELBA_TID_POS;
@@ -1182,8 +1096,6 @@ mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 	mwifiex_11n_delete_ba_stream_tbl(priv, tid, cmd_del_ba->peer_mac_addr,
 			TYPE_DELBA_RECEIVE,
 			INITIATOR_BIT(del_ba_param_set));
-
-	LEAVE();
 }
 
 /*
@@ -1197,12 +1109,9 @@ mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	if (list_empty(&priv->tx_ba_stream_tbl_ptr)) {
 		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-		LEAVE();
 		return;
 	}
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list)
@@ -1210,7 +1119,6 @@ mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
 	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	mwifiex_main_process(priv->adapter);
-	LEAVE();
 	return;
 }
 
@@ -1227,8 +1135,6 @@ mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 	int count = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_for_each_entry(rx_reorder_tbl_ptr, &priv->rx_reorder_tbl_ptr,
 			    list) {
@@ -1251,7 +1157,6 @@ mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 	}
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
-	LEAVE();
 	return count;
 }
 
@@ -1267,8 +1172,6 @@ mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	int count = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		rx_reo_tbl->tid = (u16) tx_ba_tsr_tbl->tid;
@@ -1282,6 +1185,5 @@ mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	}
 	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
-	LEAVE();
 	return count;
 }
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 57664ad..0fe1b37 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -169,8 +169,6 @@ mwifiex_find_stream_to_delete(struct mwifiex_private *priv,
 	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
 	unsigned long flags;
 
-	ENTER();
-
 	tid = priv->aggr_prio_tbl[ptr_tid].ampdu_user;
 
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
@@ -184,7 +182,6 @@ mwifiex_find_stream_to_delete(struct mwifiex_private *priv,
 	}
 	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
-	LEAVE();
 	return ret;
 }
 
@@ -197,15 +194,10 @@ mwifiex_is_ba_stream_setup(struct mwifiex_private *priv,
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
 
-	ENTER();
-
 	tx_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ptr->ra);
-	if (tx_tbl) {
-		LEAVE();
-		return IS_BASTREAM_SETUP(tx_tbl) ? true : false;
-	}
+	if (tx_tbl && IS_BASTREAM_SETUP(tx_tbl))
+		return true;
 
-	LEAVE();
 	return false;
 }
 #endif /* !_MWIFIEX_11N_H_ */
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 890d913..2312db6 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -64,8 +64,6 @@ mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter,
 	};
 	struct tx_packet_hdr *tx_header = NULL;
 
-	ENTER();
-
 	skb_put(skb_aggr, sizeof(*tx_header));
 
 	tx_header = (struct tx_packet_hdr *) skb_aggr->data;
@@ -93,7 +91,6 @@ mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter,
 						      LLC_SNAP_LEN)) & 3)) : 0;
 	skb_put(skb_aggr, *pad);
 
-	LEAVE();
 	return skb_aggr->len + *pad;
 }
 
@@ -108,7 +105,6 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 			    struct sk_buff *skb)
 {
 	struct txpd *local_tx_pd;
-	ENTER();
 
 	skb_push(skb, sizeof(*local_tx_pd));
 
@@ -141,8 +137,6 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 				MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET;
 		}
 	}
-
-	LEAVE();
 }
 
 /*
@@ -203,8 +197,6 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		0x00, 0x00, 0x00
 	};
 
-	ENTER();
-
 	data = (u8 *) (local_rx_pd + local_rx_pd->rx_pkt_offset);
 	total_pkt_len = local_rx_pd->rx_pkt_length;
 
@@ -279,7 +271,6 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -313,8 +304,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
 
-	ENTER();
-
 	PRINTM(MDAT_D, "Handling Aggr packet\n");
 
 	if (skb_queue_empty(&pra_list->skb_head)) {
@@ -359,7 +348,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
-			LEAVE();
 			return -1;
 		}
 
@@ -396,7 +384,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
 			mwifiex_write_data_complete(adapter, skb_aggr, -1);
-			LEAVE();
 			return -1;
 		}
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
@@ -448,6 +435,5 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	}
 
 exit:
-	LEAVE();
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index d11ec84..9ac9a2c 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -58,8 +58,6 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 	void *rx_tmp_ptr = NULL;
 	unsigned long flags;
 
-	ENTER();
-
 	no_pkt_to_send = (start_win > rx_reor_tbl_ptr->start_win) ?
 		min((start_win - rx_reor_tbl_ptr->start_win),
 		    rx_reor_tbl_ptr->win_size) : rx_reor_tbl_ptr->win_size;
@@ -91,7 +89,6 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 	rx_reor_tbl_ptr->start_win = start_win;
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 
-	LEAVE();
 	return ret;
 }
 
@@ -112,8 +109,6 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 	void *rx_tmp_ptr = NULL;
 	unsigned long flags;
 
-	ENTER();
-
 	for (i = 0; i < rx_reor_tbl_ptr->win_size; ++i) {
 		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
 		if (!rx_reor_tbl_ptr->rx_reorder_ptr[i]) {
@@ -142,7 +137,6 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 	rx_reor_tbl_ptr->start_win = (rx_reor_tbl_ptr->start_win + i)
 		&(MAX_TID_VALUE - 1);
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-	LEAVE();
 	return ret;
 }
 
@@ -159,12 +153,8 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 {
 	unsigned long flags;
 
-	ENTER();
-
-	if (!rx_reor_tbl_ptr) {
-		LEAVE();
+	if (!rx_reor_tbl_ptr)
 		return;
-	}
 
 	mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
 						 (rx_reor_tbl_ptr->start_win +
@@ -181,8 +171,6 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 
 	kfree(rx_reor_tbl_ptr->rx_reorder_ptr);
 	kfree(rx_reor_tbl_ptr);
-
-	LEAVE();
 }
 
 /*
@@ -195,21 +183,17 @@ mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
 		if ((!memcmp(rx_reor_tbl_ptr->ta, ta, MWIFIEX_MAC_ADDR_LENGTH))
 		    && (rx_reor_tbl_ptr->tid == tid)) {
 			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
 					       flags);
-			LEAVE();
 			return rx_reor_tbl_ptr;
 		}
 	}
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
-	LEAVE();
 	return NULL;
 }
 
@@ -274,8 +258,6 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	u16 last_seq = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	/*
 	 * If we get a TID, ta pair which is already present dispatch all the
 	 * the packets and move the window size until the ssn
@@ -345,7 +327,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	}
 
 exit:
-	LEAVE();
+	return;
 }
 
 /*
@@ -362,7 +344,6 @@ int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
 	struct host_cmd_ds_11n_addba_req *add_ba_req =
 		(struct host_cmd_ds_11n_addba_req *)
 		&cmd->params.add_ba_req;
-	ENTER();
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_REQ);
 	cmd->size =
@@ -372,7 +353,6 @@ int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
 	memcpy(add_ba_req, data_buf,
 	       sizeof(struct host_cmd_ds_11n_addba_req));
 
-	LEAVE();
 	return 0;
 }
 
@@ -397,8 +377,6 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	int win_size = 0;
 	uint16_t block_ack_param_set;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_RSP);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_11n_addba_rsp) +
@@ -431,7 +409,6 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 
 	mwifiex_11n_create_rx_reorder_tbl(priv, cmd_addba_req->peer_mac_addr,
 			    tid, win_size, le16_to_cpu(cmd_addba_req->ssn));
-	LEAVE();
 	return 0;
 }
 
@@ -449,15 +426,12 @@ int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
 	struct host_cmd_ds_11n_delba *del_ba = (struct host_cmd_ds_11n_delba *)
 		&cmd->params.del_ba;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_DELBA);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_11n_delba) + S_DS_GEN);
 
 	memcpy(del_ba, data_buf, sizeof(struct host_cmd_ds_11n_delba));
 
-	LEAVE();
 	return 0;
 }
 
@@ -483,13 +457,10 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	int ret = 0;
 	u16 pkt_index = 0;
 
-	ENTER();
-
 	rx_reor_tbl_ptr =
 		mwifiex_11n_get_rx_reorder_tbl((struct mwifiex_private *) priv,
 						tid, ta);
 	if (!rx_reor_tbl_ptr) {
-		LEAVE();
 		if (pkt_type == PKT_TYPE_BAR)
 			return ret;
 		else {
@@ -519,13 +490,10 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {/* Wrap */
 			if (seq_num >= ((start_win + (TWOPOW11)) &
 					(MAX_TID_VALUE - 1))
-			    && (seq_num < start_win)) {
-				LEAVE();
+			    && (seq_num < start_win))
 				return -1;
-			}
 		} else if ((seq_num < start_win) ||
 			   (seq_num > (start_win + (TWOPOW11)))) {
-			LEAVE();
 			return -1;
 		}
 
@@ -559,10 +527,8 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 					rx_reor_tbl_ptr,
 					start_win);
 
-			if (ret) {
-				LEAVE();
+			if (ret)
 				return ret;
-			}
 		}
 
 		PRINTM(MDAT_D, "3:seq_num %d start_win %d win_size %d"
@@ -575,7 +541,6 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 
 			if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index]) {
 				PRINTM(MDAT_D, "Drop Duplicate Pkt\n");
-				LEAVE();
 				return -1;
 			}
 			rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
@@ -588,7 +553,6 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		ret = mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -606,8 +570,6 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 	u8 cleanup_rx_reorder_tbl;
 	unsigned long flags;
 
-	ENTER();
-
 	if (type == TYPE_DELBA_RECEIVE)
 		cleanup_rx_reorder_tbl = (initiator) ? true : false;
 	else
@@ -624,7 +586,6 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 							peer_mac);
 		if (!rx_reor_tbl_ptr) {
 			PRINTM(MWARN, "TID, TA not found in table!\n");
-			LEAVE();
 			return;
 		}
 		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, rx_reor_tbl_ptr);
@@ -632,7 +593,6 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 		ptx_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, peer_mac);
 		if (!ptx_tbl) {
 			PRINTM(MWARN, "TID, RA not found in table!\n");
-			LEAVE();
 			return;
 		}
 
@@ -640,8 +600,6 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 		mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, ptx_tbl);
 		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
-
-	LEAVE();
 }
 
 /*
@@ -660,8 +618,6 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr = NULL;
 	uint16_t block_ack_param_set;
 
-	ENTER();
-
 	block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
 
 	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
@@ -703,7 +659,6 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 				rx_reor_tbl_ptr);
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -717,8 +672,6 @@ mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_11n_delba delba;
 
-	ENTER();
-
 	DBG_HEXDUMP(MCMD_D, "Event:", (u8 *) event, 20);
 
 	memset(&delba, 0, sizeof(struct host_cmd_ds_11n_delba));
@@ -732,7 +685,6 @@ mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 	delba.reason_code = cpu_to_le16(WLAN_REASON_QSTA_TIMEOUT);
 	mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA, 0, 0, NULL, &delba);
 
-	LEAVE();
 	return;
 }
 
@@ -746,8 +698,6 @@ mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 	struct mwifiex_rx_reorder_tbl *del_tbl_ptr, *tmp_node;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
 				 &priv->rx_reorder_tbl_ptr, list) {
@@ -759,6 +709,4 @@ mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 
 	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 	memset(priv->rx_seq, 0, sizeof(priv->rx_seq));
-
-	LEAVE();
 }
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 1c01854..5f1ae33 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -183,7 +183,6 @@ drvdbg
 		bit 17: MCMD_D		PRINTM(MCMD_D,...), DBG_HEXDUMP(MCMD_D,...)
 		bit 18: MFW_D		PRINTM(MFW_D,...)
 		...
-		bit 28: MENTRY		PRINTM(MENTRY,...), ENTER(), LEAVE()
 		bit 29: MWARN 		PRINTM(MWARN,...)
 		bit 30: MINFO 		PRINTM(MINFO,...)
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9ae328b..d785e5e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -88,7 +88,7 @@ static int
 mwifiex_is_alg_wep(u32 cipher)
 {
 	int alg = 0;
-	ENTER();
+
 	switch (cipher) {
 	case MWIFIEX_ENCRYPTION_MODE_WEP40:
 	case MWIFIEX_ENCRYPTION_MODE_WEP104:
@@ -98,7 +98,6 @@ mwifiex_is_alg_wep(u32 cipher)
 		alg = 0;
 		break;
 	}
-	LEAVE();
 	return alg;
 }
 
@@ -174,7 +173,6 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
-	ENTER();
 
 	ret = mwifiex_set_encode(priv, 0, NULL, 0, key_index, 1);
 	if (ret) {
@@ -182,8 +180,6 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 		return -EFAULT;
 	}
 
-	LEAVE();
-
 	PRINTM(MINFO, "Crypto keys deleted\n");
 	return 0;
 }
@@ -200,11 +196,8 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 
-	ENTER();
-
 	ret = mwifiex_set_tx_power(priv, type, dbm);
 
-	LEAVE();
 	return ret;
 }
 
@@ -221,16 +214,14 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	int ret = 0;
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
-	ENTER();
+
 	if (timeout)
 		PRINTM(MINFO,
 		       "Ignoring the timeout value for ieee power save\n");
 
 	ret = mwifiex_drv_set_power(priv, enabled);
 
-	LEAVE();
 	return ret;
-
 }
 
 /*
@@ -255,7 +246,6 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
-	ENTER();
 
 	ret = mwifiex_set_encode(priv, params->cipher, params->key,
 				 params->key_len, key_index, 0);
@@ -265,8 +255,6 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 	if (ret)
 		return -EFAULT;
 
-	LEAVE();
-
 	return 0;
 }
 
@@ -412,8 +400,6 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	u32 config_bands = 0;
 	struct wiphy *wiphy = priv->wdev->wiphy;
 
-	ENTER();
-
 	mode = mwifiex_drv_get_mode(priv, wait_option);
 
 	if (chan) {
@@ -464,7 +450,6 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -481,7 +466,6 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
-	ENTER();
 
 	if (mwifiex_get_assoc_status(priv)) {
 		PRINTM(MERROR, "This configuration is valid only when station "
@@ -489,7 +473,6 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	LEAVE();
 	return mwifiex_set_rf_channel(priv, chan, channel_type);
 }
 
@@ -510,8 +493,6 @@ mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
-
 	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE
 	    || frag_thr > MWIFIEX_FRAG_MAX_VALUE) {
 		ret = -EINVAL;
@@ -551,8 +532,6 @@ mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 	int status = 0;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
-
 	if (rts_thr < MWIFIEX_RTS_MIN_VALUE || rts_thr > MWIFIEX_RTS_MAX_VALUE)
 		rts_thr = MWIFIEX_RTS_MAX_VALUE;
 
@@ -570,8 +549,6 @@ mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 		goto done;
 	}
 done:
-	LEAVE();
-
 	kfree(wait);
 	return ret;
 }
@@ -622,8 +599,6 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -660,7 +635,6 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -845,7 +819,6 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
-	ENTER();
 
 	if (priv->disconnect)
 		return -EBUSY;
@@ -859,7 +832,6 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
 
-	LEAVE();
 	return 0;
 }
 
@@ -875,15 +847,11 @@ mwifiex_set_wep_keys(struct mwifiex_private *priv, const u8 *key, int key_len,
 
 	u32 cipher = 0;
 
-	ENTER();
-
 	if (key_len == 5)
 		cipher = WLAN_CIPHER_SUITE_WEP40;
 	else
 		cipher = WLAN_CIPHER_SUITE_WEP104;
 
-	LEAVE();
-
 	return mwifiex_set_encode(priv, cipher, key, key_len, index, 0);
 }
 
@@ -906,13 +874,9 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	int ie_len = 0;
 	u8 ie_buf[IW_ESSID_MAX_SIZE + sizeof(struct ieee_types_header)];
 
-	ENTER();
-
 	ret = mwifiex_get_bss_info(priv, &bss_info);
-	if (ret) {
-		LEAVE();
+	if (ret)
 		return ret;
-	}
 
 	ie_buf[0] = WLAN_EID_SSID;
 	ie_buf[1] = bss_info.ssid.ssid_len;
@@ -931,7 +895,6 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 		0, ie_buf, ie_len, 0, GFP_KERNEL);
 	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
 
-	LEAVE();
 	return ret;
 }
 
@@ -1104,8 +1067,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	int group_encrypt_mode = 0;
 	int alg_is_wep = 0;
 
-	ENTER();
-
 	memset(&req_ssid, 0, sizeof(struct mwifiex_802_11_ssid));
 	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
 
@@ -1247,7 +1208,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -1310,8 +1270,6 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	if (priv->ibss_join_request)
 		return -EBUSY;
 
-	ENTER();
-
 	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
 	if (mode != MWIFIEX_BSS_MODE_IBSS) {
 		PRINTM(MERROR, "Request to join ibss received "
@@ -1330,8 +1288,6 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 done:
 	priv->ibss_join_result = ret;
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1347,7 +1303,6 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 
-	ENTER();
 	if (priv->disconnect)
 		return -EBUSY;
 
@@ -1359,7 +1314,6 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
 
-	LEAVE();
 	return 0;
 }
 
@@ -1408,7 +1362,6 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	struct ieee80211_mcs_info mcs_set;
 	u8 *mcs = (u8 *)&mcs_set;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	ENTER();
 
 	ht_info->ht_supported = true;
 	ht_info->ampdu_factor = 0x3;
@@ -1432,8 +1385,6 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	memcpy((u8 *) &ht_info->mcs, mcs, sizeof(struct ieee80211_mcs_info));
 
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-
-	LEAVE();
 }
 
 /** station cfg80211 operations */
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 226a6b3..2bd8071 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -91,7 +91,6 @@ mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
 	};			/* SG 20M */
 
 	u32 rate;
-	ENTER();
 
 	if (ht_info & BIT(0)) {
 		if (index == MWIFIEX_RATE_BITMAP_MCS0) {
@@ -122,7 +121,6 @@ mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
 			index = 0;
 		rate = mwifiex_data_rates[index];
 	}
-	LEAVE();
 	return rate;
 }
 
@@ -135,17 +133,12 @@ mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate)
 {
 	u16 *ptr;
 
-	ENTER();
-
 	if (rate) {
 		ptr = memchr(mwifiex_data_rates, rate,
 				sizeof(mwifiex_data_rates));
-		if (ptr) {
-			LEAVE();
+		if (ptr)
 			return (u8) (ptr - mwifiex_data_rates);
-		}
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -159,8 +152,6 @@ mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
 {
 	u32 k;
 
-	ENTER();
-
 	if (!priv->media_connected) {
 		k = mwifiex_get_supported_rates(priv, rates);
 	} else {
@@ -169,7 +160,6 @@ mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
 				       priv->curr_bss_params.num_of_rates);
 	}
 
-	LEAVE();
 	return k;
 }
 
@@ -187,7 +177,6 @@ mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	int i;
-	ENTER();
 
 	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
 		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -218,7 +207,6 @@ mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
 				"from_cfg80211(): cannot find cfp "
 				"by band %d & channel %d\n", band, channel);
 
-	LEAVE();
 	return cfp;
 }
 
@@ -234,7 +222,6 @@ mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	int i;
-	ENTER();
 
 	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
 		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -264,7 +251,6 @@ mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
 				"cfg80211: cannot find cfp by "
 				"band %d & freq %d\n", band, freq);
 
-	LEAVE();
 	return cfp;
 }
 
@@ -277,13 +263,10 @@ mwifiex_is_rate_auto(struct mwifiex_private *priv)
 	u32 i;
 	int rate_num = 0;
 
-	ENTER();
-
 	for (i = 0; i < ARRAY_SIZE(priv->bitmap_rates); i++)
 		if (priv->bitmap_rates[i])
 			rate_num++;
 
-	LEAVE();
 	if (rate_num > 1)
 		return true;
 	else
@@ -299,16 +282,11 @@ mwifiex_get_rate_index(struct mwifiex_adapter *adapter, u16 *rate_bitmap,
 {
 	int i;
 
-	ENTER();
-
 	for (i = 0; i < size * 8; i++) {
-		if (rate_bitmap[i / 16] & (1 << (i % 16))) {
-			LEAVE();
+		if (rate_bitmap[i / 16] & (1 << (i % 16)))
 			return i;
-		}
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -324,8 +302,6 @@ mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 	u32 k = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
-
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
 		/* Infra. mode */
 		switch (adapter->config_bands) {
@@ -402,6 +378,5 @@ mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		}
 	}
 
-	LEAVE();
 	return k;
 }
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c218197..5f7274c 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -86,8 +86,6 @@ static void
 mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 		       struct cmd_ctrl_node *cmd_node)
 {
-	ENTER();
-
 	cmd_node->cmd_oid = 0;
 	cmd_node->cmd_flag = 0;
 	cmd_node->wq_buf = NULL;
@@ -98,7 +96,6 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 		cmd_node->resp_skb = NULL;
 	}
 
-	LEAVE();
 	return;
 }
 
@@ -113,20 +110,16 @@ mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
 	unsigned long flags;
 	struct cmd_ctrl_node *cmd_node;
 
-	ENTER();
-
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
 	list_for_each_entry(cmd_node, &adapter->cmd_pending_q, list) {
 		if (cmd_node->wq_buf == wait_queue) {
 			spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 					       flags);
-			LEAVE();
 			return cmd_node;
 		}
 	}
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
-	LEAVE();
 	return NULL;
 }
 
@@ -143,12 +136,9 @@ static int mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
 	struct mwifiex_ds_misc_cmd *pcmd_ptr =
 		(struct mwifiex_ds_misc_cmd *) data_buf;
 
-	ENTER();
-
 	/* Copy the HOST command to command buffer */
 	memcpy((void *) cmd, pcmd_ptr->cmd, pcmd_ptr->len);
 	PRINTM(MCMND, "Host command size = %d\n", pcmd_ptr->len);
-	LEAVE();
 	return 0;
 }
 
@@ -173,8 +163,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	struct timeval tstamp;
 	unsigned long flags;
 
-	ENTER();
-
 	if (!adapter || !cmd_node) {
 		ret = -1;
 		goto done;
@@ -258,7 +246,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	ret = 0;
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -352,8 +339,6 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	u32 buf_size;
 	u32 i;
 
-	ENTER();
-
 	/* Allocate and initialize struct cmd_ctrl_node */
 	buf_size = sizeof(struct cmd_ctrl_node) * MWIFIEX_NUM_OF_CMD_BUFFER;
 	cmd_array = kzalloc(buf_size, GFP_KERNEL);
@@ -382,7 +367,6 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 		mwifiex_insert_cmd_to_free_q(adapter, &cmd_array[i]);
 	ret = 0;
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -397,8 +381,6 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	struct cmd_ctrl_node *cmd_array;
 	u32 i;
 
-	ENTER();
-
 	/* Need to check if cmd pool is allocated or not */
 	if (adapter->cmd_pool == NULL) {
 		PRINTM(MINFO, "FREE_CMD_BUF: cmd_pool is Null\n");
@@ -426,7 +408,6 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	}
 
 done:
-	LEAVE();
 	return 0;
 }
 
@@ -450,8 +431,6 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 	struct timeval tstamp;
 	struct mwifiex_rxinfo *rx_info = NULL;
 
-	ENTER();
-
 	/* Save the last event to debug log */
 	adapter->dbg.last_event_index =
 		(adapter->dbg.last_event_index + 1) % DBG_CMD_NUM;
@@ -485,7 +464,6 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 
 	mwifiex_recv_complete(adapter, skb, 0);
 
-	LEAVE();
 	return ret;
 }
 
@@ -510,8 +488,6 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct host_cmd_ds_command *cmd_ptr = NULL;
 
-	ENTER();
-
 	/* Sanity test */
 	if (adapter->is_suspended) {
 		PRINTM(MERROR, "PREP_CMD: Device in suspended state\n");
@@ -588,7 +564,6 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	else
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -605,8 +580,6 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	struct mwifiex_wait_queue *wait_queue = NULL;
 	unsigned long flags;
 
-	ENTER();
-
 	if (cmd_node == NULL)
 		goto done;
 	if (cmd_node->wq_buf) {
@@ -625,7 +598,7 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
 
 done:
-	LEAVE();
+	return;
 }
 
 /*
@@ -643,8 +616,6 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 	u16 command;
 	unsigned long flags;
 
-	ENTER();
-
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	if (host_cmd == NULL) {
 		PRINTM(MERROR, "QUEUE_CMD: host_cmd is NULL\n");
@@ -674,7 +645,6 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 	PRINTM(MCMND, "QUEUE_CMD: cmd=0x%x is queued\n", command);
 
 done:
-	LEAVE();
 	return;
 }
 
@@ -698,8 +668,6 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	unsigned long cmd_flags;
 	unsigned long cmd_pending_q_flags;
 
-	ENTER();
-
 	/* Check if already in processing */
 	if (adapter->curr_cmd) {
 		PRINTM(MERROR,
@@ -757,7 +725,6 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -780,8 +747,6 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	struct timeval tstamp;
 	unsigned long flags;
 
-	ENTER();
-
 	/* Now we got response from FW, cancel the command timer */
 	del_timer(&adapter->cmd_timer);
 
@@ -905,7 +870,6 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -924,8 +888,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	struct timeval tstamp;
 	u8 i;
 
-	ENTER();
-
 	adapter->num_cmd_timeout++;
 	adapter->dbg.num_cmd_timeout++;
 	if (!adapter->curr_cmd) {
@@ -999,7 +961,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
 exit:
-	LEAVE();
 	return;
 }
 
@@ -1084,8 +1045,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 	unsigned long scan_pending_q_flags;
 	uint16_t cancel_scan_cmd = false;
 
-	ENTER();
-
 	if ((adapter->curr_cmd) &&
 	    (adapter->curr_cmd->wq_buf == wait_queue)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
@@ -1140,7 +1099,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 	wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
 	mwifiex_ioctl_complete(adapter, wait_queue, -1);
 
-	LEAVE();
 	return;
 }
 
@@ -1156,8 +1114,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 void
 mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 {
-	ENTER();
-
 	if (!adapter->cmd_sent &&
 	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter)) {
 		mwifiex_dnld_sleep_confirm_cmd(adapter);
@@ -1167,8 +1123,6 @@ mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 		       (adapter->curr_cmd) ? "C" : "",
 		       (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1179,8 +1133,6 @@ mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 void
 mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 {
-	ENTER();
-
 	if (activated) {
 		if (priv->adapter->is_hs_configured) {
 			priv->adapter->hs_activated = true;
@@ -1194,8 +1146,6 @@ mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 		PRINTM(MEVENT, "hs_deactived\n");
 		priv->adapter->hs_activated = false;
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1206,15 +1156,11 @@ mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 void
 mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv)
 {
-	ENTER();
-
 	if (priv->adapter->is_hs_configured)
 		/* simulate HSCFG_CANCEL command */
 		mwifiex_cancel_hs(priv, MWIFIEX_NO_WAIT);
 	else
 		PRINTM(MWARN, "hs_wakeup: Host Sleep not configured !!!\n");
-
-	LEAVE();
 }
 
 /*
@@ -1235,8 +1181,6 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 		&resp->params.opt_hs_cfg;
 	uint32_t conditions = le32_to_cpu(phs_cfg->params.hs_config.conditions);
 
-	ENTER();
-
 	if (phs_cfg->action == cpu_to_le16(HS_ACTIVATE)) {
 		mwifiex_hs_activated_event(priv, true);
 		goto done;
@@ -1256,7 +1200,6 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 			mwifiex_hs_activated_event(priv, false);
 	}
 done:
-	LEAVE();
 	return 0;
 }
 
@@ -1294,11 +1237,8 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	uint16_t command = le16_to_cpu(cmd->command);
 	uint16_t seq_num = le16_to_cpu(cmd->seq_num);
 
-	ENTER();
-
 	if (!upld_len) {
 		PRINTM(MERROR, "Command size is 0\n");
-		LEAVE();
 		return;
 	}
 
@@ -1326,7 +1266,6 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 		PRINTM(MERROR, "Sleep confirm command failed\n");
 		adapter->pm_wakeup_card_req = false;
 		adapter->ps_state = PS_STATE_AWAKE;
-		LEAVE();
 		return;
 	}
 	adapter->pm_wakeup_card_req = true;
@@ -1339,7 +1278,6 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	adapter->ps_state = PS_STATE_SLEEP;
 	cmd->command = cpu_to_le16(command);
 	cmd->seq_num = cpu_to_le16(seq_num);
-	LEAVE();
 }
 EXPORT_SYMBOL_GPL(mwifiex_process_sleep_confirm_resp);
 
@@ -1519,15 +1457,12 @@ int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_get_hw_spec *hw_spec = &cmd->params.hw_spec;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_GET_HW_SPEC);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_get_hw_spec) + S_DS_GEN);
 	memcpy(hw_spec->permanent_addr, priv->curr_addr,
 	       MWIFIEX_MAC_ADDR_LENGTH);
 
-	LEAVE();
 	return 0;
 }
 
@@ -1559,8 +1494,6 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	int ret = 0;
 	int i;
 
-	ENTER();
-
 	adapter->fw_cap_info = le32_to_cpu(hw_spec->fw_cap_info);
 
 	if (IS_SUPPORT_MULTI_BANDS(adapter))
@@ -1637,6 +1570,5 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		adapter->if_ops.update_mp_end_port(adapter,
 					le16_to_cpu(hw_spec->mp_end_port));
 
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 2cf287d..9bcf18e 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -196,8 +196,6 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	ssize_t ret = 0;
 	int i = 0;
 
-	ENTER();
-
 	if (!p) {
 		ret = -ENOMEM;
 		goto exit;
@@ -263,7 +261,6 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 free_and_exit:
 	free_page(page);
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -297,8 +294,6 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 	ssize_t ret = 0;
 	struct mwifiex_ds_get_stats stats;
 
-	ENTER();
-
 	if (!p) {
 		ret = -ENOMEM;
 		goto exit;
@@ -350,7 +345,6 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 free_and_exit:
 	free_page(page);
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -417,8 +411,6 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 	long val;
 	int i, j;
 
-	ENTER();
-
 	if (!p) {
 		ret = -ENOMEM;
 		goto exit;
@@ -507,7 +499,6 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 free_and_exit:
 	free_page(page);
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -532,8 +523,6 @@ mwifiex_txaggrprio_write(struct file *file,
 	int *data = NULL;
 	char *p = NULL;
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -569,7 +558,6 @@ mwifiex_txaggrprio_write(struct file *file,
 done:
 	kfree(data);
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -590,7 +578,6 @@ mwifiex_txaggrprio_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0, i;
 	int *data = kzalloc(sizeof(int) * MAX_NUM_TID * 2, GFP_KERNEL);
-	ENTER();
 
 	if (!data) {
 		ret = -ENOMEM;
@@ -611,7 +598,6 @@ mwifiex_txaggrprio_read(struct file *file, char __user *ubuf,
 done:
 	free_page(addr);
 	kfree(data);
-	LEAVE();
 	return ret;
 }
 
@@ -634,7 +620,6 @@ mwifiex_amsduaggrctrl_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int amsdu_enable = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -660,7 +645,6 @@ mwifiex_amsduaggrctrl_write(struct file *file,
 		ret = -EINVAL;
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -681,7 +665,6 @@ mwifiex_amsduaggrctrl_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int amsdu_enable, curr_buf_size;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -696,7 +679,6 @@ mwifiex_amsduaggrctrl_read(struct file *file, char __user *ubuf,
 
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -718,7 +700,6 @@ mwifiex_hscfg_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int cond = 0, gap = 0, action = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -762,7 +743,6 @@ mwifiex_hscfg_write(struct file *file,
 	}
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -783,7 +763,6 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
-	ENTER();
 
 	mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_GET,
 				  MWIFIEX_IOCTL_WAIT, &hscfg);
@@ -794,7 +773,6 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 
 	free_page(addr);
 
-	LEAVE();
 	return ret;
 }
 
@@ -816,7 +794,6 @@ mwifiex_deepsleep_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int ds = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -844,7 +821,6 @@ mwifiex_deepsleep_write(struct file *file,
 		ret = -EINVAL;
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -865,7 +841,6 @@ mwifiex_deepsleep_read(struct file *file, char __user *ubuf,
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -878,8 +853,6 @@ mwifiex_deepsleep_read(struct file *file, char __user *ubuf,
 
 	free_page(addr);
 
-	LEAVE();
-
 	return ret;
 }
 
@@ -901,7 +874,6 @@ mwifiex_sleeppd_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int sleeppd = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -921,7 +893,6 @@ mwifiex_sleeppd_write(struct file *file,
 		ret = -EINVAL;
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -942,7 +913,6 @@ mwifiex_sleeppd_read(struct file *file, char __user *ubuf,
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -955,8 +925,6 @@ mwifiex_sleeppd_read(struct file *file, char __user *ubuf,
 
 	free_page(addr);
 
-	LEAVE();
-
 	return ret;
 }
 
@@ -980,8 +948,6 @@ mwifiex_mpactrl_write(struct file *file,
 	int *data = NULL;
 	char *p = NULL;
 
-	ENTER();
-
 	if (!priv->adapter->if_ops.sdio_mpa_ctrl) {
 		ret = -EFAULT;
 		goto done;
@@ -1018,7 +984,6 @@ mwifiex_mpactrl_write(struct file *file,
 done:
 	kfree(data);
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -1040,8 +1005,6 @@ mwifiex_mpactrl_read(struct file *file, char __user *ubuf,
 	int pos = 0, ret = 0, i = 0;
 	int *data = kzalloc(sizeof(int) * 6, GFP_KERNEL);
 
-	ENTER();
-
 	if (!priv->adapter->if_ops.sdio_mpa_ctrl) {
 		ret = -EFAULT;
 		goto done;
@@ -1065,8 +1028,6 @@ mwifiex_mpactrl_read(struct file *file, char __user *ubuf,
 done:
 	free_page(addr);
 	kfree(data);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1088,7 +1049,6 @@ mwifiex_qoscfg_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int qoscfg = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1107,8 +1067,6 @@ mwifiex_qoscfg_write(struct file *file,
 
 done:
 	free_page(addr);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1129,7 +1087,6 @@ mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int qoscfg = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1142,8 +1099,6 @@ mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
 
 	free_page(addr);
 
-	LEAVE();
-
 	return ret;
 }
 
@@ -1165,7 +1120,6 @@ mwifiex_atimwindow_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int atim = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1183,8 +1137,6 @@ mwifiex_atimwindow_write(struct file *file,
 
 done:
 	free_page(addr);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1205,7 +1157,6 @@ mwifiex_atimwindow_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int atim = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1218,8 +1169,6 @@ mwifiex_atimwindow_read(struct file *file, char __user *ubuf,
 
 	free_page(addr);
 
-	LEAVE();
-
 	return ret;
 }
 
@@ -1242,7 +1191,6 @@ mwifiex_txratecfg_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int txrateindex = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1261,8 +1209,6 @@ mwifiex_txratecfg_write(struct file *file,
 
 done:
 	free_page(addr);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1283,7 +1229,6 @@ mwifiex_txratecfg_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int txrateindex = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1295,9 +1240,6 @@ mwifiex_txratecfg_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -1321,7 +1263,6 @@ mwifiex_addbapara_write(struct file *file,
 	int ret = 0, length = 0;
 	int *data = NULL;
 	char *p = NULL;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1358,8 +1299,6 @@ mwifiex_addbapara_write(struct file *file,
 done:
 	kfree(data);
 	free_page(addr);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1380,7 +1319,6 @@ mwifiex_addbapara_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int addba_timeout = 0, tx_win_sz = 0, rx_win_sz = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1395,9 +1333,6 @@ mwifiex_addbapara_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -1419,7 +1354,6 @@ mwifiex_httxcfg_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int httxcfg = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1438,8 +1372,6 @@ mwifiex_httxcfg_write(struct file *file,
 
 done:
 	free_page(addr);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1460,7 +1392,6 @@ mwifiex_httxcfg_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int httxcfg = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1472,9 +1403,6 @@ mwifiex_httxcfg_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -1496,7 +1424,6 @@ mwifiex_htcapinfo_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int htcap = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1515,8 +1442,6 @@ mwifiex_htcapinfo_write(struct file *file,
 
 done:
 	free_page(addr);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1537,7 +1462,6 @@ mwifiex_htcapinfo_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int htcap = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1549,9 +1473,6 @@ mwifiex_htcapinfo_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -1575,7 +1496,6 @@ mwifiex_addbareject_write(struct file *file,
 	int ret = 0, length = 0;
 	int *data = NULL;
 	char *p = NULL;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1612,8 +1532,6 @@ mwifiex_addbareject_write(struct file *file,
 done:
 	kfree(data);
 	free_page(addr);
-
-	LEAVE();
 	return ret;
 }
 
@@ -1634,7 +1552,6 @@ mwifiex_addbareject_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int ret = 0, i = 0, pos = 0;
 	int *data = kzalloc((sizeof(int) * 8), GFP_KERNEL);
-	ENTER();
 
 	if (!buf) {
 		ret = -ENOMEM;
@@ -1653,9 +1570,6 @@ mwifiex_addbareject_read(struct file *file, char __user *ubuf,
 done:
 	kfree(data);
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -1677,7 +1591,6 @@ mwifiex_antcfg_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int antcfg = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1697,7 +1610,6 @@ mwifiex_antcfg_write(struct file *file,
 		ret = -EINVAL;
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -1719,8 +1631,6 @@ mwifiex_antcfg_read(struct file *file, char __user *ubuf,
 	int pos = 0, ret = 0;
 	int antcfg;
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -1731,9 +1641,6 @@ mwifiex_antcfg_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -1756,8 +1663,6 @@ mwifiex_regrdwr_write(struct file *file,
 	int ret = 0;
 	u32 reg_type = 0, reg_offset = 0, reg_value = UINT_MAX;
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -1780,7 +1685,6 @@ mwifiex_regrdwr_write(struct file *file,
 	}
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -1802,8 +1706,6 @@ mwifiex_regrdwr_read(struct file *file, char __user *ubuf,
 	int pos = 0, ret = 0;
 	u32 reg_value;
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -1840,7 +1742,6 @@ mwifiex_regrdwr_read(struct file *file, char __user *ubuf,
 
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -1863,8 +1764,6 @@ mwifiex_rdeeprom_write(struct file *file,
 	int ret = 0;
 	int offset = -1, bytes = -1;
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -1886,7 +1785,6 @@ mwifiex_rdeeprom_write(struct file *file,
 	}
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -1908,8 +1806,6 @@ mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
 	int pos = 0, ret = 0, i = 0;
 	u8 value[MAX_EEPROM_DATA];
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -1936,7 +1832,6 @@ mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
 
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -1956,7 +1851,6 @@ mwifiex_drvdbg_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int drv_dbg = -2, if_dbg = -2; /*-1 is a valid value for these fields */
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -1974,7 +1868,6 @@ mwifiex_drvdbg_write(struct file *file,
 	ret = count;
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -1992,7 +1885,6 @@ mwifiex_drvdbg_read(struct file *file, char __user *ubuf,
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -2002,9 +1894,6 @@ mwifiex_drvdbg_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -2027,7 +1916,6 @@ mwifiex_txbufcfg_write(struct file *file,
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
 	int txbufcfg = 0;
 	int ret = 0;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -2047,7 +1935,6 @@ mwifiex_txbufcfg_write(struct file *file,
 		ret = -EINVAL;
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -2068,7 +1955,6 @@ mwifiex_txbufcfg_read(struct file *file, char __user *ubuf,
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	int txbufcfg;
-	ENTER();
 
 	if (!buf)
 		return -ENOMEM;
@@ -2080,9 +1966,6 @@ mwifiex_txbufcfg_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 	free_page(addr);
-
-	LEAVE();
-
 	return ret;
 }
 
@@ -2108,8 +1991,6 @@ mwifiex_passphrase_write(struct file *file,
 	char *begin, *end, *opt;
 	struct mwifiex_ds_passphrase ds_passphrase;
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -2203,7 +2084,6 @@ mwifiex_passphrase_write(struct file *file,
 
 done:
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -2224,8 +2104,6 @@ mwifiex_passphrase_read(struct file *file, char __user *ubuf,
 	char zero_mac[] = {0, 0, 0, 0, 0, 0 };
 	char *mac = NULL;
 
-	ENTER();
-
 	if (!buf)
 		return -ENOMEM;
 
@@ -2258,7 +2136,6 @@ mwifiex_passphrase_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, len);
 
 	free_page(addr);
-	LEAVE();
 	return ret;
 }
 
@@ -2282,8 +2159,6 @@ mwifiex_esuppmode_read(struct file *file, char __user *ubuf,
 	ssize_t ret = 0;
 	struct mwifiex_ds_esupp_mode esupp_mode;
 
-	ENTER();
-
 	if (!p) {
 		ret = -ENOMEM;
 		goto exit;
@@ -2308,7 +2183,6 @@ mwifiex_esuppmode_read(struct file *file, char __user *ubuf,
 free_and_exit:
 	free_page(page);
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -2368,8 +2242,6 @@ MWIFIEX_DFS_FILE_READ_OPS(esuppmode);
 void
 mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 {
-	ENTER();
-
 	if (!mwifiex_dfs_dir || !priv)
 		goto exit;
 
@@ -2404,7 +2276,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(esuppmode);
 
 exit:
-	LEAVE();
+	return;
 }
 
 /*
@@ -2413,14 +2285,12 @@ exit:
 void
 mwifiex_dev_debugfs_remove(struct mwifiex_private *priv)
 {
-	ENTER();
-
 	if (!priv)
 		goto exit;
 
 	debugfs_remove_recursive(priv->dfs_dev_dir);
 exit:
-	LEAVE();
+	return;
 }
 
 /*
@@ -2429,12 +2299,8 @@ exit:
 void
 mwifiex_debugfs_init(void)
 {
-	ENTER();
-
 	if (!mwifiex_dfs_dir)
 		mwifiex_dfs_dir = debugfs_create_dir("mwifiex", NULL);
-
-	LEAVE();
 }
 
 /*
@@ -2443,10 +2309,6 @@ mwifiex_debugfs_init(void)
 void
 mwifiex_debugfs_remove(void)
 {
-	ENTER();
-
 	if (mwifiex_dfs_dir)
 		debugfs_remove(mwifiex_dfs_dir);
-
-	LEAVE();
 }
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 0580775..f4e3392 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -39,8 +39,6 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	int status = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
 	if (!bss_prio) {
 		PRINTM(MERROR, "%s: failed to alloc bss_prio\n", __func__);
@@ -63,7 +61,6 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 			.bss_prio_lock, flags);
 
 exit:
-	LEAVE();
 	return status;
 }
 
@@ -79,8 +76,6 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	u32 i;
 	int ret = 0;
 
-	ENTER();
-
 	priv->media_connected = false;
 	memset(priv->curr_addr, 0xff, MWIFIEX_MAC_ADDR_LENGTH);
 
@@ -154,7 +149,6 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	ret = mwifiex_add_bss_prio_tbl(priv);
 
-	LEAVE();
 	return ret;
 }
 
@@ -172,15 +166,12 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	u32 buf_size;
 	struct mwifiex_bssdescriptor *temp_scan_table;
 
-	ENTER();
-
 	/* Allocate buffer to store the BSSID list */
 	buf_size = sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP;
 	temp_scan_table = kzalloc(buf_size, GFP_KERNEL);
 	if (!temp_scan_table) {
 		PRINTM(MERROR, "%s: failed to alloc temp_scan_table\n",
 		       __func__);
-		LEAVE();
 		return -1;
 	}
 
@@ -190,7 +181,6 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	ret = mwifiex_alloc_cmd_buffer(adapter);
 	if (ret) {
 		PRINTM(MERROR, "Failed to allocate command buffer\n");
-		LEAVE();
 		return -1;
 	}
 
@@ -204,7 +194,6 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	}
 	skb_reserve(adapter->sleep_cfm, INTF_HEADER_LEN);
 
-	LEAVE();
 	return 0;
 }
 
@@ -220,8 +209,6 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf = NULL;
 
-	ENTER();
-
 	skb_put(adapter->sleep_cfm, sizeof(sleep_cfm_buf->ps_cfm_sleep));
 	sleep_cfm_buf =
 		(struct mwifiex_opt_sleep_confirm_buffer *)
@@ -325,7 +312,6 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
 
-	LEAVE();
 	return;
 }
 
@@ -342,11 +328,8 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 static void
 mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 {
-	ENTER();
-
 	if (!adapter) {
 		PRINTM(MERROR, "The adapter is NULL.\n");
-		LEAVE();
 		return;
 	}
 
@@ -369,7 +352,6 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 
 	dev_kfree_skb_any(adapter->sleep_cfm);
 
-	LEAVE();
 	return;
 }
 
@@ -384,8 +366,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	s32           i = 0;
 	u32           j = 0;
 
-	ENTER();
-
 	spin_lock_init(&adapter->mwifiex_lock);
 	spin_lock_init(&adapter->int_lock);
 	spin_lock_init(&adapter->main_proc_lock);
@@ -433,7 +413,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -447,8 +426,6 @@ void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 	s32           i = 0;
 	s32           j = 0;
 
-	ENTER();
-
 	/* Free lists */
 	list_del(&adapter->cmd_free_q);
 	list_del(&adapter->cmd_pending_q);
@@ -467,7 +444,6 @@ void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	LEAVE();
 	return;
 }
 
@@ -491,8 +467,6 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 	int is_cmd_pend_q_empty;
 	unsigned long flags;
 
-	ENTER();
-
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 
 	/* Allocate memory for member of adapter structure */
@@ -539,7 +513,6 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
 	}
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -562,8 +535,6 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	s32 i = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	/* mwifiex already shutdown */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY)
 		return 0;
@@ -598,7 +569,6 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	/* Notify completion */
 	ret = mwifiex_shutdown_fw_complete(adapter);
 
-	LEAVE();
 	return ret;
 }
 
@@ -621,8 +591,6 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	u32 poll_num = 1;
 	int winner;
 
-	ENTER();
-
 	/* Check if firmware is already running */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num, &winner);
 	if (!ret) {
@@ -645,7 +613,6 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 			PRINTM(MERROR, "%s: mwifiex_prog_fw_w_helper failed "
 					"with ret=0x%x\n",
 					__func__, ret);
-			LEAVE();
 			return ret;
 		}
 	}
@@ -656,15 +623,11 @@ poll_fw:
 	if (ret) {
 		PRINTM(MFATAL, "FW failed to be active in time!\n");
 		ret = -1;
-		LEAVE();
 		return ret;
 	}
 done:
-
 	/* re-enable host interrupt for mwifiex after fw dnld is successful */
 	adapter->if_ops.enable_int(adapter);
-
-	LEAVE();
 	return ret;
 }
 
@@ -685,8 +648,6 @@ mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 	spinlock_t *lock;
 	unsigned long flags;
 
-	ENTER();
-
 	for (i = 0; i < adapter->priv_num; ++i) {
 		head = &adapter->bss_prio_tbl[i].bss_prio_head;
 		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
@@ -719,6 +680,4 @@ mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 			*cur = (struct mwifiex_bss_prio_node *)head;
 		}
 	}
-
-	LEAVE();
 }
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 35a3c51..f48e7f3 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -146,8 +146,6 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv,
 	u8 *tmp = NULL;
 	u32 i, j;
 
-	ENTER();
-
 	tmp = kmalloc(rate1_size, GFP_KERNEL);
 	if (!tmp) {
 		PRINTM(MERROR, "%s: failed to alloc tmp\n", __func__);
@@ -192,8 +190,6 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv,
 	ret = 0;
 done:
 	kfree(tmp);
-
-	LEAVE();
 	return ret;
 }
 
@@ -208,7 +204,7 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 {
 	u8 card_rates[MWIFIEX_SUPPORTED_RATES];
 	u32 card_rates_size = 0;
-	ENTER();
+
 	/* Copy AP supported rates */
 	memcpy(out_rates, bss_desc->supported_rates, MWIFIEX_SUPPORTED_RATES);
 	/* Get the STA supported rates */
@@ -219,14 +215,12 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 	     card_rates_size)) {
 		*out_rates_size = 0;
 		PRINTM(MERROR, "mwifiex_get_common_rates failed\n");
-		LEAVE();
 		return -1;
 	}
 
 	*out_rates_size =
 		min_t(size_t, strlen(out_rates), MWIFIEX_SUPPORTED_RATES);
 
-	LEAVE();
 	return 0;
 }
 
@@ -243,8 +237,6 @@ mwifiex_update_tsf_timestamps(struct mwifiex_private *priv,
 	long long new_tsf_base;
 	signed long long tsf_delta;
 
-	ENTER();
-
 	memcpy(&new_tsf_base, new_bss_desc->time_stamp, sizeof(new_tsf_base));
 
 	tsf_delta = new_tsf_base - new_bss_desc->network_tsf;
@@ -256,8 +248,6 @@ mwifiex_update_tsf_timestamps(struct mwifiex_private *priv,
 	     table_idx++) {
 		adapter->scan_table[table_idx].network_tsf += tsf_delta;
 	}
-
-	LEAVE();
 }
 
 /*
@@ -359,8 +349,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	u16 tmp_cap;
 	u8 *pos;
 
-	ENTER();
-
 	bss_desc = (struct mwifiex_bssdescriptor *) data_buf;
 	pos = (u8 *) assoc;
 
@@ -615,7 +603,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	assoc->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -691,8 +678,6 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	struct mwifiex_bssdescriptor *bss_desc;
 	u8 enable_data = true;
 
-	ENTER();
-
 	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
 
 	HEXDUMP("ASSOC_RESP:", (u8 *) &resp->params,
@@ -829,7 +814,6 @@ done:
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -879,8 +863,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		(u8 *) adhoc_start +
 		sizeof(struct host_cmd_ds_802_11_ad_hoc_start);
 
-	ENTER();
-
 	if (!adapter) {
 		ret = -1;
 		goto done;
@@ -1179,7 +1161,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	ret = 0;
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -1218,8 +1199,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		(u8 *) adhoc_join +
 		sizeof(struct host_cmd_ds_802_11_ad_hoc_join);
 
-	ENTER();
-
 /** Use G protection */
 #define USE_G_PROTECTION        0x02
 	if (bss_desc->erp_flags & USE_G_PROTECTION) {
@@ -1451,7 +1430,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				cpu_to_le16(tmp_cap);
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -1474,8 +1452,6 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	u16 command = le16_to_cpu(resp->command);
 	u16 result = le16_to_cpu(resp->result);
 
-	ENTER();
-
 	adhoc_result = &resp->params.adhoc_result;
 
 	bss_desc = priv->attempted_bss_desc;
@@ -1550,7 +1526,6 @@ done:
 
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -1567,14 +1542,10 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	int ret = 0;
 	u8 current_bssid[MWIFIEX_MAC_ADDR_LENGTH];
 
-	ENTER();
-
 	/* Return error if the adapter or table entry is not marked as infra */
 	if ((priv->bss_mode != MWIFIEX_BSS_MODE_INFRA) ||
-	    (bss_desc->bss_mode != MWIFIEX_BSS_MODE_INFRA)) {
-		LEAVE();
+	    (bss_desc->bss_mode != MWIFIEX_BSS_MODE_INFRA))
 		return -1;
-	}
 
 	memcpy(&current_bssid,
 	       &priv->curr_bss_params.bss_descriptor.mac_address,
@@ -1589,7 +1560,6 @@ int mwifiex_associate(struct mwifiex_private *priv,
 				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  bss_desc);
 
-	LEAVE();
 	return ret;
 }
 
@@ -1604,8 +1574,6 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	PRINTM(MINFO, "Adhoc Channel = %d\n", priv->adhoc_channel);
 	PRINTM(MINFO, "curr_bss_params.channel = %d\n",
 	       priv->curr_bss_params.bss_descriptor.channel);
@@ -1617,7 +1585,6 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  adhoc_ssid);
 
-	LEAVE();
 	return ret;
 }
 
@@ -1632,8 +1599,6 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	PRINTM(MINFO, "mwifiex_adhoc_join: CurBss.ssid =%s\n",
 	       priv->curr_bss_params.bss_descriptor.ssid.ssid);
 	PRINTM(MINFO, "mwifiex_adhoc_join: CurBss.ssid_len =%u\n",
@@ -1653,7 +1618,6 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       "ADHOC_J_CMD: New ad-hoc SSID is the same as current, "
 		       "not attempting to re-join\n");
 
-		LEAVE();
 		return -1;
 	}
 
@@ -1667,7 +1631,6 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  bss_desc);
 
-	LEAVE();
 	return ret;
 }
 
@@ -1684,8 +1647,6 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv,
 	int ret = 0;
 	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
 
-	ENTER();
-
 	if (priv->media_connected) {
 		if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
 			if (mac) {
@@ -1725,7 +1686,6 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -1737,8 +1697,6 @@ mwifiex_band_to_radio_type(u8 band)
 {
 	u8 ret_radio_type;
 
-	ENTER();
-
 	switch (band) {
 	case BAND_A:
 	case BAND_AN:
@@ -1753,6 +1711,5 @@ mwifiex_band_to_radio_type(u8 band)
 		break;
 	}
 
-	LEAVE();
 	return ret_radio_type;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 812c1e6..5df47f4 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -76,8 +76,6 @@ static int mwifiex_register(void *card,
 	struct mwifiex_adapter *adapter = NULL;
 	u8 i = 0;
 
-	ENTER();
-
 	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_KERNEL);
 	/* Allocate memory for adapter structure */
 	if (!adapter) {
@@ -166,8 +164,6 @@ error:
 	kfree(adapter);
 
 exit_register:
-
-	LEAVE();
 	return ret;
 }
 
@@ -185,8 +181,6 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 {
 	s32 i = 0;
 
-	ENTER();
-
 	del_timer(&adapter->cmd_timer);
 
 	/* Free private structures */
@@ -198,8 +192,6 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 	}
 
 	kfree(adapter);
-	LEAVE();
-
 	return 0;
 }
 
@@ -223,8 +215,6 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 	int ret = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 
 	/* Check if already processing */
@@ -356,7 +346,6 @@ process_start:
 exit_main_proc:
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING)
 		mwifiex_shutdown_drv(adapter);
-	LEAVE();
 	return ret;
 }
 
@@ -374,8 +363,6 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 	struct mwifiex_device device;
 	struct mwifiex_drv_mode *drv_mode_ptr;
 
-	ENTER();
-
 	/* find mwifiex_drv_mode entry from mwifiex_drv_mode_tbl */
 	drv_mode_ptr = NULL;
 	for (i = 0; i < ARRAY_SIZE(mwifiex_drv_mode_tbl); i++) {
@@ -387,7 +374,6 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 
 	if (!drv_mode_ptr) {
 		PRINTM(MERROR, "Invalid drv_mode_ptr=%d\n", drv_mode);
-		LEAVE();
 		return -1;
 	}
 
@@ -407,7 +393,6 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 	if (mwifiex_register(card, if_ops, &device, pmwifiex))
 		ret = -1;
 
-	LEAVE();
 	return ret;
 }
 
@@ -419,17 +404,13 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
  */
 static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 {
-	ENTER();
 	if (!adapter) {
 		PRINTM(MERROR, "The adapter is NULL.\n");
-		LEAVE();
 		return;
 	}
 
 	mwifiex_unregister(adapter);
 	PRINTM(MINFO, "Free Adapter\n");
-
-	LEAVE();
 }
 
 /*
@@ -447,8 +428,6 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	int err;
 	struct mwifiex_fw_image fw;
 
-	ENTER();
-
 	memset(&fw, 0, sizeof(struct mwifiex_fw_image));
 
 	switch (adapter->revision_id) {
@@ -503,7 +482,6 @@ done:
 		release_firmware(adapter->firmware);
 	if (ret)
 		ret = -1;
-	LEAVE();
 	return ret;
 }
 
@@ -522,8 +500,6 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 	struct timeval tv;
 	u8 tid = 0;
 
-	ENTER();
-
 	eth = (struct ethhdr *) skb->data;
 	switch (eth->h_proto) {
 	case __constant_htons(ETH_P_IP):
@@ -550,7 +526,6 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 	 */
 	do_gettimeofday(&tv);
 	skb->tstamp = timeval_to_ktime(tv);
-	LEAVE();
 	return;
 }
 
@@ -562,11 +537,7 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 static int
 mwifiex_open(struct net_device *dev)
 {
-	ENTER();
-
 	netif_start_queue(dev);
-
-	LEAVE();
 	return 0;
 }
 
@@ -576,8 +547,6 @@ mwifiex_open(struct net_device *dev)
 static int
 mwifiex_close(struct net_device *dev)
 {
-	ENTER();
-	LEAVE();
 	return 0;
 }
 
@@ -592,8 +561,6 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct sk_buff *new_skb = NULL;
 	struct mwifiex_txinfo *tx_info;
 
-	ENTER();
-
 	PRINTM(MDATA, "%lu BSS(%d): Data <= kernel\n", jiffies,
 	       priv->bss_index);
 
@@ -641,7 +608,6 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 
 done:
-	LEAVE();
 	return 0;
 }
 
@@ -656,8 +622,6 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
 	struct sockaddr *hw_addr = (struct sockaddr *) addr;
 
-	ENTER();
-
 	memset(priv->curr_addr, 0, ETH_ALEN);
 	/* dev->dev_addr is 6 bytes */
 	HEXDUMP("dev->dev_addr:", dev->dev_addr, ETH_ALEN);
@@ -672,7 +636,6 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 	HEXDUMP("priv->MacAddr:", priv->curr_addr, ETH_ALEN);
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -683,9 +646,7 @@ static void mwifiex_set_multicast_list(struct net_device *dev)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
-	ENTER();
 	mwifiex_request_set_multicast_list(priv, dev);
-	LEAVE();
 }
 
 /*
@@ -696,12 +657,11 @@ mwifiex_tx_timeout(struct net_device *dev)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
-	ENTER();
+
 	PRINTM(MERROR, "%lu : Tx timeout, bss_index=%d\n", jiffies,
 	       priv->bss_index);
 	dev->trans_start = jiffies;
 	priv->num_tx_timeout++;
-	LEAVE();
 }
 
 /*
@@ -748,8 +708,6 @@ static const struct net_device_ops mwifiex_netdev_ops = {
 static void
 mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
 {
-	ENTER();
-
 	dev->netdev_ops = &mwifiex_netdev_ops;
 	/* Initialize private structure */
 	init_waitqueue_head(&priv->ioctl_wait_q);
@@ -763,7 +721,6 @@ mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
 	priv->workqueue = create_singlethread_workqueue("cfg80211_wq");
 	INIT_WORK(&priv->cfg_workqueue, mwifiex_cfg80211_results);
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
-	LEAVE();
 }
 
 /*
@@ -786,8 +743,6 @@ static struct mwifiex_private *mwifiex_add_interface(
 	struct mwifiex_private *priv = NULL;
 	void *mdev_priv = NULL;
 
-	ENTER();
-
 	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
 			      ether_setup, 1);
 	if (!dev) {
@@ -828,12 +783,10 @@ static struct mwifiex_private *mwifiex_add_interface(
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_init(priv);
 #endif
-	LEAVE();
 	return priv;
 error:
 	if (dev)
 		free_netdev(dev);
-	LEAVE();
 	return NULL;
 }
 
@@ -856,7 +809,6 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 	struct net_device *dev = NULL;
 	struct mwifiex_private *priv = adapter->priv[bss_index];
 
-	ENTER();
 	if (!priv)
 		goto error;
 	dev = priv->netdev;
@@ -887,7 +839,6 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 	wiphy_free(priv->wdev->wiphy);
 	kfree(priv->wdev);
 error:
-	LEAVE();
 	return;
 }
 
@@ -902,8 +853,6 @@ int mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
 	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
 
-	ENTER();
-
 	/* Allocate an IOCTL request buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
@@ -918,7 +867,6 @@ int mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
 
 done:
 	kfree(wait);
-	LEAVE();
 	return status;
 }
 EXPORT_SYMBOL_GPL(mwifiex_shutdown_fw);
@@ -931,8 +879,6 @@ int mwifiex_ascii2hex(u8 *d, char *s, u32 dlen)
 	unsigned int i;
 	u8 n;
 
-	ENTER();
-
 	memset(d, 0x00, dlen);
 
 	for (i = 0; i < dlen * 2; i++) {
@@ -949,7 +895,6 @@ int mwifiex_ascii2hex(u8 *d, char *s, u32 dlen)
 		d[i / 2] += n;
 	}
 
-	LEAVE();
 	return i;
 }
 
@@ -958,8 +903,6 @@ int mwifiex_ascii2hex(u8 *d, char *s, u32 dlen)
  */
 static int mwifiex_hexval(char chr)
 {
-	ENTER();
-
 	if (chr >= '0' && chr <= '9')
 		return chr - '0';
 	if (chr >= 'A' && chr <= 'F')
@@ -967,7 +910,6 @@ static int mwifiex_hexval(char chr)
 	if (chr >= 'a' && chr <= 'f')
 		return chr - 'a' + 10;
 
-	LEAVE();
 	return 0;
 }
 
@@ -978,12 +920,9 @@ int mwifiex_atox(char *a)
 {
 	int i = 0;
 
-	ENTER();
-
 	while (isxdigit(*a))
 		i = i*16 + mwifiex_hexval(*a++);
 
-	LEAVE();
 	return i;
 }
 
@@ -995,12 +934,8 @@ char *mwifiex_strsep(char **s, char delim, char esc)
 {
 	char *se = *s, *sb;
 
-	ENTER();
-
-	if (!(*s) || (*se == '\0')) {
-		LEAVE();
+	if (!(*s) || (*se == '\0'))
 		return NULL;
-	}
 
 	for (sb = *s; *sb != '\0'; ++sb) {
 		if (*sb == esc && *(sb+1) == esc) {
@@ -1030,7 +965,6 @@ char *mwifiex_strsep(char **s, char delim, char esc)
 
 	*s = sb;
 
-	LEAVE();
 	return se;
 }
 
@@ -1042,15 +976,11 @@ void mwifiex_mac2u8(u8 *mac_addr, char *buf)
 	char *begin = buf, *end;
 	int i;
 
-	ENTER();
-
 	for (i = 0; i < ETH_ALEN; ++i) {
 		end = mwifiex_strsep(&begin, ':', '/');
 		if (end)
 			mac_addr[i] = mwifiex_atox(end);
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1075,12 +1005,8 @@ int is_command_pending(struct mwifiex_adapter *adapter)
 struct mwifiex_private *
 mwifiex_bss_index_to_priv(struct mwifiex_adapter *adapter, u8 bss_index)
 {
-	ENTER();
-	if (!adapter || (bss_index >= adapter->priv_num)) {
-		LEAVE();
+	if (!adapter || (bss_index >= adapter->priv_num))
 		return NULL;
-	}
-	LEAVE();
 	return adapter->priv[bss_index];
 }
 
@@ -1096,15 +1022,9 @@ mwifiex_main_work_queue(struct work_struct *work)
 	struct mwifiex_adapter *adapter =
 		container_of(work, struct mwifiex_adapter, main_work);
 
-	ENTER();
-
-	if (adapter->surprise_removed) {
-		LEAVE();
+	if (adapter->surprise_removed)
 		return;
-	}
 	mwifiex_main_process(adapter);
-
-	LEAVE();
 }
 
 /*
@@ -1114,13 +1034,9 @@ mwifiex_main_work_queue(struct work_struct *work)
 static void
 mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
 {
-	ENTER();
-
 	flush_workqueue(adapter->workqueue);
 	destroy_workqueue(adapter->workqueue);
 	adapter->workqueue = NULL;
-
-	LEAVE();
 }
 
 /*
@@ -1145,8 +1061,6 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	struct mwifiex_adapter *adapter = NULL;
 	struct mwifiex_drv_mode *drv_mode_info = &mwifiex_drv_mode_tbl[0];
 
-	ENTER();
-
 	if (down_interruptible(sem))
 		goto exit_sem_err;
 
@@ -1198,7 +1112,6 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 
 	up(sem);
 
-	LEAVE();
 	return 0;
 
 err_add_intf:
@@ -1228,7 +1141,6 @@ err_init_sw:
 	up(sem);
 
 exit_sem_err:
-	LEAVE();
 	return -1;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_card);
@@ -1250,8 +1162,6 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	int status;
 	int i;
 
-	ENTER();
-
 	if (down_interruptible(sem))
 		goto exit_sem_err;
 
@@ -1305,7 +1215,6 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 exit_remove:
 	up(sem);
 exit_sem_err:
-	LEAVE();
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mwifiex_remove_card);
@@ -1318,13 +1227,9 @@ EXPORT_SYMBOL_GPL(mwifiex_remove_card);
 static int
 mwifiex_init_module(void)
 {
-	ENTER();
-
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_debugfs_init();
 #endif
-
-	LEAVE();
 	return 0;
 }
 
@@ -1336,13 +1241,9 @@ mwifiex_init_module(void)
 static void
 mwifiex_cleanup_module(void)
 {
-	ENTER();
-
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_debugfs_remove();
 #endif
-
-	LEAVE();
 }
 
 module_init(mwifiex_init_module);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 461d3fb..0dc5829 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -170,14 +170,8 @@ s32
 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 		 struct mwifiex_802_11_ssid *ssid2)
 {
-	ENTER();
-
-	if (!ssid1 || !ssid2 || (ssid1->ssid_len != ssid2->ssid_len)) {
-		LEAVE();
+	if (!ssid1 || !ssid2 || (ssid1->ssid_len != ssid2->ssid_len))
 		return -1;
-	}
-
-	LEAVE();
 	return memcmp(ssid1->ssid, ssid2->ssid, ssid1->ssid_len);
 }
 
@@ -196,8 +190,6 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 	int ret = 0;
 	u8 *mac = NULL;
 
-	ENTER();
-
 	if (!ssid_bssid) {
 		ret = -1;
 		goto done;
@@ -250,8 +242,6 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 done:
 	kfree(wait1);
 	kfree(wait2);
-
-	LEAVE();
 	return ret;
 }
 
@@ -271,8 +261,6 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 	int status = 0;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
-
 	/* Allocate an IOCTL request buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
@@ -288,7 +276,6 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 done:
 	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
-	LEAVE();
 	return status;
 }
 
@@ -308,11 +295,8 @@ int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
 	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
 
-	ENTER();
-
 	if (down_interruptible(&priv->async_sem)) {
 		PRINTM(MERROR, "Acquire semaphore error, request_scan\n");
-		LEAVE();
 		return -1;
 	}
 	priv->scan_pending_on_block = true;
@@ -344,7 +328,6 @@ done:
 		priv->scan_pending_on_block = false;
 		up(&priv->async_sem);
 	}
-	LEAVE();
 	return ret;
 }
 
@@ -373,22 +356,17 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *bss_desc;
 
-	ENTER();
-
 	bss_desc = &adapter->scan_table[index];
 	bss_desc->disable_11n = false;
 
 	/* Don't check for compatibility if roaming */
 	if (priv->media_connected
 	    && (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA)
-	    && (bss_desc->bss_mode == MWIFIEX_BSS_MODE_INFRA)) {
-		LEAVE();
+	    && (bss_desc->bss_mode == MWIFIEX_BSS_MODE_INFRA))
 		return index;
-	}
 
 	if (priv->wps.session_enable == true) {
 		PRINTM(MINFO, "Return success directly in WPS period\n");
-		LEAVE();
 		return index;
 	}
 
@@ -416,16 +394,13 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 					bss_desc->disable_11n = true;
 
 				} else {
-					LEAVE();
 					return -1;
 				}
 			}
-			LEAVE();
 			return index;
 		} else {
 			PRINTM(MINFO,
 			       "ewpa_enabled: Ignore none WPA/WPA2 AP\n");
-			LEAVE();
 			return -1;
 		}
 	}
@@ -435,7 +410,6 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 	     ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id ==
 			WLAN_EID_BSS_AC_ACCESS_DELAY))) {
 		PRINTM(MINFO, "Return success for WAPI AP\n");
-		LEAVE();
 		return index;
 	}
 
@@ -452,7 +426,6 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 		    && priv->sec_info.encryption_mode ==
 		    MWIFIEX_ENCRYPTION_MODE_NONE && !bss_desc->privacy) {
 			/* No security */
-			LEAVE();
 			return index;
 		} else if (priv->sec_info.wep_status ==
 			   MWIFIEX_802_11_WEP_ENABLED
@@ -462,7 +435,6 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			/* Static WEP enabled */
 			PRINTM(MINFO, "Disable 11n in WEP mode.\n");
 			bss_desc->disable_11n = true;
-			LEAVE();
 			return index;
 		} else if (priv->sec_info.wep_status ==
 			   MWIFIEX_802_11_WEP_DISABLED
@@ -505,11 +477,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 						" not supported by AP\n");
 					bss_desc->disable_11n = true;
 				} else {
-					LEAVE();
 					return -1;
 				}
 			}
-			LEAVE();
 			return index;
 		} else if (priv->sec_info.wep_status ==
 			   MWIFIEX_802_11_WEP_DISABLED
@@ -552,11 +522,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 						" not supported by AP\n");
 					bss_desc->disable_11n = true;
 				} else {
-					LEAVE();
 					return -1;
 				}
 			}
-			LEAVE();
 			return index;
 		} else if (priv->sec_info.wep_status ==
 			   MWIFIEX_802_11_WEP_DISABLED
@@ -571,7 +539,6 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			   && priv->sec_info.encryption_mode ==
 			   MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
 			/* Ad-hoc AES enabled */
-			LEAVE();
 			return index;
 		} else if (priv->sec_info.wep_status ==
 			   MWIFIEX_802_11_WEP_DISABLED
@@ -598,7 +565,6 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 					ieee_hdr.element_id : 0,
 					priv->sec_info.encryption_mode,
 					bss_desc->privacy);
-			LEAVE();
 			return index;
 		}
 
@@ -619,12 +585,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 		       (priv->sec_info.wpa_enabled) ? "e" : "d",
 		       (priv->sec_info.wpa2_enabled) ? "e" : "d",
 		       priv->sec_info.encryption_mode, bss_desc->privacy);
-		LEAVE();
 		return -1;
 	}
 
 	/* Mode doesn't match */
-	LEAVE();
 	return -1;
 }
 
@@ -643,8 +607,6 @@ mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
 	s32 best_rssi = 0;
 	u32 i;
 
-	ENTER();
-
 	PRINTM(MINFO, "Num of BSSIDs = %d\n", adapter->num_in_scan_table);
 
 	for (i = 0; i < adapter->num_in_scan_table; i++) {
@@ -674,7 +636,6 @@ mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
 		}
 	}
 
-	LEAVE();
 	return best_net;
 }
 
@@ -700,8 +661,6 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 	int chan_idx = 0, i;
 	u8 scan_type;
 
-	ENTER();
-
 	for (band = 0; (band < IEEE80211_NUM_BANDS) ; band++) {
 
 		if (!priv->wdev->wiphy->bands[band])
@@ -746,8 +705,6 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 		}
 
 	}
-
-	LEAVE();
 }
 
 /*
@@ -777,12 +734,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	u32 total_scan_time;
 	u32 done_early;
 
-	ENTER();
-
 	if (!scan_cfg_out || !chan_tlv_out || !scan_chan_list) {
 		PRINTM(MINFO, "Scan: Null detect: %p, %p, %p\n",
 		       scan_cfg_out, chan_tlv_out, scan_chan_list);
-		LEAVE();
 		return -1;
 	}
 
@@ -912,12 +866,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			break;
 	}
 
-	LEAVE();
-
 	if (ret)
 		return -1;
 
-
 	return 0;
 }
 
@@ -972,8 +923,6 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	u32 rates_size;
 	struct mwifiex_ie_types_htcap *ht_cap;
 
-	ENTER();
-
 	/* The tlv_buf_len is calculated for each scan command.  The TLVs added
 	   in this routine will be preserved since the routine that sends the
 	   command will append channelTLVs at *chan_list_out.  The difference
@@ -1216,8 +1165,6 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 						 scan_chan_list,
 						 *filtered_scan);
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1241,8 +1188,6 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 	u32 tlv_type;
 	u32 tlv_len;
 
-	ENTER();
-
 	current_tlv = tlv;
 	tlv_buf_left = tlv_buf_size;
 	*tlv_data = NULL;
@@ -1282,7 +1227,6 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 				       "SCAN_RESP: Unhandled TLV = %d\n",
 				       tlv_type);
 				/* Give up, this seems corrupted */
-				LEAVE();
 				return;
 			}
 		}
@@ -1297,8 +1241,6 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 							  tlv_len);
 
 	}			/* while */
-
-	LEAVE();
 }
 
 /*
@@ -1351,8 +1293,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	const u8 wpa_oui[4] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wmm_oui[4] = { 0x00, 0x50, 0xf2, 0x02 };
 
-	ENTER();
-
 	found_data_rate_ie = false;
 	rate_size = 0;
 	beacon_size = 0;
@@ -1365,11 +1305,8 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	}
 
 	if (!beacon_size || beacon_size > *bytes_left) {
-
 		*beacon_info += *bytes_left;
 		*bytes_left = 0;
-
-		LEAVE();
 		return -1;
 	}
 
@@ -1395,7 +1332,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 	if (bytes_left_for_current_beacon < 12) {
 		PRINTM(MERROR, "InterpretIE: Not enough bytes left\n");
-		LEAVE();
 		return -1;
 	}
 
@@ -1691,8 +1627,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		bytes_left_for_current_beacon -= (element_len + 2);
 
 	}			/* while (bytes_left_for_current_beacon > 2) */
-
-	LEAVE();
 	return ret;
 }
 
@@ -1734,8 +1668,6 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u32 adj_idx;
 
-	ENTER();
-
 	for (adj_idx = 0; adj_idx < num_of_ent; adj_idx++) {
 		if (adapter->scan_table[adj_idx].beacon_buf > bcn_store) {
 
@@ -1797,8 +1729,6 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 			}
 		}
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1831,8 +1761,6 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 	u32 old_bcn_size;
 	u32 bcn_space;
 
-	ENTER();
-
 	if (adapter->scan_table[beacon_idx].beacon_buf) {
 
 		new_bcn_size = new_beacon->beacon_buf_size;
@@ -2196,8 +2124,6 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			new_beacon->overlap_bss_offset = 0;
 		}
 	}
-
-	LEAVE();
 }
 
 /*
@@ -2219,8 +2145,6 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 	u32 i;
 	unsigned long flags;
 
-	ENTER();
-
 	if (priv->media_connected) {
 
 		j = mwifiex_find_ssid_in_list(priv,
@@ -2290,8 +2214,6 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 		       adapter->scan_table[i].mac_address[5],
 		       (s32) adapter->scan_table[i].rssi,
 		       adapter->scan_table[i].ssid.ssid);
-
-	LEAVE();
 }
 
 /*
@@ -2330,8 +2252,6 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 	u32 beacon_buf_adj;
 	u8 *beacon_buf;
 
-	ENTER();
-
 	/*
 	 * Shift the saved beacon buffer data for the scan table back over the
 	 *   entry being removed.  Update the end of buffer pointer.  Save the
@@ -2468,8 +2388,6 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 	       0x00, sizeof(struct mwifiex_bssdescriptor));
 
 	adapter->num_in_scan_table--;
-
-	LEAVE();
 }
 
 /*
@@ -2485,8 +2403,6 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 	int ret = -1;
 	s32 table_idx;
 
-	ENTER();
-
 	PRINTM(MINFO, "Scan: Delete Ssid Entry: %-32s\n", del_ssid->ssid);
 
 	/* If the requested SSID is found in the table, delete it.  Then keep
@@ -2503,7 +2419,6 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 		mwifiex_scan_delete_table_entry(priv, table_idx);
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -2533,8 +2448,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	u8 max_chan_per_scan;
 	unsigned long flags;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		if (scan_resp) {
 			scan_resp->scan_table = (u8 *) adapter->scan_table;
@@ -2543,13 +2456,11 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 		} else {
 			ret = -1;
 		}
-		LEAVE();
 		return ret;
 	}
 
 	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
 		PRINTM(MCMND, "Scan already in process...\n");
-		LEAVE();
 		return ret;
 	}
 
@@ -2559,7 +2470,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 
 	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
 		PRINTM(MCMND, "Scan is blocked during association...\n");
-		LEAVE();
 		return ret;
 	}
 
@@ -2567,7 +2477,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 					GFP_KERNEL);
 	if (!scan_cfg_out) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
-		LEAVE();
 		return -1;
 	}
 
@@ -2578,7 +2487,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	if (!scan_chan_list) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
 		kfree(scan_cfg_out);
-		LEAVE();
 		return -1;
 	}
 
@@ -2631,8 +2539,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 
 	kfree(scan_cfg_out);
 	kfree(scan_chan_list);
-
-	LEAVE();
 	return ret;
 }
 
@@ -2656,8 +2562,6 @@ int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_scan *scan_cmd = &cmd->params.scan;
 	struct mwifiex_scan_cmd_config *scan_cfg;
 
-	ENTER();
-
 	scan_cfg = (struct mwifiex_scan_cmd_config *) data_buf;
 
 	/* Set fixed field variables in scan command */
@@ -2674,7 +2578,6 @@ int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
 					  + sizeof(scan_cmd->bssid)
 					  + scan_cfg->tlv_buf_len + S_DS_GEN));
 
-	LEAVE();
 	return 0;
 }
 
@@ -2723,8 +2626,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	u8 is_bgscan_resp;
 	unsigned long flags;
 
-	ENTER();
-
 	is_bgscan_resp = (le16_to_cpu(resp->command)
 		== HostCmd_CMD_802_11_BG_SCAN_QUERY);
 	if (is_bgscan_resp)
@@ -2985,8 +2886,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 done:
 	kfree((u8 *) bss_new_entry);
-
-	LEAVE();
 	return ret;
 }
 
@@ -3005,8 +2904,6 @@ int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_bg_scan_query *bg_query =
 		&cmd->params.bg_scan_query;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_BG_SCAN_QUERY);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_bg_scan_query) +
@@ -3014,7 +2911,6 @@ int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
 
 	bg_query->flush = 1;
 
-	LEAVE();
 	return 0;
 }
 
@@ -3036,8 +2932,6 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 	u8 best_rssi = 0;
 	u32 i;
 
-	ENTER();
-
 	PRINTM(MINFO, "Num of Entries in Table = %d\n",
 	       adapter->num_in_scan_table);
 
@@ -3098,7 +2992,6 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return net;
 }
 
@@ -3119,12 +3012,8 @@ mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
 	s32 net = -1;
 	u32 i;
 
-	ENTER();
-
-	if (!bssid) {
-		LEAVE();
+	if (!bssid)
 		return -1;
-	}
 
 	PRINTM(MINFO, "FindBSSID: Num of BSSIDs = %d\n",
 	       adapter->num_in_scan_table);
@@ -3161,7 +3050,6 @@ mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
 		}
 	}
 
-	LEAVE();
 	return net;
 }
 
@@ -3175,13 +3063,9 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	list_add_tail(&cmd_node->list, &adapter->scan_pending_q);
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
-
-	LEAVE();
 }
 
 /*
@@ -3195,8 +3079,6 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 	struct mwifiex_bssdescriptor *req_bss;
 	s32 i;
 
-	ENTER();
-
 	memset(req_ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
 
 	i = mwifiex_find_best_network_in_list(priv);
@@ -3227,7 +3109,6 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 	       req_ssid_bssid->bssid[4], req_ssid_bssid->bssid[5]);
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -3244,8 +3125,6 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	int ret = 0;
 	struct mwifiex_user_scan_cfg *scan_cfg;
 
-	ENTER();
-
 	if (!req_ssid) {
 		ret = -1;
 		goto done;
@@ -3260,19 +3139,16 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 		} else {
 			ret = -1;
 		}
-		LEAVE();
 		return ret;
 	}
 
 	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
 		PRINTM(MCMND, "Scan already in process...\n");
-		LEAVE();
 		return ret;
 	}
 
 	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
 		PRINTM(MCMND, "Scan is blocked during association...\n");
-		LEAVE();
 		return ret;
 	}
 
@@ -3294,7 +3170,6 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	kfree(scan_cfg);
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -3308,17 +3183,10 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
 	int id, ret_len = 0;
 	struct mwifiex_ie_types_vendor_param_set *vs_param_set;
 
-	ENTER();
-
-	/* Null Checks */
-	if (buffer == NULL) {
-		LEAVE();
+	if (!buffer)
 		return 0;
-	}
-	if (*buffer == NULL) {
-		LEAVE();
+	if (!(*buffer))
 		return 0;
-	}
 
 	/**
 	 * Traverse through the saved vendor specific IE array and append
@@ -3347,8 +3215,6 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
 				sizeof(struct mwifiex_ie_types_header);
 		}
 	}
-
-	LEAVE();
 	return ret_len;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index c948c04..7bff953 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -50,8 +50,6 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	int ret = 0;
 	struct sdio_mmc_card *card = NULL;
 
-	ENTER();
-
 	PRINTM(MINFO, "vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
 	       func->vendor, func->device, func->class, func->num);
 
@@ -59,7 +57,6 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	if (!card) {
 		PRINTM(MFATAL,
 		       "Failed to allocate memory in probe function!\n");
-		LEAVE();
 		return -ENOMEM;
 	}
 
@@ -73,7 +70,6 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 
 	if (ret) {
 		PRINTM(MFATAL, "sdio_enable_func() failed: ret=%d\n", ret);
-		LEAVE();
 		return -EIO;
 	}
 
@@ -86,7 +82,6 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		ret = -1;
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -100,8 +95,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 {
 	struct sdio_mmc_card *card;
 
-	ENTER();
-
 	PRINTM(MINFO, "SDIO func=%d\n", func->num);
 
 	if (func) {
@@ -112,8 +105,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 			kfree(card);
 		}
 	}
-
-	LEAVE();
 }
 
 /*
@@ -136,8 +127,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	int i;
 	int ret = 0;
 
-	ENTER();
-
 	if (func) {
 		pm_flag = sdio_get_host_pm_caps(func);
 		PRINTM(MCMND, "%s: suspend: PM flag = 0x%x\n",
@@ -147,7 +136,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 			       "%s: cannot remain alive while "
 			       "host is suspended\n",
 			       sdio_func_id(func));
-			LEAVE();
 			return -ENOSYS;
 		}
 
@@ -155,12 +143,10 @@ static int mwifiex_sdio_suspend(struct device *dev)
 		if (!card || !card->adapter) {
 			PRINTM(MERROR,
 			       "Card or moal_handle structure is not valid\n");
-			LEAVE();
 			return 0;
 		}
 	} else {
 		PRINTM(MERROR, "sdio_func is not specified\n");
-		LEAVE();
 		return 0;
 	}
 
@@ -179,7 +165,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	for (i = 0; i < adapter->priv_num; i++)
 		netif_carrier_off(adapter->priv[i]->netdev);
 
-	LEAVE();
 	return ret;
 }
 
@@ -201,20 +186,16 @@ static int mwifiex_sdio_resume(struct device *dev)
 	mmc_pm_flag_t pm_flag = 0;
 	int i;
 
-	ENTER();
-
 	if (func) {
 		pm_flag = sdio_get_host_pm_caps(func);
 		card = sdio_get_drvdata(func);
 		if (!card || !card->adapter) {
 			PRINTM(MERROR,
 			       "Card or moal_handle structure is not valid\n");
-			LEAVE();
 			return 0;
 		}
 	} else {
 		PRINTM(MERROR, "sdio_func is not specified\n");
-		LEAVE();
 		return 0;
 	}
 
@@ -222,7 +203,6 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 	if (!adapter->is_suspended) {
 		PRINTM(MWARN, "Device already resumed\n");
-		LEAVE();
 		return 0;
 	}
 
@@ -236,7 +216,6 @@ static int mwifiex_sdio_resume(struct device *dev)
 	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
 			      MWIFIEX_NO_WAIT);
 
-	LEAVE();
 	return 0;
 }
 
@@ -376,12 +355,9 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	int ret;
 
-	ENTER();
-
 	PRINTM(MEVENT, "Wakeup device...\n");
 	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, HOST_POWER_UP);
 
-	LEAVE();
 	return ret;
 }
 
@@ -394,12 +370,9 @@ static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 {
 	int ret;
 
-	ENTER();
-
 	PRINTM(MCMND, "Wakeup device completed\n");
 	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, 0);
 
-	LEAVE();
 	return ret;
 }
 
@@ -597,8 +570,6 @@ mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
 {
 	u32 fws0 = 0, fws1 = 0;
 
-	ENTER();
-
 	if (mwifiex_read_reg(adapter, CARD_FW_STATUS0_REG, &fws0))
 		return -1;
 
@@ -607,7 +578,6 @@ mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
 
 	*dat = (u16) ((fws1 << 8) | fws0);
 
-	LEAVE();
 	return 0;
 }
 
@@ -621,24 +591,18 @@ static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 {
 	u32 host_int_mask = 0;
 
-	ENTER();
-
 	/* Read back the host_int_mask register */
-	if (mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask)) {
-		LEAVE();
+	if (mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask))
 		return -1;
-	}
 
 	/* Update with the mask and write back to the register */
 	host_int_mask &= ~HOST_INT_DISABLE;
 
 	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, host_int_mask)) {
 		PRINTM(MWARN, "Disable host interrupt failed\n");
-		LEAVE();
 		return -1;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -650,17 +614,11 @@ static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 {
-
-	ENTER();
-
 	/* Simply write the mask to the register */
 	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, HOST_INT_ENABLE)) {
 		PRINTM(MWARN, "Enable host interrupt failed\n");
-		LEAVE();
 		return -1;
 	}
-
-	LEAVE();
 	return 0;
 }
 
@@ -674,8 +632,6 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (!buffer) {
 		PRINTM(MWARN, "skb NULL pointer received!\n");
 		ret = -1;
@@ -704,7 +660,6 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 	*type = le16_to_cpu(*(__le16 *) (buffer + 2));
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -728,11 +683,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u32 txlen = 0, tx_blocks = 0, tries = 0;
 	u32 i = 0;
 
-	ENTER();
-
 	if (!firmware_len) {
 		PRINTM(MMSG, "No firmware image found! Terminating download\n");
-		LEAVE();
 		return -1;
 	}
 
@@ -744,7 +696,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		PRINTM(MERROR,
 		       "Unable to allocate buffer for firmware. Terminating "
 		       "download\n");
-		LEAVE();
 		return -1;
 	}
 
@@ -865,10 +816,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 	ret = 0;
 done:
-
 	kfree(fwbuf);
-
-	LEAVE();
 	return ret;
 }
 
@@ -885,8 +833,6 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 	u32 tries;
 	u32 winner_status;
 
-	ENTER();
-
 	/* Wait for firmware initialization event */
 	for (tries = 0; tries < poll_num; tries++) {
 		ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
@@ -911,8 +857,6 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 		else
 			*winner = 1;
 	}
-
-	LEAVE();
 	return ret;
 }
 
@@ -925,8 +869,6 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	u32 sdio_ireg = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
 				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0,
 				   0)) {
@@ -948,7 +890,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
 	}
 done:
-	LEAVE();
+	return;
 }
 
 /*
@@ -963,10 +905,6 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 	struct mwifiex_adapter *adapter;
 	struct sdio_mmc_card *card;
 
-	ENTER();
-
-	PRINTM(MINTR, "*\n");
-
 	card = sdio_get_drvdata(func);
 	if (!card || !card->adapter) {
 		PRINTM(MINFO, "%s: func=%p card=%p adapter=%p\n", __func__,
@@ -985,7 +923,6 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 	queue_work(adapter->workqueue, &adapter->main_work);
 
 exit:
-	LEAVE();
 	return;
 }
 
@@ -1079,7 +1016,6 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	u8 *curr_ptr;
 	u32 rx_len = skb->len;
 
-	ENTER();
 	if (port == CTRL_PORT) {
 		/* Read the command Resp without aggr */
 		PRINTM(MINFO, "card_2_host_mp_aggr: No "
@@ -1214,7 +1150,6 @@ rx_curr_single:
 	}
 
 done:
-	LEAVE();
 	return ret;
 
 }
@@ -1246,8 +1181,6 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	u16 rx_len;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&adapter->int_lock, flags);
 	sdio_ireg = adapter->int_status;
 	adapter->int_status = 0;
@@ -1357,8 +1290,6 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 
 	ret = 0;
 done:
-
-	LEAVE();
 	return ret;
 }
 
@@ -1382,8 +1313,6 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	u32 blk_size;
 	u8 port = CTRL_PORT;
 
-	ENTER();
-
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
@@ -1443,7 +1372,6 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	}
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -1472,8 +1400,6 @@ int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_precopy_cur_buf = 0;
 	s32 f_postcopy_cur_buf = 0;
 
-	ENTER();
-
 	PRINTM(MDAT_D, "host_2_card_mp_aggr: next_pkt_len: %d curr_port:%d\n",
 	       next_pkt_len, port);
 
@@ -1577,7 +1503,6 @@ tx_curr_single:
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -1590,8 +1515,6 @@ int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
 
-	ENTER();
-
 	card->mpa_tx.buf = kzalloc(mpa_tx_buf_size, GFP_KERNEL);
 	if (!card->mpa_tx.buf) {
 		PRINTM(MERROR,
@@ -1618,7 +1541,6 @@ error:
 		kfree(card->mpa_rx.buf);
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -1633,8 +1555,6 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 
-	ENTER();
-
 	if (adapter->card) {
 		/* Release the SDIO IRQ */
 		sdio_claim_host(card->func);
@@ -1646,8 +1566,6 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 
 		PRINTM(MWARN, "Making the sdio dev card as NULL\n");
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1661,8 +1579,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
 
-	ENTER();
-
 	/* save adapter pointer in card */
 	card->adapter = adapter;
 
@@ -1689,7 +1605,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 
 	adapter->hotplug_device = &func->dev;
 
-	LEAVE();
 	return 0;
 
 release_irq:
@@ -1699,7 +1614,6 @@ disable_func:
 	sdio_release_host(func);
 	adapter->card = NULL;
 
-	LEAVE();
 	return -1;
 }
 
@@ -1857,8 +1771,6 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
 
-	ENTER();
-
 	if (!write) {
 		data[0] = card->mpa_tx.enabled;
 		data[1] = card->mpa_rx.enabled;
@@ -1970,7 +1882,6 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -2004,13 +1915,10 @@ mwifiex_sdio_init_module(void)
 {
 	int ret;
 
-	ENTER();
-
 	sema_init(&add_remove_card_sem, 1);
 
 	ret = sdio_register_driver(&mwifiex_sdio);
 
-	LEAVE();
 	return ret;
 }
 
@@ -2029,8 +1937,6 @@ mwifiex_sdio_cleanup_module(void)
 	struct mwifiex_adapter *adapter = g_adapter;
 	int i;
 
-	ENTER();
-
 	if (down_interruptible(&add_remove_card_sem))
 		goto exit_sem_err;
 
@@ -2058,8 +1964,6 @@ exit:
 
 exit_sem_err:
 	sdio_unregister_driver(&mwifiex_sdio);
-
-	LEAVE();
 }
 
 module_init(mwifiex_sdio_init_module);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index d64f6b9..d0a7558 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -39,8 +39,6 @@ static int
 mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *cmd, u16 cmd_action)
 {
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_RSSI_INFO);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rssi_info) +
@@ -59,7 +57,6 @@ mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
 	priv->bcn_rssi_avg = 0;
 	priv->bcn_nf_avg = 0;
 
-	LEAVE();
 	return 0;
 }
 
@@ -77,12 +74,9 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 	struct host_cmd_ds_mac_control *mac_ctrl = &cmd->params.mac_ctrl;
 	u16 action = *((u16 *) data_buf);
 
-	ENTER();
-
 	if (cmd_action != HostCmd_ACT_GEN_SET) {
 		PRINTM(MERROR,
 		       "mwifiex_cmd_mac_control(): support SET only.\n");
-		LEAVE();
 		return -1;
 	}
 
@@ -91,7 +85,6 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 		cpu_to_le16(sizeof(struct host_cmd_ds_mac_control) + S_DS_GEN);
 	mac_ctrl->action = cpu_to_le16(action);
 
-	LEAVE();
 	return 0;
 }
 
@@ -118,7 +111,6 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
 	u32 ul_temp;
 
-	ENTER();
 	PRINTM(MCMND, "SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
@@ -192,7 +184,6 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	       "SNMP_CMD: Action=0x%x, OID=0x%x, OIDSize=0x%x, Value=0x%x\n",
 	       cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
 	       le16_to_cpu(*(__le16 *) snmp_mib->value));
-	LEAVE();
 	return 0;
 }
 
@@ -207,12 +198,10 @@ static int
 mwifiex_cmd_802_11_get_log(struct mwifiex_private *priv,
 			   struct host_cmd_ds_command *cmd)
 {
-	ENTER();
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_GET_LOG);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_get_log) +
 			    S_DS_GEN);
-	LEAVE();
 	return 0;
 }
 
@@ -236,8 +225,6 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 
 	u32 i;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_TX_RATE_CFG);
 
 	rate_cfg->action = cpu_to_le16(cmd_action);
@@ -281,7 +268,6 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 			    sizeof(struct mwifiex_rate_scope) +
 			    sizeof(struct mwifiex_rate_drop_pattern));
 
-	LEAVE();
 	return 0;
 }
 
@@ -302,8 +288,6 @@ static int mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
 	struct host_cmd_ds_txpwr_cfg *txp = NULL;
 	struct host_cmd_ds_txpwr_cfg *cmd_txp_cfg = &cmd->params.txp_cfg;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_TXPWR_CFG);
 	cmd->size =
 		cpu_to_le16(S_DS_GEN + sizeof(struct host_cmd_ds_txpwr_cfg));
@@ -341,7 +325,6 @@ static int mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
 		break;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -363,8 +346,6 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_hs_cfg_enh *hs_cfg = &cmd->params.opt_hs_cfg;
 	u16 hs_activate = false;
 
-	ENTER();
-
 	if (data_buf == NULL) {
 		/* New Activate command */
 		hs_activate = true;
@@ -407,7 +388,6 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		       hs_cfg->params.hs_config.gap);
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -423,7 +403,6 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *cmd,
 					  u16 cmd_action)
 {
-	ENTER();
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_MAC_ADDRESS);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_mac_address) +
@@ -436,7 +415,6 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
 		memcpy(cmd->params.mac_addr.mac_addr, priv->curr_addr,
 		       MWIFIEX_MAC_ADDR_LENGTH);
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -455,8 +433,6 @@ static int mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_sleep_period *cmd_sleep_pd =
 		&cmd->params.sleep_pd;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SLEEP_PERIOD);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_sleep_period) +
@@ -466,7 +442,6 @@ static int mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
 
 	cmd_sleep_pd->action = cpu_to_le16(cmd_action);
 
-	LEAVE();
 	return 0;
 }
 
@@ -486,7 +461,6 @@ static int mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
 		(struct mwifiex_multicast_list *) data_buf;
 	struct host_cmd_ds_mac_multicast_adr *mcast_addr = &cmd->params.mc_addr;
 
-	ENTER();
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_mac_multicast_adr) +
 			    S_DS_GEN);
@@ -498,7 +472,6 @@ static int mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
 	memcpy(mcast_addr->mac_list, mcast_list->mac_list,
 	       mcast_list->num_multicast_addr * MWIFIEX_MAC_ADDR_LENGTH);
 
-	LEAVE();
 	return 0;
 }
 
@@ -516,8 +489,6 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_deauthenticate *deauth = &cmd->params.deauth;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_DEAUTHENTICATE);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_deauthenticate) +
@@ -533,7 +504,6 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 
 	deauth->reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
 
-	LEAVE();
 	return 0;
 }
 
@@ -547,12 +517,8 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 static int mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *cmd)
 {
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_AD_HOC_STOP);
 	cmd->size = cpu_to_le16(S_DS_GEN);
-
-	LEAVE();
 	return 0;
 }
 
@@ -571,8 +537,6 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 	u8 i;
 	int ret = 0;
 
-	ENTER();
-
 	/* Multi-key_param_set TLV is supported */
 	for (i = 0; i < NUM_WEP_KEYS; i++) {
 		if ((priv->wep_key[i].key_length == WLAN_KEY_LEN_WEP40) ||
@@ -627,7 +591,6 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -653,8 +616,6 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 	int ret = 0;
 	const u8 bc_mac[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_KEY_MATERIAL);
 	key_material->action = cpu_to_le16(cmd_action);
 
@@ -784,7 +745,6 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 				    sizeof(key_material->action) + S_DS_GEN);
 	}
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -813,7 +773,6 @@ static int mwifiex_cmd_802_11_supplicant_pmk(
 				(struct mwifiex_ds_passphrase *)pdata_buf;
 	u8 zero_mac[] = {0, 0, 0, 0, 0, 0 };
 
-	ENTER();
 	/*
 	 * Parse the rest of the buf here
 	 *      1)  <ssid="valid ssid"> - This will get the passphrase, AKMP
@@ -895,13 +854,11 @@ static int mwifiex_cmd_802_11_supplicant_pmk(
 				&& (!ppmk_tlv && !ppassphrase_tlv))) {
 		PRINTM(MERROR, "Invalid case,ssid/bssid present without pmk "
 			       "or passphrase\n");
-		LEAVE();
 		return -1;
 	}
 	cmd->command = cpu_to_le16(HostCmd_CMD_SUPPLICANT_PMK);
 	pesupp_psk->action = cpu_to_le16(cmd_action);
 	pesupp_psk->cache_result = 0;
-	LEAVE();
 	return 0;
 }
 
@@ -920,14 +877,11 @@ static int mwifiex_cmd_802_11_supplicant_profile(
 	struct host_cmd_ds_802_11_supplicant_profile *sup_profile =
 					&cmd->params.esupp_profile;
 
-	ENTER();
-
 	cmd->size = cpu_to_le16(
 			sizeof(struct host_cmd_ds_802_11_supplicant_profile) +
 			S_DS_GEN - 1);
 	cmd->command = cpu_to_le16(HostCmd_CMD_SUPPLICANT_PROFILE);
 	sup_profile->action = cpu_to_le16(cmd_action);
-	LEAVE();
 	return 0;
 }
 
@@ -950,8 +904,6 @@ int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 		&domain_info->domain;
 	u8 no_of_triplet = adapter->domain_reg.no_of_triplet;
 
-	ENTER();
-
 	PRINTM(MINFO, "11D: no_of_triplet=0x%x\n", no_of_triplet);
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11D_DOMAIN_INFO);
@@ -962,7 +914,6 @@ int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 		S_DS_GEN);
 		HEXDUMP("11D: 802_11D_DOMAIN_INFO", (u8 *) cmd,
 				le16_to_cpu(cmd->size));
-		LEAVE();
 		return 0;
 	}
 
@@ -993,7 +944,6 @@ int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 	HEXDUMP("11D: 802_11D_DOMAIN_INFO", (u8 *) cmd,
 			le16_to_cpu(cmd->size));
 
-	LEAVE();
 	return 0;
 }
 
@@ -1013,8 +963,6 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 		&cmd->params.rf_channel;
 	uint16_t rf_type = le16_to_cpu(rf_chan->rf_type);
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_RF_CHANNEL);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rf_channel)
 				+ S_DS_GEN);
@@ -1031,7 +979,6 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 		rf_chan->current_channel = cpu_to_le16(*((u16 *) data_buf));
 	}
 	rf_chan->action = cpu_to_le16(cmd_action);
-	LEAVE();
 	return 0;
 }
 
@@ -1049,7 +996,6 @@ static int mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_rf_antenna *antenna = &cmd->params.antenna;
 
-	ENTER();
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_RF_ANTENNA);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rf_antenna) +
@@ -1062,7 +1008,6 @@ static int mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
 		antenna->action = cpu_to_le16(HostCmd_ACT_GET_BOTH);
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -1082,8 +1027,6 @@ static int mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
 		&(cmd->params.ibss_coalescing);
 	u16 enable = 0;
 
-	ENTER();
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_IBSS_COALESCING_STATUS);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_ibss_status) +
@@ -1104,7 +1047,6 @@ static int mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
 		break;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -1130,8 +1072,6 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 {
 	struct mwifiex_ds_reg_rw *reg_rw;
 
-	ENTER();
-
 	reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
 	switch (le16_to_cpu(cmd->command)) {
 	case HostCmd_CMD_MAC_REG_ACCESS:
@@ -1232,11 +1172,9 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 			break;
 		}
 	default:
-		LEAVE();
 		return -1;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -1471,8 +1409,6 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	struct mwifiex_ds_auto_ds auto_ds;
 	enum state_11d_t state_11d;
 
-	ENTER();
-
 	if (first_sta) {
 
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_FUNC_INIT,
@@ -1587,6 +1523,5 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	priv->adapter->last_init_cmd = HostCmd_CMD_802_11_SNMP_MIB;
 	ret = -EINPROGRESS;
 done:
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 1d08629..4d13bb9 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -49,8 +49,6 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
-	ENTER();
-
 	PRINTM(MERROR, "CMD_RESP: cmd %#x error, result=%#x\n", resp->command,
 	       resp->result);
 	if (wq_buf)
@@ -114,7 +112,6 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	adapter->curr_cmd = NULL;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-	LEAVE();
 	return;
 }
 
@@ -139,8 +136,6 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 		&resp->params.rssi_info_rsp;
 	struct mwifiex_ds_get_signal *signal = NULL;
 
-	ENTER();
-
 	priv->data_rssi_last = le16_to_cpu(rssi_info_rsp->data_rssi_last);
 	priv->data_nf_last = le16_to_cpu(rssi_info_rsp->data_nf_last);
 
@@ -183,7 +178,6 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 		signal->data_nf_avg = priv->data_nf_avg;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -208,8 +202,6 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 	u16 query_type = le16_to_cpu(smib->query_type);
 	u32 ul_temp;
 
-	ENTER();
-
 	PRINTM(MINFO, "SNMP_RESP: value of the oid = 0x%x, query_type=0x%x\n",
 	       oid, query_type);
 	PRINTM(MINFO, "SNMP_RESP: Buf size  = 0x%x\n",
@@ -250,7 +242,6 @@ static int mwifiex_ret_get_log(struct mwifiex_private *priv,
 		(struct host_cmd_ds_802_11_get_log *) &resp->params.get_log;
 	struct mwifiex_ds_get_stats *stats = NULL;
 
-	ENTER();
 	if (data_buf) {
 		stats = (struct mwifiex_ds_get_stats *) data_buf;
 		stats->mcast_tx_frame = le32_to_cpu(get_log->mcast_tx_frame);
@@ -275,7 +266,6 @@ static int mwifiex_ret_get_log(struct mwifiex_private *priv,
 			le32_to_cpu(get_log->wep_icv_err_cnt[3]);
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -308,8 +298,6 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	u32 i;
 	int ret = 0;
 
-	ENTER();
-
 	tlv_buf =
 		(u8 *) ((u8 *) rate_cfg) +
 		sizeof(struct host_cmd_ds_tx_rate_cfg);
@@ -384,7 +372,6 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -400,8 +387,6 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 	struct mwifiex_types_power_group *pg_tlv_hdr = NULL;
 	struct mwifiex_power_group *pg = NULL;
 
-	ENTER();
-
 	if (data_buf) {
 		pg_tlv_hdr =
 			(struct mwifiex_types_power_group *) ((u8 *) data_buf
@@ -432,11 +417,9 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 			priv->max_tx_power_level = (u8) max_power;
 		}
 	} else {
-		LEAVE();
 		return -1;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -457,7 +440,6 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 	struct mwifiex_power_group *pg = NULL;
 	u16 action = le16_to_cpu(txp_cfg->action);
 
-	ENTER();
 	switch (action) {
 	case HostCmd_ACT_GEN_GET:
 		{
@@ -495,7 +477,6 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 		break;
 	default:
 		PRINTM(MERROR, "CMD_RESP: unknown command action %d\n", action);
-		LEAVE();
 		return 0;
 	}
 	PRINTM(MINFO,
@@ -503,7 +484,6 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 	       priv->tx_power_level, priv->max_tx_power_level,
 	       priv->min_tx_power_level);
 
-	LEAVE();
 	return 0;
 }
 
@@ -524,8 +504,6 @@ static int mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
 	u32 *sleep_period;
 	u16 sleep_pd = 0;
 
-	ENTER();
-
 	sleep_pd = le16_to_cpu(cmd_sleep_pd->sleep_pd);
 	if (data_buf) {
 		sleep_period = (u32 *) data_buf;
@@ -542,7 +520,6 @@ static int mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
 		priv->adapter->gen_null_pkt = false;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -557,8 +534,6 @@ static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_mac_address *cmd_mac_addr =
 		&resp->params.mac_addr;
 
-	ENTER();
-
 	memcpy(priv->curr_addr, cmd_mac_addr->mac_addr,
 		MWIFIEX_MAC_ADDR_LENGTH);
 
@@ -567,7 +542,6 @@ static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 	       priv->curr_addr[3], priv->curr_addr[4],
 	       priv->curr_addr[5]);
 
-	LEAVE();
 	return 0;
 }
 
@@ -578,8 +552,6 @@ static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 static int mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
 					 struct host_cmd_ds_command *resp)
 {
-	ENTER();
-	LEAVE();
 	return 0;
 }
 
@@ -596,7 +568,6 @@ static int mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
 					    struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	ENTER();
 
 	priv->tx_rate = resp->params.tx_rate.tx_rate;
 	priv->tx_htinfo = resp->params.tx_rate.ht_info;
@@ -606,7 +577,6 @@ static int mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
 						   priv->tx_htinfo);
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -621,7 +591,6 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 					     struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	ENTER();
 
 	adapter->dbg.num_cmd_deauth++;
 	if (!memcmp(resp->params.deauth.mac_addr,
@@ -629,7 +598,6 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 		    sizeof(resp->params.deauth.mac_addr))) {
 		mwifiex_reset_connect_state(priv);
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -641,10 +609,7 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 static int mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *resp)
 {
-	ENTER();
-
 	mwifiex_reset_connect_state(priv);
-	LEAVE();
 	return 0;
 }
 
@@ -660,8 +625,6 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_key_material *key =
 		&resp->params.key_material;
 
-	ENTER();
-
 	if (le16_to_cpu(key->action) == HostCmd_ACT_GEN_SET) {
 		if ((le16_to_cpu(key->key_param_set.key_info) &
 		     KEY_INFO_TKIP_MCAST)) {
@@ -680,7 +643,6 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 	HEXDUMP("CMD_RESP (Key_Material)", priv->aes_key.key_param_set.key,
 		priv->aes_key.key_param_set.key_len);
 
-	LEAVE();
 	return 0;
 }
 
@@ -708,7 +670,6 @@ static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 	int  tlv_buf_len = 0;
 	u16 tlv;
 
-	ENTER();
 	tlv_buf_len = le16_to_cpu(resp->size) -
 			(sizeof(struct host_cmd_ds_802_11_supplicant_pmk) +
 			S_DS_GEN-1);
@@ -822,7 +783,6 @@ static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -848,8 +808,6 @@ static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 	u8 *tlv;
 	int len;
 
-	ENTER();
-
 	len = le16_to_cpu(resp->size) - S_DS_GEN - sizeof(u16);
 	tlv = psup_profile->tlv_buf;
 	if (data_buf) {
@@ -886,7 +844,6 @@ static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 		}
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -903,8 +860,6 @@ int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	u16 action = le16_to_cpu(domain_info->action);
 	u8 no_of_triplet = 0;
 
-	ENTER();
-
 	/* Dump domain info response data */
 	HEXDUMP("11D: DOMAIN Info Rsp Data", (u8 *) resp, resp->size);
 
@@ -921,7 +876,6 @@ int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 		PRINTM(MWARN, "11D: Invalid number of triplets %d "
 				"returned!!\n",
 				no_of_triplet);
-		LEAVE();
 		return -1;
 	}
 
@@ -937,7 +891,6 @@ int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 		break;
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -955,7 +908,6 @@ static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 		&resp->params.rf_channel;
 	u16 new_channel = le16_to_cpu(rf_channel->current_channel);
 
-	ENTER();
 	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
 		PRINTM(MCMND, "Channel Switch: %d to %d\n",
 		       priv->curr_bss_params.bss_descriptor.channel,
@@ -966,7 +918,6 @@ static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 	if (data_buf)
 		*((u16 *)data_buf) = new_channel;
 
-	LEAVE();
 	return 0;
 }
 
@@ -983,8 +934,6 @@ static int mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_rf_antenna *antenna = &resp->params.antenna;
 	u32 *ant = (u32 *)data_buf;
 
-	ENTER();
-
 	PRINTM(MINFO, "RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
 		      le16_to_cpu(antenna->action),
 		      le16_to_cpu(antenna->antenna_mode));
@@ -992,7 +941,6 @@ static int mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
 	if (data_buf)
 		*ant = (u32)le16_to_cpu(antenna->antenna_mode);
 
-	LEAVE();
 	return 0;
 }
 
@@ -1008,7 +956,7 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
 	struct host_cmd_ds_version_ext *version_ext = NULL;
-	ENTER();
+
 	if (data_buf) {
 		version_ext = (struct host_cmd_ds_version_ext *)data_buf;
 		version_ext->version_str_sel = ver_ext->version_str_sel;
@@ -1016,7 +964,6 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 		       sizeof(char) * 128);
 		memcpy(priv->version_str, ver_ext->version_str, 128);
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -1033,8 +980,6 @@ static int mwifiex_ret_reg_access(u16 type,
 	struct mwifiex_ds_reg_rw *reg_rw = NULL;
 	struct mwifiex_ds_read_eeprom *eeprom = NULL;
 
-	ENTER();
-
 	if (data_buf) {
 		reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
 		eeprom = (struct mwifiex_ds_read_eeprom *) data_buf;
@@ -1109,7 +1054,6 @@ static int mwifiex_ret_reg_access(u16 type,
 					eeprom->byte_count = cpu_to_le16(0);
 					PRINTM(MINFO, "EEPROM read return "
 							"length is too big\n");
-					LEAVE();
 					return -1;
 				}
 				eeprom->offset = cmd_eeprom->offset;
@@ -1125,11 +1069,9 @@ static int mwifiex_ret_reg_access(u16 type,
 				break;
 			}
 		default:
-			LEAVE();
 			return -1;
 		}
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -1147,12 +1089,8 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 		&(resp->params.ibss_coalescing);
 	u8 zero_mac[MWIFIEX_MAC_ADDR_LENGTH] = { 0, 0, 0, 0, 0, 0 };
 
-	ENTER();
-
-	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET) {
-		LEAVE();
+	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
 		return 0;
-	}
 
 	PRINTM(MINFO, "New BSSID %02x:%02x:%02x:%02x:%02x:%02x\n",
 	       ibss_coal_resp->bssid[0], ibss_coal_resp->bssid[1],
@@ -1162,7 +1100,6 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 	/* If rsp has NULL BSSID, Just return..... No Action */
 	if (!memcmp(ibss_coal_resp->bssid, zero_mac, MWIFIEX_MAC_ADDR_LENGTH)) {
 		PRINTM(MMSG, "New BSSID is NULL\n");
-		LEAVE();
 		return 0;
 	}
 
@@ -1187,7 +1124,6 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 		priv->adhoc_state = ADHOC_COALESCED;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -1208,12 +1144,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 		(struct mwifiex_wait_queue *) wq_buf;
 	void *data_buf = adapter->curr_cmd->data_buf;
 
-	ENTER();
-
 	/* If the command is not successful, cleanup and return failure */
 	if (resp->result != HostCmd_RESULT_OK) {
 		mwifiex_process_cmdresp_error(priv, resp, wait_queue);
-		LEAVE();
 		return -1;
 	}
 	/* Command successful, handle response */
@@ -1357,6 +1290,5 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 		break;
 	}
 
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index a6e99d7..7238154 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -46,12 +46,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
-
-	if (!priv->media_connected) {
-		LEAVE();
+	if (!priv->media_connected)
 		return;
-	}
 
 	PRINTM(MINFO, "Handles disconnect event.\n");
 
@@ -119,10 +115,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	adapter->tx_lock_flag = false;
 	adapter->pps_uapsd_mode = false;
 
-	if (adapter->num_cmd_timeout && adapter->curr_cmd) {
-		LEAVE();
+	if (adapter->num_cmd_timeout && adapter->curr_cmd)
 		return;
-	}
 	priv->media_connected = false;
 	if (!priv->disconnect) {
 		priv->disconnect = 1;
@@ -141,7 +135,6 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	/* Reset wireless stats signal info */
 	priv->w_stats.qual.level = 0;
 	priv->w_stats.qual.noise = 0;
-	LEAVE();
 }
 
 /*
@@ -201,8 +194,6 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	int ret = 0;
 	u32 eventcause = adapter->event_cause;
 
-	ENTER();
-
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
 		PRINTM(MERROR, "Invalid EVENT: DUMMY_HOST_WAKEUP_SIGNAL,"
@@ -413,6 +404,5 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	}
 
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0a851fb..e9d80a2 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -63,7 +63,6 @@ mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
 {
 	struct mwifiex_wait_queue *wait = NULL;
 
-	ENTER();
 	wait = (struct mwifiex_wait_queue *)
 		kzalloc(sizeof(struct mwifiex_wait_queue), GFP_ATOMIC);
 	if (!wait) {
@@ -101,7 +100,6 @@ mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
 	}
 
 done:
-	LEAVE();
 	return wait;
 }
 
@@ -119,8 +117,6 @@ mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
 {
 	bool cancel_flag = false;
 
-	ENTER();
-
 	switch (wait_option) {
 	case MWIFIEX_NO_WAIT:
 		break;
@@ -149,7 +145,6 @@ mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
 			wait, wait_option);
 	}
 
-	LEAVE();
 	return;
 }
 
@@ -161,8 +156,6 @@ int mwifiex_request_ioctl(struct mwifiex_private *priv,
 			  struct mwifiex_wait_queue *wait,
 			  int status, u8 wait_option)
 {
-	ENTER();
-
 	switch (status) {
 	case -EINPROGRESS:
 		PRINTM(MCMND, "IOCTL pending: wait=%p, wait_option=%d\n",
@@ -183,7 +176,6 @@ int mwifiex_request_ioctl(struct mwifiex_private *priv,
 	default:
 		break;
 	}
-	LEAVE();
 	return status;
 }
 EXPORT_SYMBOL_GPL(mwifiex_request_ioctl);
@@ -200,8 +192,6 @@ int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 	int status = 0;
 	u8 wait_option = MWIFIEX_CMD_WAIT;
 
-	ENTER();
-
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
@@ -223,7 +213,6 @@ int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 	}
 done:
 	kfree(wait);
-	LEAVE();
 	return status;
 }
 
@@ -241,7 +230,6 @@ mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	struct mwifiex_multicast_list mcast_list;
 	u8 wait_option = MWIFIEX_NO_WAIT;
 	int status = 0;
-	ENTER();
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
@@ -267,7 +255,6 @@ mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	if (wait && status != -EINPROGRESS)
 		kfree(wait);
 done:
-	LEAVE();
 	return;
 }
 
@@ -282,8 +269,6 @@ int mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
 	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
 
-	ENTER();
-
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
@@ -297,7 +282,6 @@ int mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
 
 done:
 	kfree(wait);
-	LEAVE();
 	return status;
 }
 EXPORT_SYMBOL_GPL(mwifiex_disconnect);
@@ -315,8 +299,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 	struct mwifiex_ssid_bssid tmp_ssid_bssid;
 	int status = 0;
 
-	ENTER();
-
 	/* Stop the O.S. TX queue if needed */
 	if (!netif_queue_stopped(priv->netdev))
 		netif_stop_queue(priv->netdev);
@@ -336,7 +318,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 done:
 	kfree(wait);
-	LEAVE();
 	return status;
 }
 
@@ -353,8 +334,6 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
-
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
@@ -379,7 +358,6 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 	}
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -396,8 +374,6 @@ int mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
 	int ret = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 
-	ENTER();
-
 	if (!hscfg) {
 		ret = -ENOMEM;
 		goto done;
@@ -416,7 +392,6 @@ int mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
 done:
 	if (wait && (ret != -EINPROGRESS))
 		kfree(wait);
-	LEAVE();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mwifiex_set_get_hs_params);
@@ -432,15 +407,12 @@ int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
 	int ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
 
-	ENTER();
-
 	/* Cancel Host Sleep */
 	hscfg.conditions = HOST_SLEEP_CFG_CANCEL;
 	hscfg.is_invoke_hostcmd = true;
 	ret = mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
 					wait_option, &hscfg);
 
-	LEAVE();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mwifiex_cancel_hs);
@@ -456,8 +428,6 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	struct mwifiex_ds_hs_cfg hscfg;
 	int hs_actived = false;
 
-	ENTER();
-
 	if (adapter->hs_activated) {
 		PRINTM(MCMND, "HS Already actived\n");
 		hs_actived = true;
@@ -483,7 +453,6 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	hs_actived = true;
 
 done:
-	LEAVE();
 	return hs_actived;
 }
 EXPORT_SYMBOL_GPL(mwifiex_enable_hs);
@@ -502,8 +471,6 @@ int mwifiex_get_info_signal(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (!wait) {
 		PRINTM(MERROR, "WAIT information is not present\n");
 		ret = -1;
@@ -525,7 +492,6 @@ int mwifiex_get_info_signal(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -541,8 +507,6 @@ int mwifiex_get_info_stats(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (!wait) {
 		PRINTM(MERROR, "MWIFIEX IOCTL information is not present\n");
 		ret = -1;
@@ -557,7 +521,6 @@ int mwifiex_get_info_stats(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -575,8 +538,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 	struct mwifiex_bssdescriptor *bss_desc;
 	s32 tbl_idx = 0;
 
-	ENTER();
-
 	if (!info)
 		return -1;
 
@@ -635,7 +596,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 	info->is_hs_configured = adapter->is_hs_configured;
 	info->is_deep_sleep = adapter->is_deep_sleep;
 
-	LEAVE();
 	return ret;
 }
 
@@ -651,15 +611,12 @@ int mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_VERSION_EXT,
 				  HostCmd_ACT_GEN_GET, 0, wait, ver_ext);
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -680,8 +637,6 @@ int mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (!value) {
 		ret = -1;
 		goto done;
@@ -695,7 +650,6 @@ int mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -720,26 +674,20 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 	u8 adhoc_band = 0;
 	u32 adhoc_channel = 0;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_SET) {
 		infra_band = (u8) radio_cfg->config_bands;
 		adhoc_band = (u8) radio_cfg->adhoc_start_band;
 		adhoc_channel = radio_cfg->adhoc_channel;
 
 		/* SET Infra band */
-		if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands) {
-			LEAVE();
+		if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands)
 			return -1;
-		}
 
 		adapter->config_bands = infra_band;
 
 		/* SET Ad-hoc Band */
-		if ((adhoc_band | adapter->fw_bands) & ~adapter->fw_bands) {
-			LEAVE();
+		if ((adhoc_band | adapter->fw_bands) & ~adapter->fw_bands)
 			return -1;
-		}
 
 		if (adhoc_band)
 			adapter->adhoc_start_band = adhoc_band;
@@ -767,10 +715,8 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 				   adhoc_channel combination is invalid */
 			if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
 			    (priv, adapter->adhoc_start_band,
-			     (u16) adhoc_channel)) {
-				LEAVE();
+			     (u16) adhoc_channel))
 				return -1;
-			}
 			priv->adhoc_channel = (u8) adhoc_channel;
 		}
 		if ((adhoc_band & BAND_GN)
@@ -791,7 +737,6 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 		radio_cfg->sec_chan_offset = adapter->chan_offset;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -810,8 +755,6 @@ int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 antenna_mode;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_SET) {
 		/* User input validation */
 		if ((*antenna < RF_ANTENNA_1 || *antenna >=
@@ -836,7 +779,6 @@ int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -851,7 +793,6 @@ int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
 				  u8 action, u8 *mac)
 {
 	int ret = 0;
-	ENTER();
 
 	if ((action == HostCmd_ACT_GEN_GET) && mac) {
 		memcpy(mac, priv->curr_addr,
@@ -866,7 +807,6 @@ int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -887,8 +827,6 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 	int ret = 0;
 	u16 old_pkt_filter;
 
-	ENTER();
-
 	old_pkt_filter = priv->curr_pkt_filter;
 	if (action == HostCmd_ACT_GEN_GET) {
 		ret = -1;
@@ -941,7 +879,6 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 	}
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -958,8 +895,6 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 	struct mwifiex_chan_freq_power *cfp = NULL;
 	int ret = 0;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
 							   priv->
@@ -973,13 +908,10 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 			chan->freq = cfp->freq;
 		} else
 			ret = -1;
-		LEAVE();
 		return ret;
 	}
-	if (!chan->channel && !chan->freq) {
-		LEAVE();
+	if (!chan->channel && !chan->freq)
 		return -1;
-	}
 	if (adapter->adhoc_start_band & BAND_AN)
 		adapter->adhoc_start_band = BAND_G | BAND_B | BAND_GN;
 	else if (adapter->adhoc_start_band & BAND_A)
@@ -1024,15 +956,12 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 	}
 	if (!cfp || !cfp->channel) {
 		PRINTM(MERROR, "Invalid channel/freq\n");
-		LEAVE();
 		return -1;
-
 	}
 	priv->adhoc_channel = (u8) cfp->channel;
 	chan->channel = cfp->channel;
 	chan->freq = cfp->freq;
 
-	LEAVE();
 	return ret;
 }
 
@@ -1051,8 +980,6 @@ int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (!mode) {
 		ret = -1;
 		goto exit;
@@ -1080,7 +1007,6 @@ int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
 			ret = -EINPROGRESS;
 	}
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -1099,8 +1025,6 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	s32 i = -1;
 
-	ENTER();
-
 	priv->scan_block = false;
 	if (!ssid_bssid) {
 		ret = -1;
@@ -1191,7 +1115,6 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 start_ssid_done:
-	LEAVE();
 	return ret;
 }
 
@@ -1202,9 +1125,6 @@ int mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
 			   struct mwifiex_wait_queue *wait,
 			   u8 *mac)
 {
-	ENTER();
-
-	LEAVE();
 	return mwifiex_deauthenticate(priv, wait, mac);
 }
 
@@ -1220,8 +1140,6 @@ int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		if (!priv->media_connected) {
 			*channel = priv->adhoc_channel;
@@ -1238,7 +1156,6 @@ int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -1259,8 +1176,6 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 	u8 mac[MWIFIEX_MAC_ADDR_LENGTH];
 	int i = 0;
 
-	ENTER();
-
 	if (memcmp(ssid_bssid->bssid, zero_mac, sizeof(zero_mac))) {
 		i = mwifiex_find_bssid_in_list(priv,
 					       (u8 *) ssid_bssid->bssid,
@@ -1271,7 +1186,6 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 					"%02x:%02x:%02x:%02x:%02x:%02x\n",
 					mac[0], mac[1], mac[2],
 					mac[3], mac[4], mac[5]);
-			LEAVE();
 			return -1;
 		}
 		bss_desc = &adapter->scan_table[i];
@@ -1284,7 +1198,6 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 		if (i < 0) {
 			PRINTM(MERROR, "Can not find ssid %s\n",
 					ssid_bssid->ssid.ssid);
-			LEAVE();
 			return -1;
 		}
 		bss_desc = &adapter->scan_table[i];
@@ -1294,7 +1207,6 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 		ret = mwifiex_find_best_network(priv, ssid_bssid);
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -1326,8 +1238,6 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	struct mwifiex_ssid_bssid ssid_bssid;
 	u16 curr_chan = 0;
 
-	ENTER();
-
 	memset(&bss_info, 0, sizeof(bss_info));
 
 	/* Get BSS information */
@@ -1396,7 +1306,6 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -1412,14 +1321,11 @@ mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
 	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
 	int mode = -1;
-	ENTER();
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -1;
-	}
 
 	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_GET, &mode);
 
@@ -1427,7 +1333,6 @@ mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
 
 	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
-	LEAVE();
 	return mode;
 }
 
@@ -1446,8 +1351,6 @@ static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
 
-	ENTER();
-
 	rate_cfg->is_rate_auto = priv->is_data_rate_auto;
 	if (!priv->media_connected) {
 		switch (adapter->config_bands) {
@@ -1491,10 +1394,8 @@ static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 					  HostCmd_ACT_GEN_GET, 0, wait, NULL);
 		if (!ret)
 			ret = -EINPROGRESS;
-
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -1518,8 +1419,6 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
-
 	if (rate_cfg->is_rate_auto) {
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
 		/* Support all HR/DSSS rates */
@@ -1572,7 +1471,6 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -1588,15 +1486,12 @@ static int mwifiex_rate_ioctl_get_rate_index(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
 				  HostCmd_ACT_GEN_GET, 0, wait, rate_cfg);
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -1615,8 +1510,6 @@ static int mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
 	int ret = 0;
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
 
-	ENTER();
-
 	rate_index = rate_cfg->rate;
 	if (rate_cfg->is_rate_auto) {
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
@@ -1664,7 +1557,6 @@ static int mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -1680,12 +1572,8 @@ int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
 {
 	int status = 0;
 
-	ENTER();
-
-	if (!rate_cfg) {
-		LEAVE();
+	if (!rate_cfg)
 		return -1;
-	}
 	if (rate_cfg->rate_type == MWIFIEX_RATE_VALUE) {
 		if (rate_cfg->action == HostCmd_ACT_GEN_GET)
 			status = mwifiex_rate_ioctl_get_rate_value(
@@ -1702,7 +1590,6 @@ int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
 					priv, wait, rate_cfg);
 	}
 
-	LEAVE();
 	return status;
 }
 
@@ -1729,8 +1616,6 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 	u8 *buf = NULL;
 	u16 dbm = 0;
 
-	ENTER();
-
 	if (!power_cfg->is_power_auto) {
 		dbm = (u16) power_cfg->power_level;
 		if ((dbm < priv->min_tx_power_level) ||
@@ -1808,7 +1693,6 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 	kfree(buf);
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -1827,8 +1711,6 @@ int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 sub_cmd;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_SET) {
 		if (*ps_mode)
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
@@ -1850,7 +1732,6 @@ int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -1868,8 +1749,6 @@ int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 	int status = 0;
 	u32 prev_cond = 0;
 
-	ENTER();
-
 	switch (action) {
 	case HostCmd_ACT_GEN_SET:
 		if (adapter->pps_uapsd_mode) {
@@ -1933,7 +1812,6 @@ int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 		break;
 	}
 
-	LEAVE();
 	return status;
 }
 
@@ -1952,14 +1830,11 @@ int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u32 mode;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_GET) {
 		if (adapter->is_deep_sleep)
 			auto_deep_sleep->auto_ds = DEEP_SLEEP_ON;
 		else
 			auto_deep_sleep->auto_ds = DEEP_SLEEP_OFF;
-		LEAVE();
 		return ret;
 	}
 
@@ -1967,13 +1842,11 @@ int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
 	    DEEP_SLEEP_ON) {
 		PRINTM(MMSG, "Station already in enhanced deep"
 				" sleep mode\n");
-		LEAVE();
 		return -1;
 	} else if (!adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
 		   DEEP_SLEEP_OFF) {
 		PRINTM(MMSG, "Station already not in enhanced "
 				"deep sleep mode\n");
-		LEAVE();
 		return -1;
 	}
 
@@ -1995,7 +1868,6 @@ int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -2011,15 +1883,12 @@ int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SLEEP_PERIOD,
 				  action, 0, wait, sleep_period);
 
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -2033,12 +1902,9 @@ int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
 static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 				     u8 *ie_data_ptr, u16 ie_len)
 {
-	ENTER();
-
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wpa_ie)) {
 			PRINTM(MERROR, "failed to copy WPA IE, too big\n");
-			LEAVE();
 			return -1;
 		}
 		memcpy(priv->wpa_ie, ie_data_ptr, ie_len);
@@ -2063,7 +1929,6 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 		priv->sec_info.wpa2_enabled = false;
 	}
 
-	LEAVE();
 	return 0;
 }
 
@@ -2077,11 +1942,9 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
 			       u8 *ie_data_ptr, u16 ie_len)
 {
-	ENTER();
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wapi_ie)) {
 			PRINTM(MINFO, "failed to copy WAPI IE, too big\n");
-			LEAVE();
 			return -1;
 		}
 		memcpy(priv->wapi_ie, ie_data_ptr, ie_len);
@@ -2099,7 +1962,6 @@ static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
 		       priv->wapi_ie_len, priv->wapi_ie[0]);
 		priv->sec_info.wapi_enabled = false;
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -2115,7 +1977,6 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 {
 	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
-	ENTER();
 
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
 				  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
@@ -2123,7 +1984,6 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -2133,14 +1993,12 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 int mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
 {
 	int ret = 0;
-	ENTER();
 
 	priv->sec_info.authentication_mode = auth_mode;
 	if (priv->sec_info.authentication_mode ==
 			MWIFIEX_AUTH_MODE_NETWORKEAP)
 		ret = mwifiex_set_wpa_ie_helper(priv, NULL, 0);
 
-	LEAVE();
 	return ret;
 }
 
@@ -2159,8 +2017,6 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 	struct mwifiex_wep_key *wep_key = NULL;
 	int index;
 
-	ENTER();
-
 	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
 		priv->wep_key_curr_index = 0;
 	wep_key = &priv->wep_key[priv->wep_key_curr_index];
@@ -2221,7 +2077,6 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -2244,8 +2099,6 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 	u8 remove_key = false;
 	struct host_cmd_ds_802_11_key_material *ibss_key;
 
-	ENTER();
-
 	/* Current driver only supports key length of up to 32 bytes */
 	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
 		PRINTM(MERROR, " Error in key length\n");
@@ -2307,7 +2160,6 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -2323,7 +2175,6 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	int index;
-	ENTER();
 
 	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
 		priv->wep_key_curr_index = 0;
@@ -2386,7 +2237,6 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 		}
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -2404,7 +2254,6 @@ int mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
 	int status = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
 	if (action == HostCmd_ACT_GEN_SET) {
 		if (encrypt_key->is_wapi_key)
 			status = mwifiex_sec_ioctl_set_wapi_key(adapter,
@@ -2418,7 +2267,6 @@ int mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
 	} else {
 		status = mwifiex_sec_ioctl_get_key(adapter, wait, encrypt_key);
 	}
-	LEAVE();
 	return status;
 }
 
@@ -2439,8 +2287,6 @@ int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
 	u16 cmd_action = 0;
 	int i = 0;
 
-	ENTER();
-
 	if (action == HostCmd_ACT_GEN_SET) {
 		if (passphrase->psk_type == MWIFIEX_PSK_CLEAR)
 			cmd_action = HostCmd_ACT_GEN_REMOVE;
@@ -2477,7 +2323,6 @@ int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
 
@@ -2493,8 +2338,6 @@ int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (priv->media_connected != true) {
 		ret = -1;
 		goto exit;
@@ -2508,7 +2351,6 @@ int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -2530,13 +2372,9 @@ mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_auto_ds auto_deep_sleep;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -ENOMEM;
-	}
 
 	if (bdeep_sleep) {
 		PRINTM(MCMND, "Deep Sleep: sleep\n");
@@ -2558,7 +2396,6 @@ mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 done:
 	kfree(wait);
 
-	LEAVE();
 	return ret;
 }
 
@@ -2576,13 +2413,9 @@ mwifiex_drv_get_deep_sleep(struct mwifiex_private *priv, u32 *deep_sleep)
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_auto_ds auto_deep_sleep;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -ENOMEM;
-	}
 
 	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
 					     HostCmd_ACT_GEN_GET);
@@ -2595,8 +2428,6 @@ mwifiex_drv_get_deep_sleep(struct mwifiex_private *priv, u32 *deep_sleep)
 
 done:
 	kfree(wait);
-
-	LEAVE();
 	return ret;
 }
 
@@ -2613,8 +2444,6 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 	int ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
 
-	ENTER();
-
 	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
 
 	/* HS config is blocked if HS is already activated */
@@ -2635,7 +2464,6 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 		goto done;
 	}
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -2654,8 +2482,6 @@ mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv, int *amsdu_enable,
 	int status = 0;
 	int ret = 0;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -2675,8 +2501,6 @@ mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv, int *amsdu_enable,
 
 done:
 	kfree(wait);
-	LEAVE();
-
 	return ret;
 }
 
@@ -2694,8 +2518,6 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 	int status = 0;
 	int ret = 0;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -2717,7 +2539,6 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 		       "Successfully enabled amsdu aggregation feature\n");
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -2732,8 +2553,6 @@ mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
 {
 	int status = 0;
 
-	ENTER();
-
 	if ((max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_2K) ||
 	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_4K) ||
 	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_8K)) {
@@ -2742,7 +2561,6 @@ mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
 		status = -1;
 	}
 
-	LEAVE();
 	return status;
 }
 
@@ -2755,11 +2573,7 @@ mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
 int
 mwifiex_get_drv_txbuf_cfg(struct mwifiex_private *priv, int *max_tx_buf_size)
 {
-	ENTER();
-
 	*max_tx_buf_size = (u32) priv->adapter->max_tx_buf_size;
-
-	LEAVE();
 	return 0;
 }
 
@@ -2776,8 +2590,6 @@ mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 	int status = 0;
 	int ret = 0, i, j;
 
-	ENTER();
-
 	status = mwifiex_11n_ioctl_aggr_prio_tbl(priv, &aggr_prio_tbl,
 						 HostCmd_ACT_GEN_GET);
 
@@ -2793,7 +2605,6 @@ mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -2810,8 +2621,6 @@ mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data, int length)
 	int status = 0;
 	int ret = 0, i, j;
 
-	ENTER();
-
 	for (i = 0, j = 0; i < (length); i = i + 2, ++j) {
 		aggr_prio_tbl.ampdu[j] = data[i];
 		aggr_prio_tbl.amsdu[j] = data[i + 1];
@@ -2822,7 +2631,6 @@ mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data, int length)
 	if (status)
 		ret = -EFAULT;
 
-	LEAVE();
 	return ret;
 }
 
@@ -2839,7 +2647,6 @@ mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd)
 	int status = 0;
 	u32 sleep_period;
 	struct mwifiex_wait_queue *wait = NULL;
-	ENTER();
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
@@ -2861,7 +2668,6 @@ mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd)
 	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -2878,7 +2684,6 @@ mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd)
 	int status = 0;
 	u32 sleep_period;
 	struct mwifiex_wait_queue *wait = NULL;
-	ENTER();
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
@@ -2895,7 +2700,6 @@ mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd)
 		*sleeppd = sleep_period;
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -2912,8 +2716,6 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 	} ver;
 	char fw_ver[32];
 
-	ENTER();
-
 	ver.l = adapter->fw_release_number;
 	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
 
@@ -2921,7 +2723,6 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 
 	PRINTM(MINFO, "MWIFIEX VERSION: %s\n", version);
 
-	LEAVE();
 	return 0;
 }
 
@@ -2939,8 +2740,6 @@ mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
 	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
 	int ret = 0;
-	ENTER();
-
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
@@ -2960,7 +2759,6 @@ mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -2976,7 +2774,6 @@ mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 	struct mwifiex_ds_misc_gen_ie gen_ie;
 	int status = 0;
 	int ret = 0;
-	ENTER();
 
 	if (ie_len > IW_CUSTOM_MAX) {
 		ret = -EFAULT;
@@ -2993,7 +2790,6 @@ mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -3010,14 +2806,10 @@ int mwifiex_get_scan_table(struct mwifiex_private *priv, u8 wait_option,
 	struct mwifiex_scan_resp scan;
 	int status = 0;
 
-	ENTER();
-
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -1;
-	}
 
 	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_GET,
 				       NULL, &scan);
@@ -3032,7 +2824,6 @@ int mwifiex_get_scan_table(struct mwifiex_private *priv, u8 wait_option,
 
 	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
-	LEAVE();
 	return status;
 }
 
@@ -3048,14 +2839,11 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
 	struct mwifiex_ds_get_signal info;
 	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
-	ENTER();
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -1;
-	}
 
 	info.selector = ALL_RSSI_INFO_MASK;
 
@@ -3074,7 +2862,6 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
 
 	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
-	LEAVE();
 	return status;
 }
 
@@ -3087,11 +2874,7 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
 int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
 			     u8 wait_option, u32 encrypt_mode)
 {
-	ENTER();
-
 	priv->sec_info.encryption_mode = encrypt_mode;
-
-	LEAVE();
 	return 0;
 }
 
@@ -3105,15 +2888,12 @@ mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
 {
 	int ret = 0;
 
-	ENTER();
-
 	if (mwifiex_set_encrypt_mode(priv, MWIFIEX_IOCTL_WAIT, encrypt_mode))
 		ret = -EFAULT;
 
 	if (mwifiex_set_auth_mode(priv, auth_mode))
 		ret = -EFAULT;
 
-	LEAVE();
 	return ret;
 }
 
@@ -3138,8 +2918,6 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 	int status = 0;
 	int ret = 0;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -3181,7 +2959,6 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 		ret = -EFAULT;
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3199,8 +2976,6 @@ mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
 	struct mwifiex_wait_queue *wait = NULL;
 	u32 ps_mode;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -3215,7 +2990,6 @@ mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3236,10 +3010,8 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -ENOMEM;
-	}
 
 	/* get fw version */
 	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
@@ -3272,7 +3044,6 @@ mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna)
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -3291,7 +3062,6 @@ mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna)
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3310,7 +3080,6 @@ mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna)
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -3330,7 +3099,6 @@ mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna)
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3350,8 +3118,6 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 	struct mwifiex_ds_get_stats get_log;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
-
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
@@ -3374,7 +3140,6 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 	}
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3393,8 +3158,6 @@ mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_reg_rw reg_rw;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -3429,8 +3192,6 @@ mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_reg_rw reg_rw;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
 		ret = -ENOMEM;
@@ -3501,7 +3262,6 @@ mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data)
 	struct mwifiex_ds_11n_tx_cfg tx_cfg;
 	int status = 0;
 	int ret = 0;
-	ENTER();
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
@@ -3533,7 +3293,6 @@ mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data)
 	struct mwifiex_ds_11n_tx_cfg tx_cfg;
 	int status = 0;
 	int ret = 0;
-	ENTER();
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
 	if (!wait) {
@@ -3563,11 +3322,7 @@ done:
 void
 mwifiex_set_atim_window(struct mwifiex_private *priv, int atim)
 {
-	ENTER();
-
 	priv->atim_window = (u16) atim;
-
-	LEAVE();
 }
 
 /*
@@ -3579,13 +3334,9 @@ mwifiex_set_atim_window(struct mwifiex_private *priv, int atim)
 void
 mwifiex_get_atim_window(struct mwifiex_private *priv, int *atim)
 {
-	ENTER();
-
 	*atim = priv->atim_window;
 	if (priv->media_connected)
 		*atim = priv->curr_bss_params.bss_descriptor.atim_window;
-
-	LEAVE();
 }
 
 /*
@@ -3603,8 +3354,6 @@ mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
-
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
@@ -3635,7 +3384,6 @@ mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
 	}
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3654,12 +3402,9 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	ENTER();
-
 	/* TX rate configuration can be set only if media connected */
 	if (!priv->media_connected) {
 		PRINTM(MINFO, "Can not set txratecfg in disconnected state\n");
-		LEAVE();
 		return -1;
 	}
 
@@ -3696,7 +3441,6 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 		*tx_rate_idx = rate_cfg.rate;
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3706,8 +3450,6 @@ done:
 int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
 					  struct mwifiex_ds_passphrase *psec_pp)
 {
-	ENTER();
-
 	if ((psec_pp->psk_type == MWIFIEX_PSK_PASSPHRASE &&
 			psec_pp->psk.passphrase.passphrase_len > 0) ||
 			(psec_pp->psk_type == MWIFIEX_PSK_PMK))
@@ -3717,7 +3459,6 @@ int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
 
 	PRINTM(MINFO, "Set ewpa mode = %d\n", priv->sec_info.ewpa_enabled);
 
-	LEAVE();
 	return 0;
 }
 
@@ -3736,13 +3477,9 @@ mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_addba_param addba_param;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -ENOMEM;
-	}
 
 	addba_param.timeout = data[0];
 	addba_param.tx_win_size = data[1];
@@ -3759,7 +3496,6 @@ mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
 	}
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3779,13 +3515,9 @@ mwifiex_get_addba_param(struct mwifiex_private *priv, int *addba_timeout,
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_addba_param addba_param;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -ENOMEM;
-	}
 
 	status = mwifiex_11n_ioctl_addba_param(priv->adapter, wait,
 					       &addba_param,
@@ -3804,7 +3536,6 @@ mwifiex_get_addba_param(struct mwifiex_private *priv, int *addba_timeout,
 	       addba_timeout, tx_win_sz, rx_win_sz);
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3821,13 +3552,9 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 	int status = 0;
 	struct mwifiex_wait_queue  *wait = NULL;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -ENOMEM;
-	}
 
 	status = mwifiex_sec_ioctl_passphrase(priv, wait, ds_passphrase,
 					      action);
@@ -3839,7 +3566,6 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3857,13 +3583,9 @@ int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 	struct mwifiex_ds_esupp_mode esuppmode;
 	struct mwifiex_wait_queue *wait = NULL;
 
-	ENTER();
-
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		LEAVE();
+	if (!wait)
 		return -ENOMEM;
-	}
 	status = mwifiex_sec_ioctl_esupp_mode(priv, wait, &esuppmode);
 
 	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
@@ -3877,7 +3599,6 @@ int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 
 done:
 	kfree(wait);
-	LEAVE();
 	return ret;
 }
 
@@ -3894,8 +3615,6 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 	const u8 wpa_oui[] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wps_oui[] = { 0x00, 0x50, 0xf2, 0x04 };
 
-	ENTER();
-
 	/* If the passed length is zero, reset the buffer */
 	if (!ie_len) {
 		priv->gen_ie_buf_len = 0;
@@ -3957,7 +3676,6 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 
 	/* Return 0, or -1 for error
 	   case */
-	LEAVE();
 	return ret;
 }
 
@@ -3982,8 +3700,6 @@ int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 	int ret = 0;
 	u16 cmd_no;
 
-	ENTER();
-
 	switch (le32_to_cpu(reg_rw->type)) {
 	case MWIFIEX_REG_MAC:
 		cmd_no = HostCmd_CMD_MAC_REG_ACCESS;
@@ -4012,7 +3728,6 @@ int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -4029,8 +3744,6 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
-
 	switch (gen_ie->type) {
 	case MWIFIEX_IE_TYPE_GEN_IE:
 		if (action == HostCmd_ACT_GEN_GET) {
@@ -4060,7 +3773,6 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		PRINTM(MERROR, "Invalid IE type\n");
 		ret = -1;
 	}
-	LEAVE();
 	return ret;
 }
 
@@ -4076,8 +3788,6 @@ int mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	ENTER();
-
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
 				  HostCmd_ACT_GEN_GET, 0, wait, rd_eeprom);
@@ -4085,6 +3795,5 @@ int mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index b84ac6b..cf001d7 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -52,7 +52,6 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 	u8 rfc1042_eth_hdr[MWIFIEX_MAC_ADDR_LENGTH] = { 0xaa, 0xaa, 0x03,
 							0x00, 0x00, 0x00 };
 
-	ENTER();
 	local_rx_pd = (struct rxpd *) (skb->data);
 
 	rx_pkt_hdr =
@@ -110,8 +109,6 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 		       "RX Error: mwifiex_recv_packet" " returns failure\n");
 	}
 
-	LEAVE();
-
 	return ret;
 }
 
@@ -138,8 +135,6 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	u16 rx_pkt_type = 0;
 	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 
-	ENTER();
-
 	local_rx_pd = (struct rxpd *) (skb->data);
 	rx_pkt_type = local_rx_pd->rx_pkt_type;
 
@@ -197,7 +192,5 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		dev_kfree_skb_any(skb);
 	}
 done:
-
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 0469da1..273ae8b 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -122,8 +122,6 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	int ret = 0;
 	struct mwifiex_txinfo *tx_info = NULL;
 
-	ENTER();
-
 	if (adapter->surprise_removed) {
 		ret = -1;
 		goto done;
@@ -185,7 +183,6 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -199,12 +196,8 @@ mwifiex_check_last_packet_indication(struct mwifiex_private *priv)
 	u8 ret = false;
 	u8 prop_ps = true;
 
-	ENTER();
-
-	if (!adapter->sleep_period.period) {
-		LEAVE();
+	if (!adapter->sleep_period.period)
 		return ret;
-	}
 	if (mwifiex_wmm_lists_empty(adapter)) {
 		if ((priv->curr_bss_params.wmm_uapsd_enabled &&
 		     priv->wmm_qosinfo) || prop_ps)
@@ -219,6 +212,5 @@ mwifiex_check_last_packet_indication(struct mwifiex_private *priv)
 		ret = false;
 		adapter->delay_null_pkt = true;
 	}
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index ed37437..4500142 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -43,8 +43,6 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	struct rxpd *local_rx_pd;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 
-	ENTER();
-
 	local_rx_pd = (struct rxpd *) (skb->data);
 	/* Get the BSS number from rxpd, get corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter, local_rx_pd->bss_num &
@@ -56,7 +54,6 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	rx_info->bss_index = priv->bss_index;
 	ret = mwifiex_process_sta_rx_packet(adapter, skb);
 
-	LEAVE();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
@@ -78,8 +75,6 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	u8 *head_ptr = NULL;
 	struct txpd *local_tx_pd = NULL;
 
-	ENTER();
-
 	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, skb);
 	if (!head_ptr) {
 		ret = -1;
@@ -120,7 +115,6 @@ done:
 		break;
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -191,8 +185,6 @@ int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 	struct sk_buff *skb_parent = NULL;
 	unsigned long flags;
 
-	ENTER();
-
 	priv = adapter->priv[rx_info->bss_index];
 
 	if (priv && (status == -1))
@@ -215,6 +207,5 @@ int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 		dev_kfree_skb_any(skb);
 	}
 
-	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 3180542..07b8b43 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -35,11 +35,8 @@
 int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
 {
 
-	ENTER();
-
 	adapter->init_wait_q_woken = true;
 	wake_up_interruptible(&adapter->init_wait_q);
-	LEAVE();
 	return 0;
 }
 
@@ -52,11 +49,9 @@ int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
  */
 int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
 {
-	ENTER();
 	adapter->hw_status = MWIFIEX_HW_STATUS_NOT_READY;
 	adapter->init_wait_q_woken = true;
 	wake_up_interruptible(&adapter->init_wait_q);
-	LEAVE();
 	return 0;
 }
 
@@ -75,8 +70,6 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 	int ret = 0;
 	u16 cmd;
 
-	ENTER();
-
 	if (func_init_shutdown == MWIFIEX_FUNC_INIT) {
 		cmd = HostCmd_CMD_FUNC_INIT;
 	} else if (func_init_shutdown == MWIFIEX_FUNC_SHUTDOWN) {
@@ -95,7 +88,6 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 		ret = -EINPROGRESS;
 
 exit:
-	LEAVE();
 	return ret;
 }
 
@@ -111,8 +103,6 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
-
 	if (info) {
 		memcpy(info->packets_out,
 		       priv->wmm.packets_out,
@@ -168,7 +158,6 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->cmd_resp_received = adapter->cmd_resp_received;
 	}
 
-	LEAVE();
 	return ret;
 }
 
@@ -185,7 +174,6 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
 	struct mwifiex_rxinfo *rx_info = NULL;
 	struct mwifiex_private *priv = NULL;
-	ENTER();
 
 	if (!skb)
 		return -1;
@@ -205,7 +193,6 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	else
 		netif_rx_ni(skb);
 
-	LEAVE();
 	return 0;
 }
 
@@ -287,7 +274,6 @@ int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
 {
 	enum mwifiex_error_code status_code =
 		(enum mwifiex_error_code) wait_queue->status;
-	ENTER();
 
 	atomic_dec(&adapter->ioctl_pending);
 
@@ -311,6 +297,5 @@ int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
 		kfree(wait_queue);
 	}
 
-	LEAVE();
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index 51ffff2..db19d19 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -33,7 +33,6 @@
 #define MCMD_D      BIT(17)
 #define MFW_D       BIT(18)
 
-#define MENTRY      BIT(28)
 #define MWARN       BIT(29)
 #define MINFO       BIT(30)
 #define MHEX_DUMP   BIT(31)
@@ -88,16 +87,6 @@ do {                \
 	mwifiex_print(MHEX_DUMP | level, x, y, z); \
 } while (0)
 
-#define ENTER()     \
-do {                \
-	PRINTM(MENTRY, "Enter: %s\n", __func__);   \
-} while (0)
-
-#define LEAVE()     \
-do {                \
-	PRINTM(MENTRY, "Leave: %s\n", __func__);   \
-} while (0)
-
 #define HEXDUMP(x, y, z)   \
 do {                \
 	mwifiex_print(MHEX_DUMP | MINFO, x, y, z); \
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 63d682e..868e119 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -87,8 +87,6 @@ mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
 {
 	const char *ac_str[] = { "BK", "BE", "VI", "VO" };
 
-	ENTER();
-
 	PRINTM(MINFO, "WMM AC_%s: ACI=%d, ACM=%d, Aifsn=%d, "
 	       "EcwMin=%d, EcwMax=%d, TxopLimit=%d\n",
 	       ac_str[wmm_aci_to_qidx_map[(ac_param->aci_aifsn_bitmap
@@ -99,8 +97,6 @@ mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
 	       ac_param->ecw_bitmap & MWIFIEX_ECW_MIN,
 	       (ac_param->ecw_bitmap & MWIFIEX_ECW_MAX) >> 4,
 	       le16_to_cpu(ac_param->tx_op_limit));
-
-	LEAVE();
 }
 
 /*
@@ -113,8 +109,6 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
-	ENTER();
-
 	ra_list = kzalloc(sizeof(struct mwifiex_ra_list_tbl), GFP_ATOMIC);
 
 	if (!ra_list) {
@@ -130,7 +124,6 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 
 	PRINTM(MINFO, "RAList: Allocating buffers for TID %p\n", ra_list);
 done:
-	LEAVE();
 	return ra_list;
 }
 
@@ -149,8 +142,6 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 {
 	unsigned long flags;
 
-	ENTER();
-
 	mwifiex_11n_cleanup_reorder_tbl(priv);
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
@@ -164,8 +155,6 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-
-	LEAVE();
 }
 
 /*
@@ -179,8 +168,6 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 	struct mwifiex_ra_list_tbl *ra_list;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ENTER();
-
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		ra_list = mwifiex_wmm_allocate_ralist_node(adapter, ra);
 		PRINTM(MINFO, "Creating RA List %p\n", ra_list);
@@ -202,8 +189,6 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 		if (!priv->wmm.tid_tbl_ptr[i].ra_list_curr)
 			priv->wmm.tid_tbl_ptr[i].ra_list_curr = ra_list;
 	}
-
-	LEAVE();
 }
 
 /*
@@ -212,15 +197,11 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 void
 mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv)
 {
-	ENTER();
-
 	/* Default queue priorities: VO->VI->BE->BK */
 	priv->wmm.queue_priority[0] = WMM_AC_VO;
 	priv->wmm.queue_priority[1] = WMM_AC_VI;
 	priv->wmm.queue_priority[2] = WMM_AC_BE;
 	priv->wmm.queue_priority[3] = WMM_AC_BK;
-
-	LEAVE();
 }
 
 /*
@@ -232,14 +213,10 @@ mwifiex_wmm_queue_priorities_tid(struct mwifiex_private *priv,
 {
 	int i;
 
-	ENTER();
-
 	for (i = 0; i < 4; ++i) {
 		tos_to_tid[7 - (i * 2)] = ac_to_tid[queue_priority[i]][1];
 		tos_to_tid[6 - (i * 2)] = ac_to_tid[queue_priority[i]][0];
 	}
-
-	LEAVE();
 }
 
 /*
@@ -253,12 +230,9 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 	u32 i, j, num_ac;
 	u8 ac_idx;
 
-	ENTER();
-
 	if (!wmm_ie || !priv->wmm_enabled) {
 		/* WMM is not enabled, just set the defaults and return */
 		mwifiex_wmm_default_queue_priorities(priv);
-		LEAVE();
 		return;
 	}
 
@@ -318,7 +292,6 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 	HEXDUMP("WMM: avg_back_off, sort", (u8 *) tmp, sizeof(tmp));
 	HEXDUMP("WMM: queue_priority, sort", priv->wmm.queue_priority,
 		sizeof(priv->wmm.queue_priority));
-	LEAVE();
 }
 
 /*
@@ -335,15 +308,11 @@ mwifiex_wmm_eval_downgrade_ac(struct mwifiex_private *priv,
 	enum mwifiex_wmm_ac_e ret_ac;
 	struct mwifiex_wmm_ac_status *ac_status;
 
-	ENTER();
-
 	ac_status = &priv->wmm.ac_status[eval_ac];
 
-	if (!ac_status->disabled) {
-		LEAVE();
+	if (!ac_status->disabled)
 		/* Okay to use this AC, its enabled */
 		return eval_ac;
-	}
 
 	/* Setup a default return value of the lowest priority */
 	ret_ac = WMM_AC_BK;
@@ -364,7 +333,6 @@ mwifiex_wmm_eval_downgrade_ac(struct mwifiex_private *priv,
 			ret_ac = (enum mwifiex_wmm_ac_e) down_ac;
 	}
 
-	LEAVE();
 	return ret_ac;
 }
 
@@ -376,8 +344,6 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 {
 	int ac_val;
 
-	ENTER();
-
 	PRINTM(MINFO, "WMM: AC Priorities: BK(0), BE(1), VI(2), VO(3)\n");
 
 	if (!priv->wmm_enabled) {
@@ -397,8 +363,6 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 			       priv->wmm.ac_down_graded_vals[ac_val]);
 		}
 	}
-
-	LEAVE();
 }
 
 /*
@@ -419,14 +383,9 @@ mwifiex_wmm_convert_tos_to_ac(struct mwifiex_adapter *adapter, u32 tos)
 		WMM_AC_VO
 	};
 
-	ENTER();
-
-	if (tos >= ARRAY_SIZE(tos_to_ac)) {
-		LEAVE();
+	if (tos >= ARRAY_SIZE(tos_to_ac))
 		return WMM_AC_BE;
-	}
 
-	LEAVE();
 	return tos_to_ac[tos];
 }
 
@@ -442,8 +401,6 @@ mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid)
 	enum mwifiex_wmm_ac_e ac, ac_down;
 	u8 new_tid;
 
-	ENTER();
-
 	ac = mwifiex_wmm_convert_tos_to_ac(priv->adapter, tid);
 	ac_down = priv->wmm.ac_down_graded_vals[ac];
 
@@ -452,7 +409,6 @@ mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid)
 	 */
 	new_tid = ac_to_tid[ac_down][tid % 2];
 
-	LEAVE();
 	return new_tid;
 }
 
@@ -466,8 +422,6 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 	int i, j;
 	struct mwifiex_private *priv;
 
-	ENTER();
-
 	for (j = 0; j < adapter->priv_num; ++j) {
 		priv = adapter->priv[j];
 		if (priv) {
@@ -499,8 +453,6 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 				MWIFIEX_AMPDU_DEF_RXWINSIZE;
 		}
 	}
-
-	LEAVE();
 }
 
 /*
@@ -512,8 +464,6 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 	int i, j;
 	struct mwifiex_private *priv;
 
-	ENTER();
-
 	for (j = 0; j < adapter->priv_num; ++j) {
 		priv = adapter->priv[j];
 		if (priv) {
@@ -523,15 +473,12 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 								  &priv->wmm.
 								  tid_tbl_ptr
 								  [i].
-								  ra_list)) {
-					LEAVE();
+								  ra_list))
 					return false;
-				}
 			}
 		}
 	}
 
-	LEAVE();
 	return true;
 }
 
@@ -566,12 +513,8 @@ mwifiex_wmm_del_pkts_in_ralist(struct mwifiex_private *priv,
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
-	ENTER();
-
 	list_for_each_entry(ra_list, ra_list_head, list)
 		mwifiex_wmm_del_pkts_in_ralist_node(priv, ra_list);
-
-	LEAVE();
 }
 
 /*
@@ -582,15 +525,11 @@ mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 {
 	int i;
 
-	ENTER();
-
 	for (i = 0; i < MAX_NUM_TID; i++) {
 		mwifiex_wmm_del_pkts_in_ralist(priv,
 					       &priv->wmm.tid_tbl_ptr[i].
 					       ra_list);
 	}
-
-	LEAVE();
 }
 
 /*
@@ -602,8 +541,6 @@ mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 	struct mwifiex_ra_list_tbl *ra_list, *tmp_node;
 	int i;
 
-	ENTER();
-
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		PRINTM(MINFO, "RAList: Freeing buffers for TID %d\n", i);
 		list_for_each_entry_safe(ra_list, tmp_node,
@@ -616,8 +553,6 @@ mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 
 		priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
 	}
-
-	LEAVE();
 }
 
 /*
@@ -630,17 +565,12 @@ mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
-	ENTER();
-
 	list_for_each_entry(ra_list, &priv->wmm.tid_tbl_ptr[tid].ra_list,
 			    list) {
-		if (!memcmp(ra_list->ra, ra_addr, MWIFIEX_MAC_ADDR_LENGTH)) {
-			LEAVE();
+		if (!memcmp(ra_list->ra, ra_addr, MWIFIEX_MAC_ADDR_LENGTH))
 			return ra_list;
-		}
 	}
 
-	LEAVE();
 	return NULL;
 }
 
@@ -657,16 +587,11 @@ mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
-	ENTER();
-
 	ra_list = mwifiex_wmm_get_ralist_node(priv, tid, ra_addr);
-	if (ra_list) {
-		LEAVE();
+	if (ra_list)
 		return ra_list;
-	}
 	mwifiex_ralist_add(priv, ra_addr);
 
-	LEAVE();
 	return mwifiex_wmm_get_ralist_node(priv, tid, ra_addr);
 }
 
@@ -709,12 +634,9 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	u8 ra[MWIFIEX_MAC_ADDR_LENGTH], tid_down;
 	unsigned long flags;
 
-	ENTER();
-
 	if (!priv->media_connected) {
 		PRINTM(MWARN, "Drop packet in disconnect\n");
 		mwifiex_write_data_complete(adapter, skb, -1);
-		LEAVE();
 		return;
 	}
 
@@ -744,7 +666,6 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	if (!ra_list) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		mwifiex_write_data_complete(adapter, skb, -1);
-		LEAVE();
 		return;
 	}
 
@@ -754,8 +675,6 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	ra_list->total_pkts_size += skb->len;
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-
-	LEAVE();
 }
 
 /*
@@ -781,8 +700,6 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 	struct ieee_types_wmm_parameter *wmm_param_ie = NULL;
 	struct mwifiex_wmm_ac_status *ac_status;
 
-	ENTER();
-
 	PRINTM(MINFO, "WMM: WMM_GET_STATUS cmdresp received: %d\n", resp_len);
 	HEXDUMP("CMD_RESP: WMM_GET_STATUS", curr, resp_len);
 
@@ -849,7 +766,6 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 	mwifiex_wmm_setup_queue_priorities(priv, wmm_param_ie);
 	mwifiex_wmm_setup_ac_downgrade(priv);
 
-	LEAVE();
 	return 0;
 }
 
@@ -869,22 +785,14 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_wmm_param_set *wmm_tlv;
 	u32 ret_len = 0;
 
-	ENTER();
-
 	/* Null checks */
-	if (!assoc_buf) {
-		LEAVE();
+	if (!assoc_buf)
 		return 0;
-	}
-	if (!(*assoc_buf)) {
-		LEAVE();
+	if (!(*assoc_buf))
 		return 0;
-	}
 
-	if (!wmm_ie) {
-		LEAVE();
+	if (!wmm_ie)
 		return 0;
-	}
 
 	PRINTM(MINFO, "WMM: process assoc req: bss->wmmIe=0x%x\n",
 	       wmm_ie->vend_hdr.element_id);
@@ -914,7 +822,6 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 		*assoc_buf += ret_len;
 	}
 
-	LEAVE();
 	return ret_len;
 }
 
@@ -935,8 +842,6 @@ mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 	struct timeval out_tstamp, in_tstamp;
 	u32 queue_delay;
 
-	ENTER();
-
 	do_gettimeofday(&out_tstamp);
 	in_tstamp = ktime_to_timeval(skb->tstamp);
 
@@ -954,7 +859,6 @@ mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 	PRINTM(MDATA, "WMM: Pkt Delay: %d ms, %d ms sent to FW\n",
 	       queue_delay, ret_val);
 
-	LEAVE();
 	return ret_val;
 }
 
@@ -973,8 +877,6 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 	unsigned long flags;
 	int i, j;
 
-	ENTER();
-
 	PRINTM(MDAT_D, "POP\n");
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
@@ -1045,7 +947,6 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 					if (!is_list_empty) {
 						*priv = priv_tmp;
 						*tid = tos_to_tid[i];
-						LEAVE();
 						return ptr;
 					}
 					/* Get next ra */
@@ -1077,7 +978,6 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 						list);
 		} while (bssprio_node != bssprio_head);
 	}
-	LEAVE();
 	return NULL;
 }
 
@@ -1092,8 +992,6 @@ mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
 	int count = 0, total_size = 0;
 	struct sk_buff *skb, *tmp;
 
-	ENTER();
-
 	skb_queue_walk_safe(&ptr->skb_head, skb, tmp) {
 		total_size += skb->len;
 		if (total_size < max_buf_size)
@@ -1102,7 +1000,6 @@ mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
 			break;
 	}
 
-	LEAVE();
 	return count;
 }
 
@@ -1121,8 +1018,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	int status = 0;
 	struct mwifiex_txinfo *tx_info;
 
-	ENTER();
-
 	if (skb_queue_empty(&ptr->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -1161,7 +1056,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 					&priv->wmm.ra_list_spinlock,
 					ra_list_flags);
 			mwifiex_write_data_complete(adapter, skb, -1);
-			LEAVE();
 			return;
 		}
 
@@ -1187,8 +1081,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1230,8 +1122,6 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	struct sk_buff *skb, *skb_next;
 	struct mwifiex_txinfo *tx_info;
 
-	ENTER();
-
 	if (skb_queue_empty(&ptr->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -1265,7 +1155,6 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 					&priv->wmm.ra_list_spinlock,
 					ra_list_flags);
 			mwifiex_write_data_complete(adapter, skb, -1);
-			LEAVE();
 			return;
 		}
 
@@ -1303,8 +1192,6 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 	}
-
-	LEAVE();
 }
 
 /*
@@ -1321,14 +1208,10 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	int tid_del = 0, tid = 0;
 	unsigned long flags;
 
-	ENTER();
-
 	ptr = mwifiex_wmm_get_highest_priolist_ptr(adapter, &priv,
 							&ptr_index);
-	if (!ptr) {
-		LEAVE();
+	if (!ptr)
 		return -1;
-	}
 
 	tid = mwifiex_get_tid(priv->adapter, ptr);
 
@@ -1337,7 +1220,6 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 	if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-		LEAVE();
 		return -1;
 	}
 
@@ -1345,7 +1227,6 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		mwifiex_send_processed_packet(priv, ptr, ptr_index, flags);
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_processed_packet() */
-		LEAVE();
 		return 0;
 	}
 
@@ -1390,7 +1271,6 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 			   mwifiex_send_single_packet() */
 		}
 	}
-	LEAVE();
 	return 0;
 }
 
@@ -1401,8 +1281,6 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 void
 mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter)
 {
-	ENTER();
-
 	do {
 		/* Check if busy */
 		if (adapter->data_sent || adapter->tx_lock_flag)
@@ -1412,6 +1290,5 @@ mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter)
 			break;
 	} while (true);
 
-	LEAVE();
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 8e7785f..f2fa4e0 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -47,12 +47,9 @@ mwifiex_wmm_list_len(struct mwifiex_adapter *adapter,
 	struct list_head *pos;
 	int count = 0;
 
-	ENTER();
-
 	list_for_each(pos, head)
 		++count;
 
-	LEAVE();
 	return count;
 }
 
-- 
1.7.0.2


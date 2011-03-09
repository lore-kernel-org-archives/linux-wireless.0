Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43962 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab1CIBoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 20:44:17 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: rearrange code for better readability
Date: Tue,  8 Mar 2011 17:47:16 -0800
Message-Id: <1299635237-17913-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

restructuring if & else blocks to avoid multiline split

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   57 +++---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  212 +++++++++++------------
 drivers/net/wireless/mwifiex/cfg80211.c      |  121 ++++++-------
 drivers/net/wireless/mwifiex/cmdevt.c        |   67 +++----
 drivers/net/wireless/mwifiex/init.c          |   24 ++--
 drivers/net/wireless/mwifiex/main.c          |   67 ++++----
 drivers/net/wireless/mwifiex/scan.c          |  181 +++++++++-----------
 drivers/net/wireless/mwifiex/sta_cmd.c       |  157 ++++++++---------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    9 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  246 ++++++++++++--------------
 drivers/net/wireless/mwifiex/wmm.c           |   70 ++++----
 11 files changed, 558 insertions(+), 653 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 0d8e1c1..b2850fc 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -123,7 +123,6 @@ int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
 		priv->add_ba_param.rx_win_size = addba_param->rx_win_size;
 		if (timeout != priv->add_ba_param.timeout)
 			mwifiex_11n_update_addba_request(priv);
-
 	}
 
 	return 0;
@@ -181,39 +180,37 @@ int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 		for (i = 0; i < MAX_NUM_TID; i++) {
 			aggr_prio_tbl->ampdu[i] =
 				priv->aggr_prio_tbl[i].ampdu_user;
-			aggr_prio_tbl->amsdu[i] =
-				priv->aggr_prio_tbl[i].amsdu;
-		}
-	} else {
-		if (priv->media_connected) {
-			dev_err(priv->adapter->dev, "cannot set aggr priority"
-					" table in connected state\n");
-			return -1;
+			aggr_prio_tbl->amsdu[i] = priv->aggr_prio_tbl[i].amsdu;
 		}
+		return 0;
+	}
 
-		for (i = 0; i < MAX_NUM_TID; i++) {
-			/* For AMPDU */
-			if ((aggr_prio_tbl->ampdu[i] > HIGH_PRIO_TID)
-			    && (aggr_prio_tbl->ampdu[i] !=
-				BA_STREAM_NOT_ALLOWED)) {
-				ret = -1;
-				break;
-			}
+	/* action == SET */
+	if (priv->media_connected) {
+		dev_err(priv->adapter->dev, "cannot set aggr priority"
+				" table in connected state\n");
+		return -1;
+	}
 
-			priv->aggr_prio_tbl[i].ampdu_ap =
-				priv->aggr_prio_tbl[i].ampdu_user =
-				aggr_prio_tbl->ampdu[i];
+	for (i = 0; i < MAX_NUM_TID; i++) {
+		/* For AMPDU */
+		if ((aggr_prio_tbl->ampdu[i] > HIGH_PRIO_TID)
+		    && (aggr_prio_tbl->ampdu[i] != BA_STREAM_NOT_ALLOWED)) {
+			ret = -1;
+			break;
+		}
 
-			/* For AMSDU */
-			if ((aggr_prio_tbl->amsdu[i] > HIGH_PRIO_TID
-			     && aggr_prio_tbl->amsdu[i] !=
-			     BA_STREAM_NOT_ALLOWED)) {
-				ret = -1;
-				break;
-			} else {
-				priv->aggr_prio_tbl[i].amsdu =
-					aggr_prio_tbl->amsdu[i];
-			}
+		priv->aggr_prio_tbl[i].ampdu_ap =
+			priv->aggr_prio_tbl[i].ampdu_user =
+			aggr_prio_tbl->ampdu[i];
+
+		/* For AMSDU */
+		if ((aggr_prio_tbl->amsdu[i] > HIGH_PRIO_TID
+		     && aggr_prio_tbl->amsdu[i] != BA_STREAM_NOT_ALLOWED)) {
+			ret = -1;
+			break;
+		} else {
+			priv->aggr_prio_tbl[i].amsdu = aggr_prio_tbl->amsdu[i];
 		}
 	}
 
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 7d5e7ef..91b0c5b 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -260,57 +260,56 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	if (rx_reor_tbl_ptr) {
 		mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
 							 seq_num);
+		return;
+	}
+	/* if !rx_reor_tbl_ptr then create one */
+	new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl), GFP_KERNEL);
+	if (!new_node) {
+		dev_err(priv->adapter->dev, "%s: failed to alloc new_node\n",
+		       __func__);
+		return;
 	}
-	else {
-		new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl),
-						GFP_KERNEL);
-		if (!new_node) {
-			dev_err(priv->adapter->dev, "%s: failed to alloc new_node\n",
-			       __func__);
-			return;
-		}
 
-		INIT_LIST_HEAD(&new_node->list);
-		new_node->tid = tid;
-		memcpy(new_node->ta, ta, ETH_ALEN);
-		new_node->start_win = seq_num;
-		if (mwifiex_queuing_ra_based(priv))
-			/* TODO for adhoc */
-			dev_dbg(priv->adapter->dev,
-				"info: ADHOC:last_seq=%d start_win=%d\n",
-				last_seq, new_node->start_win);
-		else
-			last_seq = priv->rx_seq[tid];
+	INIT_LIST_HEAD(&new_node->list);
+	new_node->tid = tid;
+	memcpy(new_node->ta, ta, ETH_ALEN);
+	new_node->start_win = seq_num;
+	if (mwifiex_queuing_ra_based(priv))
+		/* TODO for adhoc */
+		dev_dbg(priv->adapter->dev,
+			"info: ADHOC:last_seq=%d start_win=%d\n",
+			last_seq, new_node->start_win);
+	else
+		last_seq = priv->rx_seq[tid];
 
-		if (last_seq >= new_node->start_win)
-			new_node->start_win = last_seq + 1;
+	if (last_seq >= new_node->start_win)
+		new_node->start_win = last_seq + 1;
 
-		new_node->win_size = win_size;
+	new_node->win_size = win_size;
 
-		new_node->rx_reorder_ptr = kzalloc(sizeof(void *) * win_size,
-						GFP_KERNEL);
-		if (!new_node->rx_reorder_ptr) {
-			kfree((u8 *) new_node);
-			dev_err(priv->adapter->dev,
-				"%s: failed to alloc reorder_ptr\n", __func__);
-			return;
-		}
+	new_node->rx_reorder_ptr = kzalloc(sizeof(void *) * win_size,
+					GFP_KERNEL);
+	if (!new_node->rx_reorder_ptr) {
+		kfree((u8 *) new_node);
+		dev_err(priv->adapter->dev,
+			"%s: failed to alloc reorder_ptr\n", __func__);
+		return;
+	}
 
-		new_node->timer_context.ptr = new_node;
-		new_node->timer_context.priv = priv;
+	new_node->timer_context.ptr = new_node;
+	new_node->timer_context.priv = priv;
 
-		init_timer(&new_node->timer_context.timer);
-		new_node->timer_context.timer.function = mwifiex_flush_data;
-		new_node->timer_context.timer.data =
-				(unsigned long) &new_node->timer_context;
+	init_timer(&new_node->timer_context.timer);
+	new_node->timer_context.timer.function = mwifiex_flush_data;
+	new_node->timer_context.timer.data =
+			(unsigned long) &new_node->timer_context;
 
-		for (i = 0; i < win_size; ++i)
-			new_node->rx_reorder_ptr[i] = NULL;
+	for (i = 0; i < win_size; ++i)
+		new_node->rx_reorder_ptr[i] = NULL;
 
-		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
-		list_add_tail(&new_node->list, &priv->rx_reorder_tbl_ptr);
-		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
-	}
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_add_tail(&new_node->list, &priv->rx_reorder_tbl_ptr);
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	return;
 }
@@ -331,11 +330,8 @@ int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
 		&cmd->params.add_ba_req;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_REQ);
-	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_11n_addba_req) +
-				S_DS_GEN);
-
-	memcpy(add_ba_req, data_buf,
-	       sizeof(struct host_cmd_ds_11n_addba_req));
+	cmd->size = cpu_to_le16(sizeof(*add_ba_req) + S_DS_GEN);
+	memcpy(add_ba_req, data_buf, sizeof(*add_ba_req));
 
 	return 0;
 }
@@ -362,8 +358,7 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	uint16_t block_ack_param_set;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_RSP);
-	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_11n_addba_rsp) +
-				S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(*add_ba_rsp) + S_DS_GEN);
 
 	memcpy(add_ba_rsp->peer_mac_addr, cmd_addba_req->peer_mac_addr,
 	       ETH_ALEN);
@@ -410,10 +405,8 @@ int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
 		&cmd->params.del_ba;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_DELBA);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_11n_delba) + S_DS_GEN);
-
-	memcpy(del_ba, data_buf, sizeof(struct host_cmd_ds_11n_delba));
+	cmd->size = cpu_to_le16(sizeof(*del_ba) + S_DS_GEN);
+	memcpy(del_ba, data_buf, sizeof(*del_ba));
 
 	return 0;
 }
@@ -444,78 +437,71 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		mwifiex_11n_get_rx_reorder_tbl((struct mwifiex_private *) priv,
 						tid, ta);
 	if (!rx_reor_tbl_ptr) {
-		if (pkt_type == PKT_TYPE_BAR) {
-			return ret;
-		}
-		else {
+		if (pkt_type != PKT_TYPE_BAR)
 			mwifiex_11n_dispatch_pkt(priv, payload);
-			return ret;
-		}
-	} else {
-		start_win = rx_reor_tbl_ptr->start_win;
-		win_size = rx_reor_tbl_ptr->win_size;
-		end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
-		del_timer(&rx_reor_tbl_ptr->timer_context.timer);
-		mod_timer(&rx_reor_tbl_ptr->timer_context.timer, jiffies
+		return 0;
+	}
+	start_win = rx_reor_tbl_ptr->start_win;
+	win_size = rx_reor_tbl_ptr->win_size;
+	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
+	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
+	mod_timer(&rx_reor_tbl_ptr->timer_context.timer, jiffies
 			+ (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
 
-		/*
-		 * If seq_num is less then starting win then ignore and drop the
-		 * packet
-		 */
-		if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {/* Wrap */
-			if (seq_num >= ((start_win + (TWOPOW11)) &
-			    (MAX_TID_VALUE - 1)) && (seq_num < start_win))
-				return -1;
-		} else if ((seq_num < start_win) ||
-			   (seq_num > (start_win + (TWOPOW11)))) {
+	/*
+	 * If seq_num is less then starting win then ignore and drop the
+	 * packet
+	 */
+	if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {/* Wrap */
+		if (seq_num >= ((start_win + (TWOPOW11)) & (MAX_TID_VALUE - 1))
+				&& (seq_num < start_win))
 			return -1;
-		}
+	} else if ((seq_num < start_win)
+			|| (seq_num > (start_win + (TWOPOW11)))) {
+		return -1;
+	}
 
-		/*
-		 * If this packet is a BAR we adjust seq_num as
-		 * WinStart = seq_num
-		 */
-		if (pkt_type == PKT_TYPE_BAR)
-			seq_num = ((seq_num + win_size) - 1) &
-				   (MAX_TID_VALUE - 1);
-
-		if (((end_win < start_win)
-		     && (seq_num < (TWOPOW11 - (MAX_TID_VALUE - start_win)))
-		     && (seq_num > end_win)) || ((end_win > start_win) &&
-			((seq_num > end_win) || (seq_num < start_win)))) {
-			end_win = seq_num;
-			if (((seq_num - win_size) + 1) >= 0)
-				start_win = (end_win - win_size) + 1;
-			else
-				start_win = (MAX_TID_VALUE -
-					     (win_size - seq_num)) + 1;
-			ret = mwifiex_11n_dispatch_pkt_until_start_win(priv,
+	/*
+	 * If this packet is a BAR we adjust seq_num as
+	 * WinStart = seq_num
+	 */
+	if (pkt_type == PKT_TYPE_BAR)
+		seq_num = ((seq_num + win_size) - 1) & (MAX_TID_VALUE - 1);
+
+	if (((end_win < start_win)
+	     && (seq_num < (TWOPOW11 - (MAX_TID_VALUE - start_win)))
+	     && (seq_num > end_win)) || ((end_win > start_win)
+	     && ((seq_num > end_win) || (seq_num < start_win)))) {
+		end_win = seq_num;
+		if (((seq_num - win_size) + 1) >= 0)
+			start_win = (end_win - win_size) + 1;
+		else
+			start_win = (MAX_TID_VALUE - (win_size - seq_num)) + 1;
+		ret = mwifiex_11n_dispatch_pkt_until_start_win(priv,
 						rx_reor_tbl_ptr, start_win);
 
-			if (ret)
-				return ret;
-		}
-
-		if (pkt_type != PKT_TYPE_BAR) {
-			if (seq_num >= start_win)
-				pkt_index = seq_num - start_win;
-			else
-				pkt_index = (seq_num+MAX_TID_VALUE) - start_win;
+		if (ret)
+			return ret;
+	}
 
-			if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index])
-				return -1;
+	if (pkt_type != PKT_TYPE_BAR) {
+		if (seq_num >= start_win)
+			pkt_index = seq_num - start_win;
+		else
+			pkt_index = (seq_num+MAX_TID_VALUE) - start_win;
 
-			rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
-		}
+		if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index])
+			return -1;
 
-		/*
-		 * Dispatch all packets sequentially from start_win until a
-		 * hole is found and adjust the start_win appropriately
-		 */
-		ret = mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
+		rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
 	}
 
+	/*
+	 * Dispatch all packets sequentially from start_win until a
+	 * hole is found and adjust the start_win appropriately
+	 */
+	ret = mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c3e5492..7948751 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -217,7 +217,8 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 
 	if (timeout)
 		wiphy_dbg(wiphy,
-			"info: ignoring the timeout value for IEEE power save\n");
+			"info: ignoring the timeout value"
+			" for IEEE power save\n");
 
 	ret = mwifiex_drv_set_power(priv, enabled);
 
@@ -429,20 +430,19 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 
 	wiphy_dbg(wiphy, "info: setting band %d, channel offset %d and "
 		"mode %d\n", config_bands, band_cfg.sec_chan_offset, mode);
+	if (!chan)
+		return ret;
 
-	if (chan) {
-		memset(&cfp, 0, sizeof(cfp));
-		cfp.freq = chan->center_freq;
-		/* Convert frequency to channel */
-		cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
+	memset(&cfp, 0, sizeof(cfp));
+	cfp.freq = chan->center_freq;
+	/* Convert frequency to channel */
+	cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
 
-		status = mwifiex_bss_ioctl_channel(priv, HostCmd_ACT_GEN_SET,
-						   &cfp);
-		if (status)
-			return -EFAULT;
+	status = mwifiex_bss_ioctl_channel(priv, HostCmd_ACT_GEN_SET, &cfp);
+	if (status)
+		return -EFAULT;
 
-		ret = mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
-	}
+	ret = mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
 
 	return ret;
 }
@@ -1074,61 +1074,54 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 
 	ret = mwifiex_set_encode(priv, 0, NULL, 0, 0, 1);/* Disable keys */
 
-	if (sme) {
-		if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC ||
-		    sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
-			auth_type = MWIFIEX_AUTH_MODE_OPEN;
-		else if (sme->auth_type == NL80211_AUTHTYPE_SHARED_KEY)
-			auth_type = MWIFIEX_AUTH_MODE_SHARED;
-
-		if (sme->crypto.n_ciphers_pairwise) {
-			pairwise_encrypt_mode =
-				mwifiex_get_mwifiex_cipher(sme->crypto.
-							   ciphers_pairwise[0]
-							   , &wpa_enabled);
-			ret = mwifiex_set_auth(priv, pairwise_encrypt_mode,
-					       auth_type, wpa_enabled);
-		}
+	if (!sme && privacy) {
+		/*
+		 * Keep MWIFIEX_ENCRYPTION_MODE_WEP40 for now so that
+		 * the firmware can find a matching network from the
+		 * scan. cfg80211 doesnt not give us the encryption
+		 * mode at this stage so just setting it to wep here
+		 */
+		auth_type = MWIFIEX_AUTH_MODE_OPEN;
+		wpa_enabled = 0;
+		ret = mwifiex_set_auth(priv, MWIFIEX_ENCRYPTION_MODE_WEP104,
+							auth_type, wpa_enabled);
+		goto done;
+	}
 
-		if (sme->crypto.cipher_group) {
-			group_encrypt_mode =
-				mwifiex_get_mwifiex_cipher(sme->crypto.
-							   cipher_group,
-							   &wpa_enabled);
-			ret = mwifiex_set_auth(priv, group_encrypt_mode,
-					       auth_type, wpa_enabled);
-		}
-		if (sme->ie)
-			ret = mwifiex_set_gen_ie(priv, sme->ie, sme->ie_len);
-
-		if (sme->key) {
-			alg_is_wep = mwifiex_is_alg_wep(pairwise_encrypt_mode) |
-				     mwifiex_is_alg_wep(group_encrypt_mode);
-			if (alg_is_wep) {
-				dev_dbg(priv->adapter->dev,
-					"info: setting wep encryption"
-					" with key len %d\n", sme->key_len);
-				ret = mwifiex_set_wep_keys(priv, sme->key,
-							   sme->key_len,
-							   sme->key_idx);
-			}
-		}
-	} else {
-		if (privacy) {
-			/*
-			 * Keep MWIFIEX_ENCRYPTION_MODE_WEP40 for now so that
-			 * the firmware can find a matching network from the
-			 * scan. cfg80211 doesnt not give us the encryption
-			 * mode at this stage so just setting it to wep here
-			 */
-			auth_type = MWIFIEX_AUTH_MODE_OPEN;
-			wpa_enabled = 0;
-			ret = mwifiex_set_auth(priv,
-					       MWIFIEX_ENCRYPTION_MODE_WEP104,
-					       auth_type, wpa_enabled);
-		}
+	if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC
+			|| sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
+		auth_type = MWIFIEX_AUTH_MODE_OPEN;
+	else if (sme->auth_type == NL80211_AUTHTYPE_SHARED_KEY)
+		auth_type = MWIFIEX_AUTH_MODE_SHARED;
+
+	if (sme->crypto.n_ciphers_pairwise) {
+		pairwise_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
+					ciphers_pairwise[0], &wpa_enabled);
+		ret = mwifiex_set_auth(priv, pairwise_encrypt_mode, auth_type,
+								wpa_enabled);
+	}
+
+	if (sme->crypto.cipher_group) {
+		group_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
+						   cipher_group, &wpa_enabled);
+		ret = mwifiex_set_auth(priv, group_encrypt_mode, auth_type,
+								wpa_enabled);
 	}
+	if (sme->ie)
+		ret = mwifiex_set_gen_ie(priv, sme->ie, sme->ie_len);
 
+	if (sme->key) {
+		alg_is_wep = mwifiex_is_alg_wep(pairwise_encrypt_mode)
+			| mwifiex_is_alg_wep(group_encrypt_mode);
+		if (alg_is_wep) {
+			dev_dbg(priv->adapter->dev,
+				"info: setting wep encryption"
+				" with key len %d\n", sme->key_len);
+			ret = mwifiex_set_wep_keys(priv, sme->key, sme->key_len,
+						   sme->key_idx);
+		}
+	}
+done:
 	/* Do specific SSID scanning */
 	if (mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &req_ssid)) {
 		dev_err(priv->adapter->dev, "scan error\n");
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index d88fcb3..e5e7329 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -273,26 +273,22 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		dev_err(adapter->dev, "SLEEP_CFM: failed\n");
 		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure++;
 		return -1;
-	} else {
-		if (GET_BSS_ROLE(mwifiex_get_priv(adapter,
-				 MWIFIEX_BSS_ROLE_ANY))
-				 == MWIFIEX_BSS_ROLE_STA) {
-			if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl)
-				/* Response is not needed for sleep
-				   confirm command */
-				adapter->ps_state = PS_STATE_SLEEP;
-			else
-				adapter->ps_state = PS_STATE_SLEEP_CFM;
-
-			if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl
-			    && (adapter->is_hs_configured &&
-				!adapter->sleep_period.period)) {
-				adapter->pm_wakeup_card_req = true;
-				mwifiex_hs_activated_event
-					(mwifiex_get_priv
-					 (adapter, MWIFIEX_BSS_ROLE_STA),
-					 true);
-			}
+	}
+	if (GET_BSS_ROLE(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY))
+			== MWIFIEX_BSS_ROLE_STA) {
+		if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl)
+			/* Response is not needed for sleep
+			   confirm command */
+			adapter->ps_state = PS_STATE_SLEEP;
+		else
+			adapter->ps_state = PS_STATE_SLEEP_CFM;
+
+		if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl
+				&& (adapter->is_hs_configured
+					&& !adapter->sleep_period.period)) {
+			adapter->pm_wakeup_card_req = true;
+			mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
+						MWIFIEX_BSS_ROLE_STA), true);
 		}
 	}
 
@@ -369,10 +365,9 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 			dev_dbg(adapter->dev, "cmd: free cmd buffer %d\n", i);
 			dev_kfree_skb_any(cmd_array[i].skb);
 		}
-
-		if (cmd_array[i].resp_skb)
-			mwifiex_recv_complete(adapter,
-						cmd_array[i].resp_skb, 0);
+		if (!cmd_array[i].resp_skb)
+			continue;
+		mwifiex_recv_complete(adapter, cmd_array[i].resp_skb, 0);
 	}
 	/* Release struct cmd_ctrl_node */
 	if (adapter->cmd_pool) {
@@ -1248,13 +1243,10 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 				(struct mwifiex_ie_types_ps_param *) tlv;
 			struct mwifiex_ps_param *ps_mode = &ps_tlv->param;
 			ps_tlv->header.type = cpu_to_le16(TLV_TYPE_PS_PARAM);
-			ps_tlv->header.len =
-				cpu_to_le16(sizeof
-					    (struct mwifiex_ie_types_ps_param) -
-					    sizeof(struct
-						   mwifiex_ie_types_header));
-			cmd_size += sizeof(struct mwifiex_ie_types_ps_param);
-			tlv += sizeof(struct mwifiex_ie_types_ps_param);
+			ps_tlv->header.len = cpu_to_le16(sizeof(*ps_tlv) -
+					sizeof(struct mwifiex_ie_types_header));
+			cmd_size += sizeof(*ps_tlv);
+			tlv += sizeof(*ps_tlv);
 			dev_dbg(adapter->dev, "cmd: PS Command: Enter PS\n");
 			ps_mode->null_pkt_interval =
 				cpu_to_le16(adapter->null_pkt_interval);
@@ -1281,15 +1273,10 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 			auto_ps_tlv->header.type =
 				cpu_to_le16(TLV_TYPE_AUTO_DS_PARAM);
 			auto_ps_tlv->header.len =
-				cpu_to_le16(sizeof
-					    (struct
-					     mwifiex_ie_types_auto_ds_param)
-					    -
-					    sizeof(struct
-						   mwifiex_ie_types_header));
-			cmd_size +=
-				sizeof(struct mwifiex_ie_types_auto_ds_param);
-			tlv += sizeof(struct mwifiex_ie_types_auto_ds_param);
+				cpu_to_le16(sizeof(*auto_ps_tlv) -
+					sizeof(struct mwifiex_ie_types_header));
+			cmd_size += sizeof(*auto_ps_tlv);
+			tlv += sizeof(*auto_ps_tlv);
 			if (data_buf)
 				idletime = ((struct mwifiex_ds_auto_ds *)
 					     data_buf)->idle_time;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 0fc9cbf..f06d69c 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -395,20 +395,18 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	}
 
 	for (i = 0; i < adapter->priv_num; i++) {
-		if (adapter->priv[i]) {
-			priv = adapter->priv[i];
-			for (j = 0; j < MAX_NUM_TID; ++j) {
-				INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j]
-						.ra_list);
-				spin_lock_init(&priv->wmm.tid_tbl_ptr[j]
-						.tid_tbl_lock);
-			}
-			INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
-			INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
-
-			spin_lock_init(&priv->tx_ba_stream_tbl_lock);
-			spin_lock_init(&priv->rx_reorder_tbl_lock);
+		if (!adapter->priv[i])
+			continue;
+		priv = adapter->priv[i];
+		for (j = 0; j < MAX_NUM_TID; ++j) {
+			INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j].ra_list);
+			spin_lock_init(&priv->wmm.tid_tbl_ptr[j].tid_tbl_lock);
 		}
+		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
+		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
+
+		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
+		spin_lock_init(&priv->rx_reorder_tbl_lock);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 0201263..0fc2203 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -91,43 +91,38 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 	adapter->priv_num = 0;
 	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++) {
 		adapter->priv[i] = NULL;
-		if (mdevice->bss_attr[i].active) {
-			/* For valid bss_attr,
-			   allocate memory for private structure */
-			adapter->priv[i] =
-				kzalloc(sizeof(struct mwifiex_private),
-					GFP_KERNEL);
-			if (!adapter->priv[i]) {
-				dev_err(adapter->dev, "%s: failed to alloc priv[%d]\n",
-				       __func__, i);
-				goto error;
-			}
 
-			adapter->priv_num++;
-			memset(adapter->priv[i], 0,
-			       sizeof(struct mwifiex_private));
-			adapter->priv[i]->adapter = adapter;
-			/* Save bss_type, frame_type & bss_priority */
-			adapter->priv[i]->bss_type =
-				(u8) mdevice->bss_attr[i].bss_type;
-			adapter->priv[i]->frame_type =
-				(u8) mdevice->bss_attr[i].frame_type;
-			adapter->priv[i]->bss_priority =
-				(u8) mdevice->bss_attr[i].bss_priority;
-			if (mdevice->bss_attr[i].bss_type ==
-							MWIFIEX_BSS_TYPE_STA)
-				adapter->priv[i]->bss_role =
-							MWIFIEX_BSS_ROLE_STA;
-			else if (mdevice->bss_attr[i].bss_type ==
-							MWIFIEX_BSS_TYPE_UAP)
-				adapter->priv[i]->bss_role =
-							MWIFIEX_BSS_ROLE_UAP;
-
-			/* Save bss_index & bss_num */
-			adapter->priv[i]->bss_index = i;
-			adapter->priv[i]->bss_num =
-				mdevice->bss_attr[i].bss_num;
+		if (!mdevice->bss_attr[i].active)
+			continue;
+
+		/* For valid bss_attr,
+		   allocate memory for private structure */
+		adapter->priv[i] = kzalloc(sizeof(struct mwifiex_private),
+				GFP_KERNEL);
+		if (!adapter->priv[i]) {
+			dev_err(adapter->dev, "%s: failed to alloc priv[%d]\n",
+			       __func__, i);
+			goto error;
 		}
+
+		adapter->priv_num++;
+		memset(adapter->priv[i], 0,
+		       sizeof(struct mwifiex_private));
+		adapter->priv[i]->adapter = adapter;
+		/* Save bss_type, frame_type & bss_priority */
+		adapter->priv[i]->bss_type = (u8) mdevice->bss_attr[i].bss_type;
+		adapter->priv[i]->frame_type =
+			(u8) mdevice->bss_attr[i].frame_type;
+		adapter->priv[i]->bss_priority =
+			(u8) mdevice->bss_attr[i].bss_priority;
+		if (mdevice->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_STA)
+			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_STA;
+		else if (mdevice->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_UAP)
+			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_UAP;
+
+		/* Save bss_index & bss_num */
+		adapter->priv[i]->bss_index = i;
+		adapter->priv[i]->bss_num = mdevice->bss_attr[i].bss_num;
 	}
 
 	/* Initialize lock variables */
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 2aacec0..faa2ffd 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2595,116 +2595,98 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		memset(bss_new_entry, 0x00,
 		       sizeof(struct mwifiex_bssdescriptor));
 
-		/* Process the data fields and IEs returned for this BSS */
-		if (!mwifiex_interpret_bss_desc_with_ie(adapter, bss_new_entry,
+		if (mwifiex_interpret_bss_desc_with_ie(adapter, bss_new_entry,
 							&bss_info,
 							&bytes_left)) {
+			/* Error parsing/interpreting scan response, skipped */
+			dev_err(adapter->dev, "SCAN_RESP: "
+			       "mwifiex_interpret_bss_desc_with_ie "
+			       "returned ERROR\n");
+			continue;
+		}
 
-			dev_dbg(adapter->dev, "info: SCAN_RESP: BSSID = %pM\n",
-			       bss_new_entry->mac_address);
-
-			/* Search the scan table for the same bssid */
-			for (bss_idx = 0; bss_idx < num_in_table; bss_idx++) {
-				if (!memcmp(bss_new_entry->mac_address,
-					    adapter->scan_table[bss_idx].
-					    mac_address,
-					    sizeof(bss_new_entry->
-						   mac_address))) {
-					/*
-					 * If the SSID matches as well, it is a
-					 * duplicate of this entry.  Keep the
-					 * bss_idx set to this entry so we
-					 * replace the old contents in the
-					 * table
-					 */
-					if ((bss_new_entry->ssid.ssid_len ==
-					     adapter->scan_table[bss_idx].
-					     ssid.ssid_len)
-					    &&
-					    (!memcmp
-					     (bss_new_entry->ssid.ssid,
-					      adapter->scan_table[bss_idx].
-					      ssid.ssid,
-					      bss_new_entry->ssid.ssid_len))) {
-						dev_dbg(adapter->dev, "info: "
-							"SCAN_RESP: duplicate"
-							" of index: %d\n",
-							bss_idx);
-						break;
-					}
-				}
-			}
-			/*
-			 * If the bss_idx is equal to the number of entries in
-			 * the table, the new entry was not a duplicate; append
-			 * it to the scan table
-			 */
-			if (bss_idx == num_in_table) {
-				/* Range check the bss_idx, keep it limited to
-				   the last entry */
-				if (bss_idx == IW_MAX_AP)
-					bss_idx--;
-				else
-					num_in_table++;
+		/* Process the data fields and IEs returned for this BSS */
+		dev_dbg(adapter->dev, "info: SCAN_RESP: BSSID = %pM\n",
+		       bss_new_entry->mac_address);
+
+		/* Search the scan table for the same bssid */
+		for (bss_idx = 0; bss_idx < num_in_table; bss_idx++) {
+			if (memcmp(bss_new_entry->mac_address,
+				adapter->scan_table[bss_idx].mac_address,
+				sizeof(bss_new_entry->mac_address))) {
+				continue;
 			}
-
-			/*
-			 * Save the beacon/probe response returned for later
-			 * application retrieval.  Duplicate beacon/probe
-			 * responses are updated if possible
-			 */
-			mwifiex_ret_802_11_scan_store_beacon(priv, bss_idx,
-							     num_in_table,
-							     bss_new_entry);
 			/*
-			 * If the TSF TLV was appended to the scan results,
-			 * save this entry's TSF value in the networkTSF field.
-			 * The networkTSF is the firmware's TSF value at the
-			 * time the beacon or probe response was received.
+			 * If the SSID matches as well, it is a
+			 * duplicate of this entry.  Keep the bss_idx
+			 * set to this entry so we replace the old
+			 * contents in the table
 			 */
-			if (tsf_tlv) {
-				memcpy(&tsf_val,
-				       &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
-				       sizeof(tsf_val));
-				memcpy(&bss_new_entry->network_tsf,
-				       &tsf_val,
-				       sizeof(bss_new_entry->network_tsf));
-			}
-			band = BAND_G;
-			if (chan_band_tlv) {
-				chan_band =
-					&chan_band_tlv->chan_band_param[idx];
-				band = mwifiex_radio_type_to_band(
-							chan_band->radio_type &
-							(BIT(0) | BIT(1)));
+			if ((bss_new_entry->ssid.ssid_len
+				== adapter->scan_table[bss_idx]. ssid.ssid_len)
+					&& (!memcmp(bss_new_entry->ssid.ssid,
+					adapter->scan_table[bss_idx].ssid.ssid,
+					bss_new_entry->ssid.ssid_len))) {
+				dev_dbg(adapter->dev, "info: SCAN_RESP:"
+					" duplicate of index: %d\n", bss_idx);
+				break;
 			}
+		}
+		/*
+		 * If the bss_idx is equal to the number of entries in
+		 * the table, the new entry was not a duplicate; append
+		 * it to the scan table
+		 */
+		if (bss_idx == num_in_table) {
+			/* Range check the bss_idx, keep it limited to
+			   the last entry */
+			if (bss_idx == IW_MAX_AP)
+				bss_idx--;
+			else
+				num_in_table++;
+		}
 
-			/* Save the band designation for this entry for use in
-			   join */
-			bss_new_entry->bss_band = band;
-			cfp =
-			mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
-						(u8) bss_new_entry->bss_band,
-						(u16)bss_new_entry->channel);
+		/*
+		 * Save the beacon/probe response returned for later application
+		 * retrieval.  Duplicate beacon/probe responses are updated if
+		 * possible
+		 */
+		mwifiex_ret_802_11_scan_store_beacon(priv, bss_idx,
+						num_in_table, bss_new_entry);
+		/*
+		 * If the TSF TLV was appended to the scan results, save this
+		 * entry's TSF value in the networkTSF field.The networkTSF is
+		 * the firmware's TSF value at the time the beacon or probe
+		 * response was received.
+		 */
+		if (tsf_tlv) {
+			memcpy(&tsf_val, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE]
+					, sizeof(tsf_val));
+			memcpy(&bss_new_entry->network_tsf, &tsf_val,
+					sizeof(bss_new_entry->network_tsf));
+		}
+		band = BAND_G;
+		if (chan_band_tlv) {
+			chan_band = &chan_band_tlv->chan_band_param[idx];
+			band = mwifiex_radio_type_to_band(chan_band->radio_type
+					& (BIT(0) | BIT(1)));
+		}
 
-			if (cfp)
-				bss_new_entry->freq = cfp->freq;
-			else
-				bss_new_entry->freq = 0;
+		/* Save the band designation for this entry for use in join */
+		bss_new_entry->bss_band = band;
+		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
+					(u8) bss_new_entry->bss_band,
+					(u16)bss_new_entry->channel);
 
-			/* Copy the locally created bss_new_entry to the scan
-			   table */
-			memcpy(&adapter->scan_table[bss_idx], bss_new_entry,
-			       sizeof(adapter->scan_table[bss_idx]));
+		if (cfp)
+			bss_new_entry->freq = cfp->freq;
+		else
+			bss_new_entry->freq = 0;
 
-		} else {
+		/* Copy the locally created bss_new_entry to the scan table */
+		memcpy(&adapter->scan_table[bss_idx], bss_new_entry,
+		       sizeof(adapter->scan_table[bss_idx]));
 
-			/* Error parsing/interpreting the scan response,
-			   skipped */
-			dev_err(adapter->dev, "SCAN_RESP: "
-			       "mwifiex_interpret_bss_desc_with_ie "
-			       "returned ERROR\n");
-		}
 	}
 
 	dev_dbg(adapter->dev,
@@ -2735,8 +2717,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 			/* Indicate ioctl complete */
 			mwifiex_ioctl_complete(adapter,
-					       (struct mwifiex_wait_queue *)
-					       wait_queue, 0);
+			       (struct mwifiex_wait_queue *) wait_queue, 0);
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index a3b94e0..2e7e2e7 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -167,7 +167,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
 			ul_temp = *(u32 *) data_buf;
 			*((__le16 *) (snmp_mib->value)) =
-			cpu_to_le16((u16) ul_temp);
+				cpu_to_le16((u16) ul_temp);
 			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
 				+ sizeof(u16));
 		}
@@ -1024,92 +1024,85 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 	reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
 	switch (le16_to_cpu(cmd->command)) {
 	case HostCmd_CMD_MAC_REG_ACCESS:
-		{
-			struct host_cmd_ds_mac_reg_access *mac_reg;
-			cmd->size = cpu_to_le16(sizeof
-					    (struct host_cmd_ds_mac_reg_access)
-					    + S_DS_GEN);
-			mac_reg = (struct host_cmd_ds_mac_reg_access *) &cmd->
-					params.mac_reg;
-			mac_reg->action = cpu_to_le16(cmd_action);
-			mac_reg->offset =
-				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
-			mac_reg->value = reg_rw->value;
-			break;
-		}
+	{
+		struct host_cmd_ds_mac_reg_access *mac_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*mac_reg) + S_DS_GEN);
+		mac_reg = (struct host_cmd_ds_mac_reg_access *) &cmd->
+			params.mac_reg;
+		mac_reg->action = cpu_to_le16(cmd_action);
+		mac_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		mac_reg->value = reg_rw->value;
+		break;
+	}
 	case HostCmd_CMD_BBP_REG_ACCESS:
-		{
-			struct host_cmd_ds_bbp_reg_access *bbp_reg;
-			cmd->size = cpu_to_le16(sizeof
-					    (struct host_cmd_ds_bbp_reg_access)
-					    + S_DS_GEN);
-			bbp_reg = (struct host_cmd_ds_bbp_reg_access *) &cmd->
-					params.bbp_reg;
-			bbp_reg->action = cpu_to_le16(cmd_action);
-			bbp_reg->offset =
-				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
-			bbp_reg->value = (u8) le32_to_cpu(reg_rw->value);
-			break;
-		}
+	{
+		struct host_cmd_ds_bbp_reg_access *bbp_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*bbp_reg) + S_DS_GEN);
+		bbp_reg = (struct host_cmd_ds_bbp_reg_access *) &cmd->
+			params.bbp_reg;
+		bbp_reg->action = cpu_to_le16(cmd_action);
+		bbp_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		bbp_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
 	case HostCmd_CMD_RF_REG_ACCESS:
-		{
-			struct host_cmd_ds_rf_reg_access *rf_reg;
-			cmd->size = cpu_to_le16(sizeof
-					    (struct host_cmd_ds_rf_reg_access) +
-					    S_DS_GEN);
-			rf_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
-				params.rf_reg;
-			rf_reg->action = cpu_to_le16(cmd_action);
-			rf_reg->offset =
-				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
-			rf_reg->value = (u8) le32_to_cpu(reg_rw->value);
-			break;
-		}
+	{
+		struct host_cmd_ds_rf_reg_access *rf_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*rf_reg) + S_DS_GEN);
+		rf_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
+			params.rf_reg;
+		rf_reg->action = cpu_to_le16(cmd_action);
+		rf_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		rf_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
 	case HostCmd_CMD_PMIC_REG_ACCESS:
-		{
-			struct host_cmd_ds_pmic_reg_access *pmic_reg;
-			cmd->size = cpu_to_le16(sizeof
-					    (struct host_cmd_ds_pmic_reg_access)
-					    + S_DS_GEN);
-			pmic_reg = (struct host_cmd_ds_pmic_reg_access *) &cmd->
-					params.pmic_reg;
-			pmic_reg->action = cpu_to_le16(cmd_action);
-			pmic_reg->offset =
-				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
-			pmic_reg->value = (u8) le32_to_cpu(reg_rw->value);
-			break;
-		}
+	{
+		struct host_cmd_ds_pmic_reg_access *pmic_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*pmic_reg) + S_DS_GEN);
+		pmic_reg = (struct host_cmd_ds_pmic_reg_access *) &cmd->
+				params.pmic_reg;
+		pmic_reg->action = cpu_to_le16(cmd_action);
+		pmic_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		pmic_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
 	case HostCmd_CMD_CAU_REG_ACCESS:
-		{
-			struct host_cmd_ds_rf_reg_access *cau_reg;
-			cmd->size = cpu_to_le16(sizeof
-					    (struct host_cmd_ds_rf_reg_access) +
-					    S_DS_GEN);
-			cau_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
-					params.rf_reg;
-			cau_reg->action = cpu_to_le16(cmd_action);
-			cau_reg->offset =
-				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
-			cau_reg->value = (u8) le32_to_cpu(reg_rw->value);
-			break;
-		}
+	{
+		struct host_cmd_ds_rf_reg_access *cau_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*cau_reg) + S_DS_GEN);
+		cau_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
+				params.rf_reg;
+		cau_reg->action = cpu_to_le16(cmd_action);
+		cau_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		cau_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
 	case HostCmd_CMD_802_11_EEPROM_ACCESS:
-		{
-			struct mwifiex_ds_read_eeprom *rd_eeprom =
-				(struct mwifiex_ds_read_eeprom *) data_buf;
-			struct host_cmd_ds_802_11_eeprom_access *cmd_eeprom =
-				(struct host_cmd_ds_802_11_eeprom_access *)
-				&cmd->params.eeprom;
-			cmd->size = cpu_to_le16(sizeof
-					    (struct
-					     host_cmd_ds_802_11_eeprom_access) +
-					    S_DS_GEN);
-			cmd_eeprom->action = cpu_to_le16(cmd_action);
-			cmd_eeprom->offset = rd_eeprom->offset;
-			cmd_eeprom->byte_count = rd_eeprom->byte_count;
-			cmd_eeprom->value = 0;
-			break;
-		}
+	{
+		struct mwifiex_ds_read_eeprom *rd_eeprom =
+			(struct mwifiex_ds_read_eeprom *) data_buf;
+		struct host_cmd_ds_802_11_eeprom_access *cmd_eeprom =
+			(struct host_cmd_ds_802_11_eeprom_access *)
+			&cmd->params.eeprom;
+
+		cmd->size = cpu_to_le16(sizeof(*cmd_eeprom) + S_DS_GEN);
+		cmd_eeprom->action = cpu_to_le16(cmd_action);
+		cmd_eeprom->offset = rd_eeprom->offset;
+		cmd_eeprom->byte_count = rd_eeprom->byte_count;
+		cmd_eeprom->value = 0;
+		break;
+	}
 	default:
 		return -1;
 	}
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 5d3fb79..8c967cc 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -323,8 +323,7 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 		}
 
 		head = (struct mwifiex_ie_types_header *) tlv_buf;
-		tlv_buf += le16_to_cpu(head->len)
-			+ sizeof(struct mwifiex_ie_types_header);
+		tlv_buf += le16_to_cpu(head->len) + sizeof(*head);
 		tlv_buf_len -= le16_to_cpu(head->len);
 	}
 
@@ -792,10 +791,8 @@ static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 					      esupp_mode->act_groupcipher);
 				break;
 			}
-			len -= (le16_to_cpu(head->len) -
-					sizeof(struct mwifiex_ie_types_header));
-			tlv = tlv + (le16_to_cpu(head->len) +
-					sizeof(struct mwifiex_ie_types_header));
+			len -= (le16_to_cpu(head->len) - sizeof(*head));
+			tlv = tlv + (le16_to_cpu(head->len) + sizeof(*head));
 		}
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 23f00b0..a0442e2 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -646,55 +646,7 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 	u8 adhoc_band = 0;
 	u32 adhoc_channel = 0;
 
-	if (action == HostCmd_ACT_GEN_SET) {
-		infra_band = (u8) radio_cfg->config_bands;
-		adhoc_band = (u8) radio_cfg->adhoc_start_band;
-		adhoc_channel = radio_cfg->adhoc_channel;
-
-		/* SET Infra band */
-		if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands)
-			return -1;
-
-		adapter->config_bands = infra_band;
-
-		/* SET Ad-hoc Band */
-		if ((adhoc_band | adapter->fw_bands) & ~adapter->fw_bands)
-			return -1;
-
-		if (adhoc_band)
-			adapter->adhoc_start_band = adhoc_band;
-		adapter->chan_offset =
-			(u8) radio_cfg->sec_chan_offset;
-		/*
-		 * If no adhoc_channel is supplied verify if the existing adhoc
-		 * channel compiles with new adhoc_band
-		 */
-		if (!adhoc_channel) {
-			if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-			     (priv, adapter->adhoc_start_band,
-			     priv->adhoc_channel)) {
-				/* Pass back the default channel */
-				radio_cfg->adhoc_channel =
-					DEFAULT_AD_HOC_CHANNEL;
-				if ((adapter->adhoc_start_band & BAND_A)
-				    || (adapter->adhoc_start_band & BAND_AN))
-					radio_cfg->adhoc_channel =
-						DEFAULT_AD_HOC_CHANNEL_A;
-			}
-		} else {	/* Retrurn error if adhoc_band and
-				   adhoc_channel combination is invalid */
-			if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-			    (priv, adapter->adhoc_start_band,
-			     (u16) adhoc_channel))
-				return -1;
-			priv->adhoc_channel = (u8) adhoc_channel;
-		}
-		if ((adhoc_band & BAND_GN)
-		    || (adhoc_band & BAND_AN))
-			adapter->adhoc_11n_enabled = true;
-		else
-			adapter->adhoc_11n_enabled = false;
-	} else {
+	if (action == HostCmd_ACT_GEN_GET) {
 		/* Infra Bands */
 		radio_cfg->config_bands = adapter->config_bands;
 		/* Adhoc Band */
@@ -703,7 +655,53 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 		radio_cfg->adhoc_channel = priv->adhoc_channel;
 		/* Secondary channel offset */
 		radio_cfg->sec_chan_offset = adapter->chan_offset;
+		return 0;
+	}
+
+	/* For action = SET */
+	infra_band = (u8) radio_cfg->config_bands;
+	adhoc_band = (u8) radio_cfg->adhoc_start_band;
+	adhoc_channel = radio_cfg->adhoc_channel;
+
+	/* SET Infra band */
+	if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands)
+		return -1;
+
+	adapter->config_bands = infra_band;
+
+	/* SET Ad-hoc Band */
+	if ((adhoc_band | adapter->fw_bands) & ~adapter->fw_bands)
+		return -1;
+
+	if (adhoc_band)
+		adapter->adhoc_start_band = adhoc_band;
+	adapter->chan_offset = (u8) radio_cfg->sec_chan_offset;
+	/*
+	 * If no adhoc_channel is supplied verify if the existing adhoc
+	 * channel compiles with new adhoc_band
+	 */
+	if (!adhoc_channel) {
+		if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+		     (priv, adapter->adhoc_start_band,
+		     priv->adhoc_channel)) {
+			/* Pass back the default channel */
+			radio_cfg->adhoc_channel = DEFAULT_AD_HOC_CHANNEL;
+			if ((adapter->adhoc_start_band & BAND_A)
+			    || (adapter->adhoc_start_band & BAND_AN))
+				radio_cfg->adhoc_channel =
+					DEFAULT_AD_HOC_CHANNEL_A;
+		}
+	} else {	/* Retrurn error if adhoc_band and
+			   adhoc_channel combination is invalid */
+		if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+		    (priv, adapter->adhoc_start_band, (u16) adhoc_channel))
+			return -1;
+		priv->adhoc_channel = (u8) adhoc_channel;
 	}
+	if ((adhoc_band & BAND_GN) || (adhoc_band & BAND_AN))
+		adapter->adhoc_11n_enabled = true;
+	else
+		adapter->adhoc_11n_enabled = false;
 
 	return 0;
 }
@@ -863,12 +861,9 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 
 	if (action == HostCmd_ACT_GEN_GET) {
 		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
-							   priv->
-							   curr_bss_params.band,
-							   (u16) priv->
-							   curr_bss_params.
-							   bss_descriptor.
-							   channel);
+				priv->curr_bss_params.band,
+				(u16) priv->curr_bss_params.bss_descriptor.
+					channel);
 		chan->channel = cfp->channel;
 		chan->freq = cfp->freq;
 
@@ -883,16 +878,14 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 	if (chan->channel) {
 		if (chan->channel <= MAX_CHANNEL_BAND_BG)
 			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-							(priv, 0,
-							(u16) chan->channel);
+					(priv, 0, (u16) chan->channel);
 		if (!cfp) {
 			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-							(priv, BAND_A,
-							(u16) chan->channel);
+					(priv, BAND_A, (u16) chan->channel);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
-					adapter->adhoc_start_band =
-						BAND_A | BAND_AN;
+					adapter->adhoc_start_band = BAND_A
+						| BAND_AN;
 				else
 					adapter->adhoc_start_band = BAND_A;
 			}
@@ -906,8 +899,8 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 						  (priv, BAND_A, chan->freq);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
-					adapter->adhoc_start_band =
-						BAND_A | BAND_AN;
+					adapter->adhoc_start_band = BAND_A
+						| BAND_AN;
 				else
 					adapter->adhoc_start_band = BAND_A;
 			}
@@ -995,28 +988,24 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 
 		/* Search for the requested SSID in the scan table */
 		if (ssid_bssid->ssid.ssid_len)
-			i = mwifiex_find_ssid_in_list(priv,
-						      &ssid_bssid->ssid, NULL,
-						      MWIFIEX_BSS_MODE_INFRA);
+			i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid,
+						NULL, MWIFIEX_BSS_MODE_INFRA);
 		else
 			i = mwifiex_find_bssid_in_list(priv,
 						(u8 *) &ssid_bssid->bssid,
 						MWIFIEX_BSS_MODE_INFRA);
-
-		if (i >= 0) {
-			dev_dbg(adapter->dev,
-				"info: SSID found in scan list ... associating...\n");
-
-			/* Clear any past association response stored for
-			   application retrieval */
-			priv->assoc_rsp_size = 0;
-			ret = mwifiex_associate(priv, wait,
-						&adapter->scan_table[i]);
-			if (ret)
-				return ret;
-		} else {	/* i >= 0 */
+		if (i < 0)
 			return -1;
-		}
+
+		dev_dbg(adapter->dev,
+			"info: SSID found in scan list ... associating...\n");
+
+		/* Clear any past association response stored for
+		 * application retrieval */
+		priv->assoc_rsp_size = 0;
+		ret = mwifiex_associate(priv, wait, &adapter->scan_table[i]);
+		if (ret)
+			return ret;
 	} else {
 		/* Adhoc mode */
 		/* If the requested SSID matches current SSID, return */
@@ -3459,60 +3448,57 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 	if (!ie_len) {
 		priv->gen_ie_buf_len = 0;
 		priv->wps.session_enable = false;
+
+		return 0;
 	} else if (!ie_data_ptr) {
-		ret = -1;
-	} else {
-		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
-		/* Test to see if it is a WPA IE, if not, then it is a gen IE */
-		if (((pvendor_ie->element_id == WLAN_EID_WPA)
-		     && (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui))))
-		    || (pvendor_ie->element_id == WLAN_EID_RSN)
-			) {
+		return -1;
+	}
+	pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
+	/* Test to see if it is a WPA IE, if not, then it is a gen IE */
+	if (((pvendor_ie->element_id == WLAN_EID_WPA)
+	     && (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui))))
+			|| (pvendor_ie->element_id == WLAN_EID_RSN)) {
 
-			/* IE is a WPA/WPA2 IE so call set_wpa function */
-			ret = mwifiex_set_wpa_ie_helper(priv, ie_data_ptr,
-							ie_len);
-			priv->wps.session_enable = false;
-		} else if (pvendor_ie->element_id ==
-				WLAN_EID_BSS_AC_ACCESS_DELAY) {
-			/* IE is a WAPI IE so call set_wapi function */
-			ret = mwifiex_set_wapi_ie(priv, ie_data_ptr, ie_len);
-		} else {
-			/*
-			 * Verify that the passed length is not larger than the
-			 * available space remaining in the buffer
-			 */
-			if (ie_len <
-			    (sizeof(priv->gen_ie_buf) - priv->gen_ie_buf_len)) {
-
-				/* Test to see if it is a WPS IE, if so, enable
-				 * wps session flag
-				 */
-				pvendor_ie = (struct
-					      ieee_types_vendor_header
-					      *) ie_data_ptr;
-				if ((pvendor_ie->element_id ==
-						WLAN_EID_VENDOR_SPECIFIC)
-						&& (!memcmp(pvendor_ie->oui,
-						wps_oui, sizeof(wps_oui)))) {
-					priv->wps.session_enable = true;
-					dev_dbg(priv->adapter->dev,
-						"info: WPS Session Enabled.\n");
-				}
+		/* IE is a WPA/WPA2 IE so call set_wpa function */
+		ret = mwifiex_set_wpa_ie_helper(priv, ie_data_ptr, ie_len);
+		priv->wps.session_enable = false;
 
-				/* Append the passed data to the end of the
-				   genIeBuffer */
-				memcpy(priv->gen_ie_buf + priv->gen_ie_buf_len,
-				       ie_data_ptr, ie_len);
-				/* Increment the stored buffer length by the
-				   size passed */
-				priv->gen_ie_buf_len += ie_len;
-			} else {
-				/* Passed data does not fit in the remaining
-				   buffer space */
-				ret = -1;
-			}
+		return ret;
+	} else if (pvendor_ie->element_id == WLAN_EID_BSS_AC_ACCESS_DELAY) {
+		/* IE is a WAPI IE so call set_wapi function */
+		ret = mwifiex_set_wapi_ie(priv, ie_data_ptr, ie_len);
+
+		return ret;
+	}
+	/*
+	 * Verify that the passed length is not larger than the
+	 * available space remaining in the buffer
+	 */
+	if (ie_len < (sizeof(priv->gen_ie_buf) - priv->gen_ie_buf_len)) {
+
+		/* Test to see if it is a WPS IE, if so, enable
+		 * wps session flag
+		 */
+		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
+		if ((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC)
+				&& (!memcmp(pvendor_ie->oui, wps_oui,
+						sizeof(wps_oui)))) {
+			priv->wps.session_enable = true;
+			dev_dbg(priv->adapter->dev,
+				"info: WPS Session Enabled.\n");
 		}
+
+		/* Append the passed data to the end of the
+		   genIeBuffer */
+		memcpy(priv->gen_ie_buf + priv->gen_ie_buf_len, ie_data_ptr,
+									ie_len);
+		/* Increment the stored buffer length by the
+		   size passed */
+		priv->gen_ie_buf_len += ie_len;
+	} else {
+		/* Passed data does not fit in the remaining
+		   buffer space */
+		ret = -1;
 	}
 
 	/* Return 0, or -1 for error case */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index a42751f..7cda4f2 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -332,7 +332,8 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 {
 	int ac_val;
 
-	dev_dbg(priv->adapter->dev, "info: WMM: AC Priorities: BK(0), BE(1), VI(2), VO(3)\n");
+	dev_dbg(priv->adapter->dev, "info: WMM: AC Priorities:"
+			"BK(0), BE(1), VI(2), VO(3)\n");
 
 	if (!priv->wmm_enabled) {
 		/* WMM is not enabled, default priorities */
@@ -409,34 +410,28 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 
 	for (j = 0; j < adapter->priv_num; ++j) {
 		priv = adapter->priv[j];
-		if (priv) {
-			for (i = 0; i < MAX_NUM_TID; ++i) {
-				priv->aggr_prio_tbl[i].amsdu =
-					tos_to_tid_inv[i];
-				priv->aggr_prio_tbl[i].ampdu_ap =
-					priv->aggr_prio_tbl[i].ampdu_user =
-					tos_to_tid_inv[i];
-
-				priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
-			}
+		if (!priv)
+			continue;
 
-			priv->aggr_prio_tbl[6].amsdu =
-				priv->aggr_prio_tbl[6].ampdu_ap =
-				priv->aggr_prio_tbl[6].ampdu_user =
-				BA_STREAM_NOT_ALLOWED;
-
-			priv->aggr_prio_tbl[7].amsdu =
-				priv->aggr_prio_tbl[7].ampdu_ap =
-				priv->aggr_prio_tbl[7].ampdu_user =
-				BA_STREAM_NOT_ALLOWED;
-
-			priv->add_ba_param.timeout =
-				MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
-			priv->add_ba_param.tx_win_size =
-				MWIFIEX_AMPDU_DEF_TXWINSIZE;
-			priv->add_ba_param.rx_win_size =
-				MWIFIEX_AMPDU_DEF_RXWINSIZE;
+		for (i = 0; i < MAX_NUM_TID; ++i) {
+			priv->aggr_prio_tbl[i].amsdu = tos_to_tid_inv[i];
+			priv->aggr_prio_tbl[i].ampdu_ap = tos_to_tid_inv[i];
+			priv->aggr_prio_tbl[i].ampdu_user = tos_to_tid_inv[i];
+			priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
 		}
+
+		priv->aggr_prio_tbl[6].amsdu
+			= priv->aggr_prio_tbl[6].ampdu_ap
+			= priv->aggr_prio_tbl[6].ampdu_user
+			= BA_STREAM_NOT_ALLOWED;
+
+		priv->aggr_prio_tbl[7].amsdu = priv->aggr_prio_tbl[7].ampdu_ap
+			= priv->aggr_prio_tbl[7].ampdu_user
+			= BA_STREAM_NOT_ALLOWED;
+
+		priv->add_ba_param.timeout = MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
+		priv->add_ba_param.tx_win_size = MWIFIEX_AMPDU_DEF_TXWINSIZE;
+		priv->add_ba_param.rx_win_size = MWIFIEX_AMPDU_DEF_RXWINSIZE;
 	}
 }
 
@@ -476,9 +471,8 @@ mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct sk_buff *skb, *tmp;
 
-	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp) {
+	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp)
 		mwifiex_write_data_complete(adapter, skb, -1);
-	}
 }
 
 /*
@@ -629,11 +623,9 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	   have only 1 raptr for a tid in case of infra */
 	if (!mwifiex_queuing_ra_based(priv)) {
 		if (!list_empty(&priv->wmm.tid_tbl_ptr[tid_down].ra_list))
-			ra_list = list_first_entry(&priv->wmm
-						   .tid_tbl_ptr[tid_down]
-						   .ra_list,
-						   struct mwifiex_ra_list_tbl,
-						   list);
+			ra_list = list_first_entry(
+				&priv->wmm.tid_tbl_ptr[tid_down].ra_list,
+				struct mwifiex_ra_list_tbl, list);
 		else
 			ra_list = NULL;
 	} else {
@@ -769,8 +761,9 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 	if (!wmm_ie)
 		return 0;
 
-	dev_dbg(priv->adapter->dev, "info: WMM: process assoc req: bss->wmmIe=0x%x\n",
-	       wmm_ie->vend_hdr.element_id);
+	dev_dbg(priv->adapter->dev, "info: WMM: process assoc req:"
+			"bss->wmmIe=0x%x\n",
+			wmm_ie->vend_hdr.element_id);
 
 	if ((priv->wmm_required
 	     || (ht_cap && (priv->adapter->config_bands & BAND_GN
@@ -782,8 +775,7 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 		wmm_tlv->header.len = cpu_to_le16((u16) wmm_info_ie[1]);
 		memcpy(wmm_tlv->wmm_ie, &wmm_info_ie[2],
 			le16_to_cpu(wmm_tlv->header.len));
-		if (wmm_ie->qos_info_bitmap &
-				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD)
+		if (wmm_ie->qos_info_bitmap & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD)
 			memcpy((u8 *) (wmm_tlv->wmm_ie
 					+ le16_to_cpu(wmm_tlv->header.len)
 					 - sizeof(priv->wmm_qosinfo)),
-- 
1.7.0.2


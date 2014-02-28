Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8739 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaB1Dfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/9] mwifiex: remove global variable cmd_wait_q_required
Date: Thu, 27 Feb 2014 19:35:12 -0800
Message-ID: <1393558513-854-1-git-send-email-bzhao@marvell.com> (sfid-20140228_043549_730773_9D24AE17)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race condition while queuing synchronous command and
asynchronous command requested from different threads, because
the wait_q_enabled flag is set based on a global variable
cmd_wait_q_required.

The issue is fixed by removing this global variable and using a
unified function with an argument 'sync' passed into the
function.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c           |   4 +-
 drivers/net/wireless/mwifiex/11n.c           |   8 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   2 +-
 drivers/net/wireless/mwifiex/cfg80211.c      | 167 +++++++++++++--------------
 drivers/net/wireless/mwifiex/cmdevt.c        |  36 ++----
 drivers/net/wireless/mwifiex/ie.c            |   6 +-
 drivers/net/wireless/mwifiex/join.c          |  37 +++---
 drivers/net/wireless/mwifiex/main.c          |   5 +-
 drivers/net/wireless/mwifiex/main.h          |   8 +-
 drivers/net/wireless/mwifiex/scan.c          |   4 +-
 drivers/net/wireless/mwifiex/sta_cmd.c       |  84 +++++++-------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   9 +-
 drivers/net/wireless/mwifiex/sta_event.c     |  38 +++---
 drivers/net/wireless/mwifiex/sta_ioctl.c     | 117 +++++++++----------
 drivers/net/wireless/mwifiex/tdls.c          |  16 +--
 drivers/net/wireless/mwifiex/uap_cmd.c       |   4 +-
 drivers/net/wireless/mwifiex/uap_event.c     |   6 +-
 drivers/net/wireless/mwifiex/util.c          |   2 +-
 18 files changed, 255 insertions(+), 298 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index 8d68307..e76b0db 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -73,8 +73,8 @@ static int mwifiex_11h_activate(struct mwifiex_private *priv, bool flag)
 {
 	u32 enable = flag;
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-				     HostCmd_ACT_GEN_SET, DOT11H_I, &enable);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				HostCmd_ACT_GEN_SET, DOT11H_I, &enable, true);
 }
 
 /* This functions processes TLV buffer for a pending BSS Join command.
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 37677af..79ead92 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -574,8 +574,8 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	memcpy(&add_ba_req.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_ADDBA_REQ,
-				     0, 0, &add_ba_req);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_11N_ADDBA_REQ,
+			       0, 0, &add_ba_req, false);
 
 	return ret;
 }
@@ -602,8 +602,8 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_DELBA,
-				     HostCmd_ACT_GEN_SET, 0, &delba);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_11N_DELBA,
+			       HostCmd_ACT_GEN_SET, 0, &delba, false);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index eb17282..48aee91 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -635,7 +635,7 @@ void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 	delba.del_ba_param_set |= cpu_to_le16(
 		(u16) event->origninator << DELBA_INITIATOR_POS);
 	delba.reason_code = cpu_to_le16(WLAN_REASON_QSTA_TIMEOUT);
-	mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_DELBA, 0, 0, &delba);
+	mwifiex_send_cmd(priv, HostCmd_CMD_11N_DELBA, 0, 0, &delba, false);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 68c51a8..bfe9316 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -252,9 +252,9 @@ mwifiex_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
 
 	if (mask != priv->mgmt_frame_mask) {
 		priv->mgmt_frame_mask = mask;
-		mwifiex_send_cmd_async(priv, HostCmd_CMD_MGMT_FRAME_REG,
-				       HostCmd_ACT_GEN_SET, 0,
-				       &priv->mgmt_frame_mask);
+		mwifiex_send_cmd(priv, HostCmd_CMD_MGMT_FRAME_REG,
+				 HostCmd_ACT_GEN_SET, 0,
+				 &priv->mgmt_frame_mask, false);
 		wiphy_dbg(wiphy, "info: mgmt frame registered\n");
 	}
 }
@@ -515,8 +515,8 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
-	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
-				   HostCmd_ACT_GEN_SET, 0, NULL)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
+			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
 		wiphy_err(wiphy, "11D: setting domain info in FW\n");
 		return -1;
 	}
@@ -580,9 +580,9 @@ mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 	    frag_thr > MWIFIEX_FRAG_MAX_VALUE)
 		frag_thr = MWIFIEX_FRAG_MAX_VALUE;
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-				     HostCmd_ACT_GEN_SET, FRAG_THRESH_I,
-				     &frag_thr);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				HostCmd_ACT_GEN_SET, FRAG_THRESH_I,
+				&frag_thr, true);
 }
 
 /*
@@ -597,9 +597,9 @@ mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 	if (rts_thr < MWIFIEX_RTS_MIN_VALUE || rts_thr > MWIFIEX_RTS_MAX_VALUE)
 		rts_thr = MWIFIEX_RTS_MAX_VALUE;
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-				    HostCmd_ACT_GEN_SET, RTS_THRESH_I,
-				    &rts_thr);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				HostCmd_ACT_GEN_SET, RTS_THRESH_I,
+				&rts_thr, true);
 }
 
 /*
@@ -637,20 +637,19 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 			bss_started = priv->bss_started;
 
-			ret = mwifiex_send_cmd_sync(priv,
-						    HostCmd_CMD_UAP_BSS_STOP,
-						    HostCmd_ACT_GEN_SET, 0,
-						    NULL);
+			ret = mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
+					       HostCmd_ACT_GEN_SET, 0,
+					       NULL, true);
 			if (ret) {
 				wiphy_err(wiphy, "Failed to stop the BSS\n");
 				kfree(bss_cfg);
 				return ret;
 			}
 
-			ret = mwifiex_send_cmd_async(priv,
-						     HostCmd_CMD_UAP_SYS_CONFIG,
-						     HostCmd_ACT_GEN_SET,
-						     UAP_BSS_PARAMS_I, bss_cfg);
+			ret = mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+					       HostCmd_ACT_GEN_SET,
+					       UAP_BSS_PARAMS_I, bss_cfg,
+					       false);
 
 			kfree(bss_cfg);
 
@@ -662,10 +661,9 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 			if (!bss_started)
 				break;
 
-			ret = mwifiex_send_cmd_async(priv,
-						     HostCmd_CMD_UAP_BSS_START,
-						     HostCmd_ACT_GEN_SET, 0,
-						     NULL);
+			ret = mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
+					       HostCmd_ACT_GEN_SET, 0,
+					       NULL, false);
 			if (ret) {
 				wiphy_err(wiphy, "Failed to start BSS\n");
 				return ret;
@@ -700,8 +698,8 @@ mwifiex_cfg80211_deinit_p2p(struct mwifiex_private *priv)
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA)
 		mwifiex_set_bss_role(priv, MWIFIEX_BSS_ROLE_STA);
 
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
-				  HostCmd_ACT_GEN_SET, 0, &mode))
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_P2P_MODE_CFG,
+			     HostCmd_ACT_GEN_SET, 0, &mode, true))
 		return -1;
 
 	return 0;
@@ -721,13 +719,13 @@ mwifiex_cfg80211_init_p2p_client(struct mwifiex_private *priv)
 		return -1;
 
 	mode = P2P_MODE_DEVICE;
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
-				  HostCmd_ACT_GEN_SET, 0, &mode))
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_P2P_MODE_CFG,
+			     HostCmd_ACT_GEN_SET, 0, &mode, true))
 		return -1;
 
 	mode = P2P_MODE_CLIENT;
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
-				  HostCmd_ACT_GEN_SET, 0, &mode))
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_P2P_MODE_CFG,
+			     HostCmd_ACT_GEN_SET, 0, &mode, true))
 		return -1;
 
 	return 0;
@@ -747,13 +745,13 @@ mwifiex_cfg80211_init_p2p_go(struct mwifiex_private *priv)
 		return -1;
 
 	mode = P2P_MODE_DEVICE;
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
-				  HostCmd_ACT_GEN_SET, 0, &mode))
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_P2P_MODE_CFG,
+			     HostCmd_ACT_GEN_SET, 0, &mode, true))
 		return -1;
 
 	mode = P2P_MODE_GO;
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_P2P_MODE_CFG,
-				  HostCmd_ACT_GEN_SET, 0, &mode))
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_P2P_MODE_CFG,
+			     HostCmd_ACT_GEN_SET, 0, &mode, true))
 		return -1;
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP)
@@ -853,8 +851,8 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 
 	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_SET_BSS_MODE,
-				    HostCmd_ACT_GEN_SET, 0, NULL);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+			       HostCmd_ACT_GEN_SET, 0, NULL, true);
 
 	return ret;
 }
@@ -942,8 +940,8 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 			STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
 
 	/* Get signal information from the firmware */
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_RSSI_INFO,
-				  HostCmd_ACT_GEN_GET, 0, NULL)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
+			     HostCmd_ACT_GEN_GET, 0, NULL, true)) {
 		dev_err(priv->adapter->dev, "failed to get signal information\n");
 		return -EFAULT;
 	}
@@ -954,9 +952,9 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	}
 
 	/* Get DTIM period information from firmware */
-	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-			      HostCmd_ACT_GEN_GET, DTIM_PERIOD_I,
-			      &priv->dtim_period);
+	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			 HostCmd_ACT_GEN_GET, DTIM_PERIOD_I,
+			 &priv->dtim_period, true);
 
 	mwifiex_parse_htinfo(priv, priv->tx_htinfo, &sinfo->txrate);
 
@@ -1186,8 +1184,8 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 	if (priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2)
 		bitmap_rates[2] |= mask->control[band].ht_mcs[1] << 8;
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
-				     HostCmd_ACT_GEN_SET, 0, bitmap_rates);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
+				HostCmd_ACT_GEN_SET, 0, bitmap_rates, true);
 }
 
 /*
@@ -1216,14 +1214,14 @@ static int mwifiex_cfg80211_set_cqm_rssi_config(struct wiphy *wiphy,
 		subsc_evt.bcn_h_rssi_cfg.abs_value = abs(rssi_thold);
 		subsc_evt.bcn_l_rssi_cfg.evt_freq = 1;
 		subsc_evt.bcn_h_rssi_cfg.evt_freq = 1;
-		return mwifiex_send_cmd_sync(priv,
-					     HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
-					     0, 0, &subsc_evt);
+		return mwifiex_send_cmd(priv,
+					HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
+					0, 0, &subsc_evt, true);
 	} else {
 		subsc_evt.action = HostCmd_ACT_BITWISE_CLR;
-		return mwifiex_send_cmd_sync(priv,
-					     HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
-					     0, 0, &subsc_evt);
+		return mwifiex_send_cmd(priv,
+					HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
+					0, 0, &subsc_evt, true);
 	}
 
 	return 0;
@@ -1276,10 +1274,9 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 	if (!mac || is_broadcast_ether_addr(mac)) {
 		wiphy_dbg(wiphy, "%s: NULL/broadcast mac address\n", __func__);
 		list_for_each_entry(sta_node, &priv->sta_list, list) {
-			if (mwifiex_send_cmd_sync(priv,
-						  HostCmd_CMD_UAP_STA_DEAUTH,
-						  HostCmd_ACT_GEN_SET, 0,
-						  sta_node->mac_addr))
+			if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH,
+					     HostCmd_ACT_GEN_SET, 0,
+					     sta_node->mac_addr, true))
 				return -1;
 			mwifiex_uap_del_sta_data(priv, sta_node);
 		}
@@ -1289,10 +1286,9 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 		sta_node = mwifiex_get_sta_entry(priv, mac);
 		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		if (sta_node) {
-			if (mwifiex_send_cmd_sync(priv,
-						  HostCmd_CMD_UAP_STA_DEAUTH,
-						  HostCmd_ACT_GEN_SET, 0,
-						  sta_node->mac_addr))
+			if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH,
+					     HostCmd_ACT_GEN_SET, 0,
+					     sta_node->mac_addr, true))
 				return -1;
 			mwifiex_uap_del_sta_data(priv, sta_node);
 		}
@@ -1333,8 +1329,8 @@ mwifiex_cfg80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
 	ant_cfg.tx_ant = tx_ant;
 	ant_cfg.rx_ant = rx_ant;
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_RF_ANTENNA,
-				     HostCmd_ACT_GEN_SET, 0, &ant_cfg);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_RF_ANTENNA,
+				HostCmd_ACT_GEN_SET, 0, &ant_cfg, true);
 }
 
 /* cfg80211 operation handler for stop ap.
@@ -1349,8 +1345,8 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	priv->ap_11n_enabled = 0;
 
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
-				  HostCmd_ACT_GEN_SET, 0, NULL)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
 		wiphy_err(wiphy, "Failed to stop the BSS\n");
 		return -1;
 	}
@@ -1461,16 +1457,16 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		bss_cfg->ps_sta_ao_timer = 10 * params->inactivity_timeout;
 	}
 
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
-				  HostCmd_ACT_GEN_SET, 0, NULL)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
 		wiphy_err(wiphy, "Failed to stop the BSS\n");
 		kfree(bss_cfg);
 		return -1;
 	}
 
-	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
-				   HostCmd_ACT_GEN_SET,
-				   UAP_BSS_PARAMS_I, bss_cfg)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+			     HostCmd_ACT_GEN_SET,
+			     UAP_BSS_PARAMS_I, bss_cfg, false)) {
 		wiphy_err(wiphy, "Failed to set the SSID\n");
 		kfree(bss_cfg);
 		return -1;
@@ -1478,8 +1474,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	kfree(bss_cfg);
 
-	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_BSS_START,
-				   HostCmd_ACT_GEN_SET, 0, NULL)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
+			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
 		wiphy_err(wiphy, "Failed to start the BSS\n");
 		return -1;
 	}
@@ -1489,9 +1485,9 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	else
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
 
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_MAC_CONTROL,
-				  HostCmd_ACT_GEN_SET, 0,
-				  &priv->curr_pkt_filter))
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+			     HostCmd_ACT_GEN_SET, 0,
+			     &priv->curr_pkt_filter, true))
 		return -1;
 
 	return 0;
@@ -2459,9 +2455,8 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 				   MWIFIEX_CRITERIA_UNICAST |
 				   MWIFIEX_CRITERIA_MULTICAST;
 
-	ret =  mwifiex_send_cmd_sync(priv, HostCmd_CMD_MEF_CFG,
-				     HostCmd_ACT_GEN_SET, 0,
-				     &mef_cfg);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_MEF_CFG,
+			       HostCmd_ACT_GEN_SET, 0, &mef_cfg, true);
 
 	kfree(mef_entry);
 	return ret;
@@ -2573,9 +2568,9 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 	if (!coalesce) {
 		dev_dbg(adapter->dev,
 			"Disable coalesce and reset all previous rules\n");
-		return mwifiex_send_cmd_sync(priv, HostCmd_CMD_COALESCE_CFG,
-					     HostCmd_ACT_GEN_SET, 0,
-					     &coalesce_cfg);
+		return mwifiex_send_cmd(priv, HostCmd_CMD_COALESCE_CFG,
+					HostCmd_ACT_GEN_SET, 0,
+					&coalesce_cfg, true);
 	}
 
 	coalesce_cfg.num_of_rules = coalesce->n_rules;
@@ -2590,8 +2585,8 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 		}
 	}
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_COALESCE_CFG,
-				     HostCmd_ACT_GEN_SET, 0, &coalesce_cfg);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_COALESCE_CFG,
+				HostCmd_ACT_GEN_SET, 0, &coalesce_cfg, true);
 }
 
 /* cfg80211 ops handler for tdls_mgmt.
@@ -2940,17 +2935,17 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				   country_code);
 	}
 
-	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-			      HostCmd_ACT_GEN_GET, FRAG_THRESH_I, &thr);
+	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			 HostCmd_ACT_GEN_GET, FRAG_THRESH_I, &thr, true);
 	wiphy->frag_threshold = thr;
-	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-			      HostCmd_ACT_GEN_GET, RTS_THRESH_I, &thr);
+	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			 HostCmd_ACT_GEN_GET, RTS_THRESH_I, &thr, true);
 	wiphy->rts_threshold = thr;
-	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-			      HostCmd_ACT_GEN_GET, SHORT_RETRY_LIM_I, &retry);
+	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			 HostCmd_ACT_GEN_GET, SHORT_RETRY_LIM_I, &retry, true);
 	wiphy->retry_short = (u8) retry;
-	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-			      HostCmd_ACT_GEN_GET, LONG_RETRY_LIM_I, &retry);
+	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			 HostCmd_ACT_GEN_GET, LONG_RETRY_LIM_I, &retry, true);
 	wiphy->retry_long = (u8) retry;
 
 	adapter->wiphy = wiphy;
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index f4faeaf..64e708b 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -37,13 +37,12 @@
 static void
 mwifiex_init_cmd_node(struct mwifiex_private *priv,
 		      struct cmd_ctrl_node *cmd_node,
-		      u32 cmd_oid, void *data_buf)
+		      u32 cmd_oid, void *data_buf, bool sync)
 {
 	cmd_node->priv = priv;
 	cmd_node->cmd_oid = cmd_oid;
-	if (priv->adapter->cmd_wait_q_required) {
-		cmd_node->wait_q_enabled = priv->adapter->cmd_wait_q_required;
-		priv->adapter->cmd_wait_q_required = false;
+	if (sync) {
+		cmd_node->wait_q_enabled = true;
 		cmd_node->cmd_wait_q_woken = false;
 		cmd_node->condition = &cmd_node->cmd_wait_q_woken;
 	}
@@ -480,28 +479,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function is used to send synchronous command to the firmware.
- *
- * it allocates a wait queue for the command and wait for the command
- * response.
- */
-int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
-			  u16 cmd_action, u32 cmd_oid, void *data_buf)
-{
-	int ret = 0;
-	struct mwifiex_adapter *adapter = priv->adapter;
-
-	adapter->cmd_wait_q_required = true;
-
-	ret = mwifiex_send_cmd_async(priv, cmd_no, cmd_action, cmd_oid,
-				     data_buf);
-
-	return ret;
-}
-
-
-/*
- * This function prepares a command and asynchronously send it to the firmware.
+ * This function prepares a command and send it to the firmware.
  *
  * Preparation includes -
  *      - Sanity tests to make sure the card is still present or the FW
@@ -511,8 +489,8 @@ int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
  *      - Fill up the non-default parameters and buffer pointers
  *      - Add the command to pending queue
  */
-int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
-			   u16 cmd_action, u32 cmd_oid, void *data_buf)
+int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
+		     u16 cmd_action, u32 cmd_oid, void *data_buf, bool sync)
 {
 	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -550,7 +528,7 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 	}
 
 	/* Initialize the command node */
-	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, data_buf);
+	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, data_buf, sync);
 
 	if (!cmd_node->cmd_skb) {
 		dev_err(adapter->dev, "PREP_CMD: no free cmd buf\n");
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 81ac001..3bf3d58 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -138,9 +138,9 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 	}
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
-		return mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
-					      HostCmd_ACT_GEN_SET,
-					      UAP_CUSTOM_IE_I, ie_list);
+		return mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+					HostCmd_ACT_GEN_SET,
+					UAP_CUSTOM_IE_I, ie_list, false);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 34472ea..e9bd435 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -901,9 +901,9 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	mwifiex_get_active_data_rates(priv, adhoc_start->data_rate);
 	if ((adapter->adhoc_start_band & BAND_G) &&
 	    (priv->curr_pkt_filter & HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON)) {
-		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
-					   HostCmd_ACT_GEN_SET, 0,
-					   &priv->curr_pkt_filter)) {
+		if (mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+				     HostCmd_ACT_GEN_SET, 0,
+				     &priv->curr_pkt_filter, false)) {
 			dev_err(adapter->dev,
 				"ADHOC_S_CMD: G Protection config failed\n");
 			return -1;
@@ -1073,9 +1073,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			priv->
 			curr_pkt_filter | HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON;
 
-		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
-					   HostCmd_ACT_GEN_SET, 0,
-					   &curr_pkt_filter)) {
+		if (mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+				     HostCmd_ACT_GEN_SET, 0,
+				     &curr_pkt_filter, false)) {
 			dev_err(priv->adapter->dev,
 				"ADHOC_J_CMD: G Protection config failed\n");
 			return -1;
@@ -1312,8 +1312,8 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	   retrieval */
 	priv->assoc_rsp_size = 0;
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_ASSOCIATE,
-				    HostCmd_ACT_GEN_SET, 0, bss_desc);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_ASSOCIATE,
+				HostCmd_ACT_GEN_SET, 0, bss_desc, true);
 }
 
 /*
@@ -1338,8 +1338,8 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 	else
 		mwifiex_set_ba_params(priv);
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_START,
-				    HostCmd_ACT_GEN_SET, 0, adhoc_ssid);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_AD_HOC_START,
+				HostCmd_ACT_GEN_SET, 0, adhoc_ssid, true);
 }
 
 /*
@@ -1383,8 +1383,8 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
 		priv->curr_bss_params.band);
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
-				    HostCmd_ACT_GEN_SET, 0, bss_desc);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
+				HostCmd_ACT_GEN_SET, 0, bss_desc, true);
 }
 
 /*
@@ -1403,8 +1403,8 @@ static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv, u8 *mac)
 	else
 		memcpy(mac_address, mac, ETH_ALEN);
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
-				    HostCmd_ACT_GEN_SET, 0, mac_address);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
+			       HostCmd_ACT_GEN_SET, 0, mac_address, true);
 
 	return ret;
 }
@@ -1432,12 +1432,11 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 					      GFP_KERNEL);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		return mwifiex_send_cmd_sync(priv,
-					     HostCmd_CMD_802_11_AD_HOC_STOP,
-					     HostCmd_ACT_GEN_SET, 0, NULL);
+		return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_AD_HOC_STOP,
+					HostCmd_ACT_GEN_SET, 0, NULL, true);
 	case NL80211_IFTYPE_AP:
-		return mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
-					     HostCmd_ACT_GEN_SET, 0, NULL);
+		return mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
+					HostCmd_ACT_GEN_SET, 0, NULL, true);
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 7a78647..7b4502f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -678,8 +678,8 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
 
 	/* Send request to firmware */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
-				    HostCmd_ACT_GEN_SET, 0, NULL);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
+			       HostCmd_ACT_GEN_SET, 0, NULL, true);
 
 	if (!ret)
 		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
@@ -871,7 +871,6 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->is_suspended = false;
 	adapter->hs_activated = false;
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
-	adapter->cmd_wait_q_required = false;
 	init_waitqueue_head(&adapter->cmd_wait_q.wait);
 	adapter->cmd_wait_q.status = 0;
 	adapter->scan_wait_q_woken = false;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 407f8ea..6747405 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -778,7 +778,6 @@ struct mwifiex_adapter {
 	struct mwifiex_dbg dbg;
 	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
 	u32 arp_filter_size;
-	u16 cmd_wait_q_required;
 	struct mwifiex_wait_queue cmd_wait_q;
 	u8 scan_wait_q_woken;
 	spinlock_t queue_lock;		/* lock for tx queues */
@@ -838,11 +837,8 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter);
 int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
 			 struct cmd_ctrl_node *cmd_node);
 
-int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
-			   u16 cmd_action, u32 cmd_oid, void *data_buf);
-
-int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
-			  u16 cmd_action, u32 cmd_oid, void *data_buf);
+int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
+		     u16 cmd_action, u32 cmd_oid, void *data_buf, bool sync);
 
 void mwifiex_cmd_timeout_func(unsigned long function_context);
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 92adbb1..0e8ca7b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -738,8 +738,8 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		else
 			cmd_no = HostCmd_CMD_802_11_SCAN;
 
-		ret = mwifiex_send_cmd_async(priv, cmd_no, HostCmd_ACT_GEN_SET,
-					     0, scan_cfg_out);
+		ret = mwifiex_send_cmd(priv, cmd_no, HostCmd_ACT_GEN_SET,
+				       0, scan_cfg_out, false);
 
 		/* rate IE is updated per scan command but same starting
 		 * pointer is used each time so that rate IE from earlier
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 5aa3d39..4315a3b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1411,9 +1411,9 @@ int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
 		/* property header is 6 bytes, data must fit in cmd buffer */
 		if (prop && prop->value && prop->length > 6 &&
 		    prop->length <= MWIFIEX_SIZE_OF_CMD_BUFFER - S_DS_GEN) {
-			ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_CFG_DATA,
-						    HostCmd_ACT_GEN_SET, 0,
-						    prop);
+			ret = mwifiex_send_cmd(priv, HostCmd_CMD_CFG_DATA,
+					       HostCmd_ACT_GEN_SET, 0,
+					       prop, true);
 			if (ret)
 				return ret;
 		}
@@ -1912,15 +1912,16 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 
 	if (first_sta) {
 		if (priv->adapter->iface_type == MWIFIEX_PCIE) {
-			ret = mwifiex_send_cmd_sync(priv,
-						HostCmd_CMD_PCIE_DESC_DETAILS,
-						HostCmd_ACT_GEN_SET, 0, NULL);
+			ret = mwifiex_send_cmd(priv,
+					       HostCmd_CMD_PCIE_DESC_DETAILS,
+					       HostCmd_ACT_GEN_SET, 0, NULL,
+					       true);
 			if (ret)
 				return -1;
 		}
 
-		ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_FUNC_INIT,
-					    HostCmd_ACT_GEN_SET, 0, NULL);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_FUNC_INIT,
+				       HostCmd_ACT_GEN_SET, 0, NULL, true);
 		if (ret)
 			return -1;
 
@@ -1938,55 +1939,57 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		}
 
 		if (adapter->cal_data) {
-			ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_CFG_DATA,
-						HostCmd_ACT_GEN_SET, 0, NULL);
+			ret = mwifiex_send_cmd(priv, HostCmd_CMD_CFG_DATA,
+					       HostCmd_ACT_GEN_SET, 0, NULL,
+					       true);
 			if (ret)
 				return -1;
 		}
 
 		/* Read MAC address from HW */
-		ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_GET_HW_SPEC,
-					    HostCmd_ACT_GEN_GET, 0, NULL);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
+				       HostCmd_ACT_GEN_GET, 0, NULL, true);
 		if (ret)
 			return -1;
 
 		/* Reconfigure tx buf size */
-		ret = mwifiex_send_cmd_sync(priv,
-					    HostCmd_CMD_RECONFIGURE_TX_BUFF,
-					    HostCmd_ACT_GEN_SET, 0,
-					    &priv->adapter->tx_buf_size);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
+				       HostCmd_ACT_GEN_SET, 0,
+				       &priv->adapter->tx_buf_size, true);
 		if (ret)
 			return -1;
 
 		if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
 			/* Enable IEEE PS by default */
 			priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
-			ret = mwifiex_send_cmd_sync(
-					priv, HostCmd_CMD_802_11_PS_MODE_ENH,
-					EN_AUTO_PS, BITMAP_STA_PS, NULL);
+			ret = mwifiex_send_cmd(priv,
+					       HostCmd_CMD_802_11_PS_MODE_ENH,
+					       EN_AUTO_PS, BITMAP_STA_PS, NULL,
+					       true);
 			if (ret)
 				return -1;
 		}
 	}
 
 	/* get tx rate */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
-				    HostCmd_ACT_GEN_GET, 0, NULL);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
+			       HostCmd_ACT_GEN_GET, 0, NULL, true);
 	if (ret)
 		return -1;
 	priv->data_rate = 0;
 
 	/* get tx power */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_RF_TX_PWR,
-				    HostCmd_ACT_GEN_GET, 0, NULL);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_RF_TX_PWR,
+			       HostCmd_ACT_GEN_GET, 0, NULL, true);
 	if (ret)
 		return -1;
 
 	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
 		/* set ibss coalescing_status */
-		ret = mwifiex_send_cmd_sync(
-				priv, HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
-				HostCmd_ACT_GEN_SET, 0, &enable);
+		ret = mwifiex_send_cmd(
+				priv,
+				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
+				HostCmd_ACT_GEN_SET, 0, &enable, true);
 		if (ret)
 			return -1;
 	}
@@ -1994,16 +1997,16 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
 	amsdu_aggr_ctrl.enable = true;
 	/* Send request to firmware */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
-				    HostCmd_ACT_GEN_SET, 0,
-				    &amsdu_aggr_ctrl);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
+			       HostCmd_ACT_GEN_SET, 0,
+			       &amsdu_aggr_ctrl, true);
 	if (ret)
 		return -1;
 	/* MAC Control must be the last command in init_fw */
 	/* set MAC Control */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_MAC_CONTROL,
-				    HostCmd_ACT_GEN_SET, 0,
-				    &priv->curr_pkt_filter);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+			       HostCmd_ACT_GEN_SET, 0,
+			       &priv->curr_pkt_filter, true);
 	if (ret)
 		return -1;
 
@@ -2012,10 +2015,9 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		/* Enable auto deep sleep */
 		auto_ds.auto_ds = DEEP_SLEEP_ON;
 		auto_ds.idle_time = DEEP_SLEEP_IDLE_TIME;
-		ret = mwifiex_send_cmd_sync(priv,
-					    HostCmd_CMD_802_11_PS_MODE_ENH,
-					    EN_AUTO_PS, BITMAP_AUTO_DS,
-					    &auto_ds);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+				       EN_AUTO_PS, BITMAP_AUTO_DS,
+				       &auto_ds, true);
 		if (ret)
 			return -1;
 	}
@@ -2023,9 +2025,9 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
 		/* Send cmd to FW to enable/disable 11D function */
 		state_11d = ENABLE_11D;
-		ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
-					    HostCmd_ACT_GEN_SET, DOT11D_I,
-					    &state_11d);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				       HostCmd_ACT_GEN_SET, DOT11D_I,
+				       &state_11d, true);
 		if (ret)
 			dev_err(priv->adapter->dev,
 				"11D: failed to enable 11D\n");
@@ -2038,8 +2040,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	 * (Short GI, Channel BW, Green field support etc.) for transmit
 	 */
 	tx_cfg.tx_htcap = MWIFIEX_FW_DEF_HTTXCFG;
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_11N_CFG,
-				    HostCmd_ACT_GEN_SET, 0, &tx_cfg);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_11N_CFG,
+			       HostCmd_ACT_GEN_SET, 0, &tx_cfg, true);
 
 	ret = -EINPROGRESS;
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 1c5e188..a8f7d54 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -158,8 +158,8 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 
 	priv->subsc_evt_rssi_state = EVENT_HANDLED;
 
-	mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
-			       0, 0, subsc_evt);
+	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
+			 0, 0, subsc_evt, false);
 
 	return 0;
 }
@@ -317,9 +317,8 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	if (priv->is_data_rate_auto)
 		priv->data_rate = 0;
 	else
-		return mwifiex_send_cmd_async(priv,
-					      HostCmd_CMD_802_11_TX_RATE_QUERY,
-					      HostCmd_ACT_GEN_GET, 0, NULL);
+		return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_TX_RATE_QUERY,
+					HostCmd_ACT_GEN_GET, 0, NULL, false);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 92ff7b3..fd2a716 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -293,9 +293,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_HS_ACT_REQ:
 		dev_dbg(adapter->dev, "event: HS_ACT_REQ\n");
-		ret = mwifiex_send_cmd_async(priv,
-					     HostCmd_CMD_802_11_HS_CFG_ENH,
-					     0, 0, NULL);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_HS_CFG_ENH,
+				       0, 0, NULL, false);
 		break;
 
 	case EVENT_MIC_ERR_UNICAST:
@@ -326,9 +325,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_BG_SCAN_REPORT:
 		dev_dbg(adapter->dev, "event: BGS_REPORT\n");
-		ret = mwifiex_send_cmd_async(priv,
-					     HostCmd_CMD_802_11_BG_SCAN_QUERY,
-					     HostCmd_ACT_GEN_GET, 0, NULL);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_BG_SCAN_QUERY,
+				       HostCmd_ACT_GEN_GET, 0, NULL, false);
 		break;
 
 	case EVENT_PORT_RELEASE:
@@ -345,16 +343,16 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_WMM_STATUS_CHANGE:
 		dev_dbg(adapter->dev, "event: WMM status changed\n");
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_WMM_GET_STATUS,
-					     0, 0, NULL);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_WMM_GET_STATUS,
+				       0, 0, NULL, false);
 		break;
 
 	case EVENT_RSSI_LOW:
 		cfg80211_cqm_rssi_notify(priv->netdev,
 					 NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 					 GFP_KERNEL);
-		mwifiex_send_cmd_async(priv, HostCmd_CMD_RSSI_INFO,
-				       HostCmd_ACT_GEN_GET, 0, NULL);
+		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
+				 HostCmd_ACT_GEN_GET, 0, NULL, false);
 		priv->subsc_evt_rssi_state = RSSI_LOW_RECVD;
 		dev_dbg(adapter->dev, "event: Beacon RSSI_LOW\n");
 		break;
@@ -368,8 +366,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		cfg80211_cqm_rssi_notify(priv->netdev,
 					 NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
 					 GFP_KERNEL);
-		mwifiex_send_cmd_async(priv, HostCmd_CMD_RSSI_INFO,
-				       HostCmd_ACT_GEN_GET, 0, NULL);
+		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
+				 HostCmd_ACT_GEN_GET, 0, NULL, false);
 		priv->subsc_evt_rssi_state = RSSI_HIGH_RECVD;
 		dev_dbg(adapter->dev, "event: Beacon RSSI_HIGH\n");
 		break;
@@ -396,15 +394,15 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_IBSS_COALESCED:
 		dev_dbg(adapter->dev, "event: IBSS_COALESCED\n");
-		ret = mwifiex_send_cmd_async(priv,
+		ret = mwifiex_send_cmd(priv,
 				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
-				HostCmd_ACT_GEN_GET, 0, NULL);
+				HostCmd_ACT_GEN_GET, 0, NULL, false);
 		break;
 	case EVENT_ADDBA:
 		dev_dbg(adapter->dev, "event: ADDBA Request\n");
-		mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_ADDBA_RSP,
-				       HostCmd_ACT_GEN_SET, 0,
-				       adapter->event_body);
+		mwifiex_send_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
+				 HostCmd_ACT_GEN_SET, 0,
+				 adapter->event_body, false);
 		break;
 	case EVENT_DELBA:
 		dev_dbg(adapter->dev, "event: DELBA Request\n");
@@ -455,10 +453,10 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		priv->csa_expire_time =
 				jiffies + msecs_to_jiffies(DFS_CHAN_MOVE_TIME);
 		priv->csa_chan = priv->curr_bss_params.bss_descriptor.channel;
-		ret = mwifiex_send_cmd_async(priv,
-			HostCmd_CMD_802_11_DEAUTHENTICATE,
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
 			HostCmd_ACT_GEN_SET, 0,
-			priv->curr_bss_params.bss_descriptor.mac_address);
+			priv->curr_bss_params.bss_descriptor.mac_address,
+			false);
 		break;
 
 	default:
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index b393d55..33170af 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -108,19 +108,19 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 				"info: Set multicast list=%d\n",
 				mcast_list->num_multicast_addr);
 			/* Send multicast addresses to firmware */
-			ret = mwifiex_send_cmd_async(priv,
-				HostCmd_CMD_MAC_MULTICAST_ADR,
-				HostCmd_ACT_GEN_SET, 0,
-				mcast_list);
+			ret = mwifiex_send_cmd(priv,
+					       HostCmd_CMD_MAC_MULTICAST_ADR,
+					       HostCmd_ACT_GEN_SET, 0,
+					       mcast_list, false);
 		}
 	}
 	dev_dbg(priv->adapter->dev,
 		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
 	       old_pkt_filter, priv->curr_pkt_filter);
 	if (old_pkt_filter != priv->curr_pkt_filter) {
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
-					     HostCmd_ACT_GEN_SET,
-					     0, &priv->curr_pkt_filter);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+				       HostCmd_ACT_GEN_SET,
+				       0, &priv->curr_pkt_filter, false);
 	}
 
 	return ret;
@@ -237,8 +237,8 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 
 	rcu_read_unlock();
 
-	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
-				   HostCmd_ACT_GEN_SET, 0, NULL)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
+			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
 		wiphy_err(priv->adapter->wiphy,
 			  "11D: setting domain info in FW\n");
 		return -1;
@@ -429,16 +429,13 @@ static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 				status = -1;
 				break;
 			}
-			if (cmd_type == MWIFIEX_SYNC_CMD)
-				status = mwifiex_send_cmd_sync(priv,
-						HostCmd_CMD_802_11_HS_CFG_ENH,
-						HostCmd_ACT_GEN_SET, 0,
-						&adapter->hs_cfg);
-			else
-				status = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_802_11_HS_CFG_ENH,
-						HostCmd_ACT_GEN_SET, 0,
-						&adapter->hs_cfg);
+
+			status = mwifiex_send_cmd(priv,
+						  HostCmd_CMD_802_11_HS_CFG_ENH,
+						  HostCmd_ACT_GEN_SET, 0,
+						  &adapter->hs_cfg,
+						  cmd_type == MWIFIEX_SYNC_CMD);
+
 			if (hs_cfg->conditions == HS_CFG_CANCEL)
 				/* Restore previous condition */
 				adapter->hs_cfg.conditions =
@@ -586,8 +583,8 @@ int mwifiex_disable_auto_ds(struct mwifiex_private *priv)
 
 	auto_ds.auto_ds = DEEP_SLEEP_OFF;
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
-				     DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+				DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds, true);
 }
 EXPORT_SYMBOL_GPL(mwifiex_disable_auto_ds);
 
@@ -601,8 +598,8 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv, u32 *rate)
 {
 	int ret;
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_TX_RATE_QUERY,
-				    HostCmd_ACT_GEN_GET, 0, NULL);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_TX_RATE_QUERY,
+			       HostCmd_ACT_GEN_GET, 0, NULL, true);
 
 	if (!ret) {
 		if (priv->is_data_rate_auto)
@@ -698,8 +695,8 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_40;
 	}
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TXPWR_CFG,
-				    HostCmd_ACT_GEN_SET, 0, buf);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_TXPWR_CFG,
+			       HostCmd_ACT_GEN_SET, 0, buf, true);
 
 	kfree(buf);
 	return ret;
@@ -722,12 +719,11 @@ int mwifiex_drv_set_power(struct mwifiex_private *priv, u32 *ps_mode)
 	else
 		adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
 	sub_cmd = (*ps_mode) ? EN_AUTO_PS : DIS_AUTO_PS;
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
-				    sub_cmd, BITMAP_STA_PS, NULL);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+			       sub_cmd, BITMAP_STA_PS, NULL, true);
 	if ((!ret) && (sub_cmd == DIS_AUTO_PS))
-		ret = mwifiex_send_cmd_async(priv,
-					     HostCmd_CMD_802_11_PS_MODE_ENH,
-					     GET_PS, 0, NULL);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+				       GET_PS, 0, NULL, false);
 
 	return ret;
 }
@@ -851,9 +847,9 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_private *priv,
 			       struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-				     HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
-				     encrypt_key);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+				encrypt_key, true);
 }
 
 /*
@@ -917,9 +913,8 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			enc_key = NULL;
 
 		/* Send request to firmware */
-		ret = mwifiex_send_cmd_async(priv,
-					     HostCmd_CMD_802_11_KEY_MATERIAL,
-					     HostCmd_ACT_GEN_SET, 0, enc_key);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				       HostCmd_ACT_GEN_SET, 0, enc_key, false);
 		if (ret)
 			return ret;
 	}
@@ -929,9 +924,9 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 	else
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
 
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_MAC_CONTROL,
-				    HostCmd_ACT_GEN_SET, 0,
-				    &priv->curr_pkt_filter);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+			       HostCmd_ACT_GEN_SET, 0,
+			       &priv->curr_pkt_filter, true);
 
 	return ret;
 }
@@ -966,10 +961,9 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 		 */
 		/* Send the key as PTK to firmware */
 		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
-		ret = mwifiex_send_cmd_async(priv,
-					     HostCmd_CMD_802_11_KEY_MATERIAL,
-					     HostCmd_ACT_GEN_SET,
-					     KEY_INFO_ENABLED, encrypt_key);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				       HostCmd_ACT_GEN_SET,
+				       KEY_INFO_ENABLED, encrypt_key, false);
 		if (ret)
 			return ret;
 
@@ -993,15 +987,13 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
 
 	if (remove_key)
-		ret = mwifiex_send_cmd_sync(priv,
-					    HostCmd_CMD_802_11_KEY_MATERIAL,
-					    HostCmd_ACT_GEN_SET,
-					    !KEY_INFO_ENABLED, encrypt_key);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				       HostCmd_ACT_GEN_SET,
+				       !KEY_INFO_ENABLED, encrypt_key, true);
 	else
-		ret = mwifiex_send_cmd_sync(priv,
-					    HostCmd_CMD_802_11_KEY_MATERIAL,
-					    HostCmd_ACT_GEN_SET,
-					    KEY_INFO_ENABLED, encrypt_key);
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				       HostCmd_ACT_GEN_SET,
+				       KEY_INFO_ENABLED, encrypt_key, true);
 
 	return ret;
 }
@@ -1105,8 +1097,8 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 	struct mwifiex_ver_ext ver_ext;
 
 	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_VERSION_EXT,
-				  HostCmd_ACT_GEN_GET, 0, &ver_ext))
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
+			     HostCmd_ACT_GEN_GET, 0, &ver_ext, true))
 		return -1;
 
 	return 0;
@@ -1131,8 +1123,8 @@ mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 			ieee80211_frequency_to_channel(chan->center_freq);
 		roc_cfg.duration = cpu_to_le32(duration);
 	}
-	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_REMAIN_ON_CHAN,
-				  action, 0, &roc_cfg)) {
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_REMAIN_ON_CHAN,
+			     action, 0, &roc_cfg, true)) {
 		dev_err(priv->adapter->dev, "failed to remain on channel\n");
 		return -1;
 	}
@@ -1164,8 +1156,8 @@ mwifiex_set_bss_role(struct mwifiex_private *priv, u8 bss_role)
 		break;
 	}
 
-	mwifiex_send_cmd_sync(priv, HostCmd_CMD_SET_BSS_MODE,
-			      HostCmd_ACT_GEN_SET, 0, NULL);
+	mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+			 HostCmd_ACT_GEN_SET, 0, NULL, true);
 
 	return mwifiex_sta_init_cmd(priv, false);
 }
@@ -1180,8 +1172,8 @@ int
 mwifiex_get_stats_info(struct mwifiex_private *priv,
 		       struct mwifiex_ds_get_stats *log)
 {
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_GET_LOG,
-				     HostCmd_ACT_GEN_GET, 0, log);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_GET_LOG,
+				HostCmd_ACT_GEN_GET, 0, log, true);
 }
 
 /*
@@ -1223,8 +1215,7 @@ static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	return mwifiex_send_cmd_sync(priv, cmd_no, action, 0, reg_rw);
-
+	return mwifiex_send_cmd(priv, cmd_no, action, 0, reg_rw, true);
 }
 
 /*
@@ -1289,8 +1280,8 @@ mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
 	rd_eeprom.byte_count = cpu_to_le16((u16) bytes);
 
 	/* Send request to firmware */
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
-				    HostCmd_ACT_GEN_GET, 0, &rd_eeprom);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
+			       HostCmd_ACT_GEN_GET, 0, &rd_eeprom, true);
 
 	if (!ret)
 		memcpy(value, rd_eeprom.value, MAX_EEPROM_DATA);
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 1ba2a16..8cec6e4 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -864,8 +864,8 @@ mwifiex_tdls_process_config_link(struct mwifiex_private *priv, u8 *peer)
 
 	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
 	tdls_oper.tdls_action = MWIFIEX_TDLS_CONFIG_LINK;
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
-				     HostCmd_ACT_GEN_SET, 0, &tdls_oper);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_OPER,
+				HostCmd_ACT_GEN_SET, 0, &tdls_oper, true);
 }
 
 static int
@@ -891,8 +891,8 @@ mwifiex_tdls_process_create_link(struct mwifiex_private *priv, u8 *peer)
 	mwifiex_hold_tdls_packets(priv, peer);
 	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
 	tdls_oper.tdls_action = MWIFIEX_TDLS_CREATE_LINK;
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
-				     HostCmd_ACT_GEN_SET, 0, &tdls_oper);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_OPER,
+				HostCmd_ACT_GEN_SET, 0, &tdls_oper, true);
 }
 
 static int
@@ -920,8 +920,8 @@ mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, u8 *peer)
 	mwifiex_restore_tdls_packets(priv, peer, TDLS_LINK_TEARDOWN);
 	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
 	tdls_oper.tdls_action = MWIFIEX_TDLS_DISABLE_LINK;
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
-				     HostCmd_ACT_GEN_SET, 0, &tdls_oper);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_OPER,
+				HostCmd_ACT_GEN_SET, 0, &tdls_oper, true);
 }
 
 static int
@@ -1033,8 +1033,8 @@ void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv)
 					     TDLS_LINK_TEARDOWN);
 		memcpy(&tdls_oper.peer_mac, sta_ptr->mac_addr, ETH_ALEN);
 		tdls_oper.tdls_action = MWIFIEX_TDLS_DISABLE_LINK;
-		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_TDLS_OPER,
-					   HostCmd_ACT_GEN_SET, 0, &tdls_oper))
+		if (mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_OPER,
+				     HostCmd_ACT_GEN_SET, 0, &tdls_oper, false))
 			dev_warn(priv->adapter->dev,
 				 "Disable link failed for TDLS peer %pM",
 				 sta_ptr->mac_addr);
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 64424c8..a6a6a53 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -226,8 +226,8 @@ void mwifiex_set_vht_width(struct mwifiex_private *priv,
 	if (ap_11ac_enable && width >= NL80211_CHAN_WIDTH_80)
 		vht_cfg.misc_config |= VHT_BW_80_160_80P80;
 
-	mwifiex_send_cmd_sync(priv, HostCmd_CMD_11AC_CFG,
-			      HostCmd_ACT_GEN_SET, 0, &vht_cfg);
+	mwifiex_send_cmd(priv, HostCmd_CMD_11AC_CFG,
+			 HostCmd_ACT_GEN_SET, 0, &vht_cfg, true);
 
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 2d47ba7..ae50e91 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -150,9 +150,9 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 	case EVENT_ADDBA:
 		dev_dbg(adapter->dev, "event: ADDBA Request\n");
 		if (priv->media_connected)
-			mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_ADDBA_RSP,
-					       HostCmd_ACT_GEN_SET, 0,
-					       adapter->event_body);
+			mwifiex_send_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
+					 HostCmd_ACT_GEN_SET, 0,
+					 adapter->event_body, false);
 		break;
 	case EVENT_DELBA:
 		dev_dbg(adapter->dev, "event: DELBA Request\n");
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 8d37bfc..098de88 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -72,7 +72,7 @@ int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	return mwifiex_send_cmd_sync(priv, cmd, HostCmd_ACT_GEN_SET, 0, NULL);
+	return mwifiex_send_cmd(priv, cmd, HostCmd_ACT_GEN_SET, 0, NULL, true);
 }
 EXPORT_SYMBOL_GPL(mwifiex_init_shutdown_fw);
 
-- 
1.8.2.3


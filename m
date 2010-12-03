Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33650 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0LCVaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 16:30:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] mwifiex: remove uAP functionality
Date: Fri,  3 Dec 2010 16:17:28 -0500
Message-Id: <1291411051-12916-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20101203191130.GD2348@tuxdriver.com>
References: <20101203191130.GD2348@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let's remove this from consideration for now...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwifiex/11n.h           |   43 -
 drivers/net/wireless/mwifiex/11n_aggr.c      |    6 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    7 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    2 +-
 drivers/net/wireless/mwifiex/Makefile        |    4 -
 drivers/net/wireless/mwifiex/README          |   44 -
 drivers/net/wireless/mwifiex/cfg80211.c      |  130 +--
 drivers/net/wireless/mwifiex/cmdevt.c        |   63 +-
 drivers/net/wireless/mwifiex/debugfs.c       |  319 +-----
 drivers/net/wireless/mwifiex/decl.h          |    8 +-
 drivers/net/wireless/mwifiex/fw.h            |  370 ------
 drivers/net/wireless/mwifiex/init.c          |    8 +-
 drivers/net/wireless/mwifiex/ioctl.h         |  216 +----
 drivers/net/wireless/mwifiex/join.c          |    4 +-
 drivers/net/wireless/mwifiex/main.c          |  176 +---
 drivers/net/wireless/mwifiex/main.h          |   69 +-
 drivers/net/wireless/mwifiex/sdio.c          |    4 -
 drivers/net/wireless/mwifiex/sta_cmd.c       |    4 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    2 +-
 drivers/net/wireless/mwifiex/sta_event.c     |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |    6 +-
 drivers/net/wireless/mwifiex/sta_rx.c        |    2 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |    2 +-
 drivers/net/wireless/mwifiex/txrx.c          |   25 +-
 drivers/net/wireless/mwifiex/uap.c           |   99 --
 drivers/net/wireless/mwifiex/uap.h           |  160 ---
 drivers/net/wireless/mwifiex/uap_cmdevent.c  | 1544 --------------------------
 drivers/net/wireless/mwifiex/uap_ioctl.c     |  397 -------
 drivers/net/wireless/mwifiex/uap_txrx.c      |  416 -------
 drivers/net/wireless/mwifiex/util.c          |   58 +-
 30 files changed, 110 insertions(+), 4080 deletions(-)
 delete mode 100644 drivers/net/wireless/mwifiex/uap.c
 delete mode 100644 drivers/net/wireless/mwifiex/uap.h
 delete mode 100644 drivers/net/wireless/mwifiex/uap_cmdevent.c
 delete mode 100644 drivers/net/wireless/mwifiex/uap_ioctl.c
 delete mode 100644 drivers/net/wireless/mwifiex/uap_txrx.c

diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 4095f3d..65f9ae8 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -91,49 +91,6 @@ enum mwifiex_status mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 						void *data_buf);
 
 /*
- * This function checks whether a station has 11N enabled or not.
- */
-static inline u8 is_station_11n_enabled(struct mwifiex_private *priv, u8 *mac)
-{
-	struct sta_node *sta_ptr = NULL;
-	sta_ptr = mwifiex_get_station_entry(priv, mac);
-	if (sta_ptr)
-		return (sta_ptr->is_11n_enabled) ? true : false;
-	return false;
-}
-
-/*
- * This function checks whether a station allows AMPDU or not
- */
-static inline u8 is_station_ampdu_allowed(struct mwifiex_private *priv,
-					  struct mwifiex_ra_list_tbl *ptr,
-					  int tid)
-{
-	struct sta_node *sta_ptr = NULL;
-	sta_ptr = mwifiex_get_station_entry(priv, ptr->ra);
-	if (sta_ptr) {
-		if (priv->sec_info.wapi_enabled && !sta_ptr->wapi_key_on)
-			return false;
-		return ((sta_ptr->ampdu_sta[tid] != BA_STREAM_NOT_ALLOWED)
-				? true : false);
-	}
-	return false;
-}
-
-/*
- * This function disable station ampdu for specific tid
- */
-static inline void disable_station_ampdu(struct mwifiex_private *priv,
-					 u8 tid, u8 *ra)
-{
-	struct sta_node *sta_ptr = NULL;
-	sta_ptr = mwifiex_get_station_entry(priv, ra);
-	if (sta_ptr)
-		sta_ptr->ampdu_sta[tid] = BA_STREAM_NOT_ALLOWED;
-	return;
-}
-
-/*
  * This function checks whether AMPDU is allowed or not for a particular TID.
  */
 static inline u8
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 69f7fa2..a9a28ed 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -270,10 +270,8 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		mbuf_daggr->priority = mbuf->priority;
 		memcpy(mbuf_daggr->buffer + mbuf_daggr->data_offset, data,
 								pkt_len);
-		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
-			ret = mwifiex_uap_recv_packet(priv, mbuf_daggr);
-		else
-			ret = mwifiex_recv_packet(adapter, mbuf_daggr);
+
+		ret = mwifiex_recv_packet(adapter, mbuf_daggr);
 
 		switch (ret) {
 		case MWIFIEX_STATUS_PENDING:
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 3461d52..06bf96f 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -37,11 +37,6 @@ mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	if (GET_BSS_ROLE((struct mwifiex_private *)priv) ==
-						MWIFIEX_BSS_ROLE_UAP)
-		return mwifiex_process_uap_rx_packet(priv,
-					(struct mwifiex_buffer *)payload);
-
 	ret = mwifiex_process_rx_packet(adapter,
 					(struct mwifiex_buffer *) payload);
 	return ret;
@@ -210,7 +205,7 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
  * This function returns the pointer to an entry in Rx reordering
  * table which matches the given TA/TID pair.
  */
-struct mwifiex_rx_reorder_tbl *
+static struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 {
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index ba0454f..e9b82cd 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -67,7 +67,7 @@ enum mwifiex_status mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
 					      struct host_cmd_ds_command *cmd,
 					      void *data_buf);
 void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv);
-struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rx_reorder_tbl(struct
+struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rxreorder_tbl(struct
 							   mwifiex_private
 							   *priv, int tid,
 							   u8 *ta);
diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 4268f81..e689d1d 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -34,10 +34,6 @@ mwifiex-y += sta_event.o
 mwifiex-y += sta_tx.o
 mwifiex-y += sta_rx.o
 mwifiex-y += cfg80211.o
-mwifiex-y += uap.o
-mwifiex-y += uap_ioctl.o
-mwifiex-y += uap_cmdevent.o
-mwifiex-y += uap_txrx.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 4546c6e..1c01854 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -762,48 +762,4 @@ esuppmode
 		(The current RSN mode is WPA, active pairwise cipher is TKIP and
 		 active group cipher is TKIP.)
 
-bssctrl
-	This command is used to start/stop the AP mode, so that UAP will start/stop transmitting beacon.
-
-	Path: /debugfs/mwifiex/uapX/bssctrl
-        Usage:
-
-		echo "1" > bssctrl     : start the AP mode
-		echo "0" > bssctrl     : stop the AP mode and disconnect all stations.
-		cat bssctrl            : Get the current state (start/stop)
-apcfg
-
-	This command is used to set/get the AP configurations. Here string
-	"ASCII_CMD=AP_CFG" is minimum requirement in the ASCII string.
-
-	Path: /debugfs/mwifiex/uapX/apcfg
-        Usage:
-	1) Set the AP configurations
-	echo "ASCII_CMD=AP_CFG,SSID=TEST_uAP,[SEC=sec,][KEY=key,]
-			[CHANNEL=channel,][PREAMBLE=peramble,][MAX_STA_NUM=max_sta_num,][END]" > apcfg
-
-	Where the parameters are:
-		SSID:       Set SSID to be used in beacon and probe response
-		[SEC]:      Security modes - open or wpa2-psk
-		[KEY]:      Encrypted key for WPA2-PSK, minimum 8 chars
-		[CHANNEL]:  Channel to be selected
-		[PREAMBLE]: Preamble
-		[MAX_STA_NUM]:  Maximum station count
-		[END]:      Optional termination in ASCII string
-
-	Examples:
-		echo "ASCII_CMD=AP_CFG,SSID=TEST_uAP" > apcfg
-					: Set AP SSID to "TEST_uAP"
-		echo "ASCII_CMD=AP_CFG,SSID=TEST_uAP,SEC=open" > apcfg
-					: Set AP SSID to "TEST_uAP" and
-					security mode is disabled
-		echo "ASCII_CMD=AP_CFG,SSID=TEST_uAP,SEC=WPA2-PSK,KEY=ecbe5facdbfe234a" > apcfg
-					: Set AP SSID to "TEST_uAP" and security mode
-					to WPA2-SPK and encrypted key ecbe5facdbfe234a
-		echo "ASCII_CMD=AP_CFG,SSID=TEST_uAP,CHANNEL=8" > apcfg
-					: Set AP SSID to "TEST_uAP" and
-					  set the AP channel to 8
-
-	2) Get the AP configurations
-	cat apcfg
 ===============================================================================
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 674c716..d3b2b3e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -72,33 +72,6 @@ static int mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 static int mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 					 enum nl80211_tx_power_setting type,
 					 int dbm);
-
-static int mwifiex_uap_cfg80211_get_station(struct wiphy *wiphy,
-					    struct net_device *dev,
-					    u8 *mac,
-					    struct station_info *sinfo);
-
-static int mwifiex_uap_cfg80211_set_wiphy_params(struct wiphy *wiphy,
-						 u32 changed);
-
-static int mwifiex_uap_cfg80211_set_channel(struct wiphy *wiphy,
-					struct net_device *dev,
-					struct ieee80211_channel *chan,
-					enum nl80211_channel_type channel_type);
-
-static int mwifiex_uap_cfg80211_del_station(struct wiphy *wiphy,
-					    struct net_device *dev,
-					    u8 *mac);
-
-static int mwifiex_uap_cfg80211_dump_station(struct wiphy *wiphy,
-					     struct net_device *dev,
-					     int idx, u8 *mac,
-					     struct station_info *sinfo);
-
-static int mwifiex_uap_cfg80211_set_tx_power(struct wiphy *wiphy,
-					     enum nl80211_tx_power_setting type,
-					     int dbm);
-
 static enum mwifiex_status
 mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 		struct mwifiex_802_11_ssid *ssid);
@@ -1428,76 +1401,6 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-/** uap cfg80211 operations */
-static struct cfg80211_ops mwifiex_uap_cfg80211_ops = {
-	.get_station = mwifiex_uap_cfg80211_get_station,
-	.set_wiphy_params = mwifiex_uap_cfg80211_set_wiphy_params,
-	.set_channel = mwifiex_uap_cfg80211_set_channel,
-	.del_station = mwifiex_uap_cfg80211_del_station,
-	.dump_station = mwifiex_uap_cfg80211_dump_station,
-	.set_tx_power = mwifiex_uap_cfg80211_set_tx_power,
-};
-
-static int
-mwifiex_uap_cfg80211_get_station(struct wiphy *wiphy,
-			     struct net_device *dev,
-			     u8 *mac, struct station_info *sinfo)
-{
-	ENTER();
-	return 0;
-	LEAVE();
-}
-
-static int
-mwifiex_uap_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
-{
-	ENTER();
-	return 0;
-	LEAVE();
-}
-
-static int
-mwifiex_uap_cfg80211_set_channel(struct wiphy *wiphy,
-			     struct net_device *dev,
-			     struct ieee80211_channel *chan,
-			     enum nl80211_channel_type channel_type)
-{
-	ENTER();
-	return 0;
-	LEAVE();
-}
-
-static int
-mwifiex_uap_cfg80211_del_station(struct wiphy *wiphy,
-				 struct net_device *dev,
-				 u8 *mac)
-{
-	ENTER();
-	return 0;
-	LEAVE();
-}
-
-static int
-mwifiex_uap_cfg80211_dump_station(struct wiphy *wiphy,
-				  struct net_device *dev,
-				  int idx, u8 *mac,
-				  struct station_info *sinfo)
-{
-	ENTER();
-	return 0;
-	LEAVE();
-}
-
-static int
-mwifiex_uap_cfg80211_set_tx_power(struct wiphy *wiphy,
-				  enum nl80211_tx_power_setting type,
-				  int dbm)
-{
-	ENTER();
-	return 0;
-	LEAVE();
-}
-
 /*
  * This function sets up the CFG802.11 specific HT capability fields
  * with default values.
@@ -1566,30 +1469,17 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 		ret = -ENOMEM;
 		goto done;
 	}
-
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
-		wdev->wiphy = wiphy_new(&mwifiex_cfg80211_ops,
-					sizeof(struct mwifiex_private *));
-		if (!wdev->wiphy) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		wdev->iftype = NL80211_IFTYPE_STATION;
-		wdev->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
-		wdev->wiphy->reg_notifier = mwifiex_reg_notifier;
-	} else if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
-		wdev->wiphy = wiphy_new(&mwifiex_uap_cfg80211_ops,
-				sizeof(struct mwifiex_private *));
-		if (!wdev->wiphy) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		wdev->iftype = NL80211_IFTYPE_AP;
-		wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_AP);
+	wdev->wiphy =
+		wiphy_new(&mwifiex_cfg80211_ops,
+			  sizeof(struct mwifiex_private *));
+	if (!wdev->wiphy) {
+		ret = -ENOMEM;
+		goto done;
 	}
-
+	wdev->iftype = NL80211_IFTYPE_STATION;
 	wdev->wiphy->max_scan_ssids = 10;
+	wdev->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
 	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
 
@@ -1610,6 +1500,8 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	/* We are using custom domains */
 	wdev->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 
+	wdev->wiphy->reg_notifier = mwifiex_reg_notifier;
+
 	/** Set struct mwifiex_private pointer in wiphy_priv */
 	wdev_priv = wiphy_priv(wdev->wiphy);
 
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 6ae9e22..6f22f5a 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -584,7 +584,7 @@ mwifiex_process_event(struct mwifiex_adapter *adapter)
 		       tstamp.tv_sec, tstamp.tv_usec, eventcause);
 	}
 
-	ret = priv->ops.process_event(priv);
+	ret = mwifiex_process_sta_event(priv);
 
 	adapter->event_cause = 0;
 	adapter->mwifiex_buffer_event = NULL;
@@ -670,7 +670,7 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 	/* Prepare command */
 	if (cmd_no)
-		ret = priv->ops.prepare_cmd(priv, cmd_no, cmd_action,
+		ret = mwifiex_sta_prepare_cmd(priv, cmd_no, cmd_action,
 					      cmd_oid, ioctl_buf, data_buf,
 					      cmd_ptr);
 	else {
@@ -992,7 +992,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 							ioctl_buf);
 	} else {
 		/* handle response */
-		ret = priv->ops.process_cmdresp(priv, cmdresp_no, resp,
+		ret = mwifiex_process_sta_cmdresp(priv, cmdresp_no, resp,
 						  ioctl_buf);
 	}
 
@@ -1542,56 +1542,6 @@ mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 			PRINTM(MCMND, "PS Command: Enter Auto Deep Sleep\n");
 			auto_ds->deep_sleep_timeout = cpu_to_le16(idletime);
 		}
-
-		if (ps_bitmap & (BITMAP_UAP_INACT_PS | BITMAP_UAP_DTIM_PS)) {
-			struct mwifiex_ds_ps_mgmt *ps_mgmt =
-					(struct mwifiex_ds_ps_mgmt *)data_buf;
-			struct mwifiex_ie_types_sleep_param *sleep_tlv = NULL;
-			struct mwifiex_ie_types_inact_sleep_param *inact_tlv =
-									NULL;
-			if (ps_mgmt->flags & PS_FLAG_SLEEP_PARAM) {
-				sleep_tlv = (struct
-					     mwifiex_ie_types_sleep_param
-					     *)tlv;
-				sleep_tlv->header.type = cpu_to_le16(
-						TLV_TYPE_AP_SLEEP_PARAM);
-				sleep_tlv->header.len = cpu_to_le16(sizeof(
-					struct mwifiex_ie_types_sleep_param) -
-					sizeof(struct mwifiex_ie_types_header));
-				sleep_tlv->ctrl_bitmap = cpu_to_le32(
-					ps_mgmt->sleep_param.ctrl_bitmap);
-				sleep_tlv->min_sleep = cpu_to_le32(
-					ps_mgmt->sleep_param.min_sleep);
-				sleep_tlv->max_sleep = cpu_to_le32(
-					ps_mgmt->sleep_param.max_sleep);
-				cmd_size += sizeof(
-					struct mwifiex_ie_types_sleep_param);
-				tlv += sizeof(
-					struct mwifiex_ie_types_sleep_param);
-			}
-			if (ps_mgmt->flags & PS_FLAG_INACT_SLEEP_PARAM) {
-				inact_tlv = (struct
-					     mwifiex_ie_types_inact_sleep_param
-					     *)tlv;
-				inact_tlv->header.type = cpu_to_le16(
-						TLV_TYPE_AP_INACT_SLEEP_PARAM);
-				inact_tlv->header.len = cpu_to_le16(
-					sizeof(struct
-					mwifiex_ie_types_inact_sleep_param)
-					- sizeof(struct
-					mwifiex_ie_types_header));
-				inact_tlv->inactivity_to = cpu_to_le32(
-					ps_mgmt->inact_param.inactivity_to);
-				inact_tlv->min_awake = cpu_to_le32(
-					ps_mgmt->inact_param.min_awake);
-				inact_tlv->max_awake = cpu_to_le32(
-					ps_mgmt->inact_param.max_awake);
-				cmd_size += sizeof(struct
-					mwifiex_ie_types_inact_sleep_param);
-				tlv += sizeof(struct
-					mwifiex_ie_types_inact_sleep_param);
-			}
-		}
 		cmd->size = cpu_to_le16(cmd_size);
 	}
 	return MWIFIEX_STATUS_SUCCESS;
@@ -1631,13 +1581,6 @@ mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 				       "Setting uapsd/pps mode to TRUE\n");
 			}
 		}
-		if (ps_mode->params.auto_ps.ps_bitmap &
-				cpu_to_le16(BITMAP_UAP_INACT_PS |
-					    BITMAP_UAP_DTIM_PS)) {
-			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
-			PRINTM(MCMND, "Enabled uAP power save\n");
-		}
-
 	} else if (action == DIS_AUTO_PS) {
 		if (ps_bitmap & BITMAP_AUTO_DS) {
 			priv->adapter->is_deep_sleep = false;
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index fa94c6e..4ea5cbc 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -20,7 +20,6 @@
 #include <linux/debugfs.h>
 
 #include "main.h"
-#include "uap.h"
 
 
 static struct dentry *mwifiex_dfs_dir;
@@ -2404,216 +2403,6 @@ exit:
 	return ret;
 }
 
-static int bssctrl;
-/*
- * Proc bssctrl file write handler.
- *
- * This function is called when the 'bssctrl' file is opened for writing
- *
- * This function can be used to start/stop the AP mode.
- */
-static ssize_t
-mwifiex_bssctrl_write(struct file *file,
-		      const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int ret = 0;
-	ENTER();
-
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	ret = sscanf(buf, "%d", &bssctrl);
-
-	if (bssctrl != 0 && bssctrl != 1) {
-		ret = -EINVAL;
-		goto done;
-	}
-	if (bssctrl == 1)
-		ret = mwifiex_uap_bss_ctrl(priv, UAP_BSS_START);
-	else if (bssctrl == 0)
-		ret = mwifiex_uap_bss_ctrl(priv, UAP_BSS_STOP);
-
-	if (!ret)
-		ret = count;
-	else
-		ret = -EINVAL;
-done:
-	free_page(addr);
-	if (ret < 0)
-		bssctrl = 0;
-	LEAVE();
-	return ret;
-}
-
-/*
- * Proc bssctrl file read handler.
- *
- * This function is called when the 'bssctrl' file is opened for reading
- *
- * This function can be used to get the current AP mode state (start/stop).
- */
-static ssize_t
-mwifiex_bssctrl_read(struct file *file, char __user *ubuf,
-		    size_t count, loff_t *ppos)
-{
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	ENTER();
-
-	if (!buf)
-		return -ENOMEM;
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", bssctrl);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-
-	LEAVE();
-
-	return ret;
-}
-
-/*
- * Proc apcfg file write handler.
- *
- * This function is called when the 'apcfg' file is opened for writing
- *
- * This function can be used to set following AP configuration parameters
- *      - ssid
- *      - security mode
- *      - encrypted key for WPA2-PSK
- *      - channel to be selected
- *      - preamble
- *      - maximum station count
- */
-static ssize_t
-mwifiex_apcfg_write(struct file *file,
-		      const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int ret = 0;
-	struct mwifiex_uap_bss_param sys_config;
-
-	ENTER();
-
-	if (!buf)
-		return -ENOMEM;
-
-	memset(&sys_config, 0, sizeof(struct mwifiex_uap_bss_param));
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	/* Overwrite last charactor '\n' in buf by '\0' */
-	buf[buf_size - 1] = '\0';
-
-	/* Initialize the invalid values so that the correct
-	 * values below are downloaded to firmware */
-	mwifiex_set_sys_config_invalid_data(&sys_config);
-
-	/* Setting the default values */
-	sys_config.channel = 6;
-	sys_config.preamble_type = 0;
-
-	ret = mwifiex_uap_ap_cfg_parse_data(&sys_config, buf);
-	if (ret)
-		goto done;
-
-	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_set_get_sys_config(priv, MWIFIEX_ACT_SET,
-						   &sys_config)) {
-		ret =  -EFAULT;
-		goto done;
-	}
-
-	ret = count;
-done:
-	free_page(addr);
-	LEAVE();
-	return ret;
-}
-
-/*
- * Proc apcfg file read handler.
- *
- * This function is called when the 'apcfg' file is opened for reading
- * It prints following ap configuration information -
- *      - ssid
- *      - security mode
- *      - encrypted key for WPA2-PSK
- *      - channel to be selected
- *      - preamble
- *      - maximum station count
- */
-static ssize_t
-mwifiex_apcfg_read(struct file *file, char __user *ubuf,
-		     size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	char *p = (char *) page;
-	int ret = 0;
-	struct mwifiex_uap_bss_param ap_cfg;
-
-	ENTER();
-
-	if (!p) {
-		ret = -ENOMEM;
-		goto exit;
-	}
-
-	memset(&ap_cfg, 0, sizeof(ap_cfg));
-	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_set_get_sys_config(priv, MWIFIEX_ACT_GET,
-						   &ap_cfg)) {
-		PRINTM(MERROR, "Error getting AP confiruration\n");
-		ret = -EFAULT;
-		goto free_and_exit;
-	}
-
-	p += sprintf(p, "ssid =\"%s\"\n", ap_cfg.ssid.ssid);
-	if (ap_cfg.protocol == PROTOCOL_NO_SECURITY)
-		p += sprintf(p, "security mode = open\n");
-	else if (ap_cfg.protocol == PROTOCOL_WPA2) {
-		p += sprintf(p, "security mode = wpa2-psk\n");
-		if (ap_cfg.wpa_cfg.length)
-			p += sprintf(p, "key = %s\n",
-						ap_cfg.wpa_cfg.passphrase);
-	}
-	if (ap_cfg.channel)
-		p += sprintf(p, "channel = %d\n", ap_cfg.channel);
-	if (ap_cfg.max_sta_count)
-		p += sprintf(p, "max station count = %d\n",
-							ap_cfg.max_sta_count);
-	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
-			(unsigned long) p - page);
-
-free_and_exit:
-	free_page(page);
-exit:
-	LEAVE();
-	return ret;
-}
-
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	priv->dfs_##name =                                              \
 	debugfs_create_file(#name, 0644, priv->dfs_dev_dir,             \
@@ -2668,8 +2457,6 @@ MWIFIEX_DFS_FILE_OPS(drvdbg);
 MWIFIEX_DFS_FILE_OPS(txbufcfg);
 MWIFIEX_DFS_FILE_OPS(passphrase);
 MWIFIEX_DFS_FILE_READ_OPS(esuppmode);
-MWIFIEX_DFS_FILE_OPS(bssctrl);
-MWIFIEX_DFS_FILE_OPS(apcfg);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -2698,34 +2485,30 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 		items[i].addr += (size_t) priv->adapter;
 
 
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
-		MWIFIEX_DFS_ADD_FILE(info);
-		MWIFIEX_DFS_ADD_FILE(debug);
-		MWIFIEX_DFS_ADD_FILE(deepsleep);
-		MWIFIEX_DFS_ADD_FILE(hscfg);
-		MWIFIEX_DFS_ADD_FILE(amsduaggrctrl);
-		MWIFIEX_DFS_ADD_FILE(txaggrprio);
-		MWIFIEX_DFS_ADD_FILE(sleeppd);
-		MWIFIEX_DFS_ADD_FILE(mpactrl);
-		MWIFIEX_DFS_ADD_FILE(qoscfg);
-		MWIFIEX_DFS_ADD_FILE(atimwindow);
-		MWIFIEX_DFS_ADD_FILE(txratecfg);
-		MWIFIEX_DFS_ADD_FILE(addbapara);
-		MWIFIEX_DFS_ADD_FILE(addbareject);
-		MWIFIEX_DFS_ADD_FILE(httxcfg);
-		MWIFIEX_DFS_ADD_FILE(htcapinfo);
-		MWIFIEX_DFS_ADD_FILE(getlog);
-		MWIFIEX_DFS_ADD_FILE(antcfg);
-		MWIFIEX_DFS_ADD_FILE(regrdwr);
-		MWIFIEX_DFS_ADD_FILE(rdeeprom);
-		MWIFIEX_DFS_ADD_FILE(drvdbg);
-		MWIFIEX_DFS_ADD_FILE(txbufcfg);
-		MWIFIEX_DFS_ADD_FILE(passphrase);
-		MWIFIEX_DFS_ADD_FILE(esuppmode);
-	} else if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
-		MWIFIEX_DFS_ADD_FILE(bssctrl);
-		MWIFIEX_DFS_ADD_FILE(apcfg);
-	}
+	MWIFIEX_DFS_ADD_FILE(info);
+	MWIFIEX_DFS_ADD_FILE(debug);
+	MWIFIEX_DFS_ADD_FILE(deepsleep);
+	MWIFIEX_DFS_ADD_FILE(hscfg);
+	MWIFIEX_DFS_ADD_FILE(amsduaggrctrl);
+	MWIFIEX_DFS_ADD_FILE(txaggrprio);
+	MWIFIEX_DFS_ADD_FILE(sleeppd);
+	MWIFIEX_DFS_ADD_FILE(mpactrl);
+	MWIFIEX_DFS_ADD_FILE(qoscfg);
+	MWIFIEX_DFS_ADD_FILE(atimwindow);
+	MWIFIEX_DFS_ADD_FILE(txratecfg);
+	MWIFIEX_DFS_ADD_FILE(addbapara);
+	MWIFIEX_DFS_ADD_FILE(addbareject);
+	MWIFIEX_DFS_ADD_FILE(httxcfg);
+	MWIFIEX_DFS_ADD_FILE(htcapinfo);
+	MWIFIEX_DFS_ADD_FILE(getlog);
+	MWIFIEX_DFS_ADD_FILE(antcfg);
+	MWIFIEX_DFS_ADD_FILE(regrdwr);
+	MWIFIEX_DFS_ADD_FILE(rdeeprom);
+	MWIFIEX_DFS_ADD_FILE(drvdbg);
+	MWIFIEX_DFS_ADD_FILE(txbufcfg);
+	MWIFIEX_DFS_ADD_FILE(passphrase);
+	MWIFIEX_DFS_ADD_FILE(esuppmode);
+
 exit:
 	LEAVE();
 }
@@ -2741,36 +2524,30 @@ mwifiex_dev_debugfs_remove(struct mwifiex_private *priv)
 	if (!priv)
 		goto exit;
 
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
-		MWIFIEX_DFS_REM_FILE(info);
-		MWIFIEX_DFS_REM_FILE(debug);
-		MWIFIEX_DFS_REM_FILE(deepsleep);
-		MWIFIEX_DFS_REM_FILE(hscfg);
-		MWIFIEX_DFS_REM_FILE(amsduaggrctrl);
-		MWIFIEX_DFS_REM_FILE(txaggrprio);
-		MWIFIEX_DFS_REM_FILE(sleeppd);
-		MWIFIEX_DFS_REM_FILE(mpactrl);
-		MWIFIEX_DFS_REM_FILE(qoscfg);
-		MWIFIEX_DFS_REM_FILE(atimwindow);
-		MWIFIEX_DFS_REM_FILE(txratecfg);
-		MWIFIEX_DFS_REM_FILE(addbapara);
-		MWIFIEX_DFS_REM_FILE(addbareject);
-		MWIFIEX_DFS_REM_FILE(httxcfg);
-		MWIFIEX_DFS_REM_FILE(htcapinfo);
-		MWIFIEX_DFS_REM_FILE(getlog);
-		MWIFIEX_DFS_REM_FILE(antcfg);
-		MWIFIEX_DFS_REM_FILE(regrdwr);
-		MWIFIEX_DFS_REM_FILE(rdeeprom);
-		MWIFIEX_DFS_REM_FILE(drvdbg);
-		MWIFIEX_DFS_REM_FILE(txbufcfg);
-		MWIFIEX_DFS_REM_FILE(passphrase);
-		MWIFIEX_DFS_REM_FILE(esuppmode);
-		MWIFIEX_DFS_REM_FILE(dev_dir);
-	} else if (priv->bss_type == MWIFIEX_BSS_TYPE_UAP) {
-		MWIFIEX_DFS_REM_FILE(bssctrl);
-		MWIFIEX_DFS_REM_FILE(apcfg);
-		MWIFIEX_DFS_REM_FILE(dev_dir);
-	}
+	MWIFIEX_DFS_REM_FILE(info);
+	MWIFIEX_DFS_REM_FILE(debug);
+	MWIFIEX_DFS_REM_FILE(deepsleep);
+	MWIFIEX_DFS_REM_FILE(hscfg);
+	MWIFIEX_DFS_REM_FILE(amsduaggrctrl);
+	MWIFIEX_DFS_REM_FILE(txaggrprio);
+	MWIFIEX_DFS_REM_FILE(sleeppd);
+	MWIFIEX_DFS_REM_FILE(mpactrl);
+	MWIFIEX_DFS_REM_FILE(qoscfg);
+	MWIFIEX_DFS_REM_FILE(atimwindow);
+	MWIFIEX_DFS_REM_FILE(txratecfg);
+	MWIFIEX_DFS_REM_FILE(addbapara);
+	MWIFIEX_DFS_REM_FILE(addbareject);
+	MWIFIEX_DFS_REM_FILE(httxcfg);
+	MWIFIEX_DFS_REM_FILE(htcapinfo);
+	MWIFIEX_DFS_REM_FILE(getlog);
+	MWIFIEX_DFS_REM_FILE(antcfg);
+	MWIFIEX_DFS_REM_FILE(regrdwr);
+	MWIFIEX_DFS_REM_FILE(rdeeprom);
+	MWIFIEX_DFS_REM_FILE(drvdbg);
+	MWIFIEX_DFS_REM_FILE(txbufcfg);
+	MWIFIEX_DFS_REM_FILE(passphrase);
+	MWIFIEX_DFS_REM_FILE(esuppmode);
+	MWIFIEX_DFS_REM_FILE(dev_dir);
 exit:
 	LEAVE();
 }
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 464c25d..a316446 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -25,7 +25,7 @@
 #include	<linux/wireless.h>
 
 
-#define MWIFIEX_MAX_BSS_NUM         (2)
+#define MWIFIEX_MAX_BSS_NUM         (1)
 
 #define MWIFIEX_MIN_DATA_HEADER_LEN 32	/* (sizeof(mwifiex_txpd)) */
 
@@ -65,9 +65,6 @@
 
 #define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
 #define MWIFIEX_FLAG_TX_BUF                BIT(1)
-#define MWIFIEX_BUF_FLAG_MALLOC_BUF        BIT(2)
-#define MWIFIEX_BUF_FLAG_BRIDGE_BUF        BIT(3)
-
 
 enum mwifiex_status {
 	MWIFIEX_STATUS_FAILURE = 0xffffffff,
@@ -148,9 +145,6 @@ enum mwifiex_event_id {
 	MWIFIEX_EVENT_ID_FW_START_TX,
 	MWIFIEX_EVENT_ID_FW_BW_CHANGED,
 	MWIFIEX_EVENT_ID_HOSTWAKE_STAIE,
-	MWIFIEX_EVENT_ID_UAP_FW_BSS_START,
-	MWIFIEX_EVENT_ID_UAP_FW_BSS_ACTIVE,
-	MWIFIEX_EVENT_ID_UAP_FW_BSS_IDLE,
 
 	MWIFIEX_EVENT_ID_DRV_CONNECTED = 0x80000001,
 	MWIFIEX_EVENT_ID_DRV_DEFER_HANDLING,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 8a0f6b8..bafeafb 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -169,7 +169,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
-#define TLV_TYPE_MGMT_IE            (PROPRIETARY_TLV_BASE_ID + 105)
 #define TLV_TYPE_ENCRYPTION_PROTO   (PROPRIETARY_TLV_BASE_ID + 64)
 #define TLV_TYPE_CIPHER             (PROPRIETARY_TLV_BASE_ID + 66)
 #define TLV_TYPE_PMK                (PROPRIETARY_TLV_BASE_ID + 68)
@@ -356,15 +355,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define HostCmd_CMD_CAU_REG_ACCESS                    0x00ed
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
 
-#define HOST_CMD_APCMD_SYS_INFO                       0x00ae
-#define HOST_CMD_APCMD_SYS_RESET                      0x00af
-#define HOST_CMD_APCMD_SYS_CONFIGURE                  0x00b0
-#define HOST_CMD_APCMD_BSS_START                      0x00b1
-#define HOST_CMD_APCMD_BSS_STOP                       0x00b2
-#define HOST_CMD_APCMD_STA_LIST                       0x00b3
-#define HOST_CMD_APCMD_STA_DEAUTH                     0x00b5
-
-#define HOST_CMD_RX_DATA_PAUSE                        0x0101
 
 enum ENH_PS_MODES {
 	EN_PS = 1,
@@ -477,11 +467,6 @@ enum ENH_PS_MODES {
 
 #define EVENT_HOSTWAKE_STAIE		0x0000004d
 
-#define EVENT_MICRO_AP_STA_DEAUTH       0x0000002c
-#define EVENT_MICRO_AP_STA_ASSOC        0x0000002d
-#define EVENT_MICRO_AP_BSS_START        0x0000002e
-#define EVENT_MICRO_AP_BSS_IDLE         0x00000043
-#define EVENT_MICRO_AP_BSS_ACTIVE       0x00000044
 #define EVENT_ID_MASK                   0xffff
 #define BSS_NUM_MASK                    0xf
 
@@ -550,63 +535,6 @@ struct rxpd {
 	u8 reserved;
 } __attribute__ ((packed));
 
-struct mwifiex_uap_txpd {
-	u8  bss_type;
-	u8  bss_num;
-	__le16 tx_pkt_length;
-	__le16 tx_pkt_offset;
-	__le16 tx_pkt_type;
-	__le32 tx_control;
-	u8  priority;
-	u8  flags;
-	u8  pkt_delay_2ms;
-	u8  reserved1;
-	__le32 reserved;
-} __attribute__ ((packed));
-
-struct mwifiex_uap_rxpd {
-	u8  bss_type;
-	u8  bss_num;
-	__le16 rx_pkt_length;
-	__le16 rx_pkt_offset;
-	__le16 rx_pkt_type;
-	__le16 reserved;
-	__le16 seq_num;
-	u8  priority;
-	u8  reserved1;
-} __attribute__ ((packed));
-
-struct ieee_types_frame_ctl {
-	u8 protocol_version:2;
-	u8 type:2;
-	u8 sub_type:4;
-	u8 to_ds:1;
-	u8 from_ds:1;
-	u8 more_frag:1;
-	u8 retry:1;
-	u8 pwr_mgmt:1;
-	u8 more_data:1;
-	u8 wep:1;
-	u8 order:1;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_mgmt_frame_set {
-	u16 type;
-	u16 len;
-	struct ieee_types_frame_ctl frame_control;
-} __attribute__ ((packed));
-
-struct ieee_types_assoc_rqst {
-	u16 cap_info;
-	u16 listen_interval;
-} __attribute__ ((packed));
-
-struct ieee_types_reassoc_rqst {
-	u16 cap_info;
-	u16 listen_interval;
-	u8  current_ap_addr[MWIFIEX_MAC_ADDR_LENGTH];
-} __attribute__ ((packed));
-
 struct mwifiex_chan_scan_mode {
 #ifdef __BIG_ENDIAN__BITFIELD
 	u8 reserved_2_7:6;
@@ -868,11 +796,6 @@ struct host_cmd_ds_mac_control {
 	__le16 reserved;
 };
 
-struct host_cmd_ds_rx_data_pause {
-	u16 action;
-	u16 rx_pause;
-};
-
 struct host_cmd_ds_mac_multicast_adr {
 	__le16 action;
 	__le16 num_of_adrs;
@@ -1431,293 +1354,6 @@ struct host_cmd_ds_set_bss_mode {
 	u8 con_type;
 } __attribute__ ((packed));
 
-struct mwifiex_ie_types_macaddr {
-	struct mwifiex_ie_types_header header;
-	u8 mac[MWIFIEX_MAC_ADDR_LENGTH];
-} __attribute__ ((packed));
-
-#define TLV_TYPE_UAP_CHAN_BAND_CONFIG (PROPRIETARY_TLV_BASE_ID + 42)
-#define TLV_TYPE_UAP_MAC_ADDRESS      (PROPRIETARY_TLV_BASE_ID + 43)
-#define TLV_TYPE_UAP_BEACON_PERIOD    (PROPRIETARY_TLV_BASE_ID + 44)
-#define TLV_TYPE_UAP_DTIM_PERIOD      (PROPRIETARY_TLV_BASE_ID + 45)
-#define TLV_TYPE_UAP_TX_POWER         (PROPRIETARY_TLV_BASE_ID + 47)
-#define TLV_TYPE_UAP_BCAST_SSID_CTL   (PROPRIETARY_TLV_BASE_ID + 48)
-#define TLV_TYPE_UAP_PREAMBLE_CTL     (PROPRIETARY_TLV_BASE_ID + 49)
-#define TLV_TYPE_UAP_ANTENNA_CTL      (PROPRIETARY_TLV_BASE_ID + 50)
-#define TLV_TYPE_UAP_RTS_THRESHOLD    (PROPRIETARY_TLV_BASE_ID + 51)
-#define TLV_TYPE_UAP_RADIO_CONTROL    (PROPRIETARY_TLV_BASE_ID + 52)
-#define TLV_TYPE_UAP_TX_DATA_RATE     (PROPRIETARY_TLV_BASE_ID + 53)
-#define TLV_TYPE_UAP_PKT_FWD_CTL      (PROPRIETARY_TLV_BASE_ID + 54)
-#define TLV_TYPE_UAP_STA_INFO         (PROPRIETARY_TLV_BASE_ID + 55)
-#define TLV_TYPE_UAP_STA_MAC_ADDR_FILTER (PROPRIETARY_TLV_BASE_ID + 56)
-#define TLV_TYPE_UAP_STA_AGEOUT_TIMER (PROPRIETARY_TLV_BASE_ID + 57)
-#define TLV_TYPE_UAP_WEP_KEY          (PROPRIETARY_TLV_BASE_ID + 59)
-#define TLV_TYPE_UAP_WPA_PASSPHRASE    (PROPRIETARY_TLV_BASE_ID + 60)
-#define TLV_TYPE_UAP_ENCRYPT_PROTOCOL (PROPRIETARY_TLV_BASE_ID + 64)
-#define TLV_TYPE_UAP_AKMP             (PROPRIETARY_TLV_BASE_ID + 65)
-#define TLV_TYPE_UAP_CIPHER           (PROPRIETARY_TLV_BASE_ID + 66)
-#define TLV_TYPE_UAP_FRAG_THRESHOLD   (PROPRIETARY_TLV_BASE_ID + 70)
-#define TLV_TYPE_UAP_GRP_REKEY_TIME   (PROPRIETARY_TLV_BASE_ID + 71)
-#define TLV_TYPE_UAP_MAX_STA_CNT      (PROPRIETARY_TLV_BASE_ID + 85)
-#define TLV_TYPE_UAP_RETRY_LIMIT      (PROPRIETARY_TLV_BASE_ID + 93)
-#define TLV_TYPE_UAP_MCBC_DATA_RATE   (PROPRIETARY_TLV_BASE_ID + 98)
-#define TLV_TYPE_UAP_RSN_REPLAY_PROTECT  (PROPRIETARY_TLV_BASE_ID + 100)
-#define TLV_TYPE_UAP_MGMT_FRAME          (PROPRIETARY_TLV_BASE_ID + 104)
-#define TLV_TYPE_UAP_EAPOL_PWK_HSK_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 117)
-#define TLV_TYPE_UAP_EAPOL_PWK_HSK_RETRIES  (PROPRIETARY_TLV_BASE_ID + 118)
-#define TLV_TYPE_UAP_EAPOL_GWK_HSK_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 119)
-#define TLV_TYPE_UAP_EAPOL_GWK_HSK_RETRIES  (PROPRIETARY_TLV_BASE_ID + 120)
-#define TLV_TYPE_UAP_PS_STA_AGEOUT_TIMER (PROPRIETARY_TLV_BASE_ID + 123)
-#define TLV_TYPE_PWK_CIPHER              (PROPRIETARY_TLV_BASE_ID + 145)
-#define TLV_TYPE_GWK_CIPHER              (PROPRIETARY_TLV_BASE_ID + 146)
-
-#define SUBTYPE_ASSOC_REQUEST        0
-#define SUBTYPE_REASSOC_REQUEST      2
-
-struct mwifiex_ie_types_beacon_period {
-	struct mwifiex_ie_types_header header;
-	__le16 beacon_period;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_dtim_period {
-	struct mwifiex_ie_types_header header;
-	u8 dtim_period;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_tx_rate {
-	struct mwifiex_ie_types_header header;
-	__le16 tx_data_rate;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_mcbc_rate {
-	struct mwifiex_ie_types_header header;
-	__le16 mcbc_data_rate;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_tx_power {
-	struct mwifiex_ie_types_header header;
-	u8 tx_power;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_bcast_ssid {
-	struct mwifiex_ie_types_header header;
-	u8 bcast_ssid_ctl;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_antenna_mode {
-	struct mwifiex_ie_types_header header;
-	u8 which_antenna;
-	u8 antenna_mode;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_pkt_forward {
-	struct mwifiex_ie_types_header header;
-	u8 pkt_forward_ctl;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_max_sta_count {
-	struct mwifiex_ie_types_header header;
-	__le16 max_sta_count;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_sta_ageout {
-	struct mwifiex_ie_types_header header;
-	__le32 sta_ageout_timer;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_rts_threshold {
-	struct mwifiex_ie_types_header header;
-	__le16 rts_threshold;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_frag_threshold {
-	struct mwifiex_ie_types_header header;
-	__le16 frag_threshold;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_retry_limit {
-	struct mwifiex_ie_types_header header;
-	u8 retry_limit;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_eapol_pwk_hsk_timeout {
-	struct mwifiex_ie_types_header header;
-	__le32 pairwise_update_timeout;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_eapol_pwk_hsk_retries {
-	struct mwifiex_ie_types_header header;
-	__le32 pwk_retries;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_eapol_gwk_hsk_timeout {
-	struct mwifiex_ie_types_header header;
-	__le32 groupwise_update_timeout;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_eapol_gwk_hsk_retries {
-	struct mwifiex_ie_types_header header;
-	__le32 gwk_retries;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_mac_filter {
-	struct mwifiex_ie_types_header header;
-	u8 filter_mode;
-	u8 count;
-	u8 mac_address[1];
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_channel_band {
-	struct mwifiex_ie_types_header     header;
-	/** Band Configuration
-	 *
-	 * [7-6] Channel Selection Mode; 00 manual, 01 ACS
-	 * [3-2] Channel Width; 00 20 MHz
-	 * [1-0] Band Info; 00 2.4 GHz
-	 */
-	u8 band_config;
-	u8 channel;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_radio_control {
-	struct mwifiex_ie_types_header header;
-	u8 radio_ctl;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_encrypt_protocol {
-	struct mwifiex_ie_types_header header;
-	__le16 protocol;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_pwk_cipher {
-	struct mwifiex_ie_types_header header;
-	__le16 protocol;
-	u8 pairwise_cipher;
-	u8 reserved;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_gwk_cipher {
-	struct mwifiex_ie_types_header header;
-	u8 group_cipher;
-	u8 reserved;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_akmp {
-	struct mwifiex_ie_types_header header;
-	__le16 key_mgmt;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_rsn_replay_prot {
-	struct mwifiex_ie_types_header header;
-	u8 rsn_replay_prot;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_group_rekey_time {
-	struct mwifiex_ie_types_header header;
-	__le32 gk_rekey_time;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_wep_key {
-	struct mwifiex_ie_types_header header;
-	u8 key_index;
-	u8 is_default;
-	u8 key[1];
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_preamble {
-	struct mwifiex_ie_types_header header;
-	u8 preamble_type;
-} __attribute__ ((packed));
-
-enum SNMP_MIB_UAP_INDEX {
-	tkip_mic_failures = 0x0b,
-	ccmp_decrypt_errors = 0x0c,
-	wep_undecryptable_count = 0x0d,
-	wep_icv_error_count = 0x0e,
-	decrypt_failure_count = 0xf,
-	dot11_failed_count = 0x12,
-	dot11_retry_count = 0x13,
-	dot11_multi_retry_count = 0x14,
-	dot11_frame_dup_count = 0x15,
-	dot11_rts_success_count = 0x16,
-	dot11_rts_failure_count = 0x17,
-	dot11_ack_failure_count = 0x18,
-	dot11_rx_fragment_count = 0x19,
-	dot11_mcast_rx_frame_count = 0x1a,
-	dot11_fcs_error_count = 0x1b,
-	dot11_tx_frame_count = 0x1c,
-	dot11_rsna_tkip_cm_invoked = 0x1d,
-	dot11_rsna_4way_hshk_failures = 0x1e,
-	dot11_mcast_tx_count = 0x1f,
-};
-
-struct mwifiex_ie_types_snmp_oid {
-	struct mwifiex_ie_types_header header;
-	__le32 data;
-} __attribute__ ((packed));
-
-struct host_cmd_ds_sys_config {
-	__le16 action;
-	u8 tlv_buffer[1];
-} __attribute__ ((packed));
-
-struct host_cmd_ds_sys_info {
-	u8 sys_info[64];
-} __attribute__ ((packed));
-
-struct host_cmd_ds_sta_deauth {
-	u8 mac[MWIFIEX_MAC_ADDR_LENGTH];
-	u16 reason;
-} __attribute__ ((packed));
-
-#define HOST_CMD_POWER_MGMT_EXT                   0x00ef
-#define TLV_TYPE_AP_SLEEP_PARAM         (PROPRIETARY_TLV_BASE_ID + 106)
-#define TLV_TYPE_AP_INACT_SLEEP_PARAM   (PROPRIETARY_TLV_BASE_ID + 107)
-
-#define HOST_CMD_SLEEP_CONFIRM                 0x00d8
-
-struct mwifiex_ie_types_sleep_param {
-	struct mwifiex_ie_types_header     header;
-	__le32 ctrl_bitmap;
-	__le32 min_sleep;
-	__le32 max_sleep;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_inact_sleep_param {
-	struct mwifiex_ie_types_header header;
-	__le32 inactivity_to;
-	__le32 min_awake;
-	__le32 max_awake;
-} __attribute__ ((packed));
-
-struct host_cmd_ds_power_mgmt_ext {
-	u16 action;
-	u16 power_mode;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_ps_sta_ageout {
-	struct mwifiex_ie_types_header header;
-	__le32 ps_sta_ageout_timer;
-} __attribute__ ((packed));
-
-struct mwifiex_ie_types_sta_info {
-	struct mwifiex_ie_types_header header;
-	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
-	u8 power_mfg_status;
-	s8 rssi;
-} __attribute__ ((packed));
-
-struct host_cmd_ds_sta_list {
-	u16 sta_count;
-} __attribute__ ((packed));
-
-#define TLV_TYPE_AP_WAPI_INFO         (PROPRIETARY_TLV_BASE_ID + 103)
-
-struct mwifiex_ie_types_wapi_info {
-	struct mwifiex_ie_types_header     header;
-	u8 multicast_PN[16];
-} __attribute__ ((packed));
-
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -1769,12 +1405,6 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_pmic_reg_access pmic_reg;
 		struct host_cmd_ds_set_bss_mode bss_mode;
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
-		struct host_cmd_ds_sys_config sys_config;
-		struct host_cmd_ds_sys_info sys_info;
-		struct host_cmd_ds_sta_deauth sta_deauth;
-		struct host_cmd_ds_sta_list sta_list;
-		struct host_cmd_ds_rx_data_pause data_pause;
-		struct host_cmd_ds_power_mgmt_ext pm_cfg;
 		struct host_cmd_ds_802_11_sleep_period sleep_pd;
 	} params;
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index bd65b7d..664959a 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -453,7 +453,6 @@ enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter)
 									true);
 			mwifiex_util_init_list_head(&priv->rx_reorder_tbl_ptr,
 									true);
-			mwifiex_util_init_list_head(&priv->sta_list, true);
 		}
 	}
 
@@ -508,7 +507,6 @@ void wlan_free_lock_list(struct mwifiex_adapter *adapter)
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
-			mwifiex_util_free_list_head(&priv->sta_list);
 			priv = adapter->priv[i];
 			for (j = 0; j < MAX_NUM_TID; ++j)
 				mwifiex_util_free_list_head(&priv->wmm
@@ -570,8 +568,8 @@ mwifiex_init_fw(struct mwifiex_adapter *adapter)
 	}
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
-			ret = adapter->priv[i]->ops.init_cmd(adapter->priv[i],
-							     first_sta);
+			ret = mwifiex_sta_init_cmd(adapter->priv[i],
+						   first_sta);
 			if (ret == MWIFIEX_STATUS_FAILURE)
 				goto done;
 
@@ -632,8 +630,6 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 			mwifiex_clean_txrx(priv);
 			mwifiex_delete_bss_prio_tbl(priv);
-			if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
-				mwifiex_delete_station_list(priv);
 		}
 	}
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 6d08cb9..c5205cb 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -40,9 +40,6 @@ enum {
 	MWIFIEX_OID_BSS_FIND_BSS,
 	MWIFIEX_OID_IBSS_ATIM_WINDOW,
 	MWIFIEX_OID_IBSS_CHANNEL,
-	MWIFIEX_OID_UAP_BSS_CONFIG,
-	MWIFIEX_OID_UAP_DEAUTH_STA,
-	MWIFIEX_OID_UAP_BSS_RESET,
 
 	MWIFIEX_IOCTL_RADIO_CFG = 0x00030000,
 	MWIFIEX_OID_BAND_CFG,
@@ -60,7 +57,6 @@ enum {
 	MWIFIEX_OID_GET_VER_EXT,
 	MWIFIEX_OID_GET_BSS_INFO,
 	MWIFIEX_OID_GET_DEBUG_INFO,
-	MWIFIEX_OID_UAP_STA_LIST,
 
 	MWIFIEX_IOCTL_SEC_CFG = 0x00060000,
 	MWIFIEX_OID_SEC_CFG_AUTH_MODE,
@@ -71,7 +67,6 @@ enum {
 	MWIFIEX_OID_SEC_CFG_EWPA_ENABLED,
 	MWIFIEX_OID_SEC_CFG_ESUPP_MODE,
 	MWIFIEX_OID_SEC_CFG_WAPI_ENABLED,
-	MWIFIEX_OID_SEC_CFG_REPORT_MIC_ERR,
 
 	MWIFIEX_IOCTL_RATE = 0x00070000,
 	MWIFIEX_OID_RATE_CFG,
@@ -86,7 +81,6 @@ enum {
 	MWIFIEX_OID_PM_CFG_HS_CFG,
 	MWIFIEX_OID_PM_CFG_DEEP_SLEEP,
 	MWIFIEX_OID_PM_CFG_SLEEP_PD,
-	MWIFIEX_OID_PM_CFG_PS_MODE,
 
 	MWIFIEX_IOCTL_WMM_CFG = 0x000A0000,
 	MWIFIEX_OID_WMM_CFG_QOS,
@@ -109,7 +103,6 @@ enum {
 	MWIFIEX_OID_MISC_GEN_IE,
 	MWIFIEX_OID_MISC_HOST_CMD,
 	MWIFIEX_OID_MISC_INIT_SHUTDOWN,
-	MWIFIEX_OID_MISC_CUSTOM_IE,
 };
 
 #define MWIFIEX_SUB_COMMAND_SIZE	4
@@ -212,139 +205,6 @@ struct mwifiex_ssid_bssid {
 	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
 };
 
-#define MAX_BEACON_PERIOD 4000
-#define MIN_BEACON_PERIOD 50
-#define MAX_DTIM_PERIOD 100
-#define MIN_DTIM_PERIOD 1
-#define MAX_TX_POWER    20
-#define MIN_TX_POWER    0
-#define MAX_STA_COUNT   10
-#define MAX_RTS_THRESHOLD   2347
-#define MAX_FRAG_THRESHOLD 2346
-#define MIN_FRAG_THRESHOLD 256
-#define DATA_RATE_54M   108
-#define ANTENNA_MODE_A      0
-#define ANTENNA_MODE_B      1
-#define TX_ANTENNA          1
-#define RX_ANTENNA          0
-#define MAX_STAGE_OUT_TIME  864000
-#define MIN_STAGE_OUT_TIME  300
-#define MAX_RETRY_LIMIT         14
-
-#define MAX_GRP_TIMER           86400
-
-#define BAND_CONFIG_ACS_MODE    0x40
-#define BAND_CONFIG_MANUAL      0x00
-#define MWIFIEX_SCAN_CHANNEL_NUM    165
-
-#define MAX_DATA_RATES          14
-
-#define DATA_RATE_AUTO       0
-
-#define MAX_CHANNEL             14
-
-#define MAC_FILTER_MODE_DISABLE         0
-#define MAC_FILTER_MODE_ALLOW_MAC       1
-#define MAC_FILTER_MODE_BLOCK_MAC       2
-#define MAX_MAC_FILTER_NUM           16
-
-#define PROTOCOL_NO_SECURITY        0x01
-#define PROTOCOL_STATIC_WEP         0x02
-#define PROTOCOL_WPA                0x08
-#define PROTOCOL_WPA2               0x20
-#define PROTOCOL_WPA2_MIXED         0x28
-#define PROTOCOL_WAPI               0x80
-
-#define KEY_MGMT_NONE   0x04
-#define KEY_MGMT_PSK    0x02
-
-#define CIPHER_TKIP                 0x04
-#define CIPHER_AES_CCMP             0x08
-
-#define VALID_CIPHER_BITMAP         0x0c
-
-struct scan_chan_list {
-	u32 num_of_chan;
-	u16 chan[MWIFIEX_SCAN_CHANNEL_NUM];
-};
-
-struct mac_filter {
-	u16 filter_mode;
-	u16 mac_count;
-	u8 mac_list[ETH_ALEN][MAX_MAC_FILTER_NUM];
-};
-
-struct wpa_param {
-	u8 pairwise_cipher_wpa;
-	u8 pairwise_cipher_wpa2;
-	u8 group_cipher;
-	u8 rsn_protection;
-	u32 length;
-	u8 passphrase[64];
-	u32 gk_rekey_time;
-};
-
-struct wep_key {
-	u8 key_index;
-	u8 is_default;
-	u16 length;
-	u8 key[26];
-};
-
-struct wep_param {
-	struct wep_key key0;
-	struct wep_key key1;
-	struct wep_key key2;
-	struct wep_key key3;
-};
-
-/** mwifiex_bss_param
- * Note: For each entry you must enter an invalid value
- * in the MWIFIEX function woal_set_sys_config_invalid_data().
- * Otherwise for a valid data an unwanted TLV will be
- * added to that command.
- */
-struct mwifiex_uap_bss_param {
-	u8 mac_addr[ETH_ALEN];
-	struct mwifiex_802_11_ssid ssid;
-	u8 bcast_ssid_ctl;
-	u8 radio_ctl;
-	u8 dtim_period;
-	u16 beacon_period;
-	u8 rates[MAX_DATA_RATES];
-	u16 tx_data_rate;
-	u16 mcbc_data_rate;
-	u8 tx_power_level;
-	u8 tx_antenna;
-	u8 rx_antenna;
-	u8 pkt_forward_ctl;
-	u16 max_sta_count;
-	struct mac_filter filter;
-	u32 sta_ageout_timer;
-	u32 ps_sta_ageout_timer;
-	u16 rts_threshold;
-	u16 frag_threshold;
-	u16 retry_limit;
-	u32 pairwise_update_timeout;
-	u32 pwk_retries;
-	u32 groupwise_update_timeout;
-	u32 gwk_retries;
-	u8 preamble_type;
-	u8 band_cfg;
-	u8 channel;
-	struct scan_chan_list chan_list;
-	u16 auth_mode;
-	u16 protocol;
-	u16 key_mgmt;
-	struct wep_param wep_cfg;
-	struct wpa_param wpa_cfg;
-};
-
-struct mwifiex_deauth_param {
-	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	u16 reason_code;
-};
-
 struct mwifiex_ds_bss {
 	u32 sub_command;
 	union {
@@ -356,8 +216,6 @@ struct mwifiex_ds_bss {
 		u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
 		struct mwifiex_multicast_list multicast_list;
 		u32 atim_window;
-		struct mwifiex_uap_bss_param bss_config;
-		struct mwifiex_deauth_param deauth_param;
 	} param;
 };
 
@@ -420,28 +278,6 @@ struct mwifiex_ds_get_stats {
 	u32 wep_icv_error[4];
 };
 
-struct mwifiex_ds_uap_stats {
-	u32 tkip_mic_failures;
-	u32 ccmp_decrypt_errors;
-	u32 wep_undecryptable_count;
-	u32 wep_icv_error_count;
-	u32 decrypt_failure_count;
-	u32 mcast_tx_count;
-	u32 failed_count;
-	u32 retry_count;
-	u32 multi_retry_count;
-	u32 frame_dup_count;
-	u32 rts_success_count;
-	u32 rts_failure_count;
-	u32 ack_failure_count;
-	u32 rx_fragment_count;
-	u32 mcast_rx_frame_count;
-	u32 fcs_error_count;
-	u32 tx_frame_count;
-	u32 rsna_tkip_cm_invoked;
-	u32 rsna_4way_hshk_failures;
-};
-
 
 #define BCN_RSSI_LAST_MASK              0x00000001
 #define BCN_RSSI_AVG_MASK               0x00000002
@@ -576,19 +412,6 @@ struct mwifiex_debug_info {
 	u8 event_received;
 };
 
-#define MAX_NUM_CLIENTS         16
-
-struct sta_info {
-	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
-	u8 power_mfg_status;
-	s8 rssi;
-};
-
-struct mwifiex_ds_sta_list {
-	u16 sta_count;
-	struct sta_info info[MAX_NUM_CLIENTS];
-};
-
 struct mwifiex_ds_get_info {
 	u32 sub_command;
 	union {
@@ -598,9 +421,6 @@ struct mwifiex_ds_get_info {
 		struct mwifiex_ver_ext ver_ext;
 		struct mwifiex_bss_info bss_info;
 		struct mwifiex_debug_info debug_info;
-		struct mwifiex_ds_uap_stats ustats;
-		struct mwifiex_ds_sta_list sta_list;
-
 	} param;
 };
 
@@ -656,12 +476,12 @@ struct mwifiex_pmk {
 };
 
 struct mwifiex_ds_passphrase {
-	struct mwifiex_802_11_ssid ssid;
+	struct mwifiex_802_11_ssid        ssid;
 	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
-	u16 psk_type;
+	u16  psk_type;
 	union {
-		struct mwifiex_passphrase passphrase;
-		struct mwifiex_pmk pmk;
+		struct mwifiex_passphrase   passphrase;
+		struct mwifiex_pmk          pmk;
 	} psk;
 };
 
@@ -682,7 +502,6 @@ struct mwifiex_ds_sec_cfg {
 		struct mwifiex_ds_passphrase passphrase;
 		u32 ewpa_enabled;
 		struct mwifiex_ds_esupp_mode esupp_mode;
-		u8 sta_mac[MWIFIEX_MAC_ADDR_LENGTH];
 	} param;
 };
 
@@ -765,33 +584,6 @@ struct mwifiex_ds_pm_cfg {
 	} param;
 };
 
-struct ps_sleep_param {
-	u32 ctrl_bitmap;
-	u32 min_sleep;
-	u32 max_sleep;
-};
-
-struct inact_sleep_param {
-	u32 inactivity_to;
-	u32 min_awake;
-	u32 max_awake;
-};
-
-#define PS_FLAG_PS_MODE                 1
-#define PS_FLAG_SLEEP_PARAM             2
-#define PS_FLAG_INACT_SLEEP_PARAM       4
-
-#define PS_MODE_DISABLE                      0
-#define PS_MODE_PERIODIC_DTIM                1
-#define PS_MODE_INACTIVITY                   2
-
-struct mwifiex_ds_ps_mgmt {
-	u16 flags;
-	u16 ps_mode;
-	struct ps_sleep_param sleep_param;
-	struct inact_sleep_param inact_param;
-};
-
 struct mwifiex_ioctl_wmm_queue_status_ac {
 	u8 wmm_acm;
 	u8 flow_required;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index da13d42..aa26105 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -432,8 +432,8 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		auth_tlv->header.len = cpu_to_le16(sizeof(auth_tlv->auth_type));
 		if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
 			auth_tlv->auth_type =
-				cpu_to_le16((u16)priv->sec_info
-					.authentication_mode);
+				cpu_to_le16((u16) priv->sec_info.
+					    authentication_mode);
 		else
 			auth_tlv->auth_type =
 				cpu_to_le16(MWIFIEX_AUTH_MODE_OPEN);
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index f27a3f0..7359715 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -20,7 +20,6 @@
 #include	"main.h"
 #include	"wmm.h"
 #include	"cfg80211.h"
-#include	"uap.h"
 
 #define VERSION	"1.0"
 
@@ -29,69 +28,25 @@ const char driver_version[] = "mwifiex " VERSION " (%s) ";
 struct mwifiex_adapter *g_adapter;
 EXPORT_SYMBOL_GPL(g_adapter);
 
-static struct mwifiex_bss_attr mwifiex_bss_uap[] = {
-	{MWIFIEX_BSS_TYPE_UAP, MWIFIEX_DATA_FRAME_TYPE_ETH_II, true, 0, 0},
-};
-
 static struct mwifiex_bss_attr mwifiex_bss_sta[] = {
 	{MWIFIEX_BSS_TYPE_STA, MWIFIEX_DATA_FRAME_TYPE_ETH_II, true, 0, 0},
 };
 
-static struct mwifiex_bss_attr mwifiex_bss_multi[] = {
-	{MWIFIEX_BSS_TYPE_STA, MWIFIEX_DATA_FRAME_TYPE_ETH_II, true, 0, 0},
-	{MWIFIEX_BSS_TYPE_UAP, MWIFIEX_DATA_FRAME_TYPE_ETH_II, true, 0, 0},
-};
-
-static int drv_mode = DRV_MODE_UAP_STA;
+static int drv_mode = DRV_MODE_STA;
 
 static char fw_name[32] = DEFAULT_FW_NAME;
 
 /** Supported drv_mode table */
 static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
 	{
+	 /* drv_mode */
 	 .drv_mode = DRV_MODE_STA,
+	 /* intf number */
 	 .intf_num = ARRAY_SIZE(mwifiex_bss_sta),
+	 /* bss_attr */
 	 .bss_attr = mwifiex_bss_sta,
-	 },
-	{
-		.drv_mode = DRV_MODE_UAP,
-		.intf_num =  ARRAY_SIZE(mwifiex_bss_uap),
-		.bss_attr = mwifiex_bss_uap,
-	},
-	{
-	 .drv_mode = DRV_MODE_UAP_STA,
-	 .intf_num = ARRAY_SIZE(mwifiex_bss_multi),
-	 .bss_attr = mwifiex_bss_multi,
-	 },
-};
-
-static struct mwifiex_operations mwifiex_sta_ops = {
-	.init_cmd = mwifiex_ops_sta_init_cmd,
-	.ioctl = mwifiex_ops_sta_ioctl,
-	.prepare_cmd = mwifiex_ops_sta_prepare_cmd,
-	.process_cmdresp = mwifiex_ops_sta_process_cmdresp,
-	.process_rx_packet = mwifiex_ops_sta_process_rx_packet,
-	.process_event = mwifiex_ops_sta_process_event,
-	.process_txpd = mwifiex_ops_sta_process_txpd,
-	.bss_role = MWIFIEX_BSS_ROLE_STA,
-};
-
-static struct mwifiex_operations mwifiex_uap_ops = {
-	.init_cmd = mwifiex_ops_uap_init_cmd,
-	.ioctl = mwifiex_ops_uap_ioctl,
-	.prepare_cmd = mwifiex_ops_uap_prepare_cmd,
-	.process_cmdresp = mwifiex_ops_uap_process_cmdresp,
-	.process_rx_packet = mwifiex_ops_uap_process_rx_packet,
-	.process_event = mwifiex_ops_uap_process_event,
-	.process_txpd = mwifiex_ops_uap_process_txpd,
-	.bss_role = MWIFIEX_BSS_ROLE_UAP,
-};
-
-/** mwifiex function table */
-static struct mwifiex_operations *mwifiex_ops[] = {
-	&mwifiex_sta_ops,
-	&mwifiex_uap_ops,
-	NULL,
+	 }
+	,
 };
 
 u32 drvdbg = MMSG | MFATAL | MERROR;
@@ -120,7 +75,6 @@ mwifiex_register(void *card,
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_adapter *adapter = NULL;
 	u8 i = 0;
-	u32 j = 0;
 
 	ENTER();
 
@@ -185,18 +139,6 @@ mwifiex_register(void *card,
 			adapter->priv[i]->bss_index = i;
 			adapter->priv[i]->bss_num =
 				mdevice->bss_attr[i].bss_num;
-
-			/* init function table */
-			for (j = 0; mwifiex_ops[j]; j++) {
-				if (mwifiex_ops[j]->bss_role ==
-						GET_BSS_ROLE(
-							adapter->priv[i])) {
-					memcpy(&adapter->priv[i]->ops,
-					       mwifiex_ops[j],
-					       sizeof(
-					       struct mwifiex_operations));
-				}
-			}
 		}
 	}
 
@@ -805,12 +747,6 @@ static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 	return &priv->stats;
 }
 
-static void mwifiex_uap_set_multicast_list(struct net_device *dev)
-{
-	ENTER();
-	LEAVE();
-}
-
 /** Network device handlers */
 static const struct net_device_ops mwifiex_netdev_ops = {
 	.ndo_open = mwifiex_open,
@@ -842,7 +778,7 @@ static const struct net_device_ops mwifiex_netdev_ops = {
  * In addition, the CFG80211 work queue is also created.
  */
 static void
-mwifiex_init_sta_dev(struct mwifiex_private *priv, struct net_device *dev)
+mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
 {
 	ENTER();
 
@@ -863,34 +799,6 @@ mwifiex_init_sta_dev(struct mwifiex_private *priv, struct net_device *dev)
 	LEAVE();
 }
 
-static const struct net_device_ops mwifiex_uap_netdev_ops = {
-	.ndo_open = mwifiex_open,
-	.ndo_stop = mwifiex_close,
-	.ndo_start_xmit = mwifiex_hard_start_xmit,
-	.ndo_set_mac_address = mwifiex_set_mac_address,
-	.ndo_tx_timeout = mwifiex_tx_timeout,
-	.ndo_get_stats = mwifiex_get_stats,
-	.ndo_set_multicast_list = mwifiex_uap_set_multicast_list,
-};
-
-static enum mwifiex_status mwifiex_init_uap_dev(struct net_device *dev,
-		struct mwifiex_private *priv)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	dev->netdev_ops = &mwifiex_uap_netdev_ops;
-
-	/* Initialize private structure */
-	init_waitqueue_head(&priv->ioctl_wait_q);
-	init_waitqueue_head(&priv->cmd_wait_q);
-	priv->media_connected = false;
-
-	LEAVE();
-	return status;
-}
-
 /*
  * This function adds a new logical interface.
  *
@@ -913,15 +821,8 @@ static struct mwifiex_private *mwifiex_add_interface(
 
 	ENTER();
 
-	if (bss_type == MWIFIEX_BSS_TYPE_STA)
-		dev = alloc_netdev_mq(sizeof(struct mwifiex_private *),
-				"mlan%d",
-				ether_setup, 1);
-	else if (bss_type == MWIFIEX_BSS_TYPE_UAP)
-		dev = alloc_netdev_mq(sizeof(struct mwifiex_private *),
-				"uap%d",
-				ether_setup, 1);
-
+	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
+			      ether_setup, 1);
 	if (!dev) {
 		PRINTM(MERROR, "No memory available\n");
 		goto error;
@@ -943,18 +844,10 @@ static struct mwifiex_private *mwifiex_add_interface(
 
 	priv->netdev = dev;
 
-	if (bss_type == MWIFIEX_BSS_TYPE_STA) {
-		sema_init(&priv->async_sem, 1);
-		priv->scan_pending_on_block = false;
-
-		mwifiex_init_sta_dev(priv, dev);
-	}
+	sema_init(&priv->async_sem, 1);
+	priv->scan_pending_on_block = false;
 
-	if (bss_type == MWIFIEX_BSS_TYPE_UAP) {
-		if (MWIFIEX_STATUS_SUCCESS !=
-				mwifiex_init_uap_dev(dev, priv))
-			goto error;
-	}
+	mwifiex_init_priv_params(priv, dev);
 
 	SET_NETDEV_DEV(dev, adapter->hotplug_device);
 
@@ -964,9 +857,6 @@ static struct mwifiex_private *mwifiex_add_interface(
 		goto error;
 	}
 
-	netif_carrier_off(dev);
-	netif_stop_queue(dev);
-
 	PRINTM(MINFO, "%s: Marvell 802.11 Adapter\n", dev->name);
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_init(priv);
@@ -1030,12 +920,9 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 	if (dev)
 		free_netdev(dev);
 
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
-		cancel_work_sync(&priv->cfg_workqueue);
-		flush_workqueue(priv->workqueue);
-		destroy_workqueue(priv->workqueue);
-	}
-
+	cancel_work_sync(&priv->cfg_workqueue);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
 	wiphy_unregister(priv->wdev->wiphy);
 	wiphy_free(priv->wdev->wiphy);
 	kfree(priv->wdev);
@@ -1148,37 +1035,6 @@ int mwifiex_atox(char *a)
 }
 
 /*
- * This function returns integer value of a given ascii string
- */
-enum mwifiex_status mwifiex_atoi(int *data, char *a)
-{
-	int i, val = 0, len;
-
-	ENTER();
-
-	len = strlen(a);
-	if (!strncmp(a, "0x", 2)) {
-		a = a + 2;
-		len -= 2;
-		*data = mwifiex_atox(a);
-		return MWIFIEX_STATUS_SUCCESS;
-	}
-	for (i = 0; i < len; i++) {
-		if (isdigit(a[i])) {
-			val = val * 10 + (a[i] - '0');
-		} else {
-			PRINTM(MERROR, "Invalid char %c in string %s\n"
-					, a[i], a);
-			return MWIFIEX_STATUS_FAILURE;
-		}
-	}
-	*data = val;
-
-	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
  *  This function is an extension of strsep lib command. The function will also
  *  take care of an escape character
  */
@@ -1408,7 +1264,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int i;
 	struct mwifiex_adapter *adapter = NULL;
-	struct mwifiex_drv_mode *drv_mode_info = &mwifiex_drv_mode_tbl[2];
+	struct mwifiex_drv_mode *drv_mode_info = &mwifiex_drv_mode_tbl[0];
 
 	ENTER();
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c8450c3..8972566 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -130,9 +130,6 @@ struct mwifiex_drv_mode {
 #define MWIFIEX_TYPE_DATA				0
 #define MWIFIEX_TYPE_EVENT				3
 
-#define RX_HIGH_THRESHOLD				60
-#define RX_LOW_THRESHOLD				15
-
 #define DBG_CMD_NUM						5
 
 #define MAX_BITMAP_RATES_SIZE			10
@@ -324,28 +321,6 @@ struct wps {
 struct mwifiex_adapter;
 struct mwifiex_private;
 
-struct mwifiex_operations {
-	enum mwifiex_status (*init_cmd) (struct mwifiex_private *priv,
-					 u8 first_sta);
-	enum mwifiex_status (*ioctl) (struct mwifiex_adapter *adapter,
-				      struct mwifiex_ioctl_req *ioctl_req);
-	enum mwifiex_status (*prepare_cmd)(struct mwifiex_private *priv,
-					   u16 cmd_no, u16 cmd_action,
-					   u32 cmd_oid, void *ioctl_buf,
-					   void *data_buf, void *cmd_buf);
-	enum mwifiex_status (*process_cmdresp)(struct mwifiex_private *priv,
-					       u16 cmdresp_no, void *cmd_buf,
-					       void *ioctl);
-	enum mwifiex_status (*process_rx_packet) (struct
-						  mwifiex_adapter *
-						  adapter,
-						  struct mwifiex_buffer *buf);
-	enum mwifiex_status (*process_event) (struct mwifiex_private *priv);
-	void *(*process_txpd) (struct mwifiex_private *priv,
-				struct mwifiex_buffer *buf);
-	enum mwifiex_bss_role bss_role;
-};
-
 struct mwifiex_private {
 	struct mwifiex_adapter *adapter;
 	u8 bss_index;
@@ -368,8 +343,6 @@ struct mwifiex_private {
 	u8 tx_rate;
 	u8 tx_htinfo;
 	u8 rxpd_htinfo;
-	u8 is_11n_enabled;
-	u8 pkt_fwd;
 	u8 rxpd_rate;
 	u16 rate_bitmap;
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
@@ -405,7 +378,6 @@ struct mwifiex_private {
 	struct host_cmd_ds_802_11_key_material aes_key;
 	u8 wapi_ie[256];
 	u8 wapi_ie_len;
-	struct mwifiex_list_head sta_list;
 	u8 wmm_required;
 	u8 wmm_enabled;
 	u8 wmm_qosinfo;
@@ -467,8 +439,6 @@ struct mwifiex_private {
 	struct dentry *dfs_txbufcfg;
 	struct dentry *dfs_passphrase;
 	struct dentry *dfs_esuppmode;
-	struct dentry *dfs_bssctrl;
-	struct dentry *dfs_apcfg;
 #endif
 	u8 nick_name[16];
 	bool is_adhoc_link_sensed;
@@ -492,7 +462,6 @@ struct mwifiex_private {
 	struct work_struct cfg_workqueue;
 	u8 country_code[COUNTRY_CODE_LEN];
 	struct wps wps;
-	struct mwifiex_operations ops;
 	u8 scan_block;
 };
 
@@ -554,16 +523,6 @@ struct cmd_ctrl_node {
 	struct mwifiex_buffer *mbuf;
 };
 
-struct sta_node {
-	struct sta_node *pprev;
-	struct sta_node *pnext;
-	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	u8 is_11n_enabled;
-	u8 ampdu_sta[MAX_NUM_TID];
-	u16 rx_seq[MAX_NUM_TID];
-	u8 wapi_key_on;
-};
-
 struct mwifiex_if_ops {
 	enum mwifiex_status (*init_if) (struct mwifiex_adapter *);
 	void (*cleanup_if) (struct mwifiex_adapter *);
@@ -689,8 +648,6 @@ struct mwifiex_adapter {
 	u8 adhoc_11n_enabled;
 	u8 chan_offset;
 	struct mwifiex_dbg dbg;
-	u16 pending_bridge_pkts;
-	u16 rx_pause_flag;
 	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
 	u32 arp_filter_size;
 };
@@ -825,22 +782,22 @@ enum mwifiex_status mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 void mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv);
 enum mwifiex_status mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 					      struct mwifiex_buffer *mbuf);
-enum mwifiex_status mwifiex_ops_sta_ioctl(struct mwifiex_adapter *,
+enum mwifiex_status mwifiex_sta_ioctl(struct mwifiex_adapter *,
 				      struct mwifiex_ioctl_req *ioctl_req);
-enum mwifiex_status mwifiex_ops_sta_prepare_cmd(struct mwifiex_private *,
+enum mwifiex_status mwifiex_sta_prepare_cmd(struct mwifiex_private *,
 						uint16_t cmd_no,
 					    u16 cmd_action, u32 cmd_oid,
 					    void *ioctl_buf, void *data_buf,
 					    void *cmd_buf);
-enum mwifiex_status mwifiex_ops_sta_process_cmdresp(struct mwifiex_private *,
+enum mwifiex_status mwifiex_process_sta_cmdresp(struct mwifiex_private *,
 						u16 cmdresp_no,
 						void *cmd_buf, void *ioctl);
-enum mwifiex_status mwifiex_ops_sta_process_rx_packet(struct mwifiex_adapter *,
+enum mwifiex_status mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
 						  struct mwifiex_buffer *mbuf);
-enum mwifiex_status mwifiex_ops_sta_process_event(struct mwifiex_private *);
-void *mwifiex_ops_sta_process_txpd(struct mwifiex_private *,
+enum mwifiex_status mwifiex_process_sta_event(struct mwifiex_private *);
+void *mwifiex_process_sta_txpd(struct mwifiex_private *,
 				struct mwifiex_buffer *mbuf);
-enum mwifiex_status mwifiex_ops_sta_init_cmd(struct mwifiex_private *,
+enum mwifiex_status mwifiex_sta_init_cmd(struct mwifiex_private *,
 						u8 first_sta);
 enum mwifiex_status mwifiex_scan_networks(struct mwifiex_private *priv,
 					  void *ioctl_buf,
@@ -947,17 +904,6 @@ enum mwifiex_status mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 					    struct host_cmd_ds_command *resp,
 					    void *ioctl_buf);
 
-struct sta_node *mwifiex_get_station_entry(struct mwifiex_private *priv,
-						u8 *mac);
-void mwifiex_delete_station_list(struct mwifiex_private *priv);
-struct sta_node *mwifiex_add_station_entry(struct mwifiex_private *priv,
-						u8 *mac);
-enum mwifiex_status mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
-					       struct mwifiex_buffer *mbuf);
-
-enum mwifiex_status mwifiex_uap_recv_packet(struct mwifiex_private *priv,
-					 struct mwifiex_buffer *mbuf);
-
 /*
  * This function checks if the queuing is RA based or not.
  */
@@ -1054,7 +1000,6 @@ enum mwifiex_status mwifiex_shutdown_fw(struct mwifiex_private *, u8);
 
 char *mwifiex_strsep(char **s, char delim, char esc);
 int mwifiex_atox(char *a);
-enum mwifiex_status mwifiex_atoi(int *data, char *a);
 void mwifiex_mac2u8(u8 *mac_addr, char *buf);
 int mwifiex_ascii2hex(u8 *d, char *s, u32 dlen);
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index ab392d4..132347d 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2136,10 +2136,6 @@ mwifiex_sdio_cleanup_module(void)
 			mwifiex_disconnect(adapter->priv[i], MWIFIEX_CMD_WAIT,
 					   NULL);
 		}
-
-		if (GET_BSS_ROLE(adapter->priv[i]) == MWIFIEX_BSS_ROLE_UAP)
-				mwifiex_disconnect(adapter->priv[i],
-						   MWIFIEX_CMD_WAIT, NULL);
 	}
 
 	if (!adapter->surprise_removed)
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 5f4b29c..51206db 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1267,7 +1267,7 @@ mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
  * routines based upon the command number.
  */
 enum mwifiex_status
-mwifiex_ops_sta_prepare_cmd(struct mwifiex_private *priv,
+mwifiex_sta_prepare_cmd(struct mwifiex_private *priv,
 			uint16_t cmd_no,
 			u16 cmd_action,
 			u32 cmd_oid,
@@ -1487,7 +1487,7 @@ mwifiex_ops_sta_prepare_cmd(struct mwifiex_private *priv,
  *      - Set MAC control (this must be the last command to initialize firmware)
  */
 enum mwifiex_status
-mwifiex_ops_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
+mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	u16 enable = true;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index d59f0a5..5ae2c8e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1382,7 +1382,7 @@ mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
  * response handlers based on the command ID.
  */
 enum mwifiex_status
-mwifiex_ops_sta_process_cmdresp(struct mwifiex_private *priv,
+mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 			    u16 cmdresp_no, void *cmd_buf, void *ioctl)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 743a673..005f522 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -232,7 +232,7 @@ mwifiex_2040_coex_event(struct mwifiex_private *priv)
  *      - EVENT_AMSDU_AGGR_CTRL
  */
 enum mwifiex_status
-mwifiex_ops_sta_process_event(struct mwifiex_private *priv)
+mwifiex_process_sta_event(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index ff3629c..0bcb1ac 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -39,7 +39,6 @@ mwifiex_ioctl(struct mwifiex_adapter *adapter,
 	      struct mwifiex_ioctl_req *ioctl_req)
 {
 	enum mwifiex_status ret;
-	struct mwifiex_private *priv = NULL;
 
 	ENTER();
 
@@ -55,8 +54,7 @@ mwifiex_ioctl(struct mwifiex_adapter *adapter,
 		goto exit;
 	}
 
-	priv = adapter->priv[ioctl_req->bss_index];
-	ret = priv->ops.ioctl(adapter, ioctl_req);
+	ret = mwifiex_sta_ioctl(adapter, ioctl_req);
 
 exit:
 	LEAVE();
@@ -6162,7 +6160,7 @@ mwifiex_scan_ioctl(struct mwifiex_adapter *adapter,
  *      MWIFIEX_IOCTL_MISC_CFG - Other miscellaneous IOCTLs
  */
 enum mwifiex_status
-mwifiex_ops_sta_ioctl(struct mwifiex_adapter *adapter,
+mwifiex_sta_ioctl(struct mwifiex_adapter *adapter,
 			struct mwifiex_ioctl_req *ioctl_req)
 {
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 7b506f2..504c377 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -184,7 +184,7 @@ done:
  * The completion callback is called after processing in complete.
  */
 enum mwifiex_status
-mwifiex_ops_sta_process_rx_packet(struct mwifiex_adapter *adapter,
+mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 				struct mwifiex_buffer *mbuf)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 05901a0..b80d245 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -43,7 +43,7 @@
  *      - Flags
  */
 void *
-mwifiex_ops_sta_process_txpd(struct mwifiex_private *priv,
+mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 				struct mwifiex_buffer *mbuf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 13a0290..a05f2d8 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -54,7 +54,7 @@ mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
 	mbuf->bss_index = priv->bss_index;
-	ret = priv->ops.process_rx_packet(adapter, mbuf);
+	ret = mwifiex_process_sta_rx_packet(adapter, mbuf);
 
 	LEAVE();
 	return ret;
@@ -82,7 +82,7 @@ mwifiex_process_tx(struct mwifiex_private *priv, struct mwifiex_buffer *mbuf,
 
 	ENTER();
 
-	head_ptr = (u8 *)priv->ops.process_txpd(priv, mbuf);
+	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, mbuf);
 	if (!head_ptr) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
@@ -158,27 +158,8 @@ mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 
 		if (mbuf->flags & MWIFIEX_FLAG_TX_BUF)
 			mwifiex_send_packet_complete(adapter, mbuf, status);
-		else {
-			if (mbuf->flags & MWIFIEX_BUF_FLAG_BRIDGE_BUF) {
-				adapter->pending_bridge_pkts--;
-				if (adapter->rx_pause_flag &&
-						(adapter->pending_bridge_pkts <=
-						 RX_LOW_THRESHOLD)) {
-					adapter->rx_pause_flag = false;
-					if (mwifiex_prepare_cmd(
-							adapter->priv[
-							mbuf->bss_index],
-							HOST_CMD_RX_DATA_PAUSE,
-							HostCmd_ACT_GEN_SET, 0,
-							NULL, NULL) !=
-							MWIFIEX_STATUS_SUCCESS)
-						PRINTM(MERROR, "Could not send "
-								"Rx data pause "
-								"command\n");
-				}
-			}
+		else
 			mwifiex_free_buffer(mbuf);
-		}
 	}
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/uap.c b/drivers/net/wireless/mwifiex/uap.c
deleted file mode 100644
index c94bdf4..0000000
--- a/drivers/net/wireless/mwifiex/uap.c
+++ /dev/null
@@ -1,99 +0,0 @@
-/**
- * Marvell Wireless LAN device driver: major functions in UAP
- * driver.
- *
- * Copyright (C) 2010, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available by writing to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
- * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
-
-#include    "main.h"
-#include    "uap.h"
-
-/*
- * Set/Get system configuration parameters
- */
-enum mwifiex_status
-mwifiex_set_get_sys_config(struct mwifiex_private *priv, u16 action,
-		struct mwifiex_uap_bss_param *sys_cfg)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
-
-	ENTER();
-
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
-
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_UAP_BSS_CONFIG;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = action;
-
-	if (action == MWIFIEX_ACT_SET)
-		memcpy(&bss->param.bss_config, sys_cfg,
-					sizeof(struct mwifiex_uap_bss_param));
-
-	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
-
-	if (action == MWIFIEX_ACT_GET)
-		memcpy(sys_cfg, &bss->param.bss_config,
-					sizeof(struct mwifiex_uap_bss_param));
-
-done:
-	kfree(req);
-	LEAVE();
-	return ret;
-}
-
-/*
- * Set invalid data for each member of mwifiex_uap_bss_param
- */
-void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config)
-{
-	ENTER();
-
-	memset(config, 0, sizeof(struct mwifiex_uap_bss_param));
-	config->bcast_ssid_ctl = 0x7F;
-	config->radio_ctl = 0x7F;
-	config->dtim_period = 0x7F;
-	config->beacon_period = 0x7FFF;
-	config->tx_data_rate = 0x7FFF;
-	config->mcbc_data_rate = 0x7FFF;
-	config->tx_power_level = 0x7F;
-	config->tx_antenna = 0x7F;
-	config->rx_antenna = 0x7F;
-	config->pkt_forward_ctl = 0x7F;
-	config->max_sta_count = 0x7FFF;
-	config->auth_mode = 0x7F;
-	config->sta_ageout_timer = 0x7FFFFFFF;
-	config->ps_sta_ageout_timer = 0x7FFFFFFF;
-	config->rts_threshold = 0x7FFF;
-	config->frag_threshold = 0x7FFF;
-	config->retry_limit = 0x7FFF;
-	config->filter.filter_mode = 0x7FFF;
-	config->filter.mac_count = 0x7FFF;
-	config->wpa_cfg.rsn_protection = 0x7F;
-	config->wpa_cfg.gk_rekey_time = 0x7FFFFFFF;
-
-	LEAVE();
-}
diff --git a/drivers/net/wireless/mwifiex/uap.h b/drivers/net/wireless/mwifiex/uap.h
deleted file mode 100644
index 645e483..0000000
--- a/drivers/net/wireless/mwifiex/uap.h
+++ /dev/null
@@ -1,160 +0,0 @@
-/**
- * Marvell Wireless LAN device driver: uap driver specific defines etc.
- * driver.
- *
- * Copyright (C) 2010, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available by writing to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
- * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- *
- **/
-
-#ifndef _MWIFIEX_UAP_H
-#define _MWIFIEX_UAP_H
-
-#define UAP_HOSTCMD			(SIOCDEVPRIVATE + 1)
-#define UAP_IOCTL_CMD			(SIOCDEVPRIVATE + 2)
-#define UAP_POWER_MODE			(SIOCDEVPRIVATE + 3)
-#define UAP_BSS_CTRL			(SIOCDEVPRIVATE + 4)
-#define UAP_BSS_CONFIG			(SIOCDEVPRIVATE + 6)
-#define UAP_STA_DEAUTH			(SIOCDEVPRIVATE + 7)
-#define UAP_WAPI_MSG			(SIOCDEVPRIVATE + 10)
-#define UAP_GET_STA_LIST		(SIOCDEVPRIVATE + 11)
-#define UAP_HS_CFG			(SIOCDEVPRIVATE + 14)
-#define UAP_GET_BSS_TYPE		(SIOCDEVPRIVATE + 15)
-
-#define UAP_ADDBA_PARA			0
-#define UAP_AGGR_PRIOTBL		1
-#define UAP_ADDBA_REJECT		2
-#define UAP_DEEP_SLEEP			3
-
-
-#define UAP_BSS_START			0
-#define UAP_BSS_STOP			1
-#define UAP_BSS_RESET			2
-#define BSS_START_REDUNDANT		3
-#define BSS_STOP_REDUNDANT		2
-
-struct wapi_msg {
-	u16 msg_type;
-	u16 msg_len;
-	u8 msg[96];
-};
-
-struct wapi_key_msg {
-	u8	mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
-	u8	pad;
-	u8	key_id;
-	u8	key[32];
-};
-
-#define P80211_PACKET_WAPIFLAG     0x0001
-#define P80211_PACKET_SETKEY      0x0003
-#define WAPI_MODE_PSK    0x04
-#define WAPI_MODE_CERT   0x08
-
-#define UAP_EVENT_ID_HS_WAKEUP             0x80000001
-#define UAP_EVENT_ID_DRV_HS_ACTIVATED      0x80000002
-#define UAP_EVENT_ID_DRV_HS_DEACTIVATED    0x80000003
-
-#define HS_CFG_FLAG_GET         0
-#define HS_CFG_FLAG_SET         1
-#define HS_CFG_FLAG_CONDITION   2
-#define HS_CFG_FLAG_GPIO        4
-#define HS_CFG_FLAG_GAP         8
-#define HS_CFG_FLAG_ALL         0x0f
-#define HS_CFG_CONDITION_MASK   0x0f
-
-struct ds_hs_cfg {
-	/** Bit0: 0 - Get, 1 Set
-	 *  Bit1: 1 - conditions is valid
-	 *  Bit2: 2 - gpio is valid
-	 *  Bit3: 3 - gap is valid
-	 */
-	u32 flags;
-	/** Host sleep config condition */
-	/** Bit0: non-unicast data
-	 *  Bit1: unicast data
-	 *  Bit2: mac events
-	 *  Bit3: magic packet
-	 */
-	u32  conditions;
-	u32  gpio;
-	u32  gap;
-};
-
-struct addba_param {
-	u32 subcmd;
-	u32 action;
-	u32 timeout;
-	u32 txwinsize;
-	u32 rxwinsize;
-};
-
-struct aggr_prio_tbl {
-	u32 subcmd;
-	u32 action;
-	u8  ampdu[MAX_NUM_TID];
-	u8  amsdu[MAX_NUM_TID];
-};
-
-struct addba_reject_para {
-	u32 subcmd;
-	u32 action;
-	u8  addba_reject[MAX_NUM_TID];
-};
-
-struct deep_sleep_para {
-	u32 subcmd;
-	u32 action;
-	u16 deep_sleep;
-	u16  idle_time;
-};
-
-int mwifiex_uap_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd);
-void mwifiex_uap_get_version(struct mwifiex_private *priv, char *version,
-			     int max_len);
-enum mwifiex_status mwifiex_uap_get_stats(struct mwifiex_private *priv,
-					  u8 wait_option,
-					  struct mwifiex_ds_uap_stats *ustats);
-extern struct iw_handler_def mwifiex_uap_handler_def;
-struct iw_statistics *mwifiex_get_uap_wireless_stats(struct net_device *dev);
-int mwifiex_uap_do_priv_ioctl(struct net_device *dev,
-			      struct ifreq *req, int cmd);
-void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config);
-enum mwifiex_status mwifiex_set_get_sys_config(struct mwifiex_private *priv,
-		u16 action,
-		struct mwifiex_uap_bss_param *sys_cfg);
-enum mwifiex_status mwifiex_ops_uap_ioctl(struct mwifiex_adapter *adapter,
-				      struct mwifiex_ioctl_req *ioctl_req);
-enum mwifiex_status mwifiex_ops_uap_prepare_cmd(struct mwifiex_private *priv,
-					    uint16_t cmd_no,
-					    u16 cmd_action, u32 cmd_oid,
-					    void *ioctl_buf, void *data_buf,
-					    void *cmd_buf);
-enum mwifiex_status
-mwifiex_ops_uap_process_cmdresp(struct mwifiex_private *priv,
-				u16 cmdresp_no,
-				void *cmd_buf, void *ioctl);
-enum mwifiex_status mwifiex_ops_uap_process_rx_packet(
-						struct mwifiex_adapter *adapter,
-						struct mwifiex_buffer *mbuf);
-enum mwifiex_status mwifiex_ops_uap_process_event(struct mwifiex_private *priv);
-void *mwifiex_ops_uap_process_txpd(struct mwifiex_private *priv,
-			       struct mwifiex_buffer *mbuf);
-enum mwifiex_status mwifiex_ops_uap_init_cmd(struct mwifiex_private *priv,
-					 u8 first_sta);
-int mwifiex_uap_bss_ctrl(struct mwifiex_private *priv, int data);
-int mwifiex_uap_ap_cfg_parse_data(struct mwifiex_uap_bss_param *ap_cfg,
-				  s8 *buf);
-#endif /* _MWIFIEX_UAP_H_ */
diff --git a/drivers/net/wireless/mwifiex/uap_cmdevent.c b/drivers/net/wireless/mwifiex/uap_cmdevent.c
deleted file mode 100644
index 70df390..0000000
--- a/drivers/net/wireless/mwifiex/uap_cmdevent.c
+++ /dev/null
@@ -1,1544 +0,0 @@
-/**
- * Marvell Wireless LAN device driver: handling of AP mode command and event
- *
- * Copyright (C) 2010, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available by writing to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
- * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
-
-#include "main.h"
-#include "uap.h"
-#include "wmm.h"
-
-/*
- * This function handles the command response error
- */
-static void
-uap_process_cmdresp_error(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *resp,
-			  struct mwifiex_ioctl_req *pioctl_buf)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-
-	ENTER();
-
-	PRINTM(MERROR, "CMD_RESP: cmd %#x error, result=%#x\n", resp->command,
-								resp->result);
-	if (pioctl_buf)
-		pioctl_buf->status_code = le16_to_cpu(resp->result);
-	/*
-	 * Handling errors here
-	 */
-	mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
-
-	mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
-	adapter->curr_cmd = NULL;
-	mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
-
-	LEAVE();
-	return;
-}
-
-/*
- * This function prepares command for config uap settings
- */
-static enum mwifiex_status mwifiex_uap_cmd_ap_config(
-		struct mwifiex_private *priv,
-		struct host_cmd_ds_command *cmd,
-		u16 cmd_action,
-		struct mwifiex_ioctl_req *pioctl_buf)
-{
-	struct mwifiex_ds_bss *bss = NULL;
-	struct host_cmd_ds_sys_config *sys_config =
-				(struct host_cmd_ds_sys_config *)&cmd->params
-								.sys_config;
-	u8 *tlv = NULL;
-	struct mwifiex_ie_types_macaddr *tlv_mac = NULL;
-	struct mwifiex_ie_types_ssid_param_set *tlv_ssid = NULL;
-	struct mwifiex_ie_types_beacon_period *tlv_beacon_period = NULL;
-	struct mwifiex_ie_types_dtim_period *tlv_dtim_period = NULL;
-	struct mwifiex_ie_types_rates_param_set *tlv_rates = NULL;
-	struct mwifiex_ie_types_tx_rate *tlv_txrate = NULL;
-	struct mwifiex_ie_types_mcbc_rate *tlv_mcbc_rate = NULL;
-	struct mwifiex_ie_types_tx_power *tlv_tx_power = NULL;
-	struct mwifiex_ie_types_bcast_ssid *tlv_bcast_ssid = NULL;
-	struct mwifiex_ie_types_antenna_mode *tlv_antenna = NULL;
-	struct mwifiex_ie_types_pkt_forward *tlv_pkt_forward = NULL;
-	struct mwifiex_ie_types_max_sta_count *tlv_sta_count = NULL;
-	struct mwifiex_ie_types_sta_ageout *tlv_sta_ageout = NULL;
-	struct mwifiex_ie_types_ps_sta_ageout *tlv_ps_sta_ageout = NULL;
-	struct mwifiex_ie_types_rts_threshold *tlv_rts_threshold = NULL;
-	struct mwifiex_ie_types_frag_threshold *tlv_frag_threshold = NULL;
-	struct mwifiex_ie_types_retry_limit *tlv_retry_limit = NULL;
-	struct mwifiex_ie_types_eapol_pwk_hsk_timeout *tlv_pairwise_timeout =
-									NULL;
-	struct mwifiex_ie_types_eapol_pwk_hsk_retries *tlv_pairwise_retries =
-									NULL;
-	struct mwifiex_ie_types_eapol_gwk_hsk_timeout *tlv_groupwise_timeout =
-									NULL;
-	struct mwifiex_ie_types_eapol_gwk_hsk_retries *tlv_groupwise_retries =
-									NULL;
-	struct mwifiex_ie_types_mac_filter *tlv_mac_filter = NULL;
-	struct mwifiex_ie_types_channel_band *tlv_chan_band = NULL;
-	struct mwifiex_ie_types_chan_list_param_set *tlv_chan_list = NULL;
-	struct mwifiex_chan_scan_param_set *pscan_chan = NULL;
-	struct mwifiex_ie_types_auth_type *tlv_auth_type = NULL;
-	struct mwifiex_ie_types_encrypt_protocol *tlv_encrypt_protocol = NULL;
-	struct mwifiex_ie_types_akmp *tlv_akmp = NULL;
-	struct mwifiex_ie_types_cipher *tlv_cipher = NULL;
-	struct mwifiex_ie_types_pwk_cipher *tlv_pwk_cipher = NULL;
-	struct mwifiex_ie_types_gwk_cipher *tlv_gwk_cipher = NULL;
-	struct mwifiex_ie_types_rsn_replay_prot *tlv_rsn_prot = NULL;
-	struct mwifiex_ie_types_passphrase *tlv_passphrase = NULL;
-	struct mwifiex_ie_types_group_rekey_time *tlv_rekey_time = NULL;
-	struct mwifiex_ie_types_wep_key *tlv_wep_key = NULL;
-	struct mwifiex_ie_types_radio_control *tlv_radio_control = NULL;
-
-	u32 cmd_size = 0;
-	u8 zero_mac[] = {0, 0, 0, 0, 0, 0 };
-	u16 i;
-
-	ENTER();
-
-	if (pioctl_buf == NULL) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	bss =  (struct mwifiex_ds_bss *)pioctl_buf->buffer;
-
-	cmd->command = cpu_to_le16(HOST_CMD_APCMD_SYS_CONFIGURE);
-	sys_config->action = cpu_to_le16(cmd_action);
-	cmd_size = sizeof(struct host_cmd_ds_sys_config) - 1 + S_DS_GEN;
-
-	tlv = (u8 *)sys_config->tlv_buffer;
-	if (memcmp(zero_mac, &bss->param.bss_config.mac_addr,
-					MWIFIEX_MAC_ADDR_LENGTH)) {
-		tlv_mac = (struct mwifiex_ie_types_macaddr *)tlv;
-		tlv_mac->header.type = cpu_to_le16(TLV_TYPE_UAP_MAC_ADDRESS);
-		tlv_mac->header.len = cpu_to_le16(MWIFIEX_MAC_ADDR_LENGTH);
-		memcpy(tlv_mac->mac, &bss->param.bss_config.mac_addr,
-						MWIFIEX_MAC_ADDR_LENGTH);
-		cmd_size += sizeof(struct mwifiex_ie_types_macaddr);
-		tlv += sizeof(struct mwifiex_ie_types_macaddr);
-	}
-
-	if (bss->param.bss_config.ssid.ssid_len) {
-		tlv_ssid = (struct mwifiex_ie_types_ssid_param_set *)tlv;
-		tlv_ssid->header.type = cpu_to_le16(TLV_TYPE_SSID);
-		tlv_ssid->header.len = cpu_to_le16(
-				(u16)bss->param.bss_config.ssid.ssid_len);
-		memcpy(tlv_ssid->ssid, bss->param.bss_config.ssid.ssid,
-				bss->param.bss_config.ssid.ssid_len);
-		cmd_size += sizeof(struct mwifiex_ie_types_header) +
-				bss->param.bss_config.ssid.ssid_len;
-		tlv += sizeof(struct mwifiex_ie_types_header) +
-				bss->param.bss_config.ssid.ssid_len;
-	}
-
-	if ((bss->param.bss_config.beacon_period >= MIN_BEACON_PERIOD) &&
-			(bss->param.bss_config.beacon_period <=
-				MAX_BEACON_PERIOD)) {
-		tlv_beacon_period =
-			(struct mwifiex_ie_types_beacon_period *)tlv;
-		tlv_beacon_period->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_BEACON_PERIOD);
-		tlv_beacon_period->header.len = cpu_to_le16(
-				sizeof(u16));
-		tlv_beacon_period->beacon_period = cpu_to_le16(
-				bss->param.bss_config.beacon_period);
-		cmd_size += sizeof(struct mwifiex_ie_types_beacon_period);
-		tlv += sizeof(struct mwifiex_ie_types_beacon_period);
-	}
-
-	if ((bss->param.bss_config.dtim_period >= MIN_DTIM_PERIOD) &&
-			(bss->param.bss_config.dtim_period <=
-				MAX_DTIM_PERIOD)) {
-		tlv_dtim_period = (struct mwifiex_ie_types_dtim_period *)tlv;
-		tlv_dtim_period->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_DTIM_PERIOD);
-		tlv_dtim_period->header.len = cpu_to_le16(
-				sizeof(u8));
-		tlv_dtim_period->dtim_period =
-				bss->param.bss_config.dtim_period;
-		cmd_size += sizeof(struct mwifiex_ie_types_dtim_period);
-		tlv += sizeof(struct mwifiex_ie_types_dtim_period);
-	}
-
-	if (bss->param.bss_config.rates[0]) {
-		tlv_rates = (struct mwifiex_ie_types_rates_param_set *)tlv;
-		tlv_rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
-		for (i = 0; i < MAX_DATA_RATES &&
-				bss->param.bss_config.rates[i];
-				i++)
-			tlv_rates->rates[i] = bss->param.bss_config.rates[i];
-		tlv_rates->header.len = cpu_to_le16(i);
-		cmd_size +=  sizeof(struct mwifiex_ie_types_header) + i;
-		tlv += sizeof(struct mwifiex_ie_types_header) + i;
-	}
-
-	if (bss->param.bss_config.tx_data_rate <= DATA_RATE_54M) {
-		tlv_txrate = (struct mwifiex_ie_types_tx_rate *)tlv;
-		tlv_txrate->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_TX_DATA_RATE);
-		tlv_txrate->header.len = cpu_to_le16(sizeof(u16));
-		tlv_txrate->tx_data_rate = cpu_to_le16(bss->param.bss_config
-						       .tx_data_rate);
-		cmd_size += sizeof(struct mwifiex_ie_types_tx_rate);
-		tlv += sizeof(struct mwifiex_ie_types_tx_rate);
-	}
-
-	if (bss->param.bss_config.mcbc_data_rate <= DATA_RATE_54M) {
-		tlv_mcbc_rate = (struct mwifiex_ie_types_mcbc_rate *)tlv;
-		tlv_mcbc_rate->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_MCBC_DATA_RATE);
-		tlv_mcbc_rate->header.len = cpu_to_le16(sizeof(u16));
-		tlv_mcbc_rate->mcbc_data_rate = cpu_to_le16(bss->param
-						.bss_config.mcbc_data_rate);
-		cmd_size += sizeof(struct mwifiex_ie_types_mcbc_rate);
-		tlv += sizeof(struct mwifiex_ie_types_mcbc_rate);
-	}
-
-	if (bss->param.bss_config.tx_power_level <= MAX_TX_POWER) {
-		tlv_tx_power = (struct mwifiex_ie_types_tx_power *)tlv;
-		tlv_tx_power->header.type = cpu_to_le16(TLV_TYPE_UAP_TX_POWER);
-		tlv_tx_power->header.len = cpu_to_le16(sizeof(u8));
-		tlv_tx_power->tx_power = bss->param.bss_config.tx_power_level;
-		cmd_size += sizeof(struct mwifiex_ie_types_tx_power);
-		tlv += sizeof(struct mwifiex_ie_types_tx_power);
-	}
-
-	if (bss->param.bss_config.bcast_ssid_ctl <= true) {
-		tlv_bcast_ssid = (struct mwifiex_ie_types_bcast_ssid *)tlv;
-		tlv_bcast_ssid->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_BCAST_SSID_CTL);
-		tlv_bcast_ssid->header.len = cpu_to_le16(sizeof(u8));
-		tlv_bcast_ssid->bcast_ssid_ctl = bss->param.bss_config
-						.bcast_ssid_ctl;
-		cmd_size += sizeof(struct mwifiex_ie_types_bcast_ssid);
-		tlv += sizeof(struct mwifiex_ie_types_bcast_ssid);
-	}
-
-	if ((bss->param.bss_config.tx_antenna == ANTENNA_MODE_A) ||
-			(bss->param.bss_config.tx_antenna == ANTENNA_MODE_B)) {
-		tlv_antenna = (struct mwifiex_ie_types_antenna_mode *)tlv;
-		tlv_antenna->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_ANTENNA_CTL);
-		tlv_antenna->header.len = cpu_to_le16(sizeof(u8) + sizeof(u8));
-		tlv_antenna->which_antenna = TX_ANTENNA;
-		tlv_antenna->antenna_mode = bss->param.bss_config.tx_antenna;
-		cmd_size += sizeof(struct mwifiex_ie_types_antenna_mode);
-		tlv += sizeof(struct mwifiex_ie_types_antenna_mode);
-	}
-
-	if ((bss->param.bss_config.rx_antenna == ANTENNA_MODE_A) ||
-			(bss->param.bss_config.rx_antenna == ANTENNA_MODE_B)) {
-		tlv_antenna = (struct mwifiex_ie_types_antenna_mode *)tlv;
-		tlv_antenna->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_ANTENNA_CTL);
-		tlv_antenna->header.len = cpu_to_le16(sizeof(u8) + sizeof(u8));
-		tlv_antenna->which_antenna = RX_ANTENNA;
-		tlv_antenna->antenna_mode = bss->param.bss_config.rx_antenna;
-		cmd_size += sizeof(struct mwifiex_ie_types_antenna_mode);
-		tlv += sizeof(struct mwifiex_ie_types_antenna_mode);
-	}
-
-	if (bss->param.bss_config.pkt_forward_ctl <= true) {
-		tlv_pkt_forward = (struct mwifiex_ie_types_pkt_forward *)tlv;
-		tlv_pkt_forward->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_PKT_FWD_CTL);
-		tlv_pkt_forward->header.len = cpu_to_le16(sizeof(u8));
-		tlv_pkt_forward->pkt_forward_ctl = bss->param.bss_config
-						.pkt_forward_ctl;
-		cmd_size += sizeof(struct mwifiex_ie_types_pkt_forward);
-		tlv += sizeof(struct mwifiex_ie_types_pkt_forward);
-	}
-
-	if (bss->param.bss_config.max_sta_count <= MAX_STA_COUNT) {
-		tlv_sta_count = (struct mwifiex_ie_types_max_sta_count *)tlv;
-		tlv_sta_count->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_MAX_STA_CNT);
-		tlv_sta_count->header.len = cpu_to_le16(sizeof(u16));
-		tlv_sta_count->max_sta_count = cpu_to_le16(bss->param
-						.bss_config.max_sta_count);
-		cmd_size += sizeof(struct mwifiex_ie_types_max_sta_count);
-		tlv += sizeof(struct mwifiex_ie_types_max_sta_count);
-	}
-
-	if (((bss->param.bss_config.sta_ageout_timer >= MIN_STAGE_OUT_TIME) &&
-				(bss->param.bss_config.sta_ageout_timer <=
-				MAX_STAGE_OUT_TIME)) ||
-				(bss->param.bss_config.sta_ageout_timer == 0)) {
-		tlv_sta_ageout = (struct mwifiex_ie_types_sta_ageout *)tlv;
-		tlv_sta_ageout->header.type = cpu_to_le16(
-					TLV_TYPE_UAP_STA_AGEOUT_TIMER);
-		tlv_sta_ageout->header.len = cpu_to_le16(sizeof(u32));
-		tlv_sta_ageout->sta_ageout_timer = cpu_to_le32(
-					bss->param.bss_config.sta_ageout_timer);
-		cmd_size += sizeof(struct mwifiex_ie_types_sta_ageout);
-		tlv += sizeof(struct mwifiex_ie_types_sta_ageout);
-	}
-
-	if (((bss->param.bss_config.ps_sta_ageout_timer >= MIN_STAGE_OUT_TIME)
-				&& (bss->param.bss_config.ps_sta_ageout_timer
-				<= MAX_STAGE_OUT_TIME))
-				|| (bss->param.bss_config
-				.ps_sta_ageout_timer == 0)) {
-		tlv_ps_sta_ageout =
-			(struct mwifiex_ie_types_ps_sta_ageout *)tlv;
-		tlv_ps_sta_ageout->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_PS_STA_AGEOUT_TIMER);
-		tlv_ps_sta_ageout->header.len = cpu_to_le16(sizeof(u32));
-		tlv_ps_sta_ageout->ps_sta_ageout_timer = cpu_to_le32(
-				bss->param.bss_config.ps_sta_ageout_timer);
-		cmd_size += sizeof(struct mwifiex_ie_types_ps_sta_ageout);
-		tlv += sizeof(struct mwifiex_ie_types_ps_sta_ageout);
-	}
-	if (bss->param.bss_config.rts_threshold <= MAX_RTS_THRESHOLD) {
-		tlv_rts_threshold =
-			(struct mwifiex_ie_types_rts_threshold *)tlv;
-		tlv_rts_threshold->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_RTS_THRESHOLD);
-		tlv_rts_threshold->header.len = cpu_to_le16(sizeof(u16));
-		tlv_rts_threshold->rts_threshold = cpu_to_le16(
-				bss->param.bss_config.rts_threshold);
-		cmd_size += sizeof(struct mwifiex_ie_types_rts_threshold);
-		tlv += sizeof(struct mwifiex_ie_types_rts_threshold);
-	}
-
-	if ((bss->param.bss_config.frag_threshold >= MIN_FRAG_THRESHOLD) &&
-				(bss->param.bss_config.frag_threshold <=
-				MAX_FRAG_THRESHOLD)) {
-		tlv_frag_threshold =
-			(struct mwifiex_ie_types_frag_threshold *)tlv;
-		tlv_frag_threshold->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_FRAG_THRESHOLD);
-		tlv_frag_threshold->header.len = cpu_to_le16(sizeof(u16));
-		tlv_frag_threshold->frag_threshold = cpu_to_le16(
-				bss->param.bss_config.frag_threshold);
-		cmd_size += sizeof(struct mwifiex_ie_types_frag_threshold);
-		tlv += sizeof(struct mwifiex_ie_types_frag_threshold);
-	}
-
-	if (bss->param.bss_config.retry_limit <= MAX_RETRY_LIMIT) {
-		tlv_retry_limit = (struct mwifiex_ie_types_retry_limit *)tlv;
-		tlv_retry_limit->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_RETRY_LIMIT);
-		tlv_retry_limit->header.len = cpu_to_le16(sizeof(u8));
-		tlv_retry_limit->retry_limit = (u8)bss->param.bss_config
-				.retry_limit;
-		cmd_size += sizeof(struct mwifiex_ie_types_retry_limit);
-		tlv += sizeof(struct mwifiex_ie_types_retry_limit);
-	}
-
-	if (bss->param.bss_config.pairwise_update_timeout) {
-		tlv_pairwise_timeout =
-			(struct mwifiex_ie_types_eapol_pwk_hsk_timeout *)tlv;
-		tlv_pairwise_timeout->header.type = cpu_to_le16(
-			TLV_TYPE_UAP_EAPOL_PWK_HSK_TIMEOUT);
-		tlv_pairwise_timeout->header.len =
-			cpu_to_le16(sizeof(u32));
-		tlv_pairwise_timeout->pairwise_update_timeout =
-			cpu_to_le32(
-			bss->param.bss_config.pairwise_update_timeout);
-		cmd_size +=
-			sizeof(struct mwifiex_ie_types_eapol_pwk_hsk_timeout);
-		tlv += sizeof(struct mwifiex_ie_types_eapol_pwk_hsk_timeout);
-	}
-
-	if (bss->param.bss_config.pwk_retries) {
-		tlv_pairwise_retries =
-			(struct mwifiex_ie_types_eapol_pwk_hsk_retries *)tlv;
-		tlv_pairwise_retries->header.type =
-			cpu_to_le16(TLV_TYPE_UAP_EAPOL_PWK_HSK_RETRIES);
-		tlv_pairwise_retries->header.len =
-			cpu_to_le16(sizeof(u32));
-		tlv_pairwise_retries->pwk_retries =
-			cpu_to_le32(bss->param.bss_config.pwk_retries);
-		cmd_size +=
-			sizeof(struct mwifiex_ie_types_eapol_pwk_hsk_retries);
-		tlv += sizeof(struct mwifiex_ie_types_eapol_pwk_hsk_retries);
-	}
-
-	if (bss->param.bss_config.groupwise_update_timeout) {
-		tlv_groupwise_timeout =
-			(struct mwifiex_ie_types_eapol_gwk_hsk_timeout *)tlv;
-		tlv_groupwise_timeout->header.type =
-			cpu_to_le16(TLV_TYPE_UAP_EAPOL_GWK_HSK_TIMEOUT);
-		tlv_groupwise_timeout->header.len =  cpu_to_le16(sizeof(u32));
-		tlv_groupwise_timeout->groupwise_update_timeout = cpu_to_le32(
-			bss->param.bss_config.groupwise_update_timeout);
-		cmd_size +=
-			sizeof(struct mwifiex_ie_types_eapol_gwk_hsk_timeout);
-		tlv += sizeof(struct mwifiex_ie_types_eapol_gwk_hsk_timeout);
-	}
-
-	if (bss->param.bss_config.gwk_retries) {
-		tlv_groupwise_retries =
-			(struct mwifiex_ie_types_eapol_gwk_hsk_retries *)tlv;
-		tlv_groupwise_retries->header.type =
-			cpu_to_le16(TLV_TYPE_UAP_EAPOL_GWK_HSK_RETRIES);
-		tlv_groupwise_retries->header.len = cpu_to_le16(sizeof(u32));
-		tlv_groupwise_retries->gwk_retries =
-			cpu_to_le32(bss->param.bss_config.gwk_retries);
-		cmd_size +=
-			sizeof(struct mwifiex_ie_types_eapol_gwk_hsk_retries);
-		tlv += sizeof(struct mwifiex_ie_types_eapol_gwk_hsk_retries);
-	}
-
-	if ((bss->param.bss_config.filter.filter_mode <=
-			MAC_FILTER_MODE_BLOCK_MAC)
-			&& (bss->param.bss_config.filter.mac_count <=
-			MAX_MAC_FILTER_NUM)) {
-		tlv_mac_filter = (struct mwifiex_ie_types_mac_filter *)tlv;
-		tlv_mac_filter->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_STA_MAC_ADDR_FILTER);
-		tlv_mac_filter->header.len = cpu_to_le16(
-				2 + MWIFIEX_MAC_ADDR_LENGTH *
-				bss->param.bss_config.filter.mac_count);
-		tlv_mac_filter->count = (u8)bss->param.bss_config.filter
-				.mac_count;
-		tlv_mac_filter->filter_mode = (u8)bss->param.bss_config.filter
-				.filter_mode;
-		memcpy(tlv_mac_filter->mac_address,
-				(u8 *)bss->param.bss_config.filter.mac_list,
-				MWIFIEX_MAC_ADDR_LENGTH *
-				bss->param.bss_config.filter.mac_count);
-		cmd_size += sizeof(struct mwifiex_ie_types_header) + 2 +
-				MWIFIEX_MAC_ADDR_LENGTH *
-				bss->param.bss_config.filter.mac_count;
-		tlv += sizeof(struct mwifiex_ie_types_header) + 2 +
-				MWIFIEX_MAC_ADDR_LENGTH *
-				bss->param.bss_config.filter.mac_count;
-	}
-
-	if ((((bss->param.bss_config.band_cfg & BAND_CONFIG_ACS_MODE) ==
-				BAND_CONFIG_MANUAL) &&
-				(bss->param.bss_config.channel > 0) &&
-				(bss->param.bss_config.channel <=
-				MAX_CHANNEL)) ||
-				(bss->param.bss_config.band_cfg &
-				BAND_CONFIG_ACS_MODE)) {
-		tlv_chan_band = (struct mwifiex_ie_types_channel_band *)tlv;
-		tlv_chan_band->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_CHAN_BAND_CONFIG);
-		tlv_chan_band->header.len = cpu_to_le16(sizeof(u8)+sizeof(u8));
-		tlv_chan_band->band_config = bss->param.bss_config.band_cfg;
-		tlv_chan_band->channel = bss->param.bss_config.channel;
-		cmd_size += sizeof(struct mwifiex_ie_types_channel_band);
-		tlv += sizeof(struct mwifiex_ie_types_channel_band);
-	}
-
-	if ((bss->param.bss_config.chan_list.num_of_chan) &&
-			(bss->param.bss_config.chan_list.num_of_chan <=
-			MWIFIEX_SCAN_CHANNEL_NUM)) {
-		tlv_chan_list = (
-			struct mwifiex_ie_types_chan_list_param_set *)tlv;
-		tlv_chan_list->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
-		tlv_chan_list->header.len = cpu_to_le16((u16)(sizeof(
-					struct mwifiex_chan_scan_param_set) *
-					bss->param.bss_config.chan_list
-					.num_of_chan));
-
-		pscan_chan = tlv_chan_list->chan_scan_param;
-		for (i = 0; i < bss->param.bss_config.chan_list
-							.num_of_chan; i++) {
-			pscan_chan->chan_number =  (u8)bss->param.bss_config
-						.chan_list.chan[i];
-			pscan_chan++;
-		}
-		cmd_size += sizeof(tlv_chan_list->header) +
-			(sizeof(struct mwifiex_chan_scan_param_set) *
-					bss->param.bss_config
-					.chan_list.num_of_chan);
-		tlv += sizeof(tlv_chan_list->header) +
-			(sizeof(struct mwifiex_chan_scan_param_set) *
-					bss->param.bss_config.chan_list
-					.num_of_chan);
-	}
-
-	if (bss->param.bss_config.auth_mode <= MWIFIEX_AUTH_MODE_SHARED) {
-		tlv_auth_type = (struct mwifiex_ie_types_auth_type *)tlv;
-		tlv_auth_type->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
-		tlv_auth_type->header.len = cpu_to_le16(sizeof(u16));
-		tlv_auth_type->auth_type =
-					cpu_to_le16((u16)bss->param
-					       .bss_config.auth_mode);
-		cmd_size += sizeof(struct mwifiex_ie_types_auth_type);
-		tlv += sizeof(struct mwifiex_ie_types_auth_type);
-	}
-
-	if (bss->param.bss_config.protocol) {
-		tlv_encrypt_protocol =
-				(struct
-				 mwifiex_ie_types_encrypt_protocol
-				 *)tlv;
-		tlv_encrypt_protocol->header.type = cpu_to_le16(
-					TLV_TYPE_UAP_ENCRYPT_PROTOCOL);
-		tlv_encrypt_protocol->header.len = cpu_to_le16(sizeof(u16));
-		tlv_encrypt_protocol->protocol = cpu_to_le16(bss->param
-					.bss_config.protocol);
-		cmd_size += sizeof(struct mwifiex_ie_types_encrypt_protocol);
-		tlv += sizeof(struct mwifiex_ie_types_encrypt_protocol);
-	}
-	if ((bss->param.bss_config.radio_ctl == 0) ||
-			(bss->param.bss_config.radio_ctl == 1)) {
-		tlv_radio_control =
-			(struct mwifiex_ie_types_radio_control *)tlv;
-		tlv_radio_control->header.type = cpu_to_le16(
-					TLV_TYPE_UAP_RADIO_CONTROL);
-		tlv_radio_control->header.len = cpu_to_le16(sizeof(u8));
-		tlv_radio_control->radio_ctl = bss->param.bss_config.radio_ctl;
-		cmd_size += sizeof(struct mwifiex_ie_types_radio_control);
-		tlv += sizeof(struct mwifiex_ie_types_radio_control);
-	}
-
-	if ((bss->param.bss_config.protocol == PROTOCOL_WPA) ||
-				(bss->param.bss_config.protocol ==
-				PROTOCOL_WPA2) ||
-				(bss->param.bss_config.protocol ==
-				PROTOCOL_WPA2_MIXED)) {
-		tlv_akmp = (struct mwifiex_ie_types_akmp *)tlv;
-		tlv_akmp->header.type = cpu_to_le16(TLV_TYPE_UAP_AKMP);
-		tlv_akmp->header.len = cpu_to_le16(sizeof(u16));
-		tlv_akmp->key_mgmt = cpu_to_le16(KEY_MGMT_PSK);
-		cmd_size += sizeof(struct mwifiex_ie_types_akmp);
-		tlv += sizeof(struct mwifiex_ie_types_akmp);
-
-		if (((bss->param.bss_config.wpa_cfg.pairwise_cipher_wpa &
-						VALID_CIPHER_BITMAP) ||
-						(bss->param.bss_config.wpa_cfg
-						.pairwise_cipher_wpa2 &
-						VALID_CIPHER_BITMAP)) &&
-						(bss->param.bss_config.wpa_cfg
-						.group_cipher &
-						VALID_CIPHER_BITMAP)) {
-			tlv_cipher = (struct mwifiex_ie_types_cipher *)tlv;
-			tlv_cipher->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_CIPHER);
-			tlv_cipher->header.len = cpu_to_le16(sizeof(u8)
-						+ sizeof(u8));
-			tlv_cipher->pair_cipher = (bss->param.bss_config
-						.wpa_cfg.pairwise_cipher_wpa |
-						bss->param.bss_config.wpa_cfg
-						.pairwise_cipher_wpa2) &
-						VALID_CIPHER_BITMAP;
-			tlv_cipher->group_cipher = bss->param.bss_config.wpa_cfg
-						.group_cipher;
-			cmd_size += sizeof(struct mwifiex_ie_types_cipher);
-			tlv += sizeof(struct mwifiex_ie_types_cipher);
-		}
-		if (bss->param.bss_config.wpa_cfg.pairwise_cipher_wpa
-						& VALID_CIPHER_BITMAP) {
-			tlv_pwk_cipher =
-				(struct mwifiex_ie_types_pwk_cipher *)tlv;
-			tlv_pwk_cipher->header.type = cpu_to_le16(
-						TLV_TYPE_PWK_CIPHER);
-			tlv_pwk_cipher->header.len = cpu_to_le16(
-						sizeof(u16) + sizeof(u8) +
-						sizeof(u8));
-			tlv_pwk_cipher->protocol = cpu_to_le16(PROTOCOL_WPA);
-			tlv_pwk_cipher->pairwise_cipher = bss->param.bss_config
-						.wpa_cfg.pairwise_cipher_wpa;
-			cmd_size += sizeof(struct mwifiex_ie_types_pwk_cipher);
-			tlv += sizeof(struct mwifiex_ie_types_pwk_cipher);
-		}
-
-		if (bss->param.bss_config.wpa_cfg.pairwise_cipher_wpa2 &
-						VALID_CIPHER_BITMAP) {
-			tlv_pwk_cipher =
-				(struct mwifiex_ie_types_pwk_cipher *)tlv;
-			tlv_pwk_cipher->header.type = cpu_to_le16(
-						TLV_TYPE_PWK_CIPHER);
-			tlv_pwk_cipher->header.len = cpu_to_le16(sizeof(u16) +
-						sizeof(u8) + sizeof(u8));
-			tlv_pwk_cipher->protocol = cpu_to_le16(PROTOCOL_WPA2);
-			tlv_pwk_cipher->pairwise_cipher = bss->param.bss_config
-						.wpa_cfg.pairwise_cipher_wpa2;
-			cmd_size += sizeof(struct mwifiex_ie_types_pwk_cipher);
-			tlv += sizeof(struct mwifiex_ie_types_pwk_cipher);
-		}
-
-		if (bss->param.bss_config.wpa_cfg.group_cipher &
-						VALID_CIPHER_BITMAP) {
-			tlv_gwk_cipher =
-				(struct mwifiex_ie_types_gwk_cipher *)tlv;
-			tlv_gwk_cipher->header.type = cpu_to_le16(
-						TLV_TYPE_GWK_CIPHER);
-			tlv_gwk_cipher->header.len = cpu_to_le16(
-						sizeof(u8) + sizeof(u8));
-			tlv_gwk_cipher->group_cipher = bss->param.bss_config
-						.wpa_cfg.group_cipher;
-			cmd_size += sizeof(struct mwifiex_ie_types_gwk_cipher);
-			tlv += sizeof(struct mwifiex_ie_types_gwk_cipher);
-		}
-
-		if (bss->param.bss_config.wpa_cfg.rsn_protection <= true) {
-			tlv_rsn_prot = (
-				struct mwifiex_ie_types_rsn_replay_prot *)tlv;
-			tlv_rsn_prot->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_RSN_REPLAY_PROTECT);
-			tlv_rsn_prot->header.len = cpu_to_le16(sizeof(u8));
-			tlv_rsn_prot->rsn_replay_prot = bss->param.bss_config
-						.wpa_cfg.rsn_protection;
-			cmd_size += sizeof(struct
-					mwifiex_ie_types_rsn_replay_prot);
-			tlv += sizeof(struct mwifiex_ie_types_rsn_replay_prot);
-		}
-
-		if (bss->param.bss_config.wpa_cfg.length) {
-			tlv_passphrase =
-				(struct mwifiex_ie_types_passphrase *)tlv;
-			tlv_passphrase->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_WPA_PASSPHRASE);
-			tlv_passphrase->header.len = cpu_to_le16(
-				(u16)bss->param.bss_config.wpa_cfg.length);
-			memcpy(tlv_passphrase->passphrase, bss->param.bss_config
-							.wpa_cfg.passphrase,
-							bss->param.bss_config
-							.wpa_cfg.length);
-			cmd_size +=  sizeof(struct mwifiex_ie_types_header) +
-					bss->param.bss_config.wpa_cfg.length;
-			tlv += sizeof(struct mwifiex_ie_types_header) +
-					bss->param.bss_config.wpa_cfg.length;
-		}
-
-		if (bss->param.bss_config.wpa_cfg.gk_rekey_time <
-								MAX_GRP_TIMER) {
-			tlv_rekey_time = (
-				struct mwifiex_ie_types_group_rekey_time *)tlv;
-			tlv_rekey_time->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_GRP_REKEY_TIME);
-			tlv_rekey_time->header.len = cpu_to_le16(sizeof(u32));
-			tlv_rekey_time->gk_rekey_time = cpu_to_le32(bss->param
-					.bss_config.wpa_cfg.gk_rekey_time);
-			cmd_size += sizeof(struct
-					mwifiex_ie_types_group_rekey_time);
-			tlv += sizeof(struct mwifiex_ie_types_group_rekey_time);
-		}
-	} else {
-		if ((bss->param.bss_config.wep_cfg.key0.length) &&
-				((bss->param.bss_config.wep_cfg.key0
-				.length == 5) ||
-				(bss->param.bss_config.wep_cfg.key0
-				.length == 10) ||
-				(bss->param.bss_config.wep_cfg.key0
-				.length == 13) ||
-				(bss->param.bss_config.wep_cfg.key0
-				.length == 26))) {
-			tlv_wep_key = (struct mwifiex_ie_types_wep_key *)tlv;
-			tlv_wep_key->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_WEP_KEY);
-			tlv_wep_key->header.len = cpu_to_le16(2 + bss->param
-					.bss_config.wep_cfg.key0.length);
-			tlv_wep_key->key_index = bss->param.bss_config.wep_cfg
-							.key0.key_index;
-			tlv_wep_key->is_default = bss->param.bss_config.wep_cfg
-							.key0.is_default;
-			memcpy(tlv_wep_key->key, bss->param.bss_config.wep_cfg
-							.key0.key,
-							bss->param.bss_config
-							.wep_cfg.key0.length);
-			cmd_size += sizeof(struct mwifiex_ie_types_header) + 2
-							+ bss->param.bss_config
-							.wep_cfg.key0.length;
-			tlv += sizeof(struct mwifiex_ie_types_header) + 2 +
-							bss->param.bss_config
-							.wep_cfg.key0.length;
-		}
-
-		if ((bss->param.bss_config.wep_cfg.key1.length) &&
-					((bss->param.bss_config.wep_cfg
-					.key1.length == 5) ||
-					(bss->param.bss_config.wep_cfg
-					.key1.length == 10) ||
-					(bss->param.bss_config.wep_cfg
-					.key1.length == 13) ||
-					(bss->param.bss_config.wep_cfg
-					.key1.length == 26))) {
-			tlv_wep_key = (struct mwifiex_ie_types_wep_key *)tlv;
-			tlv_wep_key->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_WEP_KEY);
-			tlv_wep_key->header.len = cpu_to_le16(2 + bss->param
-						.bss_config.wep_cfg
-						.key1.length);
-			tlv_wep_key->key_index = bss->param.bss_config.wep_cfg
-						.key1.key_index;
-			tlv_wep_key->is_default = bss->param.bss_config.wep_cfg
-						.key1.is_default;
-			memcpy(tlv_wep_key->key, bss->param.bss_config.wep_cfg
-						.key1.key,
-						bss->param.bss_config.wep_cfg
-						.key1.length);
-			cmd_size += sizeof(struct mwifiex_ie_types_header) + 2 +
-						bss->param.bss_config.wep_cfg
-						.key1.length;
-			tlv += sizeof(struct mwifiex_ie_types_header) + 2 +
-						bss->param.bss_config.wep_cfg
-						.key1.length;
-		}
-
-		if ((bss->param.bss_config.wep_cfg.key2.length) &&
-					((bss->param.bss_config.wep_cfg
-					.key2.length == 5) ||
-					(bss->param.bss_config.wep_cfg
-					.key2.length == 10) ||
-					(bss->param.bss_config.wep_cfg
-					.key2.length == 13) ||
-					(bss->param.bss_config.wep_cfg
-					.key2.length == 26))) {
-			tlv_wep_key = (struct mwifiex_ie_types_wep_key *)tlv;
-			tlv_wep_key->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_WEP_KEY);
-			tlv_wep_key->header.len = cpu_to_le16(2 + bss->param
-						.bss_config.wep_cfg
-						.key2.length);
-			tlv_wep_key->key_index = bss->param.bss_config.wep_cfg
-						.key2.key_index;
-			tlv_wep_key->is_default = bss->param.bss_config.wep_cfg
-						.key2.is_default;
-			memcpy(tlv_wep_key->key, bss->param.bss_config.wep_cfg
-						.key2.key,
-						bss->param.bss_config.wep_cfg
-						.key2.length);
-			cmd_size += sizeof(struct mwifiex_ie_types_header) + 2 +
-						bss->param.bss_config.wep_cfg
-						.key2.length;
-			tlv += sizeof(struct mwifiex_ie_types_header) + 2 +
-						bss->param.bss_config.wep_cfg
-						.key2.length;
-		}
-
-		if ((bss->param.bss_config.wep_cfg.key3.length) &&
-					((bss->param.bss_config.wep_cfg
-					.key3.length == 5) ||
-					(bss->param.bss_config.wep_cfg
-					.key3.length == 10) ||
-					(bss->param.bss_config.wep_cfg
-					.key3.length == 13) ||
-					(bss->param.bss_config.wep_cfg
-					.key3.length == 26))) {
-			tlv_wep_key = (struct mwifiex_ie_types_wep_key *)tlv;
-			tlv_wep_key->header.type = cpu_to_le16(
-						TLV_TYPE_UAP_WEP_KEY);
-			tlv_wep_key->header.len = cpu_to_le16(2 + bss->param
-						.bss_config.wep_cfg
-						.key3.length);
-			tlv_wep_key->key_index = bss->param.bss_config.wep_cfg
-						.key3.key_index;
-			tlv_wep_key->is_default = bss->param.bss_config.wep_cfg
-						.key3.is_default;
-			memcpy(tlv_wep_key->key, bss->param.bss_config.wep_cfg
-						.key3.key,
-						bss->param.bss_config.wep_cfg
-						.key3.length);
-			cmd_size += sizeof(struct mwifiex_ie_types_header) + 2 +
-						bss->param.bss_config.wep_cfg
-						.key3.length;
-			tlv += sizeof(struct mwifiex_ie_types_header) + 2 +
-						bss->param.bss_config.wep_cfg
-						.key3.length;
-		}
-	}
-	cmd->size = cpu_to_le16((u16)cmd_size);
-	PRINTM(MCMND, "AP config: cmd_size=%d\n", cmd_size);
-	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * This function prepares command of sys_config
- */
-static enum mwifiex_status
-mwifiex_uap_cmd_sys_configure(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *cmd,
-			      u16 cmd_action,
-			      struct mwifiex_ioctl_req *pioctl_buf)
-{
-	struct mwifiex_ds_bss *bss = NULL;
-	struct host_cmd_ds_sys_config *sys_config =
-		       (struct host_cmd_ds_sys_config *)&cmd->params.sys_config;
-	struct mwifiex_ie_types_macaddr *mac_tlv = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	cmd->command = cpu_to_le16(HOST_CMD_APCMD_SYS_CONFIGURE);
-	sys_config->action = cpu_to_le16(cmd_action);
-	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_sys_config) -
-							1 + S_DS_GEN);
-	if (pioctl_buf == NULL) {
-		mac_tlv = (struct
-			   mwifiex_ie_types_macaddr
-			   *)sys_config->tlv_buffer;
-		cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_sys_config) -
-			1 + S_DS_GEN + sizeof(struct mwifiex_ie_types_macaddr));
-		mac_tlv->header.type = cpu_to_le16(TLV_TYPE_UAP_MAC_ADDRESS);
-		mac_tlv->header.len = cpu_to_le16(MWIFIEX_MAC_ADDR_LENGTH);
-		ret = MWIFIEX_STATUS_SUCCESS;
-		goto done;
-	}
-	if (pioctl_buf->req_id == MWIFIEX_IOCTL_BSS) {
-		bss =  (struct mwifiex_ds_bss *)pioctl_buf->buffer;
-		if (bss->sub_command == MWIFIEX_OID_BSS_MAC_ADDR) {
-			mac_tlv = (struct
-				   mwifiex_ie_types_macaddr
-				   *)
-				   sys_config->tlv_buffer;
-			cmd->size = cpu_to_le16(sizeof(
-				struct host_cmd_ds_sys_config) - 1 + S_DS_GEN +
-				sizeof(struct mwifiex_ie_types_macaddr));
-			mac_tlv->header.type = cpu_to_le16(
-				TLV_TYPE_UAP_MAC_ADDRESS);
-			mac_tlv->header.len = cpu_to_le16(
-				MWIFIEX_MAC_ADDR_LENGTH);
-			if (cmd_action == HostCmd_ACT_GEN_SET)
-				memcpy(mac_tlv->mac, &bss->param.mac_addr,
-				MWIFIEX_MAC_ADDR_LENGTH);
-		} else if ((bss->sub_command == MWIFIEX_OID_UAP_BSS_CONFIG) &&
-					(cmd_action == HostCmd_ACT_GEN_SET)) {
-			ret = mwifiex_uap_cmd_ap_config(priv, cmd, cmd_action,
-								pioctl_buf);
-			goto done;
-		}
-	}
-done:
-LEAVE();
-return ret;
-}
-
-/*
- * This function handles command resp for get uap settings
- */
-static enum mwifiex_status mwifiex_uap_ret_cmd_ap_config(
-		struct mwifiex_private *priv,
-		struct host_cmd_ds_command *resp,
-		struct mwifiex_ioctl_req *pioctl_buf)
-{
-	struct host_cmd_ds_sys_config *sys_config =
-					(struct
-					host_cmd_ds_sys_config
-					*)&resp->params.sys_config;
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ie_types_header *tlv = NULL;
-	u16 tlv_buf_left = 0;
-	u16 tlv_type = 0;
-	u16 tlv_len = 0;
-	struct mwifiex_ie_types_macaddr *tlv_mac = NULL;
-	struct mwifiex_ie_types_ssid_param_set *tlv_ssid = NULL;
-	struct mwifiex_ie_types_beacon_period *tlv_beacon_period = NULL;
-	struct mwifiex_ie_types_dtim_period *tlv_dtim_period = NULL;
-	struct mwifiex_ie_types_rates_param_set *tlv_rates = NULL;
-	struct mwifiex_ie_types_tx_rate *tlv_txrate = NULL;
-	struct mwifiex_ie_types_mcbc_rate *tlv_mcbc_rate = NULL;
-	struct mwifiex_ie_types_tx_power *tlv_tx_power = NULL;
-	struct mwifiex_ie_types_bcast_ssid *tlv_bcast_ssid = NULL;
-	struct mwifiex_ie_types_antenna_mode *tlv_antenna = NULL;
-	struct mwifiex_ie_types_pkt_forward *tlv_pkt_forward = NULL;
-	struct mwifiex_ie_types_max_sta_count *tlv_sta_count = NULL;
-	struct mwifiex_ie_types_sta_ageout *tlv_sta_ageout = NULL;
-	struct mwifiex_ie_types_ps_sta_ageout *tlv_ps_sta_ageout = NULL;
-	struct mwifiex_ie_types_rts_threshold *tlv_rts_threshold = NULL;
-	struct mwifiex_ie_types_frag_threshold *tlv_frag_threshold = NULL;
-	struct mwifiex_ie_types_retry_limit *tlv_retry_limit = NULL;
-	struct mwifiex_ie_types_eapol_pwk_hsk_timeout *tlv_pairwise_timeout =
-									NULL;
-	struct mwifiex_ie_types_eapol_pwk_hsk_retries *tlv_pairwise_retries =
-									NULL;
-	struct mwifiex_ie_types_eapol_gwk_hsk_timeout *tlv_groupwise_timeout =
-									NULL;
-	struct mwifiex_ie_types_eapol_gwk_hsk_retries *tlv_groupwise_retries =
-									NULL;
-	struct mwifiex_ie_types_mac_filter *tlv_mac_filter = NULL;
-	struct mwifiex_ie_types_channel_band *tlv_chan_band = NULL;
-	struct mwifiex_ie_types_chan_list_param_set *tlv_chan_list = NULL;
-	struct mwifiex_chan_scan_param_set *pscan_chan = NULL;
-	struct mwifiex_ie_types_auth_type *tlv_auth_type = NULL;
-	struct mwifiex_ie_types_encrypt_protocol *tlv_encrypt_protocol = NULL;
-	struct mwifiex_ie_types_akmp *tlv_akmp = NULL;
-	struct mwifiex_ie_types_cipher *tlv_cipher = NULL;
-	struct mwifiex_ie_types_pwk_cipher *tlv_pwk_cipher = NULL;
-	struct mwifiex_ie_types_gwk_cipher *tlv_gwk_cipher = NULL;
-	struct mwifiex_ie_types_rsn_replay_prot *tlv_rsn_prot = NULL;
-	struct mwifiex_ie_types_passphrase *tlv_passphrase = NULL;
-	struct mwifiex_ie_types_group_rekey_time *tlv_rekey_time = NULL;
-	struct mwifiex_ie_types_wep_key *tlv_wep_key = NULL;
-	struct mwifiex_ie_types_preamble *tlv_preamble = NULL;
-	struct mwifiex_ie_types_radio_control *tlv_radio_control = NULL;
-	struct wep_key *pkey = NULL;
-	u16 i;
-
-	ENTER();
-
-	bss =  (struct mwifiex_ds_bss *)pioctl_buf->buffer;
-	tlv = (struct mwifiex_ie_types_header *)sys_config->tlv_buffer;
-	tlv_buf_left = le16_to_cpu(resp->size) - (sizeof(
-						struct host_cmd_ds_sys_config) -
-						1 +  S_DS_GEN);
-
-	while (tlv_buf_left >= sizeof(struct mwifiex_ie_types_header)) {
-
-		tlv_type = le16_to_cpu(tlv->type);
-		tlv_len = le16_to_cpu(tlv->len);
-
-		switch (tlv_type) {
-		case TLV_TYPE_UAP_MAC_ADDRESS:
-			tlv_mac = (struct mwifiex_ie_types_macaddr *)tlv;
-			memcpy(&bss->param.bss_config.mac_addr, tlv_mac->mac,
-						MWIFIEX_MAC_ADDR_LENGTH);
-			break;
-		case TLV_TYPE_SSID:
-			tlv_ssid =
-				(struct mwifiex_ie_types_ssid_param_set *)tlv;
-			bss->param.bss_config.ssid.ssid_len = tlv_len;
-			memcpy(bss->param.bss_config.ssid.ssid, tlv_ssid->ssid,
-								tlv_len);
-			break;
-		case TLV_TYPE_UAP_BEACON_PERIOD:
-			tlv_beacon_period =
-				(struct mwifiex_ie_types_beacon_period *)tlv;
-			bss->param.bss_config.beacon_period = le16_to_cpu(
-					tlv_beacon_period->beacon_period);
-			break;
-		case TLV_TYPE_UAP_DTIM_PERIOD:
-			tlv_dtim_period = (struct
-					   mwifiex_ie_types_dtim_period
-					   *)tlv;
-			bss->param.bss_config.dtim_period =
-					tlv_dtim_period->dtim_period;
-			break;
-		case TLV_TYPE_RATES:
-			tlv_rates =
-				(struct mwifiex_ie_types_rates_param_set *)tlv;
-			memcpy(bss->param.bss_config.rates, tlv_rates->rates,
-								tlv_len);
-			break;
-		case TLV_TYPE_UAP_TX_DATA_RATE:
-			tlv_txrate = (struct mwifiex_ie_types_tx_rate *)tlv;
-			bss->param.bss_config.tx_data_rate = le16_to_cpu(
-						tlv_txrate->tx_data_rate);
-			break;
-		case TLV_TYPE_UAP_MCBC_DATA_RATE:
-			tlv_mcbc_rate =
-				(struct mwifiex_ie_types_mcbc_rate *)tlv;
-			bss->param.bss_config.mcbc_data_rate = le16_to_cpu(
-						tlv_mcbc_rate->mcbc_data_rate);
-			break;
-		case TLV_TYPE_UAP_TX_POWER:
-			tlv_tx_power = (struct mwifiex_ie_types_tx_power *)tlv;
-			bss->param.bss_config.tx_power_level =
-							tlv_tx_power->tx_power;
-			break;
-		case TLV_TYPE_UAP_BCAST_SSID_CTL:
-			tlv_bcast_ssid =
-				(struct mwifiex_ie_types_bcast_ssid *)tlv;
-			bss->param.bss_config.bcast_ssid_ctl =
-						tlv_bcast_ssid->bcast_ssid_ctl;
-			break;
-		case TLV_TYPE_UAP_RADIO_CONTROL:
-			tlv_radio_control =
-				(struct mwifiex_ie_types_radio_control *)tlv;
-			bss->param.bss_config.radio_ctl =
-					tlv_radio_control->radio_ctl;
-			break;
-		case TLV_TYPE_UAP_ANTENNA_CTL:
-			tlv_antenna =
-				(struct mwifiex_ie_types_antenna_mode *)tlv;
-			if (tlv_antenna->which_antenna == TX_ANTENNA)
-				bss->param.bss_config.tx_antenna =
-						tlv_antenna->antenna_mode;
-			else if (tlv_antenna->which_antenna == RX_ANTENNA)
-				bss->param.bss_config.rx_antenna =
-						tlv_antenna->antenna_mode;
-			break;
-		case TLV_TYPE_UAP_PKT_FWD_CTL:
-			tlv_pkt_forward =
-				(struct mwifiex_ie_types_pkt_forward *)tlv;
-			bss->param.bss_config.pkt_forward_ctl =
-					tlv_pkt_forward->pkt_forward_ctl;
-			break;
-		case TLV_TYPE_UAP_MAX_STA_CNT:
-			tlv_sta_count =
-				(struct mwifiex_ie_types_max_sta_count *)tlv;
-			bss->param.bss_config.max_sta_count = le16_to_cpu(
-					tlv_sta_count->max_sta_count);
-			break;
-		case TLV_TYPE_UAP_STA_AGEOUT_TIMER:
-			tlv_sta_ageout =
-				(struct mwifiex_ie_types_sta_ageout *)tlv;
-			bss->param.bss_config.sta_ageout_timer = le32_to_cpu(
-					tlv_sta_ageout->sta_ageout_timer);
-			break;
-		case TLV_TYPE_UAP_PS_STA_AGEOUT_TIMER:
-			tlv_ps_sta_ageout =
-				(struct mwifiex_ie_types_ps_sta_ageout *)tlv;
-			bss->param.bss_config.ps_sta_ageout_timer = le32_to_cpu(
-					tlv_ps_sta_ageout->ps_sta_ageout_timer);
-			break;
-		case TLV_TYPE_UAP_RTS_THRESHOLD:
-			tlv_rts_threshold =
-				(struct mwifiex_ie_types_rts_threshold *)tlv;
-			bss->param.bss_config.rts_threshold = le16_to_cpu(
-					tlv_rts_threshold->rts_threshold);
-			break;
-		case TLV_TYPE_UAP_FRAG_THRESHOLD:
-			tlv_frag_threshold =
-				(struct mwifiex_ie_types_frag_threshold *)tlv;
-			bss->param.bss_config.frag_threshold = le16_to_cpu(
-					tlv_frag_threshold->frag_threshold);
-			break;
-		case TLV_TYPE_UAP_RETRY_LIMIT:
-			tlv_retry_limit =
-				(struct mwifiex_ie_types_retry_limit *)tlv;
-			bss->param.bss_config.retry_limit =
-					tlv_retry_limit->retry_limit;
-			break;
-		case TLV_TYPE_UAP_EAPOL_PWK_HSK_TIMEOUT:
-			tlv_pairwise_timeout =
-				(struct
-				 mwifiex_ie_types_eapol_pwk_hsk_timeout
-				*)tlv;
-			bss->param.bss_config.pairwise_update_timeout =
-				le32_to_cpu(
-				tlv_pairwise_timeout->pairwise_update_timeout);
-			break;
-		case TLV_TYPE_UAP_EAPOL_PWK_HSK_RETRIES:
-			tlv_pairwise_retries =
-				(struct
-				 mwifiex_ie_types_eapol_pwk_hsk_retries
-				 *)tlv;
-			bss->param.bss_config.pwk_retries = le32_to_cpu(
-				tlv_pairwise_retries->pwk_retries);
-			break;
-		case TLV_TYPE_UAP_EAPOL_GWK_HSK_TIMEOUT:
-			tlv_groupwise_timeout =
-				(struct
-				 mwifiex_ie_types_eapol_gwk_hsk_timeout
-				 *)tlv;
-			bss->param.bss_config.groupwise_update_timeout =
-				le32_to_cpu(
-				tlv_groupwise_timeout->
-				groupwise_update_timeout);
-			break;
-		case TLV_TYPE_UAP_EAPOL_GWK_HSK_RETRIES:
-			tlv_groupwise_retries =
-				(struct
-				 mwifiex_ie_types_eapol_gwk_hsk_retries
-				 *)tlv;
-			bss->param.bss_config.gwk_retries =
-				le32_to_cpu(
-				tlv_groupwise_retries->
-				gwk_retries);
-			break;
-		case TLV_TYPE_UAP_STA_MAC_ADDR_FILTER:
-			tlv_mac_filter =
-				(struct mwifiex_ie_types_mac_filter *)tlv;
-			bss->param.bss_config.filter.mac_count =
-					tlv_mac_filter->count;
-			bss->param.bss_config.filter.filter_mode =
-					tlv_mac_filter->filter_mode;
-			memcpy((u8 *)bss->param.bss_config.filter.mac_list,
-					tlv_mac_filter->mac_address,
-					MWIFIEX_MAC_ADDR_LENGTH *
-					bss->param.bss_config.filter.mac_count);
-			break;
-		case TLV_TYPE_UAP_CHAN_BAND_CONFIG:
-			tlv_chan_band =
-				(struct mwifiex_ie_types_channel_band *)tlv;
-			bss->param.bss_config.band_cfg =
-						tlv_chan_band->band_config;
-			bss->param.bss_config.channel = tlv_chan_band->channel;
-			break;
-		case TLV_TYPE_CHANLIST:
-			tlv_chan_list =
-				(struct
-				 mwifiex_ie_types_chan_list_param_set
-				 *)tlv;
-			bss->param.bss_config.chan_list.num_of_chan =
-				tlv_len / sizeof(
-				struct mwifiex_chan_scan_param_set);
-			pscan_chan = tlv_chan_list->chan_scan_param;
-			for (i = 0; i < bss->param.bss_config.chan_list
-							.num_of_chan; i++) {
-				bss->param.bss_config.chan_list.chan[i] =
-							pscan_chan->chan_number;
-				pscan_chan++;
-			}
-			break;
-		case TLV_TYPE_AUTH_TYPE:
-			tlv_auth_type =
-				(struct mwifiex_ie_types_auth_type *)tlv;
-			bss->param.bss_config.auth_mode =
-					le16_to_cpu(tlv_auth_type->auth_type);
-			break;
-		case TLV_TYPE_UAP_ENCRYPT_PROTOCOL:
-			tlv_encrypt_protocol =
-					(struct
-					 mwifiex_ie_types_encrypt_protocol
-					 *)tlv;
-			bss->param.bss_config.protocol = le16_to_cpu(
-					tlv_encrypt_protocol->protocol);
-			break;
-		case TLV_TYPE_UAP_AKMP:
-			tlv_akmp = (struct mwifiex_ie_types_akmp *)tlv;
-			bss->param.bss_config.key_mgmt = le16_to_cpu(
-					tlv_akmp->key_mgmt);
-			break;
-		case TLV_TYPE_UAP_CIPHER:
-			tlv_cipher = (struct mwifiex_ie_types_cipher *)tlv;
-			bss->param.bss_config.wpa_cfg.pairwise_cipher_wpa =
-						tlv_cipher->pair_cipher;
-			bss->param.bss_config.wpa_cfg.pairwise_cipher_wpa2 =
-						tlv_cipher->pair_cipher;
-			bss->param.bss_config.wpa_cfg.group_cipher =
-						tlv_cipher->group_cipher;
-		case TLV_TYPE_PWK_CIPHER:
-			tlv_pwk_cipher =
-				(struct mwifiex_ie_types_pwk_cipher *)tlv;
-			if (le16_to_cpu(tlv_pwk_cipher->protocol) &
-								PROTOCOL_WPA)
-				bss->param.bss_config.wpa_cfg
-					.pairwise_cipher_wpa =
-						tlv_pwk_cipher->pairwise_cipher;
-			if (le16_to_cpu(tlv_pwk_cipher->protocol) &
-								PROTOCOL_WPA2)
-				bss->param.bss_config.wpa_cfg
-					.pairwise_cipher_wpa2 =
-						tlv_pwk_cipher->pairwise_cipher;
-			break;
-		case TLV_TYPE_GWK_CIPHER:
-			tlv_gwk_cipher =
-				(struct mwifiex_ie_types_gwk_cipher *)tlv;
-			bss->param.bss_config.wpa_cfg.group_cipher =
-						tlv_gwk_cipher->group_cipher;
-			break;
-		case TLV_TYPE_UAP_RSN_REPLAY_PROTECT:
-			tlv_rsn_prot =
-				(struct mwifiex_ie_types_rsn_replay_prot *)tlv;
-			bss->param.bss_config.wpa_cfg.rsn_protection =
-						tlv_rsn_prot->rsn_replay_prot;
-			break;
-		case TLV_TYPE_UAP_WPA_PASSPHRASE:
-			tlv_passphrase =
-				(struct mwifiex_ie_types_passphrase *)tlv;
-			bss->param.bss_config.wpa_cfg.length = tlv_len;
-			memcpy(bss->param.bss_config.wpa_cfg.passphrase,
-					tlv_passphrase->passphrase,
-					bss->param.bss_config.wpa_cfg.length);
-			break;
-		case TLV_TYPE_UAP_GRP_REKEY_TIME:
-			tlv_rekey_time =
-				(struct mwifiex_ie_types_group_rekey_time *)tlv;
-			bss->param.bss_config.wpa_cfg.gk_rekey_time =
-						le32_to_cpu(
-						tlv_rekey_time->gk_rekey_time);
-			break;
-		case TLV_TYPE_UAP_WEP_KEY:
-			tlv_wep_key  = (struct mwifiex_ie_types_wep_key *)tlv;
-			pkey = NULL;
-			if (tlv_wep_key->key_index == 0)
-				pkey = &bss->param.bss_config.wep_cfg.key0;
-			else if (tlv_wep_key->key_index == 1)
-				pkey = &bss->param.bss_config.wep_cfg.key1;
-			else if (tlv_wep_key->key_index == 2)
-				pkey = &bss->param.bss_config.wep_cfg.key2;
-			else if (tlv_wep_key->key_index == 3)
-				pkey = &bss->param.bss_config.wep_cfg.key3;
-			if (pkey) {
-				pkey->key_index = tlv_wep_key->key_index;
-				pkey->is_default = tlv_wep_key->is_default;
-				pkey->length = tlv_len - 2;
-				memcpy(pkey->key, tlv_wep_key->key,
-								pkey->length);
-			}
-			break;
-		case TLV_TYPE_UAP_PREAMBLE_CTL:
-			tlv_preamble = (struct mwifiex_ie_types_preamble *)tlv;
-			bss->param.bss_config.preamble_type =
-						tlv_preamble->preamble_type;
-			break;
-		}
-
-		tlv_buf_left -= tlv_len +
-					sizeof(struct mwifiex_ie_types_header);
-		tlv = (struct mwifiex_ie_types_header *)((u8 *)tlv + tlv_len +
-					sizeof(struct mwifiex_ie_types_header));
-	}
-
-	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * This function handles the command response of sys_config
- */
-static enum mwifiex_status mwifiex_uap_ret_sys_config(
-		struct mwifiex_private *priv,
-		struct host_cmd_ds_command *resp,
-		struct mwifiex_ioctl_req *pioctl_buf)
-{
-	struct host_cmd_ds_sys_config  *sys_config =
-		(struct host_cmd_ds_sys_config *)&resp->params.sys_config;
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ie_types_macaddr *tlv =
-		(struct mwifiex_ie_types_macaddr *)sys_config->tlv_buffer;
-
-	ENTER();
-
-	if (pioctl_buf) {
-		if (pioctl_buf->req_id == MWIFIEX_IOCTL_BSS) {
-			bss = (struct mwifiex_ds_bss *)pioctl_buf->buffer;
-			if (bss->sub_command == MWIFIEX_OID_BSS_MAC_ADDR) {
-				if (TLV_TYPE_UAP_MAC_ADDRESS ==
-						le16_to_cpu(tlv->header.type))
-					memcpy(&bss->param.mac_addr, tlv->mac,
-						MWIFIEX_MAC_ADDR_LENGTH);
-			} else if ((bss->sub_command ==
-					MWIFIEX_OID_UAP_BSS_CONFIG) &&
-					(pioctl_buf->action ==
-					MWIFIEX_ACT_GET)) {
-				mwifiex_uap_ret_cmd_ap_config(priv, resp,
-								pioctl_buf);
-			}
-		}
-	} else {
-		if (TLV_TYPE_UAP_MAC_ADDRESS ==  le16_to_cpu(tlv->header.type))
-			memcpy(priv->curr_addr, tlv->mac,
-						MWIFIEX_MAC_ADDR_LENGTH);
-	}
-	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * Clean up wapi station list
- */
-void mwifiex_delete_station_list(struct mwifiex_private *priv)
-{
-	struct sta_node *sta_ptr;
-
-	ENTER();
-	while ((sta_ptr = (struct sta_node *) mwifiex_util_dequeue_list(
-					&priv->sta_list, true))) {
-		kfree(sta_ptr);
-	}
-	LEAVE();
-	return;
-}
-
-#define BSS_START_EVENT_FIX_SIZE    12
-/*
- * This function will search for the specific ie
- */
-	static void
-mwifiex_check_uap_capability(struct mwifiex_private *priv,
-			     struct mwifiex_buffer *pevent)
-{
-	u16 tlv_type, tlv_len;
-	int tlv_buf_left = pevent->data_len - BSS_START_EVENT_FIX_SIZE;
-	struct mwifiex_ie_types_header *tlv = (struct mwifiex_ie_types_header *)
-						(pevent->buffer +
-						pevent->data_offset +
-						BSS_START_EVENT_FIX_SIZE);
-	const u8 wmm_oui[4] = { 0x00, 0x50, 0xf2, 0x02 };
-	struct ieee_types_wmm_parameter *pWmmParamIe = NULL;
-
-	priv->wmm_enabled = false;
-	priv->is_11n_enabled = false;
-	priv->pkt_fwd = false;
-	while (tlv_buf_left >= (int)sizeof(struct mwifiex_ie_types_header)) {
-		tlv_type = le16_to_cpu(tlv->type);
-		tlv_len  = le16_to_cpu(tlv->len);
-		if ((sizeof(struct mwifiex_ie_types_header) + tlv_len) >
-						(unsigned int)tlv_buf_left) {
-			PRINTM(MERROR, "wrong tlv: tlvLen=%d, tlvBufLeft=%d\n",
-					tlv_len, tlv_buf_left);
-			break;
-		}
-		if (tlv_type == VENDOR_SPECIFIC_221) {
-			if (!memcmp((u8 *)tlv +
-						sizeof(
-						struct mwifiex_ie_types_header),
-						wmm_oui, sizeof(wmm_oui))) {
-				DBG_HEXDUMP(MCMD_D, "wmm ie tlv", tlv, tlv_len +
-					sizeof(
-					struct mwifiex_ie_types_header));
-				priv->wmm_enabled = false;
-				mwifiex_wmm_setup_ac_downgrade(priv);
-				priv->wmm_enabled = true;
-				pWmmParamIe =
-					(struct ieee_types_wmm_parameter *)
-					((u8 *)tlv + 2);
-				pWmmParamIe->vend_hdr.len = (u8)tlv_len;
-				pWmmParamIe->vend_hdr.element_id = WMM_IE;
-				mwifiex_wmm_setup_queue_priorities(priv,
-								   pWmmParamIe);
-			}
-		}
-		if (tlv_type == HT_CAPABILITY) {
-			DBG_HEXDUMP(MCMD_D, "HT_CAP tlv", tlv, tlv_len +
-					sizeof(struct mwifiex_ie_types_header));
-			priv->is_11n_enabled = true;
-		}
-		if (tlv_type == TLV_TYPE_UAP_PKT_FWD_CTL) {
-			DBG_HEXDUMP(MCMD_D, "pkt_fwd tlv", tlv, tlv_len +
-					sizeof(struct mwifiex_ie_types_header));
-			/* We will disable host pkt forwarding if firmware's
-						pkt_fwd_ctl is enabled */
-			priv->pkt_fwd = (*((u8 *)tlv + sizeof(
-				struct mwifiex_ie_types_header)) == 1) ? 0 : 1;
-			PRINTM(MCMND, "pkt_fwd=%d\n", priv->pkt_fwd);
-		}
-		tlv_buf_left -= (sizeof(struct mwifiex_ie_types_header) +
-								tlv_len);
-		tlv = (struct mwifiex_ie_types_header *)((u8 *)tlv + tlv_len +
-					sizeof(struct mwifiex_ie_types_header));
-	}
-	if (priv->wmm_enabled == false) {
-		/* Since WMM is not enabled, setup the queues with
-						the defaults */
-		mwifiex_wmm_setup_queues(priv);
-	}
-}
-
-/*
- * This function prepare the command before sending to firmware.
- */
-enum mwifiex_status
-mwifiex_ops_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
-			u16 cmd_action, u32 cmd_oid, void *pioctl_buf,
-			void *pdata_buf, void *pcmd_buf)
-{
-	struct host_cmd_ds_command *cmd_ptr =
-					(struct host_cmd_ds_command *)pcmd_buf;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	/* Prepare command */
-	switch (cmd_no) {
-	case HOST_CMD_APCMD_BSS_STOP:
-	case HOST_CMD_APCMD_BSS_START:
-	case HOST_CMD_APCMD_SYS_INFO:
-	case HOST_CMD_APCMD_SYS_RESET:
-	case HOST_CMD_APCMD_STA_LIST:
-		cmd_ptr->command = cpu_to_le16(cmd_no);
-		cmd_ptr->size = cpu_to_le16(S_DS_GEN);
-		break;
-	case HOST_CMD_APCMD_SYS_CONFIGURE:
-		ret = mwifiex_uap_cmd_sys_configure(priv, cmd_ptr, cmd_action,
-					(struct mwifiex_ioctl_req *)pioctl_buf);
-		break;
-	case HostCmd_CMD_FUNC_INIT:
-		if (priv->adapter->hw_status == MWIFIEX_HW_STATUS_RESET)
-			priv->adapter->hw_status = MWIFIEX_HW_STATUS_READY;
-		cmd_ptr->command = cpu_to_le16(cmd_no);
-		cmd_ptr->size = cpu_to_le16(S_DS_GEN);
-		break;
-	case HostCmd_CMD_FUNC_SHUTDOWN:
-		priv->adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
-		cmd_ptr->command = cpu_to_le16(cmd_no);
-		cmd_ptr->size = cpu_to_le16(S_DS_GEN);
-		break;
-	case HostCmd_CMD_GET_HW_SPEC:
-		ret = mwifiex_cmd_get_hw_spec(priv, cmd_ptr);
-		break;
-	default:
-		PRINTM(MERROR, "PREP_CMD: unknown command- %#x\n", cmd_no);
-		ret = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return ret;
-}
-
-/*
- * This function handles the AP mode command response
- */
-enum mwifiex_status
-mwifiex_ops_uap_process_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
-			    void *pcmd_buf, void *pioctl)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct host_cmd_ds_command *resp =
-					(struct host_cmd_ds_command *)pcmd_buf;
-	struct mwifiex_ioctl_req *pioctl_buf =
-					(struct mwifiex_ioctl_req *)pioctl;
-
-	ENTER();
-
-	/* If the command is not successful, cleanup and return failure */
-	if (resp->result != HostCmd_RESULT_OK) {
-		uap_process_cmdresp_error(priv, resp, pioctl_buf);
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	/* Command successful, handle response */
-	switch (cmdresp_no) {
-	case HOST_CMD_APCMD_BSS_STOP:
-	case HOST_CMD_APCMD_BSS_START:
-	case HOST_CMD_APCMD_SYS_RESET:
-		break;
-	case HOST_CMD_APCMD_SYS_CONFIGURE:
-		ret = mwifiex_uap_ret_sys_config(priv, resp, pioctl_buf);
-		break;
-	case HostCmd_CMD_FUNC_INIT:
-	case HostCmd_CMD_FUNC_SHUTDOWN:
-		break;
-	case HostCmd_CMD_GET_HW_SPEC:
-		ret = mwifiex_ret_get_hw_spec(priv, resp, pioctl_buf);
-		break;
-	default:
-		PRINTM(MERROR, "CMD_RESP: Unknown command response %#x\n",
-								resp->command);
-		break;
-	}
-	LEAVE();
-	return ret;
-}
-
-/*
- * This function handles events generated by firmware
- */
-enum mwifiex_status
-mwifiex_ops_uap_process_event(struct mwifiex_private *priv)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u32 eventcause = adapter->event_cause;
-	struct mwifiex_buffer *mbuf = adapter->mwifiex_buffer_event;
-	u8 *event_buf = NULL;
-	struct mwifiex_event *pevent = NULL;
-
-	ENTER();
-
-	/* Allocate memory for event buffer */
-	event_buf = kzalloc(MAX_EVENT_SIZE, GFP_ATOMIC);
-	if (!event_buf) {
-		PRINTM(MERROR, "%s: Could not allocate buffer for event buf\n",
-								 __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
-
-	pevent = (struct mwifiex_event *)event_buf;
-	pevent->event_id = 0;
-
-	memcpy(mbuf->buffer + mbuf->data_offset, (u8 *)&eventcause,
-							sizeof(eventcause));
-
-	switch (eventcause) {
-	case EVENT_MICRO_AP_BSS_START:
-		PRINTM(MEVENT, "EVENT: MICRO_AP_BSS_START\n");
-		memcpy(priv->curr_addr, adapter->event_body+2,
-						MWIFIEX_MAC_ADDR_LENGTH);
-		pevent->event_id = MWIFIEX_EVENT_ID_UAP_FW_BSS_START;
-		mwifiex_check_uap_capability(priv, mbuf);
-		break;
-	case EVENT_MICRO_AP_BSS_ACTIVE:
-		PRINTM(MEVENT, "EVENT: MICRO_AP_BSS_ACTIVE\n");
-		priv->media_connected = true;
-		pevent->event_id = MWIFIEX_EVENT_ID_UAP_FW_BSS_ACTIVE;
-		break;
-	case EVENT_MICRO_AP_BSS_IDLE:
-		PRINTM(MEVENT, "EVENT: MICRO_AP_BSS_IDLE\n");
-		pevent->event_id = MWIFIEX_EVENT_ID_UAP_FW_BSS_IDLE;
-		priv->media_connected = false;
-		mwifiex_clean_txrx(priv);
-		mwifiex_delete_station_list(priv);
-		break;
-	case EVENT_PS_AWAKE:
-		PRINTM(MINFO, "EVENT: AWAKE\n");
-		PRINTM(MEVENT, "||");
-		adapter->pm_wakeup_card_req = false;
-		adapter->pm_wakeup_fw_try = false;
-		adapter->ps_state = PS_STATE_AWAKE;
-		break;
-	case EVENT_PS_SLEEP:
-		PRINTM(MINFO, "EVENT: SLEEP\n");
-		PRINTM(MEVENT, "__");
-		/* Handle unexpected PS SLEEP event */
-		adapter->ps_state = PS_STATE_PRE_SLEEP;
-		mwifiex_check_ps_cond(adapter);
-		break;
-	default:
-		pevent->event_id = MWIFIEX_EVENT_ID_DRV_PASSTHU;
-		break;
-	}
-
-	if (pevent->event_id) {
-		pevent->bss_index = priv->bss_index;
-		pevent->event_len = mbuf->data_len;
-		memcpy((u8 *)pevent->event_buf, mbuf->buffer +
-					mbuf->data_offset, pevent->event_len);
-		mwifiex_recv_event(priv, pevent->event_id, pevent);
-	}
-
-done:
-	kfree(event_buf);
-	LEAVE();
-	return ret;
-}
-
-/*
- * This function issues commands to initialize firmware
- */
-enum mwifiex_status mwifiex_ops_uap_init_cmd(struct mwifiex_private *priv,
-					 u8 first_sta)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u16 last_cmd = 0;
-
-	ENTER();
-
-	if (!first_sta)
-		goto get_mac;
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_FUNC_INIT,
-			HostCmd_ACT_GEN_SET, 0, NULL, NULL);
-	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
-			HostCmd_ACT_GEN_GET, 0, NULL, NULL);
-	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
-	/* Reconfigure tx buf size */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
-						HostCmd_ACT_GEN_SET, 0, NULL,
-						&priv->adapter->tx_buf_size);
-	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
-
-get_mac:
-	ret = mwifiex_prepare_cmd(priv, HOST_CMD_APCMD_SYS_CONFIGURE,
-			HostCmd_ACT_GEN_GET, 0, NULL, NULL);
-	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
-	last_cmd = HOST_CMD_APCMD_SYS_CONFIGURE;
-	/** set last_init_cmd */
-	if (last_cmd) {
-		priv->adapter->last_init_cmd = last_cmd;
-		ret = MWIFIEX_STATUS_PENDING;
-	}
-done:
-	LEAVE();
-	return ret;
-}
diff --git a/drivers/net/wireless/mwifiex/uap_ioctl.c b/drivers/net/wireless/mwifiex/uap_ioctl.c
deleted file mode 100644
index 4e28b79..0000000
--- a/drivers/net/wireless/mwifiex/uap_ioctl.c
+++ /dev/null
@@ -1,397 +0,0 @@
-/**
- * Marvell Wireless LAN device driver: the handling of AP mode ioctls
- *
- * Copyright (C) 2010, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available by writing to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
- * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
-
-#include "decl.h"
-#include "ioctl.h"
-#include "ieee.h"
-#include "util.h"
-#include "fw.h"
-#include "main.h"
-#include "sdio.h"
-#include "wmm.h"
-#include "11n_aggr.h"
-#include "11n_rxreorder.h"
-#include "uap.h"
-
-/*
- * IOCTL handler to stop the BSS
- */
-static enum mwifiex_status
-mwifiex_uap_bss_ioctl_stop(struct mwifiex_adapter *adapter,
-			   struct mwifiex_ioctl_req  *pioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[pioctl_req->bss_index];
-
-	ENTER();
-
-	ret = mwifiex_prepare_cmd(priv,
-			HOST_CMD_APCMD_BSS_STOP,
-			HostCmd_ACT_GEN_SET,
-			0,
-			(void *)pioctl_req,
-			NULL);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL handler to start the BSS
- */
-static enum mwifiex_status
-mwifiex_uap_bss_ioctl_start(struct mwifiex_adapter *adapter,
-			    struct mwifiex_ioctl_req  *pioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[pioctl_req->bss_index];
-
-	ENTER();
-
-	ret = mwifiex_prepare_cmd(priv,
-			HOST_CMD_APCMD_BSS_START,
-			HostCmd_ACT_GEN_SET,
-			0,
-			(void *)pioctl_req,
-			NULL);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL handler to set/get MAC address
- */
-static enum mwifiex_status
-mwifiex_uap_bss_ioctl_mac_address(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *pioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[pioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u16 cmd_action = 0;
-
-	ENTER();
-
-	bss = (struct mwifiex_ds_bss *)pioctl_req->buffer;
-	if (pioctl_req->action == MWIFIEX_ACT_SET) {
-		memcpy(priv->curr_addr, &bss->param.mac_addr,
-						MWIFIEX_MAC_ADDR_LENGTH);
-		cmd_action = HostCmd_ACT_GEN_SET;
-	} else {
-		cmd_action = HostCmd_ACT_GEN_GET;
-	}
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HOST_CMD_APCMD_SYS_CONFIGURE,
-			cmd_action, 0, (void *)pioctl_req, NULL);
-
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL handler to set/get AP configuration parameters.
- */
-static enum mwifiex_status
-mwifiex_uap_bss_ioctl_config(struct mwifiex_adapter *adapter,
-			     struct mwifiex_ioctl_req *pioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[pioctl_req->bss_index];
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u16 cmd_action = 0;
-
-	ENTER();
-
-	if (pioctl_req->action == MWIFIEX_ACT_SET)
-		cmd_action = HostCmd_ACT_GEN_SET;
-	else
-		cmd_action = HostCmd_ACT_GEN_GET;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HOST_CMD_APCMD_SYS_CONFIGURE,
-			cmd_action, 0, (void *)pioctl_req, NULL);
-
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * MWIFIEX uap ioctl handler
- */
-enum mwifiex_status mwifiex_ops_uap_ioctl(struct mwifiex_adapter *adapter,
-				      struct mwifiex_ioctl_req  *pioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_bss *bss = NULL;
-
-	ENTER();
-
-	switch (pioctl_req->req_id) {
-	case MWIFIEX_IOCTL_BSS:
-		bss = (struct mwifiex_ds_bss *)pioctl_req->buffer;
-		if (bss->sub_command == MWIFIEX_OID_BSS_MAC_ADDR)
-			status = mwifiex_uap_bss_ioctl_mac_address(adapter,
-								pioctl_req);
-		else if (bss->sub_command == MWIFIEX_OID_BSS_STOP)
-			status = mwifiex_uap_bss_ioctl_stop(adapter,
-								pioctl_req);
-		else if (bss->sub_command == MWIFIEX_OID_BSS_START)
-			status = mwifiex_uap_bss_ioctl_start(adapter,
-								pioctl_req);
-		else if (bss->sub_command == MWIFIEX_OID_UAP_BSS_CONFIG)
-			status = mwifiex_uap_bss_ioctl_config(adapter,
-								pioctl_req);
-	default:
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
- * uap bss control ioctl handler
- */
-int mwifiex_uap_bss_ctrl(struct mwifiex_private *priv, int data)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_bss *bss = NULL;
-	int ret = 0;
-
-	ENTER();
-
-	PRINTM(MINFO, "ioctl bss ctrl=%d\n", data);
-	if ((data != UAP_BSS_START) && (data != UAP_BSS_STOP) &&
-			(data != UAP_BSS_RESET)) {
-		PRINTM(MERROR, "Invalid parameter: %d\n", data);
-		ret = -EINVAL;
-		goto done;
-	}
-
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	switch (data) {
-	case UAP_BSS_START:
-		bss->sub_command = MWIFIEX_OID_BSS_START;
-		break;
-	case UAP_BSS_STOP:
-		bss->sub_command = MWIFIEX_OID_BSS_STOP;
-		break;
-	}
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_SET;
-
-	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
-		if (data == UAP_BSS_START &&
-				req->status_code != BSS_START_REDUNDANT)
-			ret = -EFAULT;
-		if (data == UAP_BSS_STOP &&
-				req->status_code != BSS_STOP_REDUNDANT)
-			ret = -EFAULT;
-	}
-
-done:
-	kfree(req);
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * This function parses AP configuration information from ASCII string
- */
-int mwifiex_uap_ap_cfg_parse_data(struct mwifiex_uap_bss_param *ap_cfg, s8 *buf)
-{
-	int ret = 0, atoi_ret;
-	int set_sec = 0, set_key = 0, set_chan = 0;
-	int set_sta_num = 0, set_ssid = 0;
-	char *begin = buf, *value = NULL, *opt = NULL;
-
-	ENTER();
-
-	while (begin) {
-		value = mwifiex_strsep(&begin, ',', '/');
-		opt = mwifiex_strsep(&value, '=', '/');
-		if (opt && !strncmp(opt, "END", strlen("END"))) {
-			if (!ap_cfg->ssid.ssid_len) {
-				PRINTM(MERROR, "Minimum option required is "
-					       "SSID\n");
-				ret = -EINVAL;
-				goto done;
-			}
-			PRINTM(MINFO, "Parsing terminated by string END\n");
-			break;
-		}
-		if (!opt || !value || !value[0]) {
-			PRINTM(MERROR, "Invalid option\n");
-			ret = -EINVAL;
-			goto done;
-		} else if (!strncmp(opt, "ASCII_CMD", strlen("ASCII_CMD"))) {
-			if (strncmp(value, "AP_CFG", strlen("AP_CFG"))) {
-				PRINTM(MERROR, "ASCII_CMD: %s not matched with "
-					       "AP_CFG\n", value);
-				ret = -EFAULT;
-				goto done;
-			}
-			value = mwifiex_strsep(&begin, ',', '/');
-			opt = mwifiex_strsep(&value, '=', '/');
-			if (!opt || !value || !value[0]) {
-				PRINTM(MERROR, "Minimum option required is "
-					       "SSID\n");
-				ret = -EINVAL;
-				goto done;
-			} else if (!strncmp(opt, "SSID", strlen("SSID"))) {
-				if (set_ssid) {
-					PRINTM(MWARN, "Skipping SSID, found "
-						      "again!\n");
-					continue;
-				}
-				if (strlen(value) > MWIFIEX_MAX_SSID_LENGTH) {
-					PRINTM(MERROR, "SSID length exceeds max"
-						       " length\n");
-					ret = -EFAULT;
-					goto done;
-				}
-				ap_cfg->ssid.ssid_len = strlen(value);
-				strcpy((char *)ap_cfg->ssid.ssid, value);
-				PRINTM(MINFO, "ssid=%s, len=%d\n",
-						ap_cfg->ssid.ssid,
-						(int)ap_cfg->ssid.ssid_len);
-				set_ssid = 1;
-			} else {
-				PRINTM(MERROR, "AP_CFG: Invalid option %s, "
-						"expect SSID\n", opt);
-				ret = -EINVAL;
-				goto done;
-			}
-		} else if (!strncmp(opt, "SEC", strlen("SEC"))) {
-			if (set_sec) {
-				PRINTM(MWARN, "Skipping SEC, found again!\n");
-				continue;
-			}
-			if (!strnicmp(value, "open", strlen("open"))) {
-				ap_cfg->auth_mode = MWIFIEX_AUTH_MODE_OPEN;
-				if (set_key)
-					ap_cfg->wpa_cfg.length = 0;
-				ap_cfg->key_mgmt = KEY_MGMT_NONE;
-				ap_cfg->protocol = PROTOCOL_NO_SECURITY;
-			} else if (!strnicmp(value, "wpa2-psk",
-							strlen("wpa2-psk"))) {
-				ap_cfg->auth_mode = MWIFIEX_AUTH_MODE_OPEN;
-				ap_cfg->protocol = PROTOCOL_WPA2;
-				ap_cfg->key_mgmt = KEY_MGMT_PSK;
-				ap_cfg->wpa_cfg.pairwise_cipher_wpa =
-								CIPHER_AES_CCMP;
-				ap_cfg->wpa_cfg.pairwise_cipher_wpa2 =
-								CIPHER_AES_CCMP;
-				ap_cfg->wpa_cfg.group_cipher = CIPHER_AES_CCMP;
-			} else {
-				PRINTM(MERROR, "AP_CFG: Invalid value=%s for "
-					       "%s\n",
-					       value, opt);
-				ret = -EFAULT;
-				goto done;
-			}
-			set_sec = 1;
-		} else if (!strncmp(opt, "KEY", strlen("KEY"))) {
-			if (set_key) {
-				PRINTM(MWARN, "Skipping KEY, found again!\n");
-				continue;
-			}
-			if (set_sec && ap_cfg->protocol != PROTOCOL_WPA2) {
-				PRINTM(MWARN, "Warning! No KEY for open "
-					      "mode\n");
-				set_key = 1;
-				continue;
-			}
-			if (strlen(value) < MWIFIEX_MIN_PASSPHRASE_LENGTH ||
-						strlen(value) >
-						MWIFIEX_MAX_PMK_LENGTH * 2) {
-				PRINTM(MERROR, "Invalid PSK length\n");
-				ret = -EINVAL;
-				goto done;
-			}
-			ap_cfg->wpa_cfg.length = strlen(value);
-			memcpy(ap_cfg->wpa_cfg.passphrase, value,
-								strlen(value));
-			set_key = 1;
-		} else if (!strncmp(opt, "CHANNEL", strlen("CHANNEL"))) {
-			if (set_chan) {
-				PRINTM(MWARN, "Skipping CHANNEL, found "
-					      "again!\n");
-				continue;
-			}
-			if (mwifiex_atoi(&atoi_ret, value)) {
-				ret = -EINVAL;
-				goto done;
-			}
-			if (atoi_ret < 1 || atoi_ret > MAX_CHANNEL) {
-				PRINTM(MERROR, "AP_CFG: Channel must be between"
-					       " 1 and %d(both included)\n",
-					       MAX_CHANNEL);
-				ret = -EINVAL;
-				goto done;
-			}
-			ap_cfg->channel = atoi_ret;
-			set_chan = 1;
-		} else if (!strncmp(opt, "MAX_STA_NUM",
-						strlen("MAX_STA_NUM"))) {
-			if (set_sta_num) {
-				PRINTM(MWARN, "Skipping MAX_STA_NUM, found "
-					      "again!\n");
-				continue;
-			}
-			if (mwifiex_atoi(&atoi_ret, value)) {
-				ret = -EINVAL;
-				goto done;
-			}
-			if (atoi_ret < 0 || atoi_ret > MAX_STA_COUNT) {
-				PRINTM(MERROR, "AP_CFG: MAX_STA_NUM must be "
-					    "between 0 to %d (both included)\n",
-					    MAX_STA_COUNT);
-				ret = -EINVAL;
-				goto done;
-			}
-			ap_cfg->max_sta_count = (u16)atoi_ret;
-			set_sta_num = 1;
-		} else {
-			PRINTM(MERROR, "Invalid option %s\n", opt);
-			ret = -EINVAL;
-			goto done;
-		}
-	}
-
-done:
-	LEAVE();
-	return ret;
-}
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
deleted file mode 100644
index 349dd76..0000000
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ /dev/null
@@ -1,416 +0,0 @@
-/**
- * Marvell Wireless LAN device driver: AP mode transmit and receive functions
- *
- * Copyright (C) 2010, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available by writing to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
- * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- **/
-
-#include "decl.h"
-#include "ioctl.h"
-#include "ieee.h"
-#include "util.h"
-#include "fw.h"
-#include "main.h"
-#include "sdio.h"
-#include "wmm.h"
-#include "11n_aggr.h"
-#include "11n_rxreorder.h"
-#include "uap.h"
-
-void *mwifiex_ops_uap_process_txpd(struct mwifiex_private *priv,
-				struct mwifiex_buffer *mbuf)
-{
-	struct mwifiex_uap_txpd *plocal_tx_pd;
-	u8 *head_ptr = NULL;
-	ENTER();
-
-	if (!mbuf->data_len) {
-		PRINTM(MERROR, "uAP Tx Error: Invalid packet length: %d\n",
-				mbuf->data_len);
-		mbuf->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
-		goto done;
-	}
-	if (mbuf->data_offset < (sizeof(struct mwifiex_uap_txpd) +
-						INTF_HEADER_LEN +
-						HEADER_ALIGNMENT)) {
-		PRINTM(MERROR, "not enough space for mwifiex_uap_txpd: len=%d, "
-			       "offset=%d\n", mbuf->data_len,
-			       mbuf->data_offset);
-		DBG_HEXDUMP(MDAT_D, "drop pkt", mbuf->buffer +
-			    mbuf->data_offset, mbuf->data_len);
-		mbuf->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
-		goto done;
-	}
-
-	/* head_ptr should be aligned */
-	head_ptr = mbuf->buffer + mbuf->data_offset -
-			sizeof(struct mwifiex_uap_txpd) - INTF_HEADER_LEN;
-	head_ptr = (u8 *)((unsigned long)head_ptr
-			& ~((unsigned long)(HEADER_ALIGNMENT - 1)));
-
-	plocal_tx_pd = (struct mwifiex_uap_txpd *)(head_ptr + INTF_HEADER_LEN);
-	memset(plocal_tx_pd, 0, sizeof(struct mwifiex_uap_txpd));
-
-	/* Set the BSS number to TxPD */
-	plocal_tx_pd->bss_num = priv->bss_num;
-	plocal_tx_pd->bss_type = priv->bss_type;
-
-	plocal_tx_pd->tx_pkt_length = cpu_to_le16((u16)mbuf->data_len);
-
-	plocal_tx_pd->priority     = (u8)mbuf->priority;
-	plocal_tx_pd->pkt_delay_2ms =
-			mwifiex_wmm_compute_drv_pkt_delay(priv, mbuf);
-
-	if (plocal_tx_pd->priority < ARRAY_SIZE(priv->wmm.user_pri_pkt_tx_ctrl))
-		/*
-		 * Set the priority specific tx_control field, setting of 0 will
-		 *   cause the default value to be used later in this function
-		 */
-		plocal_tx_pd->tx_control = cpu_to_le32(priv->wmm
-				.user_pri_pkt_tx_ctrl[plocal_tx_pd->priority]);
-
-	/* Offset of actual data */
-	plocal_tx_pd->tx_pkt_offset = cpu_to_le16(
-				(u16)((unsigned long)mbuf->buffer +
-					mbuf->data_offset -
-					(unsigned long)plocal_tx_pd));
-
-	/* Adjust the data offset and length to include TxPD in mbuf */
-	mbuf->data_len += mbuf->data_offset;
-	mbuf->data_offset = head_ptr - mbuf->buffer;
-	mbuf->data_len -= mbuf->data_offset;
-
-done:
-	LEAVE();
-	return head_ptr;
-}
-
-/*
- * This function processes received packet and forwards it
- * to kernel/upper layer
- */
-static enum mwifiex_status
-mwifiex_upload_uap_rx_packet(struct mwifiex_adapter *adapter,
-			     struct mwifiex_buffer *mbuf)
-{
-	enum mwifiex_status    ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_uap_rxpd *prx_pd;
-	ENTER();
-
-	prx_pd  = (struct mwifiex_uap_rxpd *)(mbuf->buffer +
-							mbuf->data_offset);
-
-	/* Chop off RxPD */
-	mbuf->data_len -= le16_to_cpu(prx_pd->rx_pkt_offset);
-	mbuf->data_offset += le16_to_cpu(prx_pd->rx_pkt_offset);
-	mbuf->parent = NULL;
-
-	do_gettimeofday(&mbuf->out_tstamp);
-
-	PRINTM(MDATA, "%lu.%lu : Data => kernel seq_num=%d tid=%d\n",
-			mbuf->out_tstamp.tv_sec, mbuf->out_tstamp.tv_usec,
-			prx_pd->seq_num, prx_pd->priority);
-	ret = mwifiex_recv_packet(adapter, mbuf);
-	if (ret == MWIFIEX_STATUS_FAILURE)
-		PRINTM(MERROR, "uAP Rx Error: moal_recv_packet returned "
-			       "error\n");
-
-	if (ret != MWIFIEX_STATUS_PENDING)
-		mwifiex_free_buffer_skb(mbuf);
-
-	LEAVE();
-
-	return ret;
-
-}
-
-/*
- * This function processes received packet and forwards it
- * to kernel/upper layer or send back to firmware
- */
-enum mwifiex_status mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
-						  struct mwifiex_buffer *mbuf)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_uap_rxpd *prx_pd;
-	struct rx_packet_hdr *prx_pkt;
-	struct mwifiex_buffer *newbuf = NULL;
-
-	ENTER();
-
-	prx_pd  = (struct mwifiex_uap_rxpd *)(mbuf->buffer +
-						mbuf->data_offset);
-	prx_pkt = (struct rx_packet_hdr *)((u8 *)prx_pd +
-					le16_to_cpu(prx_pd->rx_pkt_offset));
-
-	DBG_HEXDUMP(MDAT_D, "uap_rx_packet", mbuf->buffer + mbuf->data_offset,
-			min_t(u32, mbuf->data_len, MAX_DATA_DUMP_LEN));
-
-	PRINTM(MINFO, "RX Data: data_len - prx_pd->rx_pkt_offset = "
-		      "%d - %d = %d\n",
-			mbuf->data_len, le16_to_cpu(prx_pd->rx_pkt_offset),
-			mbuf->data_len - le16_to_cpu(prx_pd->rx_pkt_offset));
-	PRINTM(MDATA, "Rx dest %02x:%02x:%02x:%02x:%02x:%02x\n",
-			prx_pkt->eth803_hdr.dest_addr[0],
-			prx_pkt->eth803_hdr.dest_addr[1],
-			prx_pkt->eth803_hdr.dest_addr[2],
-			prx_pkt->eth803_hdr.dest_addr[3],
-			prx_pkt->eth803_hdr.dest_addr[4],
-			prx_pkt->eth803_hdr.dest_addr[5]);
-
-	/* don't do packet forwarding in disconnected state */
-	if (priv->media_connected == false)
-		goto upload;
-	if (prx_pkt->eth803_hdr.dest_addr[0] & 0x01) {
-		/* Multicast pkt */
-		newbuf = mwifiex_alloc_buffer(MWIFIEX_TX_DATA_BUF_SIZE_2K);
-		if (newbuf) {
-			newbuf->bss_index = mbuf->bss_index;
-			newbuf->buf_type = mbuf->buf_type;
-			newbuf->priority = mbuf->priority;
-			newbuf->in_tstamp = mbuf->in_tstamp;
-			newbuf->data_offset = (sizeof(struct mwifiex_uap_txpd) +
-					INTF_HEADER_LEN + HEADER_ALIGNMENT);
-			adapter->pending_bridge_pkts++;
-			newbuf->flags |= MWIFIEX_BUF_FLAG_BRIDGE_BUF;
-
-			/* copy the data, skip rxpd */
-			memcpy((u8 *)newbuf->buffer+newbuf->data_offset,
-					mbuf->buffer + mbuf->data_offset +
-					le16_to_cpu(prx_pd->rx_pkt_offset),
-					mbuf->data_len - le16_to_cpu(
-					prx_pd->rx_pkt_offset));
-			newbuf->data_len = mbuf->data_len -
-					le16_to_cpu(prx_pd->rx_pkt_offset);
-			mwifiex_wmm_add_buf_txqueue(adapter, newbuf);
-
-		}
-	} else {
-		if (mwifiex_get_station_entry(priv,
-					prx_pkt->eth803_hdr.dest_addr)) {
-			/* Inter BSS packet */
-			mbuf->data_len -= le16_to_cpu(prx_pd->rx_pkt_offset);
-			mbuf->data_offset +=
-					le16_to_cpu(prx_pd->rx_pkt_offset);
-			mbuf->flags |= MWIFIEX_BUF_FLAG_BRIDGE_BUF;
-			adapter->pending_bridge_pkts++;
-			mwifiex_wmm_add_buf_txqueue(adapter, mbuf);
-			goto done;
-		}
-	}
-upload:
-	/* Chop off RxPD */
-	mbuf->data_len -= le16_to_cpu(prx_pd->rx_pkt_offset);
-	mbuf->data_offset += le16_to_cpu(prx_pd->rx_pkt_offset);
-	mbuf->parent = NULL;
-
-	do_gettimeofday(&mbuf->out_tstamp);
-	PRINTM(MDATA, "%lu.%lu : Data => kernel seq_num=%d tid=%d\n",
-			mbuf->out_tstamp.tv_sec, mbuf->out_tstamp.tv_usec,
-			prx_pd->seq_num, prx_pd->priority);
-
-	ret = mwifiex_recv_packet(adapter, mbuf);
-	if (ret == MWIFIEX_STATUS_FAILURE)
-		PRINTM(MERROR, "uAP Rx Error: moal_recv_packet returned "
-			       "error\n");
-
-	if (ret != MWIFIEX_STATUS_PENDING)
-		mwifiex_free_buffer(mbuf);
-done:
-	LEAVE();
-	return ret;
-}
-
-enum mwifiex_status
-mwifiex_ops_uap_process_rx_packet(struct mwifiex_adapter *adapter,
-						  struct mwifiex_buffer *mbuf)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_uap_rxpd *prx_pd;
-	struct rx_packet_hdr *prx_pkt;
-	struct mwifiex_private *priv = adapter->priv[mbuf->bss_index];
-	u8 ta[MWIFIEX_MAC_ADDR_LENGTH];
-	u16 rx_pkt_type = 0;
-	struct sta_node *sta_ptr = NULL;
-	u16 rx_pkt_length;
-	u16 rx_pkt_offset;
-	u16 seq_num;
-
-	ENTER();
-
-	prx_pd  = (struct mwifiex_uap_rxpd *)(mbuf->buffer + mbuf->data_offset);
-	/* Endian conversion */
-	rx_pkt_type = le16_to_cpu(prx_pd->rx_pkt_type);
-	rx_pkt_length = le16_to_cpu(prx_pd->rx_pkt_length);
-	rx_pkt_offset = le16_to_cpu(prx_pd->rx_pkt_offset);
-	seq_num = le16_to_cpu(prx_pd->seq_num);
-
-	prx_pkt = (struct rx_packet_hdr *)((u8 *)prx_pd + rx_pkt_offset);
-
-	DBG_HEXDUMP(MDAT_D, "UAP Rx", mbuf->buffer + mbuf->data_offset,
-			min_t(u32, mbuf->data_len, MAX_DATA_DUMP_LEN));
-
-	PRINTM(MINFO, "RX Data: data_len - prx_pd->rx_pkt_offset = "
-		      "%d - %d = %d\n",
-			mbuf->data_len, rx_pkt_offset,
-			mbuf->data_len - rx_pkt_offset);
-
-	if ((rx_pkt_offset + rx_pkt_length) > (u16)mbuf->data_len) {
-		PRINTM(MERROR, "Wrong rx packet: len=%d,rx_pkt_offset=%d,"
-				" rx_pkt_length=%d\n", mbuf->data_len,
-				rx_pkt_offset, rx_pkt_length);
-		ret = MWIFIEX_STATUS_FAILURE;
-		mwifiex_free_buffer_skb(mbuf);
-		goto done;
-	}
-	mbuf->data_len = rx_pkt_offset + rx_pkt_length;
-
-	mbuf->priority = prx_pd->priority;
-	if (rx_pkt_type == PKT_TYPE_AMSDU) {
-		mbuf->data_len = rx_pkt_length;
-		mbuf->data_offset += rx_pkt_offset;
-		mwifiex_11n_deaggregate_pkt(priv, mbuf);
-		goto done;
-	}
-	memcpy(ta, prx_pkt->eth803_hdr.src_addr, MWIFIEX_MAC_ADDR_LENGTH);
-	if (rx_pkt_type != PKT_TYPE_BAR) {
-		sta_ptr = mwifiex_get_station_entry(priv, ta);
-		if (sta_ptr)
-			sta_ptr->rx_seq[prx_pd->priority] = seq_num;
-	}
-	/* check if UAP enable 11n */
-	if (!priv->is_11n_enabled || !mwifiex_11n_get_rx_reorder_tbl(
-			(struct mwifiex_private *)priv, prx_pd->priority, ta)) {
-		if (priv->pkt_fwd == true)
-			mwifiex_process_uap_rx_packet(priv, mbuf);
-		else
-			mwifiex_upload_uap_rx_packet(adapter, mbuf);
-		goto done;
-	}
-	/* Reorder and send to OS */
-	ret = mwifiex_11n_rx_reorder_pkt(priv, seq_num,
-					 prx_pd->priority, ta,
-					 (u8)rx_pkt_type,
-					 (void *) mbuf);
-
-	if (ret || (rx_pkt_type == PKT_TYPE_BAR))
-		mwifiex_free_buffer_skb(mbuf);
-
-done:
-
-	if ((adapter->pending_bridge_pkts >= RX_HIGH_THRESHOLD)
-			&& (!adapter->rx_pause_flag)) {
-		adapter->rx_pause_flag = true;
-		mwifiex_prepare_cmd(priv, HOST_CMD_RX_DATA_PAUSE,
-					HostCmd_ACT_GEN_SET, 0, NULL, NULL);
-	}
-
-	LEAVE();
-	return ret;
-
-}
-
-/*
- * This function processes received packet and forwards it
- * to kernel/upper layer or send back to firmware
- */
-enum mwifiex_status mwifiex_uap_recv_packet(struct mwifiex_private *priv,
-					    struct mwifiex_buffer *mbuf)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct rx_packet_hdr *prx_pkt;
-	struct mwifiex_buffer *newbuf = NULL;
-
-	ENTER();
-
-	prx_pkt = (struct rx_packet_hdr *)((u8 *)mbuf->buffer +
-							mbuf->data_offset);
-
-	DBG_HEXDUMP(MDAT_D, "uap_recv_packet", mbuf->buffer +
-				mbuf->data_offset,
-				min_t(u32, mbuf->data_len, MAX_DATA_DUMP_LEN));
-
-	PRINTM(MDATA, "AMSDU dest %02x:%02x:%02x:%02x:%02x:%02x\n",
-			prx_pkt->eth803_hdr.dest_addr[0],
-			prx_pkt->eth803_hdr.dest_addr[1],
-			prx_pkt->eth803_hdr.dest_addr[2],
-			prx_pkt->eth803_hdr.dest_addr[3],
-			prx_pkt->eth803_hdr.dest_addr[4],
-			prx_pkt->eth803_hdr.dest_addr[5]);
-
-	/* don't do packet forwarding in disconnected state */
-	if (priv->media_connected == false)
-		goto upload;
-	if (prx_pkt->eth803_hdr.dest_addr[0] & 0x01) {
-		/* Multicast pkt */
-		newbuf = mwifiex_alloc_buffer(MWIFIEX_TX_DATA_BUF_SIZE_2K);
-		if (newbuf) {
-			newbuf->bss_index = mbuf->bss_index;
-			newbuf->buf_type = mbuf->buf_type;
-			newbuf->priority = mbuf->priority;
-			newbuf->in_tstamp = mbuf->in_tstamp;
-			newbuf->data_offset = (sizeof(struct mwifiex_uap_txpd) +
-					INTF_HEADER_LEN + HEADER_ALIGNMENT);
-			adapter->pending_bridge_pkts++;
-			newbuf->flags |= MWIFIEX_BUF_FLAG_BRIDGE_BUF;
-
-			/* copy the data */
-			memcpy((u8 *)newbuf->buffer+newbuf->data_offset,
-					mbuf->buffer + mbuf->data_offset,
-					mbuf->data_len);
-			newbuf->data_len = mbuf->data_len;
-			mwifiex_wmm_add_buf_txqueue(adapter, newbuf);
-
-		}
-	} else {
-		if (mwifiex_get_station_entry(priv,
-					prx_pkt->eth803_hdr.dest_addr)) {
-			/* Inter BSS packet */
-			newbuf = mwifiex_alloc_buffer(
-						MWIFIEX_TX_DATA_BUF_SIZE_2K);
-			if (newbuf) {
-				newbuf->bss_index = mbuf->bss_index;
-				newbuf->buf_type = mbuf->buf_type;
-				newbuf->priority = mbuf->priority;
-				newbuf->in_tstamp = mbuf->in_tstamp;
-				newbuf->data_offset =
-						(sizeof(struct mwifiex_uap_txpd)
-						+ INTF_HEADER_LEN
-						+ HEADER_ALIGNMENT);
-				adapter->pending_bridge_pkts++;
-				newbuf->flags |= MWIFIEX_BUF_FLAG_BRIDGE_BUF;
-
-				/* copy the data */
-				memcpy((u8 *)newbuf->buffer+newbuf->data_offset,
-						mbuf->buffer +
-						mbuf->data_offset,
-						mbuf->data_len);
-				newbuf->data_len = mbuf->data_len;
-				mwifiex_wmm_add_buf_txqueue(adapter, newbuf);
-
-			}
-			goto done;
-		}
-	}
-upload:
-	/** send packet to moal */
-	ret = mwifiex_recv_packet(adapter, mbuf);
-
-done:
-	LEAVE();
-	return ret;
-}
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index bf48d2d..abb36f1 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -648,38 +648,6 @@ mwifiex_free_buffer(struct mwifiex_buffer *mbuf)
 }
 
 /*
- * This function will return the pointer to station wapi key in station list
- * table which matches the give mac address
- */
-struct sta_node *mwifiex_get_station_entry(struct mwifiex_private *priv,
-					   u8 *mac)
-{
-	struct sta_node *sta_ptr;
-
-	ENTER();
-
-	if (!mac) {
-		LEAVE();
-		return NULL;
-	}
-	sta_ptr = (struct sta_node *) mwifiex_util_peek_list(&priv->sta_list,
-							     true);
-	if (!sta_ptr) {
-		LEAVE();
-		return NULL;
-	}
-	while (sta_ptr != (struct sta_node *) &priv->sta_list) {
-		if (!memcmp(sta_ptr->mac_addr, mac, MWIFIEX_MAC_ADDR_LENGTH)) {
-			LEAVE();
-			return sta_ptr;
-		}
-		sta_ptr = sta_ptr->pnext;
-	}
-	LEAVE();
-	return NULL;
-}
-
-/*
  * Send packet completion callback handler.
  *
  * This function updates the statistics and frees the buffer SKB.
@@ -1182,33 +1150,9 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 		if (priv) {
 			adapter->hs_activated = false;
 			mwifiex_send_iwevcustom_event(priv,
-					CUS_EVT_HS_DEACTIVATED);
+						      CUS_EVT_HS_DEACTIVATED);
 		}
 		break;
-	case MWIFIEX_EVENT_ID_UAP_FW_BSS_START:
-		memcpy(priv->curr_addr,  event->event_buf + 6, ETH_ALEN);
-		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
-		mwifiex_broadcast_event(priv, event->event_buf,
-							event->event_len);
-		break;
-	case MWIFIEX_EVENT_ID_UAP_FW_BSS_ACTIVE:
-		priv->media_connected = true;
-		if (!netif_carrier_ok(priv->netdev))
-			netif_carrier_on(priv->netdev);
-		if (netif_queue_stopped(priv->netdev))
-			netif_wake_queue(priv->netdev);
-		mwifiex_broadcast_event(priv, event->event_buf,
-							event->event_len);
-		break;
-	case MWIFIEX_EVENT_ID_UAP_FW_BSS_IDLE:
-		priv->media_connected = false;
-		if (!netif_queue_stopped(priv->netdev))
-			netif_stop_queue(priv->netdev);
-		if (netif_carrier_ok(priv->netdev))
-			netif_carrier_off(priv->netdev);
-		mwifiex_broadcast_event(priv, event->event_buf,
-							event->event_len);
-		break;
 	case MWIFIEX_EVENT_ID_DRV_PASSTHU:
 		mwifiex_broadcast_event(priv, event->event_buf,
 					event->event_len);
-- 
1.7.3.2


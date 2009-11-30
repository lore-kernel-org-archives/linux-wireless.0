Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZK3RPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:15:07 -0500
Subject: [PATCH 2/2 v2] mac80211: enable spatial multiplexing powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091130154300.647360542@sipsolutions.net>
References: <20091130153857.963079149@sipsolutions.net>
	 <20091130154300.647360542@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 18:15:12 +0100
Message-ID: <1259601312.32171.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable spatial multiplexing in mac80211 by telling the
driver what to do and, where necessary, sending action
frames to the AP to update the requested SMPS mode.

Also includes a trivial implementation for hwsim that
just logs the requested mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: (thanks to Luis)
 * fix typo "sasociation"
 * rework locking in cfg hooks
 * add missing dereference in reconfig check

 drivers/net/wireless/mac80211_hwsim.c |   22 +++++++-
 include/linux/ieee80211.h             |   25 +++++++++-
 include/net/mac80211.h                |   44 +++++++++++++++++
 net/mac80211/cfg.c                    |   85 ++++++++++++++++++++++++++++++++++
 net/mac80211/driver-trace.h           |    2 
 net/mac80211/ht.c                     |   47 ++++++++++++++++++
 net/mac80211/ieee80211_i.h            |   12 ++++
 net/mac80211/main.c                   |   24 +++++++++
 net/mac80211/mlme.c                   |   63 +++++++++++++++++++++++--
 net/mac80211/status.c                 |   38 +++++++++++++++
 net/mac80211/util.c                   |   74 +++++++++++++++++++++++++++++
 11 files changed, 428 insertions(+), 8 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-11-29 11:33:52.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-29 11:35:06.000000000 +0100
@@ -597,8 +597,10 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
+ * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
  */
 enum ieee80211_conf_changed {
+	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
 	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
 	IEEE80211_CONF_CHANGE_MONITOR		= BIT(3),
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
@@ -636,6 +638,10 @@ enum ieee80211_conf_changed {
  * @short_frame_max_tx_count: Maximum number of transmissions for a "short"
  *    frame, called "dot11ShortRetryLimit" in 802.11, but actually means the
  *    number of transmissions not the number of retries
+ *
+ * @smps_mode: spatial multiplexing powersave mode; note that
+ *	%NL80211_SMPS_STATIC is used when the device is not
+ *	configured for an HT channel
  */
 struct ieee80211_conf {
 	u32 flags;
@@ -648,6 +654,7 @@ struct ieee80211_conf {
 
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
+	enum nl80211_smps_mode smps_mode;
 };
 
 /**
@@ -930,6 +937,16 @@ enum ieee80211_tkip_key_type {
  * @IEEE80211_HW_BEACON_FILTER:
  *	Hardware supports dropping of irrelevant beacon frames to
  *	avoid waking up cpu.
+ *
+ * @IEEE80211_HW_SUPPORTS_STATIC_SMPS:
+ *	Hardware supports static spatial multiplexing powersave,
+ *	ie. can turn off all but one chain even on HT connections
+ *	that should be using more chains.
+ *
+ * @IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS:
+ *	Hardware supports dynamic spatial multiplexing powersave,
+ *	ie. can turn off all but one chain and then wake the rest
+ *	up as required after, for example, rts/cts handshake.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -947,6 +964,8 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_BEACON_FILTER			= 1<<14,
+	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
+	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 };
 
 /**
@@ -1215,6 +1234,31 @@ ieee80211_get_alt_retry_rate(const struc
  */
 
 /**
+ * DOC: Spatial multiplexing power save
+ *
+ * SMPS (Spatial multiplexing power save) is a mechanism to conserve
+ * power in an 802.11n implementation. For details on the mechanism
+ * and rationale, please refer to 802.11 (as amended by 802.11n-2009)
+ * "11.2.3 SM power save".
+ *
+ * The mac80211 implementation is capable of sending action frames
+ * to update the AP about the station's SMPS mode, and will instruct
+ * the driver to enter the specific mode. It will also announce the
+ * requested SMPS mode during the association handshake. Hardware
+ * support for this feature is required, and can be indicated by
+ * hardware flags.
+ *
+ * The default mode will be "automatic", which nl80211/cfg80211
+ * defines to be dynamic SMPS in (regular) powersave, and SMPS
+ * turned off otherwise.
+ *
+ * To support this feature, the driver must set the appropriate
+ * hardware support flags, and handle the SMPS flag to the config()
+ * operation. It will then with this mechanism be instructed to
+ * enter the requested SMPS mode while associated to an HT AP.
+ */
+
+/**
  * DOC: Frame filtering
  *
  * mac80211 requires to see many management frames for proper
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-29 11:33:29.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-29 22:18:08.000000000 +0100
@@ -297,6 +297,8 @@ struct ieee80211_if_managed {
 
 	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
+	enum nl80211_smps_mode req_smps, /* requested smps mode */
+			       ap_smps; /* smps mode AP thinks we're in */
 
 	unsigned long request;
 
@@ -587,6 +589,9 @@ struct ieee80211_local {
 	/* used for uploading changed mc list */
 	struct work_struct reconfig_filter;
 
+	/* used to reconfigure hardware SM PS */
+	struct work_struct recalc_smps;
+
 	/* aggregated multicast list */
 	struct dev_addr_list *mc_list;
 	int mc_count;
@@ -760,6 +765,8 @@ struct ieee80211_local {
 	int user_power_level; /* in dBm */
 	int power_constr_level; /* in dBm */
 
+	enum nl80211_smps_mode smps_mode;
+
 	struct work_struct restart_work;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -983,6 +990,9 @@ void ieee80211_send_bar(struct ieee80211
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code);
+int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
+			       enum nl80211_smps_mode smps, const u8 *da,
+			       const u8 *bssid);
 
 void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
@@ -1093,6 +1103,8 @@ void ieee80211_sta_def_wmm_params(struct
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
+void ieee80211_recalc_smps(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *forsdata);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-29 11:33:00.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-30 18:06:44.000000000 +0100
@@ -1316,6 +1316,62 @@ static int ieee80211_testmode_cmd(struct
 }
 #endif
 
+static int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
+				    enum nl80211_smps_mode smps_mode)
+{
+	const u8 *ap;
+	enum nl80211_smps_mode old_req;
+	int err;
+
+	old_req = sdata->u.mgd.req_smps;
+	sdata->u.mgd.req_smps = smps_mode;
+
+	if (old_req == smps_mode &&
+	    smps_mode != NL80211_SMPS_AUTOMATIC)
+		return 0;
+
+	/*
+	 * If not associated, or current association is not an HT
+	 * association, there's no need to send an action frame.
+	 */
+	if (!sdata->u.mgd.associated ||
+	    sdata->local->oper_channel_type == NL80211_CHAN_NO_HT) {
+		mutex_lock(&sdata->local->iflist_mtx);
+		ieee80211_recalc_smps(sdata->local, sdata);
+		mutex_unlock(&sdata->local->iflist_mtx);
+		return 0;
+	}
+
+	ap = sdata->u.mgd.associated->cbss.bssid;
+
+	if (smps_mode == NL80211_SMPS_AUTOMATIC) {
+		if (sdata->u.mgd.powersave)
+			smps_mode = NL80211_SMPS_DYNAMIC;
+		else
+			smps_mode = NL80211_SMPS_OFF;
+	}
+
+	/* send SM PS frame to AP */
+	err = ieee80211_send_smps_action(sdata, smps_mode,
+					 ap, ap);
+	if (err)
+		sdata->u.mgd.req_smps = old_req;
+
+	return err;
+}
+
+static int ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
+				  enum nl80211_smps_mode smps_mode)
+{
+	int err;
+
+	mutex_lock(&sdata->u.mgd.mtx);
+	err = __ieee80211_request_smps(sdata, smps_mode);
+	mutex_unlock(&sdata->u.mgd.mtx);
+
+	return err;
+}
+
 static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 				    bool enabled, int timeout)
 {
@@ -1333,6 +1389,11 @@ static int ieee80211_set_power_mgmt(stru
 	sdata->u.mgd.powersave = enabled;
 	conf->dynamic_ps_timeout = timeout;
 
+	/* no change, but if automatic follow powersave */
+	mutex_lock(&sdata->u.mgd.mtx);
+	__ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);
+	mutex_unlock(&sdata->u.mgd.mtx);
+
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 
@@ -1383,6 +1444,29 @@ static int ieee80211_set_bitrate_mask(st
 	return err;
 }
 
+static int ieee80211_set_smps(struct wiphy *wiphy, struct net_device *dev,
+			      enum nl80211_smps_mode smps_mode)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS) &&
+	    smps_mode == NL80211_SMPS_STATIC)
+		return -EINVAL;
+
+	/* auto should be dynamic if in PS mode */
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS) &&
+	    (smps_mode == NL80211_SMPS_DYNAMIC ||
+	     smps_mode == NL80211_SMPS_AUTOMATIC))
+		return -EINVAL;
+
+	/* supported only on managed interfaces for now */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	return ieee80211_request_smps(sdata, smps_mode);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1429,4 +1513,5 @@ struct cfg80211_ops mac80211_config_ops 
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
 	.set_power_mgmt = ieee80211_set_power_mgmt,
 	.set_bitrate_mask = ieee80211_set_bitrate_mask,
+	.set_smps = ieee80211_set_smps,
 };
--- wireless-testing.orig/include/linux/ieee80211.h	2009-11-29 11:33:00.000000000 +0100
+++ wireless-testing/include/linux/ieee80211.h	2009-11-29 11:35:06.000000000 +0100
@@ -707,6 +707,10 @@ struct ieee80211_mgmt {
 					u8 action;
 					u8 trans_id[WLAN_SA_QUERY_TR_ID_LEN];
 				} __attribute__ ((packed)) sa_query;
+				struct {
+					u8 action;
+					u8 smps_control;
+				} __attribute__ ((packed)) ht_smps;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -824,6 +828,7 @@ struct ieee80211_ht_cap {
 #define IEEE80211_HT_CAP_LDPC_CODING		0x0001
 #define IEEE80211_HT_CAP_SUP_WIDTH_20_40	0x0002
 #define IEEE80211_HT_CAP_SM_PS			0x000C
+#define		IEEE80211_HT_CAP_SM_PS_SHIFT	2
 #define IEEE80211_HT_CAP_GRN_FLD		0x0010
 #define IEEE80211_HT_CAP_SGI_20			0x0020
 #define IEEE80211_HT_CAP_SGI_40			0x0040
@@ -839,6 +844,7 @@ struct ieee80211_ht_cap {
 /* 802.11n HT capability AMPDU settings (for ampdu_params_info) */
 #define IEEE80211_HT_AMPDU_PARM_FACTOR		0x03
 #define IEEE80211_HT_AMPDU_PARM_DENSITY		0x1C
+#define		IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT	2
 
 /*
  * Maximum length of AMPDU that the STA can receive.
@@ -922,12 +928,17 @@ struct ieee80211_ht_info {
 #define IEEE80211_MAX_AMPDU_BUF 0x40
 
 
-/* Spatial Multiplexing Power Save Modes */
+/* Spatial Multiplexing Power Save Modes (for capability) */
 #define WLAN_HT_CAP_SM_PS_STATIC	0
 #define WLAN_HT_CAP_SM_PS_DYNAMIC	1
 #define WLAN_HT_CAP_SM_PS_INVALID	2
 #define WLAN_HT_CAP_SM_PS_DISABLED	3
 
+/* for SM power control field lower two bits */
+#define WLAN_HT_SMPS_CONTROL_DISABLED	0
+#define WLAN_HT_SMPS_CONTROL_STATIC	1
+#define WLAN_HT_SMPS_CONTROL_DYNAMIC	3
+
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
@@ -1150,6 +1161,18 @@ enum ieee80211_spectrum_mgmt_actioncode 
 	WLAN_ACTION_SPCT_CHL_SWITCH = 4,
 };
 
+/* HT action codes */
+enum ieee80211_ht_actioncode {
+	WLAN_HT_ACTION_NOTIFY_CHANWIDTH = 0,
+	WLAN_HT_ACTION_SMPS = 1,
+	WLAN_HT_ACTION_PSMP = 2,
+	WLAN_HT_ACTION_PCO_PHASE = 3,
+	WLAN_HT_ACTION_CSI = 4,
+	WLAN_HT_ACTION_NONCOMPRESSED_BF = 5,
+	WLAN_HT_ACTION_COMPRESSED_BF = 6,
+	WLAN_HT_ACTION_ASEL_IDX_FEEDBACK = 7,
+};
+
 /* Security key length */
 enum ieee80211_key_len {
 	WLAN_KEY_LEN_WEP40 = 5,
--- wireless-testing.orig/net/mac80211/mlme.c	2009-11-29 11:33:47.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-11-29 22:18:09.000000000 +0100
@@ -398,6 +398,8 @@ static void ieee80211_send_assoc(struct 
 		__le16 tmp;
 		u32 flags = local->hw.conf.channel->flags;
 
+		/* determine capability flags */
+
 		switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 			if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
@@ -413,17 +415,64 @@ static void ieee80211_send_assoc(struct 
 			break;
 		}
 
-		tmp = cpu_to_le16(cap);
-		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
+		/* set SM PS mode properly */
+		cap &= ~IEEE80211_HT_CAP_SM_PS;
+		/* new association always uses requested smps mode */
+		if (ifmgd->req_smps == NL80211_SMPS_AUTOMATIC) {
+			if (ifmgd->powersave)
+				ifmgd->ap_smps = NL80211_SMPS_DYNAMIC;
+			else
+				ifmgd->ap_smps = NL80211_SMPS_OFF;
+		} else
+			ifmgd->ap_smps = ifmgd->req_smps;
+
+		switch (ifmgd->ap_smps) {
+		case NL80211_SMPS_AUTOMATIC:
+		case __NL80211_SMPS_NUM:
+			WARN_ON(1);
+		case NL80211_SMPS_OFF:
+			cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
+				IEEE80211_HT_CAP_SM_PS_SHIFT;
+			break;
+		case NL80211_SMPS_STATIC:
+			cap |= WLAN_HT_CAP_SM_PS_STATIC <<
+				IEEE80211_HT_CAP_SM_PS_SHIFT;
+			break;
+		case NL80211_SMPS_DYNAMIC:
+			cap |= WLAN_HT_CAP_SM_PS_DYNAMIC <<
+				IEEE80211_HT_CAP_SM_PS_SHIFT;
+			break;
+		}
+
+		/* reserve and fill IE */
+
+		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_cap);
 		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+
+		/* capability flags */
+		tmp = cpu_to_le16(cap);
 		memcpy(pos, &tmp, sizeof(u16));
 		pos += sizeof(u16);
-		/* TODO: needs a define here for << 2 */
+
+		/* AMPDU parameters */
 		*pos++ = sband->ht_cap.ampdu_factor |
-			 (sband->ht_cap.ampdu_density << 2);
+			 (sband->ht_cap.ampdu_density <<
+			 	IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+
+		/* MCS set */
 		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+		pos += sizeof(sband->ht_cap.mcs);
+
+		/* extended capabilities */
+		pos += sizeof(__le16);
+
+		/* BF capabilities */
+		pos += sizeof(__le32);
+
+		/* antenna selection */
+		pos += sizeof(u8);
 	}
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -932,6 +981,7 @@ static void ieee80211_set_associated(str
 
 	mutex_lock(&local->iflist_mtx);
 	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_smps(local, sdata);
 	mutex_unlock(&local->iflist_mtx);
 
 	netif_start_queue(sdata->dev);
@@ -2328,6 +2378,11 @@ void ieee80211_sta_setup_sdata(struct ie
 		ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
 
 	mutex_init(&ifmgd->mtx);
+
+	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
+		ifmgd->req_smps = NL80211_SMPS_AUTOMATIC;
+	else
+		ifmgd->req_smps = NL80211_SMPS_OFF;
 }
 
 /* scan finished notification */
--- wireless-testing.orig/net/mac80211/ht.c	2009-11-29 11:33:29.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-11-29 11:35:06.000000000 +0100
@@ -166,3 +166,50 @@ void ieee80211_process_delba(struct ieee
 		spin_unlock_bh(&sta->lock);
 	}
 }
+
+int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
+			       enum nl80211_smps_mode smps, const u8 *da,
+			       const u8 *bssid)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *action_frame;
+
+	/* 27 = header + category + action + smps mode */
+	skb = dev_alloc_skb(27 + local->hw.extra_tx_headroom);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	action_frame = (void *)skb_put(skb, 27);
+	memcpy(action_frame->da, da, ETH_ALEN);
+	memcpy(action_frame->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(action_frame->bssid, bssid, ETH_ALEN);
+	action_frame->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_ACTION);
+	action_frame->u.action.category = WLAN_CATEGORY_HT;
+	action_frame->u.action.u.ht_smps.action = WLAN_HT_ACTION_SMPS;
+	switch (smps) {
+	case NL80211_SMPS_AUTOMATIC:
+	case __NL80211_SMPS_NUM:
+		WARN_ON(1);
+	case NL80211_SMPS_OFF:
+		action_frame->u.action.u.ht_smps.smps_control =
+				WLAN_HT_SMPS_CONTROL_DISABLED;
+		break;
+	case NL80211_SMPS_STATIC:
+		action_frame->u.action.u.ht_smps.smps_control =
+				WLAN_HT_SMPS_CONTROL_STATIC;
+		break;
+	case NL80211_SMPS_DYNAMIC:
+		action_frame->u.action.u.ht_smps.smps_control =
+				WLAN_HT_SMPS_CONTROL_DYNAMIC;
+		break;
+	}
+
+	/* we'll do more on status of this frame */
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+	ieee80211_tx_skb(sdata, skb);
+
+	return 0;
+}
--- wireless-testing.orig/net/mac80211/status.c	2009-11-29 11:33:00.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2009-11-29 11:35:06.000000000 +0100
@@ -134,6 +134,40 @@ static void ieee80211_handle_filtered_fr
 	dev_kfree_skb(skb);
 }
 
+static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *) skb->data;
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	if (ieee80211_is_action(mgmt->frame_control) &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    mgmt->u.action.category == WLAN_CATEGORY_HT &&
+	    mgmt->u.action.u.ht_smps.action == WLAN_HT_ACTION_SMPS) {
+		/*
+		 * This update looks racy, but isn't -- if we come
+		 * here we've definitely got a station that we're
+		 * talking to, and on a managed interface that can
+		 * only be the AP. And the only other place updating
+		 * this variable is before we're associated.
+		 */
+		switch (mgmt->u.action.u.ht_smps.smps_control) {
+		case WLAN_HT_SMPS_CONTROL_DYNAMIC:
+			sta->sdata->u.mgd.ap_smps = NL80211_SMPS_DYNAMIC;
+			break;
+		case WLAN_HT_SMPS_CONTROL_STATIC:
+			sta->sdata->u.mgd.ap_smps = NL80211_SMPS_STATIC;
+			break;
+		case WLAN_HT_SMPS_CONTROL_DISABLED:
+		default: /* shouldn't happen since we don't send that */
+			sta->sdata->u.mgd.ap_smps = NL80211_SMPS_OFF;
+			break;
+		}
+
+		ieee80211_queue_work(&local->hw, &local->recalc_smps);
+	}
+}
+
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
@@ -209,6 +243,10 @@ void ieee80211_tx_status(struct ieee8021
 		rate_control_tx_status(local, sband, sta, skb);
 		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
 			ieee80211s_update_metric(local, sta, skb);
+
+		if (!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+		    (info->flags & IEEE80211_TX_STAT_ACK))
+			ieee80211_frame_acked(sta, skb);
 	}
 
 	rcu_read_unlock();
--- wireless-testing.orig/net/mac80211/main.c	2009-11-29 11:33:00.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-29 22:18:07.000000000 +0100
@@ -113,6 +113,18 @@ int ieee80211_hw_config(struct ieee80211
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
+	if (!conf_is_ht(&local->hw.conf)) {
+		/*
+		 * mac80211.h documents that this is only valid
+		 * when the channel is set to an HT type, and
+		 * that otherwise STATIC is used.
+		 */
+		local->hw.conf.smps_mode = NL80211_SMPS_STATIC;
+	} else if (local->hw.conf.smps_mode != local->smps_mode) {
+		local->hw.conf.smps_mode = local->smps_mode;
+		changed |= IEEE80211_CONF_CHANGE_SMPS;
+	}
+
 	if (scan_chan)
 		power = chan->max_power;
 	else
@@ -297,6 +309,16 @@ void ieee80211_restart_hw(struct ieee802
 }
 EXPORT_SYMBOL(ieee80211_restart_hw);
 
+static void ieee80211_recalc_smps_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, recalc_smps);
+
+	mutex_lock(&local->iflist_mtx);
+	ieee80211_recalc_smps(local, NULL);
+	mutex_unlock(&local->iflist_mtx);
+}
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -370,6 +392,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
 
 	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
+	INIT_WORK(&local->recalc_smps, ieee80211_recalc_smps_work);
+	local->smps_mode = NL80211_SMPS_OFF;
 
 	INIT_WORK(&local->dynamic_ps_enable_work,
 		  ieee80211_dynamic_ps_enable_work);
--- wireless-testing.orig/net/mac80211/util.c	2009-11-29 11:33:00.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-11-30 18:07:13.000000000 +0100
@@ -1170,3 +1170,77 @@ int ieee80211_reconfig(struct ieee80211_
 	return 0;
 }
 
+static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
+			  enum nl80211_smps_mode *smps_mode)
+{
+	if (ifmgd->associated) {
+		*smps_mode = ifmgd->ap_smps;
+
+		if (*smps_mode == NL80211_SMPS_AUTOMATIC) {
+			if (ifmgd->powersave)
+				*smps_mode = NL80211_SMPS_DYNAMIC;
+			else
+				*smps_mode = NL80211_SMPS_OFF;
+		}
+
+		return 1;
+	}
+
+	return 0;
+}
+
+/* must hold iflist_mtx */
+void ieee80211_recalc_smps(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *forsdata)
+{
+	struct ieee80211_sub_if_data *sdata;
+	enum nl80211_smps_mode smps_mode = NL80211_SMPS_OFF;
+	int count = 0;
+
+	if (forsdata)
+		WARN_ON(!mutex_is_locked(&forsdata->u.mgd.mtx));
+
+	WARN_ON(!mutex_is_locked(&local->iflist_mtx));
+
+	/*
+	 * This function could be improved to handle multiple
+	 * interfaces better, but right now it makes any
+	 * non-station interfaces force SM PS to be turned
+	 * off. If there are multiple station interfaces it
+	 * could also use the best possible mode, e.g. if
+	 * one is in static and the other in dynamic then
+	 * dynamic is ok.
+	 */
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			goto set;
+		if (sdata != forsdata) {
+			/*
+			 * This nested is ok -- we are holding the iflist_mtx
+			 * so can't get here twice or so. But it's required
+			 * since normally we acquire it first and then the
+			 * iflist_mtx.
+			 */
+			mutex_lock_nested(&sdata->u.mgd.mtx, SINGLE_DEPTH_NESTING);
+			count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
+			mutex_unlock(&sdata->u.mgd.mtx);
+		} else
+			count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
+
+		if (count > 1) {
+			smps_mode = NL80211_SMPS_OFF;
+			break;
+		}
+	}
+
+	if (smps_mode == local->smps_mode)
+		return;
+
+ set:
+	local->smps_mode = smps_mode;
+ 	/* changed flag is auto-detected for this */
+	ieee80211_hw_config(local, 0);
+}
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-11-29 11:33:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-11-29 11:35:06.000000000 +0100
@@ -619,12 +619,26 @@ static int mac80211_hwsim_config(struct 
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
+	static const char *chantypes[4] = {
+		[NL80211_CHAN_NO_HT] = "noht",
+		[NL80211_CHAN_HT20] = "ht20",
+		[NL80211_CHAN_HT40MINUS] = "ht40-",
+		[NL80211_CHAN_HT40PLUS] = "ht40+",
+	};
+	static const char *smps_modes[__NL80211_SMPS_NUM] = {
+		[NL80211_SMPS_AUTOMATIC] = "auto/invalid",
+		[NL80211_SMPS_OFF] = "off",
+		[NL80211_SMPS_STATIC] = "static",
+		[NL80211_SMPS_DYNAMIC] = "dynamic",
+	};
 
-	printk(KERN_DEBUG "%s:%s (freq=%d idle=%d ps=%d)\n",
+	printk(KERN_DEBUG "%s:%s (freq=%d/%s idle=%d ps=%d smps=%s)\n",
 	       wiphy_name(hw->wiphy), __func__,
 	       conf->channel->center_freq,
+	       chantypes[conf->channel_type],
 	       !!(conf->flags & IEEE80211_CONF_IDLE),
-	       !!(conf->flags & IEEE80211_CONF_PS));
+	       !!(conf->flags & IEEE80211_CONF_PS),
+	       smps_modes[conf->smps_mode]);
 
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
@@ -1121,7 +1135,9 @@ static int __init init_mac80211_hwsim(vo
 			BIT(NL80211_IFTYPE_MESH_POINT);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
-			    IEEE80211_HW_SIGNAL_DBM;
+			    IEEE80211_HW_SIGNAL_DBM |
+			    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
+			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS;
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
--- wireless-testing.orig/net/mac80211/driver-trace.h	2009-11-29 22:18:24.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2009-11-29 22:19:04.000000000 +0100
@@ -140,6 +140,7 @@ TRACE_EVENT(drv_config,
 		__field(u8, short_frame_max_tx_count)
 		__field(int, center_freq)
 		__field(int, channel_type)
+		__field(int, smps)
 	),
 
 	TP_fast_assign(
@@ -155,6 +156,7 @@ TRACE_EVENT(drv_config,
 		__entry->short_frame_max_tx_count = local->hw.conf.short_frame_max_tx_count;
 		__entry->center_freq = local->hw.conf.channel->center_freq;
 		__entry->channel_type = local->hw.conf.channel_type;
+		__entry->smps = local->hw.conf.smps_mode;
 	),
 
 	TP_printk(



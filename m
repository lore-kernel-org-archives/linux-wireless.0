Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48185 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1HQHpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 03:45:05 -0400
Received: by wwf5 with SMTP id 5so730248wwf.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 00:45:04 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 23/40] wl12xx: re-enable block ack session support
Date: Wed, 17 Aug 2011 10:45:49 +0300
Message-Id: <1313567149-26475-2-git-send-email-eliad@wizery.com> (sfid-20110817_094510_138341_0ADF3321)
In-Reply-To: <1313567149-26475-1-git-send-email-eliad@wizery.com>
References: <1313567149-26475-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Incorporate interface changes for HT support.

Add ba_bitmap field to the wl1271_link struct, to indicate
activate RX BA sessions (for AP mode).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v3: don't change tx_ba_win_size conf value (64) 

 drivers/net/wireless/wl12xx/acx.c    |   66 +++++----------
 drivers/net/wireless/wl12xx/acx.h    |   82 ++++++-------------
 drivers/net/wireless/wl12xx/cmd.h    |    1 +
 drivers/net/wireless/wl12xx/conf.h   |    9 ++-
 drivers/net/wireless/wl12xx/init.c   |   37 +++------
 drivers/net/wireless/wl12xx/main.c   |  146 ++++++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ++
 7 files changed, 177 insertions(+), 170 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index d783fce..ecbceb6 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1320,25 +1320,21 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	/* Allow HT Operation ? */
 	if (allow_ht_operation) {
-		ht_capabilites =
-			WL1271_ACX_FW_CAP_HT_OPERATION;
-		if (ht_cap->cap & IEEE80211_HT_CAP_GRN_FLD)
-			ht_capabilites |=
-				WL1271_ACX_FW_CAP_GREENFIELD_FRAME_FORMAT;
-		if (ht_cap->cap & IEEE80211_HT_CAP_SGI_20)
-			ht_capabilites |=
-				WL1271_ACX_FW_CAP_SHORT_GI_FOR_20MHZ_PACKETS;
-		if (ht_cap->cap & IEEE80211_HT_CAP_LSIG_TXOP_PROT)
-			ht_capabilites |=
-				WL1271_ACX_FW_CAP_LSIG_TXOP_PROTECTION;
+		/* no need to translate capabilities - use the spec values */
+		ht_capabilites = ht_cap->cap;
+
+		/*
+		 * this bit is not employed by the spec but only by FW to
+		 * indicate peer HT support
+		 */
+		ht_capabilites |= WL12XX_HT_CAP_HT_OPERATION;
 
 		/* get data from A-MPDU parameters field */
 		acx->ampdu_max_length = ht_cap->ampdu_factor;
 		acx->ampdu_min_spacing = ht_cap->ampdu_density;
 	}
 
@@ -1389,82 +1385,64 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 out:
 	kfree(acx);
 	return ret;
 }
 
 /* Configure BA session initiator/receiver parameters setting in the FW. */
-int wl1271_acx_set_ba_session(struct wl1271 *wl,
-			       enum ieee80211_back_parties direction,
-			       u8 tid_index, u8 policy)
+int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl)
 {
-	struct wl1271_acx_ba_session_policy *acx;
+	struct wl1271_acx_ba_initiator_policy *acx;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx ba session setting");
+	wl1271_debug(DEBUG_ACX, "acx ba initiator policy");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	/* ANY role */
-	acx->role_id = 0xff;
-	acx->tid = tid_index;
-	acx->enable = policy;
-	acx->ba_direction = direction;
-
-	switch (direction) {
-	case WLAN_BACK_INITIATOR:
-		acx->win_size = wl->conf.ht.tx_ba_win_size;
-		acx->inactivity_timeout = wl->conf.ht.inactivity_timeout;
-		break;
-	case WLAN_BACK_RECIPIENT:
-		acx->win_size = RX_BA_WIN_SIZE;
-		acx->inactivity_timeout = 0;
-		break;
-	default:
-		wl1271_error("Incorrect acx command id=%x\n", direction);
-		ret = -EINVAL;
-		goto out;
-	}
+	/* set for the current role */
+	acx->role_id = wl->role_id;
+	acx->tid_bitmap = wl->conf.ht.tx_ba_tid_bitmap;
+	acx->win_size = wl->conf.ht.tx_ba_win_size;
+	acx->inactivity_timeout = wl->conf.ht.inactivity_timeout;
 
 	ret = wl1271_cmd_configure(wl,
-				   ACX_BA_SESSION_POLICY_CFG,
+				   ACX_BA_SESSION_INIT_POLICY,
 				   acx,
 				   sizeof(*acx));
 	if (ret < 0) {
-		wl1271_warning("acx ba session setting failed: %d", ret);
+		wl1271_warning("acx ba initiator policy failed: %d", ret);
 		goto out;
 	}
 
 out:
 	kfree(acx);
 	return ret;
 }
 
 /* setup BA session receiver setting in the FW. */
-int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
-					bool enable)
+int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
+				       u16 ssn, bool enable, u8 peer_hlid)
 {
 	struct wl1271_acx_ba_receiver_setup *acx;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "acx ba receiver session setting");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	/* Single link for now */
-	acx->link_id = 1;
+	acx->hlid = peer_hlid;
 	acx->tid = tid_index;
 	acx->enable = enable;
-	acx->win_size = 0;
+	acx->win_size = wl->conf.ht.rx_ba_win_size;
 	acx->ssn = ssn;
 
 	ret = wl1271_cmd_configure(wl, ACX_BA_SESSION_RX_SETUP, acx,
 				   sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("acx ba receiver session failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 5b3fabd..82c9271 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -896,33 +896,25 @@ struct wl1271_acx_rssi_snr_avg_weights {
 	u8 rssi_beacon;
 	u8 rssi_data;
 	u8 snr_beacon;
 	u8 snr_data;
 };
 
+
+/* special capability bit (not employed by the 802.11n spec) */
+#define WL12XX_HT_CAP_HT_OPERATION BIT(16)
+
 /*
  * ACX_PEER_HT_CAP
  * Configure HT capabilities - declare the capabilities of the peer
  * we are connected to.
  */
 struct wl1271_acx_ht_capabilities {
 	struct acx_header header;
 
-	/*
-	 * bit 0 - Allow HT Operation
-	 * bit 1 - Allow Greenfield format in TX
-	 * bit 2 - Allow Short GI in TX
-	 * bit 3 - Allow L-SIG TXOP Protection in TX
-	 * bit 4 - Allow HT Control fields in TX.
-	 *         Note, driver will still leave space for HT control in packets
-	 *         regardless of the value of this field. FW will be responsible
-	 *         to drop the HT field from any frame when this Bit set to 0.
-	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
-	 *         Exact policy setting for this feature is TBD.
-	 *         Note, this bit can only be set to 1 if bit 3 is set to 1.
-	 */
+	/* bitmask of capability bits supported by the peer */
 	__le32 ht_capabilites;
 
 	/* Indicates to which link these capabilities apply. */
 	u8 hlid;
 
 	/*
@@ -934,21 +926,12 @@ struct wl1271_acx_ht_capabilities {
 	/* This is the minimal spacing required when sending A-MPDUs to the AP*/
 	u8 ampdu_min_spacing;
 
 	u8 padding;
 } __packed;
 
-/* HT Capabilites Fw Bit Mask Mapping */
-#define WL1271_ACX_FW_CAP_HT_OPERATION                 BIT(0)
-#define WL1271_ACX_FW_CAP_GREENFIELD_FRAME_FORMAT      BIT(1)
-#define WL1271_ACX_FW_CAP_SHORT_GI_FOR_20MHZ_PACKETS   BIT(2)
-#define WL1271_ACX_FW_CAP_LSIG_TXOP_PROTECTION         BIT(3)
-#define WL1271_ACX_FW_CAP_HT_CONTROL_FIELDS            BIT(4)
-#define WL1271_ACX_FW_CAP_RD_INITIATION                BIT(5)
-
-
 /*
  * ACX_HT_BSS_OPERATION
  * Configure HT capabilities - AP rules for behavior in the BSS.
  */
 struct wl1271_acx_ht_information {
 	struct acx_header header;
@@ -976,63 +959,54 @@ struct wl1271_acx_ht_information {
 	 */
 	u8 dual_cts_protection;
 
 	u8 padding[2];
 } __packed;
 
-#define RX_BA_WIN_SIZE 8
+#define RX_BA_MAX_SESSIONS 2
 
-struct wl1271_acx_ba_session_policy {
+struct wl1271_acx_ba_initiator_policy {
 	struct acx_header header;
-	/*
-	 * Specifies role Id, Range 0-7, 0xFF means ANY role.
-	 * Future use. For now this field is irrelevant
-	 */
+
+	/* Specifies role Id, Range 0-7, 0xFF means ANY role. */
 	u8 role_id;
+
 	/*
-	 * Specifies Link Id, Range 0-31, 0xFF means ANY  Link Id.
-	 * Not applicable if Role Id is set to ANY.
+	 * Per TID setting for allowing TX BA. Set a bit to 1 to allow
+	 * TX BA sessions for the corresponding TID.
 	 */
-	u8 link_id;
-
-	u8 tid;
-
-	u8 enable;
+	u8 tid_bitmap;
 
 	/* Windows size in number of packets */
-	u16 win_size;
+	u8 win_size;
 
-	/*
-	 * As initiator inactivity timeout in time units(TU) of 1024us.
-	 * As receiver reserved
-	 */
-	u16 inactivity_timeout;
+	u8 padding1[1];
 
-	/* Initiator = 1/Receiver = 0 */
-	u8 ba_direction;
+	/* As initiator inactivity timeout in time units(TU) of 1024us */
+	u16 inactivity_timeout;
 
-	u8 padding[3];
+	u8 padding[2];
 } __packed;
 
 struct wl1271_acx_ba_receiver_setup {
 	struct acx_header header;
 
-	/* Specifies Link Id, Range 0-31, 0xFF means ANY  Link Id */
-	u8 link_id;
+	/* Specifies link id, range 0-31 */
+	u8 hlid;
 
 	u8 tid;
 
 	u8 enable;
 
-	u8 padding[1];
-
 	/* Windows size in number of packets */
-	u16 win_size;
+	u8 win_size;
 
 	/* BA session starting sequence number.  RANGE 0-FFF */
 	u16 ssn;
+
+	u8 padding[2];
 } __packed;
 
 struct wl1271_acx_fw_tsf_information {
 	struct acx_header header;
 
 	__le32 current_tsf_high;
@@ -1215,13 +1189,13 @@ enum {
 	ACX_FRAG_CFG                = 0x004F,
 	ACX_BET_ENABLE              = 0x0050,
 	ACX_RSSI_SNR_TRIGGER        = 0x0051,
 	ACX_RSSI_SNR_WEIGHTS        = 0x0052,
 	ACX_KEEP_ALIVE_MODE         = 0x0053,
 	ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
-	ACX_BA_SESSION_POLICY_CFG   = 0x0055,
+	ACX_BA_SESSION_INIT_POLICY  = 0x0055,
 	ACX_BA_SESSION_RX_SETUP     = 0x0056,
 	ACX_PEER_HT_CAP             = 0x0057,
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
 	ACX_BURST_MODE              = 0x005C,
 	ACX_SET_RATE_MGMT_PARAMS    = 0x005D,
@@ -1294,17 +1268,15 @@ int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
 int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl);
 int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    struct ieee80211_sta_ht_cap *ht_cap,
 				    bool allow_ht_operation);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
-int wl1271_acx_set_ba_session(struct wl1271 *wl,
-			      enum ieee80211_back_parties direction,
-			      u8 tid_index, u8 policy);
-int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
-				       bool enable);
+int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl);
+int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
+				       u16 ssn, bool enable, u8 peer_hlid);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
 int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 5cf92e2..8b32a57 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -205,12 +205,13 @@ enum {
 	CMD_STATUS_STA_TABLE_FULL		= 17,
 	CMD_STATUS_RADIO_ERROR		= 18,
 	CMD_STATUS_WRONG_NESTING		= 19,
 	CMD_STATUS_TIMEOUT		= 21, /* Driver internal use.*/
 	CMD_STATUS_FW_RESET		= 22, /* Driver internal use.*/
 	CMD_STATUS_TEMPLATE_OOM		= 23,
+	CMD_STATUS_NO_RX_BA_SESSION	= 24,
 	MAX_COMMAND_STATUS		= 0xff
 };
 
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
 
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index a7c1478..76b5c62 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -554,12 +554,15 @@ struct conf_tx_ac_category {
 	 */
 	u16 tx_op_limit;
 };
 
 #define CONF_TX_MAX_TID_COUNT 8
 
+/* Allow TX BA on all TIDs but 6,7. These are currently reserved in the FW */
+#define CONF_TX_BA_ENABLED_TID_BITMAP 0x3F
+
 enum {
 	CONF_CHANNEL_TYPE_DCF = 0,   /* DC/LEGACY*/
 	CONF_CHANNEL_TYPE_EDCF = 1,  /* EDCA*/
 	CONF_CHANNEL_TYPE_HCCA = 2,  /* HCCA*/
 };
 
@@ -1092,14 +1095,18 @@ struct conf_rf_settings {
 	 * Range: s8
 	 */
 	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
 };
 
 struct conf_ht_setting {
-	u16 tx_ba_win_size;
+	u8 rx_ba_win_size;
+	u8 tx_ba_win_size;
 	u16 inactivity_timeout;
+
+	/* bitmap of enabled TIDs for TX BA sessions */
+	u8 tx_ba_tid_bitmap;
 };
 
 struct conf_memory_settings {
 	/* Number of stations supported in IBSS mode */
 	u8 num_stations;
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 47d87aa..a374c21 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -526,47 +526,30 @@ int wl1271_init_ap_rates(struct wl1271 *wl)
 			return ret;
 	}
 
 	return 0;
 }
 
-static void wl1271_check_ba_support(struct wl1271 *wl)
-{
-	/* validate FW cose ver x.x.x.50-60.x */
-	if ((wl->chip.fw_ver[3] >= WL12XX_BA_SUPPORT_FW_COST_VER2_START) &&
-	    (wl->chip.fw_ver[3] < WL12XX_BA_SUPPORT_FW_COST_VER2_END)) {
-		wl->ba_support = true;
-		return;
-	}
-
-	wl->ba_support = false;
-}
-
 static int wl1271_set_ba_policies(struct wl1271 *wl)
 {
-	u8 tid_index;
-	int ret = 0;
-
 	/* Reset the BA RX indicators */
 	wl->ba_rx_bitmap = 0;
 	wl->ba_allowed = true;
+	wl->ba_rx_session_count = 0;
 
-	/* validate that FW support BA */
-	wl1271_check_ba_support(wl);
+	/* BA is supported in STA/AP modes */
+	if (wl->bss_type != BSS_TYPE_AP_BSS &&
+	    wl->bss_type != BSS_TYPE_STA_BSS) {
+		wl->ba_support = false;
+		return 0;
+	}
 
-	if (wl->ba_support)
-		/* 802.11n initiator BA session setting */
-		for (tid_index = 0; tid_index < CONF_TX_MAX_TID_COUNT;
-		     ++tid_index) {
-			ret = wl1271_acx_set_ba_session(wl, WLAN_BACK_INITIATOR,
-							tid_index, true);
-			if (ret < 0)
-				break;
-		}
+	wl->ba_support = true;
 
-	return ret;
+	/* 802.11n initiator BA session setting */
+	return wl12xx_acx_set_ba_initiator_policy(wl);
 }
 
 int wl1271_chip_specific_init(struct wl1271 *wl)
 {
 	int ret = 0;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ea150b5..934f573 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -283,14 +283,16 @@ static struct conf_drv_settings default_conf = {
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		},
 	},
 	.ht = {
+		.rx_ba_win_size = 8,
 		.tx_ba_win_size = 64,
 		.inactivity_timeout = 10000,
+		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
 	},
 	.mem_wl127x = {
 		.num_stations                 = 1,
 		.ssid_profiles                = 1,
 		.rx_block_num                 = 70,
 		.tx_min_block_num             = 40,
@@ -3188,54 +3190,28 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 
 			/* Need to update the BSSID (for filtering etc) */
 			do_join = true;
 		}
 	}
 
-	rcu_read_lock();
-	sta = ieee80211_find_sta(vif, bss_conf->bssid);
-	if (sta)  {
+	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_HT)) {
+		rcu_read_lock();
+		sta = ieee80211_find_sta(vif, bss_conf->bssid);
+		if (!sta)
+			goto sta_not_found;
+
 		/* save the supp_rates of the ap */
 		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
 		if (sta->ht_cap.ht_supported)
 			sta_rate_set |=
 			    (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
 		sta_ht_cap = sta->ht_cap;
 		sta_exists = true;
-	}
-	rcu_read_unlock();
 
-	if (sta_exists) {
-		/* handle new association with HT and HT information change */
-		if ((changed & BSS_CHANGED_HT) &&
-		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
-							     true);
-			if (ret < 0) {
-				wl1271_warning("Set ht cap true failed %d",
-					       ret);
-				goto out;
-			}
-			ret = wl1271_acx_set_ht_information(wl,
-						bss_conf->ht_operation_mode);
-			if (ret < 0) {
-				wl1271_warning("Set ht information failed %d",
-					       ret);
-				goto out;
-			}
-		}
-		/* handle new association without HT and disassociation */
-		else if (changed & BSS_CHANGED_ASSOC) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
-							     false);
-			if (ret < 0) {
-				wl1271_warning("Set ht cap false failed %d",
-					       ret);
-				goto out;
-			}
-		}
+sta_not_found:
+		rcu_read_unlock();
 	}
 
 	if ((changed & BSS_CHANGED_ASSOC)) {
 		if (bss_conf->assoc) {
 			u32 rates;
 			int ieoffset;
@@ -3437,12 +3413,47 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			ret = wl12xx_cmd_role_stop_dev(wl);
 			if (ret < 0)
 				goto out;
 		}
 	}
 
+	/* Handle new association with HT. Do this only after join. */
+	if (sta_exists) {
+		if ((changed & BSS_CHANGED_HT) &&
+		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
+							     true);
+			if (ret < 0) {
+				wl1271_warning("Set ht cap true failed %d",
+					       ret);
+				goto out;
+			}
+		}
+		/* handle new association without HT and disassociation */
+		else if (changed & BSS_CHANGED_ASSOC) {
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
+							     false);
+			if (ret < 0) {
+				wl1271_warning("Set ht cap false failed %d",
+					       ret);
+				goto out;
+			}
+		}
+	}
+
+	/* Handle HT information change. Only after join. */
+	if (sta_exists && (changed & BSS_CHANGED_HT) &&
+	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+		ret = wl1271_acx_set_ht_information(wl,
+					bss_conf->ht_operation_mode);
+		if (ret < 0) {
+			wl1271_warning("Set ht information failed %d", ret);
+			goto out;
+		}
+	}
+
 out:
 	return;
 }
 
 static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
@@ -3620,12 +3631,13 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 
 	if (WARN_ON(!test_bit(id, wl->ap_hlid_map)))
 		return;
 
 	__clear_bit(id, wl->ap_hlid_map);
 	memset(wl->links[hlid].addr, 0, ETH_ALEN);
+	wl->links[hlid].ba_bitmap = 0;
 	wl1271_tx_reset_link_queues(wl, hlid);
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 }
 
 bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid)
@@ -3722,43 +3734,91 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 				  enum ieee80211_ampdu_mlme_action action,
 				  struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 				  u8 buf_size)
 {
 	struct wl1271 *wl = hw->priv;
 	int ret;
+	u8 hlid, *ba_bitmap;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 ampdu action %d tid %d", action,
+		     tid);
+
+	/* sanity check - the fields in FW are only 8bits wide */
+	if (WARN_ON(tid > 0xFF))
+		return -ENOTSUPP;
 
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF)) {
 		ret = -EAGAIN;
 		goto out;
 	}
 
+	if (wl->bss_type == BSS_TYPE_STA_BSS) {
+		hlid = wl->sta_hlid;
+		ba_bitmap = &wl->ba_rx_bitmap;
+	} else if (wl->bss_type == BSS_TYPE_AP_BSS) {
+		struct wl1271_station *wl_sta;
+
+		wl_sta = (struct wl1271_station *)sta->drv_priv;
+		hlid = wl_sta->hlid;
+		ba_bitmap = &wl->links[hlid].ba_bitmap;
+	} else {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 ampdu: Rx tid %d action %d",
 		     tid, action);
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if ((wl->ba_support) && (wl->ba_allowed)) {
-			ret = wl1271_acx_set_ba_receiver_session(wl, tid, *ssn,
-								 true);
-			if (!ret)
-				wl->ba_rx_bitmap |= BIT(tid);
-		} else {
+		if (!wl->ba_support || !wl->ba_allowed) {
 			ret = -ENOTSUPP;
+			break;
+		}
+
+		if (wl->ba_rx_session_count >= RX_BA_MAX_SESSIONS) {
+			ret = -EBUSY;
+			wl1271_error("exceeded max RX BA sessions");
+			break;
+		}
+
+		if (*ba_bitmap & BIT(tid)) {
+			ret = -EINVAL;
+			wl1271_error("cannot enable RX BA session on active "
+				     "tid: %d", tid);
+			break;
+		}
+
+		ret = wl12xx_acx_set_ba_receiver_session(wl, tid, *ssn, true,
+							 hlid);
+		if (!ret) {
+			*ba_bitmap |= BIT(tid);
+			wl->ba_rx_session_count++;
 		}
 		break;
 
 	case IEEE80211_AMPDU_RX_STOP:
-		ret = wl1271_acx_set_ba_receiver_session(wl, tid, 0, false);
-		if (!ret)
-			wl->ba_rx_bitmap &= ~BIT(tid);
+		if (!(*ba_bitmap & BIT(tid))) {
+			ret = -EINVAL;
+			wl1271_error("no active RX BA session on tid: %d",
+				     tid);
+			break;
+		}
+
+		ret = wl12xx_acx_set_ba_receiver_session(wl, tid, 0, false,
+							 hlid);
+		if (!ret) {
+			*ba_bitmap &= ~BIT(tid);
+			wl->ba_rx_session_count--;
+		}
 		break;
 
 	/*
 	 * The BA initiator session management in FW independently.
 	 * Falling break here on purpose for all TX APDU commands.
 	 */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1313dc5..487c3c7 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -352,12 +352,15 @@ struct wl1271_link {
 
 	/* accounting for allocated / available TX blocks in FW */
 	u8 allocated_blks;
 	u8 prev_freed_blks;
 
 	u8 addr[ETH_ALEN];
+
+	/* bitmap of TIDs where RX BA sessions are active for this link */
+	u8 ba_bitmap;
 };
 
 struct wl1271 {
 	struct platform_device *plat_dev;
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
@@ -606,12 +609,15 @@ struct wl1271 {
 
 	/* Quirks of specific hardware revisions */
 	unsigned int quirks;
 
 	/* Platform limitations */
 	unsigned int platform_quirks;
+
+	/* number of currently active RX BA sessions */
+	int ba_rx_session_count;
 };
 
 struct wl1271_station {
 	u8 hlid;
 };
 
-- 
1.7.6.401.g6a319


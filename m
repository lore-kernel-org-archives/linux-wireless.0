Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3750 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760215Ab3BHO4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/27] brcmfmac: P2P action frame tx.
Date: Fri, 8 Feb 2013 15:53:49 +0100
Message-ID: <1360335242-12608-15-git-send-email-arend@broadcom.com> (sfid-20130208_163817_163049_03EFD491)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

With this patch it is possible to send action frames.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   19 ++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  294 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |   10 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   41 ++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    1 +
 5 files changed, 361 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 2c4ca59..0f2c83b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -20,6 +20,10 @@
 
 #include <linux/if_ether.h>
 
+
+#define BRCMF_FIL_ACTION_FRAME_SIZE	1800
+
+
 enum brcmf_fil_p2p_if_types {
 	BRCMF_FIL_P2P_IF_CLIENT,
 	BRCMF_FIL_P2P_IF_GO,
@@ -39,6 +43,21 @@ struct brcmf_fil_chan_info_le {
 	__le32 scan_channel;
 };
 
+struct brcmf_fil_action_frame_le {
+	u8	da[ETH_ALEN];
+	__le16	len;
+	__le32	packet_id;
+	u8	data[BRCMF_FIL_ACTION_FRAME_SIZE];
+};
+
+struct brcmf_fil_af_params_le {
+	__le32					channel;
+	__le32					dwell_time;
+	u8					bssid[ETH_ALEN];
+	u8					pad[2];
+	struct brcmf_fil_action_frame_le	action_frame;
+};
+
 struct brcmf_fil_bss_enable_le {
 	__le32 bsscfg_idx;
 	__le32 enable;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index e5b1fb9..0c42910 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -55,6 +55,21 @@
 #define P2P_OUI			"\x50\x6F\x9A"	/* P2P OUI */
 #define P2P_OUI_LEN		3		/* P2P OUI length */
 
+/* Action Frame Constants */
+#define DOT11_ACTION_HDR_LEN	2	/* action frame category + action */
+#define DOT11_ACTION_CAT_OFF	0	/* category offset */
+#define DOT11_ACTION_ACT_OFF	1	/* action offset */
+
+#define P2P_AF_DWELL_TIME		200
+#define P2P_AF_MIN_DWELL_TIME		100
+#define P2P_AF_MED_DWELL_TIME		400
+#define P2P_AF_LONG_DWELL_TIME		1000
+#define P2P_AF_TX_MAX_RETRY		5
+#define P2P_AF_MAX_WAIT_TIME		2000
+#define P2P_INVALID_CHANNEL		-1
+#define P2P_CHANNEL_SYNC_RETRY		5
+#define P2P_AF_FRM_SCAN_MAX_WAIT	1500
+
 /* WiFi P2P Public Action Frame OUI Subtypes */
 #define P2P_PAF_GON_REQ		0	/* Group Owner Negotiation Req */
 #define P2P_PAF_GON_RSP		1	/* Group Owner Negotiation Rsp */
@@ -178,6 +193,17 @@ struct brcmf_p2psd_gas_pub_act_frame {
 	u8	query_data[1];
 };
 
+/**
+ * struct brcmf_config_af_params - Action Frame Parameters for tx.
+ *
+ * @max_tx_retry: max tx retry count if tx no ack.
+ * @mpc_onoff: To make sure to send successfully action frame, we have to
+ *             turn off mpc  0: off, 1: on,  (-1): do nothing
+ */
+struct brcmf_config_af_params {
+	s32 max_tx_retry;
+	s32 mpc_onoff;
+};
 
 /**
  * brcmf_p2p_is_pub_action() - true if p2p public type frame.
@@ -590,8 +616,6 @@ static s32 brcmf_p2p_deinit_discovery(struct brcmf_p2p_info *p2p)
  * brcmf_p2p_enable_discovery() - initialize and configure discovery.
  *
  * @p2p: P2P specific data.
- * @ie: buffer containing information elements.
- * @ie_len: length of @ie buffer.
  *
  * Initializes the discovery device and configure the virtual interface.
  */
@@ -731,7 +755,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 	/* Override scan params to find a peer for a connection */
 	if (num_chans == 1) {
 		active = WL_SCAN_CONNECT_DWELL_TIME_MS;
-		/* XXX WAR to sync with presence period of VSDB GO.
+		/* WAR to sync with presence period of VSDB GO.
 		 * send probe request more frequently
 		 */
 		nprobes = active / WL_SCAN_JOIN_PROBE_INTERVAL_MS;
@@ -1032,6 +1056,269 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 
 
 /**
+ * brcmf_p2p_notify_action_tx_complete() - transmit action frame complete
+ *
+ * @ifp: interfac control.
+ * @e: event message. Not used, to make it usable for fweh event dispatcher.
+ * @data: not used.
+ *
+ */
+int brcmf_p2p_notify_action_tx_complete(struct brcmf_if *ifp,
+					const struct brcmf_event_msg *e,
+					void *data)
+{
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+
+	brcmf_dbg(INFO, "Enter: status %d\n", e->status);
+
+	if (e->status == BRCMF_E_STATUS_SUCCESS)
+		set_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
+	else
+		set_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
+	/* for now complete the receiver process here !! */
+	complete(&p2p->send_af_done);
+
+	return 0;
+}
+
+
+/**
+ * brcmf_p2p_tx_action_frame() - send action frame over fil.
+ *
+ * @p2p: p2p info struct for vif.
+ * @af_params: action frame data/info.
+ *
+ * Send an action frame immediately without doing channel synchronization.
+ *
+ * This function waits for a completion event before returning.
+ * The WLC_E_ACTION_FRAME_COMPLETE event will be received when the action
+ * frame is transmitted.
+ */
+static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
+				     struct brcmf_fil_af_params_le *af_params)
+{
+	struct brcmf_cfg80211_vif *vif;
+	s32 err = 0;
+	s32 timeout = 0;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
+	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
+
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	err = brcmf_fil_bsscfg_data_set(vif->ifp, "actframe", af_params,
+					sizeof(*af_params));
+	if (err) {
+		brcmf_err(" sending action frame has failed\n");
+		goto exit;
+	}
+
+	timeout = wait_for_completion_timeout(&p2p->send_af_done,
+					msecs_to_jiffies(P2P_AF_MAX_WAIT_TIME));
+
+	if (test_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status)) {
+		brcmf_dbg(TRACE, "TX action frame operation is success\n");
+	} else {
+		err = -EIO;
+		brcmf_dbg(TRACE, "TX action frame operation has failed\n");
+	}
+	/* clear status bit for action tx */
+	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
+	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
+
+exit:
+	return err;
+}
+
+
+/**
+ * brcmf_p2p_pub_af_tx() - public action frame tx routine.
+ *
+ * @cfg: driver private data for cfg80211 interface.
+ * @af_params: action frame data/info.
+ * @config_af_params: configuration data for action frame.
+ *
+ * routine which transmits ation frame public type.
+ */
+static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
+			       struct brcmf_fil_af_params_le *af_params,
+			       struct brcmf_config_af_params *config_af_params)
+{
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_fil_action_frame_le *action_frame;
+	struct brcmf_p2p_pub_act_frame *act_frm;
+	s32 err = 0;
+
+	action_frame = &af_params->action_frame;
+	act_frm = (struct brcmf_p2p_pub_act_frame *)(action_frame->data);
+
+	switch (act_frm->subtype) {
+	case P2P_PAF_GON_REQ:
+		brcmf_dbg(TRACE, "P2P: GO_NEG_PHASE status set\n");
+		set_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
+		config_af_params->mpc_onoff = 0;
+		p2p->next_af_subtype = act_frm->subtype + 1;
+		/* increase dwell time to wait for RESP frame */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
+		break;
+	case P2P_PAF_GON_RSP:
+		p2p->next_af_subtype = act_frm->subtype + 1;
+		/* increase dwell time to wait for CONF frame */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
+		break;
+	case P2P_PAF_GON_CONF:
+		/* If we reached till GO Neg confirmation reset the filter */
+		brcmf_dbg(TRACE, "P2P: GO_NEG_PHASE status cleared\n");
+		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
+		/* turn on mpc again if go nego is done */
+		config_af_params->mpc_onoff = 1;
+		/* minimize dwell time */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
+		break;
+	case P2P_PAF_INVITE_REQ:
+		p2p->next_af_subtype = act_frm->subtype + 1;
+		/* increase dwell time */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
+		break;
+	case P2P_PAF_INVITE_RSP:
+		/* minimize dwell time */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
+		break;
+	case P2P_PAF_DEVDIS_REQ:
+		p2p->next_af_subtype = act_frm->subtype + 1;
+		/* maximize dwell time to wait for RESP frame */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_LONG_DWELL_TIME);
+		break;
+	case P2P_PAF_DEVDIS_RSP:
+		/* minimize dwell time */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
+		break;
+	case P2P_PAF_PROVDIS_REQ:
+		config_af_params->mpc_onoff = 0;
+		p2p->next_af_subtype = act_frm->subtype + 1;
+		/* increase dwell time to wait for RESP frame */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
+		break;
+	case P2P_PAF_PROVDIS_RSP:
+		/* wpa_supplicant send go nego req right after prov disc */
+		p2p->next_af_subtype = P2P_PAF_GON_REQ;
+		/* increase dwell time to MED level */
+		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
+		break;
+	default:
+		brcmf_err("Unknown p2p pub act frame subtype: %d\n",
+			  act_frm->subtype);
+		err = -EINVAL;
+	}
+	return err;
+}
+
+/**
+ * brcmf_p2p_send_action_frame() - send action frame .
+ *
+ * @cfg: driver private data for cfg80211 interface.
+ * @ndev: net device to transmit on.
+ * @af_params: configuration data for action frame.
+ */
+bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
+				 struct net_device *ndev,
+				 struct brcmf_fil_af_params_le *af_params)
+{
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_fil_action_frame_le *action_frame;
+	struct brcmf_config_af_params config_af_params;
+	u16 action_frame_len;
+	bool ack = false;
+	u8 category;
+	u8 action;
+	s32 tx_retry;
+
+	action_frame = &af_params->action_frame;
+	action_frame_len = le16_to_cpu(action_frame->len);
+
+	brcmf_p2p_print_actframe(true, action_frame->data, action_frame_len);
+
+	/* Add the default dwell time. Dwell time to stay off-channel */
+	/* to wait for a response action frame after transmitting an  */
+	/* GO Negotiation action frame                                */
+	af_params->dwell_time = cpu_to_le32(P2P_AF_DWELL_TIME);
+
+	category = action_frame->data[DOT11_ACTION_CAT_OFF];
+	action = action_frame->data[DOT11_ACTION_ACT_OFF];
+
+	/* initialize variables */
+	p2p->next_af_subtype = P2P_PAF_SUBTYPE_INVALID;
+
+	/* config parameters */
+	config_af_params.max_tx_retry = P2P_AF_TX_MAX_RETRY;
+	config_af_params.mpc_onoff = -1;
+
+	if (brcmf_p2p_is_pub_action(action_frame->data, action_frame_len)) {
+		/* p2p public action frame process */
+		if (brcmf_p2p_pub_af_tx(cfg, af_params, &config_af_params)) {
+			/* Just send unknown subtype frame with */
+			/* default parameters.                  */
+			brcmf_err("P2P Public action frame, unknown subtype.\n");
+		}
+	} else if (brcmf_p2p_is_gas_action(action_frame->data,
+					   action_frame_len)) {
+		/* service discovery process */
+		if (action == P2PSD_ACTION_ID_GAS_IREQ ||
+		    action == P2PSD_ACTION_ID_GAS_CREQ) {
+			/* save next af suptype to cancel */
+			/* remaining dwell time           */
+			p2p->next_af_subtype = action + 1;
+
+			af_params->dwell_time =
+				cpu_to_le32(P2P_AF_MED_DWELL_TIME);
+		} else if (action == P2PSD_ACTION_ID_GAS_IRESP ||
+			   action == P2PSD_ACTION_ID_GAS_CRESP) {
+			/* configure service discovery response frame */
+			af_params->dwell_time =
+				cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
+		} else {
+			brcmf_err("Unknown action type: %d\n", action);
+			goto exit;
+		}
+	} else if (brcmf_p2p_is_p2p_action(action_frame->data,
+					   action_frame_len)) {
+		/* do not configure anything. it will be */
+		/* sent with a default configuration     */
+	} else {
+		brcmf_err("Unknown Frame: category 0x%x, action 0x%x\n",
+			  category, action);
+		return false;
+	}
+
+	/* if scan is ongoing, abort current scan. */
+	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
+		brcmf_abort_scanning(cfg);
+
+	/* To make sure to send successfully action frame, turn off mpc */
+	if (config_af_params.mpc_onoff == 0)
+		brcmf_set_mpc(ndev, 0);
+
+	/* if failed, retry it. tx_retry_max value is configure by .... */
+	tx_retry = 0;
+	while ((ack == false) && (tx_retry < config_af_params.max_tx_retry)) {
+		ack = !brcmf_p2p_tx_action_frame(p2p, af_params);
+		tx_retry++;
+	}
+	if (ack == false)
+		brcmf_err("Failed to send Action Frame(retry %d)\n", tx_retry);
+
+exit:
+	/* if all done, turn mpc on again */
+	if (config_af_params.mpc_onoff == 1)
+		brcmf_set_mpc(ndev, 1);
+
+	return ack;
+}
+
+
+/**
  * brcmf_p2p_attach() - attach for P2P.
  *
  * @cfg: driver private data for cfg80211 interface.
@@ -1047,6 +1334,7 @@ void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg,
 	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = vif;
 	brcmf_p2p_generate_bss_mac(p2p);
 	brcmf_p2p_set_firmware(p2p);
+	init_completion(&p2p->send_af_done);
 }
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index d247946..0610dcf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -89,6 +89,8 @@ enum brcmf_p2p_status {
  * @ssid: ssid for P2P GO.
  * @listen_channel: channel for @WL_P2P_DISC_ST_LISTEN discover state.
  * @remain_on_channel: contains copy of struct used by cfg80211.
+ * @next_af_subtype: expected action frame subtype.
+ * @send_af_done: indication that action frame tx is complete.
  */
 struct brcmf_p2p_info {
 	struct brcmf_cfg80211_info *cfg;
@@ -100,6 +102,8 @@ struct brcmf_p2p_info {
 	struct brcmf_ssid ssid;
 	u8 listen_channel;
 	struct ieee80211_channel remain_on_channel;
+	u8 next_af_subtype;
+	struct completion send_af_done;
 };
 
 void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg,
@@ -126,5 +130,11 @@ void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp);
 int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 				     const struct brcmf_event_msg *e,
 				     void *data);
+int brcmf_p2p_notify_action_tx_complete(struct brcmf_if *ifp,
+					const struct brcmf_event_msg *e,
+					void *data);
+bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
+				 struct net_device *ndev,
+				 struct brcmf_fil_af_params_le *af_params);
 
 #endif /* WL_CFGP2P_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3914beb..7ae84a0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2494,7 +2494,7 @@ update_bss_info_out:
 	return err;
 }
 
-static void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
+void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 {
 	struct escan_info *escan = &cfg->escan_info;
 
@@ -3949,6 +3949,10 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	s32 err = 0;
 	s32 ie_offset;
 	s32 ie_len;
+	struct brcmf_fil_action_frame_le *action_frame;
+	struct brcmf_fil_af_params_le *af_params;
+	bool ack;
+	s32 chan_nr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3986,11 +3990,44 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 					    ie_len);
 		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
 					GFP_KERNEL);
+	} else if (ieee80211_is_action(mgmt->frame_control)) {
+		af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
+		if (af_params == NULL) {
+			brcmf_err("unable to allocate frame\n");
+			err = -ENOMEM;
+			goto exit;
+		}
+		action_frame = &af_params->action_frame;
+		/* Add the packet Id */
+		action_frame->packet_id = cpu_to_le32(*cookie);
+		/* Add BSSID */
+		memcpy(&action_frame->da[0], &mgmt->da[0], ETH_ALEN);
+		memcpy(&af_params->bssid[0], &mgmt->bssid[0], ETH_ALEN);
+		/* Add the length exepted for 802.11 header  */
+		action_frame->len = cpu_to_le16(len - DOT11_MGMT_HDR_LEN);
+		/* Add the channel */
+		chan_nr = ieee80211_frequency_to_channel(chan->center_freq);
+		af_params->channel = cpu_to_le32(chan_nr);
+
+		memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
+		       le16_to_cpu(action_frame->len));
+
+		brcmf_dbg(TRACE, "Action frame, cookie=%lld, len=%d, freq=%d\n",
+			  *cookie, le16_to_cpu(action_frame->len),
+			  chan->center_freq);
+
+		ack = brcmf_p2p_send_action_frame(cfg, wdev->netdev,
+						  af_params);
+
+		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, ack,
+					GFP_KERNEL);
+		kfree(af_params);
 	} else {
 		brcmf_dbg(TRACE, "Unhandled, fc=%04x!!\n", mgmt->frame_control);
 		brcmf_dbg_hex_dump(true, buf, len, "payload, len=%Zu\n", len);
 	}
 
+exit:
 	return err;
 }
 
@@ -4703,6 +4740,8 @@ static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
 			    brcmf_p2p_notify_listen_complete);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_ACTION_FRAME_RX,
 			    brcmf_p2p_notify_action_frame_rx);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_ACTION_FRAME_COMPLETE,
+			    brcmf_p2p_notify_action_tx_complete);
 }
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 2595712..a020555 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -498,5 +498,6 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct net_device *ndev,
 				bool aborted, bool fw_abort);
 void brcmf_set_mpc(struct net_device *ndev, int mpc);
+void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.10.4



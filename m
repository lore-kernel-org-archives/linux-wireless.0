Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3743 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760197Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/27] brcmfmac: Add handling of receiving P2P action
 frames.
Date: Fri, 8 Feb 2013 15:53:48 +0100
Message-ID: <1360335242-12608-14-git-send-email-arend@broadcom.com> (sfid-20130208_163815_549137_43D39841)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Once wpa_supplicant has registered for P2P action frames all received
action frames for the device are passed up to cfg80211.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  345 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |    3 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +
 3 files changed, 350 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d5f9711..e5b1fb9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -48,6 +48,38 @@
 
 #define BRCMF_SCB_TIMEOUT_VALUE	20
 
+#define P2P_VER			9	/* P2P version: 9=WiFi P2P v1.0 */
+#define P2P_PUB_AF_CATEGORY	0x04
+#define P2P_PUB_AF_ACTION	0x09
+#define P2P_AF_CATEGORY		0x7f
+#define P2P_OUI			"\x50\x6F\x9A"	/* P2P OUI */
+#define P2P_OUI_LEN		3		/* P2P OUI length */
+
+/* WiFi P2P Public Action Frame OUI Subtypes */
+#define P2P_PAF_GON_REQ		0	/* Group Owner Negotiation Req */
+#define P2P_PAF_GON_RSP		1	/* Group Owner Negotiation Rsp */
+#define P2P_PAF_GON_CONF	2	/* Group Owner Negotiation Confirm */
+#define P2P_PAF_INVITE_REQ	3	/* P2P Invitation Request */
+#define P2P_PAF_INVITE_RSP	4	/* P2P Invitation Response */
+#define P2P_PAF_DEVDIS_REQ	5	/* Device Discoverability Request */
+#define P2P_PAF_DEVDIS_RSP	6	/* Device Discoverability Response */
+#define P2P_PAF_PROVDIS_REQ	7	/* Provision Discovery Request */
+#define P2P_PAF_PROVDIS_RSP	8	/* Provision Discovery Response */
+#define P2P_PAF_SUBTYPE_INVALID	255	/* Invalid Subtype */
+
+/* WiFi P2P Action Frame OUI Subtypes */
+#define P2P_AF_NOTICE_OF_ABSENCE	0	/* Notice of Absence */
+#define P2P_AF_PRESENCE_REQ		1	/* P2P Presence Request */
+#define P2P_AF_PRESENCE_RSP		2	/* P2P Presence Response */
+#define P2P_AF_GO_DISC_REQ		3	/* GO Discoverability Request */
+
+/* P2P Service Discovery related */
+#define P2PSD_ACTION_CATEGORY		0x04	/* Public action frame */
+#define P2PSD_ACTION_ID_GAS_IREQ	0x0a	/* GAS Initial Request AF */
+#define P2PSD_ACTION_ID_GAS_IRESP	0x0b	/* GAS Initial Response AF */
+#define P2PSD_ACTION_ID_GAS_CREQ	0x0c	/* GAS Comback Request AF */
+#define P2PSD_ACTION_ID_GAS_CRESP	0x0d	/* GAS Comback Response AF */
+
 /**
  * struct brcmf_p2p_disc_st_le - set discovery state in firmware.
  *
@@ -92,6 +124,261 @@ struct brcmf_p2p_scan_le {
 };
 
 /**
+ * struct brcmf_p2p_pub_act_frame - WiFi P2P Public Action Frame
+ *
+ * @category: P2P_PUB_AF_CATEGORY
+ * @action: P2P_PUB_AF_ACTION
+ * @oui[3]: P2P_OUI
+ * @oui_type: OUI type - P2P_VER
+ * @subtype: OUI subtype - P2P_TYPE_*
+ * @dialog_token: nonzero, identifies req/rsp transaction
+ * @elts[1]: Variable length information elements.
+ */
+struct brcmf_p2p_pub_act_frame {
+	u8	category;
+	u8	action;
+	u8	oui[3];
+	u8	oui_type;
+	u8	subtype;
+	u8	dialog_token;
+	u8	elts[1];
+};
+
+/**
+ * struct brcmf_p2p_action_frame - WiFi P2P Action Frame
+ *
+ * @category: P2P_AF_CATEGORY
+ * @OUI[3]: OUI - P2P_OUI
+ * @type: OUI Type - P2P_VER
+ * @subtype: OUI Subtype - P2P_AF_*
+ * @dialog_token: nonzero, identifies req/resp tranaction
+ * @elts[1]: Variable length information elements.
+ */
+struct brcmf_p2p_action_frame {
+	u8	category;
+	u8	oui[3];
+	u8	type;
+	u8	subtype;
+	u8	dialog_token;
+	u8	elts[1];
+};
+
+/**
+ * struct brcmf_p2psd_gas_pub_act_frame - Wi-Fi GAS Public Action Frame
+ *
+ * @category: 0x04 Public Action Frame
+ * @action: 0x6c Advertisement Protocol
+ * @dialog_token: nonzero, identifies req/rsp transaction
+ * @query_data[1]: Query Data. SD gas ireq SD gas iresp
+ */
+struct brcmf_p2psd_gas_pub_act_frame {
+	u8	category;
+	u8	action;
+	u8	dialog_token;
+	u8	query_data[1];
+};
+
+
+/**
+ * brcmf_p2p_is_pub_action() - true if p2p public type frame.
+ *
+ * @frame: action frame data.
+ * @frame_len: length of action frame data.
+ *
+ * Determine if action frame is p2p public action type
+ */
+static bool brcmf_p2p_is_pub_action(void *frame, u32 frame_len)
+{
+	struct brcmf_p2p_pub_act_frame *pact_frm;
+
+	if (frame == NULL)
+		return false;
+
+	pact_frm = (struct brcmf_p2p_pub_act_frame *)frame;
+	if (frame_len < sizeof(struct brcmf_p2p_pub_act_frame) - 1)
+		return false;
+
+	if (pact_frm->category == P2P_PUB_AF_CATEGORY &&
+	    pact_frm->action == P2P_PUB_AF_ACTION &&
+	    pact_frm->oui_type == P2P_VER &&
+	    memcmp(pact_frm->oui, P2P_OUI, P2P_OUI_LEN) == 0)
+		return true;
+
+	return false;
+}
+
+/**
+ * brcmf_p2p_is_p2p_action() - true if p2p action type frame.
+ *
+ * @frame: action frame data.
+ * @frame_len: length of action frame data.
+ *
+ * Determine if action frame is p2p action type
+ */
+static bool brcmf_p2p_is_p2p_action(void *frame, u32 frame_len)
+{
+	struct brcmf_p2p_action_frame *act_frm;
+
+	if (frame == NULL)
+		return false;
+
+	act_frm = (struct brcmf_p2p_action_frame *)frame;
+	if (frame_len < sizeof(struct brcmf_p2p_action_frame) - 1)
+		return false;
+
+	if (act_frm->category == P2P_AF_CATEGORY &&
+	    act_frm->type  == P2P_VER &&
+	    memcmp(act_frm->oui, P2P_OUI, P2P_OUI_LEN) == 0)
+		return true;
+
+	return false;
+}
+
+/**
+ * brcmf_p2p_is_gas_action() - true if p2p gas action type frame.
+ *
+ * @frame: action frame data.
+ * @frame_len: length of action frame data.
+ *
+ * Determine if action frame is p2p gas action type
+ */
+static bool brcmf_p2p_is_gas_action(void *frame, u32 frame_len)
+{
+	struct brcmf_p2psd_gas_pub_act_frame *sd_act_frm;
+
+	if (frame == NULL)
+		return false;
+
+	sd_act_frm = (struct brcmf_p2psd_gas_pub_act_frame *)frame;
+	if (frame_len < sizeof(struct brcmf_p2psd_gas_pub_act_frame) - 1)
+		return false;
+
+	if (sd_act_frm->category != P2PSD_ACTION_CATEGORY)
+		return false;
+
+	if (sd_act_frm->action == P2PSD_ACTION_ID_GAS_IREQ ||
+	    sd_act_frm->action == P2PSD_ACTION_ID_GAS_IRESP ||
+	    sd_act_frm->action == P2PSD_ACTION_ID_GAS_CREQ ||
+	    sd_act_frm->action == P2PSD_ACTION_ID_GAS_CRESP)
+		return true;
+
+	return false;
+}
+
+/**
+ * brcmf_p2p_print_actframe() - debug print routine.
+ *
+ * @tx: Received or to be transmitted
+ * @frame: action frame data.
+ * @frame_len: length of action frame data.
+ *
+ * Print information about the p2p action frame
+ */
+static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
+{
+	struct brcmf_p2p_pub_act_frame *pact_frm;
+	struct brcmf_p2p_action_frame *act_frm;
+	struct brcmf_p2psd_gas_pub_act_frame *sd_act_frm;
+
+	if (!frame || frame_len <= 2)
+		return;
+
+	if (brcmf_p2p_is_pub_action(frame, frame_len)) {
+		pact_frm = (struct brcmf_p2p_pub_act_frame *)frame;
+		switch (pact_frm->subtype) {
+		case P2P_PAF_GON_REQ:
+			brcmf_dbg(TRACE, "%s P2P Group Owner Negotiation Req Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_GON_RSP:
+			brcmf_dbg(TRACE, "%s P2P Group Owner Negotiation Rsp Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_GON_CONF:
+			brcmf_dbg(TRACE, "%s P2P Group Owner Negotiation Confirm Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_INVITE_REQ:
+			brcmf_dbg(TRACE, "%s P2P Invitation Request  Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_INVITE_RSP:
+			brcmf_dbg(TRACE, "%s P2P Invitation Response Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_DEVDIS_REQ:
+			brcmf_dbg(TRACE, "%s P2P Device Discoverability Request Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_DEVDIS_RSP:
+			brcmf_dbg(TRACE, "%s P2P Device Discoverability Response Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_PROVDIS_REQ:
+			brcmf_dbg(TRACE, "%s P2P Provision Discovery Request Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_PAF_PROVDIS_RSP:
+			brcmf_dbg(TRACE, "%s P2P Provision Discovery Response Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		default:
+			brcmf_dbg(TRACE, "%s Unknown P2P Public Action Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		}
+	} else if (brcmf_p2p_is_p2p_action(frame, frame_len)) {
+		act_frm = (struct brcmf_p2p_action_frame *)frame;
+		switch (act_frm->subtype) {
+		case P2P_AF_NOTICE_OF_ABSENCE:
+			brcmf_dbg(TRACE, "%s P2P Notice of Absence Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_AF_PRESENCE_REQ:
+			brcmf_dbg(TRACE, "%s P2P Presence Request Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_AF_PRESENCE_RSP:
+			brcmf_dbg(TRACE, "%s P2P Presence Response Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2P_AF_GO_DISC_REQ:
+			brcmf_dbg(TRACE, "%s P2P Discoverability Request Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		default:
+			brcmf_dbg(TRACE, "%s Unknown P2P Action Frame\n",
+				  (tx) ? "TX" : "RX");
+		}
+
+	} else if (brcmf_p2p_is_gas_action(frame, frame_len)) {
+		sd_act_frm = (struct brcmf_p2psd_gas_pub_act_frame *)frame;
+		switch (sd_act_frm->action) {
+		case P2PSD_ACTION_ID_GAS_IREQ:
+			brcmf_dbg(TRACE, "%s P2P GAS Initial Request\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2PSD_ACTION_ID_GAS_IRESP:
+			brcmf_dbg(TRACE, "%s P2P GAS Initial Response\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2PSD_ACTION_ID_GAS_CREQ:
+			brcmf_dbg(TRACE, "%s P2P GAS Comback Request\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		case P2PSD_ACTION_ID_GAS_CRESP:
+			brcmf_dbg(TRACE, "%s P2P GAS Comback Response\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		default:
+			brcmf_dbg(TRACE, "%s Unknown P2P GAS Frame\n",
+				  (tx) ? "TX" : "RX");
+			break;
+		}
+	}
+}
+
+/**
  * brcmf_p2p_set_firmware() - prepare firmware for peer-to-peer operation.
  *
  * @p2p: P2P specific data.
@@ -687,6 +974,64 @@ void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp)
 
 
 /**
+ * brcmf_p2p_notify_action_frame_rx() - received action frame.
+ *
+ * @ifp: interfac control.
+ * @e: event message. Not used, to make it usable for fweh event dispatcher.
+ * @data: payload of message, containing action frame data.
+ *
+ */
+int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
+				     const struct brcmf_event_msg *e,
+				     void *data)
+{
+	struct wireless_dev *wdev;
+	u32 mgmt_frame_len = e->datalen - sizeof(struct brcmf_rx_mgmt_data);
+	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
+	u16 chanspec = be16_to_cpu(rxframe->chanspec);
+	struct ieee80211_mgmt *mgmt_frame;
+	s32 err;
+	s32 freq;
+	u16 mgmt_type;
+
+	/* Check if wpa_supplicant has registered for this frame */
+	brcmf_dbg(INFO, "ifp->vif->mgmt_rx_reg %04x\n", ifp->vif->mgmt_rx_reg);
+	mgmt_type = (IEEE80211_STYPE_ACTION & IEEE80211_FCTL_STYPE) >> 4;
+	if ((ifp->vif->mgmt_rx_reg & BIT(mgmt_type)) == 0)
+		return 0;
+
+	brcmf_p2p_print_actframe(false, (u8 *)(rxframe + 1), mgmt_frame_len);
+
+	mgmt_frame = kzalloc(offsetof(struct ieee80211_mgmt, u) +
+			     mgmt_frame_len, GFP_KERNEL);
+	if (!mgmt_frame) {
+		brcmf_err("No memory available for action frame\n");
+		return -ENOMEM;
+	}
+	memcpy(mgmt_frame->da, ifp->mac_addr, ETH_ALEN);
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSSID, mgmt_frame->bssid,
+				     ETH_ALEN);
+	if (err < 0)
+		brcmf_err("BRCMF_C_GET_BSSID error %d\n", err);
+	memcpy(mgmt_frame->sa, e->addr, ETH_ALEN);
+	mgmt_frame->frame_control = cpu_to_le16(IEEE80211_STYPE_ACTION);
+	memcpy(&mgmt_frame->u, (u8 *)(rxframe + 1), mgmt_frame_len);
+	mgmt_frame_len += offsetof(struct ieee80211_mgmt, u);
+
+	freq = ieee80211_channel_to_frequency(CHSPEC_CHANNEL(chanspec),
+					      CHSPEC_IS2G(chanspec) ?
+					      IEEE80211_BAND_2GHZ :
+					      IEEE80211_BAND_5GHZ);
+	wdev = ifp->ndev->ieee80211_ptr;
+	cfg80211_rx_mgmt(wdev, freq, 0, (u8 *)mgmt_frame, mgmt_frame_len,
+			 GFP_ATOMIC);
+
+	kfree(mgmt_frame);
+	return 0;
+}
+
+
+/**
  * brcmf_p2p_attach() - attach for P2P.
  *
  * @cfg: driver private data for cfg80211 interface.
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 4c1819c..d247946 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -123,5 +123,8 @@ int brcmf_p2p_notify_listen_complete(struct brcmf_if *ifp,
 				     const struct brcmf_event_msg *e,
 				     void *data);
 void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp);
+int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
+				     const struct brcmf_event_msg *e,
+				     void *data);
 
 #endif /* WL_CFGP2P_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c94d536..3914beb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4701,6 +4701,8 @@ static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
 			    brcmf_notify_rx_mgmt_p2p_probereq);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_P2P_DISC_LISTEN_COMPLETE,
 			    brcmf_p2p_notify_listen_complete);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_ACTION_FRAME_RX,
+			    brcmf_p2p_notify_action_frame_rx);
 }
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
-- 
1.7.10.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3754 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760196Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/27] brcmfmac: add support for P2P listen mode.
Date: Fri, 8 Feb 2013 15:53:38 +0100
Message-ID: <1360335242-12608-4-git-send-email-arend@broadcom.com> (sfid-20130208_163814_476016_B6AB9BA3)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

With this patch a device can be put in p2p listen mode and becomes
visible for other p2p devices (via p2p_find).

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   13 ++
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  150 +++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |   15 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  189 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    2 +
 6 files changed, 341 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index b61254d..82724d3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -452,6 +452,19 @@ struct brcmf_sta_info_le {
 	__le32	rx_decrypt_failures;	/* # of packet decrypted failed */
 };
 
+/*
+ * WLC_E_PROBRESP_MSG
+ * WLC_E_P2P_PROBREQ_MSG
+ * WLC_E_ACTION_FRAME_RX
+ */
+struct brcmf_rx_mgmt_data {
+	__be16	version;
+	__be16	chanspec;
+	__be32	rssi;
+	__be32	mactime;
+	__be32	rate;
+};
+
 /* Bus independent dongle command */
 struct brcmf_dcmd {
 	uint cmd;		/* common dongle cmd definition */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 36901f7..8c39b51 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -83,6 +83,7 @@ struct brcmf_event;
 	BRCMF_ENUM_DEF(MULTICAST_DECODE_ERROR, 51) \
 	BRCMF_ENUM_DEF(TRACE, 52) \
 	BRCMF_ENUM_DEF(IF, 54) \
+	BRCMF_ENUM_DEF(P2P_DISC_LISTEN_COMPLETE, 55) \
 	BRCMF_ENUM_DEF(RSSI, 56) \
 	BRCMF_ENUM_DEF(PFN_SCAN_COMPLETE, 57) \
 	BRCMF_ENUM_DEF(EXTLOG_MSG, 58) \
@@ -96,8 +97,11 @@ struct brcmf_event;
 	BRCMF_ENUM_DEF(DFS_AP_RESUME, 66) \
 	BRCMF_ENUM_DEF(ESCAN_RESULT, 69) \
 	BRCMF_ENUM_DEF(ACTION_FRAME_OFF_CHAN_COMPLETE, 70) \
+	BRCMF_ENUM_DEF(PROBERESP_MSG, 71) \
+	BRCMF_ENUM_DEF(P2P_PROBEREQ_MSG, 72) \
 	BRCMF_ENUM_DEF(DCS_REQUEST, 73) \
-	BRCMF_ENUM_DEF(FIFO_CREDIT_MAP, 74)
+	BRCMF_ENUM_DEF(FIFO_CREDIT_MAP, 74) \
+	BRCMF_ENUM_DEF(ACTION_FRAME_RX, 75)
 
 #define BRCMF_ENUM_DEF(id, val) \
 	BRCMF_E_##id = (val),
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 25c6b7d..ecc96f3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -318,11 +318,6 @@ static s32 brcmf_p2p_deinit_discovery(struct brcmf_p2p_info *p2p)
 	brcmf_dbg(TRACE, "enter\n");
 
 	bss_dev = &p2p->bss_idx[P2PAPI_BSSCFG_DEVICE];
-	if (bss_dev->vif == NULL) {
-		brcmf_err("do nothing, not initialized\n");
-		return -EINVAL;
-	}
-
 	ifp = bss_dev->vif->ifp;
 
 	/* Set the discovery state to SCAN */
@@ -348,8 +343,7 @@ static s32 brcmf_p2p_deinit_discovery(struct brcmf_p2p_info *p2p)
  *
  * Initializes the discovery device and configure the virtual interface.
  */
-static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p,
-				      const u8 *ie, u32 ie_len)
+static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 {
 	struct brcmf_cfg80211_vif *vif;
 	s32 ret = 0;
@@ -357,9 +351,8 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p,
 	brcmf_dbg(TRACE, "enter\n");
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (vif) {
-		brcmf_dbg(INFO,
-			  "DISCOVERY init already done, just process IE\n");
-		goto set_ie;
+		brcmf_dbg(INFO, "DISCOVERY init already done\n");
+		goto exit;
 	}
 
 	ret = brcmf_p2p_init_discovery(p2p);
@@ -380,20 +373,36 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p,
 	if (ret < 0)
 		brcmf_err("wsec error %d\n", ret);
 
-set_ie:
-	if (ie_len) {
-		ret = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBREQ_FLAG,
-					    ie, ie_len);
-
-		if (ret < 0) {
-			brcmf_err("set probreq ie occurs error %d\n", ret);
-			goto exit;
-		}
-	}
 exit:
 	return ret;
 }
 
+/**
+ * brcmf_p2p_configure_probereq() - Configure probe request data.
+ *
+ * @p2p: P2P specific data.
+ * @ie: buffer containing information elements.
+ * @ie_len: length of @ie buffer.
+ *
+ */
+static int brcmf_p2p_configure_probereq(struct brcmf_p2p_info *p2p,
+					const u8 *ie, u32 ie_len)
+{
+	struct brcmf_cfg80211_vif *vif;
+	s32 err = 0;
+
+	brcmf_dbg(TRACE, "enter\n");
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+
+	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBREQ_FLAG,
+				    ie, ie_len);
+
+	if (err < 0)
+		brcmf_err("set probreq ie occurs error %d\n", err);
+
+	return err;
+}
+
 /*
  * brcmf_p2p_escan() - initiate a P2P scan.
  *
@@ -420,9 +429,6 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 	struct brcmf_scan_params_le *sparams;
 	struct brcmf_ssid ssid;
 
-	/* add padding if uneven */
-	if (num_chans % 2)
-		memsize += sizeof(__le16);
 	memsize += num_chans * sizeof(__le16);
 	memblk = kzalloc(memsize, GFP_KERNEL);
 	if (!memblk)
@@ -639,8 +645,10 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
 		brcmf_dbg(INFO, "P2P: GO_NEG_PHASE status cleared\n");
 
-		err = brcmf_p2p_enable_discovery(p2p, request->ie,
-						 request->ie_len);
+		err = brcmf_p2p_enable_discovery(p2p);
+		if (err == 0)
+			err = brcmf_p2p_configure_probereq(p2p, request->ie,
+							   request->ie_len);
 
 		/*
 		 * override .run_escan() callback.
@@ -666,6 +674,92 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 	return err;
 }
 
+
+/**
+ * brcmf_p2p_remain_on_channel() - put device on channel and stay there.
+ *
+ * @wiphy: wiphy device.
+ * @channel: channel to stay on.
+ * @duration: time in ms to remain on channel.
+ *
+ */
+int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
+				struct ieee80211_channel *channel,
+				unsigned int duration, u64 *cookie)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_cfg80211_vif *vif;
+	s32 err;
+	u16 chanspec;
+
+	brcmf_dbg(TRACE, "Enter, channel: %d, duration ms (%d)\n",
+		  ieee80211_frequency_to_channel(channel->center_freq),
+		  duration);
+
+	*cookie = 0;
+	err = brcmf_p2p_enable_discovery(p2p);
+	if (err)
+		goto exit;
+
+	chanspec = channel_to_chanspec(channel);
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	err = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_LISTEN,
+					   chanspec, (u16)duration);
+	if (err)
+		goto exit;
+
+	memcpy(&p2p->remain_on_channel, channel,
+	       sizeof(p2p->remain_on_channel));
+
+	set_bit(BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL, &p2p->status);
+
+exit:
+	cfg80211_ready_on_channel(wdev, *cookie, channel, duration, GFP_KERNEL);
+	return err;
+}
+
+
+/**
+ * brcmf_p2p_notify_listen_complete() - p2p listen has completed.
+ *
+ * @ifp: interfac control.
+ * @e: event message. Not used, to make it usable for fweh event dispatcher.
+ * @data: payload of message. Not used.
+ *
+ */
+int brcmf_p2p_notify_listen_complete(struct brcmf_if *ifp,
+				     const struct brcmf_event_msg *e,
+				     void *data)
+{
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+
+	brcmf_dbg(TRACE, "Enter\n");
+	if (test_and_clear_bit(BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL,
+			       &p2p->status))
+		cfg80211_remain_on_channel_expired(&ifp->vif->wdev, 0,
+						   &p2p->remain_on_channel,
+						   GFP_KERNEL);
+	return 0;
+}
+
+
+/**
+ * brcmf_p2p_cancel_remain_on_channel() - cancel p2p listen state.
+ *
+ * @ifp: interfac control.
+ *
+ */
+void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp)
+{
+	if (!ifp)
+		return;
+	brcmf_p2p_set_discover_state(ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
+	brcmf_p2p_notify_listen_complete(ifp, NULL, NULL);
+}
+
+
 /**
  * brcmf_p2p_attach() - attach for P2P.
  *
@@ -689,7 +783,11 @@ void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
  */
 void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 {
-	brcmf_p2p_deinit_discovery(p2p);
+	if (p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif != NULL) {
+		brcmf_p2p_cancel_remain_on_channel(
+			p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->ifp);
+		brcmf_p2p_deinit_discovery(p2p);
+	}
 	/* just set it all to zero */
 	memset(p2p, 0, sizeof(*p2p));
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index f304adf..df93272 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -60,10 +60,10 @@ struct p2p_bss {
  * @BRCMF_P2P_STATUS_IF_DELETING: peer-to-peer vif delete sent to dongle.
  * @BRCMF_P2P_STATUS_IF_CHANGING: peer-to-peer vif change sent to dongle.
  * @BRCMF_P2P_STATUS_IF_CHANGED: peer-to-peer vif change completed on dongle.
- * @BRCMF_P2P_STATUS_LISTEN_EXPIRED: listen duration expired.
  * @BRCMF_P2P_STATUS_ACTION_TX_COMPLETED: action frame tx completed.
  * @BRCMF_P2P_STATUS_ACTION_TX_NOACK: action frame tx not acked.
  * @BRCMF_P2P_STATUS_GO_NEG_PHASE: P2P GO negotiation ongoing.
+ * @BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL: P2P listen, remaining on channel.
  */
 enum brcmf_p2p_status {
 	BRCMF_P2P_STATUS_IF_ADD = 0,
@@ -71,10 +71,10 @@ enum brcmf_p2p_status {
 	BRCMF_P2P_STATUS_IF_DELETING,
 	BRCMF_P2P_STATUS_IF_CHANGING,
 	BRCMF_P2P_STATUS_IF_CHANGED,
-	BRCMF_P2P_STATUS_LISTEN_EXPIRED,
 	BRCMF_P2P_STATUS_ACTION_TX_COMPLETED,
 	BRCMF_P2P_STATUS_ACTION_TX_NOACK,
-	BRCMF_P2P_STATUS_GO_NEG_PHASE
+	BRCMF_P2P_STATUS_GO_NEG_PHASE,
+	BRCMF_P2P_STATUS_REMAIN_ON_CHANNEL
 };
 
 /**
@@ -88,6 +88,7 @@ enum brcmf_p2p_status {
  * @listen_timer: timer for @WL_P2P_DISC_ST_LISTEN discover state.
  * @ssid: ssid for P2P GO.
  * @listen_channel: channel for @WL_P2P_DISC_ST_LISTEN discover state.
+ * @remain_on_channel: contains copy of struct used by cfg80211.
  */
 struct brcmf_p2p_info {
 	struct brcmf_cfg80211_info *cfg;
@@ -98,6 +99,7 @@ struct brcmf_p2p_info {
 	struct timer_list listen_timer;
 	struct brcmf_ssid ssid;
 	u8 listen_channel;
+	struct ieee80211_channel remain_on_channel;
 };
 
 void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg);
@@ -110,5 +112,12 @@ int brcmf_p2p_start_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request);
+int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
+				struct ieee80211_channel *channel,
+				unsigned int duration, u64 *cookie);
+int brcmf_p2p_notify_listen_complete(struct brcmf_if *ifp,
+				     const struct brcmf_event_msg *e,
+				     void *data);
+void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp);
 
 #endif /* WL_CFGP2P_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6b4e877..6ab6397 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3359,6 +3359,11 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			mgmt_ie_len = &saved_ie->probe_req_ie_len;
 			mgmt_ie_buf_len = sizeof(saved_ie->probe_req_ie);
 			break;
+		case BRCMF_VNDR_IE_PRBRSP_FLAG:
+			mgmt_ie_buf = saved_ie->probe_res_ie;
+			mgmt_ie_len = &saved_ie->probe_res_ie_len;
+			mgmt_ie_buf_len = sizeof(saved_ie->probe_res_ie);
+			break;
 		default:
 			err = -EPERM;
 			brcmf_err("not suitable type\n");
@@ -3674,6 +3679,150 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	return err;
 }
 
+
+static void
+brcmf_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   u16 frame_type, bool reg)
+{
+	struct brcmf_if *ifp = netdev_priv(wdev->netdev);
+	struct brcmf_cfg80211_vif *vif = ifp->vif;
+	u16 mgmt_type;
+
+	brcmf_dbg(TRACE, "Enter, frame_type %04x, reg=%d\n", frame_type, reg);
+
+	mgmt_type = (frame_type & IEEE80211_FCTL_STYPE) >> 4;
+	if (reg)
+		vif->mgmt_rx_reg |= BIT(mgmt_type);
+	else
+		vif->mgmt_rx_reg |= ~BIT(mgmt_type);
+}
+
+
+static int
+brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+		       struct ieee80211_channel *chan, bool offchan,
+		       unsigned int wait, const u8 *buf, size_t len,
+		       bool no_cck, bool dont_wait_for_ack, u64 *cookie)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	const struct ieee80211_mgmt *mgmt;
+	struct brcmf_cfg80211_vif *vif;
+	s32 err = 0;
+	s32 ie_offset;
+	s32 ie_len;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	*cookie = 0;
+
+	mgmt = (const struct ieee80211_mgmt *)buf;
+
+	if (ieee80211_is_mgmt(mgmt->frame_control)) {
+		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+			/* Right now the only reason to get a probe response */
+			/* is for p2p listen response from wpa_supplicant.   */
+			/* Unfortunately the wpa_supplicant sends it on the  */
+			/* primary ndev, while dongle wants it on the p2p    */
+			/* vif. Since this is only reason for a probe        */
+			/* response to be sent, the vif is taken from cfg.   */
+			/* If ever desired to send proberesp for non p2p     */
+			/* response then data should be checked for          */
+			/* "DIRECT-". Note in future supplicant will take    */
+			/* dedicated p2p wdev to do this and then this 'hack'*/
+			/* is not needed anymore.                            */
+			ie_offset =  DOT11_MGMT_HDR_LEN +
+				     DOT11_BCN_PRB_FIXED_LEN;
+			ie_len = len - ie_offset;
+
+			vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+			if (vif == NULL) {
+				brcmf_err("No p2p device available for probe response\n");
+				err = -ENODEV;
+				goto exit;
+			}
+			err = brcmf_vif_set_mgmt_ie(vif,
+						    BRCMF_VNDR_IE_PRBRSP_FLAG,
+						    &buf[ie_offset],
+						    ie_len);
+			cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
+						GFP_KERNEL);
+			goto exit;
+		}
+	}
+	brcmf_dbg(TRACE, "Unhandled, is_mgmt %d, fc=%04x!!!!!\n",
+		  ieee80211_is_mgmt(mgmt->frame_control), mgmt->frame_control);
+exit:
+	return err;
+}
+
+
+static int
+brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
+					struct wireless_dev *wdev,
+					u64 cookie)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_vif *vif;
+	int err = 0;
+
+	brcmf_dbg(TRACE, "Enter p2p listen cancel\n");
+
+	vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (vif == NULL) {
+		brcmf_err("No p2p device available for probe response\n");
+		err = -ENODEV;
+		goto exit;
+	}
+	brcmf_p2p_cancel_remain_on_channel(vif->ifp);
+exit:
+	return err;
+}
+
+static s32 brcmf_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
+					     const struct brcmf_event_msg *e,
+					     void *data)
+{
+	struct wireless_dev *wdev;
+	struct brcmf_cfg80211_vif *vif = ifp->vif;
+	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
+	u16 chanspec = be16_to_cpu(rxframe->chanspec);
+	u8 *mgmt_frame;
+	u32 mgmt_frame_len;
+	s32 freq;
+	u16 mgmt_type;
+
+	brcmf_dbg(INFO,
+		  "Enter: event %d reason %d\n", e->event_code, e->reason);
+
+	/* Firmware sends us two proberesponses for each idx one. At the */
+	/* moment only bsscfgidx 0 is passed up to supplicant            */
+	if (e->bsscfgidx)
+		return 0;
+
+	/* Check if wpa_supplicant has registered for this frame */
+	brcmf_dbg(INFO, "vif->mgmt_rx_reg %04x\n", vif->mgmt_rx_reg);
+	mgmt_type = (IEEE80211_STYPE_PROBE_REQ & IEEE80211_FCTL_STYPE) >> 4;
+	if ((vif->mgmt_rx_reg & BIT(mgmt_type)) == 0)
+		return 0;
+
+	mgmt_frame = (u8 *)(rxframe + 1);
+	mgmt_frame_len = e->datalen - sizeof(*rxframe);
+	freq = ieee80211_channel_to_frequency(CHSPEC_CHANNEL(chanspec),
+					      CHSPEC_IS2G(chanspec) ?
+					      IEEE80211_BAND_2GHZ :
+					      IEEE80211_BAND_5GHZ);
+	wdev = ifp->ndev->ieee80211_ptr;
+	cfg80211_rx_mgmt(wdev, freq, 0, mgmt_frame, mgmt_frame_len, GFP_ATOMIC);
+
+	brcmf_dbg(INFO,
+		  "mgmt_frame_len (%d) , e->datalen (%d), chanspec (%04x), freq (%d)\n",
+		  mgmt_frame_len, e->datalen, chanspec, freq);
+
+	return 0;
+}
+
+
 static struct cfg80211_ops wl_cfg80211_ops = {
 	.add_virtual_intf = brcmf_cfg80211_add_iface,
 	.del_virtual_intf = brcmf_cfg80211_del_iface,
@@ -3703,6 +3852,10 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.del_station = brcmf_cfg80211_del_station,
 	.sched_scan_start = brcmf_cfg80211_sched_scan_start,
 	.sched_scan_stop = brcmf_cfg80211_sched_scan_stop,
+	.mgmt_frame_register = brcmf_cfg80211_mgmt_frame_register,
+	.mgmt_tx = brcmf_cfg80211_mgmt_tx,
+	.remain_on_channel = brcmf_p2p_remain_on_channel,
+	.cancel_remain_on_channel = brcmf_cfg80211_cancel_remain_on_channel,
 #ifdef CONFIG_NL80211_TESTMODE
 	.testmode_cmd = brcmf_cfg80211_testmode
 #endif
@@ -3765,6 +3918,30 @@ static const struct ieee80211_iface_combination brcmf_iface_combos[] = {
 	}
 };
 
+static const struct ieee80211_txrx_stypes
+brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_GO] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4) |
+		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+		      BIT(IEEE80211_STYPE_ACTION >> 4)
+	}
+};
+
 static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 {
 	struct wiphy *wiphy;
@@ -3797,10 +3974,10 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
-	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;	/* enable power
-								 * save mode
-								 * by default
-								 */
+	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	wiphy->mgmt_stypes = brcmf_txrx_stypes;
+	wiphy->max_remain_on_channel_duration = 5000;
 	brcmf_wiphy_pno_params(wiphy);
 	err = wiphy_register(wiphy);
 	if (err < 0) {
@@ -4271,6 +4448,10 @@ static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
 			    brcmf_notify_sched_scan_results);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_IF,
 			    brcmf_notify_vif_event);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_P2P_PROBEREQ_MSG,
+			    brcmf_notify_rx_mgmt_p2p_probereq);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_P2P_DISC_LISTEN_COMPLETE,
+			    brcmf_p2p_notify_listen_complete);
 }
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 691f613..a996afa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -189,6 +189,7 @@ struct vif_saved_ie {
  * @sme_state: SME state using enum brcmf_vif_status bits.
  * @pm_block: power-management blocked.
  * @list: linked list.
+ * @mgmt_rx_reg: registered rx mgmt frame types.
  */
 struct brcmf_cfg80211_vif {
 	struct brcmf_if *ifp;
@@ -200,6 +201,7 @@ struct brcmf_cfg80211_vif {
 	bool pm_block;
 	struct vif_saved_ie saved_ie;
 	struct list_head list;
+	u16 mgmt_rx_reg;
 };
 
 /* association inform */
-- 
1.7.10.4



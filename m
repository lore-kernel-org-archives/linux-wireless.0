Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3669 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760212Ab3BHO4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 27/27] brcmfmac: Add tx p2p off-channel support.
Date: Fri, 8 Feb 2013 15:54:02 +0100
Message-ID: <1360335242-12608-28-git-send-email-arend@broadcom.com> (sfid-20130208_160635_218246_DFE60C17)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

With this patch off-channel action frames can be transmitted. This
is needed for p2p when two devices need to find each other while
using different social channels.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  673 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |   51 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   76 +--
 3 files changed, 707 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 84d6acd..4166e64 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -43,6 +43,9 @@
 #define SOCIAL_CHAN_1		1
 #define SOCIAL_CHAN_2		6
 #define SOCIAL_CHAN_3		11
+#define IS_P2P_SOCIAL_CHANNEL(channel) ((channel == SOCIAL_CHAN_1) || \
+					 (channel == SOCIAL_CHAN_2) || \
+					 (channel == SOCIAL_CHAN_3))
 #define SOCIAL_CHAN_CNT		3
 #define AF_PEER_SEARCH_CNT	2
 
@@ -64,11 +67,12 @@
 #define P2P_AF_MIN_DWELL_TIME		100
 #define P2P_AF_MED_DWELL_TIME		400
 #define P2P_AF_LONG_DWELL_TIME		1000
-#define P2P_AF_TX_MAX_RETRY		5
+#define P2P_AF_TX_MAX_RETRY		1
 #define P2P_AF_MAX_WAIT_TIME		2000
 #define P2P_INVALID_CHANNEL		-1
 #define P2P_CHANNEL_SYNC_RETRY		5
 #define P2P_AF_FRM_SCAN_MAX_WAIT	1500
+#define P2P_DEFAULT_SLEEP_TIME_VSDB	200
 
 /* WiFi P2P Public Action Frame OUI Subtypes */
 #define P2P_PAF_GON_REQ		0	/* Group Owner Negotiation Req */
@@ -196,13 +200,15 @@ struct brcmf_p2psd_gas_pub_act_frame {
 /**
  * struct brcmf_config_af_params - Action Frame Parameters for tx.
  *
- * @max_tx_retry: max tx retry count if tx no ack.
  * @mpc_onoff: To make sure to send successfully action frame, we have to
  *             turn off mpc  0: off, 1: on,  (-1): do nothing
+ * @search_channel: 1: search peer's channel to send af
+ * extra_listen: keep the dwell time to get af response frame.
  */
 struct brcmf_config_af_params {
-	s32 max_tx_retry;
 	s32 mpc_onoff;
+	bool search_channel;
+	bool extra_listen;
 };
 
 /**
@@ -415,6 +421,30 @@ static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
 
 #endif
 
+
+/**
+ * brcmf_p2p_chnr_to_chspec() - convert channel number to chanspec.
+ *
+ * @channel: channel number
+ */
+static u16 brcmf_p2p_chnr_to_chspec(u16 channel)
+{
+	u16 chanspec;
+
+	chanspec = channel & WL_CHANSPEC_CHAN_MASK;
+
+	if (channel <= CH_MAX_2G_CHANNEL)
+		chanspec |= WL_CHANSPEC_BAND_2G;
+	else
+		chanspec |= WL_CHANSPEC_BAND_5G;
+
+	chanspec |= WL_CHANSPEC_BW_20;
+	chanspec |= WL_CHANSPEC_CTL_SB_NONE;
+
+	return chanspec;
+}
+
+
 /**
  * brcmf_p2p_set_firmware() - prepare firmware for peer-to-peer operation.
  *
@@ -811,6 +841,43 @@ exit:
 	return err;
 }
 
+
+/**
+ * brcmf_p2p_find_listen_channel() - find listen channel in ie string.
+ *
+ * @ie: string of information elements.
+ * @ie_len: length of string.
+ *
+ * Scan ie for p2p ie and look for attribute 6 channel. If available determine
+ * channel and return it.
+ */
+static s32 brcmf_p2p_find_listen_channel(const u8 *ie, u32 ie_len)
+{
+	u8 channel_ie[5];
+	s32 listen_channel;
+	s32 err;
+
+	err = cfg80211_get_p2p_attr(ie, ie_len,
+				    IEEE80211_P2P_ATTR_LISTEN_CHANNEL,
+				    channel_ie, sizeof(channel_ie));
+	if (err < 0)
+		return err;
+
+	/* listen channel subel length format:     */
+	/* 3(country) + 1(op. class) + 1(chan num) */
+	listen_channel = (s32)channel_ie[3 + 1];
+
+	if (listen_channel == SOCIAL_CHAN_1 ||
+	    listen_channel == SOCIAL_CHAN_2 ||
+	    listen_channel == SOCIAL_CHAN_3) {
+		brcmf_dbg(INFO, "Found my Listen Channel %d\n", listen_channel);
+		return listen_channel;
+	}
+
+	return -EPERM;
+}
+
+
 /**
  * brcmf_p2p_scan_prep() - prepare scan based on request.
  *
@@ -831,12 +898,13 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 
 	if (brcmf_p2p_scan_is_p2p_request(request)) {
 		/* find my listen channel */
-		err = cfg80211_get_p2p_attr(request->ie, request->ie_len,
-				      IEEE80211_P2P_ATTR_LISTEN_CHANNEL,
-				      &p2p->listen_channel, 1);
+		err = brcmf_p2p_find_listen_channel(request->ie,
+						    request->ie_len);
 		if (err < 0)
 			return err;
 
+		p2p->afx_hdl.my_listen_chan = err;
+
 		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
 		brcmf_dbg(INFO, "P2P: GO_NEG_PHASE status cleared\n");
 
@@ -859,13 +927,12 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
  * brcmf_p2p_discover_listen() - set firmware to discover listen state.
  *
  * @p2p: p2p device.
- * @freq: center frequency for discover listen.
- * #@duration: time in ms to stay on channel.
+ * @channel: channel nr for discover listen.
+ * @duration: time in ms to stay on channel.
  *
  */
 static s32
-brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p,
-			  struct ieee80211_channel *channel, u32 duration)
+brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
 {
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
@@ -884,7 +951,7 @@ brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p,
 		goto exit;
 	}
 
-	chanspec = channel_to_chanspec(channel);
+	chanspec = brcmf_p2p_chnr_to_chspec(channel);
 	err = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_LISTEN,
 					   chanspec, (u16)duration);
 	if (!err) {
@@ -911,15 +978,16 @@ int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	s32 err;
+	u16 channel_nr;
 
-	brcmf_dbg(TRACE, "Enter, channel: %d, duration ms (%d)\n",
-		  ieee80211_frequency_to_channel(channel->center_freq),
+	channel_nr = ieee80211_frequency_to_channel(channel->center_freq);
+	brcmf_dbg(TRACE, "Enter, channel: %d, duration ms (%d)\n", channel_nr,
 		  duration);
 
 	err = brcmf_p2p_enable_discovery(p2p);
 	if (err)
 		goto exit;
-	err = brcmf_p2p_discover_listen(p2p, channel, duration);
+	err = brcmf_p2p_discover_listen(p2p, channel_nr, duration);
 	if (err)
 		goto exit;
 
@@ -949,11 +1017,20 @@ int brcmf_p2p_notify_listen_complete(struct brcmf_if *ifp,
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (test_and_clear_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN,
-			       &p2p->status))
+			       &p2p->status)) {
+		if (test_and_clear_bit(BRCMF_P2P_STATUS_WAITING_NEXT_AF_LISTEN,
+				       &p2p->status)) {
+			clear_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME,
+				  &p2p->status);
+			brcmf_dbg(INFO, "Listen DONE, wake up wait_next_af\n");
+			complete(&p2p->wait_next_af);
+		}
+
 		cfg80211_remain_on_channel_expired(&ifp->vif->wdev,
 						   p2p->remain_on_channel_cookie,
 						   &p2p->remain_on_channel,
 						   GFP_KERNEL);
+	}
 	return 0;
 }
 
@@ -974,6 +1051,285 @@ void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp)
 
 
 /**
+ * brcmf_p2p_act_frm_search() - search function for action frame.
+ *
+ * @p2p: p2p device.
+ * channel: channel on which action frame is to be trasmitted.
+ *
+ * search function to reach at common channel to send action frame. When
+ * channel is 0 then all social channels will be used to send af
+ */
+static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
+{
+	s32 err;
+	u32 channel_cnt;
+	u16 *default_chan_list;
+	u32 i;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (channel)
+		channel_cnt = AF_PEER_SEARCH_CNT;
+	else
+		channel_cnt = SOCIAL_CHAN_CNT;
+	default_chan_list = kzalloc(channel_cnt * sizeof(*default_chan_list),
+				    GFP_KERNEL);
+	if (default_chan_list == NULL) {
+		brcmf_err("channel list allocation failed\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+	if (channel) {
+		/* insert same channel to the chan_list */
+		for (i = 0; i < channel_cnt; i++)
+			default_chan_list[i] =
+					brcmf_p2p_chnr_to_chspec(channel);
+	} else {
+		default_chan_list[0] = brcmf_p2p_chnr_to_chspec(SOCIAL_CHAN_1);
+		default_chan_list[1] = brcmf_p2p_chnr_to_chspec(SOCIAL_CHAN_2);
+		default_chan_list[2] = brcmf_p2p_chnr_to_chspec(SOCIAL_CHAN_3);
+	}
+	err = brcmf_p2p_escan(p2p, channel_cnt, default_chan_list,
+			      WL_P2P_DISC_ST_SEARCH, WL_ESCAN_ACTION_START,
+			      P2PAPI_BSSCFG_DEVICE);
+	kfree(default_chan_list);
+exit:
+	return err;
+}
+
+
+/**
+ * brcmf_p2p_afx_handler() - afx worker thread.
+ *
+ * @work:
+ *
+ */
+static void brcmf_p2p_afx_handler(struct work_struct *work)
+{
+	struct afx_hdl *afx_hdl = container_of(work, struct afx_hdl, afx_work);
+	struct brcmf_p2p_info *p2p = container_of(afx_hdl,
+						  struct brcmf_p2p_info,
+						  afx_hdl);
+	s32 err;
+
+	if (!afx_hdl->is_active)
+		return;
+
+	if (afx_hdl->is_listen && afx_hdl->my_listen_chan)
+		/* 100ms ~ 300ms */
+		err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
+						100 * (1 + (random32() % 3)));
+	else
+		err = brcmf_p2p_act_frm_search(p2p, afx_hdl->peer_listen_chan);
+
+	if (err) {
+		brcmf_err("ERROR occurred! value is (%d)\n", err);
+		if (test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
+			     &p2p->status))
+			complete(&afx_hdl->act_frm_scan);
+	}
+}
+
+
+/**
+ * brcmf_p2p_af_searching_channel() - search channel.
+ *
+ * @p2p: p2p device info struct.
+ *
+ */
+static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
+{
+	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
+	struct brcmf_cfg80211_vif *pri_vif;
+	unsigned long duration;
+	s32 retry;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	pri_vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+
+	INIT_COMPLETION(afx_hdl->act_frm_scan);
+	set_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL, &p2p->status);
+	afx_hdl->is_active = true;
+	afx_hdl->peer_chan = P2P_INVALID_CHANNEL;
+
+	/* Loop to wait until we find a peer's channel or the
+	 * pending action frame tx is cancelled.
+	 */
+	retry = 0;
+	duration = msecs_to_jiffies(P2P_AF_FRM_SCAN_MAX_WAIT);
+	while ((retry < P2P_CHANNEL_SYNC_RETRY) &&
+	       (afx_hdl->peer_chan == P2P_INVALID_CHANNEL)) {
+		afx_hdl->is_listen = false;
+		brcmf_dbg(TRACE, "Scheduling action frame for sending.. (%d)\n",
+			  retry);
+		/* search peer on peer's listen channel */
+		schedule_work(&afx_hdl->afx_work);
+		wait_for_completion_timeout(&afx_hdl->act_frm_scan, duration);
+		if ((afx_hdl->peer_chan != P2P_INVALID_CHANNEL) ||
+		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
+			       &p2p->status)))
+			break;
+
+		if (afx_hdl->my_listen_chan) {
+			brcmf_dbg(TRACE, "Scheduling listen peer, channel=%d\n",
+				  afx_hdl->my_listen_chan);
+			/* listen on my listen channel */
+			afx_hdl->is_listen = true;
+			schedule_work(&afx_hdl->afx_work);
+			wait_for_completion_timeout(&afx_hdl->act_frm_scan,
+						    duration);
+		}
+		if ((afx_hdl->peer_chan != P2P_INVALID_CHANNEL) ||
+		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
+			       &p2p->status)))
+			break;
+		retry++;
+
+		/* if sta is connected or connecting, sleep for a while before
+		 * retry af tx or finding a peer
+		 */
+		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &pri_vif->sme_state) ||
+		    test_bit(BRCMF_VIF_STATUS_CONNECTING, &pri_vif->sme_state))
+			msleep(P2P_DEFAULT_SLEEP_TIME_VSDB);
+	}
+
+	brcmf_dbg(TRACE, "Completed search/listen peer_chan=%d\n",
+		  afx_hdl->peer_chan);
+	afx_hdl->is_active = false;
+
+	clear_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL, &p2p->status);
+
+	return afx_hdl->peer_chan;
+}
+
+
+/**
+ * brcmf_p2p_scan_finding_common_channel() - was escan used for finding channel
+ *
+ * @cfg: common configuration struct.
+ * @bi: bss info struct, result from scan.
+ *
+ */
+bool brcmf_p2p_scan_finding_common_channel(struct brcmf_cfg80211_info *cfg,
+					   struct brcmf_bss_info_le *bi)
+
+{
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
+	u8 *ie;
+	s32 err;
+	u8 p2p_dev_addr[ETH_ALEN];
+
+	if (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL, &p2p->status))
+		return false;
+
+	if (bi == NULL) {
+		brcmf_dbg(TRACE, "ACTION FRAME SCAN Done\n");
+		if (afx_hdl->peer_chan == P2P_INVALID_CHANNEL)
+			complete(&afx_hdl->act_frm_scan);
+		return true;
+	}
+
+	ie = ((u8 *)bi) + le16_to_cpu(bi->ie_offset);
+	memset(p2p_dev_addr, 0, sizeof(p2p_dev_addr));
+	err = cfg80211_get_p2p_attr(ie, le32_to_cpu(bi->ie_length),
+				    IEEE80211_P2P_ATTR_DEVICE_INFO,
+				    p2p_dev_addr, sizeof(p2p_dev_addr));
+	if (err < 0)
+		err = cfg80211_get_p2p_attr(ie, le32_to_cpu(bi->ie_length),
+					    IEEE80211_P2P_ATTR_DEVICE_ID,
+					    p2p_dev_addr, sizeof(p2p_dev_addr));
+	if ((err >= 0) &&
+	    (!memcmp(p2p_dev_addr, afx_hdl->tx_dst_addr, ETH_ALEN))) {
+		afx_hdl->peer_chan = bi->ctl_ch ? bi->ctl_ch :
+				      CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+		brcmf_dbg(TRACE, "ACTION FRAME SCAN : Peer %pM found, channel : %d\n",
+			  afx_hdl->tx_dst_addr, afx_hdl->peer_chan);
+		complete(&afx_hdl->act_frm_scan);
+	}
+	return true;
+}
+
+/**
+ * brcmf_p2p_stop_wait_next_action_frame() - finish scan if af tx complete.
+ *
+ * @cfg: common configuration struct.
+ *
+ */
+static void
+brcmf_p2p_stop_wait_next_action_frame(struct brcmf_cfg80211_info *cfg)
+{
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct net_device *ndev = cfg->escan_info.ndev;
+
+	if (test_bit(BRCMF_P2P_STATUS_SENDING_ACT_FRAME, &p2p->status) &&
+	    (test_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status) ||
+	     test_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status))) {
+		brcmf_dbg(TRACE, "*** Wake UP ** abort actframe iovar\n");
+		/* if channel is not zero, "actfame" uses off channel scan.
+		 * So abort scan for off channel completion.
+		 */
+		if (p2p->af_sent_channel)
+			brcmf_notify_escan_complete(cfg, ndev, true, true);
+	} else if (test_bit(BRCMF_P2P_STATUS_WAITING_NEXT_AF_LISTEN,
+			    &p2p->status)) {
+		brcmf_dbg(TRACE, "*** Wake UP ** abort listen for next af frame\n");
+		/* So abort scan to cancel listen */
+		brcmf_notify_escan_complete(cfg, ndev, true, true);
+	}
+}
+
+
+/**
+ * brcmf_p2p_gon_req_collision() - Check if go negotiaton collission
+ *
+ * @p2p: p2p device info struct.
+ *
+ * return true if recevied action frame is to be dropped.
+ */
+static bool
+brcmf_p2p_gon_req_collision(struct brcmf_p2p_info *p2p, u8 *mac)
+{
+	struct brcmf_cfg80211_info *cfg = p2p->cfg;
+	struct brcmf_if *ifp;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (!test_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME, &p2p->status) ||
+	    !p2p->gon_req_action)
+		return false;
+
+	brcmf_dbg(TRACE, "GO Negotiation Request COLLISION !!!\n");
+	/* if sa(peer) addr is less than da(my) addr, then this device
+	 * process peer's gon request and block to send gon req.
+	 * if not (sa addr > da addr),
+	 * this device will process gon request and drop gon req of peer.
+	 */
+	ifp = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->ifp;
+	if (memcmp(mac, ifp->mac_addr, ETH_ALEN) < 0) {
+		brcmf_dbg(INFO, "Block transmit gon req !!!\n");
+		p2p->block_gon_req_tx = true;
+		/* if we are finding a common channel for sending af,
+		 * do not scan more to block to send current gon req
+		 */
+		if (test_and_clear_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
+				       &p2p->status))
+			complete(&p2p->afx_hdl.act_frm_scan);
+		if (test_and_clear_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME,
+				       &p2p->status))
+			brcmf_p2p_stop_wait_next_action_frame(cfg);
+		return false;
+	}
+
+	/* drop gon request of peer to process gon request by this device. */
+	brcmf_dbg(INFO, "Drop received gon req !!!\n");
+
+	return true;
+}
+
+
+/**
  * brcmf_p2p_notify_action_frame_rx() - received action frame.
  *
  * @ifp: interfac control.
@@ -985,14 +1341,20 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 				     const struct brcmf_event_msg *e,
 				     void *data)
 {
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
 	struct wireless_dev *wdev;
 	u32 mgmt_frame_len = e->datalen - sizeof(struct brcmf_rx_mgmt_data);
 	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
+	u8 *frame = (u8 *)(rxframe + 1);
+	struct brcmf_p2p_pub_act_frame *act_frm;
+	struct brcmf_p2psd_gas_pub_act_frame *sd_act_frm;
 	u16 chanspec = be16_to_cpu(rxframe->chanspec);
 	struct ieee80211_mgmt *mgmt_frame;
-	s32 err;
 	s32 freq;
 	u16 mgmt_type;
+	u8 action;
 
 	/* Check if wpa_supplicant has registered for this frame */
 	brcmf_dbg(INFO, "ifp->vif->mgmt_rx_reg %04x\n", ifp->vif->mgmt_rx_reg);
@@ -1000,7 +1362,46 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 	if ((ifp->vif->mgmt_rx_reg & BIT(mgmt_type)) == 0)
 		return 0;
 
-	brcmf_p2p_print_actframe(false, (u8 *)(rxframe + 1), mgmt_frame_len);
+	brcmf_p2p_print_actframe(false, frame, mgmt_frame_len);
+
+	action = P2P_PAF_SUBTYPE_INVALID;
+	if (brcmf_p2p_is_pub_action(frame, mgmt_frame_len)) {
+		act_frm = (struct brcmf_p2p_pub_act_frame *)frame;
+		action = act_frm->subtype;
+		if ((action == P2P_PAF_GON_REQ) &&
+		    (brcmf_p2p_gon_req_collision(p2p, (u8 *)e->addr))) {
+			if (test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
+				     &p2p->status) &&
+			    (memcmp(afx_hdl->tx_dst_addr, e->addr,
+				    ETH_ALEN) == 0)) {
+				afx_hdl->peer_chan = CHSPEC_CHANNEL(chanspec);
+				brcmf_dbg(INFO, "GON request: Peer found, channel=%d\n",
+					  afx_hdl->peer_chan);
+				complete(&afx_hdl->act_frm_scan);
+			}
+			return 0;
+		}
+		/* After complete GO Negotiation, roll back to mpc mode */
+		if ((action == P2P_PAF_GON_CONF) ||
+		    (action == P2P_PAF_PROVDIS_RSP))
+			brcmf_set_mpc(ifp->ndev, 1);
+		if (action == P2P_PAF_GON_CONF) {
+			brcmf_dbg(TRACE, "P2P: GO_NEG_PHASE status cleared\n");
+			clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
+		}
+	} else if (brcmf_p2p_is_gas_action(frame, mgmt_frame_len)) {
+		sd_act_frm = (struct brcmf_p2psd_gas_pub_act_frame *)frame;
+		action = sd_act_frm->action;
+	}
+
+	if (test_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME, &p2p->status) &&
+	    (p2p->next_af_subtype == action)) {
+		brcmf_dbg(TRACE, "We got a right next frame! (%d)\n", action);
+		clear_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME,
+			  &p2p->status);
+		/* Stop waiting for next AF. */
+		brcmf_p2p_stop_wait_next_action_frame(cfg);
+	}
 
 	mgmt_frame = kzalloc(offsetof(struct ieee80211_mgmt, u) +
 			     mgmt_frame_len, GFP_KERNEL);
@@ -1009,13 +1410,11 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 		return -ENOMEM;
 	}
 	memcpy(mgmt_frame->da, ifp->mac_addr, ETH_ALEN);
-	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSSID, mgmt_frame->bssid,
-				     ETH_ALEN);
-	if (err < 0)
-		brcmf_err("BRCMF_C_GET_BSSID error %d\n", err);
+	brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSSID, mgmt_frame->bssid,
+			       ETH_ALEN);
 	memcpy(mgmt_frame->sa, e->addr, ETH_ALEN);
 	mgmt_frame->frame_control = cpu_to_le16(IEEE80211_STYPE_ACTION);
-	memcpy(&mgmt_frame->u, (u8 *)(rxframe + 1), mgmt_frame_len);
+	memcpy(&mgmt_frame->u, frame, mgmt_frame_len);
 	mgmt_frame_len += offsetof(struct ieee80211_mgmt, u);
 
 	freq = ieee80211_channel_to_frequency(CHSPEC_CHANNEL(chanspec),
@@ -1046,15 +1445,29 @@ int brcmf_p2p_notify_action_tx_complete(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 
-	brcmf_dbg(INFO, "Enter: status %d\n", e->status);
+	brcmf_dbg(INFO, "Enter: event %s, status=%d\n",
+		  e->event_code == BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE ?
+		  "ACTION_FRAME_OFF_CHAN_COMPLETE" : "ACTION_FRAME_COMPLETE",
+		  e->status);
 
-	if (e->status == BRCMF_E_STATUS_SUCCESS)
-		set_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
-	else
-		set_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
-	/* for now complete the receiver process here !! */
-	complete(&p2p->send_af_done);
+	if (!test_bit(BRCMF_P2P_STATUS_SENDING_ACT_FRAME, &p2p->status))
+		return 0;
+
+	if (e->event_code == BRCMF_E_ACTION_FRAME_COMPLETE) {
+		if (e->status == BRCMF_E_STATUS_SUCCESS)
+			set_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED,
+				&p2p->status);
+		else {
+			set_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
+			/* If there is no ack, we don't need to wait for
+			 * WLC_E_ACTION_FRAME_OFFCHAN_COMPLETE event
+			 */
+			brcmf_p2p_stop_wait_next_action_frame(cfg);
+		}
 
+	} else {
+		complete(&p2p->send_af_done);
+	}
 	return 0;
 }
 
@@ -1080,6 +1493,7 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
+	INIT_COMPLETION(p2p->send_af_done);
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
 
@@ -1091,6 +1505,9 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 		goto exit;
 	}
 
+	p2p->af_sent_channel = le32_to_cpu(af_params->channel);
+	p2p->af_tx_sent_jiffies = jiffies;
+
 	timeout = wait_for_completion_timeout(&p2p->send_af_done,
 					msecs_to_jiffies(P2P_AF_MAX_WAIT_TIME));
 
@@ -1126,16 +1543,21 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_p2p_pub_act_frame *act_frm;
 	s32 err = 0;
+	u16 ie_len;
 
 	action_frame = &af_params->action_frame;
 	act_frm = (struct brcmf_p2p_pub_act_frame *)(action_frame->data);
 
+	config_af_params->extra_listen = true;
+
 	switch (act_frm->subtype) {
 	case P2P_PAF_GON_REQ:
 		brcmf_dbg(TRACE, "P2P: GO_NEG_PHASE status set\n");
 		set_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
 		config_af_params->mpc_onoff = 0;
+		config_af_params->search_channel = true;
 		p2p->next_af_subtype = act_frm->subtype + 1;
+		p2p->gon_req_action = true;
 		/* increase dwell time to wait for RESP frame */
 		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
 		break;
@@ -1152,8 +1574,10 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 		config_af_params->mpc_onoff = 1;
 		/* minimize dwell time */
 		af_params->dwell_time = cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
+		config_af_params->extra_listen = false;
 		break;
 	case P2P_PAF_INVITE_REQ:
+		config_af_params->search_channel = true;
 		p2p->next_af_subtype = act_frm->subtype + 1;
 		/* increase dwell time */
 		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
@@ -1161,8 +1585,10 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 	case P2P_PAF_INVITE_RSP:
 		/* minimize dwell time */
 		af_params->dwell_time = cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
+		config_af_params->extra_listen = false;
 		break;
 	case P2P_PAF_DEVDIS_REQ:
+		config_af_params->search_channel = true;
 		p2p->next_af_subtype = act_frm->subtype + 1;
 		/* maximize dwell time to wait for RESP frame */
 		af_params->dwell_time = cpu_to_le32(P2P_AF_LONG_DWELL_TIME);
@@ -1170,8 +1596,15 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 	case P2P_PAF_DEVDIS_RSP:
 		/* minimize dwell time */
 		af_params->dwell_time = cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
+		config_af_params->extra_listen = false;
 		break;
 	case P2P_PAF_PROVDIS_REQ:
+		ie_len = le16_to_cpu(action_frame->len) -
+			 offsetof(struct brcmf_p2p_pub_act_frame, elts);
+		if (cfg80211_get_p2p_attr(&act_frm->elts[0], ie_len,
+					  IEEE80211_P2P_ATTR_GROUP_ID,
+					  NULL, 0) < 0)
+			config_af_params->search_channel = true;
 		config_af_params->mpc_onoff = 0;
 		p2p->next_af_subtype = act_frm->subtype + 1;
 		/* increase dwell time to wait for RESP frame */
@@ -1182,6 +1615,7 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 		p2p->next_af_subtype = P2P_PAF_GON_REQ;
 		/* increase dwell time to MED level */
 		af_params->dwell_time = cpu_to_le32(P2P_AF_MED_DWELL_TIME);
+		config_af_params->extra_listen = false;
 		break;
 	default:
 		brcmf_err("Unknown p2p pub act frame subtype: %d\n",
@@ -1205,11 +1639,14 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_config_af_params config_af_params;
+	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
 	u16 action_frame_len;
 	bool ack = false;
 	u8 category;
 	u8 action;
 	s32 tx_retry;
+	s32 extra_listen_time;
+	uint delta_ms;
 
 	action_frame = &af_params->action_frame;
 	action_frame_len = le16_to_cpu(action_frame->len);
@@ -1226,10 +1663,12 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 
 	/* initialize variables */
 	p2p->next_af_subtype = P2P_PAF_SUBTYPE_INVALID;
+	p2p->gon_req_action = false;
 
 	/* config parameters */
-	config_af_params.max_tx_retry = P2P_AF_TX_MAX_RETRY;
 	config_af_params.mpc_onoff = -1;
+	config_af_params.search_channel = false;
+	config_af_params.extra_listen = false;
 
 	if (brcmf_p2p_is_pub_action(action_frame->data, action_frame_len)) {
 		/* p2p public action frame process */
@@ -1243,6 +1682,9 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		/* service discovery process */
 		if (action == P2PSD_ACTION_ID_GAS_IREQ ||
 		    action == P2PSD_ACTION_ID_GAS_CREQ) {
+			/* configure service discovery query frame */
+			config_af_params.search_channel = true;
+
 			/* save next af suptype to cancel */
 			/* remaining dwell time           */
 			p2p->next_af_subtype = action + 1;
@@ -1268,24 +1710,114 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		return false;
 	}
 
+	/* if connecting on primary iface, sleep for a while before sending
+	 * af tx for VSDB
+	 */
+	if (test_bit(BRCMF_VIF_STATUS_CONNECTING,
+		     &p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->sme_state))
+		msleep(50);
+
 	/* if scan is ongoing, abort current scan. */
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
 		brcmf_abort_scanning(cfg);
 
+	memcpy(afx_hdl->tx_dst_addr, action_frame->da, ETH_ALEN);
+
 	/* To make sure to send successfully action frame, turn off mpc */
 	if (config_af_params.mpc_onoff == 0)
 		brcmf_set_mpc(ndev, 0);
 
-	/* if failed, retry it. tx_retry_max value is configure by .... */
+	/* set status and destination address before sending af */
+	if (p2p->next_af_subtype != P2P_PAF_SUBTYPE_INVALID) {
+		/* set status to cancel the remained dwell time in rx process */
+		set_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME, &p2p->status);
+	}
+
+	p2p->af_sent_channel = 0;
+	set_bit(BRCMF_P2P_STATUS_SENDING_ACT_FRAME, &p2p->status);
+	/* validate channel and p2p ies */
+	if (config_af_params.search_channel &&
+	    IS_P2P_SOCIAL_CHANNEL(le32_to_cpu(af_params->channel)) &&
+	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->saved_ie.probe_req_ie_len) {
+		afx_hdl = &p2p->afx_hdl;
+		afx_hdl->peer_listen_chan = le32_to_cpu(af_params->channel);
+
+		if (brcmf_p2p_af_searching_channel(p2p) ==
+							P2P_INVALID_CHANNEL) {
+			brcmf_err("Couldn't find peer's channel.\n");
+			goto exit;
+		}
+
+		/* Abort scan even for VSDB scenarios. Scan gets aborted in
+		 * firmware but after the check of piggyback algorithm. To take
+		 * care of current piggback algo, lets abort the scan here
+		 * itself.
+		 */
+		brcmf_notify_escan_complete(cfg, ndev, true, true);
+
+		/* update channel */
+		af_params->channel = cpu_to_le32(afx_hdl->peer_chan);
+	}
+
 	tx_retry = 0;
-	while ((ack == false) && (tx_retry < config_af_params.max_tx_retry)) {
+	while (!p2p->block_gon_req_tx &&
+	       (ack == false) && (tx_retry < P2P_AF_TX_MAX_RETRY)) {
 		ack = !brcmf_p2p_tx_action_frame(p2p, af_params);
 		tx_retry++;
 	}
-	if (ack == false)
+	if (ack == false) {
 		brcmf_err("Failed to send Action Frame(retry %d)\n", tx_retry);
+		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
+	}
 
 exit:
+	clear_bit(BRCMF_P2P_STATUS_SENDING_ACT_FRAME, &p2p->status);
+
+	/* WAR: sometimes dongle does not keep the dwell time of 'actframe'.
+	 * if we coundn't get the next action response frame and dongle does
+	 * not keep the dwell time, go to listen state again to get next action
+	 * response frame.
+	 */
+	if (ack && config_af_params.extra_listen && !p2p->block_gon_req_tx &&
+	    test_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME, &p2p->status) &&
+	    p2p->af_sent_channel == afx_hdl->my_listen_chan) {
+		delta_ms = jiffies_to_msecs(jiffies - p2p->af_tx_sent_jiffies);
+		if (le32_to_cpu(af_params->dwell_time) > delta_ms)
+			extra_listen_time = le32_to_cpu(af_params->dwell_time) -
+					    delta_ms;
+		else
+			extra_listen_time = 0;
+		if (extra_listen_time > 50) {
+			set_bit(BRCMF_P2P_STATUS_WAITING_NEXT_AF_LISTEN,
+				&p2p->status);
+			brcmf_dbg(INFO, "Wait more time! actual af time:%d, calculated extra listen:%d\n",
+				  le32_to_cpu(af_params->dwell_time),
+				  extra_listen_time);
+			extra_listen_time += 100;
+			if (!brcmf_p2p_discover_listen(p2p,
+						       p2p->af_sent_channel,
+						       extra_listen_time)) {
+				unsigned long duration;
+
+				extra_listen_time += 100;
+				duration = msecs_to_jiffies(extra_listen_time);
+				wait_for_completion_timeout(&p2p->wait_next_af,
+							    duration);
+			}
+			clear_bit(BRCMF_P2P_STATUS_WAITING_NEXT_AF_LISTEN,
+				  &p2p->status);
+		}
+	}
+
+	if (p2p->block_gon_req_tx) {
+		/* if ack is true, supplicant will wait more time(100ms).
+		 * so we will return it as a success to get more time .
+		 */
+		p2p->block_gon_req_tx = false;
+		ack = true;
+	}
+
+	clear_bit(BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME, &p2p->status);
 	/* if all done, turn mpc on again */
 	if (config_af_params.mpc_onoff == 1)
 		brcmf_set_mpc(ndev, 1);
@@ -1293,6 +1825,72 @@ exit:
 	return ack;
 }
 
+/**
+ * brcmf_p2p_notify_rx_mgmt_p2p_probereq() - Event handler for p2p probe req.
+ *
+ * @ifp: interface pointer for which event was received.
+ * @e: even message.
+ * @data: payload of event message (probe request).
+ */
+s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
+					  const struct brcmf_event_msg *e,
+					  void *data)
+{
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
+	struct wireless_dev *wdev;
+	struct brcmf_cfg80211_vif *vif = ifp->vif;
+	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
+	u16 chanspec = be16_to_cpu(rxframe->chanspec);
+	u8 *mgmt_frame;
+	u32 mgmt_frame_len;
+	s32 freq;
+	u16 mgmt_type;
+
+	brcmf_dbg(INFO, "Enter: event %d reason %d\n", e->event_code,
+		  e->reason);
+
+	if (test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL, &p2p->status) &&
+	    (memcmp(afx_hdl->tx_dst_addr, e->addr, ETH_ALEN) == 0)) {
+		afx_hdl->peer_chan = CHSPEC_CHANNEL(chanspec);
+		brcmf_dbg(INFO, "PROBE REQUEST: Peer found, channel=%d\n",
+			  afx_hdl->peer_chan);
+		complete(&afx_hdl->act_frm_scan);
+	}
+
+	/* Firmware sends us two proberesponses for each idx one. At the */
+	/* moment anything but bsscfgidx 0 is passed up to supplicant    */
+	if (e->bsscfgidx == 0)
+		return 0;
+
+	/* Filter any P2P probe reqs arriving during the GO-NEG Phase */
+	if (test_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status)) {
+		brcmf_dbg(INFO, "Filtering P2P probe_req in GO-NEG phase\n");
+		return 0;
+	}
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
+	brcmf_dbg(INFO, "mgmt_frame_len (%d) , e->datalen (%d), chanspec (%04x), freq (%d)\n",
+		  mgmt_frame_len, e->datalen, chanspec, freq);
+
+	return 0;
+}
+
 
 /**
  * brcmf_p2p_attach() - attach for P2P.
@@ -1362,6 +1960,9 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 		}
 
 		init_completion(&p2p->send_af_done);
+		INIT_WORK(&p2p->afx_hdl.afx_work, brcmf_p2p_afx_handler);
+		init_completion(&p2p->afx_hdl.act_frm_scan);
+		init_completion(&p2p->wait_next_af);
 	}
 exit:
 	return err;
@@ -1622,6 +2223,7 @@ fail:
 int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct brcmf_cfg80211_vif *vif;
 	unsigned long jiffie_timeout = msecs_to_jiffies(1500);
 	bool wait_for_disable = false;
@@ -1647,6 +2249,9 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 		break;
 	}
 
+	clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
+	brcmf_dbg(INFO, "P2P: GO_NEG_PHASE status cleared\n");
+
 	if (wait_for_disable)
 		wait_for_completion_timeout(&cfg->vif_disabled,
 					    msecs_to_jiffies(500));
@@ -1666,7 +2271,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	}
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	brcmf_free_vif(vif);
-	cfg->p2p.bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
+	p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
 
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 9e0e962..6821b26 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -58,6 +58,10 @@ struct p2p_bss {
  * @BRCMF_P2P_STATUS_ACTION_TX_NOACK: action frame tx not acked.
  * @BRCMF_P2P_STATUS_GO_NEG_PHASE: P2P GO negotiation ongoing.
  * @BRCMF_P2P_STATUS_DISCOVER_LISTEN: P2P listen, remaining on channel.
+ * @BRCMF_P2P_STATUS_SENDING_ACT_FRAME: In the process of sending action frame.
+ * @BRCMF_P2P_STATUS_WAITING_NEXT_AF_LISTEN: extra listen time for af tx.
+ * @BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME: waiting for action frame response.
+ * @BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL: search channel for AF active.
  */
 enum brcmf_p2p_status {
 	BRCMF_P2P_STATUS_ENABLED,
@@ -69,7 +73,34 @@ enum brcmf_p2p_status {
 	BRCMF_P2P_STATUS_ACTION_TX_COMPLETED,
 	BRCMF_P2P_STATUS_ACTION_TX_NOACK,
 	BRCMF_P2P_STATUS_GO_NEG_PHASE,
-	BRCMF_P2P_STATUS_DISCOVER_LISTEN
+	BRCMF_P2P_STATUS_DISCOVER_LISTEN,
+	BRCMF_P2P_STATUS_SENDING_ACT_FRAME,
+	BRCMF_P2P_STATUS_WAITING_NEXT_AF_LISTEN,
+	BRCMF_P2P_STATUS_WAITING_NEXT_ACT_FRAME,
+	BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL
+};
+
+/**
+ * struct afx_hdl - action frame off channel storage.
+ *
+ * @afx_work: worker thread for searching channel
+ * @act_frm_scan: thread synchronizing struct.
+ * @is_active: channel searching active.
+ * @peer_chan: current channel.
+ * @is_listen: sets mode for afx worker.
+ * @my_listen_chan: this peers listen channel.
+ * @peer_listen_chan: remote peers listen channel.
+ * @tx_dst_addr: mac address where tx af should be sent to.
+ */
+struct afx_hdl {
+	struct work_struct afx_work;
+	struct completion act_frm_scan;
+	bool is_active;
+	s32 peer_chan;
+	bool is_listen;
+	u16 my_listen_chan;
+	u16 peer_listen_chan;
+	u8 tx_dst_addr[ETH_ALEN];
 };
 
 /**
@@ -87,6 +118,12 @@ enum brcmf_p2p_status {
  * @remain_on_channel_cookie: cookie counter for remain on channel cmd
  * @next_af_subtype: expected action frame subtype.
  * @send_af_done: indication that action frame tx is complete.
+ * @afx_hdl: action frame search handler info.
+ * @af_sent_channel: channel action frame is sent.
+ * @af_tx_sent_jiffies: jiffies time when af tx was transmitted.
+ * @wait_next_af: thread synchronizing struct.
+ * @gon_req_action: about to send go negotiation requets frame.
+ * @block_gon_req_tx: drop tx go negotiation requets frame.
  */
 struct brcmf_p2p_info {
 	struct brcmf_cfg80211_info *cfg;
@@ -101,6 +138,12 @@ struct brcmf_p2p_info {
 	u32 remain_on_channel_cookie;
 	u8 next_af_subtype;
 	struct completion send_af_done;
+	struct afx_hdl afx_hdl;
+	u32 af_sent_channel;
+	unsigned long af_tx_sent_jiffies;
+	struct completion wait_next_af;
+	bool gon_req_action;
+	bool block_gon_req_tx;
 };
 
 s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg);
@@ -132,5 +175,9 @@ int brcmf_p2p_notify_action_tx_complete(struct brcmf_if *ifp,
 bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 				 struct net_device *ndev,
 				 struct brcmf_fil_af_params_le *af_params);
-
+bool brcmf_p2p_scan_finding_common_channel(struct brcmf_cfg80211_info *cfg,
+					   struct brcmf_bss_info_le *bi);
+s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
+					  const struct brcmf_event_msg *e,
+					  void *data);
 #endif /* WL_CFGP2P_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b5cc154..481f41a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -601,10 +601,8 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		cfg80211_scan_done(scan_request, aborted);
 		brcmf_set_mpc(ndev, 1);
 	}
-	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("Scan complete while device not scanning\n");
-		return -EPERM;
-	}
+	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
+		brcmf_dbg(SCAN, "Scan complete, probably P2P scan\n");
 
 	return err;
 }
@@ -2525,8 +2523,7 @@ static void brcmf_cfg80211_escan_timeout_worker(struct work_struct *work)
 			container_of(work, struct brcmf_cfg80211_info,
 				     escan_timeout_work);
 
-	brcmf_notify_escan_complete(cfg,
-		cfg->escan_info.ndev, true, true);
+	brcmf_notify_escan_complete(cfg, cfg->escan_info.ndev, true, true);
 }
 
 static void brcmf_escan_timeout(unsigned long data)
@@ -2603,11 +2600,6 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			brcmf_err("Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
-		if (!cfg->scan_request) {
-			brcmf_dbg(SCAN, "result without cfg80211 request\n");
-			goto exit;
-		}
-
 		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
 			brcmf_err("Invalid bss_count %d: ignoring\n",
 				  escan_result_le->bss_count);
@@ -2615,6 +2607,14 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		}
 		bss_info_le = &escan_result_le->bss_info_le;
 
+		if (brcmf_p2p_scan_finding_common_channel(cfg, bss_info_le))
+			goto exit;
+
+		if (!cfg->scan_request) {
+			brcmf_dbg(SCAN, "result without cfg80211 request\n");
+			goto exit;
+		}
+
 		bi_length = le32_to_cpu(bss_info_le->length);
 		if (bi_length != (le32_to_cpu(escan_result_le->buflen) -
 					WL_ESCAN_RESULTS_FIXED_SIZE)) {
@@ -2653,6 +2653,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		list->count++;
 	} else {
 		cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+		if (brcmf_p2p_scan_finding_common_channel(cfg, NULL))
+			goto exit;
 		if (cfg->scan_request) {
 			cfg->bss_list = (struct brcmf_scan_results *)
 				cfg->escan_info.escan_buf;
@@ -2661,7 +2663,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			brcmf_notify_escan_complete(cfg, ndev, aborted,
 						    false);
 		} else
-			brcmf_err("Unexpected scan result 0x%x\n", status);
+			brcmf_dbg(SCAN, "Ignored scan complete result 0x%x\n",
+				  status);
 	}
 exit:
 	return err;
@@ -4038,50 +4041,6 @@ exit:
 	return err;
 }
 
-static s32 brcmf_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
-					     const struct brcmf_event_msg *e,
-					     void *data)
-{
-	struct wireless_dev *wdev;
-	struct brcmf_cfg80211_vif *vif = ifp->vif;
-	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
-	u16 chanspec = be16_to_cpu(rxframe->chanspec);
-	u8 *mgmt_frame;
-	u32 mgmt_frame_len;
-	s32 freq;
-	u16 mgmt_type;
-
-	brcmf_dbg(INFO,
-		  "Enter: event %d reason %d\n", e->event_code, e->reason);
-
-	/* Firmware sends us two proberesponses for each idx one. At the */
-	/* moment anything but bsscfgidx 0 is passed up to supplicant    */
-	if (e->bsscfgidx == 0)
-		return 0;
-
-	/* Check if wpa_supplicant has registered for this frame */
-	brcmf_dbg(INFO, "vif->mgmt_rx_reg %04x\n", vif->mgmt_rx_reg);
-	mgmt_type = (IEEE80211_STYPE_PROBE_REQ & IEEE80211_FCTL_STYPE) >> 4;
-	if ((vif->mgmt_rx_reg & BIT(mgmt_type)) == 0)
-		return 0;
-
-	mgmt_frame = (u8 *)(rxframe + 1);
-	mgmt_frame_len = e->datalen - sizeof(*rxframe);
-	freq = ieee80211_channel_to_frequency(CHSPEC_CHANNEL(chanspec),
-					      CHSPEC_IS2G(chanspec) ?
-					      IEEE80211_BAND_2GHZ :
-					      IEEE80211_BAND_5GHZ);
-	wdev = ifp->ndev->ieee80211_ptr;
-	cfg80211_rx_mgmt(wdev, freq, 0, mgmt_frame, mgmt_frame_len, GFP_ATOMIC);
-
-	brcmf_dbg(INFO,
-		  "mgmt_frame_len (%d) , e->datalen (%d), chanspec (%04x), freq (%d)\n",
-		  mgmt_frame_len, e->datalen, chanspec, freq);
-
-	return 0;
-}
-
-
 static struct cfg80211_ops wl_cfg80211_ops = {
 	.add_virtual_intf = brcmf_cfg80211_add_iface,
 	.del_virtual_intf = brcmf_cfg80211_del_iface,
@@ -4240,6 +4199,7 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
 	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
+			WIPHY_FLAG_OFFCHAN_TX |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
@@ -4721,13 +4681,15 @@ static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
 	brcmf_fweh_register(cfg->pub, BRCMF_E_IF,
 			    brcmf_notify_vif_event);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_P2P_PROBEREQ_MSG,
-			    brcmf_notify_rx_mgmt_p2p_probereq);
+			    brcmf_p2p_notify_rx_mgmt_p2p_probereq);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_P2P_DISC_LISTEN_COMPLETE,
 			    brcmf_p2p_notify_listen_complete);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_ACTION_FRAME_RX,
 			    brcmf_p2p_notify_action_frame_rx);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_ACTION_FRAME_COMPLETE,
 			    brcmf_p2p_notify_action_tx_complete);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE,
+			    brcmf_p2p_notify_action_tx_complete);
 }
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
-- 
1.7.10.4



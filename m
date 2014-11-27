Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49759 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbaK0JXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 04:23:49 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so7614066wiv.7
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 01:23:48 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/7] ath10k: implement intermediate event args
Date: Thu, 27 Nov 2014 10:11:18 +0100
Message-Id: <1417079481-22255-5-git-send-email-michal.kazior@tieto.com> (sfid-20141127_102405_497613_AB309BBA)
In-Reply-To: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
References: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits the actual event parsing into
intermediary structures to facilitate future
support of vastly different ABI WMI backends.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 383 +++++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/wmi.h |  60 +++++-
 2 files changed, 347 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c0f3e4d..4a9468e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -977,22 +977,48 @@ ath10k_wmi_event_scan_type_str(enum wmi_scan_event_type type,
 	}
 }
 
+static int ath10k_wmi_pull_scan_ev(struct sk_buff *skb,
+				   struct wmi_scan_ev_arg *arg)
+{
+	struct wmi_scan_event *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->event_type = ev->event_type;
+	arg->reason = ev->reason;
+	arg->channel_freq = ev->channel_freq;
+	arg->scan_req_id = ev->scan_req_id;
+	arg->scan_id = ev->scan_id;
+	arg->vdev_id = ev->vdev_id;
+
+	return 0;
+}
+
 static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_scan_event *event = (struct wmi_scan_event *)skb->data;
+	struct wmi_scan_ev_arg arg = {};
 	enum wmi_scan_event_type event_type;
 	enum wmi_scan_completion_reason reason;
 	u32 freq;
 	u32 req_id;
 	u32 scan_id;
 	u32 vdev_id;
+	int ret;
 
-	event_type = __le32_to_cpu(event->event_type);
-	reason     = __le32_to_cpu(event->reason);
-	freq       = __le32_to_cpu(event->channel_freq);
-	req_id     = __le32_to_cpu(event->scan_req_id);
-	scan_id    = __le32_to_cpu(event->scan_id);
-	vdev_id    = __le32_to_cpu(event->vdev_id);
+	ret = ath10k_wmi_pull_scan_ev(skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse scan event: %d\n", ret);
+		return ret;
+	}
+
+	event_type = __le32_to_cpu(arg.event_type);
+	reason = __le32_to_cpu(arg.reason);
+	freq = __le32_to_cpu(arg.channel_freq);
+	req_id = __le32_to_cpu(arg.scan_req_id);
+	scan_id = __le32_to_cpu(arg.scan_id);
+	vdev_id = __le32_to_cpu(arg.vdev_id);
 
 	spin_lock_bh(&ar->data_lock);
 
@@ -1147,11 +1173,52 @@ static void ath10k_wmi_handle_wep_reauth(struct ath10k *ar,
 	}
 }
 
-static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
+static int ath10k_wmi_pull_mgmt_rx_ev(struct sk_buff *skb,
+				      struct wmi_mgmt_rx_ev_arg *arg,
+				      struct ath10k *ar)
 {
 	struct wmi_mgmt_rx_event_v1 *ev_v1;
 	struct wmi_mgmt_rx_event_v2 *ev_v2;
 	struct wmi_mgmt_rx_hdr_v1 *ev_hdr;
+	size_t pull_len;
+	u32 msdu_len;
+
+	if (test_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features)) {
+		ev_v2 = (struct wmi_mgmt_rx_event_v2 *)skb->data;
+		ev_hdr = &ev_v2->hdr.v1;
+		pull_len = sizeof(*ev_v2);
+	} else {
+		ev_v1 = (struct wmi_mgmt_rx_event_v1 *)skb->data;
+		ev_hdr = &ev_v1->hdr;
+		pull_len = sizeof(*ev_v1);
+	}
+
+	if (skb->len < pull_len)
+		return -EPROTO;
+
+	skb_pull(skb, pull_len);
+	arg->channel = ev_hdr->channel;
+	arg->buf_len = ev_hdr->buf_len;
+	arg->status = ev_hdr->status;
+	arg->snr = ev_hdr->snr;
+	arg->phy_mode = ev_hdr->phy_mode;
+	arg->rate = ev_hdr->rate;
+
+	msdu_len = __le32_to_cpu(arg->buf_len);
+	if (skb->len < msdu_len)
+		return -EPROTO;
+
+	/* the WMI buffer might've ended up being padded to 4 bytes due to HTC
+	 * trailer with credit update. Trim the excess garbage.
+	 */
+	skb_trim(skb, msdu_len);
+
+	return 0;
+}
+
+static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct wmi_mgmt_rx_ev_arg arg = {};
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr;
 	u32 rx_status;
@@ -1161,24 +1228,20 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	u32 rate;
 	u32 buf_len;
 	u16 fc;
-	int pull_len;
+	int ret;
 
-	if (test_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features)) {
-		ev_v2 = (struct wmi_mgmt_rx_event_v2 *)skb->data;
-		ev_hdr = &ev_v2->hdr.v1;
-		pull_len = sizeof(*ev_v2);
-	} else {
-		ev_v1 = (struct wmi_mgmt_rx_event_v1 *)skb->data;
-		ev_hdr = &ev_v1->hdr;
-		pull_len = sizeof(*ev_v1);
+	ret = ath10k_wmi_pull_mgmt_rx_ev(skb, &arg, ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse mgmt rx event: %d\n", ret);
+		return ret;
 	}
 
-	channel   = __le32_to_cpu(ev_hdr->channel);
-	buf_len   = __le32_to_cpu(ev_hdr->buf_len);
-	rx_status = __le32_to_cpu(ev_hdr->status);
-	snr       = __le32_to_cpu(ev_hdr->snr);
-	phy_mode  = __le32_to_cpu(ev_hdr->phy_mode);
-	rate	  = __le32_to_cpu(ev_hdr->rate);
+	channel = __le32_to_cpu(arg.channel);
+	buf_len = __le32_to_cpu(arg.buf_len);
+	rx_status = __le32_to_cpu(arg.status);
+	snr = __le32_to_cpu(arg.snr);
+	phy_mode = __le32_to_cpu(arg.phy_mode);
+	rate = __le32_to_cpu(arg.rate);
 
 	memset(status, 0, sizeof(*status));
 
@@ -1232,8 +1295,6 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	status->signal = snr + ATH10K_DEFAULT_NOISE_FLOOR;
 	status->rate_idx = get_rate_idx(rate, status->band);
 
-	skb_pull(skb, pull_len);
-
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
 
@@ -1266,12 +1327,6 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
 
-	/*
-	 * packets from HTC come aligned to 4byte boundaries
-	 * because they can originally come in along with a trailer
-	 */
-	skb_trim(skb, buf_len);
-
 	ieee80211_rx(ar->hw, skb);
 	return 0;
 }
@@ -1295,21 +1350,44 @@ exit:
 	return idx;
 }
 
+static int ath10k_wmi_pull_ch_info_ev(struct sk_buff *skb,
+				      struct wmi_ch_info_ev_arg *arg)
+{
+	struct wmi_chan_info_event *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->err_code = ev->err_code;
+	arg->freq = ev->freq;
+	arg->cmd_flags = ev->cmd_flags;
+	arg->noise_floor = ev->noise_floor;
+	arg->rx_clear_count = ev->rx_clear_count;
+	arg->cycle_count = ev->cycle_count;
+
+	return 0;
+}
+
 static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_chan_info_event *ev;
+	struct wmi_ch_info_ev_arg arg = {};
 	struct survey_info *survey;
 	u32 err_code, freq, cmd_flags, noise_floor, rx_clear_count, cycle_count;
-	int idx;
+	int idx, ret;
 
-	ev = (struct wmi_chan_info_event *)skb->data;
+	ret = ath10k_wmi_pull_ch_info_ev(skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse chan info event: %d\n", ret);
+		return;
+	}
 
-	err_code = __le32_to_cpu(ev->err_code);
-	freq = __le32_to_cpu(ev->freq);
-	cmd_flags = __le32_to_cpu(ev->cmd_flags);
-	noise_floor = __le32_to_cpu(ev->noise_floor);
-	rx_clear_count = __le32_to_cpu(ev->rx_clear_count);
-	cycle_count = __le32_to_cpu(ev->cycle_count);
+	err_code = __le32_to_cpu(arg.err_code);
+	freq = __le32_to_cpu(arg.freq);
+	cmd_flags = __le32_to_cpu(arg.cmd_flags);
+	noise_floor = __le32_to_cpu(arg.noise_floor);
+	rx_clear_count = __le32_to_cpu(arg.rx_clear_count);
+	cycle_count = __le32_to_cpu(arg.cycle_count);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "chan info err_code %d freq %d cmd_flags %d noise_floor %d rx_clear_count %d cycle_count %d\n",
@@ -1566,16 +1644,38 @@ static void ath10k_wmi_event_update_stats(struct ath10k *ar,
 	ath10k_debug_fw_stats_process(ar, skb);
 }
 
+static int ath10k_wmi_pull_vdev_start_ev(struct sk_buff *skb,
+					 struct wmi_vdev_start_ev_arg *arg)
+{
+	struct wmi_vdev_start_response_event *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->vdev_id = ev->vdev_id;
+	arg->req_id = ev->req_id;
+	arg->resp_type = ev->resp_type;
+	arg->status = ev->status;
+
+	return 0;
+}
+
 static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	struct wmi_vdev_start_response_event *ev;
+	struct wmi_vdev_start_ev_arg arg = {};
+	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_START_RESP_EVENTID\n");
 
-	ev = (struct wmi_vdev_start_response_event *)skb->data;
+	ret = ath10k_wmi_pull_vdev_start_ev(skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse vdev start event: %d\n", ret);
+		return;
+	}
 
-	if (WARN_ON(__le32_to_cpu(ev->status)))
+	if (WARN_ON(__le32_to_cpu(arg.status)))
 		return;
 
 	complete(&ar->vdev_setup_done);
@@ -1588,23 +1688,43 @@ static void ath10k_wmi_event_vdev_stopped(struct ath10k *ar,
 	complete(&ar->vdev_setup_done);
 }
 
+static int ath10k_wmi_pull_peer_kick_ev(struct sk_buff *skb,
+					struct wmi_peer_kick_ev_arg *arg)
+{
+	struct wmi_peer_sta_kickout_event *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->mac_addr = ev->peer_macaddr.addr;
+
+	return 0;
+}
+
 static void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
-	struct wmi_peer_sta_kickout_event *ev;
+	struct wmi_peer_kick_ev_arg arg = {};
 	struct ieee80211_sta *sta;
+	int ret;
 
-	ev = (struct wmi_peer_sta_kickout_event *)skb->data;
+	ret = ath10k_wmi_pull_peer_kick_ev(skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse peer kickout event: %d\n",
+			    ret);
+		return;
+	}
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event peer sta kickout %pM\n",
-		   ev->peer_macaddr.addr);
+		   arg.mac_addr);
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta_by_ifaddr(ar->hw, ev->peer_macaddr.addr, NULL);
+	sta = ieee80211_find_sta_by_ifaddr(ar->hw, arg.mac_addr, NULL);
 	if (!sta) {
 		ath10k_warn(ar, "Spurious quick kickout for STA %pM\n",
-			    ev->peer_macaddr.addr);
+			    arg.mac_addr);
 		goto exit;
 	}
 
@@ -1641,7 +1761,7 @@ exit:
 static void ath10k_wmi_update_tim(struct ath10k *ar,
 				  struct ath10k_vif *arvif,
 				  struct sk_buff *bcn,
-				  struct wmi_bcn_info *bcn_info)
+				  const struct wmi_tim_info *tim_info)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)bcn->data;
 	struct ieee80211_tim_ie *tim;
@@ -1652,14 +1772,14 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 
 	/* if next SWBA has no tim_changed the tim_bitmap is garbage.
 	 * we must copy the bitmap upon change and reuse it later */
-	if (__le32_to_cpu(bcn_info->tim_info.tim_changed)) {
+	if (__le32_to_cpu(tim_info->tim_changed)) {
 		int i;
 
 		BUILD_BUG_ON(sizeof(arvif->u.ap.tim_bitmap) !=
-			     sizeof(bcn_info->tim_info.tim_bitmap));
+			     sizeof(tim_info->tim_bitmap));
 
 		for (i = 0; i < sizeof(arvif->u.ap.tim_bitmap); i++) {
-			t = bcn_info->tim_info.tim_bitmap[i / 4];
+			t = tim_info->tim_bitmap[i / 4];
 			v = __le32_to_cpu(t);
 			arvif->u.ap.tim_bitmap[i] = (v >> ((i % 4) * 8)) & 0xFF;
 		}
@@ -1711,13 +1831,13 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 		return;
 	}
 
-	tim->bitmap_ctrl = !!__le32_to_cpu(bcn_info->tim_info.tim_mcast);
+	tim->bitmap_ctrl = !!__le32_to_cpu(tim_info->tim_mcast);
 	memcpy(tim->virtual_map, arvif->u.ap.tim_bitmap, pvm_len);
 
 	if (tim->dtim_count == 0) {
 		ATH10K_SKB_CB(bcn)->bcn.dtim_zero = true;
 
-		if (__le32_to_cpu(bcn_info->tim_info.tim_mcast) == 1)
+		if (__le32_to_cpu(tim_info->tim_mcast) == 1)
 			ATH10K_SKB_CB(bcn)->bcn.deliver_cab = true;
 	}
 
@@ -1727,7 +1847,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 }
 
 static void ath10k_p2p_fill_noa_ie(u8 *data, u32 len,
-				   struct wmi_p2p_noa_info *noa)
+				   const struct wmi_p2p_noa_info *noa)
 {
 	struct ieee80211_p2p_noa_attr *noa_attr;
 	u8  ctwindow_oppps = noa->ctwindow_oppps;
@@ -1769,7 +1889,7 @@ static void ath10k_p2p_fill_noa_ie(u8 *data, u32 len,
 	*noa_attr_len = __cpu_to_le16(attr_len);
 }
 
-static u32 ath10k_p2p_calc_noa_ie_len(struct wmi_p2p_noa_info *noa)
+static u32 ath10k_p2p_calc_noa_ie_len(const struct wmi_p2p_noa_info *noa)
 {
 	u32 len = 0;
 	u8 noa_descriptors = noa->num_descriptors;
@@ -1789,9 +1909,8 @@ static u32 ath10k_p2p_calc_noa_ie_len(struct wmi_p2p_noa_info *noa)
 
 static void ath10k_wmi_update_noa(struct ath10k *ar, struct ath10k_vif *arvif,
 				  struct sk_buff *bcn,
-				  struct wmi_bcn_info *bcn_info)
+				  const struct wmi_p2p_noa_info *noa)
 {
-	struct wmi_p2p_noa_info *noa = &bcn_info->p2p_noa_info;
 	u8 *new_data, *old_data = arvif->u.ap.noa_data;
 	u32 new_len;
 
@@ -1832,22 +1951,59 @@ cleanup:
 	kfree(old_data);
 }
 
+static int ath10k_wmi_pull_swba_ev(struct sk_buff *skb,
+				   struct wmi_swba_ev_arg *arg)
+{
+	struct wmi_host_swba_event *ev = (void *)skb->data;
+	u32 map;
+	size_t i;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->vdev_map = ev->vdev_map;
+
+	for (i = 0, map = __le32_to_cpu(ev->vdev_map); map; map >>= 1) {
+		if (!(map & BIT(0)))
+			continue;
+
+		/* If this happens there were some changes in firmware and
+		 * ath10k should update the max size of tim_info array.
+		 */
+		if (WARN_ON_ONCE(i == ARRAY_SIZE(arg->tim_info)))
+			break;
+
+		arg->tim_info[i] = &ev->bcn_info[i].tim_info;
+		arg->noa_info[i] = &ev->bcn_info[i].p2p_noa_info;
+		i++;
+	}
+
+	return 0;
+}
+
 static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_host_swba_event *ev;
+	struct wmi_swba_ev_arg arg = {};
 	u32 map;
 	int i = -1;
-	struct wmi_bcn_info *bcn_info;
+	const struct wmi_tim_info *tim_info;
+	const struct wmi_p2p_noa_info *noa_info;
 	struct ath10k_vif *arvif;
 	struct sk_buff *bcn;
 	dma_addr_t paddr;
 	int ret, vdev_id = 0;
 
-	ev = (struct wmi_host_swba_event *)skb->data;
-	map = __le32_to_cpu(ev->vdev_map);
+	ret = ath10k_wmi_pull_swba_ev(skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse swba event: %d\n", ret);
+		return;
+	}
+
+	map = __le32_to_cpu(arg.vdev_map);
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT, "mgmt swba vdev_map 0x%x\n",
-		   ev->vdev_map);
+		   map);
 
 	for (; map; map >>= 1, vdev_id++) {
 		if (!(map & 0x1))
@@ -1860,19 +2016,20 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
-		bcn_info = &ev->bcn_info[i];
+		tim_info = arg.tim_info[i];
+		noa_info = arg.noa_info[i];
 
 		ath10k_dbg(ar, ATH10K_DBG_MGMT,
 			   "mgmt event bcn_info %d tim_len %d mcast %d changed %d num_ps_pending %d bitmap 0x%08x%08x%08x%08x\n",
 			   i,
-			   __le32_to_cpu(bcn_info->tim_info.tim_len),
-			   __le32_to_cpu(bcn_info->tim_info.tim_mcast),
-			   __le32_to_cpu(bcn_info->tim_info.tim_changed),
-			   __le32_to_cpu(bcn_info->tim_info.tim_num_ps_pending),
-			   __le32_to_cpu(bcn_info->tim_info.tim_bitmap[3]),
-			   __le32_to_cpu(bcn_info->tim_info.tim_bitmap[2]),
-			   __le32_to_cpu(bcn_info->tim_info.tim_bitmap[1]),
-			   __le32_to_cpu(bcn_info->tim_info.tim_bitmap[0]));
+			   __le32_to_cpu(tim_info->tim_len),
+			   __le32_to_cpu(tim_info->tim_mcast),
+			   __le32_to_cpu(tim_info->tim_changed),
+			   __le32_to_cpu(tim_info->tim_num_ps_pending),
+			   __le32_to_cpu(tim_info->tim_bitmap[3]),
+			   __le32_to_cpu(tim_info->tim_bitmap[2]),
+			   __le32_to_cpu(tim_info->tim_bitmap[1]),
+			   __le32_to_cpu(tim_info->tim_bitmap[0]));
 
 		arvif = ath10k_get_arvif(ar, vdev_id);
 		if (arvif == NULL) {
@@ -1899,8 +2056,8 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		}
 
 		ath10k_tx_h_seq_no(arvif->vif, bcn);
-		ath10k_wmi_update_tim(ar, arvif, bcn, bcn_info);
-		ath10k_wmi_update_noa(ar, arvif, bcn, bcn_info);
+		ath10k_wmi_update_tim(ar, arvif, bcn, tim_info);
+		ath10k_wmi_update_noa(ar, arvif, bcn, noa_info);
 
 		spin_lock_bh(&ar->data_lock);
 
@@ -2188,37 +2345,53 @@ ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 	}
 }
 
+static int ath10k_wmi_pull_phyerr_ev(struct sk_buff *skb,
+				     struct wmi_phyerr_ev_arg *arg)
+{
+	struct wmi_phyerr_event *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	arg->num_phyerrs = ev->num_phyerrs;
+	arg->tsf_l32 = ev->tsf_l32;
+	arg->tsf_u32 = ev->tsf_u32;
+	arg->buf_len = __cpu_to_le32(skb->len - sizeof(*ev));
+	arg->phyerrs = ev->phyerrs;
+
+	return 0;
+}
+
 static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 {
-	const struct wmi_phyerr_event *ev;
+	struct wmi_phyerr_ev_arg arg = {};
 	const struct wmi_phyerr *phyerr;
 	u32 count, i, buf_len, phy_err_code;
 	u64 tsf;
-	int left_len = skb->len;
+	int left_len, ret;
 
 	ATH10K_DFS_STAT_INC(ar, phy_errors);
 
-	/* Check if combined event available */
-	if (left_len < sizeof(*ev)) {
-		ath10k_warn(ar, "wmi phyerr combined event wrong len\n");
+	ret = ath10k_wmi_pull_phyerr_ev(skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse phyerr event: %d\n", ret);
 		return;
 	}
 
-	left_len -= sizeof(*ev);
+	left_len = __le32_to_cpu(arg.buf_len);
 
 	/* Check number of included events */
-	ev = (const struct wmi_phyerr_event *)skb->data;
-	count = __le32_to_cpu(ev->num_phyerrs);
+	count = __le32_to_cpu(arg.num_phyerrs);
 
-	tsf = __le32_to_cpu(ev->tsf_u32);
+	tsf = __le32_to_cpu(arg.tsf_u32);
 	tsf <<= 32;
-	tsf |= __le32_to_cpu(ev->tsf_l32);
+	tsf |= __le32_to_cpu(arg.tsf_l32);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event phyerr count %d tsf64 0x%llX\n",
 		   count, tsf);
 
-	phyerr = ev->phyerrs;
+	phyerr = arg.phyerrs;
 	for (i = 0; i < count; i++) {
 		/* Check if we can read event header */
 		if (left_len < sizeof(*phyerr)) {
@@ -2622,22 +2795,42 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
 	complete(&ar->wmi.service_ready);
 }
 
-static int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
+static int ath10k_wmi_pull_rdy_ev(struct sk_buff *skb,
+				  struct wmi_rdy_ev_arg *arg)
 {
-	struct wmi_ready_event *ev = (struct wmi_ready_event *)skb->data;
+	struct wmi_ready_event *ev = (void *)skb->data;
 
-	if (WARN_ON(skb->len < sizeof(*ev)))
-		return -EINVAL;
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->sw_version = ev->sw_version;
+	arg->abi_version = ev->abi_version;
+	arg->status = ev->status;
+	arg->mac_addr = ev->mac_addr.addr;
+
+	return 0;
+}
 
-	ether_addr_copy(ar->mac_addr, ev->mac_addr.addr);
+static int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct wmi_rdy_ev_arg arg = {};
+	int ret;
+
+	ret = ath10k_wmi_pull_rdy_ev(skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse ready event: %d\n", ret);
+		return ret;
+	}
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi event ready sw_version %u abi_version %u mac_addr %pM status %d skb->len %i ev-sz %zu\n",
-		   __le32_to_cpu(ev->sw_version),
-		   __le32_to_cpu(ev->abi_version),
-		   ev->mac_addr.addr,
-		   __le32_to_cpu(ev->status), skb->len, sizeof(*ev));
+		   "wmi event ready sw_version %u abi_version %u mac_addr %pM status %d\n",
+		   __le32_to_cpu(arg.sw_version),
+		   __le32_to_cpu(arg.abi_version),
+		   arg.mac_addr,
+		   __le32_to_cpu(arg.status));
 
+	ether_addr_copy(ar->mac_addr, arg.mac_addr);
 	complete(&ar->wmi.unified_ready);
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 724929d..0952bc2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4120,7 +4120,7 @@ struct wmi_bcn_info {
 
 struct wmi_host_swba_event {
 	__le32 vdev_map;
-	struct wmi_bcn_info bcn_info[1];
+	struct wmi_bcn_info bcn_info[0];
 } __packed;
 
 #define WMI_MAX_AP_VDEV 16
@@ -4568,6 +4568,57 @@ struct wmi_dbglog_cfg_cmd {
 
 #define WMI_MAX_MEM_REQS 16
 
+struct wmi_scan_ev_arg {
+	__le32 event_type; /* %WMI_SCAN_EVENT_ */
+	__le32 reason; /* %WMI_SCAN_REASON_ */
+	__le32 channel_freq; /* only valid for WMI_SCAN_EVENT_FOREIGN_CHANNEL */
+	__le32 scan_req_id;
+	__le32 scan_id;
+	__le32 vdev_id;
+};
+
+struct wmi_mgmt_rx_ev_arg {
+	__le32 channel;
+	__le32 snr;
+	__le32 rate;
+	__le32 phy_mode;
+	__le32 buf_len;
+	__le32 status; /* %WMI_RX_STATUS_ */
+};
+
+struct wmi_ch_info_ev_arg {
+	__le32 err_code;
+	__le32 freq;
+	__le32 cmd_flags;
+	__le32 noise_floor;
+	__le32 rx_clear_count;
+	__le32 cycle_count;
+};
+
+struct wmi_vdev_start_ev_arg {
+	__le32 vdev_id;
+	__le32 req_id;
+	__le32 resp_type; /* %WMI_VDEV_RESP_ */
+	__le32 status;
+};
+
+struct wmi_peer_kick_ev_arg {
+	const u8 *mac_addr;
+};
+
+struct wmi_swba_ev_arg {
+	__le32 vdev_map;
+	const struct wmi_tim_info *tim_info[WMI_MAX_AP_VDEV];
+	const struct wmi_p2p_noa_info *noa_info[WMI_MAX_AP_VDEV];
+};
+
+struct wmi_phyerr_ev_arg {
+	__le32 num_phyerrs;
+	__le32 tsf_l32;
+	__le32 tsf_u32;
+	__le32 buf_len;
+	const struct wmi_phyerr *phyerrs;
+};
 struct wmi_svc_rdy_ev_arg {
 	__le32 min_tx_power;
 	__le32 max_tx_power;
@@ -4584,6 +4635,13 @@ struct wmi_svc_rdy_ev_arg {
 	const struct wlan_host_mem_req *mem_reqs[WMI_MAX_MEM_REQS];
 };
 
+struct wmi_rdy_ev_arg {
+	__le32 sw_version;
+	__le32 abi_version;
+	__le32 status;
+	const u8 *mac_addr;
+};
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats;
-- 
1.8.5.3


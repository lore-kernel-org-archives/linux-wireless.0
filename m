Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31372 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1GMM0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 08:26:43 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 3/3] mac80211: Report 40MHz Intolerance to associated AP.
Date: Wed, 13 Jul 2011 17:54:33 +0530
Message-ID: <1310559873-10314-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110713_142647_318351_9E1F152E)
In-Reply-To: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for 40MHz intolerance handling in STA
mode. STA should report of any 40MHz intolerance in case if it
finds a non-HT AP or a HT AP which prohibits 40MHz transmission
(i.e 40MHz intolerant bit is set in HT capabilities IE).

STA shall report this condition using 20/40 BSS coexistence
action frame.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |    4 ++
 net/mac80211/mlme.c        |    1 +
 net/mac80211/scan.c        |   30 +++++++++++++++
 net/mac80211/util.c        |   87 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4c7a831..9365fb1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -599,6 +599,8 @@ struct ieee80211_sub_if_data {
 	struct sk_buff_head skb_queue;
 
 	bool arp_filter_state;
+	bool found_40mhz_intolerant;
+	u8 intol_channels;
 
 	/*
 	 * AP this belongs to: self in AP mode and
@@ -1279,6 +1281,8 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
 
+void ieee80211_process_40mhz_intolerance(struct ieee80211_local *local);
+
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
 void ieee80211_stop_device(struct ieee80211_local *local);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b6d9bd5..41517bb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -206,6 +206,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    !(sband->ht_cap.cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 08a45ac..29d50dd 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -74,6 +74,31 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
 }
 
+static void ieee80211_check_40mhz_intolerance(
+			struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_channel *channel,
+			struct ieee802_11_elems *elems)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if ((local->_oper_channel_type != NL80211_CHAN_HT40MINUS) ||
+	    (local->_oper_channel_type != NL80211_CHAN_HT40PLUS))
+		return;
+
+	if (local->oper_channel->band != channel->band)
+		return;
+
+	if (!elems->ht_cap_elem ||
+	    (le16_to_cpu(elems->ht_cap_elem->cap_info) &
+		    IEEE80211_HT_CAP_40MHZ_INTOLERANT)) {
+		sdata->found_40mhz_intolerant = true;
+		if (!channel->is_40mhz_intolerant) {
+			channel->is_40mhz_intolerant = true;
+			sdata->intol_channels++;
+		}
+	}
+}
+
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
@@ -212,6 +237,8 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	if (bss)
 		ieee80211_rx_bss_put(sdata->local, bss);
 
+	ieee80211_check_40mhz_intolerance(sdata, channel, &elems);
+
 	/* If we are on-operating-channel, and this packet is for the
 	 * current channel, pass the pkt on up the stack so that
 	 * the rest of the stack can make use of it.
@@ -319,6 +346,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	}
 
 	ieee80211_recalc_idle(local);
+	ieee80211_process_40mhz_intolerance(local);
 
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
@@ -434,6 +462,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	else
 		__set_bit(SCAN_SW_SCANNING, &local->scanning);
 
+	sdata->found_40mhz_intolerant = false;
+	sdata->intol_channels = 0;
 	ieee80211_recalc_idle(local);
 
 	if (local->ops->hw_scan) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 652e569..9ad5361 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1334,6 +1334,93 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	return 0;
 }
 
+static void ieee80211_send_public_action_frame(
+		struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband =
+		local->hw.wiphy->bands[local->oper_channel->band];
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *action_frame;
+	int i;
+	u8 *pos;
+
+	skb = dev_alloc_skb(sizeof(*action_frame) + local->hw.extra_tx_headroom
+				+ sdata->intol_channels);
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer for "
+				"public action frame\n", sdata->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	action_frame = (struct ieee80211_mgmt *)skb_put(skb, 24);
+	memset(action_frame, 0, 24);
+	memcpy(action_frame->da, ifmgd->bssid, ETH_ALEN);
+	memcpy(action_frame->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(action_frame->bssid, ifmgd->bssid, ETH_ALEN);
+	action_frame->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(action_frame->u.action.u.bss_coex));
+	action_frame->u.action.category = WLAN_CATEGORY_PUBLIC;
+	action_frame->u.action.u.bss_coex.action_code = 0;
+
+	memset(&action_frame->u.action.u.bss_coex.bc_elem, 0,
+		sizeof(struct ieee80211_2040_bss_coex_ie));
+	action_frame->u.action.u.bss_coex.bc_elem.element_id =
+			WLAN_EID_BSS_COEX_2040;
+	action_frame->u.action.u.bss_coex.bc_elem.length = 1;
+	if (local->hw.wiphy->dot11FortyMHzIntolerant)
+		action_frame->u.action.u.bss_coex.bc_elem.coex_param |=
+			IEEE80211_2040_BC_40MHZ_INTOL;
+	action_frame->u.action.u.bss_coex.bc_elem.coex_param |=
+			IEEE80211_2040_BC_20MHZ_WIDTH_REQ;
+
+	action_frame->u.action.u.bss_coex.ic_report.element_id =
+			WLAN_EID_BSS_2040_INTOL_CHAN_REPORT;
+	action_frame->u.action.u.bss_coex.ic_report.length =
+		sdata->intol_channels + 1;
+	action_frame->u.action.u.bss_coex.ic_report.reg_class = 0; /* XXX */
+	pos = skb_put(skb, sdata->intol_channels);
+	for (i = 0; i < sband->n_channels; i++) {
+		if (sband->channels[i].is_40mhz_intolerant)
+			*pos++ = ieee80211_frequency_to_channel(
+					sband->channels[i].center_freq);
+	}
+	sdata->intol_channels = 0;
+	sdata->found_40mhz_intolerant = false;
+
+	ieee80211_tx_skb(sdata, skb);
+}
+
+void ieee80211_process_40mhz_intolerance(struct ieee80211_local *local)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_supported_band *sband =
+		local->hw.wiphy->bands[local->oper_channel->band];
+	struct ieee80211_sub_if_data *sdata;
+	int i;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (!sdata->found_40mhz_intolerant)
+			continue;
+		if (!conf_is_ht40(conf))
+			continue;
+		ieee80211_send_public_action_frame(sdata);
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	for (i = 0; i < sband->n_channels; i++)
+		sband->channels[i].is_40mhz_intolerant = false;
+}
+
 static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
 			  enum ieee80211_smps_mode *smps_mode)
 {
-- 
1.7.6


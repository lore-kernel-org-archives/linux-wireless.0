Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10036 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2DINd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 09:33:29 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 2/2] ath6kl: Configure htcap in fw based on the channel type in AP mode
Date: Mon, 9 Apr 2012 19:03:58 +0530
Message-ID: <1333978438-29596-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120409_153333_731850_E22981FB)
In-Reply-To: <1333978438-29596-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1333978438-29596-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch disables HT in start_ap if the type of the channel on
which the AP mode is going to be operating is non-HT. HT is enabled
with default ht cap setting if the operating channel is going to be
11n.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---

V2 - Realign the members of struct ath6kl_htcap to avoid padding (Joe Perches' comment)

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   77 ++++++++++++++++++++--------
 drivers/net/wireless/ath/ath6kl/common.h   |    1 +
 drivers/net/wireless/ath/ath6kl/core.h     |    9 +++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   37 +++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   13 +++++
 5 files changed, 116 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 295ad3c..266f068 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2424,31 +2424,25 @@ void ath6kl_check_wow_status(struct ath6kl *ar)
 }
 #endif
 
-static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
-			      struct ieee80211_channel *chan,
-			      enum nl80211_channel_type channel_type)
+static int ath6kl_set_htcap(struct ath6kl_vif *vif, enum ieee80211_band band,
+			    bool ht_enable)
 {
-	struct ath6kl_vif *vif;
-
-	/*
-	 * 'dev' could be NULL if a channel change is required for the hardware
-	 * device itself, instead of a particular VIF.
-	 *
-	 * FIXME: To be handled properly when monitor mode is supported.
-	 */
-	if (!dev)
-		return -EBUSY;
-
-	vif = netdev_priv(dev);
+	struct ath6kl_htcap *htcap = &vif->htcap;
 
-	if (!ath6kl_cfg80211_ready(vif))
-		return -EIO;
+	if (htcap->ht_enable == ht_enable)
+		return 0;
 
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
-		   __func__, chan->center_freq, chan->hw_value);
-	vif->next_chan = chan->center_freq;
+	if (ht_enable) {
+		/* Set default ht capabilities */
+		htcap->ht_enable = true;
+		htcap->cap_info = (band == IEEE80211_BAND_2GHZ) ?
+				   ath6kl_g_htcap : ath6kl_a_htcap;
+		htcap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K;
+	} else /* Disable ht */
+		memset(htcap, 0, sizeof(*htcap));
 
-	return 0;
+	return ath6kl_wmi_set_htcap_cmd(vif->ar->wmi, vif->fw_vif_idx,
+					band, htcap);
 }
 
 static bool ath6kl_is_p2p_ie(const u8 *pos)
@@ -2571,6 +2565,35 @@ static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
 	return 0;
 }
 
+static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
+			      struct ieee80211_channel *chan,
+			      enum nl80211_channel_type channel_type)
+{
+	struct ath6kl_vif *vif;
+
+	/*
+	 * 'dev' could be NULL if a channel change is required for the hardware
+	 * device itself, instead of a particular VIF.
+	 *
+	 * FIXME: To be handled properly when monitor mode is supported.
+	 */
+	if (!dev)
+		return -EBUSY;
+
+	vif = netdev_priv(dev);
+
+	if (!ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
+		   __func__, chan->center_freq, chan->hw_value);
+	vif->next_chan = chan->center_freq;
+	vif->next_ch_type = channel_type;
+	vif->next_ch_band = chan->band;
+
+	return 0;
+}
+
 static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_ap_settings *info)
 {
@@ -2737,6 +2760,10 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			return res;
 	}
 
+	if (ath6kl_set_htcap(vif, vif->next_ch_band,
+			     vif->next_ch_type != NL80211_CHAN_NO_HT))
+		return -EIO;
+
 	res = ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx, &p);
 	if (res < 0)
 		return res;
@@ -2771,6 +2798,13 @@ static int ath6kl_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
 	clear_bit(CONNECTED, &vif->flags);
 
+	/* Restore ht setting in firmware */
+	if (ath6kl_set_htcap(vif, IEEE80211_BAND_2GHZ, true))
+		return -EIO;
+
+	if (ath6kl_set_htcap(vif, IEEE80211_BAND_5GHZ, true))
+		return -EIO;
+
 	return 0;
 }
 
@@ -3316,6 +3350,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->next_mode = nw_type;
 	vif->listen_intvl_t = ATH6KL_DEFAULT_LISTEN_INTVAL;
 	vif->bmiss_time_t = ATH6KL_DEFAULT_BMISS_TIME;
+	vif->htcap.ht_enable = true;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 	if (fw_vif_idx != 0)
diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index 71f5450..98a8861 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -78,6 +78,7 @@ enum crypto_type {
 
 struct htc_endpoint_credit_dist;
 struct ath6kl;
+struct ath6kl_htcap;
 enum htc_credit_dist_reason;
 struct ath6kl_htc_credit_info;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 72e6a94..9d67964 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -477,6 +477,12 @@ struct ath6kl_mc_filter {
 	char hw_addr[ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE];
 };
 
+struct ath6kl_htcap {
+	bool ht_enable;
+	u8 ampdu_factor;
+	unsigned short cap_info;
+};
+
 /*
  * Driver's maximum limit, note that some firmwares support only one vif
  * and the runtime (current) limit must be checked from ar->vif_max.
@@ -525,6 +531,7 @@ struct ath6kl_vif {
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 	struct aggr_info *aggr_cntxt;
+	struct ath6kl_htcap htcap;
 
 	struct timer_list disconnect_timer;
 	struct timer_list sched_scan_timer;
@@ -537,6 +544,8 @@ struct ath6kl_vif {
 	u32 send_action_id;
 	bool probe_req_report;
 	u16 next_chan;
+	enum nl80211_channel_type next_ch_type;
+	enum ieee80211_band next_ch_band;
 	u16 assoc_bss_beacon_int;
 	u16 listen_intvl_t;
 	u16 bmiss_time_t;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7cd1d96..7c8a997 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2882,6 +2882,43 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
+int ath6kl_wmi_set_htcap_cmd(struct wmi *wmi, u8 if_idx,
+			     enum ieee80211_band band,
+			     struct ath6kl_htcap *htcap)
+{
+	struct sk_buff *skb;
+	struct wmi_set_htcap_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_htcap_cmd *) skb->data;
+
+	/*
+	 * NOTE: Band in firmware matches enum ieee80211_band, it is unlikely
+	 * this will be changed in firmware. If at all there is any change in
+	 * band value, the host needs to be fixed.
+	 */
+	cmd->band = band;
+	cmd->ht_enable = !!htcap->ht_enable;
+	cmd->ht20_sgi = !!(htcap->cap_info & IEEE80211_HT_CAP_SGI_20);
+	cmd->ht40_supported =
+		!!(htcap->cap_info & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+	cmd->ht40_sgi = !!(htcap->cap_info & IEEE80211_HT_CAP_SGI_40);
+	cmd->intolerant_40mhz =
+		!!(htcap->cap_info & IEEE80211_HT_CAP_40MHZ_INTOLERANT);
+	cmd->max_ampdu_len_exp = htcap->ampdu_factor;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "Set htcap: band:%d ht_enable:%d 40mhz:%d sgi_20mhz:%d sgi_40mhz:%d 40mhz_intolerant:%d ampdu_len_exp:%d\n",
+		   cmd->band, cmd->ht_enable, cmd->ht40_supported,
+		   cmd->ht20_sgi, cmd->ht40_sgi, cmd->intolerant_40mhz,
+		   cmd->max_ampdu_len_exp);
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_HT_CAP_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 25aa6b8..d3d2ab5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1277,6 +1277,16 @@ struct wmi_mcast_filter_add_del_cmd {
 	u8 mcast_mac[ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE];
 } __packed;
 
+struct wmi_set_htcap_cmd {
+	u8 band;
+	u8 ht_enable;
+	u8 ht40_supported;
+	u8 ht20_sgi;
+	u8 ht40_sgi;
+	u8 intolerant_40mhz;
+	u8 max_ampdu_len_exp;
+} __packed;
+
 /* Command Replies */
 
 /* WMI_GET_CHANNEL_LIST_CMDID reply */
@@ -2487,6 +2497,9 @@ int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi);
 int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, u8 if_idx, enum wmi_txop_cfg cfg);
 int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 if_idx,
 				 u8 keep_alive_intvl);
+int ath6kl_wmi_set_htcap_cmd(struct wmi *wmi, u8 if_idx,
+			     enum ieee80211_band band,
+			     struct ath6kl_htcap *htcap);
 int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 
 s32 ath6kl_wmi_get_rate(s8 rate_index);
-- 
1.7.0.4


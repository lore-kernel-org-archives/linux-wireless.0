Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbbFJRnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 13:43:03 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: define TDLS wider BW support bits
Date: Wed, 10 Jun 2015 20:42:59 +0300
Message-Id: <1433958179-28051-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150610_194308_550037_05CBA29C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Allow a device to specify support for the TDLS wider-bandwidth feature.
Indicate this support during TDLS setup in the ext-capab IE and set an
appropriate station flag when our TDLS peer supports it.
This feature gives TDLS peers the ability to use a wider channel than
the base width of the BSS. For instance VHT capable TDLS peers connected
on a 20MHz channel can extend the channel to 80MHz, if regulatory
considerations allow it.

Do not cap the bandwidth of such stations by the current BSS channel width
in mac80211.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
This one is obviously needed by
mac80211: upgrade BW of TDLS peers when possible
I just sent. Sorry for not sending them as a series
---
 include/net/mac80211.h  |  4 ++++
 net/mac80211/cfg.c      |  6 ++++++
 net/mac80211/debugfs.c  |  1 +
 net/mac80211/sta_info.h |  3 +++
 net/mac80211/tdls.c     | 18 +++++++++++++-----
 net/mac80211/vht.c      |  8 ++++++--
 6 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6b1077c..ec2c87e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1888,6 +1888,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS: The HW supports scanning on all bands
  *	in one command, mac80211 doesn't have to run separate scans per band.
  *
+ * @IEEE80211_HW_TDLS_WIDER_BW: The device/driver supports wider bandwidth
+ *	than then BSS bandwidth for a TDLS link on the base channel.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1920,6 +1923,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_CHANCTX_STA_CSA,
 	IEEE80211_HW_SUPPORTS_CLONED_SKBS,
 	IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS,
+	IEEE80211_HW_TDLS_WIDER_BW,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bf7023f..55a1a54 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1097,6 +1097,12 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	    params->ext_capab[3] & WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH)
 		set_sta_flag(sta, WLAN_STA_TDLS_CHAN_SWITCH);
 
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
+	    ieee80211_hw_check(&local->hw, TDLS_WIDER_BW) &&
+	    params->ext_capab_len >= 8 &&
+	    params->ext_capab[7] & WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED)
+		set_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW);
+
 	if (params->sta_modify_mask & STATION_PARAM_APPLY_UAPSD) {
 		sta->sta.uapsd_queues = params->uapsd_queues;
 		sta->sta.max_sp = params->max_sp;
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3ea8b7d..91dd7fd 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -122,6 +122,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
 	FLAG(CHANCTX_STA_CSA),
 	FLAG(SUPPORTS_CLONED_SKBS),
 	FLAG(SINGLE_SCAN_ON_ALL_BANDS),
+	FLAG(TDLS_WIDER_BW),
 
 	/* keep last for the build bug below */
 	(void *)0x1
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 226f8ca4..2cde9d0 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -53,6 +53,8 @@
  * @WLAN_STA_TDLS_CHAN_SWITCH: This TDLS peer supports TDLS channel-switching
  * @WLAN_STA_TDLS_OFF_CHANNEL: The local STA is currently off-channel with this
  *	TDLS peer
+ * @WLAN_STA_TDLS_WIDER_BW: This TDLS peer supports working on a wider bw on
+ *	the BSS base channel.
  * @WLAN_STA_UAPSD: Station requested unscheduled SP while driver was
  *	keeping station in power-save mode, reply when the driver
  *	unblocks the station.
@@ -84,6 +86,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TDLS_INITIATOR,
 	WLAN_STA_TDLS_CHAN_SWITCH,
 	WLAN_STA_TDLS_OFF_CHANNEL,
+	WLAN_STA_TDLS_WIDER_BW,
 	WLAN_STA_UAPSD,
 	WLAN_STA_SP,
 	WLAN_STA_4ADDR_EVENT,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index ad31b2d..fec1b33 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -35,20 +35,28 @@ void ieee80211_tdls_peer_del_work(struct work_struct *wk)
 	mutex_unlock(&local->mtx);
 }
 
-static void ieee80211_tdls_add_ext_capab(struct ieee80211_local *local,
+static void ieee80211_tdls_add_ext_capab(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
-	u8 *pos = (void *)skb_put(skb, 7);
+	struct ieee80211_local *local = sdata->local;
 	bool chan_switch = local->hw.wiphy->features &
 			   NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
+	bool wider_band = ieee80211_hw_check(&local->hw, TDLS_WIDER_BW);
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+	bool vht = sband && sband->vht_cap.vht_supported;
+	u8 *pos = (void *)skb_put(skb, 10);
 
 	*pos++ = WLAN_EID_EXT_CAPABILITY;
-	*pos++ = 5; /* len */
+	*pos++ = 8; /* len */
 	*pos++ = 0x0;
 	*pos++ = 0x0;
 	*pos++ = 0x0;
 	*pos++ = chan_switch ? WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH : 0;
 	*pos++ = WLAN_EXT_CAPA5_TDLS_ENABLED;
+	*pos++ = 0;
+	*pos++ = 0;
+	*pos++ = (vht && wider_band) ? WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED : 0;
 }
 
 static u8
@@ -320,7 +328,7 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		offset = noffset;
 	}
 
-	ieee80211_tdls_add_ext_capab(local, skb);
+	ieee80211_tdls_add_ext_capab(sdata, skb);
 
 	/* add the QoS element if we support it */
 	if (local->hw.queues >= IEEE80211_NUM_ACS &&
@@ -784,7 +792,7 @@ ieee80211_tdls_build_mgmt_packet_data(struct ieee80211_sub_if_data *sdata,
 			       max(sizeof(struct ieee80211_mgmt),
 				   sizeof(struct ieee80211_tdls_data)) +
 			       50 + /* supported rates */
-			       7 + /* ext capab */
+			       10 + /* ext capab */
 			       26 + /* max(WMM-info, WMM-param) */
 			       2 + max(sizeof(struct ieee80211_ht_cap),
 				       sizeof(struct ieee80211_ht_operation)) +
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 80694d5..f05808d 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -308,11 +308,15 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	enum ieee80211_sta_rx_bandwidth bw;
+	enum nl80211_chan_width bss_width = sdata->vif.bss_conf.chandef.width;
 
-	bw = ieee80211_chan_width_to_rx_bw(sdata->vif.bss_conf.chandef.width);
-	bw = min(bw, ieee80211_sta_cap_rx_bw(sta));
+	bw = ieee80211_sta_cap_rx_bw(sta);
 	bw = min(bw, sta->cur_max_bandwidth);
 
+	/* do not cap the BW of TDLS WIDER_BW peers by the bss */
+	if (!test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW))
+		bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
+
 	return bw;
 }
 
-- 
2.1.4


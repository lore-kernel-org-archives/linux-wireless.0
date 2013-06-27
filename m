Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55880 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3F0Mon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:43 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 08/18] mac80211: allow scanning for 5/10 MHz channels in IBSS
Date: Thu, 27 Jun 2013 14:44:14 +0200
Message-Id: <1372337064-19254-9-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144500_073395_6EB206FE)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a chandef instead of just the channel for scanning, and enable
5/10 Mhz scanning for IBSS mode. Also reporting is changed to the new
inform_bss functions.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c        |   16 ++++++++++++----
 net/mac80211/ieee80211_i.h |    5 +++--
 net/mac80211/main.c        |   10 ++--------
 net/mac80211/scan.c        |   45 ++++++++++++++++++++++++++++++++++++++------
 4 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index cf66ddc..0bad948 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -51,6 +51,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change, rate_flags, rates = 0, rates_added = 0;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chandef;
+	enum nl80211_bss_scan_width scan_width;
 	struct beacon_data *presp;
 	int frame_len;
 	int divisor;
@@ -267,8 +268,10 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-	bss = cfg80211_inform_bss_frame(local->hw.wiphy, chan,
-					mgmt, presp->head_len, 0, GFP_KERNEL);
+	scan_width = cfg80211_chandef_to_scan_width(&chandef);
+	bss = cfg80211_inform_bss_width_frame(local->hw.wiphy, chan,
+					      scan_width, mgmt,
+					      presp->head_len, 0, GFP_KERNEL);
 	cfg80211_put_bss(local->hw.wiphy, bss);
 	netif_carrier_on(sdata->dev);
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
@@ -749,6 +752,7 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	enum nl80211_bss_scan_width scan_width;
 
 	sdata_assert_lock(sdata);
 
@@ -770,8 +774,9 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	sdata_info(sdata,
 		   "No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)\n");
 
+	scan_width = cfg80211_chandef_to_scan_width(&ifibss->chandef);
 	ieee80211_request_ibss_scan(sdata, ifibss->ssid, ifibss->ssid_len,
-				    NULL);
+				    NULL, scan_width);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -821,6 +826,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	struct cfg80211_bss *cbss;
 	struct ieee80211_channel *chan = NULL;
 	const u8 *bssid = NULL;
+	enum nl80211_bss_scan_width scan_width;
 	int active_ibss;
 	u16 capability;
 
@@ -869,8 +875,10 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 					IEEE80211_SCAN_INTERVAL)) {
 		sdata_info(sdata, "Trigger new scan to find an IBSS to join\n");
 
+		scan_width = cfg80211_chandef_to_scan_width(&ifibss->chandef);
 		ieee80211_request_ibss_scan(sdata, ifibss->ssid,
-					    ifibss->ssid_len, chan);
+					    ifibss->ssid_len, chan,
+					    scan_width);
 	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fc15d12..ba6d9f9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1053,7 +1053,7 @@ struct ieee80211_local {
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request *int_scan_req;
 	struct cfg80211_scan_request *scan_req, *hw_scan_req;
-	struct ieee80211_channel *scan_channel;
+	struct cfg80211_chan_def scan_chandef;
 	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
 	int scan_ies_len;
@@ -1333,7 +1333,8 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 void ieee80211_scan_work(struct work_struct *work);
 int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				const u8 *ssid, u8 ssid_len,
-				struct ieee80211_channel *chan);
+				struct ieee80211_channel *chan,
+				enum nl80211_bss_scan_width scan_width);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 void ieee80211_scan_cancel(struct ieee80211_local *local);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a1d51af..8275d72 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -102,17 +102,11 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
-	if (local->scan_channel) {
-		chandef.chan = local->scan_channel;
+	if (local->scan_chandef.chan) {
+		chandef = local->scan_chandef;
 		/* If scanning on oper channel, use whatever channel-type
 		 * is currently in use.
 		 */
-		if (chandef.chan == local->_oper_chandef.chan) {
-			chandef = local->_oper_chandef;
-		} else {
-			chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
-			chandef.center_freq1 = chandef.chan->center_freq;
-		}
 	} else if (local->tmp_channel) {
 		chandef.chan = local->tmp_channel;
 		chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b1bfb05..77165d84 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -66,6 +66,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
 	int clen, srlen;
+	enum nl80211_bss_scan_width scan_width;
 	s32 signal = 0;
 
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
@@ -73,8 +74,15 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		signal = (rx_status->signal * 100) / local->hw.max_signal;
 
-	cbss = cfg80211_inform_bss_frame(local->hw.wiphy, channel,
-					 mgmt, len, signal, GFP_ATOMIC);
+	scan_width = NL80211_BSS_CHAN_WIDTH_20;
+	if (rx_status->flag & RX_FLAG_5MHZ)
+		scan_width = NL80211_BSS_CHAN_WIDTH_5;
+	if (rx_status->flag & RX_FLAG_10MHZ)
+		scan_width = NL80211_BSS_CHAN_WIDTH_10;
+
+	cbss = cfg80211_inform_bss_width_frame(local->hw.wiphy, channel,
+					       scan_width, mgmt, len, signal,
+					       GFP_ATOMIC);
 	if (!cbss)
 		return NULL;
 
@@ -291,7 +299,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	rcu_assign_pointer(local->scan_sdata, NULL);
 
 	local->scanning = 0;
-	local->scan_channel = NULL;
+	local->scan_chandef.chan = NULL;
 
 	/* Set power back to normal operating levels. */
 	ieee80211_hw_config(local, 0);
@@ -626,11 +634,34 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 {
 	int skip;
 	struct ieee80211_channel *chan;
+	enum nl80211_bss_scan_width oper_scan_width;
 
 	skip = 0;
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
-	local->scan_channel = chan;
+	local->scan_chandef.chan = chan;
+	local->scan_chandef.center_freq1 = chan->center_freq;
+	local->scan_chandef.center_freq2 = 0;
+	switch (local->scan_req->scan_width) {
+	case NL80211_BSS_CHAN_WIDTH_5:
+		local->scan_chandef.width = NL80211_CHAN_WIDTH_5;
+		break;
+	case NL80211_BSS_CHAN_WIDTH_10:
+		local->scan_chandef.width = NL80211_CHAN_WIDTH_10;
+		break;
+	case NL80211_BSS_CHAN_WIDTH_20:
+		/* If scanning on oper channel, use whatever channel-type
+		 * is currently in use.
+		*/
+		oper_scan_width = cfg80211_chandef_to_scan_width(
+					&local->_oper_chandef);
+		if (chan == local->_oper_chandef.chan &&
+		    oper_scan_width == local->scan_req->scan_width)
+			local->scan_chandef = local->_oper_chandef;
+		else
+			local->scan_chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		break;
+	}
 
 	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
 		skip = 1;
@@ -670,7 +701,7 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 					 unsigned long *next_delay)
 {
 	/* switch back to the operating channel */
-	local->scan_channel = NULL;
+	local->scan_chandef.chan = NULL;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	/* disable PS */
@@ -812,7 +843,8 @@ int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				const u8 *ssid, u8 ssid_len,
-				struct ieee80211_channel *chan)
+				struct ieee80211_channel *chan,
+				enum nl80211_bss_scan_width scan_width)
 {
 	struct ieee80211_local *local = sdata->local;
 	int ret = -EBUSY;
@@ -862,6 +894,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 
 	local->int_scan_req->ssids = &local->scan_ssid;
 	local->int_scan_req->n_ssids = 1;
+	local->int_scan_req->scan_width = scan_width;
 	memcpy(local->int_scan_req->ssids[0].ssid, ssid, IEEE80211_MAX_SSID_LEN);
 	local->int_scan_req->ssids[0].ssid_len = ssid_len;
 
-- 
1.7.10.4


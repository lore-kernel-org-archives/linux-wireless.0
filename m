Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40019 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3EISKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:10:49 -0400
From: a@pandem0nium
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 3/8] mac80211: change IBSS channel state to chandef
Date: Thu,  9 May 2013 20:10:31 +0200
Message-Id: <1368123036-22721-4-git-send-email-a> (sfid-20130509_201100_989619_FA0B9688)
In-Reply-To: <1368123036-22721-1-git-send-email-a>
References: <1368123036-22721-1-git-send-email-a>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

This should make some parts cleaner and is also required for handling
5/10 MHz properly.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c        |   22 +++++++++++-----------
 net/mac80211/ieee80211_i.h |    3 +--
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4e1fb81..ef07b65 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -81,7 +81,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	cfg80211_chandef_create(&chandef, chan, ifibss->channel_type);
+	chandef = ifibss->chandef;
 	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
@@ -514,7 +514,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			set_sta_flag(sta, WLAN_STA_WME);
 
 		if (sta && elems->ht_operation && elems->ht_cap_elem &&
-		    sdata->u.ibss.channel_type != NL80211_CHAN_NO_HT) {
+		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
+		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_5 &&
+		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_10) {
 			/* we both use HT */
 			struct ieee80211_ht_cap htcap_ie;
 			struct cfg80211_chan_def chandef;
@@ -529,8 +531,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			 * fall back to HT20 if we don't use or use
 			 * the other extension channel
 			 */
-			if (cfg80211_get_chandef_type(&chandef) !=
-						sdata->u.ibss.channel_type)
+			if (chandef.center_freq1 !=
+			    sdata->u.ibss.chandef.center_freq1)
 				htcap_ie.cap_info &=
 					cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 
@@ -569,7 +571,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	/* different channel */
 	if (sdata->u.ibss.fixed_channel &&
-	    sdata->u.ibss.channel != cbss->channel)
+	    sdata->u.ibss.chandef.chan != cbss->channel)
 		goto put_bss;
 
 	/* different SSID */
@@ -757,7 +759,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, ifibss->basic_rates,
+				  ifibss->chandef.chan, ifibss->basic_rates,
 				  capability, 0, true);
 }
 
@@ -789,7 +791,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	if (ifibss->fixed_bssid)
 		bssid = ifibss->bssid;
 	if (ifibss->fixed_channel)
-		chan = ifibss->channel;
+		chan = ifibss->chandef.chan;
 	if (!is_zero_ether_addr(ifibss->bssid))
 		bssid = ifibss->bssid;
 	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
@@ -1059,9 +1061,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
-	sdata->u.ibss.channel = params->chandef.chan;
-	sdata->u.ibss.channel_type =
-		cfg80211_get_chandef_type(&params->chandef);
+	sdata->u.ibss.chandef = params->chandef;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	if (params->ie) {
@@ -1124,7 +1124,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 		if (ifibss->privacy)
 			capability |= WLAN_CAPABILITY_PRIVACY;
 
-		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->channel,
+		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
 					ifibss->bssid, ifibss->ssid,
 					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
 					WLAN_CAPABILITY_PRIVACY,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 44be28c..1079c27 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -505,8 +505,7 @@ struct ieee80211_if_ibss {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len, ie_len;
 	u8 *ie;
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
-- 
1.7.10.4


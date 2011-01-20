Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53067 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab1ATJPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:15:06 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pfqbg-0005iZ-U7
	for linux-wireless@vger.kernel.org; Thu, 20 Jan 2011 10:15:04 +0100
Received: from dslb-084-059-120-020.pools.arcor-ip.net ([84.59.120.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:15:04 +0100
Received: from alexander.simon by dslb-084-059-120-020.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:15:04 +0100
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: [RFC 1/4] mac80211: support for IEEE80211N in IBSS
Date: Thu, 20 Jan 2011 09:10:58 +0000 (UTC)
Message-ID: <loom.20110120T093834-982@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de> <1295447708.4685.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, here we go.

What do you mean with a "not so refactoring version"? I am adding a new IE.
These are only insertions, no other changes. Or do you mean that dev_alloc_skb?
However, i took the last "try" from Benoit.

I split my patch into 4 sections: Setting channel_type, Building the HT IE when
joining an IBSS, parse the HT IE of a newly joined station and enable
aggregation code for IBSS.

This first patch adds setting nl80211_channel_type for an IBSS. This is mostly
Benoits work.
When a IBSS to connect to is given by iw, there is a new argument to set HT20,
HT40+ or HT40-.
When we create an IBSS, we have that struct params where we can find the channel
type set by iw.
When we join a already existing IBSS, we don't. If we find a HT IE, then we will
distinguish our channel type by that.
Here the problem remains if a legacy station has joined a HT IBSS and we got its
beacon. Then we'll won't have an HT IE... This has to be fixed, maybe something
like "found a HT20 STA, switching to HT20. And now found a HT40-, switching to
HT40-"

diff -Nrup compat-wireless-2011-01-17/include/net/cfg80211.h
compat-wireless-2011-01-17.1//include/net/cfg80211.h
--- compat-wireless-2011-01-17/include/net/cfg80211.h	2011-01-17
21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17.1//include/net/cfg80211.h	2011-01-20
09:56:01.000000000 +0100
@@ -960,6 +960,7 @@ struct cfg80211_ibss_params {
 	u8 *ssid;
 	u8 *bssid;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
diff -Nrup compat-wireless-2011-01-17/net/mac80211/ibss.c
compat-wireless-2011-01-17.1//net/mac80211/ibss.c
--- compat-wireless-2011-01-17/net/mac80211/ibss.c	2011-01-17 21:03:25.000000000
+0100
+++ compat-wireless-2011-01-17.1//net/mac80211/ibss.c	2011-01-20
09:56:01.000000000 +0100
@@ -66,6 +66,7 @@ static void ieee80211_rx_mgmt_auth_ibss(
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
+				      enum nl80211_channel_type channel_type,
 				      const u32 basic_rates,
 				      const u16 capability, u64 tsf)
 {
@@ -107,7 +108,7 @@ static void __ieee80211_sta_join_ibss(st
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -221,6 +222,7 @@ static void ieee80211_sta_join_ibss(stru
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -244,9 +246,29 @@ static void ieee80211_sta_join_ibss(stru
 		}
 	}
 
+	/* parse HT Information IE, if present */
+	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
+	if (ht_info_ie) {
+		const struct ieee80211_ht_info *ht_info = 
+				(const struct ieee80211_ht_info *)(ht_info_ie + 2);
+
+		switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+			channel_type = NL80211_CHAN_HT20;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			channel_type = NL80211_CHAN_HT40PLUS;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			channel_type = NL80211_CHAN_HT40MINUS;
+			break;
+		}
+	}
+
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
 				  cbss->channel,
+				  channel_type,
 				  basic_rates,
 				  cbss->capability,
 				  cbss->tsf);
@@ -565,7 +587,7 @@ static void ieee80211_sta_create_ibss(st
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, ifibss->basic_rates,
+				  ifibss->channel, ifibss->channel_type, ifibss->basic_rates,
 				  capability, 0);
 }
 
@@ -925,13 +947,14 @@ int ieee80211_ibss_join(struct ieee80211
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
 	sdata->u.ibss.channel = params->channel;
+	sdata->u.ibss.channel_type = params->channel_type;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
 		sdata->local->oper_channel = params->channel;
 		WARN_ON(!ieee80211_set_channel_type(sdata->local, sdata,
-						    NL80211_CHAN_NO_HT));
+						    params->channel_type));
 	}
 
 	if (params->ie) {
diff -Nrup compat-wireless-2011-01-17/net/mac80211/ieee80211_i.h
compat-wireless-2011-01-17.1//net/mac80211/ieee80211_i.h
--- compat-wireless-2011-01-17/net/mac80211/ieee80211_i.h	2011-01-17
21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17.1//net/mac80211/ieee80211_i.h	2011-01-20
09:56:01.000000000 +0100
@@ -438,6 +438,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
diff -Nrup compat-wireless-2011-01-17/net/wireless/nl80211.c
compat-wireless-2011-01-17.1//net/wireless/nl80211.c
--- compat-wireless-2011-01-17/net/wireless/nl80211.c	2011-01-17
21:03:26.000000000 +0100
+++ compat-wireless-2011-01-17.1//net/wireless/nl80211.c	2011-01-20
09:56:01.000000000 +0100
@@ -3907,8 +3907,24 @@ static int nl80211_join_ibss(struct sk_b
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		enum nl80211_channel_type channel_type;
+
+		channel_type = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+				channel_type != NL80211_CHAN_HT20 &&
+				channel_type != NL80211_CHAN_HT40PLUS &&
+				channel_type != NL80211_CHAN_HT40MINUS)
+			return -EINVAL;
+		ibss.channel_type = channel_type;
+	} else {
+		ibss.channel_type = NL80211_CHAN_NO_HT;
+	}
+
+	ibss.channel = rdev_freq_to_chan(rdev,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+		ibss.channel_type);
 	if (!ibss.channel ||
 	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
 	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)



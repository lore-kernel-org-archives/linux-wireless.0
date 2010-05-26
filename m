Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0EZOOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 10:14:41 -0400
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274878391.3658.9.camel@jlt3.sipsolutions.net>
	 <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 16:14:36 +0200
Message-ID: <1274883276.3658.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TBD

Needs to be split up (setting bss_conf and the bss_change flag is a
separate bugfix) and tested but this is what I think it should be like.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    2 +
 net/mac80211/ibss.c        |    5 +++-
 net/mac80211/ieee80211_i.h |    2 +
 net/wireless/nl80211.c     |   47 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-05-26 15:43:20.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-05-26 15:43:54.000000000 +0200
@@ -801,6 +801,7 @@ struct cfg80211_disassoc_request {
  * @beacon_interval: beacon interval to use
  * @privacy: this is a protected network, keys will be configured
  *	after joining
+ * @basic_rates: bitmap of basic rates to use when creating the IBSS
  */
 struct cfg80211_ibss_params {
 	u8 *ssid;
@@ -809,6 +810,7 @@ struct cfg80211_ibss_params {
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
+	u32 basic_rates;
 	bool channel_fixed;
 	bool privacy;
 };
--- wireless-testing.orig/net/wireless/nl80211.c	2010-05-26 15:46:01.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-05-26 16:08:28.000000000 +0200
@@ -3955,6 +3955,53 @@ static int nl80211_join_ibss(struct sk_b
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
+		u8 *rates = nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+		int n_rates = nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+		struct ieee80211_supported_band *sband =
+			wiphy->bands[ibss.channel->band];
+		int i, j;
+
+		if (n_rates == 0) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		for (i = 0; i < n_rates; i++) {
+			int rate = (rates[i] & 0x7f) * 5;
+			bool found = false;
+
+			for (j = 0; j < sband->n_bitrates; j++) {
+				if (sband->bitrates[j].bitrate == rate) {
+					found = true;
+					ibss.basic_rates |= j;
+					break;
+				}
+			}
+			if (!found) {
+				err = -EINVAL;
+				goto out;
+			}
+		}
+	} else {
+		/*
+		 * If no rates were explicitly configured,
+		 * use the mandatory rate set for 11b or
+		 * 11a for maximum compatibility.
+		 */
+		struct ieee80211_supported_band *sband =
+			wiphy->bands[ibss.channel->band];
+		int j;
+		u32 flag = ibss.channel->band == IEEE80211_BAND_5GHZ ?
+				IEEE80211_RATE_MANDATORY_A :
+				IEEE80211_RATE_MANDATORY_B;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].flags & flag)
+				ibss.basic_rates |= j;
+		}
+	}
+
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 
 out:
--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-26 16:09:11.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-05-26 16:12:32.000000000 +0200
@@ -172,11 +172,13 @@ static void __ieee80211_sta_join_ibss(st
 	rcu_assign_pointer(ifibss->presp, skb);
 
 	sdata->vif.bss_conf.beacon_int = beacon_int;
+	sdata->vif.bss_conf.basic_rates = basic_rates;
 	bss_change = BSS_CHANGED_BEACON_INT;
 	bss_change |= ieee80211_reset_erp_info(sdata);
 	bss_change |= BSS_CHANGED_BSSID;
 	bss_change |= BSS_CHANGED_BEACON;
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
+	bss_change |= BSS_CHANGED_BASIC_RATES;
 	bss_change |= BSS_CHANGED_IBSS;
 	sdata->vif.bss_conf.ibss_joined = true;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
@@ -529,7 +531,7 @@ static void ieee80211_sta_create_ibss(st
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, 3, /* first two are basic */
+				  ifibss->channel, ifibss->basic_rates,
 				  capability, 0);
 }
 
@@ -910,6 +912,7 @@ int ieee80211_ibss_join(struct ieee80211
 		sdata->u.ibss.fixed_bssid = false;
 
 	sdata->u.ibss.privacy = params->privacy;
+	sdata->u.ibss.basic_rates = params->basic_rates;
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-26 16:11:51.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-05-26 16:12:02.000000000 +0200
@@ -393,6 +393,8 @@ struct ieee80211_if_ibss {
 	unsigned long request;
 	unsigned long last_scan_completed;
 
+	u32 basic_rates;
+
 	bool timer_running;
 
 	bool fixed_bssid;



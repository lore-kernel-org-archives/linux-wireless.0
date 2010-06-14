Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:56915 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0FNGTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 02:19:07 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 1/3] mac80211: Set basic rates while joining ibss network
Date: Mon, 14 Jun 2010 09:15:43 +0300
Message-Id: <1276496145-5623-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <1276496145-5623-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276496145-5623-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to nl80211 and mac80211 to set basic rates when
joining/creating ibss network.

Original patch was posted by Johannes Berg on the linux-wireless posting list.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 include/net/cfg80211.h     |    2 +
 net/mac80211/ibss.c        |    4 ++-
 net/mac80211/ieee80211_i.h |    2 +
 net/wireless/nl80211.c     |   49 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 22ab9d8..64374f4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -810,6 +810,7 @@ struct cfg80211_disassoc_request {
  * @beacon_interval: beacon interval to use
  * @privacy: this is a protected network, keys will be configured
  *	after joining
+ * @basic_rates: bitmap of basic rates to use when creating the IBSS
  */
 struct cfg80211_ibss_params {
 	u8 *ssid;
@@ -818,6 +819,7 @@ struct cfg80211_ibss_params {
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
+	u32 basic_rates;
 	bool channel_fixed;
 	bool privacy;
 };
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d7a96ce..8be5a96 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -172,6 +172,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	rcu_assign_pointer(ifibss->presp, skb);
 
 	sdata->vif.bss_conf.beacon_int = beacon_int;
+	sdata->vif.bss_conf.basic_rates = basic_rates;
 	bss_change = BSS_CHANGED_BEACON_INT;
 	bss_change |= ieee80211_reset_erp_info(sdata);
 	bss_change |= BSS_CHANGED_BSSID;
@@ -529,7 +530,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, 3, /* first two are basic */
+				  ifibss->channel, ifibss->basic_rates,
 				  capability, 0);
 }
 
@@ -910,6 +911,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 		sdata->u.ibss.fixed_bssid = false;
 
 	sdata->u.ibss.privacy = params->privacy;
+	sdata->u.ibss.basic_rates = params->basic_rates;
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4d3883e..fde058b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -393,6 +393,8 @@ struct ieee80211_if_ibss {
 	unsigned long request;
 	unsigned long last_scan_completed;
 
+	u32 basic_rates;
+
 	bool timer_running;
 
 	bool fixed_bssid;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 90ab3c8..324b4a5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3955,6 +3955,55 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
+		u8 *rates =
+			nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+		int n_rates =
+			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
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
+					ibss.basic_rates |= BIT(j);
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
+		* If no rates were explicitly configured,
+		* use the mandatory rate set for 11b or
+		* 11a for maximum compatibility.
+		*/
+		struct ieee80211_supported_band *sband =
+			wiphy->bands[ibss.channel->band];
+		int j;
+		u32 flag = ibss.channel->band == IEEE80211_BAND_5GHZ ?
+			IEEE80211_RATE_MANDATORY_A :
+			IEEE80211_RATE_MANDATORY_B;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].flags & flag)
+				ibss.basic_rates |= BIT(j);
+		}
+	}
+
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 
 out:
-- 
1.5.6.3


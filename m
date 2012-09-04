Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:45919 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2IDSwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 14:52:41 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [RFC] cfg/nl/mac80211: use per-band basic rates bitmap in IBSS
Date: Tue,  4 Sep 2012 20:52:21 +0200
Message-Id: <1346784741-7003-1-git-send-email-ordex@autistici.org> (sfid-20120904_205246_984494_ADC5222E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each band maps the bitmap of rates to different real bitrates, therefore using
the same bitmask for every band (as it is now) is not correct.
Each band must have its own bitmask where the bits of the rates specified by the
user on IBSS join have to be set

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 include/net/cfg80211.h     |  4 ++--
 net/mac80211/ibss.c        |  6 ++++--
 net/mac80211/ieee80211_i.h |  2 +-
 net/wireless/nl80211.c     | 12 +++++++-----
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c518f1..d16f903 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1261,7 +1261,7 @@ struct cfg80211_disassoc_request {
  *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
  *	required to assume that the port is unauthorized until authorized by
  *	user space. Otherwise, port is marked authorized by default.
- * @basic_rates: bitmap of basic rates to use when creating the IBSS
+ * @basic_rates: per-band bitmap of basic rates
  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
  */
 struct cfg80211_ibss_params {
@@ -1272,7 +1272,7 @@ struct cfg80211_ibss_params {
 	u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
-	u32 basic_rates;
+	u32 basic_rates[IEEE80211_NUM_BANDS];
 	bool channel_fixed;
 	bool privacy;
 	bool control_port;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a9d9328..9b9b11f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -686,7 +686,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, ifibss->basic_rates,
+				  ifibss->channel,
+				  ifibss->basic_rates[ifibss->channel->band],
 				  capability, 0);
 }
 
@@ -1045,7 +1046,8 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.control_port = params->control_port;
-	sdata->u.ibss.basic_rates = params->basic_rates;
+	memcpy(sdata->u.ibss.basic_rates, params->basic_rates,
+	       sizeof(params->basic_rates));
 	memcpy(sdata->vif.bss_conf.mcast_rate, params->mcast_rate,
 	       sizeof(params->mcast_rate));
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 204bfed..3465620 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -508,7 +508,7 @@ struct ieee80211_if_ibss {
 
 	unsigned long last_scan_completed;
 
-	u32 basic_rates;
+	u32 basic_rates[IEEE80211_NUM_BANDS];
 
 	bool timer_running;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 787aeaa..f9ecc17 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5326,11 +5326,13 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
 		struct ieee80211_supported_band *sband =
 			wiphy->bands[ibss.channel->band];
-
-		err = ieee80211_get_ratemask(sband, rates, n_rates,
-					     &ibss.basic_rates);
-		if (err)
-			return err;
+		for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+			err = ieee80211_get_ratemask(wiphy->bands[i], rates,
+						     n_rates,
+						     ibss.basic_rates[i]);
+			if (err)
+				return err;
+		}
 	}
 
 	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
-- 
1.7.12


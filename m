Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28009 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2FPRIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 13:08:14 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] cfg80211/mac80211: userspace peer authorization in IBSS
Date: Sat, 16 Jun 2012 18:50:05 +0200
Message-Id: <1339865405-10787-5-git-send-email-ordex@autistici.org> (sfid-20120616_190854_688996_3E046439)
In-Reply-To: <1339865405-10787-1-git-send-email-ordex@autistici.org>
References: <1339865405-10787-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the IBSS network is RSN-protected, let userspace authorize the stations
instead of adding them as AUTHORIZED by default.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/cfg80211.h     |    5 +++++
 net/mac80211/ibss.c        |    6 +++++-
 net/mac80211/ieee80211_i.h |    2 ++
 net/wireless/nl80211.c     |   20 ++++++++++++--------
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 229edc5..e0c9ff3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1147,6 +1147,10 @@ struct cfg80211_disassoc_request {
  * @beacon_interval: beacon interval to use
  * @privacy: this is a protected network, keys will be configured
  *	after joining
+ * @control_port: whether user space controls IEEE 802.1X port, i.e.,
+ *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
+ *	required to assume that the port is unauthorized until authorized by
+ *	user space. Otherwise, port is marked authorized by default.
  * @basic_rates: bitmap of basic rates to use when creating the IBSS
  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
  */
@@ -1161,6 +1165,7 @@ struct cfg80211_ibss_params {
 	u32 basic_rates;
 	bool channel_fixed;
 	bool privacy;
+	bool control_port;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 };
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 7b3a0b0..8361da4 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -268,7 +268,10 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
-	sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
+	/* authorize the station only if the network is not RSN protected. If
+	 * not wait for the userspace to authorize it */
+	if (!sta->sdata->u.ibss.control_port)
+		sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 	rate_control_rate_init(sta);
 
@@ -1075,6 +1078,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 		sdata->u.ibss.fixed_bssid = false;
 
 	sdata->u.ibss.privacy = params->privacy;
+	sdata->u.ibss.control_port = params->control_port;
 	sdata->u.ibss.basic_rates = params->basic_rates;
 	memcpy(sdata->vif.bss_conf.mcast_rate, params->mcast_rate,
 	       sizeof(params->mcast_rate));
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a146b11..74594f0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -478,6 +478,8 @@ struct ieee80211_if_ibss {
 	bool fixed_channel;
 	bool privacy;
 
+	bool control_port;
+
 	u8 bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len, ie_len;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e1fd1bf..f1681e2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2654,13 +2654,6 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		/* disallow things sta doesn't support */
-		if (params.plink_action)
-			return -EINVAL;
-		if (params.ht_capa)
-			return -EINVAL;
-		if (params.listen_interval >= 0)
-			return -EINVAL;
 		/*
 		 * Don't allow userspace to change the TDLS_PEER flag,
 		 * but silently ignore attempts to change it since we
@@ -2668,7 +2661,15 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		 * to change the flag.
 		 */
 		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
-
+		/* fall through */
+	case NL80211_IFTYPE_ADHOC:
+		/* disallow things sta doesn't support */
+		if (params.plink_action)
+			return -EINVAL;
+		if (params.ht_capa)
+			return -EINVAL;
+		if (params.listen_interval >= 0)
+			return -EINVAL;
 		/* reject any changes other than AUTHORIZED */
 		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
 			return -EINVAL;
@@ -4802,6 +4803,9 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(connkeys);
 	}
 
+	ibss.control_port =
+		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT]);
+
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 	if (err)
 		kfree(connkeys);
-- 
1.7.9.4


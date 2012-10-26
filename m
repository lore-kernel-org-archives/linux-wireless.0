Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:33164 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826Ab2JZP6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 11:58:18 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv3 2/2] mac80211: implement set_mcast_rate() callback
Date: Fri, 26 Oct 2012 17:57:35 +0200
Message-Id: <1351267055-21927-2-git-send-email-ordex@autistici.org> (sfid-20121026_175822_095492_3A8F3F51)
In-Reply-To: <1351267055-21927-1-git-send-email-ordex@autistici.org>
References: <1351267055-21927-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new callback can be used to tune the rate to be used to send
multicast frames. The callback can be used with vif configured as
ADHOC or MESH_POINT only.

In the current state the multicast rate can be specified on IBSS/MESH
joining only. This makes it impossible to select a custom multicast
rate when then join command is sent by an external program (e.g.
wpa_supplicant)

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/cfg.c         |  7 +++++++
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/util.c        | 12 ++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 34fd3eb..9518e96 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1954,6 +1954,12 @@ static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	return ieee80211_ibss_leave(IEEE80211_DEV_TO_SUB_IF(dev));
 }
 
+static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
+				    int rate[IEEE80211_NUM_BANDS])
+{
+	return ieee80211_mcast_rate(IEEE80211_DEV_TO_SUB_IF(dev), rate);
+}
+
 static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
@@ -3151,6 +3157,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.disassoc = ieee80211_disassoc,
 	.join_ibss = ieee80211_join_ibss,
 	.leave_ibss = ieee80211_leave_ibss,
+	.set_mcast_rate = ieee80211_set_mcast_rate,
 	.set_wiphy_params = ieee80211_set_wiphy_params,
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3026519..375f230 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1609,6 +1609,9 @@ void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
 
+int ieee80211_mcast_rate(struct ieee80211_sub_if_data *sdata,
+			 int rate[IEEE80211_NUM_BANDS]);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dd0e6f2..ac935c3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1966,3 +1966,15 @@ u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs)
 		return 2;
 	return 1;
 }
+
+int ieee80211_mcast_rate(struct ieee80211_sub_if_data *sdata,
+			 int rate[IEEE80211_NUM_BANDS])
+{
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));
+
+	return 0;
+}
-- 
1.7.12.4


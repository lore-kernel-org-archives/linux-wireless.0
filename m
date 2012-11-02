Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:25613 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308Ab2KBM2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 08:28:36 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv5 2/2] mac80211: implement set_mcast_rate() callback
Date: Fri,  2 Nov 2012 13:27:49 +0100
Message-Id: <1351859269-27134-2-git-send-email-ordex@autistici.org> (sfid-20121102_132851_118547_AACC9B0B)
In-Reply-To: <1351859269-27134-1-git-send-email-ordex@autistici.org>
References: <1351859269-27134-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new callback can be used to tune the rate to be used to send
multicast frames.

In the current state the multicast rate can be specified on IBSS/MESH
joining only. This makes it impossible to select a custom multicast
rate when then join command is sent by an external program (e.g.
wpa_supplicant)

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/cfg.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index eebb70b..80e0618 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1954,6 +1954,16 @@ static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	return ieee80211_ibss_leave(IEEE80211_DEV_TO_SUB_IF(dev));
 }
 
+static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
+				    int rate[IEEE80211_NUM_BANDS])
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));
+
+	return 0;
+}
+
 static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
@@ -3180,6 +3190,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.disassoc = ieee80211_disassoc,
 	.join_ibss = ieee80211_join_ibss,
 	.leave_ibss = ieee80211_leave_ibss,
+	.set_mcast_rate = ieee80211_set_mcast_rate,
 	.set_wiphy_params = ieee80211_set_wiphy_params,
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
-- 
1.7.12.4


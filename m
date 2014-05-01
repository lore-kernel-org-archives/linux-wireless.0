Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37274 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaEAHRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 03:17:36 -0400
Received: by mail-wi0-f181.google.com with SMTP id f8so228926wiw.8
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 00:17:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] mac80211: set an external flag for TDLS stations
Date: Thu,  1 May 2014 10:17:27 +0300
Message-Id: <1398928648-5052-1-git-send-email-arik@wizery.com> (sfid-20140501_091739_863970_F0BF63ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

expose a new tdls flag for the public ieee80211_sta struct. This is used
in some rate control decisions.

Change-Id: Ida05ae03feecb53d00d2d3947c0d314526a8a88d
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/cfg.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 451c1bf..bdb4a7c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1374,6 +1374,7 @@ struct ieee80211_sta_rates {
  *	the station moves to associated state.
  * @smps_mode: current SMPS mode (off, static or dynamic)
  * @rates: rate control selection table
+ * @tdls: indicates whether the STA is a TDLS peer
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1388,6 +1389,7 @@ struct ieee80211_sta {
 	enum ieee80211_sta_rx_bandwidth bandwidth;
 	enum ieee80211_smps_mode smps_mode;
 	struct ieee80211_sta_rates __rcu *rates;
+	bool tdls;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7b8d3cf..d8b2366 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1459,6 +1459,8 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))) {
 		sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 		sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
+	} else {
+		sta->sta.tdls = true;
 	}
 
 	err = sta_apply_parameters(local, sta, params);
-- 
1.9.1


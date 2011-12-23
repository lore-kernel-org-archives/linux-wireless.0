Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64880 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1LWMXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:23:25 -0500
Received: by werm1 with SMTP id m1so3926910wer.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 04:23:24 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] mac80211: check sta_apply_parameters() return value
Date: Fri, 23 Dec 2011 14:24:33 +0200
Message-Id: <1324643075-29385-2-git-send-email-eliad@wizery.com> (sfid-20111223_132329_237183_DB0C49DC)
In-Reply-To: <1324643075-29385-1-git-send-email-eliad@wizery.com>
References: <1324643075-29385-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bail out if sta_apply_parameters() returns an error.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 850bb96..f08a337 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1001,6 +1001,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
+	int err;
 
 	mutex_lock(&local->sta_mtx);
 
@@ -1040,7 +1041,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		ieee80211_send_layer2_update(sta);
 	}
 
-	sta_apply_parameters(local, sta, params);
+	err = sta_apply_parameters(local, sta, params);
+	if (err) {
+		mutex_unlock(&local->sta_mtx);
+		return err;
+	}
 
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
 		rate_control_rate_init(sta);
-- 
1.7.6.401.g6a319


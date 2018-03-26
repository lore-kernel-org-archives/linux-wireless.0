Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:28030
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751249AbeCZNgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 09:36:54 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH 2/3] cfg80211: enable use of non-cleared DFS channels for DFS offload
Date: Mon, 26 Mar 2018 16:36:32 +0300
Message-Id: <20180326133633.8771-3-sergey.matyukevich.os@quantenna.com> (sfid-20180326_153700_450616_F8BEF9AA)
In-Reply-To: <20180326133633.8771-1-sergey.matyukevich.os@quantenna.com>
References: <20180326133633.8771-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Lebed <dlebed@quantenna.com>

Currently channel switch/start_ap to DFS channel cannot be done to
non-CAC-cleared channel even if DFS offload if enabled.
Make non-cleared DFS channels available if DFS offload is enabled.
CAC will be started by HW after channel change, start_ap call, etc.

Signed-off-by: Dmitry Lebed <dlebed@quantenna.com>
---
 net/wireless/chan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a48859982a32..2db713d18f71 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -579,6 +579,10 @@ static bool cfg80211_get_chans_dfs_available(struct wiphy *wiphy,
 {
 	struct ieee80211_channel *c;
 	u32 freq, start_freq, end_freq;
+	bool dfs_offload;
+
+	dfs_offload = wiphy_ext_feature_isset(wiphy,
+					      NL80211_EXT_FEATURE_DFS_OFFLOAD);
 
 	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
 	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
@@ -596,8 +600,9 @@ static bool cfg80211_get_chans_dfs_available(struct wiphy *wiphy,
 		if (c->flags & IEEE80211_CHAN_DISABLED)
 			return false;
 
-		if ((c->flags & IEEE80211_CHAN_RADAR)  &&
-		    (c->dfs_state != NL80211_DFS_AVAILABLE))
+		if ((c->flags & IEEE80211_CHAN_RADAR) &&
+		    (c->dfs_state != NL80211_DFS_AVAILABLE) &&
+		    !(c->dfs_state == NL80211_DFS_USABLE && dfs_offload))
 			return false;
 	}
 
-- 
2.11.0

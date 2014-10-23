Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64299 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJWGhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 02:37:39 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so381763wgh.7
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 23:37:38 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Jonathan Doron <jond@wizery.com>
Subject: [PATCH 3/5] cfg80211: update missing fields in custom regulatory path
Date: Thu, 23 Oct 2014 09:37:35 +0300
Message-Id: <1414046257-22184-4-git-send-email-arik@wizery.com> (sfid-20141023_083742_679785_EF1D60D3)
In-Reply-To: <1414046257-22184-1-git-send-email-arik@wizery.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jonathan Doron <jond@wizery.com>

Some channels fields were not being updated in the custom regulatory
path. Update them according to the code in handle_channel().

Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/wireless/reg.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index efbdff0..9575aea 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1691,10 +1691,23 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
 		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
+	chan->dfs_state = NL80211_DFS_USABLE;
+	chan->dfs_state_entered = jiffies;
+
+	chan->beacon_found = false;
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
 	chan->max_reg_power = chan->max_power =
 		(int) MBM_TO_DBM(power_rule->max_eirp);
+
+	if (chan->flags & IEEE80211_CHAN_RADAR) {
+		if (reg_rule->dfs_cac_ms)
+			chan->dfs_cac_ms = reg_rule->dfs_cac_ms;
+		else
+			chan->dfs_cac_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
+	}
+
+	chan->max_power = chan->max_reg_power;
 }
 
 static void handle_band_custom(struct wiphy *wiphy,
-- 
1.9.1


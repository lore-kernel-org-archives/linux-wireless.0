Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50129 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaKPOhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2014 09:37:46 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so1871969wid.17
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2014 06:37:45 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] cfg80211: update missing fields in custom regulatory path
Date: Sun, 16 Nov 2014 16:37:46 +0200
Message-Id: <1416148667-3750-1-git-send-email-arik@wizery.com> (sfid-20141116_153751_229447_0E8CB0F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some channels fields were not being updated in the custom regulatory
path. Update them according to the code in handle_channel().

Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 net/wireless/reg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7449a8c..a60f391 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1597,10 +1597,20 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
 		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
+	chan->dfs_state_entered = jiffies;
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


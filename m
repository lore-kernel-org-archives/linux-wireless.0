Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59644 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbaKPOhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2014 09:37:48 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so299955wiv.4
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2014 06:37:47 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] cfg80211: explicitly initialize some fields in custom reg path
Date: Sun, 16 Nov 2014 16:37:47 +0200
Message-Id: <1416148667-3750-2-git-send-email-arik@wizery.com> (sfid-20141116_153751_829587_03B83EA3)
In-Reply-To: <1416148667-3750-1-git-send-email-arik@wizery.com>
References: <1416148667-3750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Explicitly initialize the DFS state and beacon found state when handling
channels in the custom regulatory path.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a60f391..32d8310 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1598,6 +1598,9 @@ static void handle_channel_custom(struct wiphy *wiphy,
 		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
 	chan->dfs_state_entered = jiffies;
+	chan->dfs_state = NL80211_DFS_USABLE;
+
+	chan->beacon_found = false;
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
 	chan->max_reg_power = chan->max_power =
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58088 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaDILrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 07:47:36 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so1761125eek.40
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 04:47:35 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: reg: set DFS CAC time in case of custom regd
Date: Wed,  9 Apr 2014 13:47:12 +0200
Message-Id: <1397044032-2723-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140409_134740_260594_EF448F55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set DFS CAC time also in case of using custom
and strict regulatory from drivers. In other case
we could have unset DFS CAC time directly after
driver loaded and before issue regulatory set from
user mode.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/reg.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f59aaac..220c4a2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1071,6 +1071,13 @@ static void handle_channel(struct wiphy *wiphy,
 			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
 		chan->max_reg_power = chan->max_power = chan->orig_mpwr =
 			(int) MBM_TO_DBM(power_rule->max_eirp);
+
+		if (chan->flags & IEEE80211_CHAN_RADAR) {
+			chan->dfs_cac_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
+			if (reg_rule->dfs_cac_ms)
+				chan->dfs_cac_ms = reg_rule->dfs_cac_ms;
+		}
+
 		return;
 	}
 
-- 
1.7.9.5


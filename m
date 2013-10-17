Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37580 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab3JQSXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 14:23:39 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo15so1252756pbc.37
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2013 11:23:39 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] cfg80211: fix DFS channel recovery timeout
Date: Thu, 17 Oct 2013 11:21:11 -0700
Message-Id: <1382034072-13541-1-git-send-email-michal.kazior@tieto.com> (sfid-20131017_202344_178343_F78129E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timeout was not properly converted from msecs
to jiffies. As a result channel transition to
NL80211_DFS_USABLE was delayed depending on
CONFIG_HZ configuration, e.g. HZ=100 would delay
the NOP from 30 minutes to 300 minutes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 8d49c1c..edfe6de 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -707,8 +707,8 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 			if (c->dfs_state != NL80211_DFS_UNAVAILABLE)
 				continue;
 
-			timeout = c->dfs_state_entered +
-				  IEEE80211_DFS_MIN_NOP_TIME_MS;
+			timeout = c->dfs_state_entered + msecs_to_jiffies(
+					IEEE80211_DFS_MIN_NOP_TIME_MS);
 
 			if (time_after_eq(jiffies, timeout)) {
 				c->dfs_state = NL80211_DFS_USABLE;
-- 
1.8.4.rc3


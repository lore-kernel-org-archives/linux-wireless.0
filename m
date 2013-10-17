Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60512 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab3JQSXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 14:23:42 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so3216759pad.28
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2013 11:23:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] cfg80211: update dfs_state_entered upon dfs_state change
Date: Thu, 17 Oct 2013 11:21:12 -0700
Message-Id: <1382034072-13541-2-git-send-email-michal.kazior@tieto.com> (sfid-20131017_202344_798598_521F1329)
In-Reply-To: <1382034072-13541-1-git-send-email-michal.kazior@tieto.com>
References: <1382034072-13541-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timestamp wasn't updated after transitioning
to the NL80211_DFS_USABLE state after NOP time.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/mlme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index edfe6de..6a6b1c8 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -712,6 +712,8 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 
 			if (time_after_eq(jiffies, timeout)) {
 				c->dfs_state = NL80211_DFS_USABLE;
+				c->dfs_state_entered = jiffies;
+
 				cfg80211_chandef_create(&chandef, c,
 							NL80211_CHAN_NO_HT);
 
-- 
1.8.4.rc3


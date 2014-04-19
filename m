Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36814 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaDSQd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 12:33:57 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so2386902pab.13
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2014 09:33:56 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/3] cfg80211: fix incorrect checking of return value
Date: Sun, 20 Apr 2014 00:32:37 +0800
Message-Id: <338500f76d74ed1a62249f719024e8bbc5120790.1397924746.git.gamerh2o@gmail.com> (sfid-20140419_183400_366821_9093B745)
In-Reply-To: <cover.1397924746.git.gamerh2o@gmail.com>
References: <cover.1397924746.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1397924746.git.gamerh2o@gmail.com>
References: <cover.1397924746.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since cfg80211_chandef_dfs_required() can return error number(e.g.,
-EINVAL), it's not sufficient to just check if it didn't return zero.

Fixes: 9e0e29615a20 ("cfg80211: consider existing DFS interfaces")
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/chan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 9c9501a..2cfff9e 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -744,7 +744,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chanmode = CHAN_MODE_SHARED;
 
 			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef))
+							  &wdev->chandef) > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
@@ -754,7 +754,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chanmode = CHAN_MODE_SHARED;
 
 			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef))
+							  &wdev->chandef) > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
-- 
1.9.0


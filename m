Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1HHNuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:50:03 -0400
Received: by wyg24 with SMTP id 24so39586wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 06:50:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: clear sta.drv_priv on reconfiguration
Date: Mon,  8 Aug 2011 16:50:22 +0300
Message-Id: <1312811422-24911-1-git-send-email-eliad@wizery.com> (sfid-20110808_155008_703490_95CBAC7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers might assume sta.drv_priv is clear while
the sta is added, so clear it on reconfinguration.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 652e569..23cea7d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1196,6 +1196,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
+			memset(&sta->sta.drv_priv, 0, hw->sta_data_size);
 			WARN_ON(drv_sta_add(local, sdata, &sta->sta));
 		}
 	}
-- 
1.7.6.401.g6a319


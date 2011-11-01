Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45252 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1KANQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 09:16:54 -0400
Received: by eye27 with SMTP id 27so6183782eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 06:16:53 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: set BSS_CHANGED_IDLE on vif reconfig
Date: Tue,  1 Nov 2011 15:16:55 +0200
Message-Id: <1320153415-7646-1-git-send-email-eliad@wizery.com> (sfid-20111101_141657_962429_06A12052)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The vif might be busy while reconfiguring
(e.g. associated), so indicate BSS_CHANGED_IDLE as well.

Reported-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/util.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7439d26..5427dcc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1072,7 +1072,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_BEACON_INT |
 			  BSS_CHANGED_BSSID |
 			  BSS_CHANGED_CQM |
-			  BSS_CHANGED_QOS;
+			  BSS_CHANGED_QOS |
+			  BSS_CHANGED_IDLE;
 
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
-- 
1.7.6.401.g6a319


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36882 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDZBoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 21:44:02 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so3699251pab.8
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 18:44:02 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/2] mac80211: remove unnecessary assignment
Date: Sat, 26 Apr 2014 09:43:41 +0800
Message-Id: <1472aa0c57e6d1820435c0b8f0a487173c4091d6.1398476191.git.gamerh2o@gmail.com> (sfid-20140426_034418_929581_42360536)
In-Reply-To: <2c511530891bb91f1898a9ae09fed1628043192c.1398476191.git.gamerh2o@gmail.com>
References: <1398440262.4152.21.camel@jlt4.sipsolutions.net>
 <2c511530891bb91f1898a9ae09fed1628043192c.1398476191.git.gamerh2o@gmail.com>
In-Reply-To: <2c511530891bb91f1898a9ae09fed1628043192c.1398476191.git.gamerh2o@gmail.com>
References: <2c511530891bb91f1898a9ae09fed1628043192c.1398476191.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P2P_DEVICE doesn't support ieee80211_bss_info_change_notify() for now,
so it's not needed to set changed flags for P2P_DEVICE.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/util.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cafbae7..ad05875 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1671,13 +1671,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			}
 			break;
 		case NL80211_IFTYPE_WDS:
-			break;
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
-			/* ignore virtual */
-			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
-			changed = BSS_CHANGED_IDLE;
+			/* nothing to do */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NUM_NL80211_IFTYPES:
-- 
1.9.0


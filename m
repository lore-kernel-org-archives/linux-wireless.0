Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51789 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab2AKLJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 06:09:34 -0500
Received: by wgbds12 with SMTP id ds12so434121wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 03:09:33 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: set bss_conf.idle when vif is connected
Date: Wed, 11 Jan 2012 13:11:50 +0200
Message-Id: <1326280310-20071-1-git-send-email-eliad@wizery.com> (sfid-20120111_120938_392998_2C2189E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__ieee80211_recalc_idle() iterates through the vifs,
sets bss_conf.idle = true if they are disconnected,
and increases "count" if they are not (which later
gets evaluated in order to determine whether the
device is idle).

However, the loop doesn't set bss_conf.idle = false
(along with increasing "count"), causing the device
idle state and the vif idle state to get out of sync
in some cases.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/iface.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index da21db5..ca1a9f3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1314,6 +1314,7 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 			continue;
 		}
 		/* count everything else */
+		sdata->vif.bss_conf.idle = false;
 		count++;
 	}
 
-- 
1.7.6.401.g6a319


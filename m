Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59452 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1JPI4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Oct 2011 04:56:34 -0400
Received: by bkbzt19 with SMTP id zt19so2174785bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Oct 2011 01:56:33 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: call set_wmm_default only for valid vifs
Date: Sun, 16 Oct 2011 10:57:31 +0200
Message-Id: <1318755451-26502-1-git-send-email-eliad@wizery.com> (sfid-20111016_105642_041902_C6D3B064)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 calls ieee80211_set_wmm_default (which in turn
calls drv_conf_tx()) for every new interface, including
"internal" ones (e.g. monitor interface, which the low-level
driver doesn't know about).

Limit this call only to valid interfaces.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/iface.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ef741e8..87a5b47 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -286,6 +286,13 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);
+
+		/*
+		 * set default queue parameters so drivers don't
+		 * need to initialise the hardware if the hardware
+		 * doesn't start up with sane defaults
+		 */
+		ieee80211_set_wmm_default(sdata);
 	}
 
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
@@ -329,15 +336,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	if (coming_up)
 		local->open_count++;
 
-	if (hw_reconf_flags) {
+	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
-		/*
-		 * set default queue parameters so drivers don't
-		 * need to initialise the hardware if the hardware
-		 * doesn't start up with sane defaults
-		 */
-		ieee80211_set_wmm_default(sdata);
-	}
 
 	ieee80211_recalc_ps(local, -1);
 
-- 
1.7.6.401.g6a319


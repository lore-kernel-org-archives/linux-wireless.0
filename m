Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60461 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2BBLJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:09:37 -0500
Received: by werb13 with SMTP id b13so1708627wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:09:36 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: support hw scan while idle
Date: Thu,  2 Feb 2012 13:13:09 +0200
Message-Id: <1328181189-5461-1-git-send-email-eliad@wizery.com> (sfid-20120202_120941_055941_5AF8BA9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, mac80211 goes to idle-off before starting a scan.
However, some devices that implement hw scan might not
need going idle-off in order to perform a hw scan, and
thus saving some energy and simplifying their state machine.

(Note that this is also the case for sched scan - it
currently doesn't make mac80211 go idle-off)

Add a new flag to indicate hw scan while idle support.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/iface.c   |    3 ++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a7523e..f8d407c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1134,6 +1134,10 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_TX_AMPDU_SETUP_IN_HW: The device handles TX A-MPDU session
  *	setup strictly in HW. mac80211 should not attempt to do this in
  *	software.
+ *
+ * @IEEE80211_HW_SCAN_WHILE_IDLE: The device can do hw scan while
+ *	being idle (i.e. mac80211 doesn't have to go idle-off during the
+ *	the scan).
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1160,6 +1164,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
+	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 01a21c2..ca1a9f3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1323,7 +1323,8 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 		wk->sdata->vif.bss_conf.idle = false;
 	}
 
-	if (local->scan_sdata) {
+	if (local->scan_sdata &&
+	    !(local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)) {
 		scanning = true;
 		local->scan_sdata->vif.bss_conf.idle = false;
 	}
-- 
1.7.6.401.g6a319


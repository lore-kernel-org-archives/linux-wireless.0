Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37204 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab2BBPlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 10:41:23 -0500
Received: by wics10 with SMTP id s10so1866884wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 07:41:22 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: support hw scan while idle
Date: Thu,  2 Feb 2012 17:44:55 +0200
Message-Id: <1328197495-14325-1-git-send-email-eliad@wizery.com> (sfid-20120202_164132_815451_849B1A12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, mac80211 goes to idle-off before starting a scan.
However, some devices that implement hw scan might not
need going idle-off in order to perform a hw scan, and
thus saving some energy and simplifying their state machine.

(Note that this is also the case for sched scan - it
currently doesn't make mac80211 go idle-off)

Add a new flag to indicate support for hw scan while idle.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: verify ops->hw_scan is implemented (thanks Helmut!)
    update hwflags debugfs file 

 include/net/mac80211.h |    5 +++++
 net/mac80211/debugfs.c |    2 ++
 net/mac80211/iface.c   |    3 ++-
 net/mac80211/main.c    |    3 +++
 4 files changed, 12 insertions(+), 1 deletions(-)

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
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 90baea5..c108540 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -267,6 +267,8 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 		sf += snprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
 	if (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)
 		sf += snprintf(buf + sf, mxln - sf, "TX_AMPDU_SETUP_IN_HW\n");
+	if (local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)
+		sf += snprintf(buf + sf, mxln - sf, "SCAN_WHILE_IDLE\n");
 
 	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 	kfree(buf);
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
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0a0d94a..636cc14 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -701,6 +701,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	    )
 		return -EINVAL;
 
+	if ((hw->flags & IEEE80211_HW_SCAN_WHILE_IDLE) && !local->ops->hw_scan)
+		return -EINVAL;
+
 	if (hw->max_report_rates == 0)
 		hw->max_report_rates = hw->max_rates;
 
-- 
1.7.6.401.g6a319


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:27436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992748AbXDDIqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 04:46:48 -0400
Received: by ug-out-1314.google.com with SMTP id 44so583933uga
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2007 01:46:46 -0700 (PDT)
Message-ID: <1ba2fa240704040145l2aa8eb35hd2ef77b5475a03a3@mail.gmail.com>
Date: Wed, 4 Apr 2007 11:45:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: debugfs.c and DEBUG COUNTERS
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

debugfs.c fails comillation if CONFIG_MAC80211_DEBUG_COUNTERS is not defined
Here is a quick patch. Not sure it's correct but now it compiles.

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 419da6a..75043dd 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -253,6 +253,8 @@ DEBUGFS_DEVSTATS_FILE(dot11RTSFailureCount);
 DEBUGFS_DEVSTATS_FILE(dot11FCSErrorCount);
 DEBUGFS_DEVSTATS_FILE(dot11RTSSuccessCount);

+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+
 static ssize_t stats_wme_rx_queue_read(struct file *file,
                                       char __user *userbuf,
                                       size_t count, loff_t *ppos)
@@ -293,6 +295,7 @@ static const struct file_operations
stats_wme_tx_queue_ops = {
        .open = mac80211_open_file_generic,
 };

+#endif

 void debugfs_hw_add(struct ieee80211_local *local)
 {
@@ -360,13 +363,13 @@ void debugfs_hw_add(struct ieee80211_local *local)
        DEBUGFS_STATS_ADD(rx_expand_skb_head2);
        DEBUGFS_STATS_ADD(rx_handlers_fragments);
        DEBUGFS_STATS_ADD(tx_status_drop);
+       DEBUGFS_STATS_ADD(wme_tx_queue);
+       DEBUGFS_STATS_ADD(wme_rx_queue);
 #endif
        DEBUGFS_STATS_ADD(dot11ACKFailureCount);
        DEBUGFS_STATS_ADD(dot11RTSFailureCount);
        DEBUGFS_STATS_ADD(dot11FCSErrorCount);
        DEBUGFS_STATS_ADD(dot11RTSSuccessCount);
-       DEBUGFS_STATS_ADD(wme_tx_queue);
-       DEBUGFS_STATS_ADD(wme_rx_queue);
 }

 void debugfs_hw_del(struct ieee80211_local *local)
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index aa3035b..1790902 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -223,8 +223,10 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
        DEBUGFS_ADD(last_ack_ms);
        DEBUGFS_ADD(inactive_ms);
        DEBUGFS_ADD(last_seq_ctrl);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
        DEBUGFS_ADD(wme_rx_queue);
        DEBUGFS_ADD(wme_tx_queue);
+#endif
 }

 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
@@ -235,9 +237,10 @@ void ieee80211_sta_debugfs_remove(struct sta_info *sta)
        DEBUGFS_DEL(last_ack_ms);
        DEBUGFS_DEL(inactive_ms);
        DEBUGFS_DEL(last_seq_ctrl);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
        DEBUGFS_DEL(wme_rx_queue);
        DEBUGFS_DEL(wme_tx_queue);
-
+#endif
        debugfs_remove(sta->debugfs.dir);
        sta->debugfs.dir = NULL;
 }

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43652 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1ATRch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:32:37 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/3] mac80211: Support sw_scan_start_cur
Date: Thu, 20 Jan 2011 09:32:28 -0800
Message-Id: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This method is called when driver can support
scanning the currect active channel without otherwise
impeding traffic on that channel.  The mac80211 scan
logic may call this when we are only scanning on the
active channel and thus do not need to go off channel.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 d6b0045... 3e89ae7... M	include/net/mac80211.h
 include/net/mac80211.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d6b0045..3e89ae7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1672,6 +1672,12 @@ enum ieee80211_ampdu_mlme_action {
  *	is started. Can be NULL, if the driver doesn't need this notification.
  *	The callback can sleep.
  *
+ * @sw_scan_start_cur: Notifier function that is called just before a software
+ *	scan on only the current channel is started. If NULL, sw_scan_start
+ *      will be used instead.  sw_scan_start_cur with second argument set to
+ *      false should be treated identically to sw_scan_start.
+ *	The callback can sleep.
+ *
  * @sw_scan_complete: Notifier function that is called just after a
  *	software scan finished. Can be NULL, if the driver doesn't need
  *	this notification.
@@ -1820,6 +1826,8 @@ struct ieee80211_ops {
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
+	void (*sw_scan_start_cur)(struct ieee80211_hw *hw,
+				  bool cur_channel_only);
 	void (*sw_scan_complete)(struct ieee80211_hw *hw);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
-- 
1.7.2.3


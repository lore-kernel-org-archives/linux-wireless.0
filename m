Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2KHObS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 09:31:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add debugfs file for HW queues
Date: Thu,  8 Nov 2012 15:31:53 +0100
Message-Id: <1352385113-21671-1-git-send-email-johannes@sipsolutions.net> (sfid-20121108_153131_760253_7FEDA0BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add a debugfs file showing which HW queues were
allocated to a virtual interface, including the
CAB queue for AP interfaces.

Change-Id: I486924e961b6ad6785a79db09620919ee644e703
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 3393ad5..c3f089a 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -169,6 +169,26 @@ IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
 IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
 
+static ssize_t
+ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
+			   char *buf, int buflen)
+{
+	int len;
+
+	len = scnprintf(buf, buflen, "AC queues: VO:%d VI:%d BE:%d BK:%d\n",
+			sdata->vif.hw_queue[IEEE80211_AC_VO],
+			sdata->vif.hw_queue[IEEE80211_AC_VI],
+			sdata->vif.hw_queue[IEEE80211_AC_BE],
+			sdata->vif.hw_queue[IEEE80211_AC_BK]);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP && len < buflen)
+		len += scnprintf(buf + len, buflen - len, "cab queue: %d\n",
+				 sdata->vif.cab_queue);
+
+	return len;
+}
+__IEEE80211_IF_FILE(hw_queues, NULL);
+
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
@@ -531,6 +551,7 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
+	DEBUGFS_ADD(hw_queues);
 }
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
-- 
1.8.0


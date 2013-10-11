Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39711 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3JKVGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 17:06:05 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Add rate-control name to station debugfs.
Date: Fri, 11 Oct 2013 14:04:31 -0700
Message-Id: <1381525471-23655-1-git-send-email-greearb@candelatech.com> (sfid-20131011_230611_813270_5076835C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Nice to see what algorithm it's actually using.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/debugfs_sta.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 19c54a4..472f544 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -15,6 +15,7 @@
 #include "debugfs_sta.h"
 #include "sta_info.h"
 #include "driver-ops.h"
+#include "rate.h"
 
 /* sta attributtes */
 
@@ -371,6 +372,21 @@ static ssize_t sta_current_tx_rate_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(current_tx_rate);
 
+static ssize_t sta_rc_name_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct rate_control_ref *ref = sta->rate_ctrl;
+	if (ref && ref->ops && ref->ops->name)
+		return mac80211_format_buffer(userbuf, count, ppos,
+					      "%s\n",
+					      ref->ops->name);
+	else
+		return mac80211_format_buffer(userbuf, count, ppos,
+					      "Unknown\n");
+}
+STA_OPS(rc_name);
+
 static ssize_t sta_last_rx_rate_read(struct file *file, char __user *userbuf,
 				     size_t count, loff_t *ppos)
 {
@@ -441,6 +457,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(last_ack_signal);
 	DEBUGFS_ADD(current_tx_rate);
 	DEBUGFS_ADD(last_rx_rate);
+	DEBUGFS_ADD(rc_name);
 
 	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
 	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
-- 
1.7.3.4


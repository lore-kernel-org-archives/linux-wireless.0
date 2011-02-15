Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38833 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab1BOVL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 16:11:29 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Add power to debugfs.
Date: Tue, 15 Feb 2011 13:11:22 -0800
Message-Id: <1297804282-18415-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 1f02e59... 51f0d78... M	net/mac80211/debugfs.c
 net/mac80211/debugfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 1f02e59..51f0d78 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -60,6 +60,10 @@ static const struct file_operations name## _ops = {			\
 	debugfs_create_file(#name, mode, phyd, local, &name## _ops);
 
 
+DEBUGFS_READONLY_FILE(user_power, "%d",
+		      local->user_power_level);
+DEBUGFS_READONLY_FILE(power, "%d",
+		      local->hw.conf.power_level);
 DEBUGFS_READONLY_FILE(frequency, "%d",
 		      local->hw.conf.channel->center_freq);
 DEBUGFS_READONLY_FILE(total_ps_buffered, "%d",
@@ -391,6 +395,8 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(uapsd_queues);
 	DEBUGFS_ADD(uapsd_max_sp_len);
 	DEBUGFS_ADD(channel_type);
+	DEBUGFS_ADD(user_power);
+	DEBUGFS_ADD(power);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
-- 
1.7.2.3


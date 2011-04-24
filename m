Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35124 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab1DXLzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 07:55:41 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 04:55:15 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<L.Kriara@sms.ed.ac.uk>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] mac80211: Add num_stations connected in debugfs
Date: Sun, 24 Apr 2011 17:25:33 +0530
Message-ID: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com> (sfid-20110424_135545_064416_8D5A63A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

this will be useful when the device is operating in AP/Ad-Hoc/Mesh
mode

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/debugfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 0a602db..c16b81c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -65,6 +65,8 @@ static const struct file_operations name## _ops = {			\
 	debugfs_create_file(#name, mode, phyd, local, &name## _ops);
 
 
+DEBUGFS_READONLY_FILE(num_stations , "%lu",
+		      local->num_sta);
 DEBUGFS_READONLY_FILE(user_power, "%d",
 		      local->user_power_level);
 DEBUGFS_READONLY_FILE(power, "%d",
@@ -460,6 +462,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
+	DEBUGFS_ADD(num_stations);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
-- 
1.7.0.4


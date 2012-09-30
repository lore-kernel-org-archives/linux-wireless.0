Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2I3PPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 11:15:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use __printf attribute in debugfs
Date: Sun, 30 Sep 2012 17:16:14 +0200
Message-Id: <1349018174-22867-1-git-send-email-johannes@sipsolutions.net> (sfid-20120930_171543_198899_696E1E06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The internal function mac80211_format_buffer() has a
printf-style argument list, so add the attribute to
have gcc verify that list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 466f4b4..b189ae2 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -17,8 +17,8 @@
 
 #define DEBUGFS_FORMAT_BUFFER_SIZE 100
 
-int mac80211_format_buffer(char __user *userbuf, size_t count,
-				  loff_t *ppos, char *fmt, ...)
+int __printf(4, 5) mac80211_format_buffer(char __user *userbuf, size_t count,
+					  loff_t *ppos, char *fmt, ...)
 {
 	va_list args;
 	char buf[DEBUGFS_FORMAT_BUFFER_SIZE];
-- 
1.7.10.4


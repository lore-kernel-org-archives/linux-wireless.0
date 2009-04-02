Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761190AbZDBW0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 18:26:13 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/5] mac80211: expose HT channel flags through debugfs
Date: Thu,  2 Apr 2009 18:26:06 -0400
Message-Id: <1238711166-2208-6-git-send-email-lrodriguez@atheros.com> (sfid-20090403_002622_490565_17DB28B1)
In-Reply-To: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we are not going to be exporting HT40-/+
flags for now through nl80211 we supply the channel
flags as a whole through debugfs so users/testers can
see whether or not HT40-/+ is allowed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/debugfs.c     |   15 +++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 210b9b6..e6b36e9 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -51,6 +51,15 @@ static const struct file_operations name## _ops = {			\
 
 DEBUGFS_READONLY_FILE(frequency, 20, "%d",
 		      local->hw.conf.channel->center_freq);
+DEBUGFS_READONLY_FILE(ht40allowed, 20, "%d",
+		      !(local->hw.conf.channel->flags &
+		      IEEE80211_CHAN_NO_HT40));
+DEBUGFS_READONLY_FILE(ht40plusallowed, 20, "%d",
+		      !(local->hw.conf.channel->flags &
+		      IEEE80211_CHAN_NO_HT40PLUS));
+DEBUGFS_READONLY_FILE(ht40minusallowed, 20, "%d",
+		      !(local->hw.conf.channel->flags &
+		      IEEE80211_CHAN_NO_HT40MINUS));
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
 		      local->rts_threshold);
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
@@ -269,6 +278,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	local->debugfs.keys = debugfs_create_dir("keys", phyd);
 
 	DEBUGFS_ADD(frequency);
+	DEBUGFS_ADD(ht40allowed);
+	DEBUGFS_ADD(ht40plusallowed);
+	DEBUGFS_ADD(ht40minusallowed);
 	DEBUGFS_ADD(rts_threshold);
 	DEBUGFS_ADD(fragmentation_threshold);
 	DEBUGFS_ADD(short_retry_limit);
@@ -324,6 +336,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 void debugfs_hw_del(struct ieee80211_local *local)
 {
 	DEBUGFS_DEL(frequency);
+	DEBUGFS_DEL(ht40allowed);
+	DEBUGFS_DEL(ht40plusallowed);
+	DEBUGFS_DEL(ht40minusallowed);
 	DEBUGFS_DEL(rts_threshold);
 	DEBUGFS_DEL(fragmentation_threshold);
 	DEBUGFS_DEL(short_retry_limit);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e6ed78c..f48cab9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -750,6 +750,9 @@ struct ieee80211_local {
 		struct dentry *rcdir;
 		struct dentry *rcname;
 		struct dentry *frequency;
+		struct dentry *ht40allowed;
+		struct dentry *ht40plusallowed;
+		struct dentry *ht40minusallowed;
 		struct dentry *rts_threshold;
 		struct dentry *fragmentation_threshold;
 		struct dentry *short_retry_limit;
-- 
1.6.0.6


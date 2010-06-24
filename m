Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56676 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0FXRPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 13:15:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] minstrel_ht: move minstrel_mcs_groups declaration to header file
Date: Thu, 24 Jun 2010 13:06:47 -0400
Message-Id: <1277399207-17462-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1277392602-10578-1-git-send-email-linville@tuxdriver.com>
References: <1277392602-10578-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rc80211_minstrel_ht.h         |    2 ++
 net/mac80211/rc80211_minstrel_ht_debugfs.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 696c0fc..462d2b2 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -29,6 +29,8 @@ struct mcs_group {
 	unsigned int duration[MCS_GROUP_RATES];
 };
 
+extern const struct mcs_group minstrel_mcs_groups[];
+
 struct minstrel_rate_stats {
 	/* current / last sampling period attempts/success counters */
 	unsigned int attempts, last_attempts;
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 4fb3ccb..4a5a4b3 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -14,8 +14,6 @@
 #include "rc80211_minstrel.h"
 #include "rc80211_minstrel_ht.h"
 
-extern const struct mcs_group minstrel_mcs_groups[];
-
 static int
 minstrel_ht_stats_open(struct inode *inode, struct file *file)
 {
-- 
1.7.0.1


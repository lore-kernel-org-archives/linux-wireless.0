Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759480AbZFIIaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:30:13 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] mac80211: add debugfs counter for not valid birate frames
Date: Tue,  9 Jun 2009 04:30:10 -0400
Message-Id: <1244536211-22535-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244536211-22535-1-git-send-email-lrodriguez@atheros.com>
References: <1244536211-22535-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lets keep track of how many frames we drop due to not having
a valid bitrate for the sta.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/debugfs.c     |    4 ++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/tx.c          |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 11c7231..6a4b15c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -248,6 +248,8 @@ DEBUGFS_STATS_FILE(tx_handlers_drop_wep, 20, "%u",
 		   local->tx_handlers_drop_wep);
 DEBUGFS_STATS_FILE(tx_handlers_drop_not_assoc, 20, "%u",
 		   local->tx_handlers_drop_not_assoc);
+DEBUGFS_STATS_FILE(tx_handlers_drop_no_bitrate, 20, "%u",
+		   local->tx_handlers_drop_no_bitrate);
 DEBUGFS_STATS_FILE(tx_handlers_drop_unauth_port, 20, "%u",
 		   local->tx_handlers_drop_unauth_port);
 DEBUGFS_STATS_FILE(rx_handlers_drop, 20, "%u",
@@ -324,6 +326,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_STATS_ADD(tx_handlers_drop_fragment);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_wep);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_not_assoc);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_no_bitrate);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_unauth_port);
 	DEBUGFS_STATS_ADD(rx_handlers_drop);
 	DEBUGFS_STATS_ADD(rx_handlers_queued);
@@ -370,6 +373,7 @@ void debugfs_hw_del(struct ieee80211_local *local)
 	DEBUGFS_STATS_DEL(tx_handlers_drop_fragment);
 	DEBUGFS_STATS_DEL(tx_handlers_drop_wep);
 	DEBUGFS_STATS_DEL(tx_handlers_drop_not_assoc);
+	DEBUGFS_STATS_DEL(tx_handlers_drop_no_bitrate);
 	DEBUGFS_STATS_DEL(tx_handlers_drop_unauth_port);
 	DEBUGFS_STATS_DEL(rx_handlers_drop);
 	DEBUGFS_STATS_DEL(rx_handlers_queued);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c088c46..b46f46f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -733,6 +733,7 @@ struct ieee80211_local {
 	unsigned int tx_handlers_drop_fragment;
 	unsigned int tx_handlers_drop_wep;
 	unsigned int tx_handlers_drop_not_assoc;
+	unsigned int tx_handlers_drop_no_bitrate;
 	unsigned int tx_handlers_drop_unauth_port;
 	unsigned int rx_handlers_drop;
 	unsigned int rx_handlers_queued;
@@ -804,6 +805,7 @@ struct ieee80211_local {
 			struct dentry *tx_handlers_drop_fragment;
 			struct dentry *tx_handlers_drop_wep;
 			struct dentry *tx_handlers_drop_not_assoc;
+			struct dentry *tx_handlers_drop_no_bitrate;
 			struct dentry *tx_handlers_drop_unauth_port;
 			struct dentry *rx_handlers_drop;
 			struct dentry *rx_handlers_queued;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 03f9a4e..9f0a23b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -575,6 +575,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 			WARN_ON(1);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 		}
+		I802_DEBUG_INC(tx->local->tx_handlers_drop_no_bitrate);
 		return TX_DROP;
 	}
 
-- 
1.6.0.6


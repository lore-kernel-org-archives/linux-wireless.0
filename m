Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36460 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbcBPV2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 16:28:25 -0500
From: "Avery Pennarun" <apenwarr@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name
Cc: Avery Pennarun <apenwarr@gmail.com>
Subject: [PATCH] mac80211: debugfs var for the default aggregation timeout.
Date: Tue, 16 Feb 2016 16:28:11 -0500
Message-Id: <1455658091-28262-2-git-send-email-apenwarr@gmail.com> (sfid-20160216_222829_705982_11842B9F)
In-Reply-To: <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since around the beginning of time, ath9k aggregates have timed out after
5000 TU (around 5000ms) of inactivity, but nobody seems to be quite sure
why, and this magic number seems to have migrated around from one place to
another.  An openbsd mailing list recently had a patch to disable the
timeout completely, which they say matches some commercial routers:
https://www.mail-archive.com/tech@openbsd.org/msg29456.html

Even in Linux, several non-ath9k drivers default to no timeout already.  I
think changing it directly to zero would be safe, but to allow a more
structured investigation, let's make it configurable for now.

Signed-off-by: Avery Pennarun <apenwarr@gmail.com>
---
 net/mac80211/debugfs_netdev.c      | 4 ++++
 net/mac80211/rc80211_minstrel_ht.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)
 

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 37ea30e..5ae160b 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -715,6 +715,8 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 }
 #endif
 
+u32 default_agg_timeout = 5000;
+
 static void add_files(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata->vif.debugfs_dir)
@@ -725,6 +727,8 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(txpower);
 	DEBUGFS_ADD(user_power_level);
 	DEBUGFS_ADD(ap_power_level);
+	debugfs_create_u32("default_agg_timeout", 0600, sdata->vif.debugfs_dir,
+		&default_agg_timeout);
 
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
 		add_common_files(sdata);
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3928dbd..028d9d4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -671,6 +671,8 @@ minstrel_downgrade_rate(struct minstrel_ht_sta *mi, u16 *idx, bool primary)
 	}
 }
 
+extern u32 default_agg_timeout;
+
 static void
 minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 {
@@ -691,7 +693,7 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 	if (likely(sta->ampdu_mlme.tid_tx[tid]))
 		return;
 
-	ieee80211_start_tx_ba_session(pubsta, tid, 5000);
+	ieee80211_start_tx_ba_session(pubsta, tid, default_agg_timeout);
 }
 
 static void
-- 
2.7.0.rc3.207.g0ac5344


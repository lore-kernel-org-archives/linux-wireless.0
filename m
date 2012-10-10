Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53504 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab2JJUkk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 16:40:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 3.7] mac80211: use ieee80211_free_txskb in a few more places
Date: Wed, 10 Oct 2012 22:40:23 +0200
Message-Id: <1349901623-63864-1-git-send-email-nbd@openwrt.org> (sfid-20121010_224044_091345_DDECE997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free tx status skbs when draining power save buffers, pending frames, or
when tearing down a vif.
Fixes remaining conditions that can lead to hostapd/wpa_supplicant hangs when
running out of socket write memory.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/mac80211/iface.c    | 2 +-
 net/mac80211/sta_info.c | 4 ++--
 net/mac80211/util.c     | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6f8a73c..7de7717 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -853,7 +853,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			if (info->control.vif == &sdata->vif) {
 				__skb_unlink(skb, &local->pending[i]);
-				dev_kfree_skb_irq(skb);
+				ieee80211_free_txskb(&local->hw, skb);
 			}
 		}
 	}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 797dd36..0a4e4c0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -650,7 +650,7 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 		 */
 		if (!skb)
 			break;
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 	}
 
 	/*
@@ -679,7 +679,7 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 		local->total_ps_buffered--;
 		ps_dbg(sta->sdata, "Buffered frame expired (STA %pM)\n",
 		       sta->sta.addr);
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 	}
 
 	/*
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22ca350..94e5868 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -406,7 +406,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 	int queue = info->hw_queue;
 
 	if (WARN_ON(!info->control.vif)) {
-		kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
 
@@ -431,7 +431,7 @@ void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (WARN_ON(!info->control.vif)) {
-			kfree_skb(skb);
+			ieee80211_free_txskb(&local->hw, skb);
 			continue;
 		}
 
-- 
1.7.12.2


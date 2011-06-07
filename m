Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34937 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1FGHkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 03:40:13 -0400
Received: by wwa36 with SMTP id 36so4621097wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2011 00:40:12 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: use _ni version of ieee80211_tx_status
Date: Tue,  7 Jun 2011 10:40:39 +0300
Message-Id: <1307432439-1752-1-git-send-email-eliad@wizery.com> (sfid-20110607_094017_613549_620E0041)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271_flush_deferred_work(), which calls ieee80211_rx() and
ieee80211_tx_status(), is called from a process context.
hence, use ieee80211_tx_status_ni() instead of ieee80211_tx_status().

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 drivers/net/wireless/wl12xx/ps.c   |    2 +-
 drivers/net/wireless/wl12xx/tx.c   |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..11e3701 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -857,7 +857,7 @@ static void wl1271_flush_deferred_work(struct wl1271 *wl)
 
 	/* Return sent skbs to the network stack */
 	while ((skb = skb_dequeue(&wl->deferred_tx_queue)))
-		ieee80211_tx_status(wl->hw, skb);
+		ieee80211_tx_status_ni(wl->hw, skb);
 }
 
 static void wl1271_netstack_work(struct work_struct *work)
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index d3e377d..5116db0 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -204,7 +204,7 @@ static void wl1271_ps_filter_frames(struct wl1271 *wl, u8 hlid)
 			info = IEEE80211_SKB_CB(skb);
 			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 			info->status.rates[0].idx = -1;
-			ieee80211_tx_status(wl->hw, skb);
+			ieee80211_tx_status_ni(wl->hw, skb);
 			filtered++;
 		}
 	}
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6603e60..b2635c7 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -782,7 +782,7 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 			info = IEEE80211_SKB_CB(skb);
 			info->status.rates[0].idx = -1;
 			info->status.rates[0].count = 0;
-			ieee80211_tx_status(wl->hw, skb);
+			ieee80211_tx_status_ni(wl->hw, skb);
 			total++;
 		}
 	}
@@ -820,7 +820,7 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 					info = IEEE80211_SKB_CB(skb);
 					info->status.rates[0].idx = -1;
 					info->status.rates[0].count = 0;
-					ieee80211_tx_status(wl->hw, skb);
+					ieee80211_tx_status_ni(wl->hw, skb);
 				}
 			}
 		}
@@ -863,7 +863,7 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 			info->status.rates[0].idx = -1;
 			info->status.rates[0].count = 0;
 
-			ieee80211_tx_status(wl->hw, skb);
+			ieee80211_tx_status_ni(wl->hw, skb);
 		}
 	}
 }
-- 
1.7.0.4


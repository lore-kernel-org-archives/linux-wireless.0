Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61342 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab1KWCuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 21:50:55 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so22487vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 18:50:54 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2 3/3] mac80211: log reason and initiator when rx agg is stopped
Date: Tue, 22 Nov 2011 21:50:30 -0500
Message-Id: <1322016630-27332-4-git-send-email-mar.kolya@gmail.com> (sfid-20111123_035058_527881_164C602A)
In-Reply-To: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Add additional debug logging of initiator and reason when rx
aggregation session is stopped

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/agg-rx.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index d4f23d4..98208b6 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -73,8 +73,11 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u\n",
-	       sta->sta.addr, tid);
+	printk(KERN_DEBUG
+	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
+	       sta->sta.addr, tid,
+	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
+	       (int)reason);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-- 
1.7.4.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63166 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab1KWCuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 21:50:52 -0500
Received: by vcbfk1 with SMTP id fk1so940785vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 18:50:51 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2 2/3] mac80211: trivial: use WLAN_BACK_RECIPIENT instead of hardcoded 0
Date: Tue, 22 Nov 2011 21:50:29 -0500
Message-Id: <1322016630-27332-3-git-send-email-mar.kolya@gmail.com> (sfid-20111123_035055_346683_791FA30C)
In-Reply-To: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Use WLAN_BACK_RECIPIENT instead of hardcoded 0 for clarity

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/agg-rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 476b106..d4f23d4 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -85,7 +85,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	/* check if this is a self generated aggregation halt */
 	if (initiator == WLAN_BACK_RECIPIENT && tx)
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
-				     tid, 0, reason);
+				     tid, WLAN_BACK_RECIPIENT, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
 	del_timer_sync(&tid_rx->reorder_timer);
-- 
1.7.4.1


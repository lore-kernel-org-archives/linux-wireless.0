Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1DANsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 09:48:04 -0400
Received: by bwz15 with SMTP id 15so2534654bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 06:48:02 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Fix duplicate frames on cooked monitor
Date: Fri,  1 Apr 2011 15:46:05 +0200
Message-Id: <1301665565-4616-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleaning the ieee80211_rx_data.flags field here is wrong, instead the
flags should be valid accross processing the frame on different
interfaces. Fix this by removing the incorrect flags=0 assignment.

Introduced in commit 554891e63a29af35cc6bb403ef34e319518114d0
(mac80211: move packet flags into packet).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d47d33d..32cc8ee 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2545,7 +2545,6 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 		 * same TID from the same station
 		 */
 		rx->skb = skb;
-		rx->flags = 0;
 
 		CALL_RXH(ieee80211_rx_h_decrypt)
 		CALL_RXH(ieee80211_rx_h_check_more_data)
@@ -2616,6 +2615,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 		.sdata = sta->sdata,
 		.local = sta->local,
 		.queue = tid,
+		.flags = 0,
 	};
 	struct tid_ampdu_rx *tid_agg_rx;
 
-- 
1.7.3.4


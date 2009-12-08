Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36420 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966738AbZLHWaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:30:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: correctly report signal value for IEEE80211_HW_SIGNAL_UNSPEC
Date: Tue,  8 Dec 2009 17:15:48 -0500
Message-Id: <1260310548-18161-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This part was missed in "cfg80211: implement get_wireless_stats",
probably because sta_set_sinfo already existed and was only handling
dBm signals.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/cfg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 93ee1fd..6dc3579 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -354,7 +354,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sinfo->rx_packets = sta->rx_packets;
 	sinfo->tx_packets = sta->tx_packets;
 
-	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
+	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
 		sinfo->filled |= STATION_INFO_SIGNAL;
 		sinfo->signal = (s8)sta->last_signal;
 	}
-- 
1.6.2.5


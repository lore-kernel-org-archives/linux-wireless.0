Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45751 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab0ANWUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 17:20:44 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: Fixed netif_tx_wake_all_queues in IBSS mode
Date: Thu, 14 Jan 2010 23:20:31 +0100
Message-Id: <1263507631-12933-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ieee80211_offchannel_return is called, it needs to re-enabled TX
queues that have been stopped in ieee80211_offchannel_stop_beaconing or
ieee80211_offchannel_stop_station. It happens if we are doing a scan with an
IBSS interface. In this case, the interface stopped transmitting.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/offchannel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 1facfeb..c36b191 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -153,9 +153,11 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_disable(sdata);
-			netif_tx_wake_all_queues(sdata->dev);
 		}
 
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+			netif_tx_wake_all_queues(sdata->dev);
+
 		/* re-enable beaconing */
 		if (enable_beaconing &&
 		    (sdata->vif.type == NL80211_IFTYPE_AP ||
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp08.msg.oleane.net ([62.161.4.8]:55365 "EHLO
	smtp08.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab3DSJUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 05:20:47 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp08.msg.oleane.net (MTA) with ESMTP id r3J9Kicm021758
	for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 11:20:44 +0200
From: cedric voncken <cedric.voncken@acksys.fr>
To: linux-wireless@vger.kernel.org
Cc: cedric voncken <cedric.voncken@acksys.fr>
Subject: [PATCH] mac80211: Fix driver crash when STA_NOTIFY_AWAKE occures
Date: Fri, 19 Apr 2013 11:20:42 +0200
Message-Id: <1366363242-29481-1-git-send-email-cedric.voncken@acksys.fr> (sfid-20130419_112051_358756_8C409DEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the device uses the HT mode and receives a frame from a sta whith state < IEEE80211_STA_ASSOC
then the null pointer exception crashes the Linnux kernel.

In the case of ath9k, the function ath_tx_node_init is indirectly called by drv_sta_state (in net/mac80211/driver-ops.h) only when the sta_state goes to IEEE80211_STA_ASSOC from IEEE80211_STA_AUTH.

Signed-off-by: cedric VONCKEN <cedric.voncken@acksys.fr>
---
 net/mac80211/sta_info.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 11216bc..bcfd7b0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1040,7 +1040,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
 	sta->driver_buffered_tids = 0;
 
-	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS &&
+			sta->sta_state >= IEEE80211_STA_ASSOC))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
 	skb_queue_head_init(&pending);
-- 
1.7.2.5


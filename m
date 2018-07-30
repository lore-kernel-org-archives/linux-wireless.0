Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeG3Hx4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 03:53:56 -0400
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] mac80211: allow station search on AP/VLANs
Date: Mon, 30 Jul 2018 11:50:20 +0530
Message-Id: <1532931620-3161-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180730_082035_668709_F7528517)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 receives a packet, we interate over the list of
active interfaces to find the station(which transmitted the packet).
Currently, station search is not allowed on AP/VLAN interface; since
stations can also get mapped to AP/VLAN interfaces, they are worth
considering for station search.

Found this during code review; just a theoritical fix.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 net/mac80211/rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a16ba56..e3fbed1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4391,8 +4391,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
 
 		/*
-- 
2.7.4

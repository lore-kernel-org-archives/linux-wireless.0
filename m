Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29534 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbeCTXwX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 19:52:23 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH] mac80211: notify driver for change in multicast rates
Date: Tue, 20 Mar 2018 16:52:09 -0700
Message-Id: <1521589929-13997-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180321_005227_262714_D0A19D54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is required to pass the rate information to driver/firmware
when rate control is offloaded to firmware. This helps in changing
multicast traffic rates thereby improving the network performance.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 include/net/mac80211.h | 1 +
 net/mac80211/cfg.c     | 2 ++
 net/mac80211/util.c    | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4c99c13..4360765 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -336,6 +336,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_OCB                 = 1<<22,
 	BSS_CHANGED_MU_GROUPS		= 1<<23,
 	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
+	BSS_CHANGED_MCAST_RATE		= 1<<25,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0763792..22bb82e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2313,6 +2313,8 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(sdata->vif.bss_conf.mcast_rate, rate,
 	       sizeof(int) * NUM_NL80211_BANDS);
 
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_MCAST_RATE);
+
 	return 0;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6aef679..6594df0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1971,7 +1971,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_CQM |
 			  BSS_CHANGED_QOS |
 			  BSS_CHANGED_IDLE |
-			  BSS_CHANGED_TXPOWER;
+			  BSS_CHANGED_TXPOWER |
+			  BSS_CHANGED_MCAST_RATE;
 
 		if (sdata->vif.mu_mimo_owner)
 			changed |= BSS_CHANGED_MU_GROUPS;
-- 
1.9.1

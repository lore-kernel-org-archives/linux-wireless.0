Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44390 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbeBWJGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 04:06:08 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 4/4] mac80211: support station 4-addr mode fast-rx
Date: Fri, 23 Feb 2018 10:06:06 +0100
Message-Id: <20180223090606.55726-4-nbd@nbd.name> (sfid-20180223_100615_018108_CDD8E98F)
In-Reply-To: <20180223090606.55726-1-nbd@nbd.name>
References: <20180223090606.55726-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/cfg.c |  2 --
 net/mac80211/rx.c  | 11 +++++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6f9d5beec73e..72b5a2ec4e94 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -160,7 +160,6 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	if (type == NL80211_IFTYPE_AP_VLAN &&
 	    params && params->use_4addr == 0) {
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
-		ieee80211_check_fast_rx_iface(sdata);
 	} else if (type == NL80211_IFTYPE_STATION &&
 		   params && params->use_4addr >= 0) {
 		sdata->u.mgd.use_4addr = params->use_4addr;
@@ -1575,7 +1574,6 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 			}
 
 			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
-			__ieee80211_check_fast_rx_iface(vlansdata);
 		}
 
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6e2506a84586..6944705c5258 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3747,10 +3747,6 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
-		/* 4-addr is harder to deal with, later maybe */
-		if (sdata->u.mgd.use_4addr)
-			goto clear;
-
 		if (sta->sta.tdls) {
 			fastrx.da_offs = offsetof(struct ieee80211_hdr, addr1);
 			fastrx.sa_offs = offsetof(struct ieee80211_hdr, addr2);
@@ -3763,6 +3759,13 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 				cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		}
 
+		if (sdata->u.mgd.use_4addr && !sta->sta.tdls) {
+			fastrx.expected_ds_bits |=
+				cpu_to_le16(IEEE80211_FCTL_TODS);
+			fastrx.da_offs = offsetof(struct ieee80211_hdr, addr3);
+			fastrx.sa_offs = offsetof(struct ieee80211_hdr, addr4);
+		}
+
 		if (!sdata->u.mgd.powersave)
 		    break;
 
-- 
2.14.2

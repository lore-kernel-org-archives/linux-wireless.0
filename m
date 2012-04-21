Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41541 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab2DUVmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 17:42:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH v3 2/2] mac80211: fix num_mcast_sta counting issues
Date: Sat, 21 Apr 2012 23:42:13 +0200
Message-Id: <1335044533-37359-2-git-send-email-nbd@openwrt.org> (sfid-20120421_234239_316887_612BB941)
In-Reply-To: <1335044533-37359-1-git-send-email-nbd@openwrt.org>
References: <1335044533-37359-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving a STA to an AP VLAN prevents num_mcast_sta from being decremented
once the STA leaves, because sta->sdata changes. Fix this by checking
for AP VLANs as well.

Also exclude 4-addr VLAN stations from num_mcast_sta - remote 4-addr
stations ignore 3-address multicast frames anyway. In a typical bridge
configuration they receive the same packets as 4-address unicast.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c      |   17 +++++++++++++++++
 net/mac80211/sta_info.c |   12 ++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 510a745..a675509 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1005,6 +1005,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	}
 
 	if (params->vlan && params->vlan != sta->sdata->dev) {
+		bool prev_4addr = false;
+		bool new_4addr = false;
+
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
 		if (vlansdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
@@ -1020,9 +1023,23 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 			}
 
 			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
+			new_4addr = true;
 		}
 
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		    sta->sdata->u.vlan.sta)
+			prev_4addr = true;
+
 		sta->sdata = vlansdata;
+
+		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
+		    prev_4addr != new_4addr) {
+			if (new_4addr)
+				atomic_dec(&sta->sdata->bss->num_mcast_sta);
+			else
+				atomic_inc(&sta->sdata->bss->num_mcast_sta);
+		}
+
 		ieee80211_send_layer2_update(sta);
 	}
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4c04eb5..97a9d66 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1417,15 +1417,19 @@ int sta_info_move_state(struct sta_info *sta,
 		if (sta->sta_state == IEEE80211_STA_AUTH) {
 			set_bit(WLAN_STA_ASSOC, &sta->_flags);
 		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
-			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
-				atomic_dec(&sta->sdata->u.ap.num_mcast_sta);
+			if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
+			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			     !sta->sdata->u.vlan.sta))
+				atomic_dec(&sta->sdata->bss->num_mcast_sta);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
 		break;
 	case IEEE80211_STA_AUTHORIZED:
 		if (sta->sta_state == IEEE80211_STA_ASSOC) {
-			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
-				atomic_inc(&sta->sdata->u.ap.num_mcast_sta);
+			if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
+			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			     !sta->sdata->u.vlan.sta))
+				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
 		break;
-- 
1.7.3.2


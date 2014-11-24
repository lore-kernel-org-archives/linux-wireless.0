Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:57178
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966AbaKXRM2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 12:12:28 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.18] mac80211: copy chandef from AP vif to VLANs
Date: Mon, 24 Nov 2014 18:12:16 +0100
Message-Id: <1416849136-14507-1-git-send-email-nbd@openwrt.org> (sfid-20141124_181230_833710_DB28BB93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes a crash in nl80211_send_chandef, introduced in

commit c12bc4885f4b3bab0ed779c69d5d7e3223fa5003
"mac80211: return the vif's chandef in ieee80211_cfg_get_channel()"

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/chan.c  | 23 +++++++++++++++++++----
 net/mac80211/iface.c |  1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 4c74e8d..5ce13a7 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -929,6 +929,21 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+static void
+ieee80211_vif_update_chandef(struct ieee80211_sub_if_data *sdata,
+			     const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *vlan;
+
+	sdata->vif.bss_conf.chandef = *chandef;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
+		return;
+
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		vlan->vif.bss_conf.chandef = *chandef;
+}
+
 static int
 ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 {
@@ -991,7 +1006,7 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
 		changed = BSS_CHANGED_BANDWIDTH;
 
-	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+	ieee80211_vif_update_chandef(sdata, &sdata->reserved_chandef);
 
 	if (changed)
 		ieee80211_bss_info_change_notify(sdata, changed);
@@ -1333,7 +1348,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 			    sdata->reserved_chandef.width)
 				changed = BSS_CHANGED_BANDWIDTH;
 
-			sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+			ieee80211_vif_update_chandef(sdata, &sdata->reserved_chandef);
 			if (changed)
 				ieee80211_bss_info_change_notify(sdata,
 								 changed);
@@ -1504,7 +1519,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	sdata->vif.bss_conf.chandef = *chandef;
+	ieee80211_vif_update_chandef(sdata, chandef);
 
 	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
 	if (ret) {
@@ -1646,7 +1661,7 @@ int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 
-	sdata->vif.bss_conf.chandef = *chandef;
+	ieee80211_vif_update_chandef(sdata, chandef);
 
 	ieee80211_recalc_chanctx_chantype(local, ctx);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 653f5eb..eeae0ab 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -511,6 +511,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		sdata->vif.cab_queue = master->vif.cab_queue;
 		memcpy(sdata->vif.hw_queue, master->vif.hw_queue,
 		       sizeof(sdata->vif.hw_queue));
+		sdata->vif.bss_conf.chandef = master->vif.bss_conf.chandef;
 		break;
 		}
 	case NL80211_IFTYPE_AP:
-- 
2.1.2


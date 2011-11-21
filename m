Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58523 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1KUOlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 09:41:52 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so6626611bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 06:41:51 -0800 (PST)
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [RFC v2 5/8] mac80211: setting link-specific mesh power modes when plink opens
Date: Mon, 21 Nov 2011 18:40:13 +0400
Message-Id: <1321886416-12597-6-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154155_732897_648C5C05)
In-Reply-To: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When plink is opened peer link-specific power mode is set up equal to
peer non-peer power mode value.

When plink is opened local link-specific power mode is set up equal
to local non-peer value.

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 net/mac80211/mesh.c       |   33 +++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h       |    6 ++++++
 net/mac80211/mesh_plink.c |   22 +++++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5b8c5d3..5963164 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -386,6 +386,39 @@ void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
 	}
 }
 
+void ieee80211s_set_local_ps_mode(struct sta_info *sta, u8 pm)
+{
+	switch (pm) {
+	case NL80211_MESH_POWER_ACTIVE:
+		sta->local_ps_mode = NL80211_MESH_POWER_ACTIVE;
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		printk(KERN_DEBUG "%s: local STA operates in active mode with STA %pM\n",
+			sta->sdata->name, sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+		break;
+	case NL80211_MESH_POWER_LIGHT_SLEEP:
+		sta->local_ps_mode = NL80211_MESH_POWER_LIGHT_SLEEP;
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		printk(KERN_DEBUG "%s: local STA operates in light sleep mode with STA %pM\n",
+				sta->sdata->name, sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+		break;
+	case NL80211_MESH_POWER_DEEP_SLEEP:
+		sta->local_ps_mode = NL80211_MESH_POWER_DEEP_SLEEP;
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		printk(KERN_DEBUG "%s: local STA operates in deep sleep mode with STA %pM\n",
+				sta->sdata->name, sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+		break;
+	default:
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		printk(KERN_DEBUG "%s: local STA used invalid power mode to operate with STA %pM\n",
+				sta->sdata->name, sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+		break;
+	}
+}
+
 /**
  * ieee80211_fill_mesh_addresses - fill addresses of a locally originated mesh frame
  * @hdr:    	802.11 frame header
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index e62c53b..1b2c58d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -227,6 +227,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 void ieee80211s_set_sta_ps_mode(struct sta_info *sta,
 				enum nl80211_mesh_power_mode mode);
+void ieee80211s_set_local_ps_mode(struct sta_info *sta, u8 pm);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
@@ -312,6 +313,11 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
 }
 
+static inline bool ieee80211s_has_capab_pm(__le16 capab_info)
+{
+	return (capab_info & MESHCONF_CAPAB_POWER_SAVE_LEVEL) != 0;
+}
+
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
 void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 7e57f5d..a8f92f3 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -248,6 +248,8 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	struct ieee80211_mgmt *mgmt = container_of(hw_addr,
+					struct ieee80211_mgmt, sa[0]);
 
 	rcu_read_lock();
 
@@ -275,8 +277,26 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 	if (mesh_peer_accepts_plinks(elems) &&
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
-			sdata->u.mesh.mshcfg.auto_open_plinks)
+			sdata->u.mesh.mshcfg.auto_open_plinks) {
+		if (ieee80211_has_pm(mgmt->frame_control)) {
+			__le16 capab_info = mgmt->u.probe_resp.capab_info;
+			if (ieee80211s_has_capab_pm(capab_info)) {
+				ieee80211s_set_sta_ps_mode(sta,
+					NL80211_MESH_POWER_DEEP_SLEEP);
+			} else {
+				ieee80211s_set_sta_ps_mode(sta,
+					NL80211_MESH_POWER_LIGHT_SLEEP);
+			}
+		} else {
+			ieee80211s_set_sta_ps_mode(sta,
+				NL80211_MESH_POWER_ACTIVE);
+		}
+
+		ieee80211s_set_local_ps_mode(sta,
+			sdata->u.mesh.mshcfg.power_mode);
+
 		mesh_plink_open(sta);
+	}
 
 	rcu_read_unlock();
 }
-- 
1.7.3.4


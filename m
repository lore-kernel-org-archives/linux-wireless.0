Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:51305 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbbCQThQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 15:37:16 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] mac80211: filter multicast data packets on AP_VLAN interfaces w/o sta
Date: Tue, 17 Mar 2015 20:30:35 +0100
Message-Id: <1426620635-868-1-git-send-email-michael-dev@fami-braun.de> (sfid-20150317_203721_122179_FCC0EAE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, multicast data packets are dropped on AP interfaces if
there are no authorized stations connected. This avoids superflous
data packets to be transmitted on air.

But when using AP_VLAN, this does not happen, as the current check does
not apply to AP_VLAN interfaces. Though, there can easily be more AP_VLAN
interfaces on an AP resulting in more multicast data frames. This is
especially true since hostapd does not remove no-longer-used AP_VLAN
interfaces and bridges.

In order to filter on AP_VLAN interfaces, a per AP_VLAN interface
counter is required (in constrast to the counter on the AP interface
counting the stations on all related AP_VLAN interfaces as well).

If there are multicast data frames on the AP interface and authorized
stations only on the related AP_VLAN interfaces, these multicast data
frames on the AP interface still won't be filtered.
This is just left unchanged by this patch.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/cfg.c            | 12 ++++++++++++
 net/mac80211/debugfs_netdev.c |  9 +++++++++
 net/mac80211/ieee80211_i.h    |  1 +
 net/mac80211/sta_info.c       | 17 +++++++++++++++++
 net/mac80211/tx.c             |  8 ++++++++
 5 files changed, 47 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 74f509c..53db0c3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1360,6 +1360,18 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 			prev_4addr = true;
 		}
 
+		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
+		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		    !sta->sdata->u.vlan.sta &&
+		    sta->sdata != vlansdata)
+			atomic_dec(&sta->sdata->u.vlan.num_mcast_sta);
+
+		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
+		    vlansdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		    !vlansdata->u.vlan.sta &&
+		    sta->sdata != vlansdata)
+			atomic_inc(&vlansdata->u.vlan.num_mcast_sta);
+
 		sta->sdata = vlansdata;
 
 		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index c68896a..71b71e2 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -428,6 +428,7 @@ IEEE80211_IF_FILE_RW(uapsd_max_sp_len);
 IEEE80211_IF_FILE(num_mcast_sta, u.ap.num_mcast_sta, ATOMIC);
 IEEE80211_IF_FILE(num_sta_ps, u.ap.ps.num_sta_ps, ATOMIC);
 IEEE80211_IF_FILE(dtim_count, u.ap.ps.dtim_count, DEC);
+IEEE80211_IF_FILE(vlan_num_mcast_sta, u.vlan.num_mcast_sta, ATOMIC);
 
 static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -594,6 +595,11 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 }
 
+static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD(vlan_num_mcast_sta);
+}
+
 static void add_ibss_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD_MODE(tsf, 0600);
@@ -697,6 +703,9 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	case NL80211_IFTYPE_AP:
 		add_ap_files(sdata);
 		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		add_vlan_files(sdata);
+		break;
 	case NL80211_IFTYPE_WDS:
 		add_wds_files(sdata);
 		break;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8d53d65..722ad28 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -305,6 +305,7 @@ struct ieee80211_if_vlan {
 
 	/* used for all tx if the VLAN is configured to 4-addr mode */
 	struct sta_info __rcu *sta;
+	atomic_t num_mcast_sta; /* number of stations receiving multicast */
 };
 
 struct mesh_stats {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 00ca8dc..68f9d2b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -143,6 +143,17 @@ static void __cleanup_single_sta(struct sta_info *sta)
 		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
 		kfree(tid_tx);
 	}
+
+	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
+		    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		     !sta->sdata->u.vlan.sta))
+			atomic_dec(&sta->sdata->bss->num_mcast_sta);
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		     !sta->sdata->u.vlan.sta)
+			atomic_dec(&sta->sdata->u.vlan.num_mcast_sta);
+		clear_sta_flag(sta, WLAN_STA_AUTHORIZED);
+	}
 }
 
 static void cleanup_single_sta(struct sta_info *sta)
@@ -1694,6 +1705,9 @@ int sta_info_move_state(struct sta_info *sta,
 			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 			     !sta->sdata->u.vlan.sta))
 				atomic_dec(&sta->sdata->bss->num_mcast_sta);
+			if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			     !sta->sdata->u.vlan.sta)
+				atomic_dec(&sta->sdata->u.vlan.num_mcast_sta);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
 		break;
@@ -1703,6 +1717,9 @@ int sta_info_move_state(struct sta_info *sta,
 			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 			     !sta->sdata->u.vlan.sta))
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
+			if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			     !sta->sdata->u.vlan.sta)
+				atomic_inc(&sta->sdata->u.vlan.num_mcast_sta);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
 		break;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 07bd8db..ff10e00 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -330,6 +330,14 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		 * frames.
 		 */
 		return TX_DROP;
+	} else if (unlikely(tx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			    ieee80211_is_data(hdr->frame_control) &&
+			    !atomic_read(&tx->sdata->u.vlan.num_mcast_sta))) {
+		/*
+		 * No associated STAs - no need to send multicast
+		 * frames.
+		 */
+		return TX_DROP;
 	}
 
 	return TX_CONTINUE;
-- 
1.9.1


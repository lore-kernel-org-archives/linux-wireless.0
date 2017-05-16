Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55174 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbdEPJXd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:23:33 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/7] mac80211: Mark channel as unusable if a regulatory MESH CSA is received
Date: Tue, 16 May 2017 11:23:10 +0200
Message-Id: <20170516092316.15636-2-sw@simonwunderlich.de> (sfid-20170516_112815_050541_574397D9)
In-Reply-To: <20170516092316.15636-1-sw@simonwunderlich.de>
References: <20170516092316.15636-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin@sipsolutions.net>

In the Mesh Channel Switch Parameters (8.4.2.105) the reason is specified
to WLAN_REASON_MESH_CHAN_REGULATORY in the case that a regulatory
limitation was the cause for the switch. This means another station
detected a radar event.

Mark the channel as unusable if this happens.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
[sw: style cleanup, rebase]
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mesh.c        | 21 +++++++++++++++++++++
 net/mac80211/spectmgmt.c   |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f8f6c148f554..60bed6c69801 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1440,6 +1440,7 @@ struct ieee80211_csa_ie {
 	u8 count;
 	u8 ttl;
 	u16 pre_value;
+	u16 reason_code;
 };
 
 /* Parsed Information Elements */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 737e1f082b0d..3702e3d9141d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -916,6 +916,21 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_configure_filter(local);
 }
 
+static void ieee80211_mesh_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
+{
+	int err;
+
+	/* if the current channel is a DFS channel, mark the channel as
+	 * unavailable.
+	 */
+	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
+					    &sdata->vif.bss_conf.chandef,
+					    NL80211_IFTYPE_MESH_POINT);
+	if (err > 0)
+		cfg80211_radar_event(sdata->local->hw.wiphy,
+				     &sdata->vif.bss_conf.chandef, GFP_ATOMIC);
+}
+
 static bool
 ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems, bool beacon)
@@ -954,6 +969,12 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	if (err)
 		return false;
 
+	/* Mark the channel unavailable if the reason for the switch is
+	 * regulatory.
+	 */
+	if (csa_ie.reason_code == WLAN_REASON_MESH_CHAN_REGULATORY)
+		ieee80211_mesh_csa_mark_radar(sdata);
+
 	params.chandef = csa_ie.chandef;
 	params.count = csa_ie.count;
 
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 0782e486fe89..d2ea0017c79d 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -76,6 +76,11 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		csa_ie->mode = elems->mesh_chansw_params_ie->mesh_flags;
 		csa_ie->pre_value = le16_to_cpu(
 				elems->mesh_chansw_params_ie->mesh_pre_value);
+
+		if (elems->mesh_chansw_params_ie->mesh_flags &
+				WLAN_EID_CHAN_SWITCH_PARAM_REASON)
+			csa_ie->reason_code = le16_to_cpu(
+				elems->mesh_chansw_params_ie->mesh_reason);
 	}
 
 	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
-- 
2.11.0

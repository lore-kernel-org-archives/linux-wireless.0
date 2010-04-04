Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:42216 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0DDTuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 15:50:07 -0400
Received: by fxm27 with SMTP id 27so588024fxm.28
        for <linux-wireless@vger.kernel.org>; Sun, 04 Apr 2010 12:50:06 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] mac80211: fix ieee80211_meshconf_ie::meshconf_cap type to be __le16
Date: Sun,  4 Apr 2010 23:50:01 +0400
Message-Id: <1270410601-9177-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <201004042339.35467.jcmvbkbc@gmail.com>
References: <201004042339.35467.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the current 802.11s draft mesh capability field
is 16 bits wide.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 include/linux/ieee80211.h |    2 +-
 net/mac80211/mesh.c       |   25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1998495..6e8d436 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -604,7 +604,7 @@ struct ieee80211_meshconf_ie {
 	u8 meshconf_synch;
 	u8 meshconf_auth;
 	u8 meshconf_form;
-	u8 meshconf_cap;
+	__le16 meshconf_cap;
 } __attribute__ ((packed));
 
 /**
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 61080c5..fead4af 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -99,7 +99,7 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
 {
 	return (ie->mesh_config->meshconf_cap &
-	    MESHCONF_CAPAB_ACCEPT_PLINKS) != 0;
+	    cpu_to_le16(MESHCONF_CAPAB_ACCEPT_PLINKS)) != 0;
 }
 
 /**
@@ -216,6 +216,7 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_meshconf_ie *meshconf;
 	u8 *pos;
 	int len, i, rate;
 	u8 neighbors;
@@ -259,33 +260,35 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	*pos++ = WLAN_EID_MESH_CONFIG;
 	*pos++ = sizeof(struct ieee80211_meshconf_ie);
 
+	meshconf = (struct ieee80211_meshconf_ie *)pos;
+	pos += sizeof(struct ieee80211_meshconf_ie);
+
 	/* Active path selection protocol ID */
-	*pos++ = sdata->u.mesh.mesh_pp_id;
+	meshconf->meshconf_psel = sdata->u.mesh.mesh_pp_id;
 
 	/* Active path selection metric ID   */
-	*pos++ = sdata->u.mesh.mesh_pm_id;
+	meshconf->meshconf_pmetric = sdata->u.mesh.mesh_pm_id;
 
 	/* Congestion control mode identifier */
-	*pos++ = sdata->u.mesh.mesh_cc_id;
+	meshconf->meshconf_congest = sdata->u.mesh.mesh_cc_id;
 
 	/* Synchronization protocol identifier */
-	*pos++ = sdata->u.mesh.mesh_sp_id;
+	meshconf->meshconf_synch = sdata->u.mesh.mesh_sp_id;
 
 	/* Authentication Protocol identifier */
-	*pos++ = sdata->u.mesh.mesh_auth_id;
+	meshconf->meshconf_auth = sdata->u.mesh.mesh_auth_id;
 
 	/* Mesh Formation Info - number of neighbors */
 	neighbors = atomic_read(&sdata->u.mesh.mshstats.estab_plinks);
 	/* Number of neighbor mesh STAs or 15 whichever is smaller */
 	neighbors = (neighbors > 15) ? 15 : neighbors;
-	*pos++ = neighbors << 1;
+	meshconf->meshconf_form = neighbors << 1;
 
 	/* Mesh capability */
 	sdata->u.mesh.accepting_plinks = mesh_plink_availables(sdata);
-	*pos = MESHCONF_CAPAB_FORWARDING;
-	*pos++ |= sdata->u.mesh.accepting_plinks ?
-	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
-	*pos++ = 0x00;
+	meshconf->meshconf_cap = cpu_to_le16(MESHCONF_CAPAB_FORWARDING);
+	meshconf->meshconf_cap |= sdata->u.mesh.accepting_plinks ?
+	    cpu_to_le16(MESHCONF_CAPAB_ACCEPT_PLINKS) : 0x00;
 
 	return;
 }
-- 
1.6.2.5


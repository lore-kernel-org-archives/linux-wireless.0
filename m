Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37973 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab1CRUXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 16:23:12 -0400
Received: by mail-iy0-f174.google.com with SMTP id 26so4365892iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 13:23:12 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/5 v4] mac80211: Let userspace create stations when mesh security is enabled
Date: Fri, 18 Mar 2011 13:22:11 -0700
Message-Id: <1300479732-25920-5-git-send-email-javier@cozybit.com>
In-Reply-To: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace can enable mesh security via the new
MESH_SETUP_ENABLE_SECURITY flag and by providing an RSN information
element.  When that happens, the mesh stack will delegate station
management to userspace.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c       |    4 ++++
 net/mac80211/mesh_plink.c |   11 ++++++++---
 net/wireless/nl80211.c    |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1c244c0..47a26c0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -573,6 +573,10 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 			       &elems);
 
+	/* ignore beacons from secure mesh peers if our security is off */
+	if (elems.rsn_len && !sdata->u.mesh.is_secure)
+		return;
+
 	if (elems.ds_params && elems.ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems.ds_params[0], band);
 	else
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c705b20..b4b1c53 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -105,7 +105,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return NULL;
 
-	sta->flags = WLAN_STA_AUTHORIZED;
+	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	rate_control_rate_init(sta);
 
@@ -248,8 +248,9 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data
 	sta = sta_info_get(sdata, hw_addr);
 	if (!sta) {
 		rcu_read_unlock();
-
-		sta = mesh_plink_alloc(sdata, hw_addr, rates);
+		/* Userspace handles peer allocation when security is enabled */
+		if (!sdata->u.mesh.is_secure)
+			sta = mesh_plink_alloc(sdata, hw_addr, rates);
 		if (!sta)
 			return;
 		if (sta_info_insert_rcu(sta)) {
@@ -449,6 +450,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		mpl_dbg("Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
+	if (elems.rsn_len && !sdata->u.mesh.is_secure) {
+		mpl_dbg("Mesh plink: can't establish link with secure peer\n");
+		return;
+	}
 
 	ftype = mgmt->u.action.u.plink_action.action_code;
 	ie_len = elems.peer_link_len;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a45c12c..316e08f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2329,6 +2329,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EINVAL;
 
-- 
1.7.1


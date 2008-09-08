Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYIHNmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 09:42:06 -0400
Subject: [PATCH 4/3] mac80211: fix action frame length checks
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Tomas Winkler <tomasw@gmail.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <20080908090507.641740000@sipsolutions.net> (sfid-20080908_110822_044365_11756028)
References: <20080908090507.641740000@sipsolutions.net>
	 (sfid-20080908_110822_044365_11756028)
Content-Type: text/plain
Date: Mon, 08 Sep 2008 15:41:59 +0200
Message-Id: <1220881319.31304.56.camel@johannes.berg> (sfid-20080908_154211_736656_F02195E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The action frame length checks are one too small, there's not just
an action code as the comment makes you believe, there's a category
code too, and the category code is required in each action frame
(hence part of IEEE80211_MIN_ACTION_SIZE).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mesh_hwmp.c  |    4 ++++
 net/mac80211/mesh_plink.c |    4 ++++
 net/mac80211/mlme.c       |    5 +++--
 3 files changed, 11 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/mesh_hwmp.c	2008-09-08 15:37:12.000000000 +0200
+++ everything/net/mac80211/mesh_hwmp.c	2008-09-08 15:37:25.000000000 +0200
@@ -581,6 +581,10 @@ void mesh_rx_path_sel_frame(struct ieee8
 	size_t baselen;
 	u32 last_hop_metric;
 
+	/* need action_code */
+	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+		return;
+
 	baselen = (u8 *) mgmt->u.action.u.mesh_action.variable - (u8 *) mgmt;
 	ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
 			len - baselen, &elems);
--- everything.orig/net/mac80211/mesh_plink.c	2008-09-08 15:37:12.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-09-08 15:37:25.000000000 +0200
@@ -421,6 +421,10 @@ void mesh_rx_plink_frame(struct ieee8021
 	DECLARE_MAC_BUF(mac);
 #endif
 
+	/* need action_code, aux */
+	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
+		return;
+
 	if (is_multicast_ether_addr(mgmt->da)) {
 		mpl_dbg("Mesh plink: ignore frame from multicast address");
 		return;
--- everything.orig/net/mac80211/mlme.c	2008-09-08 15:37:17.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 15:37:25.000000000 +0200
@@ -60,7 +60,7 @@
 
 #define ERP_INFO_USE_PROTECTION BIT(1)
 
-/* mgmt header + 1 byte action code */
+/* mgmt header + 1 byte category code */
 #define IEEE80211_MIN_ACTION_SIZE (24 + 1)
 
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
@@ -2989,7 +2989,8 @@ static void ieee80211_rx_mgmt_action(str
 {
 	struct ieee80211_local *local = sdata->local;
 
-	if (len < IEEE80211_MIN_ACTION_SIZE)
+	/* all categories we currently handle have action_code */
+	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 		return;
 
 	switch (mgmt->u.action.category) {



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYBYPZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:25:02 -0500
Subject: [PATCH] mac80211: clean up mesh RX path a bit more
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 16:24:38 +0100
Message-Id: <1203953078.13162.108.camel@johannes.berg> (sfid-20080225_152539_320655_9E958903)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moves another ifdef into the sta_info header file in favour of
compiling more code even w/o CONFIG_MAC80211_MESH.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
---
Luis, should sta_plink_state return something else for the non-mesh
case? Can you please make a patch that
 (a) renames the enum plink_state members to PLINK_*
 (b) explains them with a kernel-doc comment
 (c) changes the return there if required

You should probably wait until after the sta_info rework I'm about to
post.

Thanks,
johannes

 net/mac80211/rx.c       |   17 ++++++-----------
 net/mac80211/sta_info.h |    8 ++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-02-25 16:23:36.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-25 16:23:39.000000000 +0100
@@ -391,13 +391,14 @@ ieee80211_rx_h_passive_scan(struct ieee8
 	return RX_CONTINUE;
 }
 
-#ifdef CONFIG_MAC80211_MESH
-#define msh_h_get(h, l) ((struct ieee80211s_hdr *) ((u8 *)h + l))
 static ieee80211_rx_result
 ieee80211_rx_mesh_check(struct ieee80211_txrx_data *rx)
 {
 	int hdrlen = ieee80211_get_hdrlen(rx->fc);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+
+#define msh_h_get(h, l) ((struct ieee80211s_hdr *) ((u8 *)h + l))
+
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) {
 		if (!((rx->fc & IEEE80211_FCTL_FROMDS) &&
 		      (rx->fc & IEEE80211_FCTL_TODS)))
@@ -410,8 +411,9 @@ ieee80211_rx_mesh_check(struct ieee80211
 	 * establisment frame, beacon or probe, drop the frame.
 	 */
 
-	if (!rx->sta || rx->sta->plink_state != ESTAB) {
+	if (!rx->sta || sta_plink_state(rx->sta) != ESTAB) {
 		struct ieee80211_mgmt *mgmt;
+
 		if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
 			return RX_DROP_MONITOR;
 
@@ -434,17 +436,10 @@ ieee80211_rx_mesh_check(struct ieee80211
 		    is_broadcast_ether_addr(hdr->addr1) &&
 		    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
 		return RX_DROP_MONITOR;
-	else
-		return RX_CONTINUE;
-}
 #undef msh_h_get
-#else
-static inline ieee80211_rx_result
-ieee80211_rx_mesh_check(struct ieee80211_txrx_data *rx)
-{
+
 	return RX_CONTINUE;
 }
-#endif
 
 
 static ieee80211_rx_result
--- everything.orig/net/mac80211/sta_info.h	2008-02-25 16:23:36.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-25 16:23:39.000000000 +0100
@@ -239,6 +239,14 @@ struct sta_info {
 #endif
 };
 
+static inline enum plink_state sta_plink_state(struct sta_info *sta)
+{
+#ifdef CONFIG_MAC80211_MESH
+	return sta->plink_state;
+#endif
+	return LISTEN;
+}
+
 
 /* Maximum number of concurrently registered stations */
 #define MAX_STA_COUNT 2007



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYJ1SgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:36:06 -0400
Subject: [PATCH] wireless: move mesh config length constant
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 11:12:57 +0100
Message-Id: <1225188777.3598.2.camel@johannes.berg> (sfid-20081028_193616_379279_C76D11AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a constant from the 802.11 specification.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    3 +++
 net/mac80211/mesh.c       |    2 +-
 net/mac80211/mesh.h       |    5 +----
 net/mac80211/scan.c       |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- everything.orig/net/mac80211/scan.c	2008-10-28 11:08:56.000000000 +0100
+++ everything/net/mac80211/scan.c	2008-10-28 11:08:59.000000000 +0100
@@ -159,7 +159,7 @@ ieee80211_rx_mesh_bss_add(struct ieee802
 {
 	struct ieee80211_bss *bss;
 
-	if (mesh_config_len != MESH_CFG_LEN)
+	if (mesh_config_len != IEEE80211_MESH_CONFIG_LEN)
 		return NULL;
 
 	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
--- everything.orig/include/linux/ieee80211.h	2008-10-28 11:08:55.000000000 +0100
+++ everything/include/linux/ieee80211.h	2008-10-28 11:09:30.000000000 +0100
@@ -97,7 +97,10 @@
 #define IEEE80211_MAX_FRAME_LEN		2352
 
 #define IEEE80211_MAX_SSID_LEN		32
+
 #define IEEE80211_MAX_MESH_ID_LEN	32
+#define IEEE80211_MESH_CONFIG_LEN	19
+
 #define IEEE80211_QOS_CTL_LEN		2
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
 #define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007
--- everything.orig/net/mac80211/mesh.c	2008-10-28 11:08:56.000000000 +0100
+++ everything/net/mac80211/mesh.c	2008-10-28 11:08:59.000000000 +0100
@@ -238,7 +238,7 @@ void mesh_mgmt_ies_add(struct sk_buff *s
 
 	pos = skb_put(skb, 21);
 	*pos++ = WLAN_EID_MESH_CONFIG;
-	*pos++ = MESH_CFG_LEN;
+	*pos++ = IEEE80211_MESH_CONFIG_LEN;
 	/* Version */
 	*pos++ = 1;
 
--- everything.orig/net/mac80211/mesh.h	2008-10-28 11:08:56.000000000 +0100
+++ everything/net/mac80211/mesh.h	2008-10-28 11:11:34.000000000 +0100
@@ -145,9 +145,6 @@ struct mesh_rmc {
 };
 
 
-/* Mesh IEs constants */
-#define MESH_CFG_LEN		19
-
 /*
  * MESH_CFG_COMP_LEN Includes:
  * 	- Active path selection protocol ID.
@@ -157,7 +154,7 @@ struct mesh_rmc {
  * Does not include mesh capabilities, which may vary across nodes in the same
  * mesh
  */
-#define MESH_CFG_CMP_LEN 	17
+#define MESH_CFG_CMP_LEN 	(IEEE80211_MESH_CONFIG_LEN - 2)
 
 /* Default values, timeouts in ms */
 #define MESH_TTL 		5



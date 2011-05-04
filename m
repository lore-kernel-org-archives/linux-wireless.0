Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49906 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1EDRZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 13:25:07 -0400
Received: by pwi15 with SMTP id 15so608984pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 10:25:07 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] cfg80211: Use capability info to detect mesh beacons.
Date: Wed,  4 May 2011 10:24:56 -0700
Message-Id: <1304529896-20934-1-git-send-email-javier@cozybit.com> (sfid-20110504_192512_519248_E5EDC844)
In-Reply-To: <1304513847.3563.15.camel@jlt3.sipsolutions.net>
References: <1304513847.3563.15.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh beacons no longer use all-zeroes BSSID.  Beacon frames for MBSS,
infrastructure BSS, or IBSS are differentiated by the Capability
Information field in the Beacon frame.  A mesh STA sets the ESS and IBSS
subfields to 0 in transmitted Beacon or Probe Response management
frames.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    5 +++++
 net/wireless/scan.c       |   14 +++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a26dcb8..b2eee58 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1002,6 +1002,11 @@ struct ieee80211_ht_info {
 
 #define WLAN_CAPABILITY_ESS		(1<<0)
 #define WLAN_CAPABILITY_IBSS		(1<<1)
+
+/* A mesh STA sets the ESS and IBSS capability bits to zero */
+#define WLAN_CAPABILITY_IS_MBSS(cap)	\
+	(!((cap) & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)))
+
 #define WLAN_CAPABILITY_CF_POLLABLE	(1<<2)
 #define WLAN_CAPABILITY_CF_POLL_REQUEST	(1<<3)
 #define WLAN_CAPABILITY_PRIVACY		(1<<4)
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index fbf6f33..62e542a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -210,7 +210,7 @@ static bool is_mesh(struct cfg80211_bss *a,
 {
 	const u8 *ie;
 
-	if (!is_zero_ether_addr(a->bssid))
+	if (!WLAN_CAPABILITY_IS_MBSS(a->capability))
 		return false;
 
 	ie = cfg80211_find_ie(WLAN_EID_MESH_ID,
@@ -248,11 +248,7 @@ static int cmp_bss(struct cfg80211_bss *a,
 	if (a->channel != b->channel)
 		return b->channel->center_freq - a->channel->center_freq;
 
-	r = memcmp(a->bssid, b->bssid, ETH_ALEN);
-	if (r)
-		return r;
-
-	if (is_zero_ether_addr(a->bssid)) {
+	if (WLAN_CAPABILITY_IS_MBSS(a->capability | b->capability)) {
 		r = cmp_ies(WLAN_EID_MESH_ID,
 			    a->information_elements,
 			    a->len_information_elements,
@@ -267,6 +263,10 @@ static int cmp_bss(struct cfg80211_bss *a,
 			       b->len_information_elements);
 	}
 
+	r = memcmp(a->bssid, b->bssid, ETH_ALEN);
+	if (r)
+		return r;
+
 	return cmp_ies(WLAN_EID_SSID,
 		       a->information_elements,
 		       a->len_information_elements,
@@ -407,7 +407,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 
 	res->ts = jiffies;
 
-	if (is_zero_ether_addr(res->pub.bssid)) {
+	if (WLAN_CAPABILITY_IS_MBSS(res->pub.capability)) {
 		/* must be mesh, verify */
 		meshid = cfg80211_find_ie(WLAN_EID_MESH_ID,
 					  res->pub.information_elements,
-- 
1.7.1


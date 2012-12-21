Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:47067 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab2LULpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 06:45:20 -0500
Message-ID: <50D44BCC.30304@posedge.com> (sfid-20121221_124524_956861_72670AE5)
Date: Fri, 21 Dec 2012 17:15:17 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix the MAX MTU calculation
References: <201212211141.qBLBfZdq015078@chaitanya-desktop>
In-Reply-To: <201212211141.qBLBfZdq015078@chaitanya-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fix the Max MTU calculations.
Do not take headers in to account, only MAX MSDU size
as per 802.11-2012(8.2.3) is enough.

ToDo: Add support for AMSDU in future.

Signed-off-by: T Krishna Chaitanya <chaitanyatk@posedge.com>
---

 net/mac80211/iface.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 54fb7f9..5e5e876 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -207,15 +207,24 @@ void ieee80211_recalc_idle(struct ieee80211_local *local)
 
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 {
-	int meshhdrlen;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	meshhdrlen = (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) ? 5 : 0;
+	/* 802.11-2012: 8.2.3: The maximum frame body size is determined by
+	1. The maximum MSDU size (2304 octets),
+	2. plus the length of the Mesh Control field (6, 12, or 18 octets)
+		if present,
+	3. the maximum unencrypted MMPDU size excluding the MAC header and
+		FCS (2304 octets) or
+	4. the maximum A- MSDU size (3839 or 7935 octets),
+		plus any overhead from security encapsulation.
+	Note1: IEEE80211_MAX_DATA_LEN doesnt include any headers (2304),
+		so it can be used directly+ Mesh HDR Len
+	Note2: In Other places (skb_alloc) its handled properly.
+
+	ToDO: Make the MAX_DATA_LEN driver configurable through its
+	AMSDU capabilities.
+	 */
 
-	/* FIX: what would be proper limits for MTU?
-	 * This interface uses 802.3 frames. */
 	if (new_mtu < 256 ||
-	    new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
+	    new_mtu > IEEE80211_MAX_DATA_LEN) {
 		return -EINVAL;
 	}
 





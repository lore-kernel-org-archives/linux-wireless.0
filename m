Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:28419 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYDWTu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 15:50:58 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1692780wra.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2008 12:50:57 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Wed, 23 Apr 2008 12:34:59 -0700
Subject: [PATCH] mac80211: update mesh EID values
Message-ID: <480f9321.14045a0a.5b67.51aa@mx.google.com> (sfid-20080423_215133_797669_8D1C298B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates mesh EID values, some of which where conflicting with
already-approved 11h EIDs (pointed out by Tomas Winkler). I wanted to use the
values suggested in the last available 802.11 draft (2.0) but it assigns 50 to
MESH_CONFIG, the same value than EXT_SUPP_RATES. Using the values proposed in
the draft incremented by one.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/ieee80211.h |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index c840bd1..0b5e03e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -465,13 +465,19 @@ enum ieee80211_eid {
 	WLAN_EID_TS_DELAY = 43,
 	WLAN_EID_TCLAS_PROCESSING = 44,
 	WLAN_EID_QOS_CAPA = 46,
-	/* 802.11s */
-	WLAN_EID_MESH_CONFIG = 36,      /* Pending IEEE 802.11 ANA approval */
-	WLAN_EID_MESH_ID = 37,          /* Pending IEEE 802.11 ANA approval */
-	WLAN_EID_PEER_LINK = 40,	/* Pending IEEE 802.11 ANA approval */
-	WLAN_EID_PREQ = 53,		/* Pending IEEE 802.11 ANA approval */
-	WLAN_EID_PREP = 54,		/* Pending IEEE 802.11 ANA approval */
-	WLAN_EID_PERR = 55,		/* Pending IEEE 802.11 ANA approval */
+	/* 802.11s
+	 *
+	 * All mesh EID numbers are pending IEEE 802.11 ANA approval.
+	 * The numbers have been incremented from those suggested in
+	 * 802.11s/D2.0 so that MESH_CONFIG does not conflict with
+	 * EXT_SUPP_RATES.
+	 */
+	WLAN_EID_MESH_CONFIG = 51,
+	WLAN_EID_MESH_ID = 52,
+	WLAN_EID_PEER_LINK = 55,
+	WLAN_EID_PREQ = 68,
+	WLAN_EID_PREP = 69,
+	WLAN_EID_PERR = 70,
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
-- 
1.5.4.3




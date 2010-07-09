Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58274 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0GIXtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 19:49:12 -0400
Received: by pzk26 with SMTP id 26so592298pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jul 2010 16:49:11 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, Steve deRosier <steve@cozybit.com>
Subject: [PATCH] mac80211: update mesh information element values
Date: Fri,  9 Jul 2010 16:48:50 -0700
Message-Id: <1278719330-56441-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old values conflicted with ANA approved values. The new values
were chosen to be consistent with those for the ANA request plan
for 802.11s.

The Peer Link IE no longer exists in draft standards, replaced by
the Peer Management IE.  Leaving the old definition in was prudent
until mesh code can be changed to match.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 include/linux/ieee80211.h |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 97b2eae..1ed60b5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1142,17 +1142,20 @@ enum ieee80211_eid {
 	/* 802.11s
 	 *
 	 * All mesh EID numbers are pending IEEE 802.11 ANA approval.
-	 * The numbers have been incremented from those suggested in
-	 * 802.11s/D2.0 so that MESH_CONFIG does not conflict with
-	 * EXT_SUPP_RATES.
+	 * The numbers have been taken from ANA request plan for 802.11s
+	 *
+	 * Note that the Peer Link IE has been replaced with the similar
+	 * Peer Management IE.  We will keep the former definition until mesh
+	 * code is changed to comply with latest 802.11s drafts.
 	 */
-	WLAN_EID_MESH_CONFIG = 51,
-	WLAN_EID_MESH_ID = 52,
-	WLAN_EID_PEER_LINK = 55,
-	WLAN_EID_PREQ = 68,
-	WLAN_EID_PREP = 69,
-	WLAN_EID_PERR = 70,
-	WLAN_EID_RANN = 49,	/* compatible with FreeBSD */
+	WLAN_EID_MESH_CONFIG = 113,
+	WLAN_EID_MESH_ID = 114,
+	WLAN_EID_PEER_MGMT = 115,
+	WLAN_EID_PEER_LINK = 55,  /* no longer in 802.11s drafts */
+	WLAN_EID_PREQ = 130,
+	WLAN_EID_PREP = 131,
+	WLAN_EID_PERR = 132,
+	WLAN_EID_RANN = 126,
 
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
-- 
1.7.0


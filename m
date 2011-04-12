Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54954 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab1DLLKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:10:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Q9bTw-0000a9-Db
	for linux-wireless@vger.kernel.org; Tue, 12 Apr 2011 13:10:04 +0200
Received: from 89.204.153.111 ([89.204.153.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 13:10:04 +0200
Received: from alexander.simon by 89.204.153.111 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 13:10:04 +0200
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: Re: [PATCH 3/4] mac80211: Add function to build HT caps
Date: Tue, 12 Apr 2011 11:06:11 +0000 (UTC)
Message-ID: <loom.20110412T130449-831@post.gmane.org>
References: <1302604964.2139.5.camel@alex-2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some refracturing work.

Add a new function ieee80211_ie_build_ht_cap in util.c.
Use this shared code from ieee80211_build_preq_ies (util.c) and
ieee80211_add_ht_ie (work.c)

This will be used from ibss.c also.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 ieee80211_i.h |    2 ++
 util.c        |   54 +++++++++++++++++++++++++++++++++++++-----------------
 work.c        |   29 +----------------------------
 3 files changed, 40 insertions(+), 45 deletions(-)

diff -Nrup a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
--- a/net/mac80211/ieee80211_i.h	2011-03-31 21:04:02.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-04-12 09:55:16.000000000 +0200
@@ -1351,6 +1352,8 @@ void ieee80211_recalc_smps(struct ieee80
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
+                              u16 cap);
 
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
diff -Nrup a/net/mac80211/util.c b/net/mac80211/util.c
--- a/net/mac80211/util.c	2011-03-31 21:04:02.000000000 +0200
+++ b/net/mac80211/util.c	2011-04-12 09:55:48.000000000 +0200
@@ -1007,23 +1007,8 @@ int ieee80211_build_preq_ies(struct ieee
 		offset = noffset;
 	}
 
-	if (sband->ht_cap.ht_supported) {
-		u16 cap = sband->ht_cap.cap;
-		__le16 tmp;
-
-		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_cap);
-		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-		tmp = cpu_to_le16(cap);
-		memcpy(pos, &tmp, sizeof(u16));
-		pos += sizeof(u16);
-		*pos++ = sband->ht_cap.ampdu_factor |
-			 (sband->ht_cap.ampdu_density <<
-				IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-		pos += sizeof(sband->ht_cap.mcs);
-		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
-	}
+	if (sband->ht_cap.ht_supported)
+		pos = ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
 
 	/*
 	 * If adding more here, adjust code in main.c
@@ -1443,3 +1428,38 @@ size_t ieee80211_ie_split_vendor(const u
 
 	return pos;
 }
+
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
+                              u16 cap)
+{
+	__le16 tmp;
+
+	*pos++ = WLAN_EID_HT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_ht_cap);
+	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+
+	/* capability flags */
+	tmp = cpu_to_le16(cap);
+	memcpy(pos, &tmp, sizeof(u16));
+	pos += sizeof(u16);
+
+	/* AMPDU parameters */
+	*pos++ = sband->ht_cap.ampdu_factor |
+		 (sband->ht_cap.ampdu_density <<
+			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+
+	/* MCS set */
+	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+	pos += sizeof(sband->ht_cap.mcs);
+
+	/* extended capabilities */
+	pos += sizeof(__le16);
+
+	/* BF capabilities */
+	pos += sizeof(__le32);
+
+	/* antenna selection */
+	pos += sizeof(u8);
+
+	return pos;
+}
diff -Nrup a/net/mac80211/work.c b/net/mac80211/work.c
--- a/net/mac80211/work.c	2011-03-31 21:04:01.000000000 +0200
+++ b/net/mac80211/work.c	2011-04-12 09:43:30.000000000 +0200
@@ -110,7 +110,6 @@ static void ieee80211_add_ht_ie(struct s
 	u8 *pos;
 	u32 flags = channel->flags;
 	u16 cap = sband->ht_cap.cap;
-	__le16 tmp;
 
 	if (!sband->ht_cap.ht_supported)
 		return;
@@ -161,34 +160,8 @@ static void ieee80211_add_ht_ie(struct s
 	}
 
 	/* reserve and fill IE */
-
 	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
-	*pos++ = WLAN_EID_HT_CAPABILITY;
-	*pos++ = sizeof(struct ieee80211_ht_cap);
-	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-
-	/* capability flags */
-	tmp = cpu_to_le16(cap);
-	memcpy(pos, &tmp, sizeof(u16));
-	pos += sizeof(u16);
-
-	/* AMPDU parameters */
-	*pos++ = sband->ht_cap.ampdu_factor |
-		 (sband->ht_cap.ampdu_density <<
-			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-
-	/* MCS set */
-	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-	pos += sizeof(sband->ht_cap.mcs);
-
-	/* extended capabilities */
-	pos += sizeof(__le16);
-
-	/* BF capabilities */
-	pos += sizeof(__le32);
-
-	/* antenna selection */
-	pos += sizeof(u8);
+	ieee80211_ie_build_ht_cap(pos, sband, cap);
 }
 
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,



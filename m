Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54223 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756528AbcLNTrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:17 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 09/10] mac80211: minstrel_ht: remove obsolete #if for >= 3 streams
Date: Wed, 14 Dec 2016 20:47:02 +0100
Message-Id: <20161214194703.33429-9-nbd@nbd.name> (sfid-20161214_204742_170323_DD965662)
In-Reply-To: <20161214194703.33429-1-nbd@nbd.name>
References: <20161214194703.33429-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was added during early development when 3x3 hardware was not very
common yet. This is completely unnecessary now.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ae45dcb..8e783e1 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -155,67 +155,47 @@ MODULE_PARM_DESC(minstrel_vht_only,
 const struct mcs_group minstrel_mcs_groups[] = {
 	MCS_GROUP(1, 0, BW_20),
 	MCS_GROUP(2, 0, BW_20),
-#if MINSTREL_MAX_STREAMS >= 3
 	MCS_GROUP(3, 0, BW_20),
-#endif
 
 	MCS_GROUP(1, 1, BW_20),
 	MCS_GROUP(2, 1, BW_20),
-#if MINSTREL_MAX_STREAMS >= 3
 	MCS_GROUP(3, 1, BW_20),
-#endif
 
 	MCS_GROUP(1, 0, BW_40),
 	MCS_GROUP(2, 0, BW_40),
-#if MINSTREL_MAX_STREAMS >= 3
 	MCS_GROUP(3, 0, BW_40),
-#endif
 
 	MCS_GROUP(1, 1, BW_40),
 	MCS_GROUP(2, 1, BW_40),
-#if MINSTREL_MAX_STREAMS >= 3
 	MCS_GROUP(3, 1, BW_40),
-#endif
 
 	CCK_GROUP,
 
 #ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
 	VHT_GROUP(1, 0, BW_20),
 	VHT_GROUP(2, 0, BW_20),
-#if MINSTREL_MAX_STREAMS >= 3
 	VHT_GROUP(3, 0, BW_20),
-#endif
 
 	VHT_GROUP(1, 1, BW_20),
 	VHT_GROUP(2, 1, BW_20),
-#if MINSTREL_MAX_STREAMS >= 3
 	VHT_GROUP(3, 1, BW_20),
-#endif
 
 	VHT_GROUP(1, 0, BW_40),
 	VHT_GROUP(2, 0, BW_40),
-#if MINSTREL_MAX_STREAMS >= 3
 	VHT_GROUP(3, 0, BW_40),
-#endif
 
 	VHT_GROUP(1, 1, BW_40),
 	VHT_GROUP(2, 1, BW_40),
-#if MINSTREL_MAX_STREAMS >= 3
 	VHT_GROUP(3, 1, BW_40),
-#endif
 
 	VHT_GROUP(1, 0, BW_80),
 	VHT_GROUP(2, 0, BW_80),
-#if MINSTREL_MAX_STREAMS >= 3
 	VHT_GROUP(3, 0, BW_80),
-#endif
 
 	VHT_GROUP(1, 1, BW_80),
 	VHT_GROUP(2, 1, BW_80),
-#if MINSTREL_MAX_STREAMS >= 3
 	VHT_GROUP(3, 1, BW_80),
 #endif
-#endif
 };
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
-- 
2.10.1

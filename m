Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYFRM6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 08:58:47 -0400
Subject: [PATCH] mac80211: use separate spinlock for sta flags
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Ellingsworth <david@identd.dyndns.org>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Jun 2008 14:58:09 +0200
Message-Id: <1213793889.1312.17.camel@johannes.berg> (sfid-20080618_145851_108332_3D01A431)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Ellingsworth posted a bug that was only noticable on UP/NO-PREEMP=
T
and Michael correctly analysed it to be a spin_lock_bh() section within
a spin_lock_irqsave() section. This adds a separate spinlock for the
sta_info flags to fix that issue and avoid having to take much care
about where the sta flag manipulation functions are called.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-By: =EF=BB=BFDavid Ellingsworth <david@identd.dyndns.org>
---
 net/mac80211/sta_info.c |    1 +
 net/mac80211/sta_info.h |   40 +++++++++++++++++++++++++++------------=
-
 2 files changed, 28 insertions(+), 13 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-06-18 10:07:24.0000000=
00 +0200
+++ everything/net/mac80211/sta_info.h	2008-06-18 11:58:32.000000000 +0=
200
@@ -164,6 +164,7 @@ struct sta_ampdu_mlme {
  * @aid: STA's unique AID (1..2007, 0 =3D not assigned yet),
  *	only used in AP (and IBSS?) mode
  * @flags: STA flags, see &enum ieee80211_sta_info_flags
+ * @flaglock: spinlock for flags accesses
  * @ps_tx_buf: buffer of frames to transmit to this station
  *	when it leaves power saving state
  * @tx_filtered: buffer of frames we already tried to transmit
@@ -186,6 +187,7 @@ struct sta_info {
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t lock;
+	spinlock_t flaglock;
 	struct ieee80211_ht_info ht_info;
 	u64 supp_rates[IEEE80211_NUM_BANDS];
 	u8 addr[ETH_ALEN];
@@ -198,7 +200,10 @@ struct sta_info {
 	 */
 	u8 pin_status;
=20
-	/* frequently updated information, locked with lock spinlock */
+	/*
+	 * frequently updated, locked with own spinlock (flaglock),
+	 * use the accessors defined below
+	 */
 	u32 flags;
=20
 	/*
@@ -293,34 +298,41 @@ static inline enum plink_state sta_plink
=20
 static inline void set_sta_flags(struct sta_info *sta, const u32 flags=
)
 {
-	spin_lock_bh(&sta->lock);
+	unsigned long irqfl;
+
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	sta->flags |=3D flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 }
=20
 static inline void clear_sta_flags(struct sta_info *sta, const u32 fla=
gs)
 {
-	spin_lock_bh(&sta->lock);
+	unsigned long irqfl;
+
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	sta->flags &=3D ~flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 }
=20
 static inline void set_and_clear_sta_flags(struct sta_info *sta,
 					   const u32 set, const u32 clear)
 {
-	spin_lock_bh(&sta->lock);
+	unsigned long irqfl;
+
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	sta->flags |=3D set;
 	sta->flags &=3D ~clear;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 }
=20
 static inline u32 test_sta_flags(struct sta_info *sta, const u32 flags=
)
 {
 	u32 ret;
+	unsigned long irqfl;
=20
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	ret =3D sta->flags & flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
=20
 	return ret;
 }
@@ -329,11 +341,12 @@ static inline u32 test_and_clear_sta_fla
 					   const u32 flags)
 {
 	u32 ret;
+	unsigned long irqfl;
=20
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	ret =3D sta->flags & flags;
 	sta->flags &=3D ~flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
=20
 	return ret;
 }
@@ -341,10 +354,11 @@ static inline u32 test_and_clear_sta_fla
 static inline u32 get_sta_flags(struct sta_info *sta)
 {
 	u32 ret;
+	unsigned long irqfl;
=20
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	ret =3D sta->flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
=20
 	return ret;
 }
--- everything.orig/net/mac80211/sta_info.c	2008-06-18 11:56:44.0000000=
00 +0200
+++ everything/net/mac80211/sta_info.c	2008-06-18 11:56:58.000000000 +0=
200
@@ -235,6 +235,7 @@ struct sta_info *sta_info_alloc(struct i
 		return NULL;
=20
 	spin_lock_init(&sta->lock);
+	spin_lock_init(&sta->flaglock);
=20
 	memcpy(sta->addr, addr, ETH_ALEN);
 	sta->local =3D local;


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

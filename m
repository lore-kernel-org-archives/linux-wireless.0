Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYFRKDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 06:03:38 -0400
Subject: Re: mac80211 local_bh_enable called with IRQs disabled (was:
	b43legacy kernel warning)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	David Ellingsworth <david@identd.dyndns.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200806172320.18778.mb@bu3sch.de>
References: <30353c3d0806171359k6d7be389g23dfc809f288d2f1@mail.gmail.com>
	 <200806172320.18778.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 12:02:47 +0200
Message-Id: <1213783367.1312.2.camel@johannes.berg> (sfid-20080618_120351_179012_A3DD5D60)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-17 at 23:20 +0200, Michael Buesch wrote:
> On Tuesday 17 June 2008 22:59:52 David Ellingsworth wrote:
> > I ran into this error today from a kernel I built last night based on
> > the latest wireless-testing branch. Correct me if I'm wrong, but it
> > looks to be b43legacy related. I'm a bit new to kernel debugging but
> > can try to provide additional information if instructions on how to do
> > so are provided.
> 
> No, this is a mac80211 bug

Can you try the patch below?

johannes

--- everything.orig/net/mac80211/sta_info.h	2008-06-18 10:07:24.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-06-18 11:58:32.000000000 +0200
@@ -164,6 +164,7 @@ struct sta_ampdu_mlme {
  * @aid: STA's unique AID (1..2007, 0 = not assigned yet),
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
 
-	/* frequently updated information, locked with lock spinlock */
+	/*
+	 * frequently updated, locked with own spinlock (flaglock),
+	 * use the accessors defined below
+	 */
 	u32 flags;
 
 	/*
@@ -293,34 +298,41 @@ static inline enum plink_state sta_plink
 
 static inline void set_sta_flags(struct sta_info *sta, const u32 flags)
 {
-	spin_lock_bh(&sta->lock);
+	unsigned long irqfl;
+
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	sta->flags |= flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 }
 
 static inline void clear_sta_flags(struct sta_info *sta, const u32 flags)
 {
-	spin_lock_bh(&sta->lock);
+	unsigned long irqfl;
+
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	sta->flags &= ~flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 }
 
 static inline void set_and_clear_sta_flags(struct sta_info *sta,
 					   const u32 set, const u32 clear)
 {
-	spin_lock_bh(&sta->lock);
+	unsigned long irqfl;
+
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	sta->flags |= set;
 	sta->flags &= ~clear;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 }
 
 static inline u32 test_sta_flags(struct sta_info *sta, const u32 flags)
 {
 	u32 ret;
+	unsigned long irqfl;
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	ret = sta->flags & flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 
 	return ret;
 }
@@ -329,11 +341,12 @@ static inline u32 test_and_clear_sta_fla
 					   const u32 flags)
 {
 	u32 ret;
+	unsigned long irqfl;
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	ret = sta->flags & flags;
 	sta->flags &= ~flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 
 	return ret;
 }
@@ -341,10 +354,11 @@ static inline u32 test_and_clear_sta_fla
 static inline u32 get_sta_flags(struct sta_info *sta)
 {
 	u32 ret;
+	unsigned long irqfl;
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, irqfl);
 	ret = sta->flags;
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 
 	return ret;
 }
--- everything.orig/net/mac80211/sta_info.c	2008-06-18 11:56:44.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-06-18 11:56:58.000000000 +0200
@@ -235,6 +235,7 @@ struct sta_info *sta_info_alloc(struct i
 		return NULL;
 
 	spin_lock_init(&sta->lock);
+	spin_lock_init(&sta->flaglock);
 
 	memcpy(sta->addr, addr, ETH_ALEN);
 	sta->local = local;



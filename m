Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54385 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab0IXWCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 18:02:39 -0400
Received: by fxm3 with SMTP id 3so1004886fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 15:02:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
Date: Sat, 25 Sep 2010 00:02:20 +0200
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
References: <201009210057.13297.chunkeey@googlemail.com> <20100924180013.GD8077@tuxdriver.com>
In-Reply-To: <20100924180013.GD8077@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009250002.21219.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 24 September 2010 20:00:13 John W. Linville wrote:
> On Tue, Sep 21, 2010 at 12:57:13AM +0200, Christian Lamparter wrote:
> > net/mac80211/mesh_plink.c +574 mesh_rx_plink_frame(168)
> > error: we previously assumed 'sta' could be null.
> > 
> > This bug was detected by smatch.
> > ( http://repo.or.cz/w/smatch.git )
> > 
> > Cc: <stable@kernel.org>
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > ---
> > diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> > index ea13a80..1d7c564 100644
> > --- a/net/mac80211/mesh_plink.c
> > +++ b/net/mac80211/mesh_plink.c
> > @@ -473,7 +473,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
> >  	rcu_read_lock();
> >  
> >  	sta = sta_info_get(sdata, mgmt->sa);
> > -	if (!sta && ftype != PLINK_OPEN) {
> > +	if (!sta || ftype != PLINK_OPEN) {
> >  		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
> >  		rcu_read_unlock();
> >  		return;
> 
> Are you sure this is the intended check?  It isn't clear to me from looking at the code.

You are right, that change may even break mesh.
(if it did work?)

because mesh uses actions instead of AUTH/ASSOC and
the following code in ieee80211_rx_h_action (rx.c)

1986)       if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
1987)               return RX_DROP_UNUSABLE;

prevents any new plinks because action.category is probably
WLAN_CATEGORY_MESH_PLINK, right?

> Perhaps line 574 just needs to be protected by another NULL check?

hard to say, smatch must see the null dereference, when
we receive an action action frame where ftype is PLINK_OPEN
and the mesh_matches_local(&elems, sdata) check fail, but why
doesn't it complain about the "spin_lock_bh(&sta->lock)"?

---

[...]

(from previous checks we know that sta has to be pointing to a
 valid sta_info or ftype is set to PLINK_OPEN)

if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
	switch (ftype) {
		case PLINK_OPEN:
			event = OPN_RJCT;
			break;
		case PLINK_CONFIRM:
			event = CNF_RJCT;
			break;
		case PLINK_CLOSE:
			/* avoid warning */
		break;
	}
	--> spin_lock_bh(&sta->lock); <--
} else if (!sta) {
	/* ftype == PLINK_OPEN */
	...
}
...
---
anyway here's my new fix (this time RFC). Is there anyone at
cozybits who can review the logic in the new patch?

---
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ea13a80..8b7efee 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -412,7 +412,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	enum plink_event event;
 	enum plink_frame_type ftype;
 	size_t baselen;
-	bool deactivated;
+	bool deactivated, matches_local = true;
 	u8 ie_len;
 	u8 *baseaddr;
 	__le16 plid, llid, reason;
@@ -487,6 +487,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
 	if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
+		matches_local = false;
 		switch (ftype) {
 		case PLINK_OPEN:
 			event = OPN_RJCT;
@@ -498,7 +499,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			/* avoid warning */
 			break;
 		}
-		spin_lock_bh(&sta->lock);
+	}
+
+	if (!sta && !matches_local) {
+		rcu_read_unlock();
+		reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+		llid = 0;
+		mesh_plink_frame_tx(sdata, PLINK_CLOSE, mgmt->sa, llid,
+ 				    plid, reason);
+		return;
 	} else if (!sta) {
 		/* ftype == PLINK_OPEN */
 		u32 rates;
@@ -522,7 +531,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 		event = OPN_ACPT;
 		spin_lock_bh(&sta->lock);
-	} else {
+	} else if (matches_local) {
 		spin_lock_bh(&sta->lock);
 		switch (ftype) {
 		case PLINK_OPEN:
@@ -564,6 +573,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			rcu_read_unlock();
 			return;
 		}
+	} else {
+		spin_lock_bh(&sta->lock);
 	}
 
 	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",
---

Regards,
	Chr

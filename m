Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbZKRUCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 15:02:22 -0500
Subject: Re: [RFC] mac80211: move TX status processing to process context
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
In-Reply-To: <20091118195339.GB25188@bombadil.infradead.org>
References: <1258571772.30511.54.camel@johannes.local>
	 <20091118195339.GB25188@bombadil.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NSC+6ROPqsW2DtJyQXQU"
Date: Wed, 18 Nov 2009 21:01:57 +0100
Message-ID: <1258574517.30511.61.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NSC+6ROPqsW2DtJyQXQU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 14:53 -0500, Luis R. Rodriguez wrote:

> > Ok so this might /slightly/ impact ath5k/ath9k performance, but maybe
> > they shouldn't be using a tasklet anyway but also use work structs...
>=20
> Shoudln't by current mac80211 API documentation or shouldn't as in
> it'd be good to change it? From the current docs I read hard IRQ
> context but that could be clarified.

The latter :) I really see no real reason for it to be using tasklets.

> I'm not opposed to changing ath[59]k, in fact I want this change to
> happen; in the future more of our drivers will hopefully share more
> code and this then does mean eventually doing more things in process
> context. But if something is affecting performance terribly without prope=
r
> coordination for a specific kernel release it would be terrible for
> us and would prefer to try to avoid it. Can you test to see how much
> performance difference you see with this?=20

Not really, I think it'd be hard to test, I expect a really small
increase in CPU utilisation. It's only a difference between processing
it, and putting it on a list, pulling it off a list and processing it.


> > --- wireless-testing.orig/net/mac80211/main.c	2009-11-18 19:40:08.00000=
0000 +0100
> > +++ wireless-testing/net/mac80211/main.c	2009-11-18 19:51:51.000000000 =
+0100
> > @@ -625,16 +623,20 @@ void ieee80211_unregister_hw(struct ieee
> > =20
> >  	cancel_work_sync(&local->reconfig_filter);
> > =20
> > +	cancel_work_sync(&local->tx_status_work);
> > +
>=20
> Are there changes required during suspend as well?

Good question, but I think not since we don't touch the tasklet during
suspend right now. Now, that might be wrong too, but at least it
wouldn't change anything (actually we flush the workqueue for suspend
anyway, don't we?)

> > --- wireless-testing.orig/net/mac80211/status.c	2009-11-18 19:40:08.000=
000000 +0100
> > +++ wireless-testing/net/mac80211/status.c	2009-11-18 20:05:55.00000000=
0 +0100
> > @@ -16,25 +16,31 @@
> >  #include "led.h"
> > =20
> > =20
> > -void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
> > -				 struct sk_buff *skb)
> > +void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw, struct sk_bu=
ff *skb)
> >  {
> >  	struct ieee80211_local *local =3D hw_to_local(hw);
> >  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> > -	int tmp;
> > +	struct sk_buff_head *queue;
> > +	int num;
> > =20
> > -	skb->pkt_type =3D IEEE80211_TX_STATUS_MSG;
> > -	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
> > -		       &local->skb_queue : &local->skb_queue_unreliable, skb);
> > -	tmp =3D skb_queue_len(&local->skb_queue) +
> > -		skb_queue_len(&local->skb_queue_unreliable);
> > -	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
> > -	       (skb =3D skb_dequeue(&local->skb_queue_unreliable))) {
> > +	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
> > +		queue =3D &local->tx_status;
> > +	else
> > +		queue =3D &local->tx_status_unreliable;
> > +
> > +	skb_queue_tail(queue, skb);
>=20
> This sort of change could go into a seprate patch to help review
> easier.

Huh? The patch really only changes the if from being inlined into the
function call to not being there .. while changing the skb queue names
anyway.

> > +	/* if we got over the limit with this frame, try to make room */
> > +	if (num > IEEE80211_TX_STATUS_QUEUE_LIMIT &&
> > +	    (skb =3D skb_dequeue(&local->tx_status_unreliable))) {
> >  		dev_kfree_skb_irq(skb);
>=20
> Note before there was a while loop and now just a if branch. Why can we
> get away with freeing now just one buffer? It would be nice to see
> this explained in the commit log entry as it is not obvious to me.

Ah yes, I meant to explain that. We only use the status queues for TX
status now and not for RX too as before, so before it could actually
happen that we could free more than one off the unreliable queue, while
now it really can only be one.

Not that it actually matters, I just realised we never ever even use the
unreliable queue since we _always_ set the
IEEE80211_TX_CTL_REQ_TX_STATUS bit!

> > -		tmp--;
> >  		I802_DEBUG_INC(local->tx_status_drop);
> >  	}
> > -	tasklet_schedule(&local->tasklet);
> > +
> > +	ieee80211_queue_work(&local->hw, &local->tx_status_work);
>=20
> How about just moving this last party to a helper as well while at it?

What?

> > -	rcu_read_lock();
> > -	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +	mutex_lock(&local->iflist_mtx);
>=20
> Hm, what change here allows us to lift the rcu_read_lock, I
> was under the impression it would be the for sdata.

Well yeah, but we have the mutex now instead.

> > --- wireless-testing.orig/include/net/mac80211.h	2009-11-18 20:09:21.00=
0000000 +0100
> > +++ wireless-testing/include/net/mac80211.h	2009-11-18 20:11:00.0000000=
00 +0100
> > @@ -1734,31 +1737,28 @@ static inline void ieee80211_rx_ni(struc
> >   * transmitted. It is permissible to not call this function for
> >   * multicast frames but this can affect statistics.
> >   *
> > - * This function may not be called in IRQ context. Calls to this funct=
ion
>                                          ^^^
>=20
> > - * for a single hardware must be synchronized against each other. Call=
s
> > - * to this function and ieee80211_tx_status_irqsafe() may not be mixed
> > - * for a single hardware.
> > + * This function may not be called in hard or soft IRQ context. Calls
>                                          ^^^^ ^^ ^^^^ ^^^

?

johannes

--=-NSC+6ROPqsW2DtJyQXQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBFKyAAoJEODzc/N7+QmaWsgP+gO3cfoJGsUgBKmv3Mbro0s3
+ixk/n3wZ0hZ/yLeNcZWN6KHkmBDvN5KRT3a5ifUJkY9EgvSi/Oee0JYLGEQAMLM
qedDJUlhfKh0EJJdYrGnS5ppCfk1lqcnRCx68FbI55Jv4cYLhoZ82AD3iIymhpAJ
exAsQmjJV79RmlIR7OIkzmtSzOWfsv8yAJEZay4VM/NdRPl2h6PIvfe/EupGLCXW
31JYBombP5AcF6S+rFTeVO6KbV/T94KBbAJDWsw9HoKDo4/mHOwTrJ+4S2n+idpK
6iHHznjX37L62Px8RcvJDa4orppXG8GB4LnqwmuH6kQDKMECds9ckzfGHVXgKXqD
AFt/uEA34BCAxpneMHdeYy+5zEk1g5OcFpHBYPMl3nHwZQ2a1HtOS8JahCKnWApY
48U//i7/pjRvIQteiAeCptrxpbrgLqn+5qNxDgL9AVsd1VdBE1blaMHc00nw7oqL
4pl3hrOKkOjdGzZFfTDd7AH5in5dBHC+F9caanQ7IOY6RAmNZ+YHsBxHxSrf6/IE
E9wC8XgFrq4lu7gZ6IZLZdLOF5rJ+Oxm5xW5w9jwehUI26z/sG6Qp3ds7pL+u7Yc
KKAs1y3GxR+lu3oQ19x8WnhfJVK9Qx4euEhRmncouo3oW3fUsz4B50qMLWebgim+
OZk2uO7j997mgYB2NQ8W
=Lj4u
-----END PGP SIGNATURE-----

--=-NSC+6ROPqsW2DtJyQXQU--


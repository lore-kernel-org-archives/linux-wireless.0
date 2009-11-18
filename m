Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbZKRUfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 15:35:05 -0500
Subject: Re: [RFC] mac80211: move TX status processing to process context
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <20091118202334.GG6581@tux>
References: <1258571772.30511.54.camel@johannes.local>
	 <20091118195339.GB25188@bombadil.infradead.org>
	 <1258574517.30511.61.camel@johannes.local>  <20091118202334.GG6581@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-d3NubI3Vdnpy6qP+jFTx"
Date: Wed, 18 Nov 2009 21:34:39 +0100
Message-ID: <1258576479.30511.65.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d3NubI3Vdnpy6qP+jFTx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 12:23 -0800, Luis R. Rodriguez wrote:

> > > > +	/* if we got over the limit with this frame, try to make room */
> > > > +	if (num > IEEE80211_TX_STATUS_QUEUE_LIMIT &&
> > > > +	    (skb =3D skb_dequeue(&local->tx_status_unreliable))) {
> > > >  		dev_kfree_skb_irq(skb);
> > >=20
> > > Note before there was a while loop and now just a if branch. Why can =
we
> > > get away with freeing now just one buffer? It would be nice to see
> > > this explained in the commit log entry as it is not obvious to me.
> >=20
> > Ah yes, I meant to explain that. We only use the status queues for TX
> > status now and not for RX too as before, so before it could actually
> > happen that we could free more than one off the unreliable queue, while
> > now it really can only be one.
>=20
> Ah, thanks, so, that skb_queue can go and we can just have one
> unreliable sk_buff ?

No, you misunderstood. Because I'm separating the queue for the tasklet
(tasklet_queue) and for TX status (tx_status/tx_status_unreliable) we
can only possibly free one since we only added one -- the count cannot
increase over that. The loop would only loop once at most.

However ... right now we never use _any_ unreliable at all, but I
suspect we will want to change that again at some point.

> I mean that ieee80211_tx_status_irqsafe() is basicaly doing this:
>=20
> ieee80211_tx_status_irqsafe()
> {
> 	skb_queue_tail(queue, skb);
> 	clear_unreliable_if_needed();
> 	ieee80211_queue_work(&local->hw, &local->tx_status_work);
> }
>=20
> Would be easier to read that way too.

Ah. Hmm well, I dunno, splitting it up that much didn't seem useful to
me.


> > > > - * This function may not be called in IRQ context. Calls to this f=
unction
> > >                                          ^^^
> > >=20
> > > > - * for a single hardware must be synchronized against each other. =
Calls
> > > > - * to this function and ieee80211_tx_status_irqsafe() may not be m=
ixed
> > > > - * for a single hardware.
> > > > + * This function may not be called in hard or soft IRQ context. Ca=
lls
> > >                                          ^^^^ ^^ ^^^^ ^^^

> I was just highlighting the current kdoc for my first point on the e-mail=
.

Oh. Well it said "IRQ", but that was wrong, it should've said "hard
IRQ". Then again sometimes "IRQ" is used to refer to "hard interrupt"
only...

johannes

--=-d3NubI3Vdnpy6qP+jFTx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBFpcAAoJEODzc/N7+QmaIucP/iP3wMT6mKPROgvlBkl1Ulap
7fzBYklDBIXDXLDemC2Wi7ZwaGml0uhy5nqXrZZUtm2bC0q2FQheOlK9oaDy9y3/
PK8x3CdvGsAviXClKCgcRnefAPLsQmuNOXraxI9UEwuSnA2KCcB7fzUW7Jg8X/ct
FeTeFHKzXZmp/2mwQkQHTQu7pVA2l58LFB6bH8D4B5PQqjQDqu0XnGlJBu/Yy5Tc
TB8mnkhR4p+9F5jxbZm+CKXJYAwqJ0fdHGtPgcg1YNrIor30uBZeAfOWcruJeS1X
Gs2pUavWEQaRRPcuJst1ednL4GnaIH+nCUOmwlJVwQvB2VlX+DfypCCpeM4nvTl/
U/ef23Aelds7CRkZ9S8f9/qMU5t6Hur44geGDk6/vfYH6Q2gmC8bk+1wtzLzJ29R
DLdC+F6SElha5uiglrc1w1KUn6LM5hZX949xUwyeV2NrQLF/cbWBKGuNE4u8+ahM
O/p+FXwYKldJ6oV4HMEfgbXSdzLOd5May84/LJQLNA9+R5V66noboXothJiKzdwa
XBdUCg1S01eZE2C/dAzBjP5W/8h+7s8tDYZafNpZhkKzqH2UuzoXXxiJdzoSo6Jl
YbDhuhByeEdr9gJssFSOvWX/bwcD0yV1n7lPGPWabVcmx3acdplkUwWE53xm0ZY1
YXx+qkaI3qCKdvwbNUMC
=PrNL
-----END PGP SIGNATURE-----

--=-d3NubI3Vdnpy6qP+jFTx--


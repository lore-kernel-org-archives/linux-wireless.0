Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZB0VG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:06:58 -0500
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20090225023458.GB17040@xi.wantstofly.org>
References: <20081216025542.GO18056@xi.wantstofly.org>
	 <1229628950.3601.43.camel@johannes.berg>
	 <20090225023458.GB17040@xi.wantstofly.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bdgCpY9eNYpk+XfgmIQi"
Date: Fri, 27 Feb 2009 18:27:04 +0100
Message-Id: <1235755624.7426.71.camel@johannes.local> (sfid-20090227_220700_738168_7000AF57)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bdgCpY9eNYpk+XfgmIQi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Lennert,

Are you bringing your laptop? Want to do a little direct review next
week? If I can go home, I probably won't bring a laptop though.

> > > +static inline u16 mwl8k_qos_setbit_qlen(u16 qos, u8 len)
> >=20
> > Why do you need to work with the QoS header?
>=20
> The firmware expects that we send it a 4-address header without a
> QoS field, and any QoS info (if present) should be passed via the TX
> descriptor, which is why we need these.  Does that make sense?

So the QoS info in the TX descriptor doesn't match the layout in the
frame and you need to translate it? I guess that makes sense.

> Actually, the firmware always runs in little endian.  I have yet to
> test it on a big-endian host but I've done a pass over the driver to
> make sure that all firmware struct fields >8 bits are annotated
> as __le and that we use cpu_to_leXX/leXX_to_cpu in the right places,
> and I think it's okay now.  (And I think we got rid of the bitfields
> before the first submission.)

Sounds good :) If you've got pcie hardware but no big endian machine, I
can test it for you if you want.

> > > +	/*
> > > +	 * Copy up/down the 802.11 header; the firmware requires
> > > +	 * we present a 2-byte payload length followed by a
> > > +	 * 4-address header (w/o QoS), followed (optionally) by
> > > +	 * any WEP/ExtIV header (but only filled in for CCMP).
> > > +	 */
> > > +	if (hdrlen < sizeof(struct mwl8k_dma_data)) {
> >=20
> > That comparison seems slightly odd to me
>=20
> I double-checked it, but it seems correct, even if it'll always
> evaluate as true for now.  In the theoretical case we get a 4-address
> header here (which can't happen for now) with a QoS field,
> hdrlen =3D=3D sizeof(struct mwl8k_dma_data) and we don't need to
> skb_push(), since we'll just push the header 2 bytes forward (over
> the QoS field, moving that to the descriptor) and prepend a 16bit
> length field to the packet and end up with a payload of the same size.

Right, I probably just got confused. Don't even remember.

> > > +	/* Clear addr4 */
> > > +	memset(tr->wh.addr4, 0, IEEE80211_ADDR_LEN);
> >=20
> > ?
>=20
> As per above, the firmware always expects a 4-address header, but we
> won't actually end up with a 4-address header here currently, so we
> can just unconditionally write zeroes here.  This might need to be
> revisited in the future.

Yeah, if you want to support 4addr (WDS).

> > > +/*
> > > + * Scan a list of BSSIDs to process for finalize join.
> > > + * Allows for extension to process multiple BSSIDs.
> > > + */
> >=20
> > Can you explain why you need to do this much BSSID stuff? Maybe we
> > can extend mac80211 a little instead?
>=20
> There is a firmware command FINALIZE_JOIN which expects a copy of
> the beacon used for association.  From the beacon it uses the BSSID
> and TSF timer (to program the PS timers), and possibly a couple of
> other fields (I'd have to check), which is why we have
> priv->capture_bssid and priv->beacon_skb.  Ideas?  I guess we could
> have mac80211 pass us a copy of the beacon it used for association,
> but I don't think any other card needs this...

Might make sense to do that with some of the new cfg80211 assoc stuff
that might have that anyway, but it seems ok to keep for now then. I
guess mac80211 kinda passes all the information that the firmware will
parse out of the beacon in an already parsed form.

> We just ended up always queueing the work, since it's more consistent
> that way, and you'll have to wait in line anyway since you don't want
> to end up breaking up already-queued command sequences that the
> firmware expects to be sequential.  So it seemed simpler to just use
> the existing mechanism.

Ok, except, where does the requirement to use a workqueue come from at
all? Can we remove that entirely maybe? Or is it the filter flags stuff
(where we can't change atomicity requirement)?

johannes

--=-bdgCpY9eNYpk+XfgmIQi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqCJlAAoJEKVg1VMiehFY+IgP/1Z/zHyJAGsyqW4uyPo/tK3y
F6V5P0WvLZZsDky2jrWDF3huLY0kOH+D64+8ykhH28adWfOJY/U4WjO9kjKFNp+7
HAQ6LhzUmWeX9a9GxQHVTuB4q1qF7UzVd6sqE+9LODjtwtKFqurT6tLH6P8o/rvn
Kwdzbjk/YbVsSqSRgQk+il6wuz43vwmoS/2BFXmn/dVkHS5ISFuJleDZ2xbeeWzX
Tdttpp7G5/f/y9uR5FjgCa5WiKnZx6UaIF0LSYgjiirmjRyRFbWRDQunL/1/om+f
O2fMFWlr3jWf6smpLOx/Sq6yOhqG5xp4py6jfwFUjWAXOGqSXnQ9RFRXHvTpLTY7
UFWbyuxZu8SsjsmPW514WbOVzAqofj/w88DifV3N99WZFZbjxet3ZcGRAdtMh64t
MfP58eYps1vJ0AhR8hGM8Z9wp5Q+FK4ju3nSHfG0AmUmHn0JTg0v66MLu1UbKM1o
LoyzUA1Z6c63pn3FG4Rgg7+IYa1VoyXNgu9D4i8U4Z67mpXoLX9ZlT6W1RHbUZ21
YumfhzEF+a2ZYGsCD7WDK2Sx7sw+bMvIixHvjci7dW+260HW3ZiAQFH1LIRE8oiO
Sn89Bynz/B7DQd/6tMkN8+xXVqRtdfJY7biaKAybmD4Y80pyQ9apjccAmd2yDBJ6
PpmyRFmBakzoR92osBEm
=p/lx
-----END PGP SIGNATURE-----

--=-bdgCpY9eNYpk+XfgmIQi--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYFLNVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 09:21:09 -0400
Subject: Re: [RFC] First CRDA integration work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080612131154.GA28315@tesla>
References: <20080611040402.GE17936@ruslug.rutgers.edu>
	 <1213260106.19369.15.camel@johannes.berg>  <20080612131154.GA28315@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zs6UQ+ndKShJKnPj+hVG"
Date: Thu, 12 Jun 2008 15:19:38 +0200
Message-Id: <1213276778.3936.10.camel@johannes.berg> (sfid-20080612_152114_598007_1BB7592D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zs6UQ+ndKShJKnPj+hVG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > + * @NL80211_CMD_GET_REG: Get current regulatory domain, this is a qu=
ery=20
> > > + * 	to the kernel wireless core, the wireless core returns currently
> > > + * 	set alpha2 by %NL80211_ATTR_REG_ALPHA2,.
> >=20
> > Please specify what command it comes in, probably _NEW_REG that you
> > haven't added.
>=20
> We can probably not even add this, what do you think?

Well I think that some userspace programs like network manager want to
get a notification when for whatever reason the regdomain changes, and
they want to be able to query which one is currently set, and things
should be changeable. So you need at least three messages, NEW, GET,
SET, no?

> > >  CRDA replies by sending a regulatory domain
> > > + * 	structure which consists of %NL80211_ATTR_REG_ALPHA set to our c=
urrent alpha2
> > > + * 	if it found a match.
> >=20
> > Why set the alpha2 again? I thought the kernel queried for that?
>=20
> This is in case we wanted to support letting userspace query the kernel
> what alpha2 it has set. I'm OK with not supporting this though but it
> seemed it may have come in handy, hopefully not for abuse for other
> things.

Yeah true, we may want to be able to force a certain regdomain.

> > >  and a regulatory rule. The regulatory
> > > + * 	rule consists of set of frequency ranges given by
> > > + * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] with an attached power r=
ule given
> > > + * 	by %NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
> > > + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. Each regulatory rule also=
 has=20
> > > + * 	an attached %NL80211_ATTR_REG_RULE_FLAGS.
> >=20
> > How are these attributes used? Nested in some array?
>=20
> I wasn't sure yet, I wanted your feedback, but you are giving me this
> through IRC :)

Well, as I said, look at how wiphy band info with frequencies works.
That's how you need to do it with netlink attributes.

> > > + * @NL80211_ATTR_REG_RULE_FREQ_START: starting frequencry for the re=
gulatory
> > > + * 	rule in KHz. This is not a center of frequency but an actual reg=
ulatory
> >                                             ^^ remove
> > > + * 	band edge.
> > > + * @NL80211_ATTR_REG_RULE_FREQ_END: ending frequency for the regulat=
ory rule
> > > + * 	in KHz. This is not a center a frequency but an actual regulator=
y
> >                                        ^^ remove
> > > + * 	band edge.
> > > + * @NL80211_ATTR_REG_RULE_FREQ_MAX_BW: maximum allowed bandwidth for=
 this
> > > + * 	frequency range, in KHz.
> > > + * @NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN: the maximum allowed an=
tenna gain
> > > + * 	for a given frequency range. The value is in mBi (100 * dBi).
> >=20
> > Can be left out.
>=20
> OK.

I mean, you have to add a note that it can be left out if it's not
specified in the db.

> > > @@ -9,137 +10,93 @@
> > >   */
> > > =20
> > >  /*
> > > - * This regulatory domain control implementation is highly incomplet=
e, it
> > > - * only exists for the purpose of not regressing mac80211.
> > > - *
> > > - * For now, drivers can restrict the set of allowed channels by eith=
er
> > > - * not registering those channels or setting the IEEE80211_CHAN_DISA=
BLED
> > > - * flag; that flag will only be *set* by this code, never *cleared.
> > > - *
> > >   * The usual implementation is for a driver to read a device EEPROM =
to
> > >   * determine which regulatory domain it should be operating under, t=
hen
> > >   * looking up the allowable channels in a driver-local table and fin=
ally
> > >   * registering those channels in the wiphy structure.
> > >   *
> > > - * Alternatively, drivers that trust the regulatory domain control h=
ere
> > > - * will register a complete set of capabilities and the control code
> > > - * will restrict the set by setting the IEEE80211_CHAN_* flags.
> >=20
> > I think you shouldn't remove that but just rewrite it to make the drive=
r
> > trust crda instead of this code.
>=20
> The EEPROM lets us get a list of supported channels for a product a
> customer (a vendor's customer, not a regular customer) decided to support=
.
> If we trust CRDA we then could potentially trust a different set of chann=
els
> which the customer may not have tested his products on. They probably
> will work, but the safer approach is to support only the intended
> channels.
>=20
> We can then trust CRDA only to disable channels, not to *enable*.

That's already covered by the paragraph above it though, "[t]he usual
implementation is for a driver [...]". Hence, you want to rewrite the
second paragraph as I mentioned :)

johannes

--=-zs6UQ+ndKShJKnPj+hVG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUSJmAAoJEKVg1VMiehFY19oQAKq+sjKQAjoFOyOe8WfaZ5t2
7I2jxUasMDKRNp8KIvJ6utcqGQ8FiFbxc8moiqNWxTVLiLStcldZ3Yf0L+INl5o8
92ux1KsQ0j71QWe7E2N81+XeiyoLOIxdE17Jc1Eht/aPcYJvZ+1tBueSoFbPg3JG
5Isp8FUyOZ4yDeCHJaesTXGx8ydzVTJq8d7bgZU0eIUfG3k+KwxnrFJeLMneMBa7
bycOkXhBqx/g1yNZ40aClS5obUp4n+VeyTwN094Fw1lSzNIYRwrZSA+uE5CX684X
F/bm07uL3y5/dQu3iVu9ENP0068+vrUnGeUFiQIA6HmcULNs/zob9Rw11BRjrCDl
fSNK6vuntyiC921s0SiH6ilKYPhBb+aPxzkhESF/+bF9ovhJ1FwZvn0/l7uuz7NE
E1amUqtVJjRbQh5aXWCTcmqrB7Pq3GxG/SAA7e/JTmLSu+FCypX1HHgwNelTBtze
QAMA15U+TZjzwlYA5TAPg1nZZOKmyk44X6QXpUjFSparILxDJo2smkAMxB/RCFfu
jYRi4J82+oU/Lw7gfAW3tIx1LAwFoTZS38mxjpm3Utv9b7RVjto3xsliIogztmar
I3kKEXnQtyNHMZLFCKy6eTmIHp3XDUtsTsfao7pcXsRWb0QJbLiNQmyaa41fghxd
jFaUasl8Xtl0TvK2kO/h
=wwKu
-----END PGP SIGNATURE-----

--=-zs6UQ+ndKShJKnPj+hVG--


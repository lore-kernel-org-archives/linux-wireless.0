Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbYFQSUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:20:12 -0400
Subject: Re: [RFC PATCH 3/7] 802.11w: Add BIP (AES-128-CMAC)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617180610.GC4974@jm.kir.nu>
References: <20080617154008.883383150@localhost>
	 <20080617155904.082926456@localhost>
	 <1213721714.3803.83.camel@johannes.berg>  <20080617180610.GC4974@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gPrlqtC51XGM+vbdAzKY"
Date: Tue, 17 Jun 2008 20:19:13 +0200
Message-Id: <1213726753.3803.103.camel@johannes.berg> (sfid-20080617_202015_947837_A9BD8867)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gPrlqtC51XGM+vbdAzKY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Aah.. That's a copy-paste from something old.. I think I removed the
> IEEE80211_KEY_FLAG_GENERATE_IV flag from here for BIP.. I'm not
> completely sure yet, how we should have this, i.e., whether that flag
> should be used here or not. It is unclear what type of hwaccel, if any,
> vendors are going to implement for BIP.

Yeah, good point, I guess we should just not implement hwaccel until we
find hardware that can handle it.

> > I tried ensure pskb_expand_head is only called at most once when the
> > frame is handed to master_start_xmit to avoid problems with skb truesiz=
e
> > and such. Could you add the necessary space at that point already,
> > possibly simply reserving max(mmic-len, mmie-len) or so instead of the
> > current mmic-len (I think)? I'd hate to add back calls to
> > pskb_expand_head at other places, and it's only 18 bytes so not really
> > huge.
>=20
> I thought about that for a moment, but then decided that it would be
> okay to just do this here since MMIE is larger than any other tailroom
> we have and there is next to no real use for multicast/broadcast
> management frames, so there is no need to optimize this. I don't see how
> this would require any other place to use pskb_expand_head.

Well the thing is that you can't just call pskb_expand_head without
orphaning the SKB first and all that truesize adjusting, because of
truesize accounting, because it might now or later belong to a userspace
socket.

> Anyway, I would assume it would be possible to do this by changing
> IEEE80211_ENCRYPT_TAILROOM from 12 to 22 which would waste 10 bytes
> extra for every frame (well, not waste for BIP-protected frames but
> there are next to none of them).

22? Is there something else on the frame in addition to the MMIE?

> I converted some of the places to use the new helpers, but did not go
> through all places. I would assume there is still places that can be
> made to use them, but as long as FC is available in host byte order, it
> is easier and faster to use it. Sure, if rx->fc were to disappear, that
> may make it more likely that these get changed ;-).

Heh, ok, that's fine, I didn't realise that it was using the CPU order
FC.

> > Is that what the draft says? Because iterating the IEs would be
> > different, this means you could potentially have something like a vendo=
r
> > IE last that encapsulates the MMIE including type/len fields, which
> > should probably not be used?
>=20
> MMIE has to be the last "IE" in the frame. Sure, it would, in theory, be
> possible to receive a frame that does not have MMIE, but has "MMIE like"
> data in another IE. As long as we can make sure that this is reached
> only for frames that are received from MFP enabled AP, the simple
> solution of pointing to the end of the frame is enough. Otherwise, we
> would need to parse all the IEs and know about the start of IEs in all
> different types of Action frames.. That's not really something I would
> like to do.

Yeah, true, and we actually have that in another place too. If we then
remove the MMIE, the IE sanity checks should catch the bad frame anyway,
when/if it is parsed. Except we removed those because APs were sending
bogus information. I'm fine with this, but we should be aware of the
consequence.

> > > +	/* Remove MMIE */
> > > +	skb_trim(skb, skb->len - sizeof(*mmie));
> >=20
> > Is that actually necessary? Since it's an IE, it should be ignored by
> > all other code, no? Not that it matters though.
>=20
> I don't think it is necessary in the sense that leaving the "IE" in
> would break anything. However, I do think this is the correct thing to
> do here and matches with what we do with TKIP/CCMP. MMIE is not really
> an IE, it is just a frame component that is made to look like one. The
> current IEEE 802.11w draft is bit confused about what MMIE is at places,
> but anyway, I would compare it to TKIP ICV and CCMP MIC in the end of
> the frames.

Works for me.

johannes

--=-gPrlqtC51XGM+vbdAzKY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWAAdAAoJEKVg1VMiehFY5GwP+gOAnixvT3AY/HXs2WZxrb/J
6v/MWMOq/8KJvKVLiOs2YK7JZD0a0hCaC/0z6wIYcBhr0C4kRyXwO+MCWu0Nq7/L
KDDmZyoBsnz7cxZQe0X9PBWZOelyjYFpjBYo3fL47t5g7smS2cKJ9F8ur6/VANTT
FBpzWHSQmti/gSXGs295KQUc8yYb+YhuyEL2vuD3VkU7yKzFzI+swt2WW8WnEcoa
daN1zs83ln5OYrV81gH4kdXQKTdpFF5xNtz/g6dm4sLXUZUHVl5azz48WcdSSuAE
UAW04jXJrxbPgyErNDr8nlmBUzr0pG4lO94DgVwHkZUDJmP2Rc0QL1pnytm3zwxP
fmSeurxu2CMv9Mlj2Mh6gJozW2hyZZG1ND7s9z+z5UFxjDjC7RQOmBGS/bLBpwOr
epri88rId9hgU90VS8yZZv3Zd0iyGXGEqcp199AhhBTZ/7+Ak6GwejFiPZW+YYVt
8ZPWGmZblNC7t/LoR1TtaQSG2ZWPny+WNQxhl7IqfUJLiz/qPGpLvqHRKmM9VW8r
Egv1N3r8ntDMp2aT6fKfkmJyBH/y4Sfi774kAoAG8u4VihS7Mu/sESReoVIO8xrj
JtLbxM2Q/OL8xGCR7bbAWCMPbxN7TM4sy0RCxcdf4SD115oyUuXOjkSm7qBqVPbv
nrruq922ygwJqwqIxa6M
=4BjX
-----END PGP SIGNATURE-----

--=-gPrlqtC51XGM+vbdAzKY--


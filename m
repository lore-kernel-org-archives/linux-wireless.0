Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYFIRZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:25:19 -0400
Subject: Re: [PATCH 2/7] mac80211: replace ieee80211_get_morefrag with
	ieee80211_has_morefrags
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213028961.5974.18.camel@brick> (sfid-20080609_182929_823786_13F038F5)
References: <1212774671.6340.76.camel@brick>
	 (sfid-20080606_195947_229598_F1790495)  <1212997132.698.53.camel@johannes.berg>
	 <1213028961.5974.18.camel@brick> (sfid-20080609_182929_823786_13F038F5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RLnwHjI8LiIVpAW1GeMe"
Date: Mon, 09 Jun 2008 19:22:13 +0200
Message-Id: <1213032133.22220.3.camel@johannes.berg> (sfid-20080609_192523_146009_1233ADAB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RLnwHjI8LiIVpAW1GeMe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-09 at 09:29 -0700, Harvey Harrison wrote:
> On Mon, 2008-06-09 at 09:38 +0200, Johannes Berg wrote:
> > > -	if (ieee80211_get_morefrag(hdr))
> > > +	if (ieee80211_has_morefrags(hdr->frame_control))
> >=20
> > looks fine to me, though I wonder if we should have
> >=20
> > ieee80211_has_morefrags(struct 80211hdr)
> > and
> > __ieee80211_has_morefrags(__le16 fc)
> >=20
> > or something with variants of the functions that do the ->frame_control=
?
>=20
> I considered that, but thought it was a small benefit for doubling the
> number of helpers.
>=20
> I chose the __le16 variant as there is some driver code that checks these
> values in driver-specific structures, so I just left it up to the caller
> to dereference whatever structure the frame control is held in.
>=20
> But if both sets are wanted, I would suggest:
>=20
> =EF=BB=BFieee80211_fc_has_morefrags(__le16 fc);
>=20
> ieee80211_has_morefrags(struct ieee80211 *hdr)
> {
> 	return ieee80211_fc_has_morefrags(hdr->frame_control);
> }
>=20
> Do you think I should add the struct helper(s)?

It looks like you'd be using them in many places, so don't you think it
would be helpful? I don't really care too much.

johannes

--=-RLnwHjI8LiIVpAW1GeMe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITWbCAAoJEKVg1VMiehFYIXkP/jq+cjg95VeNTOLVwSKgJuED
gTEuTzL8VRhgWxeHiwUUKEEwEwRjZwGqM2rML3NFaF8PdihFKRPG502jZWCWgYT3
/Hdjen8TETt9DC0QHONIvxeaT4iNKjsu9FnrOah7eIIbrKG34ih+l8OzuPpoqdBu
3BgtNXOMt3ZgmhlgqP1rQ3DztmTFQE1bYTiAXRk0VsQHKZe3aKZrGAGYoervPrNL
1ZkIUNRunFPbk2iP//OdiVlZlAGMmYy8NM/41n5CGyIswC3oP9q5M3h13ArNgXAP
0KB8H40gsMDoOXRqW3Dphh5RWg8mAUGmiqZYsdGQaipCXyV4qeup5nZ5m3verm1S
jD5zAYaMXHEsoRH4pA0quMA9iD5mJ1V2+T0oYIigW6FeTwYPL8+N0C9BnKoY6G9K
NSX14wP0BP0LUcnrQK/NQlPYlhdnCpzw44vp+9COmhKMReAryU8UdYsG/rYrULfQ
4e3zgqE/VtQ2zMu4PlkPNl4f5ebsDD9A5BVEaPWZ/vIikHuwqiRs2mDFJ24neK1N
uQXdnOd8ETleAnUQoVTnb4zlo8/JiguEKthZoc17UhV6RetmX8wKj5O5sXHb52JG
4Vq4H8h1ycQ8m4n/KiAL8KKehhaxTrfdAUxj7Zl2MmDLt62WwS5rma1ampKl6ROn
mMQfRIQN4yTHAmKH5W45
=ZF+Y
-----END PGP SIGNATURE-----

--=-RLnwHjI8LiIVpAW1GeMe--


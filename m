Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYKETwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 14:52:16 -0500
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d
	support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <43e72e890811051124g3931e244i3e29c413a05c08f3@mail.gmail.com> (sfid-20081105_203443_261937_0EA8DECD)
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
	 <1225887783.3619.108.camel@johannes.berg>
	 <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com>
	 <1225908658.3619.135.camel@johannes.berg>
	 <43e72e890811051124g3931e244i3e29c413a05c08f3@mail.gmail.com>
	 (sfid-20081105_203443_261937_0EA8DECD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yHj6eRyzVXTl5+2FwUDE"
Date: Wed, 05 Nov 2008 20:52:13 +0100
Message-Id: <1225914733.3619.150.camel@johannes.berg> (sfid-20081105_205223_545136_B290962C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yHj6eRyzVXTl5+2FwUDE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 11:24 -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 5, 2008 at 10:10 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-11-05 at 08:57 -0800, Luis R. Rodriguez wrote:
> >
> >> >> +/*
> >> >> + * IEEE 802.11-2007 7.3.2.9 Country information element
> >> >> + *
> >> >> + * Minimum length is 8 octects, ie len must be evenly
> >> >> + * divisible by 2
> >> >> + */
> >> >
> >> > That seems odd, I thought there are triplets in there? That mean it
> >> > should be 2+N*3, no?
> >>
> >> Forgot the environment 'I', 'O' or ' '.
> >>
> >> alpha+environment (3) + n * 3
> >
> > But then it should be evenly divisible by three, not two, right?
>=20
> Nope, the end of the IE requires a pad to make it divisible by 2.

Ah, that's weird, I suspect nobody cares and that's why your Broadcom
router has only 6 bytes.

> > And 8
> > doesn't make sense as a minimum length either then.
>=20
> Agreed :) but that's exactly why I put those comments there.

right :)

> >> > When I suggested to use a checksum I was thinking of an easy way to
> >> > debounce. But a checksum is never perfect. Hence, the WARN_ON you ad=
ded
> >> > might trigger despite the debounce checksum. Or we might fail to fol=
low
> >> > changes.
> >>
> >> Let me know what you think about the alpha2 + BSSID thing above. I
> >> guess it should also consider the environment (I, O, ' ') in case the
> >> AP is reconfigured to be outdoor (without being moved). I don't think
> >> we should care about supporting these cases on the fly but we should
> >> ensure the change won't break things.
> >
> > Well I haven't checked in detail which things you care about in the IE
> > now, but shouldn't you check if those changed?
>=20
> We only care about the channel triplet and that has:
>=20
> a. Channel start
> b. Number of channels
> c. Power
>=20
> But I think that if the alpha2+environment is the same that's enough
> for the STA to assume the BSSID has not changed the IE. At least with
> openwrt I need to bring down the interface of the AP to change 11d.
> I'd guess most home APs act the same way as in that they require a
> reboot or something. On some APs I use I use iwpriv to change it but I
> haven't checked to see internally what that will do while its on.
>=20
> The checksum really only should be useful if a secondary device tries
> to associate to an AP and it gets a country IE. It needs a way to know
> if the IE is different than the one an already-present device is
> using. What I'm suggesting is that if these things are the same we can
> assume it doesn't change: BSSID+alpha2+environment.

Ok, checksums are nice to avoid having to memcmp large things, but
afaict we're talking about maybe 12 bytes, right? If so, why don't we
just keep a copy of the country IE and compare it fully every time?

The way I see it, driver/mac80211 calls cfg80211's
	regulatory_11d(wiphy, ie, ie_length)
function and that sorts out whether to do anything at all, ignore it
because it already knows etc. So regardless of what we do we can just do
it all in here and not bother anything elsewhere with checksums,
debouncing etc, and will be free to change it easily.

johannes

--=-yHj6eRyzVXTl5+2FwUDE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEflqAAoJEKVg1VMiehFYjTwP/1SRGHOX1MOmc09mbC4snJ8H
pvMx3eAOstqoYPFG4Eg5ggA+9pmiJTaVvE0tHUmtRsVOyzdSUNVmW3Pz4MEEqiIo
8DQsKD9vwYZiZHLXoY5Rd1692UiNpNsRUOJZZuaA3gsHBR9N1/9Csgg26dpqv3UJ
aBP/EQVtgnli80quQFmPTO4BBqPQbKDRkXyFrDmfBRihXthsBb4DY0rtxrlPeIDP
1AmT6MdiJsWLGj/M4HNW/wV70G7iGk1cX9YP/GbQARHYtnBJAomgRucNxtqsEMjN
y+w3ed9G1OIgFBQzwuIfIruhtESPhBO0N+KNboDZSRcBRT9bZ8QYIcvftSF7Kkt+
ZkZ2nsXIgS0aI0WpPL8N+QggCxeY5/zNyIRsKuGP70eeKLgTXjSJQuJTjqlys7sy
IadSbDxdo/uHREry4D2y6XsS0zO4zICl9epz9H9S3uCbTR9yBI/vU6WZMrJWCnTT
7PTfcPdKudoYIT4v8bMYtnAu6OdszO45A8UVBAdBsRCT41xcXvu96d0px4fVOQJz
BLdgRfLQAvnyJje2TKWsLwSwuw7yu+SeKjTIyS6dF96yVR0bhjuGRE1SapmFvNxs
sIVLFhDcwKsRl223ZhMOls49F1fKwHL8ba3PjJehG/fLo0+gl/qcGg+kC9qG/PIc
LA+vmBXfxAGqODE9w7K4
=fX1v
-----END PGP SIGNATURE-----

--=-yHj6eRyzVXTl5+2FwUDE--


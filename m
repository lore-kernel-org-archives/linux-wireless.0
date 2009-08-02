Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZHBIbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 04:31:17 -0400
Subject: Re: [DISCUSS] Implement non standard channel widths
From: Johannes Berg <johannes@sipsolutions.net>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, sidhayn@gmail.com
In-Reply-To: <4A74D5F5.8090409@erley.org>
References: <4A74D5F5.8090409@erley.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8IrrhhucI7bBjDAmUE7l"
Date: Sun, 02 Aug 2009 10:31:09 +0200
Message-Id: <1249201869.2007.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8IrrhhucI7bBjDAmUE7l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Pat,

On Sat, 2009-08-01 at 19:55 -0400, Pat Erley wrote:
> I've been kicking around the idea of attacking the addition of the
> ability to set non 20MHz channels to the mac80211 stack.  I've come up
> with 2 potentially un-intrusive ways to do this, but before starting,
> I'd like to get a touch of discussion on which way would be
> preferred/acceptable upstream (if any are).
>=20
>=20
> 1. Extend nl80211_channel_type to have values for the other channel
> bandwidths we want to support. =20
>=20
> Maybe something like NL80211_CHAN_NO_HT_5 for 5MHz, etc.
>=20
> This is the option I like least and have put the least thought into.

Personally, it's the option I like most, combined with registering, for
each channel, which channel widths are supported on it.

> The upside to this is, it'd be the least intrusive into the actual
> code, with the downside being, that enum is currently really more
> aptly named nl80211_ht_channel_type, and as such, pretty much
> everywhere it's used currently would have to test to see if ht is
> supported, and if it is, if the current ht mode is supported, but
> also, if it's not NO_HT, if it's a non-standard channel width.

You're right that it currently is mostly about HT, but I don't see why
all this testing should be necessary. I'd just use the managed mode
interface flag IEEE80211_STA_DISABLE_11N.

> With this route, setting the channel width would be done something like:
> iw dev <devname> set width <width in MHz>
>            or maybe=20
> iw dev <devname> set freq  <freq in MHz>[@<width in MHZ>]

I don't like the technicalities of this, I think that the channel width
should be set with the "connect" call. Of course, it has to be supported
here as well, for monitor purposes, but shouldn't be required here.

>=20
> -- Problems common to both --
>=20
> In the beginning, I think that leaving the supported channels static
> to whatever operating band the card is in, is fine.  Yes, going to
> 10MHz channels would double the number of available channels in a
> band, but with the absolute lack of hardware(AP/Router) that supports
> it, having a pre-set double sized channel list seems pointless.  I
> suspect most people who would use this would want to set center
> frequency anyways, rather than specific channel, but that's another
> can of worms. =20

Also keep in mind that there _are_ standard uses for smaller bandwidth
channels, Jouni has helpfully collected them on
http://wireless.kernel.org/en/developers/Documentation/ChannelList

> Another problem, odd channel width channels.  With a 5MHz channel,
> would you do center freq +/-2.5MHz, or center freq +2/-3MHz/etc?  Or
> maybe limit the problem to only even channel widths?

I don't think even channel widths can work, since we really do need 5
MHz :) But it shouldn't be that much of a problem, we already use KHz in
a number of places.

> Next problem, background scanning.  I think that disabling background
> scanning when not operating in a standard frequency would be a 'good
> thing', as all of the applications I can think of that would use this
> are cases where scanning isn't really necessary.  I could go either
> way on this topic though.

We don't have any background scanning.

> Final problem, HT channels.  I think that channel bonding should be
> mutually exclusive with non 20MHz channels.  In theory, bonded 10MHz
> channels could provide better throughput than a single 20MHz channel,
> due to the ability of a 10MHz channel to get above the noise floor at
> a distance, but again, this seems like the amount of work to implement
> would grossly increase the complexity of the problem.  Maybe this is
> something that should be left up to drivers as to if they can support
> it. =20

I can agree with this -- I think "HT" should be left reserved for real
HT, that is 20 or 40 MHz 'channels', where 40 really is bonding as you
say.

So let me outline how I'd handling this, by extending the flags instead
of using a bandwidth number.

The first thing I'd do is start with some cleanup -- remove the
'max_bandwidth' member from struct ieee80211_channel, it's used only
write-only in a few places afaict. In fact, I'm happy to do that
unrelated to this work.

The second thing I'd do is refactor the use of IEEE80211_CHAN_NO_HT40*,
remove that from the flags field (maybe making the flags field a u16)
and introducing a new "types" field, which would take a bitmask of
BIT(NL80211_CHAN_*) values. This would have to be set to default to
	BIT(NL80211_CHAN_NO_HT)
or, if HT is supported,
	BIT(NO_HT) | BIT(HT20) | BIT(HT40+) | BIT(HT40-)
and would also need an orig_types field, and then regulatory code
removes the bits from "types" as appropriate, leaving them in
"orig_types" for future regulatory changes. Just like "flags" works.

Note that the default value for types should be applied if, and only if
(!), the types field is set to 0 (i.e. unset) by the driver. IOW,
cfg80211's channel checking loop in wiphy_register() would get this
code:
	if (!sband->channels[i].types) {
		sband->channels[i].types =3D BIT(NL80211_..._NO_HT);
		if (sband->ht_cap.ht_supported)
			sband->channels[i].types |=3D ...;
	}


Third, the channel type needs to be a bit more pervasive. As a start,
I'd start with adding it to connect(), ibss_join() (maybe) and
set_channel() commands. This mostly involves cfg80211 and mac80211, but
not all the full-mac drivers since they don't support anything other
than NO_HT yet (which should probably be renamed to 20MHZ).

This would already have one good thing: it would give us the ability to
request, from userspace, to disable HT40 and/or HT40, by passing:
 - no flags: automatic, use all
 - HT20: no HT40 permitted (don't think we can _force_ ht20?)
 - NO_HT: no HT permitted

This is a little strange though, but at least NO_HT would be easy by
setting IEEE80211_STA_DISABLE_11N, maybe reject the others for a start.

This is validated against the channel you're using, of course, in the
cfg80211 SME etc.

One other thing that would be necessary is adding channel type to scan
results, I guess?


Then, finally, I'd add a new channel type, NL80211_CHANNEL_TYPE_5MHZ.
Document it to imply that HT is being turned off, of course. Now this
bit should be really simple.


I don't think the 'specify bandwidth' instead of using flags really
gains you much in this process?

Mind you I'm not nailing down that process now, it's just how I'm
currently thinking about it.

johannes

--=-8IrrhhucI7bBjDAmUE7l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdU7HAAoJEODzc/N7+QmaKaEP/jKzFL/VwbHNKSZueUc4Lfnk
T+UEuKoanA2bX7EmEpMp+6ppl7uIT7r4+bbl/tqkBR3kH/6N5DlA76kMpHjZ//0E
OcvR43Dn+9ErLddhgb/z3nhDnwE/hOxV31pTIfRq1+hkTE4HmT52STnzE+9YStLy
9Yk+e84AQx2+DZ6NJ+YJyPoGR6bvEM+mrSu+fuYotI1y1c++OzAkTlTNfmHtoKDf
x2hz1YuWXk9/pjEfnZCN8CiJuclsMrFCKQUIN/7vIJTY0oiSRCTOOwXFeb6Is9ye
91bYhVc5XJ8M0Ee6Jmoq2hE4xfeZDjFwwB6knWlIu++4qFaXp+L+koeROYOaN/Lh
M613G5KCeWyoXtX45NNhXRBV2IdIG/3BpTEEIqpNQNmqIfDTLMj5Y2D9MWqJvP6d
j065r8aCZpCcpoLgg8VNIb78w1bkHfNcdf5DeUhqiDe6JGpC3tiW31vFRob8TRzS
VljkON+Owfk2Mp+MyqmbKNiFMiljmjLk78EJtrP/qyjmiWVHm0h6coYSLmDJKRAj
Chz+txLiaik2nlCT780eqS1D5/LkQG7j6UAO8/aCpF2TLsm+eN5LZGylU4CM5NyZ
JXIXFcUycoQski4s+Ye4UDS93pUTNYvM6uU7fzANbBmQZaXejFc7BbjoiCJppN81
diN0TDvzvmH3rhbASBSY
=pt4e
-----END PGP SIGNATURE-----

--=-8IrrhhucI7bBjDAmUE7l--


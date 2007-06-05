Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760420AbXFEOMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 10:12:45 -0400
Subject: Re: nl80211 status? (implying cfg80211 status)
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: linux-wireless@vger.kernel.org,
	Stephan Maka <stephan@spaceboyz.net>
In-Reply-To: <20070605140001.GB5221@charon.n2.diac24.net>
References: <20070604193034.GA16350@charon.n2.diac24.net>
	 <1181040798.8274.10.camel@johannes.berg>
	 <20070605140001.GB5221@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d851sL1n9Hs5Cm7Pt1uz"
Date: Tue, 05 Jun 2007 16:12:52 +0200
Message-Id: <1181052772.8274.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d851sL1n9Hs5Cm7Pt1uz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi David,

> Hmm, true, converting wext isn't really needed first. Does making
> cfg80211 usable make a better candidate for first work?

Yeah, I think so.

> As far as I can
> tell, the only thing mac80211 implements for cfg80211 is interface
> creation / deletion...

Yes, that's true. But cfg80211 also doesn't implement that much more of
nl80211 right now.

> I'd propose two additional commands:
>=20
> - NL80211_CMD_GET_WIPHY [_CFG]
> - NL80211_CMD_SET_WIPHY [_CFG]
>=20
> which would be invoked with a NL80211_ATTR_WIPHY and setting/getting
> NL80211_ATTR_WIPHY_NAME, NL80211_ATTR_CHANNEL and NL80211_ATTR_PHYMODE.

Hmm, this does seem to be orthogonal, for example changing the channel
could be accepted but changing the name could fail. Hence, it doesn't
make sense to use all these attributes together. IMHO adding commands
isn't a problem, so I'd rather see RENAME_WIPHY stay while adding a
command to switch channels. Something like SET_CHANNEL(CHANNEL,PHYMODE).

> The NEWNAME notify-command could be renamed and used for channel / phymod=
e
> notifications too.

Again, these two are orthogonal and I'd rather see them split.

> Yes, thats what I meant for interface configuration. However, I don't
> think NL80211_ATTR_CHANNEL and NL80211_ATTR_PHYMODE belong here - if
> something is capable of using more than one channel, it really should
> have more phys, not more interfaces...

I don't understand this comment. The CHANNEL/PHYMODE attributes are used
with associating as per the 802.11 mlme interface. Yes, if you support
multiple channels/PHYs then you should have multiple wiphys, but that
doesn't preclude allowing to set the channel/phymode in the same command
as changing the association, no?

> Phew. The only thing nl80211.h contains in mainline is enum nl80211_iftyp=
e.
> So the possibility to make generic getter/setters out of the NAME command=
s
> is still there...

Right, that was needed to get cfg80211/mac80211 with virtual interfaces
to compile.

johannes

--=-d851sL1n9Hs5Cm7Pt1uz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGZW9j/ETPhpq3jKURAnYGAKCR+ElYTw1oNJqyidZ3WPQ9YdieNgCfdIur
7RWQjvbxvFVjwJrGIsGjtXw=
=uWVC
-----END PGP SIGNATURE-----

--=-d851sL1n9Hs5Cm7Pt1uz--


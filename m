Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZFRMT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 08:19:58 -0400
Subject: Re: [PATCH] mac80211: push rx status into skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87d491n3bi.fsf@litku.valot.fi>
References: <1245237180.20613.4.camel@johannes.local>
	 <87d491n3bi.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ALmqprIl4C2cb+A0mOAG"
Date: Thu, 18 Jun 2009 14:19:25 +0200
Message-Id: <1245327565.13790.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ALmqprIl4C2cb+A0mOAG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-18 at 15:17 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > From:	Johannes Berg <johannes@sipsolutions.net>
> > Subject: [PATCH] mac80211: push rx status into skb->cb
> > To:	John Linville <linville@tuxdriver.com>
> > Cc:	linux-wireless <linux-wireless@vger.kernel.org>
> > Date:	Wed, 17 Jun 2009 13:13:00 +0200
> >
> > Within mac80211, we often need to copy the rx status into
> > skb->cb. This is wasteful, as drivers could be building it
> > in there to start with. This patch changes the API so that
> > drivers are expected to pass the RX status in skb->cb, now
> > accessible as IEEE80211_SKB_RXCB(skb). It also updates all
> > drivers to pass the rx status in there, but only by making
> > them memcpy() it into place before the call to the receive
> > function (ieee80211_rx(_irqsafe)). Each driver can now be
> > optimised on its own schedule.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> [...]
>=20
> >  drivers/net/wireless/wl12xx/rx.c           |    3 -
>=20
> Last night John applied a patch which renamed this to wl1251_rx.c.

He actually applied both patches so I'll assume git resolved this.

> >  drivers/staging/agnx/xmit.c                |    3 -
> >  drivers/staging/stlc45xx/stlc45xx.c        |    3 -
> >  drivers/staging/winbond/wb35rx.c           |    3 -
>=20
> John takes staging patches now? And stlc45xx won't even compile right
> now :(

Well, I did that with spatch, so ...

johannes

--=-ALmqprIl4C2cb+A0mOAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOjDKAAoJEODzc/N7+QmaZUIP/38LHSWcpsZ0ELrPy5JBeGuI
pT9D4ObU7tD0RXz5talJjNw+JenQY9DIEMnJH3J8JPSCq480pl2VY2cwV5rCoH8w
iKvt2MyLfkdqV2TlEBRigqK3ZTBe9HRfEfztfAgRY5+BThbFQsqPHfwcm8B5S0/L
LarzgFUIDQbWjNoeiC4ULC3ymhWn0csHsUonAukTTpTT16giUDHP19VxX15jQzbK
+qgsK+9e3YCp/1A+6/hhBFCyEcnr25lwtJIqVPVt7p233ZkLIrDzmzFeso7w9r9J
BvAakQxDRJ3uw7J9narTQoACTGcYEWnWCmlds9Ew+2wXF80/vAGfs4zKhecE9N6e
gjoNFa6IgVw/U5EB/tm+A1Y0KUG5m9qqEH40HdQeeYXc09zhXitSh/lhACXWIC8E
go5mC3n3FCE9KA4c/gP/x+771Y/Vgrv2TYZ+aKq4KuPwyStJZpvRUp8pae8tdvln
bSgGg48ZzKJafeKiENAMgrW0P0fAVmXxj2qiCksLzTN69UAq2Yt9xspS+Uo2EN1i
v/LibH2XhQxasRtFOoHN4sgpYaizOx2l4yULWp8De8SH0midNe0gU95UdaWw/1M0
YVnPSd0ISc/NEj1gYwbPaghVh8w8tCmvergUZOCkENgNKl35zCuEXDxgaqGQrkWO
3qXAi3PSefrNa+zd/1ht
=+LDQ
-----END PGP SIGNATURE-----

--=-ALmqprIl4C2cb+A0mOAG--


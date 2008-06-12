Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900AbYFLLFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 07:05:03 -0400
Subject: RE: [PATCH 1/1] mac80211: [RFC] do not fragment while
	aggregationis in use
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB050224AF@hasmsx411.ger.corp.intel.com>
References: <1213207296-14548-1-git-send-email-ron.rindjunsky@intel.com>
	 <1213219526.3827.0.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB050224AF@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CcvCGeCCARB0CYRt1/F5"
Date: Thu, 12 Jun 2008 13:04:12 +0200
Message-Id: <1213268652.3936.0.camel@johannes.berg> (sfid-20080612_130508_179573_A6EE4AF0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CcvCGeCCARB0CYRt1/F5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-12 at 12:56 +0300, Rindjunsky, Ron wrote:
> >> -	/*
> >> -	 * Warn when submitting a fragmented A-MPDU frame and drop it.
> >> -	 * This is an error and needs to be fixed elsewhere, but when
> >> -	 * done needs to take care of monitor interfaces (injection)
> >> -	 * etc.
> >> -	 */
> >> -	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
> >> -		    skb_get_queue_mapping(tx->skb) >=3D
> >> -			ieee80211_num_regular_queues(&tx->local->hw)))
> >> -		return TX_DROP;
> >> -
>=20
> > Should we keep that, just in case? If it ever happens and the hw
> rejects
> > a fragment for some reason, we'll otherwise clobber some state and
> > probably crash.
>=20
> Agree. Should I resend the patch or would you just remove it from the
> original patch?

Well, you probably want to adjust the comment, since you did fix it
elsewhere :)

johannes

--=-CcvCGeCCARB0CYRt1/F5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUQKoAAoJEKVg1VMiehFYDQ4P/1fvLW7eNpOjHc2efjivJkHq
qikbrNpNQ95qGHNV/VgPhqjqG6G8veLgcSZnr2f7+NT1Sg0MIf0ORrkXpTmz243/
G1genJA20c09/Mjv84BzvQZl+PlV3eI22VmeBA8IPj0B0vkx6tyCD8T8R40jP6Ex
m+d+qqGN0mx3K6cnoxpDDIIrZvaU4DO/pKXNd0IZzOGFmkU8DNTZYVdvBmvkY3mC
KcsgBFddnnIz2UgcD+KYaJH4FcTt/keM6QhAdHxt7pSBcgMeuQGDnlwC5KZvKdHv
8D2Bk8vVRr61wnVCoQk8gWXi56NCnlkqrDkgydJBri6RIzLfz+jEQXEwbCxQtpIL
7nB+U7ILaMeM0AWw2c+GotCCOX+xG8t3ZiwIqGSD/tnhbEGj/gdVcYm6vH1lHB7k
eObd2sgzuT/2S1idHT/gui/Pyv43JxgGzl8RtUrrSrxTHUk8yw1tsnbnOT7Pu0UJ
iSVftEdMzpnJOj+IW9c4MeslL71J1G96ygZfq4UrCyV3hs3CGzmNdUXnwzzgc4ht
zoBSudP6E7M/6Z6v7UJGPchPO7Oiop92qd8LUDzdZh/A1TiyctZg0aqQVY4m57GO
mKah89GdNAZv8QSTFbAWIs8UD9Wykugx8CMYoBtOLd40ABpxvdcAYIIdi+1SQ4lL
nwO33ybHw5yC2FTQbpBs
=o/eY
-----END PGP SIGNATURE-----

--=-CcvCGeCCARB0CYRt1/F5--


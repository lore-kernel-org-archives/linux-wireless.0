Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbYJVKDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 06:03:54 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Sujith <m.sujith@gmail.com>, Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com> (sfid-20081020_234638_705151_437FF968)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	 (sfid-20081020_234638_705151_437FF968)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/jYCKgHXDOeF/fcqDcjv"
Date: Wed, 22 Oct 2008 12:03:47 +0200
Message-Id: <1224669827.28639.54.camel@johannes.berg> (sfid-20081022_120415_628343_35F6DAAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/jYCKgHXDOeF/fcqDcjv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 23:46 +0200, Tomas Winkler wrote:

> > Immediate Block-Ack is mandatory for 11n, delayed BA is optional.
> > ath9k currently maintains the BA window state internally too.
> > Another candidate that can be moved to mac80211, IMO.
> >
>=20
> TX or RX side?

Both? What exactly does your firmware do, say of the list that Sujith
posted?

> >> What I could also imagine is that mac80211 simply does pretty much
> >> everything and hands a number of skbs to the driver at once with some
> >> additional information about how to aggregate them, what sort of spaci=
ng
> >> to use, etc. It should be able to calculate all the required stuff sin=
ce
> >> it knows from the rate control algorithm what's happening there.
>=20
> What you need is to compute how many frames can be transmitted within
> TXOP i think we can provide the calculation
> depending on the current state. Just with the retransmission down
> scaling need to be taken into account.

We really need TXOP handling in mac80211 anyway, no? Right now we won't
handle frames that are too long for the TXOP, for example.

>  That
> >> might leave Intel out a bit, but I'm starting to think that we want to
> >> special-case them a bit anyway.
>=20
> Let's see first mvel and bcom implementation :)

Like I said, from what I can tell bcom is really similar, and I'd like
to not have to re-implement all this first. mac80211 used to have a more
push-model, which we've deviated from with the HT stuff you did, but for
most hardware the push-model is still appropriate, so imho we should try
to go to one even with HT and then see. We've since reworked rate
control to be able to cope with HT too, so mac80211 can have much more
information about what's going on and should be able to make many of the
necessary decisions.

johannes

--=-/jYCKgHXDOeF/fcqDcjv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/vqAAAoJEKVg1VMiehFYZx8P/jkeTa4FbZ4ht1cWbHUSn/j9
sd1ggG4QYXzySWLz9QS8o83kDcN0Ajf3XeM1cevIgHc9UrN+twl0RsDyXdvsmgHK
HY8pTK+qEftbMkVgCvC/A4svjcihwv6gjIUV6RBaOSli3t03dEhyhRD69RE6icPx
dI1FehMJaGwlUzx/tya9qutYLFijpQbfaB8D3ap4ZB9Rvof471d4Cy5wMpIuYWwp
WC1XlEPdbc65CvfCcVRDQ2h+ISzZRqQI+uMhnzB24YLx9IAJuWj+j6WjxseSfJ1L
8UN286QA8Zn99jJh6wcoq7auKBjHVWAsXTIjJIoUzKVNqNxFM8pvittFxjlwS4dY
G/nr+QKEJxyaYtuvj94XzgE7M+7xJJapS+Xnc0OzMp1zVH8/3Wd1lp0t1Swu3CQt
Nm5pSWL5M2XN+Tv0xhHSkbMUqDUHmUIypJ12hKaWK+jw8Bc8LJr2RBohD4kjXXPL
fFJ4wpYxIqr+TcNW16MNkC/HitEvM8rNj8a+NsFJLNdR8VAI1in4ALwntEdNivi6
KO5bMpLaIgR5X12vBXsA7VsAfLz+0mnu/g6t0M5Cqesxy6lRmKT2Vb6QE3cjWjyH
OEYStfRjNTB6H9JVe1BjT8s9sPxwGzRBnrPBMahgPaSVaEGo4WCeSOx2KQhnpJj9
o0Mn8eaOBa5NBPkiHiAC
=Lgn/
-----END PGP SIGNATURE-----

--=-/jYCKgHXDOeF/fcqDcjv--


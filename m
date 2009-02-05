Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZBENgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 08:36:38 -0500
Subject: Re: [PATCH] mac80211: Fix the wrong WARN_ON message appearing on
	enabling power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4100902050426x5c6a0da5r86c3e6ca945b29c1@mail.gmail.com> (sfid-20090205_132619_307258_7901E67F)
References: <20090205110631.GA13746@myhost.users.atheros.com>
	 <1233835647.3931.13.camel@johannes.local>
	 <8e92b4100902050426x5c6a0da5r86c3e6ca945b29c1@mail.gmail.com>
	 (sfid-20090205_132619_307258_7901E67F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9P9rqU29OamIc0jZCocf"
Date: Thu, 05 Feb 2009 14:35:58 +0100
Message-Id: <1233840958.3931.20.camel@johannes.local> (sfid-20090205_143642_805312_5422604B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9P9rqU29OamIc0jZCocf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 17:56 +0530, Vivek Natarajan wrote:
> On Thu, Feb 5, 2009 at 5:37 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Thu, 2009-02-05 at 16:36 +0530, Vivek Natarajan wrote:
> >> The warning message intended to be hit on driver's rejection of a Tx f=
rame
> >> is also hit while the netif_subqueue is stopped. This patch fixes this=
 error
> >> case.
> >
> > This seems a little odd. Why would we be in that code if the queue is
> > stopped?
>=20
> This issue happens only when we are associated with a 11n AP and power
> save is enabled.
> In the function 'ieee80211_master_start_xmit', ps_disable_work is
> queued where wake_queues is called. But before this work is executed,
> we check if the queues are stopped in _ieee80211_tx and returned
> TX_AGAIN to ieee8011_tx which led to the warning message.

Ah, ok, thanks for the explanation. Might make sense to put that into
the commit message.

johannes

--=-9P9rqU29OamIc0jZCocf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJius7AAoJEKVg1VMiehFYnpgQAKqGVv/CtQw8Neu08277eg+L
xplzBCmXF8jAY2vKjbIo9EpBTbVtC2BcqFqTRd2ph+8TKLROIA9HO2z2gDyjZz2G
pkTr2sLC31AfggoOWUkD3rSH6U0TCHFeOYkfc1EU5zlM1opD5lSF8A/6GSzIey6Q
kbjGb/2d8AtLXKc6c6OBzfmLZlaAR+4VF+uhzLXPahtIWptNoIzbL43Wn3UhmIC2
Tfa72QSOkp4TO21cFq7ugKb/0jK0mCyqEa4eDzNehW7AsJ2nRvOyGATUk7grVfVz
zvVRJqqgbxNZefxV3B1jIVLEXhcLKs6hPMsii7P78hspkxbNpsIR8O2s+pkb+CpW
i2eS/6/9vSQxXboXMP0/rhnDMr4H2b5JGCeUiaTvi1U7Ec/xFk/G0oxsQ5PwmaVY
+Ujcvu1SOCPyVf0TdGBmxjGlwqLhatU2vFuivDJs9lBuwJWlGXRzCYJV8Kh45WFx
sH5t28mbv+TgjxfWqOvqoKmztBeXVlpk1XZDVg40bOy5nMUAEKdBTBsKICmjWoG/
+BZaPmrL5MYG43t8cs+7pl7Dz16wV+O+zuQIw76Un5lLzPt8kt0ztbtnt3lAXNZr
Je1f7zXRZ1PFQv4vvTCrp6/22OE7AxJsNau0OZcwTytaKu1u+MSnIJkPJ5ePPe/3
WOWUegIiiy+B0jUYdTtF
=PyW3
-----END PGP SIGNATURE-----

--=-9P9rqU29OamIc0jZCocf--


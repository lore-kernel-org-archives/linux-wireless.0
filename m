Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbXFMME7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 08:04:59 -0400
Subject: Re: [RFC] {cfg,nl}80211 API
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <20070611230434.GA13221@charon.n2.diac24.net>
References: <20070611230434.GA13221@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BtjyIB/4/C7NkbbenqKS"
Date: Wed, 13 Jun 2007 12:22:35 +0200
Message-Id: <1181730155.29767.77.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BtjyIB/4/C7NkbbenqKS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

> - struct ieee80211_channel:
>   use (phymode, channel, 80211n-mode) as "key"; kill off frequency
>   (which will move to some get_channel_foobar function)

Hmm. Maybe we should've kept frequency. How do we want to handle
dot11ChannelStartingFactor (see 17.3.8.3.2 Channel numbering in
802.11j), I quote:

Change the text of 17.3.8.3.2 as follows:
Channel center frequencies are defined at every integral multiple of 5 MHz =
above Channel starting
frequency. The relationship between center frequency and channel number is =
given by Equation (27):

   Channel center frequency =3D Channel starting frequency + (nch =C3=97 5)=
 (MHz)                      (27)

where
                              is 0,1,... 200,
   nch
   Channel starting frequency is defined as dot11ChannelStartingFactor =C3=
=97 500 kHz or
                              is defined as 5 GHz for systems where dot11Re=
gulatoryClassesRequired is
                              false or not defined.
                              For example, dot11ChannelStartingFactor =3D 1=
0 000 indicates that Channel
                              zero center frequency is 5.000 GHz. The value=
 NULL for nch shall be
                              reserved, and a channel center frequency of 5=
.000 GHz shall be indicated by
                              dot11ChannelStartingFactor =3D 8000 and nch =
=3D 200. An SME managing
                              multiple channel sets can change the channel =
set being managed by changing
                              the value of dot11ChannelStartingFactor.


johannes

--=-BtjyIB/4/C7NkbbenqKS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGb8Vq/ETPhpq3jKURAndwAKCQbvLe4JP1avcTGdsgVQ35/vm8/wCdG+9P
QqJCJqTsRFudTZ59Yo2ZVGA=
=uJe9
-----END PGP SIGNATURE-----

--=-BtjyIB/4/C7NkbbenqKS--


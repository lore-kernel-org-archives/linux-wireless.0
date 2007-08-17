Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbXHQPJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 11:09:35 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Johannes Berg <johannes@sipsolutions.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1187360200.4417.32.camel@thinkpad>
References: <1187151162.3253.18.camel@thinkpad>
	 <1187308221.23489.91.camel@johannes.berg>
	 <1187360200.4417.32.camel@thinkpad>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V0imD5IkhJG9kWOc0Y7S"
Date: Fri, 17 Aug 2007 17:09:05 +0200
Message-Id: <1187363345.6090.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V0imD5IkhJG9kWOc0Y7S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 10:16 -0400, Volker Braun wrote:

> NetworkManager can do that for you, no need to duplicate that in the
> driver where you can't give any useful feedback to the user. Maybe you
> want to test whether your AP _really_ discards unencrypted data?=20

Can't really do that since it'll ack the packet anyway :)

> It should be broadcast, you are right.

Don't think it matters much, was just curious.

> The key index is saved later on in key->keyidx. So I wanted to be on the
> safe side and make sure that a legal value is stored there.

Right. I was totally confused about some things and just reread the
standard again :)

> First of all, we violate the standard by looking at the keyindex in case
> of a pairwise key.

I don't think we do look at it, do we? In any case, if it was there I
removed it with the RFC key selection patch.

> Now granted, Cisco also violates it, but in a way
> that is never visible to standards-compliant STAs. We must set the
> keyindex to zero on outgoing pairwise key-encrypted data, but that is
> kind of irrelevant since the AP is forced to ignore that key index on
> receive.

But then I don't understand why we try to set a non-zero key index for
the key.

johannes

--=-V0imD5IkhJG9kWOc0Y7S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxboR/ETPhpq3jKURAtCuAJ4hOzxkCJYufCohTonjW8WEqhLTHwCdFu9v
WWkDRxjsUBz86WbCfJqHwm8=
=0CSN
-----END PGP SIGNATURE-----

--=-V0imD5IkhJG9kWOc0Y7S--


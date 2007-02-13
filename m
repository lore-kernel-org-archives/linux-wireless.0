Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXBMQVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 11:21:23 -0500
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070212183020.GA16597@instant802.com>
References: <200702041344.19117.mb@bu3sch.de>
	 <20070212183020.GA16597@instant802.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CmVnoDpw9IittsBvVAlt"
Date: Tue, 13 Feb 2007 17:18:51 +0100
Message-Id: <1171383531.10344.34.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CmVnoDpw9IittsBvVAlt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-12 at 10:30 -0800, Jouni Malinen wrote:

> How exactly is this supposed to work for RX? Phase1 needs to be
> calculated after 65536 frames (whenever iv32 changes), but the
> exact time for RX case is unclear due to possible loss of frames and
> retransmissions etc. Is bcm43xx just going drop couple of packets
> whenever the phase1 value is changed?

I think it's been said before, but I'll explain it (again). bcm43xx hw
will simply not decrypt the frame if the iv32 is different from what it
has the phase1 key for, so then it passes it up undecrypted.

>  Or is there some kind of
> mechanism for the hardware/firmware request a new phase1 value? Or is
> this supposed to be recovered from in software (which is something that
> d80211 is able to do if the radio driver notifies that the frame was not
> decrypted)?

Yeah, you notice the frame wasn't decrypted and then give the hw the new
phase1 key and also recover in software (or just drop the frame if you
want, I guess).

johannes

--=-CmVnoDpw9IittsBvVAlt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0eTr/ETPhpq3jKURAiC4AKCUaD5YHyEajGjX0pYx9e+0x94w+gCgsa1h
9EN/tO/vTN/yk3rDewacx/4=
=tsVH
-----END PGP SIGNATURE-----

--=-CmVnoDpw9IittsBvVAlt--


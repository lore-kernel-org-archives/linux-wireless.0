Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674AbXDBQ6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 12:58:54 -0400
Subject: Re: SIOCSIWAP behavior question
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1175521655.9859.15.camel@localhost.localdomain>
References: <1175521655.9859.15.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0dQqWT6nIJ592SQPmgsp"
Date: Mon, 02 Apr 2007 18:58:14 +0200
Message-Id: <1175533095.23438.79.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0dQqWT6nIJ592SQPmgsp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-02 at 09:47 -0400, Dan Williams wrote:
> Should setting a BSSID trigger a disconnection event from the driver?
> Obviously a disconnect event shouldn't be triggered if the BSSID being
> set is the same BSSID the card is already associated with.  Or does that
> mean "reassociate unconditionally" ?

IMHO (answering your rephrased question with "always") it should unless
the BSSIDs are really identical. After all, one disassociates from one
BSS before associating to the other.

> The libertas driver currently does this; it sometimes confuses
> wpa_supplicant and is arguably wrong behavior because drivers don't
> issue disconnection events when auto-roaming from BSSID to BSSID in the
> same ESS.

Is there a way to trigger such events when auto-roaming? :)

> Thoughts?  I guess I vote for not sending disconnect events if that
> BSSID has the same capabilities and the same SSID as the current
> association BSS.

I think that just makes things unnecessarily complex -- we'd have to try
to see if two things are really the same ESS in the driver/stack/...

johannes

--=-0dQqWT6nIJ592SQPmgsp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGETYm/ETPhpq3jKURAgO+AJ9lnbIaOd7BSivU1f8UltUaQB/F6gCdEkrB
NjGjoy6L1YeJ8MwtBIJI4o4=
=Jw6R
-----END PGP SIGNATURE-----

--=-0dQqWT6nIJ592SQPmgsp--


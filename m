Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33439 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3LQJWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 04:22:31 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so2743531eek.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 01:22:28 -0800 (PST)
Date: Tue, 17 Dec 2013 10:21:20 +0100
From: Henrik Austad <henrik@austad.us>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-rt-users@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/10] make iwlwifi RT friendly
Message-ID: <20131217092120.GA28480@austad.us> (sfid-20131217_102238_136222_14578E89)
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
 <20131215154843.GL31090@linutronix.de>
 <52ADEAAF.3080107@gmail.com>
 <52ADEB0D.3080306@linutronix.de>
 <52ADEBDF.5060406@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
In-Reply-To: <52ADEBDF.5060406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 15, 2013 at 07:50:23PM +0200, Emmanuel Grumbach wrote:
>=20
>=20
> On 12/15/2013 07:46 PM, Sebastian Andrzej Siewior wrote:
> > On 12/15/2013 06:45 PM, Emmanuel Grumbach wrote:
> >> No we don't. The primary interrupt just tells the hardware to stop
> >> firing interrupts and wakes up the thread as written above.
> >=20
> > Sounds great then.
> >=20
>=20
> Ok - I guess I'll submit then internally then before we send them upstrea=
m.

I'm trying to mash this on top of 3.12.5 for the latest rt-release, and=20
especially drivers/net/wireless/iwlwifi/pcie/rx.c is not particularly=20
compatible with your patches, especially iwl_pcie_int_cause_non_ict(),=20
which as been moved, renamed and given new return values.

Especially 07 is giving me some headaches, and instead of me making a=20
massive trainwreck of it all, would you mind moving this closer to 3.12?

Thanks!

--=20
Henrik Austad

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKwF5AACgkQ6k5VT6v45lmElwCcDdDgBqI42zooxDbPb1yHKY+b
PUsAmwUdVOH1fJVJMHYI1v73WH4k30iU
=3Tsq
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37435 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3LQJod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 04:44:33 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so2364554eaj.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 01:44:32 -0800 (PST)
Date: Tue, 17 Dec 2013 10:43:25 +0100
From: Henrik Austad <henrik@austad.us>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/10] make iwlwifi RT friendly
Message-ID: <20131217094325.GA2413@austad.us> (sfid-20131217_104440_540419_BE183367)
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
 <20131215154843.GL31090@linutronix.de>
 <52ADEAAF.3080107@gmail.com>
 <52ADEB0D.3080306@linutronix.de>
 <52ADEBDF.5060406@gmail.com>
 <20131217092120.GA28480@austad.us>
 <0BA3FCBA62E2DC44AF3030971E174FB303D2233A@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D2233A@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 09:32:14AM +0000, Grumbach, Emmanuel wrote:
> >=20
> > On Sun, Dec 15, 2013 at 07:50:23PM +0200, Emmanuel Grumbach wrote:
> > >
> > >
> > > On 12/15/2013 07:46 PM, Sebastian Andrzej Siewior wrote:
> > > > On 12/15/2013 06:45 PM, Emmanuel Grumbach wrote:
> > > >> No we don't. The primary interrupt just tells the hardware to stop
> > > >> firing interrupts and wakes up the thread as written above.
> > > >
> > > > Sounds great then.
> > > >
> > >
> > > Ok - I guess I'll submit then internally then before we send them ups=
tream.
> >=20
> > I'm trying to mash this on top of 3.12.5 for the latest rt-release, and=
 especially
> > drivers/net/wireless/iwlwifi/pcie/rx.c is not particularly compatible w=
ith your
> > patches, especially iwl_pcie_int_cause_non_ict(), which as been moved,
> > renamed and given new return values.
>=20
> iwl_pcie_int_cause_non_ict didn't exist before my patch. I am not sure I =
follow here...

bah, git is messing with my head, iwl_pcie_is_non_ict() used a lot of the=
=20
same code as iwl_pcie_isr(), so I mistakenly saw it as a rename (which got=
=20
me a bit confused). Looking closer and applying enough braincells to form a=
=20
synapse, I see that it has just moved further down.

> I am not sure I'll have the time to fulfill your request, but I'll try.

Fair enough, I'll give the rt-port of the patches another go :)

--=20
Henrik Austad

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKwHL0ACgkQ6k5VT6v45lnfUgCg0IaXo6/+NE+rubadYsvcOQ7X
m6IAn0E8UdKj/Hf1uDdF8fkZkhs4JJ8a
=XkMX
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([87.230.16.230]:50017 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXE2S3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2007 14:29:13 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Tue, 29 May 2007 20:28:19 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	Gary Zambrano <zambrano@broadcom.com>, netdev@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705282255.56490.maxi@daemonizer.de> <1180388752.3657.13.camel@chaos>
In-Reply-To: <1180388752.3657.13.camel@chaos>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2108277.LgnDDiMWG5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705292028.23386.maxi@daemonizer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2108277.LgnDDiMWG5
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 May 2007, Thomas Gleixner wrote:
> On Mon, 2007-05-28 at 22:55 +0200, Maximilian Engelhardt wrote:
> > > > I additionally built my 2.6.22-rc2-mm1 kernel without High Resoluti=
on
> > > > Timer, but the high ping problem is still there.
> > >
> > > Hmm, that's mysterious. Wild guess is that highres exposes the hidden
> > > "feature" in a different way than rc2-mm1 does.
> >
> > I think the bug in 2.6.21/22-rc3 is a different one that the one in
> > 2.6.22-rc2-mm1, but that's also only a wild guess :)
> >
> > I'll explain this a bit:
> > In 2.6.21/22-rc3 is the same b44 driver that has been in the stock
> > kernels for some time. With this driver and High Resolution Timer turned
> > on I get problems using iperf. The problems are that the systems becomes
> > really slow and unresponsive.  Michael Buesch thought this could be an
> > IRQ storm which sounds logical to me. This bug did never happen to me
> > before I startet the iperf test.
>
> Can you please apply
>
> http://www.tglx.de/projects/hrtimers/2.6.22-rc3/patch-2.6.22-rc3-hrt1.pat=
ch
>
> on top of rc3 and check, whether it has any effect on your problem.
>
The patch didn't change anything.

> > The other issue happens only with 2.6.22-rc2-mm1 which includes the b44
> > ssb spilt. It's independed wether High Resolution Timer is turned on or
> > off I always get very varying and high ping times. The iperf-test doesn=
't
> > show the problems from 2.6.21/22-rc3.
>
> Neither with nor without highres ?

Yes, it doesn't matter if highres is turned on or off. iperf never showed t=
he=20
problem from 2.6.21/22-rc3.

Maxi

--nextPart2108277.LgnDDiMWG5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXHDHOimwv528XGERAvpZAKDu3pqAnjMzHV5odcOiR2TmhWn8bQCg2hQ/
2ZkoY2na1eNflA4m/XLM1AA=
=hbMa
-----END PGP SIGNATURE-----

--nextPart2108277.LgnDDiMWG5--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smp.if.uj.edu.pl ([149.156.82.206]:37603 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab1IHXQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 19:16:45 -0400
Date: Thu, 8 Sep 2011 18:54:34 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Michael Witten <mfwitten@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mac80211: fix suspend/resume races with unregister hw
Message-ID: <20110908165434.GC9104@smp.if.uj.edu.pl> (sfid-20110909_011649_264728_A97F809D)
References: <1313150459-13234-1-git-send-email-sgruszka@redhat.com>
 <d9f6472975e34cb294831e32c8ce2346-mfwitten@gmail.com>
 <20110908064410.GA2195@redhat.com>
 <CAMOZ1BvsPok-AZVCwKnv0hWWXyV+np+nARjGRqwqsvC-du_GAw@mail.gmail.com>
 <20110908162605.GD2195@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-6834-1315500875-0001-2"
In-Reply-To: <20110908162605.GD2195@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-6834-1315500875-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09-08 18:26, Stanislaw Gruszka wrote:
> On Thu, Sep 08, 2011 at 04:04:28PM +0000, Michael Witten wrote:
> > On Thu, Sep 8, 2011 at 06:44, Stanislaw Gruszka <sgruszka@redhat.com> w=
rote:
> > > On Wed, Sep 07, 2011 at 09:50:29PM -0000, Michael Witten wrote:
> > >> My boot process is stalling proximate the following messages (after =
a period
> > >> of time, some other message might show up, but the boot never progre=
sses much
> > >> further):
> > >>
> > >> =A0 cfg80211: World regulatory domain updated:
> > >> =A0 cfg80211: =A0 =A0 (start_freq - end_freq @ bandwidth), (max_ante=
nna_gain, max_eirp)
> > >> =A0 cfg80211: =A0 =A0 (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 =
mBi, 2000 mBm)
> > >> =A0 cfg80211: =A0 =A0 (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 =
mBi, 2000 mBm)
> > >> =A0 cfg80211: =A0 =A0 (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 =
mBi, 2000 mBm)
> > >> =A0 cfg80211: =A0 =A0 (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 =
mBi, 2000 mBm)
> > >> =A0 cfg80211: =A0 =A0 (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 =
mBi, 2000 mBm)
> > >>
> > >> I bisected to this patch, namely via the following commit:
> > >>
> > >> =A0 commit ecb4433550f0620f3d1471ae7099037ede30a91e
> > >> =A0 Author: Stanislaw Gruszka <sgruszka@redhat.com>
> > >> =A0 Date: =A0 Fri Aug 12 14:00:59 2011 +0200
> > >
> > > Grr, crap.
> > >
> > >>
> > >> Now, it may be the case that my system startup's scripts are doing s=
omething
> > >> funny, as the stall described above occurs after Arch Linux outputs:
> > >>
> > >> =A0 Waiting for UDev uevents to be processed
> > >>
> > >> At this point, that's all I know.
> > >
> > > What wireless driver are you using? If this is ipw2x00 please try
> > > attached patch.
> >=20
> > I am indeed using `ipw2200', and your patch seems to fix the problem.
> >=20
> > How did you know what to do?
>=20
> You are not the first person who hit this bug and did bisection :-/
> Witold (CCed) did it. Can you also check if wireless network and rmmod
> ipw2x00 works? I did not yet receive that information from Witold
> regarding latest patch.

I'm just checking it (latest patch). Hit some another bug in logfs :)



--=20
Witold Baryluk

--=_smp.if.uj.edu.pl-6834-1315500875-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5o80oACgkQ7ZLFFOttZ4JnhgCdF9yX7aPnXWCLpzDAOcaEEQOJ
jnsAn3KC22HhQIdiw58qV/V1Zyosp/+U
=a+4W
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-6834-1315500875-0001-2--

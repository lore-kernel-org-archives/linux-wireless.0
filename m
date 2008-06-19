Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:32873 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbYFSNlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 09:41:17 -0400
Date: Thu, 19 Jun 2008 09:41:38 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: More 4965 woes
Message-ID: <20080619134138.GA27021@drd1813.lan> (sfid-20080619_154120_863927_76BAE742)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <20080617132401.GA8328@drd1813.lan> <1213781294.2625.52.camel@debian.sh.intel.com> <20080618154109.GB15170@drd1813.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
In-Reply-To: <20080618154109.GB15170@drd1813.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2008 at 11:41:10AM -0400, Mike Kershaw wrote:
> On Wed, Jun 18, 2008 at 05:28:14PM +0800, Zhu Yi wrote:
> > On Tue, 2008-06-17 at 09:24 -0400, Mike Kershaw wrote:
> > > 1 - Inability to associate to a network on 5ghz.  Same AP on 2.4ghz
> > >   works fine, scanning shows the AP fine.  Sniffing with an additional
> > >   card shows no frames at all being sent by the 4965. AP is on a
> > > channel
> > >   the 4965 should be able to talk to according to iwlist channel (logs
> > > attached)
> >=20
> > >From the log, you are trying to use channel 56 which is under radar
> > detection. The card must hear from the AP first in order to send. Can
> > you try 36?=20
>=20
> Must hear from the AP?  Like, beacons?  If beacons aren't enough, how is
> something ever supposed to associate?
>=20
> The AP is detected normally via scanning (wpa_supplicant 'scan' and
> iwlist scan) so the card is seeing beacons fine.
>=20
> I'll reboot into the git kernel later today and redo the test on another
> channel.

On channel 36 things appear to work (well, as much as they do otherwise,
packet hanging still makes the device unusable).  I'm still confused as
to why the card can report it works on that channel, scan that channel,
see beacons, but then refuse to transmit.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

Catapultam habeo. Nisi pecuniam omnem mihi dabis, ad caput tuum saxum=20
immane mittam.=20

I have a catapult. Give me all your money, or I will fling an enormous=20
rock at your head

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhaYhIACgkQ17KIInOLvbFl+QCfV7q/hNLfS1IiovkiqCcWSdOq
cGAAnjp30w79y0ufS7sRKnjk8S9gEMfm
=oZLu
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--

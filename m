Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:26686 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030396Ab3HIH1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 03:27:15 -0400
Date: Fri, 9 Aug 2013 09:21:52 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <ordex@autistici.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2] cfg/nl80211: send CMD_INTERFACE event on
 NETDEV_UNREGISTER
Message-ID: <20130809072152.GD2281@open-mesh.com> (sfid-20130809_092718_994301_C3F66EBB)
References: <1376004275-606-1-git-send-email-ordex@autistici.org>
 <1376031393.8355.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2hMgfIw2X+zgXrFs"
In-Reply-To: <1376031393.8355.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2013 at 11:56:33PM -0700, Johannes Berg wrote:
> On Fri, 2013-08-09 at 01:24 +0200, Antonio Quartulli wrote:
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >=20
> > Userspace applications may be listening for events (e.g.
> > matching mgmt frame) on a given interface. If such interface
> > is deleted they would keep hanging because no event will be
> > delivered anymore.
> >=20
> > Send a CMD_INTERFACE event on NETDEV_UNREGISTER to notify
> > userspace that the interface does not exist anymore.
>=20
> This is too slippery a slope for me, I'm not going to apply this. You
> can listen to normal interface events in rtnetlink.

Mh, ok. Even if it is strange that an nl80211 socket does not get any
notification on interface deletion.
But yes, I'll listen for rtnl events. Thanks for the hint.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--2hMgfIw2X+zgXrFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSBJiQAAoJEADl0hg6qKeO5hAQAKbof2wBdwmDr1VbV0iJ0yNE
uW3k7IH739GNUKDAk7t17Kx+jPW9Yce4lzd+afpvLjeNh+IIAToK7DT5d+4nUu73
6HA+SVqKncosqUGyM55O847uoJPHGaHKtSiQoJYtL65ya7b+0GDHkJdY71lB72GO
SG+9k77Xny1sbUQAkxNW/BJ8OgeHx/LI6McYdidT19El/HMdjjDYntSSHBz9eI9/
M+qOF4qsqg7VE6C1lGSCrTEx4dHRd3XUuqVIjuddUVxotvSA+sx+yAf7T/b5/UPp
swmqsVNChDcM6EDqedFnznKdZGWYPlajKsvGlABDawSP6pLCtkIU0ZDfuJPhnlmU
+Y6/WuGbbQQ78EBFrK5q1GJCGGRErC2zgZZ5iTLfMzfO+cKKKhABrhXX1SM4uxB+
4xGLuY+nveF9Py4OtCxRTU8AEtnkJ9qmCYtz8YyMthwcjzwHFoxwNQEKAIJX/R1I
PnbK/RxiuyP1RyCwSWpaZ1/ncT8ySpKRVQq3VOtktYqAZb8cPE5V/uonWcOpW2bJ
Z2hceKdxFraioUrTPNvzNG5Ta4QifjpJgKK5QhckH7aI1PoG5miMRDRLrGu6HAbl
eLWWY29bphhPI9oJ8A/ErhET6e9IFZVMAMO4IBAmR6fXJxYSYJE4RQIrzW5wYPED
dka2okkONQwcOa9sYlpn
=xOLa
-----END PGP SIGNATURE-----

--2hMgfIw2X+zgXrFs--

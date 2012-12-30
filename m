Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35287 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2L3XdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2012 18:33:13 -0500
Date: Mon, 31 Dec 2012 00:33:04 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from
 outside
Message-ID: <20121230233304.GB16767@pandem0nium> (sfid-20121231_003317_309510_D1EE7F92)
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354042232-32428-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354111295.9345.25.camel@jlt4.sipsolutions.net>
 <20121130134311.GA19037@pandem0nium>
 <1356707102.9922.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
In-Reply-To: <1356707102.9922.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 28, 2012 at 04:05:02PM +0100, Johannes Berg wrote:
> On Fri, 2012-11-30 at 14:43 +0100, Simon Wunderlich wrote:
> > On Wed, Nov 28, 2012 at 03:01:35PM +0100, Johannes Berg wrote:
> > > On Tue, 2012-11-27 at 19:50 +0100, Simon Wunderlich wrote:
> > > > It can be useful to set own WMM parameters from outside, otherwise =
there
> > > > is no way to change this in Ad-Hoc networks.
> > >=20
> > > Having proper WMM support for IBSS doesn't seem this simple.
> > >=20
> > > What about IBSS merging? What about adding WMM IEs? etc.
> >=20
> > I couldn't find anything on this in the IEEE standard - it only talks
> > about infrastructure mode, and that EDCA Parameter IEs should be adopte=
d.=20
> > (Although I doubt that's a good idea).
>=20
> In infrastructure mode the values are adopted, the IEs aren't ever
> transmitted by a client...
>=20
> I would argue that in order to join an IBSS you need to execute the
> MLME-JOIN primitive, and that has no EDCA parameter set argument so you
> should take the values from the IBSS.
>=20
> Why would that be a bad idea? It seems like a much worse idea to have
> different stations in an IBSS that have different EDCA parameters.
>=20

The idea here is to use the standard EDCA parameters (as now), but allow lo=
cal
changes. When something is adopted, it might override our local changes, an=
d this
is what we don't want.=20

In our special case (mesh networks, etc) we have control over our nodes and=
 want
to set values locally - usually the same values on all nodes (different from
standard parameters), but sometimes even different parameters, e.g. to prio=
ritize
nodes over others. The second one is more a wishlist item, however. :)

Granted, this feature will probably not be used even by the IBSS users, but
can be useful to research and special applications and shouldn't hurt to ha=
ve. :)

> > All we want here is to locally change the parameters. Seems we are not =
the
> > first ones who want to do that [1]. The WMM specification only says tha=
t no
> > WMM IEs is in the beacon and distribution of parameters is missing, and
> > therefore defaults are to be used.
> >=20
> > Therefore, I'd like to go for the local changes only and skip WMM IEs, =
adoption,
> > etc.
> >=20
> > You have a point regarding IBSS merging - with this change, we would lo=
se the
> > local configuration with the merge. This could be changed for mac80211,
> > not sure about other drivers (or if anyone actually cares).
>=20
> Wait I'm lost -- you say you don't want to adopt the parameters from
> others but then when merging ...??

Right now, when merging __ieee80211_sta_join_ibss() is called which resets =
the=20
parameters back to the EDCA defaults. We would like to keep it our local pa=
rameters.

>=20
> It seems to me that the WMM IEs also need to be present to even tell the
> peers that you're QoS capable to start with, otherwise they'll never be
> able to use QoS towards you. You're not making all that much sense right
> now, but maybe that's because I haven't looked at the code?

Just checked again ... we already use WMM IEs in IBSS, but currently don't =
advertise
any EDCA parameters in them (there are appearently different WME subtypes, =
and only
the WME subtype=3D=3D1 used by AP includes EDCA parameters). So yes, I was =
wrong
- we do have WMM IEs in IBSS, we use them to recognize that the peer is QoS=
 capable.

Anyway, how can we move forward? Ways to go I see:

 1.) Use local values, don't advertise the, don't adopt anything. That is b=
asically
     what the current patch does. As I said, we might lose the local change=
s when
     merging, so this would have to be changed.
 2.) Advertise EDCA parameters in WMM IEs, adopt them, and sync them with t=
he
     other IBSS nodes.=20
 3.) Skip the patchset altogether/keep it locally, as WMM parameters should
     not be changed at all (even if technically possible)

Preferences? Anyone else interested in IBSS + WMM?

Cheers,
	Simon

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDgzzAACgkQrzg/fFk7axYMbwCfWzSn9XIAUholzbuztL4Ix/E3
XNoAoJKsvs+t3rfwB25Yh1NHVkK5XvKz
=8lHb
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--

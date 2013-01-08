Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59891 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3AHONj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 09:13:39 -0500
Date: Tue, 8 Jan 2013 15:13:28 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from
 outside
Message-ID: <20130108141328.GA18920@pandem0nium> (sfid-20130108_151343_266869_876F071D)
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAJ-Vmok_UDVykup4xHCigrBbzErOhUQOZMATJ+=qkBFOHQS+Bg@mail.gmail.com>
 <1357131499.9839.19.camel@jlt4.sipsolutions.net>
 <201301021436.55010.chunkeey@googlemail.com>
 <1357137688.9839.43.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <1357137688.9839.43.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 03:41:28PM +0100, Johannes Berg wrote:
> On Wed, 2013-01-02 at 14:36 +0100, Christian Lamparter wrote:
>=20
> > I can't find anything useful in the 802.11-2012 spec either. There's
> > something vague in 4.7 "Difference between ESS and IBSS LANs" on page 8=
0:
> > "The services that apply to an IBSS are the SSs [Station ServiceS]. [..=
=2E].
> > The parameters that  control differentiation of the delivery of MSDUs w=
ith
> > different priority using EDCA are >FIXED<. [...]".
> >=20
> > But what does this mean? Does it translate into: "Every peer of an IBSS
> > truly independent of each other when it comes to the WMM parameters.
> > Each peer can advertise (in beacons, probes, ...) and have its own set
> > of fixed parameters and no one needs to sync those from anyone else"?
> >=20
> > Or does "fixed" just mean that everyone has to go with the default WMM
> > parameters from 8-105 [i.e.: no one can change them at all]?
>=20
> Yeah it's a little vague, but I think it means *fixed* as you describe.
> The WMM spec describes them as fixed and also doesn't include the WMM
> Parameter IE in beacons/probe responses, so all of this would be an
> extension to the spec and we have to be careful not to break the spec
> (default) case (which is correct right now, afaict, with default
> parameters and no parameters IE)

It appears that WMM IEs never carry EDCA parameters, and this is also not
specified anywhere that IBSS-stations should do that. All I can find is to =
use
the default EDCA parameters, and this is done right now in Linux - external=
 WMM
IEs are ignored.

For the original patch, I'd still opt to have it integrated:
 * if no WMM EDCA parameters are provided from userspace, the default behav=
iour
   is still to use the default EDCA parameters - 99% of the people won't ch=
ange
   that
 * changed parameter sets don't have to be exposed to other nodes - the BSS
   won't break if nodes will have other parameters, it might just behave
   unexpected in terms of priority. Normal users won't tamper with EDCA par=
ameters
   and shouldn't notice that at all.
 * Exposing EDCA parameters in the WMM IEs is technically possible, but will
   probably give us more headache (syncing them, most clients won't support=
 that,
   etc) then solve problems.

With the current patch, one can just set the parameters locally, using the
already existing nl80211-commands for AP. One thing we still need to consid=
er
is the ibss-merge case (mac80211 will reset to EDCA defaults then, we want
to keep the custom values). I can provide a patch for that, of course.

>=20
> Interoperating with FreeBSD would be useful though.

Yeah I agree. Don't know what the state in FreeBSD is now, but I'd still su=
ggest
to not use EDCA-parameters in WMM IEs for reasons above. Even if Linux and =
FreeBSD
supports it in their open source drivers, there will probably tons of other=
 drivers
not supporting these parameters and breaking the mechanism - this is not st=
andard
behaviour, after all.

Adrian, others, what do you think?

Cheers,
	Simon

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDsKYgACgkQrzg/fFk7axaDQACcCJe50ie4hOyVg3WCYsrIvivB
wkYAnj0PQBb4JCQIJAY+BZR4EwGxU3TY
=2cJj
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--

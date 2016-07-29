Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42466 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbcG2Owh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2016 10:52:37 -0400
Message-ID: <1469803947.7306.139.camel@sipsolutions.net> (sfid-20160729_165241_525744_7F4C3386)
Subject: Re: [PATCH] ath10k: Allow setting coverage class
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	ath10k@lists.infradead.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Fri, 29 Jul 2016 16:52:27 +0200
In-Reply-To: <5798EEC3.5040008@candelatech.com> (sfid-20160727_192629_507046_B6A4A1EA)
References: <1469608424-11370-1-git-send-email-benjamin@sipsolutions.net>
	 <5798EEC3.5040008@candelatech.com> (sfid-20160727_192629_507046_B6A4A1EA)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-w58xpH9yTbwuM6VYYdjN"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w58xpH9yTbwuM6VYYdjN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mi, 2016-07-27 at 10:26 -0700, Ben Greear wrote:
> On 07/27/2016 01:33 AM, Benjamin Berg wrote:
> >=20
> > Unfortunately ath10k does not generally allow modifying the coverage cl=
ass
> > with the stock firmware and Qualcomm has so far refused to implement th=
is
> > feature so that it can be properly supported in ath10k. If we however k=
now
> > the registers that need to be modified for proper operation with a high=
er
> > coverage class, then we can do these modifications from the driver.
> >=20
> > This patch implements this hack for first generation cards which are ba=
sed
> > on a core that is similar to ath9k. The registers are modified in place=
 and
> > need to be re-written every time the firmware sets them. To achieve thi=
s
> > the register status is verified after any event from the firmware.
> >=20
> > The coverage class may not be modified temporarily right after the card
> > re-initializes the registers. This is for example the case during scann=
ing.
> >=20
> > A warning will be generated if the hack is not supported on the card or
> > unexpected values are hit. There is no error reporting for userspace
> > applications though (this is a limitation in the mac80211 driver
> > interface).
> >=20
> > > > Thanks to Sebastian Gottschall <s.gottschall@dd-wrt.com> for initia=
lly
> > working on a userspace support for this. This patch wouldn't have been
> > possible without this documentation.
>=20
> I would be concerned about the various resets firmware does to work aroun=
d
> hardware hangs as well.=C2=A0=C2=A0I don't think any events are generated=
 for these, unless
> you count the dbglog messages?

Yeah, I am aware of the fact that the firmware may do internal resets
from time to time. The interesting question (and one for which I do not
know the answer) is whether we get a wmi or other event under all
conditions where the register may be rewritten due to a reset.

The current code will re-set the register value after any wmi event
including debug messages. If this is not enough, then the only solution
might be to periodically poll the register values instead of relying on
a received event.

Benjamin
--=-w58xpH9yTbwuM6VYYdjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXm22rAAoJENEjaKZhhWwgykkP/RFD4Q1H6ijTfQhrYer1UDrT
rVQoq6iTW+MY3uwD8Yc9fyi++pIga+v3ZO0OtYlZNHQl6Yd1mZQHceESS7gxlLGD
SICh5D8xY2xTjW8oGOrV3BHVxXwxj60TCg9Duxp4E2CRgpO2h11ys9MeOkog72Ue
ocO106ugNb+/QI1D9/pwNs7edhvQMLBG//rkPDHlWQG/0sPQ2TD9gkQ0D/DztBb5
yfOigLHF+iZJim5x7pGggkGjOLFtREk2kmrCHGkz38lFAkLhucSmJOM9nCW8mBBz
K3e6p+96YOL9MNDVMn9isAqn9/pEnoR8cTQihiXCgffBsG2lER23IuMMaPeZ2Ceg
T745bSOTyQTIeKAMr64fWMGo0Bc/T5or0Vz5w3kEU79PNkqU3HURUqYdYBMCZfOz
gWJlXc5ytXtE24qvibsjk/XQsN6rndr2v97JiCJTH8eh25Jjj5FU2I2U0o0Kk+hw
+3tK4VO9dhE9JJ+dS5SYnjHurGhv8wuld2SmQzOByam6crkp+fcBiYDPeMqbAsaq
0BrSMhJqsHYS/6UimczTIOAs4Ry4QBxN8svnr668QBAHl7ZoxVC2kOf3pegyLf0Y
2h7xtwBAOXNTXZuo8wCUMn+msvlXiJak+haMraM7kp5sRQjbisTLeJbaLcl1Y+Q4
wD+Zg4EdhQrw8LoD+6Hf
=0/Oc
-----END PGP SIGNATURE-----

--=-w58xpH9yTbwuM6VYYdjN--


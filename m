Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbXLRNTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:19:02 -0500
Subject: Re: [patch 0/9] Rate control rework
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linville@tuxdriver.com, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197925174.7505.3.camel@localhost> (sfid-20071217_210008_134071_D7CE2421)
References: <20071217001956.640555983@gmx.de>
	 (sfid-20071217_003027_842318_90F1A18D)  <1197900351.4885.41.camel@johannes.berg>
	 <1197925174.7505.3.camel@localhost> (sfid-20071217_210008_134071_D7CE2421)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QRfkQ0MgCsZr4iSXnZ3s"
Date: Tue, 18 Dec 2007 14:18:53 +0100
Message-Id: <1197983933.4885.130.camel@johannes.berg> (sfid-20071218_131906_604715_D1F82F0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QRfkQ0MgCsZr4iSXnZ3s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > It does, however, look like the whole rate control code needs a revamp.
> > Looks like Jiri got busy there with krefs too without giving it too muc=
h
> > thought... It looks like all that can be converted to RCU just as well
> > as all the other stuff I already converted, I don't see a reason to kee=
p
> > a reference count of the rate control algorithm for each sta.
>=20
> What bothers me most is the fact that we have several ways to refer to a
> rate: Either we use struct ieee80211_rate pointers or indices into
> local->oper_hw_mode->rates[]. This is not very consistent. Furthermore,
> there is oper_hw_mode vs scan_hw_mode. So potentially even to rates[].
> That sucks.

Yeah. That cfg80211 rate/channel stuff I had addressed some of it, but
not all, iirc.

johannes

--=-QRfkQ0MgCsZr4iSXnZ3s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fIvKVg1VMiehFYAQL29xAAtk0RQgI4dHuj6VAogWuPhq2rdEWo2i67
ghDDy4SQShotdt5UvUA7UKlPsSR6pCbp6OIJkgOegASDTa/6zK3/7lIV/M7VBD8W
XglR4n5oGugmaixmsjSfIJIgn4IlJrIko3W5GU9itbW1xI3x94zOut3+lgThdLsX
AkHWyI2o/1q98srucwboPOSBOHgIXLxyxE0gYFeMFrV+OB9CpX66ol2ETULoU2Jq
jHE8zsCO7SzRfUBYrcKnJ4jTrUC/+KEqc6U4UAicnwhrM4Ohov4O1QZtZMCeTe26
LSp/cNE4t3vc38y3d1WBERYhu8BBF2Sor6yVlSRZFx43g1usg0Q9GqvXKne5dOT2
9ZEeVsOTlmCJCy1Ye+VTVeiUvg1ZEpCo0RXljBLsoeEsXykZRZUR5mPi/3214Wc5
gyJXJ4Ga6mD10ooQDbAFFa6EPR+oXxCvuHCOpHjB124/7CN4LktbCkh/oJwxu8QV
LX3SLOTDlHuFta3YydYmNVctmVIYSSzvJ3aoQMh99ghTzKzCSyMuubqR1rxiPKi4
2gH+kmnBoFEexuvLe5Cmp48Rb/Wyt3E40DMWl9H9t2fUWrNLIxVdyAJFi5YT1jzE
KOKsQ2UoiHcmJ/VTapqjtWjD2uSduqJw6Fh5ZAmVgpwpLbpBCVq/9ZIa7T7Yxh2x
hL82YTIosV4=
=69bg
-----END PGP SIGNATURE-----

--=-QRfkQ0MgCsZr4iSXnZ3s--


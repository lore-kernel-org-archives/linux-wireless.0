Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbXJJJus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 05:50:48 -0400
Subject: Re: rt2500pci 2.0.9 not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <fei71k$tu7$1@sea.gmane.org> (sfid-20071010_104655_814828_A64B9327)
References: <fdqhn4$qab$1@sea.gmane.org> <fei4sd$mm0$1@sea.gmane.org>
	 <1192008384.12541.8.camel@johannes.berg>   <fei71k$tu7$1@sea.gmane.org>
	 (sfid-20071010_104655_814828_A64B9327)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1yWQ8PnHBYsUHASb6KUw"
Date: Wed, 10 Oct 2007 11:51:40 +0200
Message-Id: <1192009901.12541.15.camel@johannes.berg> (sfid-20071010_105052_385324_3B5E03FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1yWQ8PnHBYsUHASb6KUw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-10 at 11:43 +0200, Marcus Better wrote:
> Johannes Berg wrote:
> > Can you try that patch from Matthias Nissler ("[PATCH] mac80211: Defer
> > setting of RX_FLAG_DECRYPTED.")?
>=20
> It's already in the tree I used.

Hm, right, noticed that it was merged right after sending this. Reason
19 seems totally unrelated to crypto:
WLAN_STATUS_ASSOC_DENIED_NOSHORTPREAMBLE =3D 19

Looking at the code... Ahh, I see. You've selected the B mode instead of
G and the AP requires G. I think my "[PATCH] mac80211: fix set_channel
regression" will fix this for you.

johannes

--=-1yWQ8PnHBYsUHASb6KUw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwygq6Vg1VMiehFYAQI+vw/+K8gSuWGvW9t4FBhLiwEKPEQL+5nvqO6B
9pe2R80B1gQ6wTnYDTyoV4xQpN+Q2P/JjtWhm0GWul4WyfYIkwSFdMJTUMIJN8OZ
B5Dk2j0rGPyW/YW6XOo7PJKGjKDcARiOuLxPUFzWvuzfsyRB41kkfvmD/NkfRPSU
x2WTpF/40Vi3a1+vptY+7oIWh2POWbDbR2U/PRQ18ZPbMqTUpzV8zPrISNqgXSk9
Pp8XBu14Qzq25dPJHOpBSRTxfpH8iFeO+KKo7vV9I7JI77/fzbF4SNWlue4kJyJY
5pCr7JX/JfBphzydXFGJuUWGTxsEyA5n49wgtbecAbNgPrcovM7pA/xBKEWEOl2i
G9kotTMmNMPMHRNpVEG7r91YgtvZNj2QOaMXhznCCRG+Oiv69wOYp6y9zea6OJ3f
O4oC5+GzRs5YSIbGeWn735+7PPzi/4GDfcnTmVPLGQ0X8uQStDn0XHFC1eXpw3Xs
wNEfzuCDwfauIdmKygxRO4wO0zmahcdM4zYARSnGwdy7olvPXRhYra29JwbQ+vQ1
EM26ZoO+jsAdS6OXTp86ot1kNxvARxIKBUppW20PdFt/wq3h71T1ChVEf0nuTXeU
yHQYBYYce4PdYARXPsJ394IU3pn6wVZdxpe57nmSQyOPL7p78p6zXgzeZJhF8lSI
S0SFpZ4e9Lg=
=WmLO
-----END PGP SIGNATURE-----

--=-1yWQ8PnHBYsUHASb6KUw--


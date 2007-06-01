Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762160AbXFATaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 15:30:09 -0400
Subject: Re: mac80211 initial rate: a question
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <466045F2.6010708@lwfinger.net>
References: <466045F2.6010708@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cTtEqJq4NA7BrdpXQSfw"
Date: Fri, 01 Jun 2007 21:30:23 +0200
Message-Id: <1180726223.11026.39.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cTtEqJq4NA7BrdpXQSfw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-01 at 11:14 -0500, Larry Finger wrote:

>          /* TODO: what is a good starting rate for STA? About middle? May=
be not
>           * the lowest or the highest rate.. Could consider using RSSI fr=
om
>           * previous packets? Need to have IEEE 802.1X auth succeed immed=
iately
>           * after assoc.. */
>=20
> After that the code goes on to set the rate equal to the last one in the =
rate table, which might be=20
> the highest rate.=20

Yeah, I think that's very wrong.

> Although that rate might be OK for most of the devices using mac80211,

Even then, if the AP is just in range it might not receive transmissions
at 54M, depending on the fallback mechanism that might or might not be
ok.

> it=20
> certainly is not for bcm43xx, which does not have the ability to transmit=
 or receive at speeds much=20
> above 1 Mbs. In a private patch circulated only on the bcm43xx mailing li=
st, I changed this routine=20
> to set an initial rate of 1 Mbs, which certainly helps bcm43xx authentica=
te and communicate with the=20
> DHCP server.

The thing about 802.1X is that you have a handshake with a few packets
that need to go through or you need to restart, which is the wpa problem
people are seeing currently with bcm43xx, but my brother also sees with
madwifi/atheros in our living room upstairs (router is downstairs here)

> If this low rate were to be set for all drivers, how rapidly would the ra=
te-control algorithm=20
> respond? Would this cause a serious performance degradation?

This, unfortunately, I don't know. I'd think the algorithm would adjust
fast enough for it not to be an issue.

johannes

--=-cTtEqJq4NA7BrdpXQSfw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGYHPO/ETPhpq3jKURAnK6AKCmC8QVbrsuPgJ8Db8dheovwEUknwCfYgkO
G/cQoghJmXVp15G9eyF1ie8=
=Yazl
-----END PGP SIGNATURE-----

--=-cTtEqJq4NA7BrdpXQSfw--


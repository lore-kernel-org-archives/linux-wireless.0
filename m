Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684AbYBZPkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:40:06 -0500
Subject: mesh beaconing questions
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-meKpOIpTgJX7btkB/p/y"
Date: Tue, 26 Feb 2008 15:07:05 +0100
Message-Id: <1204034825.13162.233.camel@johannes.berg> (sfid-20080226_154011_050567_6B9BE70A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-meKpOIpTgJX7btkB/p/y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

The Draft states that beacons may be sent either as defined for IBSS or
as defined for infrastructure mode.

I have a few questions, some of which are related to our implementation
and others which are related to the Draft.

1. Are we going to let drivers choose which mode to use? Should they
indicate that somehow so userspace knows? Or are we going to make this
configurable? Can all hardware support both modes? (the last question
probably ties in with the next)

2. The Draft states to use either procedures 11.1.2.2 (IBSS) or 11.1.2.1
(infrastructure). It is easy to "port" 11.1.2.1 to mesh, but 11.1.2.2
reads like this:

--- >% ---
[...]

At each TBTT, the STA shall:

[...]

 (d) Cancel the remaining random delay and the pending beacon
     transmission, if a beacon arrives from the IBSS of which the STA is
     a member before the random delay timer has expired, at which time
     the ATIM backoff timer shall resume decrementing.
[...]
--- %< ---

However, I feel that pointing from the mesh amendement to something
rather IBSS specific is not well defined. This clause doesn't
"obviously" port to mesh since the BSSID is left zeroed in mesh! But the
draft doesn't change 11.1.2.2 either to adjust for this difference.

Hence, I think the draft needs to be expanded to modify 11.1.2.2 to
explain under which circumstances an MP shall cancel its beacon if it
opts to use IBSS-like beaconing.

I think the only useful thing is to require it to look at the mesh IEs,
but that is not implementable with existing hardware, at least not
without firmware changes. I could probably do it in Broadcom firmware
fairly easily...

So now I've probably answered my first question implicitly because I
pointed out how I think using IBSS-like beaconing isn't even
well-defined ;)

johannes

--=-meKpOIpTgJX7btkB/p/y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8QdB6Vg1VMiehFYAQIinQ//XoE1xxTUm17C4pFUYe17Zj0sjugK3ddb
A5qh46cJYqYSPq+m3Pl/JNvzKup2leMaC4iXUULppXig8fHASILUqDpNcYnH48c2
GvJ27+li0YHcAbao6FNyvUte+SXQLhRz7eMDOovLiv9JhcpjydHj5g+mygcvuthU
rxWWrtCBghN7BOCGQsN4xC/19L8cdZ29j1CYbtJiQuULlWqT7MlWek/I8meQUVgb
HsZRaQv5zEu5iH/K9ciakdxEGC9zKMzdx5ki/W9g+fuuyJjgD1Gsg3YlFtQwvt+A
p9S3Md5AChaK0Ffa100EEINd9ro9pplpDc2xoF4PY/Gtm+2FX8kgZDrOXiM6FFOQ
5UKElIdFKjVuGiCS1+jZGd/6azgUqiAr4Yrwx1X6yRJP0mVo9e/s30NsqnFuO1WP
yFtfoOcOvc7m61VdlEIsvib4DWPRJDrYvNUbFZN7CS0CVT8K6LiMjcWp37xV/ghq
FIzoIiCmADo+kDKP8SGr/BZrDS8B5lYkYUaKZV/Pt2crIfyrxKswMl/h6HxZs/TE
29eEVPaLlnYZ9FyzZFbA4GxX6pm6r858onbMqNCkm3ZnOVRIvobqcmQNXPyrdCRx
/dS32H5VbWmb45mgpuyZ5HI2AbhSs4yG77HMwGjuVc+R6ro1tNqVhv45Xik34Oql
Swaam5UQjHA=
=nJKk
-----END PGP SIGNATURE-----

--=-meKpOIpTgJX7btkB/p/y--


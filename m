Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZFEWcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 18:32:08 -0400
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200906052338.05653.mb@bu3sch.de>
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
	 <200906052101.47168.mb@bu3sch.de> <4A298C37.9030503@lwfinger.net>
	 <200906052338.05653.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oFdvsflNl7EmUoRyMuvU"
Date: Sat, 06 Jun 2009 00:32:06 +0200
Message-Id: <1244241126.15640.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oFdvsflNl7EmUoRyMuvU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-05 at 23:38 +0200, Michael Buesch wrote:

> Hell, just return a freaking error from b43_rfkill_poll(), if the interfa=
ce
> is down. If rfkill can't handle that, it should probably be taught to han=
dle it.
> Especially as there can be other errors as well, like memory allocation f=
ailures.

Be my guest. You'll notice eventually that it's not really easy or
possible to do. I've explained the currently broken scenario already.
And even if you introduce the 'unknown' state, you still end up having
to poll the bit when userspace tries to turn on the device... doesn't
help much.

Larry, thanks for your patch, I'll modify it to turn off the core again
after checking the rfkill bit tomorrow.

johannes

--=-oFdvsflNl7EmUoRyMuvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKZzjAAoJEODzc/N7+QmawvUQAIjlc+cs1+iBl020z+YoPHoh
7hQh28UcwfPW7Q/6lNEYb1/ctlBLqoId5leM+XZrZoC1k0qJEzBGAWqT9FhREYnc
DO3KFyfPpIG5LM5wfEq5p2hnprXayQEeZ5k1ZbOdbHrfJcYDmr0Bi+/+foGUcVKz
MPFPsep/QpglBdqb4oMYTgCArycfFiW3J8P/s3rHYWiyHSmJWXNLvQVMHrP7nUFO
mCuJOTsg8xYQW1gTfAiNtC0fh3VkAQK0kXz0sNSQkYDSLgDb2at1g7/t11vlSwh7
prM8yy9bIiXmT6GsCJC2TI1/10B0nQCTPLjr/SYRLTp5nXEPdnyXaHjs2v243UsH
A4uTQJXzyrp6+HFWQ8LMQfq09q4eI2PBT+2dBi7MvCeGREKKtCpsBIji78WyVkqy
9ZSK2Zu1JEn/49tpVEADuyaPmpHbCguk1dCzShuH0TdkKinWdEfV6qcil8gwfjH6
GJS8LAtvubfLN+9Sc8w3JyeaATBfs0RYPj1579HaEXA8Vy0MbmtqhHzomfQ9RtAs
9ZOboJuD15EKswqpcPzGCV9DMz0COoOwSoQqkj/BPsOlVciL13FIcD3d5++yXOWJ
bZ8xvh/Bdi99xcMc/x9QuKGpwahU0LYxLJJT8QPFhyb5u4sLOkw7UOE+KZEZBNFq
M1VzyJvouF4i8gLGpppW
=AiU8
-----END PGP SIGNATURE-----

--=-oFdvsflNl7EmUoRyMuvU--


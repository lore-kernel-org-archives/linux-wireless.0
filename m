Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:38337 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbcKKNKM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:10:12 -0500
Date: Fri, 11 Nov 2016 14:10:07 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Problems getting mwifiex with sd8887 to work
Message-ID: <20161111131007.GC1687@katana> (sfid-20161111_141015_397402_575F8ADB)
References: <20161110175915.GB1585@katana>
 <507fff29bd2048c2b2295beb451943b5@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
In-Reply-To: <507fff29bd2048c2b2295beb451943b5@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> 0x242 command failure is expected for sd8887, as It's not supported.
> Driver shouldn't abort initialization in this case. You can try below
> change. I will prepare a patch to send this command based on firmware
> version/capability.

Thanks for the heads up. If you CC me on the patch, I'll happily ack it.

Meanwhile, I nailed my problem down to some SDIO IRQ delivery issue.

Thanks again.


--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJcMvAAoJEBQN5MwUoCm2tR8QAIhcFAbNeGG/KMwmv4nlrNVX
2dyy99vTcY0HPfdkunxPtaywfI7ewFwhzHQMLK32tWslNzpbA1XPw8qRl+UkKi5y
9sse9uv7HlZjs/ZuHP16wC+0hVDkyqkntzAzLa6ddjIAoReeaV6RBghyhgQBVU0y
HJeSX/Cx9groetMLXrbEhYyFwX4nb6dzlkhVaeRIiy5JbNYNrHq7+zacbpp7EadQ
qEJghSC0R5tUviYsAq1j7Qd9Xa1sQtvQggMOCP+qxdB2+uAGEXz3WTa3YmqtZBvr
gssqX67sWKJb5LG56bPtST1fndCNUJTvNuapcvAOAV42g20/Ug6odZC4KO5m5ZpD
kof2Pl57zhWWWJ3sWwGH91eekJkoqS0tJr5ruuL26X6+A6WjyyMCI1WZtmAcLo7a
Ueq6t+ojkOca2QsBQf7JWW24jTESACLk2j1vu0+C98fGpotNnEBdduGUQoMaTBX9
4MUOzJNNi7pphKPdd8kwbXHPuvP8XGaGnQakNBqpi/i9B0ZSKrv5c+16bXMD1cHL
s/TtP1fDOTcRiZKahBTMFsfFjqW9zylumsB/BhJfcYRlHbEOpDvEN2dxI3NhxCVn
WnW5KxkprG8QN9dZad/WUz910ZdiNvhr0hHGLuiLbI/OWjwzvcv068Rrowo/E6QW
P5xlPOUosB2rOs9IsIHC
=MBQT
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--

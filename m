Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:56764 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab3EERYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 13:24:40 -0400
Date: Sun, 5 May 2013 19:24:05 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Thommy Jakobsson <thommyj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	piotras@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <20130505192405.0cf4350e@milhouse> (sfid-20130505_192456_679340_589A7590)
In-Reply-To: <CACna6ry+F45PhCXahPpJtzu-w+vLE29ksHo9njXfTcfY3Av6LA@mail.gmail.com>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
	<CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
	<CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com>
	<CACna6ry+F45PhCXahPpJtzu-w+vLE29ksHo9njXfTcfY3Av6LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z+FnjG_jiAmDwTf_jSOc2zY"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/z+FnjG_jiAmDwTf_jSOc2zY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 5 May 2013 18:31:20 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> Still worth considering is my previous e-mail. Why writing (for
> example) 1 to RXSTOPINDEX doesn't stop firmware from using slot 1?

What makes you think this register does not work?

Do you write a 1 to the register, or do you mean "the offset that
corresponds to slot 1"?

> Can it be because it's "too late"? For example:
> 1) Firmware writes to slot 0, changes "curr descr" to 1
> 2) Firmware grabs slot 1
> 3) Firmware generates IRQ
> 4) Driver reads slot 0
> 5) Driver writes RX stop index 1

The stop index is the index that the firmware does _not_ write to.
If you set it _after_ it already wrote, you clearly are too late (for
this ring wrapping).

--=20
Michael

--Sig_/z+FnjG_jiAmDwTf_jSOc2zY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRhpW1AAoJEPUyvh2QjYsOGf8P/0cE41OwSYfC2NHuSx3zXiYL
sJZHWKDEj7Swj7ivS4eTkONtb+1oWRp0wJQckN1wjbymrgZJjrO1Xgz4O/4mMkjP
aF1rHkRua3DEPbbsS5dlZHMZmXzIB63zSnLq1eYBCPHS5RyUfaGvC7mV1OVpECzA
R+O83a4wkTvqOTROgRlqQiWiCMImDNi8L1cExwiFD7YZrF6oAUT4Fy/z/KqBLZ6X
Ru8LCFZuUIAzzUZ7oP69DPsZK5HFR2Pwk316YniLxhrqJI4ZAnJiv9WBmB8fp2CX
DCWXuVcBR+FCuQ84T1ihew5A9gAYD7U5rhGsCdqeciN1AVNQ9SNwRWGzdkiFMOOY
4lwuI+84WmcSHc5Q6Rg+3itLkpMNu6tg2KTUBaviNvW7I1cNv9wJDrMPyx8KedtQ
3BqfrX4AqvZwk3elAVKs1mk5cLOP11HPCe7c6MVmeJ/yeuBSYRdjCEAXSqf+EIgc
vHgM1BydLv6vIp0F8DTHX7tvBuLvOmxci0VQELEf6N+4bGMLrPlJsonjaR6iH53o
w9AFoQ/gIA/n1jTn7AMlOiHKG/gSSUkH1aE/UxYNBwNfT3PjgZYuDGhv2ufDSPJv
E+wkX+np0xzbwKyKoLH89qVk6Ktx4upm/I0uwD+jJdI5WEeDou7RhTUA2/Jj0ZLj
vmgFGcRWWVEPvbbtlHq9
=4Txh
-----END PGP SIGNATURE-----

--Sig_/z+FnjG_jiAmDwTf_jSOc2zY--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYCQPOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 11:14:03 -0400
Subject: Re: BUG: scheduling while atomic
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200803171600.04805.hs4233@mail.mn-solutions.de> (sfid-20080317_150307_177238_56CC604F)
References: <200803171600.04805.hs4233@mail.mn-solutions.de>
	 (sfid-20080317_150307_177238_56CC604F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iccCTYjvswzMaKgUaWsW"
Date: Mon, 17 Mar 2008 16:13:25 +0100
Message-Id: <1205766805.1614.114.camel@johannes.berg> (sfid-20080317_151410_161012_DF0B6E17)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iccCTYjvswzMaKgUaWsW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

That's pretty obvious:

On Mon, 2008-03-17 at 16:00 +0100, Holger Schurig wrote:
> I have a bug that I don't have enought knowledge to debug it myself.
> It happens with wireless-testing, v2.6.25-rc5-2623-g7556b76. I've no
> additional patch from me on top of this.

> kernel:  [<f8ab71dd>] __lbs_cmd+0xd5/0x175 [libertas]

does
wait_event_interruptible(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);

but

> kernel:  [<f8aafdfc>] lbs_set_multicast_list+0x263/0x2ab [libertas]
> kernel:  [<c02c8bd5>] ? __dev_addr_add+0x5e/0xb2
> kernel:  [<c02c83d6>] __dev_set_rx_mode+0x72/0x75
> kernel:  [<c02cc984>] dev_mc_add+0x4b/0x6e

that is running under a spinlock, namely the device's tx lock.

johannes

--=-iccCTYjvswzMaKgUaWsW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR96KlKVg1VMiehFYAQKz5g/9FmzD1JHf22pkJoD6lp2Z3z8cCCElMlDe
H1ATTdlq09Hvje+qti7GPsKSWxsEBBmXuy7CYuoW81bp1xtrJa/ZglzYffyWT6bQ
ll2DvChq6lq5m9cWYRbVdck+XkrH0URStIvn+/kR79+nHjzTwy/mhWS+HkUOxQ1n
/nZ5bjMfkw0ZP54PJrIcprNnR1yL6xOwT7jfwARnvfSRcXpS1Xr2bsTX6AEzTHA5
0JOq23NO6hoHPCs8WS7zJw1iMjRqCh9QyyJsn1NQ8YYoASQBEjt+rf8vX1ORv1xa
ib/2jXf9omWDQe+gtAkFZwt/NdIm4bW8s40IifKubFjsB/S/W2CwthX1iS79Wo4c
ha+THr0ywp7AIe6JfWz2XMkKFm107qwgLrB3ZTcxuyuFYRA9DWD3JShg4ZlImi+g
iYYBj04D+vtc6kovC9zo3VPFN59pGB+ayBDx5vo/vxJ2ZUqtaLTZZapNmHcGwUvX
V+dprgiaSJS+hSJTxxPFX/IO/20ufUu+tac7ePBkEyH1dxYHrUBFkOS5SsnO2XMO
raJhm43GJ+4O6Y2OWKM0JLr7CRiJqKCUXrm4ucIK3Lsx4SDIb/Br8bJJ5QU+ytm6
Dj1nnk3XgkuBoJjJZaKp7Fhr/vV0dacPO4OCqpD3jyFpmkGv903mK0HbdPaxH58Y
DRTX4uPwOdk=
=BgfN
-----END PGP SIGNATURE-----

--=-iccCTYjvswzMaKgUaWsW--


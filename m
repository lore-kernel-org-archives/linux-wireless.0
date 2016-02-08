Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:43931 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbcBHWWx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 17:22:53 -0500
Date: Mon, 8 Feb 2016 23:22:02 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/2] b43: Remove unnecessary synchronize_irq() before
 free_irq()
Message-ID: <20160208232202.7db42b54@wiggum> (sfid-20160208_232256_708273_3FE27C5C)
In-Reply-To: <1454964073-25108-1-git-send-email-lars@metafoo.de>
References: <1454964073-25108-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NAroeOM/kQHhVxuEjAhgWB3"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/NAroeOM/kQHhVxuEjAhgWB3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  8 Feb 2016 21:41:12 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:

> Calling synchronize_irq() right before free_irq() is quite useless. On one
> hand the IRQ can easily fire again before free_irq() is entered,

Well, that depends on whether the interrupt is shared and whether we
disabled the interrupt mask inside of the device (which we did).

> on the
> other hand free_irq() itself calls synchronize_irq() internally (in a race
> condition free way), before any state associated with the IRQ is freed.

Ok, fair enough.

--=20
Michael

--Sig_/NAroeOM/kQHhVxuEjAhgWB3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWuRUKAAoJEPUyvh2QjYsOAzQP/36ikxhb/H741vZ1D3MI96LY
KOVjIlOn3tVoNQSc+5p+y8vv9c2Zhba2VmgIDnQ9iRObQXxxP+yIQR8x204iAQGU
71NAdn8j5eqVPqK+KikegmeHLEsQtzBlq2QcQ4ZtkqD5RRou73PazedsXah71Qkc
RfS4cHgqhU7G+EC+wcraksPQZw1qkODpKUt7EtjpWNQjbeIY+xbUXhpcIGsCO2cV
oaS4f0tu80UqX5dtjfWK26UomyI7CcUmNSKJGHM1kkAx9ZYdgcJpM98DkzNhTnih
tXdzdPMUB/bd/HDCzIfliBfVgYMUXb8wAz6ok7i9t+8ynYQIpY85STL8dnPX/Bds
h/mZN2Zr1Td8AdAlw73B+Hq/T0qUmuplrU2XpFA0mKOPNimjlMKv9GIV7ZEd+g2S
wQ3MMCNdgXH/YhHyi7JjGZ4LKUaw3rAP5HpMvEK/FyPfj1gihxvlECjB8HXfZPix
j3CY3PBelHPdT4bubMdXDTaIVoT8sWrxIOhLZKS+UXOUz80LJDiYIzR1mJnbV1BO
Mm5RnC33Mzoa5M5TTpAIpY//ZpLpY5zNw4f74GzgjQ2u6zKuPfj46luXeUZkyerI
QoUIlKCwneXAwBWoxQw1XdVEnFUySMetNlklh/DLtmycahY8VTXr0y99f50EamS4
2TPKKogbSmMNz/z1cxhc
=fJUJ
-----END PGP SIGNATURE-----

--Sig_/NAroeOM/kQHhVxuEjAhgWB3--

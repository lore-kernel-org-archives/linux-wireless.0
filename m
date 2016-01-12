Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33184 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbcALFpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 00:45:18 -0500
Date: Tue, 12 Jan 2016 06:44:47 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: kvalo@codeaurora.org, zajec5@gmail.com, joe@perches.com,
	davem@davemloft.net, johannes.berg@intel.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: Fix memory leaks in b43_bus_dev_ssb_init and
 b43_bus_dev_bcma_init
Message-ID: <20160112064447.055dcf7f@wiggum> (sfid-20160112_064522_298762_BCDC8574)
In-Reply-To: <1452560464-7146-1-git-send-email-baijiaju1990@163.com>
References: <1452560464-7146-1-git-send-email-baijiaju1990@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qZtyUa6f2J+v2Tw04WbZD61"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/qZtyUa6f2J+v2Tw04WbZD61
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Jan 2016 09:01:04 +0800
Jia-Ju Bai <baijiaju1990@163.com> wrote:

> The memory allocated by kzalloc in b43_bus_dev_ssb_init and
> b43_bus_dev_bcma_initis not freed.
> This patch fixes the bug by adding kfree in b43_ssb_remove,
> b43_bcma_remove and error handling code of b43_bcma_probe.
>=20
> Thanks Michael for his suggestion.
>=20
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---
>  drivers/net/wireless/b43/main.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/m=
ain.c
> index ec013fb..2c9d9c1 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -5683,6 +5683,7 @@ static int b43_bcma_probe(struct bcma_device *core)
>  	schedule_work(&wl->firmware_load);
> =20
>  bcma_out:
> +	kfree(dev);
>  	return err;
> =20

This is not correct. It will also free dev for the non-error exit.


--=20
Michael

--Sig_/qZtyUa6f2J+v2Tw04WbZD61
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWlJLPAAoJEPUyvh2QjYsONhoQAI7FaZe4H66UaVF4C3ZRZ7Gz
qaIkdpgUL96dFNp0YvPWIaGz89iZal2ZJEr7RJvLSpmT9S0K8FVYkNumO4dLPy8v
PTi1Lvs+nCyKrJWBa2nHTGMP381OC9+qLlEWRsEbhZsh/8ubQVdyQhpcXzXAMrzo
phaFOVe8XPc50QD96Dfoh+UggYC9VtNJwPukYy8lHXxePnujc8HzDnh8eh18X1Cf
oWLSr3Ujv7hoTt5Xk5+JhGI86RaYEPW3mp9dRafMjydvXe9eqVMj4uMfeLmnYDTI
75lp1x5yX3zdpDdUPrnRT3/JR3DaToPoXIgD4a1v7mXRMEb6y1OOxKrqUFIR/a4v
47P60tLeQV5CU8793RKGQfuoUbUoO7rK3YLX4J2Z+DhTY/s9Y4IQtFymeQLX9IHH
5zhBxe59PaB3Cq/v3Tbv4s5RLwaH6TuvskEnbSOAH538x9uAF1sXVGuJ3R+p5qgE
aKp1Ly64iqzj8w594uUXJw5WKi9tuw78esYkJ3PBhr5T7OfakdtBMbnpTJh0tymh
yeShqGx2uHSl5aQwI9VOFS73RWP83aNAsL4ZZ1ElNQNTHZK0SisvxffnS8h+xfjj
oIpuGlcJotOqbm9NUvWIsVzs3xmmqefalYAHt33ACcPbZp4qLmwCxCex4d9R9wvN
qW1C8qWlYWh90oXlCZaU
=BgSF
-----END PGP SIGNATURE-----

--Sig_/qZtyUa6f2J+v2Tw04WbZD61--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51553 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3LKTPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 14:15:04 -0500
Message-ID: <1386789296.21473.152.camel@fourier> (sfid-20131211_201511_409182_1039BF36)
Subject: Re: [PATCH] [stable back port for <= 3.8] staging: vt6656: [BUG]
 Fix for TX USB resets from vendors driver.
From: Kamal Mostafa <kamal@canonical.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
Date: Wed, 11 Dec 2013 11:14:56 -0800
In-Reply-To: <1385888246.3121.3.camel@canaries32-MCP7A>
References: <1385888246.3121.3.camel@canaries32-MCP7A>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-oPvP3sfAYJ2yq8ZBLMNU"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oPvP3sfAYJ2yq8ZBLMNU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-12-01 at 08:57 +0000, Malcolm Priestley wrote:
> upstream commit
> 9df682927c2e3a92f43803d6b52095992e3b2ab8
> back port for 3.8 and less kernels.

Thanks very much Malcolm...  I'll queue this up for 3.8-stable.

 -Kamal


> This fixes resets on heavy TX data traffic.
>=20
> Vendor driver
> VT6656_Linux_src_v1.21.03_x86_11.04.zip
> http://www.viaembedded.com/servlet/downloadSvl?id=3D1890&download_file_id=
=3D14704
> This is GPL-licensed code.
>=20
> original code
> BBbVT3184Init
> ...
> //2007-0725, RobertChang add, Enable Squelch detect reset option(SQ_RST_O=
pt), USB (register4, bit1)
> CONTROLnsRequestIn(pDevice,
>                                  MESSAGE_TYPE_READ,
>                                  (WORD)0x600+4,     // USB's Reg4's bit1
>                                  MESSAGE_REQUEST_MEM,
>                                  1,
>                                  (PBYTE) &byData);
> byData =3D byData|2 ;
> CONTROLnsRequestOut(pDevice,
>                               MESSAGE_TYPE_WRITE,
>                               (WORD)0x600+4,     // USB's Reg4's bit1
>                               MESSAGE_REQUEST_MEM,
>                               1,
>                               (PBYTE) &byData);
>=20
> return TRUE;//ntStatus;
> ....
>=20
> A back port patch is needed for kernels less than 3.10.
>=20
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> Cc: stable@vger.kernel.org # <=3D v3.8
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/vt6656/baseband.c | 11 +++++++++++
>  drivers/staging/vt6656/rndis.h    |  1 +
>  2 files changed, 12 insertions(+)
>=20
> diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/b=
aseband.c
> index 3855015..65503b9 100644
> --- a/drivers/staging/vt6656/baseband.c
> +++ b/drivers/staging/vt6656/baseband.c
> @@ -976,6 +976,7 @@ BOOL BBbVT3184Init(PSDevice pDevice)
>      PBYTE                   pbyAgc;
>      WORD                    wLengthAgc;
>      BYTE                    abyArray[256];
> +	u8 data;
> =20
>      ntStatus =3D CONTROLnsRequestIn(pDevice,
>                                    MESSAGE_TYPE_READ,
> @@ -1144,6 +1145,16 @@ else {
>      ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x0D,0x01);
> =20
>      RFbRFTableDownload(pDevice);
> +
> +	/* Fix for TX USB resets from vendors driver */
> +	CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ, USB_REG4,
> +		MESSAGE_REQUEST_MEM, sizeof(data), &data);
> +
> +	data |=3D 0x2;
> +
> +	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, USB_REG4,
> +		MESSAGE_REQUEST_MEM, sizeof(data), &data);
> +
>      return TRUE;//ntStatus;
>  }
> =20
> diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndi=
s.h
> index fccf7e9..dcf7bf5 100644
> --- a/drivers/staging/vt6656/rndis.h
> +++ b/drivers/staging/vt6656/rndis.h
> @@ -69,6 +69,7 @@
> =20
>  #define VIAUSB20_PACKET_HEADER          0x04
> =20
> +#define USB_REG4	0x604
> =20
>  /*---------------------  Export Classes  ----------------------------*/
> =20


--=-oPvP3sfAYJ2yq8ZBLMNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABCAAGBQJSqLmwAAoJEHqwmdxYrXhZ66gQAI+tlgEPFPK6qr4FGMPh8MOn
Q6ATicWbfPWznDO8iCI7kCic9y+PL7hbLZc3bbNm/lO3xI9wLWH31SdoNCJ6Eb4q
0UVTbIOMav3tnjiP326EEfziSbs+UWMBeuzYV1/xaygo+/WEq59JfWqGfUjwPbWF
Rw2X2V6WbPvhtE/gfYIFUbhUIXJIpq3pGoxcWpFwek3qwjMz4pDMQGYmIz+TwmAo
scCSSJm4GG8GT2JwnUf6tZXSc5MJSc76W2s9y/zzwbLz50EFf7TdqYTvwwQPG5u1
zXX0whbm2EzmDzVGbsYRBytt8yz22OWccvatkesAclIdSYqEohsgBbz+oYFWoFYX
2aKGNi+RTdew9m9Mgv3YjTbZs5c/DWRoHkN4uqLjGsMGCpL33ivl8MtzXlBsDl+v
jniUMpsR6nVX47IGPLtaBYwVG1r6gQJMwP3VkZ3AKgrC1VuRFqQjdTyv+1eR1ue3
xxU92YmM6zJQIJbRbXDgciO4T3o9ckExm/uqr3e5EdJsrPiJ8ZmAh2GFGWkkccLf
4MdqMh3KshdlDmFEfvcorfJZ1ABr357j1N/2Icmt74ewHwF9eP6ETmfVD90QuBkO
/46HKsAvCZCwb031tTIN5jQjfheL00AdLsqUnuGP8z/rgocAVO1W+4pYaC+a49DM
6ebNVorRlojpI24+1+lk
=CmGs
-----END PGP SIGNATURE-----

--=-oPvP3sfAYJ2yq8ZBLMNU--


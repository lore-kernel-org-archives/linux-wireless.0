Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZFQLR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 07:17:28 -0400
Subject: Re: [PATCH] acer-wmi: fix rfkill conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Troy Moure <twmoure@szypr.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0906171135080.3376@troy-laptop>
References: <alpine.LFD.2.00.0906171135080.3376@troy-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yclC6ydRx3cWskLW+eHg"
Date: Wed, 17 Jun 2009 13:15:34 +0200
Message-Id: <1245237334.31171.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yclC6ydRx3cWskLW+eHg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 11:51 +0100, Troy Moure wrote:
> Commit 19d337dff95cbf76ed ("rfkill: rewrite") incorrectly reversed
> the meaning of 'state' in acer_rfkill_update() when it changed
> rfkill_force_state() to rfkill_set_sw_state().  Fix it.
>=20
> Signed-off-by: Troy Moure <twmoure@szypr.net>
> ---
> This fixes the rfkill switch on my Acer laptop, which was behaving
> backwards (the state reported in the logs was the opposite of the
> state indicated by the LED).

Thanks. Looks like I made this mistake a few times.

johannes

>  drivers/platform/x86/acer-wmi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-=
wmi.c
> index 09a503e..be2fd6f 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -958,12 +958,12 @@ static void acer_rfkill_update(struct work_struct *=
ignored)
> =20
>  	status =3D get_u32(&state, ACER_CAP_WIRELESS);
>  	if (ACPI_SUCCESS(status))
> -		rfkill_set_sw_state(wireless_rfkill, !!state);
> +		rfkill_set_sw_state(wireless_rfkill, !state);
> =20
>  	if (has_cap(ACER_CAP_BLUETOOTH)) {
>  		status =3D get_u32(&state, ACER_CAP_BLUETOOTH);
>  		if (ACPI_SUCCESS(status))
> -			rfkill_set_sw_state(bluetooth_rfkill, !!state);
> +			rfkill_set_sw_state(bluetooth_rfkill, !state);
>  	}
> =20
>  	schedule_delayed_work(&acer_rfkill_work, round_jiffies_relative(HZ));

--=-yclC6ydRx3cWskLW+eHg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKONBRAAoJEODzc/N7+QmaR90P/REnnNzWRbcmTifpCdlI1TmU
x7op2rx1P7/ozHKe7t0PLmG4JPhlp9mmENazhfdRsRlhnLV4wLuy3ciTrs91S2TN
mao4j7LfqUTdWGV1TrWRzUUgwjljssH4FbkxbUVsbNk0Um1XI2sguMrrVrTw97BU
syPg/tEAIW8VRJgFB67qBW6AbOboqyVzFSHEQ9zoKEutI0CHO/bgwBvzAWbtaG5X
iVSlShp2S/wVIajIPgWHOGyFPzYiCPhcYjlqWhYVkF3xc8Jolc2Q+Np2LKmQkjUF
iQylmxjRbRUnS48drV1Zm6/+djZiHI90KacBHHaV163HPDZs83+sebkTLHYK6fw/
Nso/4qF0ZHRWTXLl4Ejm2hnRpDEdoOEmes5rOZM/lx8BXd4GcfBAzyAK2fgMUCAb
Y65gtr69609tEUVgRDQF9rVDwhrKphkvmrw1jlrPpVLmEutXW1WbjO2ZPaqlsPEH
HPB8XoIZWRKLz+kERCxuWEdbryL16Aktoyk3pbw6Y6ZM5hhWngeaHIDuMGilk6uN
dOn+D7NhnRssclC/xQfEXi7pKZ1MZXh24sTdqRpNEfKthX0tfIsbHbtYRP7KokYU
W3roY+upS5vQ88Zmt+M++szsC8n8Sf53+Nav/bmgWT/G2e8Ppopysw1xHdxLUYxL
cYZejJsUP8uMJwGRVMXg
=eCVf
-----END PGP SIGNATURE-----

--=-yclC6ydRx3cWskLW+eHg--


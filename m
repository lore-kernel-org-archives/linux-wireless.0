Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbZIXT1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 15:27:13 -0400
Subject: Re: [PATCH] sony-laptop: check for rfkill hard block at load time
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Mattia Dongili <malattia@linux.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Norbert Preining <preining@logic.at>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
In-Reply-To: <4ABBC54C.5010103@tuffmail.co.uk>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
	 <1253801252.3868.108.camel@johannes.local>
	 <4ABB89B2.8070302@tuffmail.co.uk>
	 <1253804713.3868.168.camel@johannes.local>
	 <4ABB8C5E.6070402@tuffmail.co.uk>
	 <1253813371.3868.313.camel@johannes.local>
	 <4ABBC54C.5010103@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-k+1v0CwzuxzTH5/de1hr"
Date: Thu, 24 Sep 2009 21:27:15 +0200
Message-Id: <1253820435.3868.473.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k+1v0CwzuxzTH5/de1hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 20:15 +0100, Alan Jenkins wrote:
> "I recently (on a flight) I found out that when I boot with the hard-swit=
ch
> activated, so turning off all wireless activity on my laptop, the state
> is not correctly announced in /dev/rfkill (reading it with rfkill command=
,
> or my own gnome applet)...
>=20
> After turning off and on again the hard-switch the events were right."
>=20
> We can fix this by querying the firmware at load time and calling
> rfkill_set_hw_state().
>=20
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Tested-by: Norbert Preining <preining@logic.at>

Looks good, thanks Alan.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  drivers/platform/x86/sony-laptop.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/so=
ny-laptop.c
> index dafaa4a..a234a9d 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -1081,6 +1081,8 @@ static int sony_nc_setup_rfkill(struct acpi_device =
*device,
>  	struct rfkill *rfk;
>  	enum rfkill_type type;
>  	const char *name;
> +	int result;
> +	bool hwblock;
> =20
>  	switch (nc_type) {
>  	case SONY_WIFI:
> @@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct acpi_device=
 *device,
>  	if (!rfk)
>  		return -ENOMEM;
> =20
> +	sony_call_snc_handle(0x124, 0x200, &result);
> +	hwblock =3D !(result & 0x1);
> +	rfkill_set_hw_state(rfk, hwblock);
> +
>  	err =3D rfkill_register(rfk);
>  	if (err) {
>  		rfkill_destroy(rfk);


--=-k+1v0CwzuxzTH5/de1hr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu8gPAAoJEODzc/N7+Qma3l8P/1GE+7v9hZeWUTa+9maonKwr
HrXqfI8H8In3Y0SlsMpPK85nisCbsI4j38J05cB2OGkcmS+FId0ihfrJpw6M9Jvs
uY0DuYOm5xQC4/hm9VVYNeoyQAdv3o9JE+PTa2NYvyPhLdA86iMDZr6209FQ4hoB
OgksOGWjbcATpzlHvc6HCursuSDp2UlJMsMLwpMLzroCApQqRESl3yqIuHLXIW1E
el9Gx2xqGzAjGlLkv3cIH45e4NwtubNr4A1WWbkeF0VCZqshBucX9LcHpwCD8VEH
mW0/z98v4G6QWzZnaxvEJh8FUBcTDvpYRXZI5i5nrLVbNRvTecSvbh5nqf9NsEWm
lZC9y2Sgbzvhbia3VMt9hm8yrL9nRJDqJTAlQ1CcShnEHSGy0xDeF4rzYKpflSyx
aEjgXiRdTEmsp+6KcJW1+qqBUwVjeyIthm4cqYmXW1GhF8p6Y0Lbd2UgJtIQmog/
Is1LChy1qrooFroCng0WBV1e5ByV+puwQTnh5rTnSjbyJZvwZIEiAKpNuYwwlDMw
V4ChyI/XhKwg9p7o8wOSkE/p0nPDpSfiacMBAXvHnyL60OUFwr9HQifowVTHMbiK
gNxQd41VMFzYbolv0OV6ofM9nfBDFqhjIUUEVpMekmFTGLqTR143uNE0ASTxnFo/
xNAKVNAhHsHr84VL5rxT
=onF9
-----END PGP SIGNATURE-----

--=-k+1v0CwzuxzTH5/de1hr--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZJaFnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 01:43:03 -0400
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256939549.31271.14.camel@maxim-laptop>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939549.31271.14.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ud6BWiyYMB0y4tZ+t+wQ"
Date: Sat, 31 Oct 2009 06:43:02 +0100
Message-ID: <1256967782.3555.69.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ud6BWiyYMB0y4tZ+t+wQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-30 at 23:52 +0200, Maxim Levitsky wrote:
> >From 1d13f997f652c7e632d4ddb053df3f3fad78da23 Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Fri, 30 Oct 2009 23:36:20 +0200
> Subject: [PATCH 1/2] Allow scanning while in authenticated only state
>=20
> Since ifmgd->work_list is {ab}used as a storage for authenticated,
> but not associated access points (this is done using idle work items),
> allow scanning if all work items are in this state.
>=20
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

I don't think this is needed. While not _strictly_ wrong, I still
dislike the additional complexity.

I think you just need this wpa_supplicant patch:
http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59/deau=
th-on-disassoc.patch

johannes

> ---
>  net/mac80211/scan.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index c46ac01..c932765 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -418,6 +418,7 @@ static int __ieee80211_start_scan(struct ieee80211_su=
b_if_data *sdata,
>  {
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
> +	struct ieee80211_mgd_work *wk, *tmp;
>  	int rc;
> =20
>  	if (local->scan_req)
> @@ -450,9 +451,14 @@ static int __ieee80211_start_scan(struct ieee80211_s=
ub_if_data *sdata,
>  	if (req !=3D local->int_scan_req &&
>  	    sdata->vif.type =3D=3D NL80211_IFTYPE_STATION &&
>  	    !list_empty(&ifmgd->work_list)) {
> -		/* actually wait for the work it's doing to finish/time out */
> -		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
> -		return 0;
> +
> +		/* actually wait for the work it's doing to finish/time out*/
> +		list_for_each_entry_safe(wk, tmp, &ifmgd->work_list, list) {
> +			if (wk->state !=3D IEEE80211_MGD_STATE_IDLE) {
> +				set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
> +				return 0;
> +			}
> +		}
>  	}
> =20
>  	if (local->ops->hw_scan)


--=-Ud6BWiyYMB0y4tZ+t+wQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK685gAAoJEODzc/N7+QmasCoP/3XYo3ghG1qn5UR/MLjSLgCv
tYLLQbPLPQqZ7lhZQUFYZYsDm+7SjRpNaWgzhngo/RGkyvV0vlbeUazVM1aRMp5p
tpKa55qJgpeBOFt2pX0J4FKMMzX9IueeAfwM9UyS7PgtCeoPZ2YWbIPGb4LOVcuR
3auGmvUF8X66M1rVkKlbB/nSKJ2qXd/vWThPpRIGg/tpu3jRdYVAOZn1jqKa1c4r
ShF5eF+ZWfYhcGMglmoRive0xjbLvmZRg91K7AtUEBUCozFUX0FXf8OJBi+TTpZY
2gA0fAvmlghRsGrqbyfY65ZhLBWVb2KigHa+8C4CDP0gKQUrzegqFiJApoy6tbdo
VAxGk+NuGzmDy+cvVDPX1n93C3ychcmgG48Q0B7Ud3R5jIzm1mDsTn594Hn+6tbC
UELLQl02EZacPhOI1P3fAzr10HzglR4ZAUzg9EJIhXMdeazMsubWeHBShX7GRODL
UEG47OhjjNLhhGDtkb28Nm9YvId1QpiSvB2pUnhN0TW0MsidpUZKOoLMN+4J7sUs
UI4T493A26E5zk7Ei3SNsThxKnVj2ANgH1icAA5yRZpWGJZRplw6FkPoVg6nIgCT
MLXzB2AcRfluH/1kKXyK2uV7KOcUQBpE0vYEO5h2pw819/Y4ritcKH0gQ/V+axzk
fTz0WUtt31KwS82KPAY5
=Ykh0
-----END PGP SIGNATURE-----

--=-Ud6BWiyYMB0y4tZ+t+wQ--


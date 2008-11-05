Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYKEMCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 07:02:14 -0500
Subject: Re: [PATCH 6/7] cfg80211: initialize last_request
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QDicfffc+Y3AoXkGg2PR"
Date: Wed, 05 Nov 2008 13:02:16 +0100
Message-Id: <1225886536.3619.86.camel@johannes.berg> (sfid-20081105_130216_830829_FEF4E854)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QDicfffc+Y3AoXkGg2PR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
> last_request was not being initialized. By initializing it
> we don't fix a bug as we are not checking for it before prior
> to a regulatory hint however we may do so at a later time.

It's a static variable, it always starts out as NULL, this isn't
necessary.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index f062b8b..3754d0d 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -899,6 +899,8 @@ int regulatory_init(void)
>  	if (IS_ERR(reg_pdev))
>  		return PTR_ERR(reg_pdev);
> =20
> +	last_request =3D NULL;
> +
>  #ifdef CONFIG_WIRELESS_OLD_REGULATORY
>  	cfg80211_regdomain =3D static_regdom(ieee80211_regdom);
> =20

--=-QDicfffc+Y3AoXkGg2PR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYtEAAoJEKVg1VMiehFYcX0QAJzEMbR9zkfr1M7JrgPY7jVo
s4GFpWCKvadfVu/34vVcpcRdRTACxDvCjam8M1XHNKJG4yIKjFQ6+JhEaix81kYf
2MR5SddPZ05kolrQZhq7SSAOFYrWrybnZkW+Jd5y3vknRWKKQLlaZVrBrAuJQHR3
qtrCDvv7puB1u76Ud/kXM/jdbHFBTf2CH9KYryWEpzLLxVGrOSOefrlF/3gQeWIW
4pBSE6syJ9gmPDFPfn6JxN/xocmboUEAVztSL9teSW0bzEfmZPIvWXebqe+8P5Wz
wzjBCX7z2FR7v9SrESqnl85cZRk6pNsrejebXb77ONw9ln5xGu9Z1UmscPLA3avE
XGZ8KTXmK4fDOuzQOvFE11LdcyA03m6eM/SlPyv1rRTSf4tA47pEa8AphOCJytbE
QJ5soeQFOEM54AKguvkaxT7EFhR8ekMiREyAlSScfFngL5b4r3GKLg5YzgYldkWa
qmxyf0vklRqV4TXoBi+NiIbWVQdjfciGYizE+tQTOh6LTomh+F2fvpQKLb1OOtFB
MXjAgBXrgMWC993CHNXgxZRQH7S42mpT/ZbnwhN7EQIcZWcp+NS55aLLJ/gN3xPM
SvRYbkKkBU9qBC9OjwwhHWcYtJp7ZdyU26m0GxrKn7IlX9kWP/XXBo67SIbj6Uxj
gYoQ2wbgTs6AZmfiVClh
=CdPI
-----END PGP SIGNATURE-----

--=-QDicfffc+Y3AoXkGg2PR--


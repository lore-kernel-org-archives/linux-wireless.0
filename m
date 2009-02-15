Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZBOLBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 06:01:21 -0500
Subject: Re: [PATCH 06/10] cfg80211: propagate -ENOMEM during
	regulatory_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
In-Reply-To: <1234589627-16977-7-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-7-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ilBcYEF1ScDpCCsY0YSS"
Date: Sun, 15 Feb 2009 12:01:14 +0100
Message-Id: <1234695674.4219.50.camel@johannes.local> (sfid-20090215_120125_650763_86A7342A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ilBcYEF1ScDpCCsY0YSS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
> Calling kobject_uevent_env() can fail mainly due to out of
> memory conditions. We do not want to continue during such
> conditions so propagate that as well instead of letting
> cfg80211 load as if everything is peachy.
>=20
> Additionally lets clarify that when CRDA is not called during
> cfg80211's initialization _and_ if the error is not an -ENOMEM
> its because kobject_uevent_env() failed to call CRDA, not because
> CRDA failed. For those who want to find out why we also let you
> do so by enabling the kernel config CONFIG_CFG80211_REG_DEBUG --
> you'll get an actual stack trace.
>=20
> So for now we'll treat non -ENOMEM kobject_uevent_env() failures as
> non fatal during cfg80211's initialization.

I disagree with this patch -- there's so much that can go wrong even if
allocating the message here is ok that imho it's hardly useful to check
for errors here. crda could fail, not be installed, etc.

johannes

> CC: Greg KH <greg@kroah.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |   20 +++++++++++++++-----
>  1 files changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 679fded..47d5056 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1616,7 +1616,7 @@ void reg_device_remove(struct wiphy *wiphy)
> =20
>  int regulatory_init(void)
>  {
> -	int err;
> +	int err =3D 0;
> =20
>  	reg_pdev =3D platform_device_register_simple("regulatory", 0, NULL, 0);
>  	if (IS_ERR(reg_pdev))
> @@ -1637,14 +1637,24 @@ int regulatory_init(void)
>  	cfg80211_regdomain =3D cfg80211_world_regdom;
> =20
>  	err =3D regulatory_hint_core("00");
> +#endif
>  	if (err) {
>  		if (err =3D=3D -ENOMEM)
>  			return err;
> -		printk(KERN_ERR "cfg80211: calling CRDA failed - "
> -		       "unable to update world regulatory domain, "
> -		       "using static definition\n");
> -	}
> +		/*
> +		 * N.B. kobject_uevent_env() can fail mainly for when we're out
> +		 * memory which is handled and propagated appropriately above
> +		 * but it can also fail during a netlink_broadcast() or during
> +		 * early boot for call_usermodehelper(). For now treat these
> +		 * errors as non-fatal.
> +		 */
> +		printk(KERN_ERR "cfg80211: kobject_uevent_env() was unable "
> +			"to call CRDA during init");
> +#ifdef CONFIG_CFG80211_REG_DEBUG
> +		/* We want to find out exactly why when debugging */
> +		WARN_ON(err);
>  #endif
> +	}
> =20
>  	return 0;
>  }

--=-ilBcYEF1ScDpCCsY0YSS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJl/X3AAoJEKVg1VMiehFYEosQAKX7jI8iE349jNHoDIb52YEM
Plk8hEzssG7EVoaSex5tI21wGJNBOmKibF/auZQy2+A4yrmT0fkUlVKEDwfYq2ol
oH14QzoMD+YJn8dgrjtG18a9QDvAo/kfL0V1yJEH60eAxrFyEBR/2g7GwAH4WEfh
38QaGlmAtXgE+Jf83Rdg6yyn3P32BPJ4aEEjy6SLyukTldcEq1SR6KeyymAmE7Yp
ElQYpterpNfwfxNRPY6GrlWxHMC58JvoDbeN+eVmkQKkKslCG/YIEpjvyRAnJWM9
lzBZwC6ACCtyw8gEj6aJlCwbeDi+FgePSjDONWq04BH/JvYBp/OOT4nF8xav9UiL
M/RcgH4s+F97H7OkzBTJa/sQugnaMxyAy1Evy3bHESLBklJSdRgYnVjLPFNfPYC0
ad+gcaEQ4asx+X0lFF9sZ+Lg1qrTa8cp+glV7IEUQsPCAdM/HqJFnN4FGR0xGFi+
b7gEFYadcWjWkwawA/PdDkH2LMpPm0EZEptpKfbnTfA9oHwoiHvlXkjioHb5tb9m
I9oh5dr1ilreGe22f2dRX+kEpOGPNQwnL3J/6SFm44IMYD0O/3FrEkWYACBYmDZD
QrhMlCH2vnTQh6VxeaI5pFrw5SOe6NHBSZpjmc0qfZ0IdhpvELwKLD8WB4FshV+f
LODu6a8b9v3/5nfnyUTD
=YGOF
-----END PGP SIGNATURE-----

--=-ilBcYEF1ScDpCCsY0YSS--


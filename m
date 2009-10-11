Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52529 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZJKTBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 15:01:05 -0400
Message-ID: <4AD22B39.3070006@hauke-m.de>
Date: Sun, 11 Oct 2009 21:00:09 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat-wireless: Fix the bleeding-edge version to build
 on 2.6.27
References: <4ac55601.EpUUwD1vnjBKSXDy%Larry.Finger@lwfinger.net>
In-Reply-To: <4ac55601.EpUUwD1vnjBKSXDy%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFD6B39C730E2887EF0EEAB11"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFD6B39C730E2887EF0EEAB11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Larry Finger wrote:
> When building the bleeding-edge compat-wireless for kernel 2.6.27,
> several compilation errors were detected.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>=20
> Luis,
>=20
> I checked these patches on 2.6.27 and 2.6.31, but not for the intermedi=
ate
> releases.
>=20
> Larry
> ---
>=20
> Index: compat-wireless-2009-09-05/include/net/compat-2.6.28.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- compat-wireless-2009-09-05.orig/include/net/compat-2.6.28.h
> +++ compat-wireless-2009-09-05/include/net/compat-2.6.28.h
> @@ -149,6 +149,7 @@ static inline void skb_queue_splice_tail
>  struct module;
>  struct tracepoint;
> =20
> +#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28))
>  struct tracepoint {
>  	const char *name;		/* Tracepoint name */
>  	int state;			/* State. */
> @@ -159,6 +160,7 @@ struct tracepoint {
>  					 * align these on the structure size.
>  					 * Keep in sync with vmlinux.lds.h.
>  					 */
> +#endif
> =20
>  #ifndef DECLARE_TRACE
> =20
> @@ -179,13 +181,17 @@ struct tracepoint {
>  		return -ENOSYS;						\
>  	}
> =20
> +#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28))
>  #define DEFINE_TRACE(name)
> +#endif
>  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
>  #define EXPORT_TRACEPOINT_SYMBOL(name)
> =20
> +#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28))
>  static inline void tracepoint_update_probe_range(struct tracepoint *be=
gin,
>  	struct tracepoint *end)
>  { }
> +#endif
> =20
>  #endif
> =20

LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28) can not be true in
compat-2.6.28.h. The definitions are not needed in compat-wireless any
more. Removing this does not break compiling with mainline kernel 2.6.25
to 2.6.32

> Index: compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- compat-wireless-2009-09-05.orig/net/wireless/compat-2.6.28.c
> +++ compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c
> @@ -260,6 +260,7 @@ static unsigned long round_jiffies_commo
>  	return j;
>  }
> =20
> +#if 0
>  /**
>   * round_jiffies_up - function to round jiffies up to a full second
>   * @j: the time in (absolute) jiffies that should be rounded
> @@ -274,5 +275,6 @@ unsigned long round_jiffies_up(unsigned
>  	return round_jiffies_common(j, raw_smp_processor_id(), true);
>  }
>  EXPORT_SYMBOL_GPL(round_jiffies_up);
> +#endif
> =20
>  #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */

The mainline kernel 2.6.27 does not contain round_jiffies_up. Are you
using Suse? Suse adds some extra extensions into the kernel, we need an
other way to deactivate the round_jiffies_up export. With this patch
this symbol is missing while compiling against mainline kernel <=3D
2.6.27. An other user reported a problem with the Suse kernel in:
http://marc.info/?l=3Dlinux-wireless&m=3D125393384728475

> Index: compat-wireless-2009-09-05/net/wireless/scan.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- compat-wireless-2009-09-05.orig/net/wireless/scan.c
> +++ compat-wireless-2009-09-05/net/wireless/scan.c
> @@ -499,8 +499,10 @@ cfg80211_inform_bss(struct wiphy *wiphy,
> =20
>  	kref_init(&res->ref);
> =20
> +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
>  	/* cfg80211_bss_update() eats up res - we ensure we free it there */
>  	kmemleak_ignore(res);
> +#endif
> =20
>  	res =3D cfg80211_bss_update(wiphy_to_dev(wiphy), res, 0);
>  	if (!res)

Hauke


--------------enigFD6B39C730E2887EF0EEAB11
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJK0itAAAoJEIZ0px9YPRMyj4MP/0nB8VSg/TIRLV0bSzNIOARR
DOSQuHwC7TgTJgHI9QCGpWnpvizyUe+PFSaGzaT9UpbEOu4y0aVp1AM64GUQ/9u2
u3jW5gWT0WFP/mz7nJpVbQNYBMEkLQLn5BhnGo/5bhwbzEEXgia1vy06aVHwqmO/
PQoUHrV2V7gmCj/gKsRvJDEvi+7DUuxICxhl/1G63jJpkba/Ucd+4YHERLpLP+9p
6wAywfqaa4Wq+H8/VXYTDRE4mnPikVUR3HRDa6//bb/4fcHGqxd7jA/lwPPTnK4B
1KXky0SGCcFykqBTk1PNXpmLxrGNnIIZpqgUsCsruoJkPrLWgTZceBHnZu/TG/DZ
IVeA3uT4DeApwwkmPmUGyGyNh8iMmUELWPsYw5Afs1XQL1nZklIQBPCjcuCL1ZaX
+zSzwOcO+rXSOZBvOu8x6jQrqxKKFyCKOp5y9OwxMZefNSyunynLluw1D+H6uaX8
U/+K+sT7pm5qwVTDiayTBuF9a5d1+aEwz+5GZjal/Z9Q/7IOl9ZeNRlfxE9arPUt
1NF1WwC2QAhprgelKu3E6Zntd5PbkzuEopWxye274bVjnsHLvsR62dfMbstm0AL/
BNh6cmw+q9zk67ottBh/Gy3n083QVpMq/xs4pbvctA1r3ANXgt21yuzbqsWo9C40
UoRFmHUuWeYIx29rK0N0
=+h7p
-----END PGP SIGNATURE-----

--------------enigFD6B39C730E2887EF0EEAB11--

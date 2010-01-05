Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0AEJsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:48:36 -0500
Subject: Re: [RFC PATCH v5 2/7] mac80211: add debugfs interface for U-APSD
 queue configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, a.young.jason@gmail.com
In-Reply-To: <20091231133720.29899.75214.stgit@tikku>
References: <20091231133626.29899.95683.stgit@tikku>
	 <20091231133720.29899.75214.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iPo8pipQ8ZOci9oNooMQ"
Date: Tue, 05 Jan 2010 10:48:22 +0100
Message-ID: <1262684902.21956.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iPo8pipQ8ZOci9oNooMQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-31 at 15:37 +0200, Kalle Valo wrote:

> +static ssize_t uapsd_max_sp_len_read(struct file *file, char __user
> *user_buf,
> +				     size_t count, loff_t *ppos)
> +{
> +	struct ieee80211_local *local =3D file->private_data;
> +	int res;
> +	char buf[10];
> +
> +	res =3D scnprintf(buf, sizeof(buf), "0x%x\n",
> local->uapsd_max_sp_len);
> +
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
> +}
> +
> +static ssize_t uapsd_max_sp_len_write(struct file *file,
> +				      const char __user *user_buf,
> +				      size_t count, loff_t *ppos)
> +{
> +	struct ieee80211_local *local =3D file->private_data;
> +	unsigned long val;
> +	char buf[10];
> +	size_t len;
> +	int ret;
> +
> +	len =3D min(count, sizeof(buf) - 1);
> +	if (copy_from_user(buf, user_buf, len))
> +		return -EFAULT;
> +	buf[len] =3D '\0';
> +
> +	ret =3D strict_strtoul(buf, 0, &val);
> +
> +	if (ret)
> +		return -EINVAL;
> +
> +	if (val !=3D 0 && (val & IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK) =3D=3D 0=
)
> +		return -ERANGE;
> +
> +	local->uapsd_max_sp_len =3D val;

This seems a bit weird, that means you need to use 0x20, ..., 0x60,
right? I think you should shift it up/down when reading/writing, or
probably even store it shifted in local->uapsd_max_sp_len and then shift
it up by 5 when using that value -- the value itself is only 0..3 after
all, and only stored in a bitmasked field.

johannes

--=-iPo8pipQ8ZOci9oNooMQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwriAAoJEODzc/N7+QmaP/YQAM+vKTwcbtgBQTxAzukvyJTo
S0vuBAcvaka3kBwMrxpztKnjCrHMPptsWLRf0/6+H2X94RYCQc0FNRH3g5JyHeJZ
iWFT4LkPrAf+hKcnwolVRrsOKIQFANtrKauJs2u0nIt/9/g6nnQlI7KxYil1Ad6X
tvDKq6oTwV+qTLAJPj0yaGqbNDnrVpJ4rKfJ3ko82UYazJu816oTOXwbk6NRleDz
KRMZvLr/OLTr22VHLM6QSAWzeG9KiVVE1L7USjjzHy3p5hDYLzCtErJ7wJ4vCcLm
hfDzJK6nHJAr6+dlnObLaYwq4ExBaymjqlhIKRN9zVu+n017A23QZcHvBK+9yVIj
ZHr2MRwPZZdIJz1n+BsJwhJ8o68IODyVKM4dzNsTDCf2xlixLESll2e8GFgJ3taY
nR0jBy9B1Ig7wbn/fddbs4P+Fk3vCzsQE1BxcqbIufUeszfLNDZlBUxhyXitPUzB
Hg6Avij/Cx6q2hUieRwB40nLsbQmLqxYEITx+SpbgDhmBujTp39MJZ8DMrtzyrKQ
6yIUBRW/FA13NbktG8x80d+JhkyCgLcjFHLlx66K4VHwrY3ZlbVZMbhOIxbzZmh2
8iL1Qrd02aFkfgMwZys1LrIwAu30Yuc8NLgsAwEaOESk2sjONpAFdU5P/BVKaScV
gCiNJ7LLT3d5tHmXmSm6
=xf0z
-----END PGP SIGNATURE-----

--=-iPo8pipQ8ZOci9oNooMQ--


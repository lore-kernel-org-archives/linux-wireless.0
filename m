Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZENTNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 15:13:18 -0400
Subject: Re: [RFC] Simulate medium behavior
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090514184547.GA3225@newton.monom.org>
References: <20090422092159.GA24586@toronto053.server4you.de>
	 <1240393088.21756.3.camel@johannes.local>
	 <20090422113556.GB24586@toronto053.server4you.de>
	 <20090507184007.GA6684@newton.monom.org>
	 <1241722972.7590.34.camel@johannes.local>
	 <20090514184547.GA3225@newton.monom.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z/xTPyXPCwhNY9sLoNei"
Date: Thu, 14 May 2009 21:12:49 +0200
Message-Id: <1242328369.5799.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z/xTPyXPCwhNY9sLoNei
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 20:45 +0200, Daniel Wagner wrote:

Looks good to me, couple of comments below.

> +static int hwsim_fops_group_read(void *dat, u64 *val)
> +{
> +	struct mac80211_hwsim_data *data =3D dat;
> +	*val =3D data->group;
> +	return 0;
> +}
> +
> +static int hwsim_fops_group_write(void *dat, u64 val)
> +{
> +	struct mac80211_hwsim_data *data =3D dat;
> +	data->group =3D val;
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
> +			hwsim_fops_group_read, hwsim_fops_group_write,
> +			"%llu\n");

I think %llx would work better for this? At least I can do bitops better
in hex :)

>  		data->debugfs_ps =3D debugfs_create_file("ps", 0666,
>  						       data->debugfs, data,
>  						       &hwsim_fops_ps);
> +		data->debugfs_group =3D debugfs_create_file("group", 0666,
> +							data->debugfs, data,
> +							&hwsim_fops_group);

Good thing this is a test module only... debugfs files with user access
permissions are a security risk. (a user can open the file and leave the
fd open, if root then rmmods future reads/writes to the fd by the user
crash the kernel)

Anyway looks good, please submit properly with [PATCH] etc :)

johannes

--=-z/xTPyXPCwhNY9sLoNei
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDG0sAAoJEODzc/N7+QmahAcP/2wIcAbRccagXEvfVVQNndVb
iYv1SymmRr3BjLea+txrKRi6cxdhBhMySRMNuXigvJ7ZOXLddcH8nwi6Dur4P5Bp
B55iV2bz7oCN6gAjSXgHkogzWpdNcuzq92VP/ytCDRLm1kRgl11e4AKmFGK9FkrW
x4I9fw0ca6bdD2u7zyCHh+/WI9R11mD5p5rGiBWAlYAf6KtpRzM9ITsWP4Gq9/fS
LbDCjo/wpolpXapirQvJWiZNhaFzqeGk2Z2Vpq5yJcbRqwxCIkTRzH7OHioXWrz2
W411mdiqHz3C7GddkiI2wxzicVtcYFAmRZzGmQ0bZ6uv2ZlvZpgU2M7BKsyC18wN
c/dxACinm6nMklAXlLMEWVoVidjb0PJ4KL0koRMgPe8Gfhdzk621XLkW1Z3FsJIf
4FoxbXHU0dh6kbwa9f84mjBFbtu7RYRDky9mmVj8WHwjEMT6B96SPTzPMLEvBoyk
C7eB/CAmGmRpIwVaJqWBfnWIpGIbtoHEEuz0awIbvj5pNgKKguMlRKjdOSH373YC
zXcA5VCuHVNPauSQBKzH0Bw6XA1eukaqaR1rL6hIk6XUYI1Wpe3xs1sOfbZklEIb
lWCpFUEUDcgvJMskUk+HL3vcYi+NkbAuaTCIARfsohtiqAnwPib87wEMEFKU8zkt
r8kUn1k62jfNr48YLWvB
=fs3O
-----END PGP SIGNATURE-----

--=-z/xTPyXPCwhNY9sLoNei--


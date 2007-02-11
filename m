Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXBKNP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 08:15:56 -0500
Received: from [84.135.252.56] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HGEVF-0007lU-9R
	for linux-wireless@vger.kernel.org; Sun, 11 Feb 2007 13:12:25 +0000
Subject: Re: [PATCH 1/5] cfg80211: update to code submitted to mainline
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20070209162526.489839000@sipsolutions.net>
References: <20070209162414.043158000@sipsolutions.net>
	 <20070209162526.489839000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RQe52Q3pitg1qMgJ8/5C"
Date: Sun, 11 Feb 2007 14:13:29 +0100
Message-Id: <1171199609.5032.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RQe52Q3pitg1qMgJ8/5C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-09 at 17:24 +0100, johannes@sipsolutions.net wrote:


>=20
> +int wext_ioctl(unsigned int cmd, struct ifreq *ifr, void __user *arg)
> +{
> +       int ret =3D -EINVAL;
> +
> +       /* If command is `set a parameter', or `get the encoding paramete=
rs',
> +        * check if the user is allowed to do it */
> +       if (IW_IS_SET(cmd) || cmd =3D=3D SIOCGIWENCODE || cmd =3D=3D SIOC=
GIWENCODEEXT)
> +               if (!capable(CAP_NET_ADMIN))
> +                       return -EPERM;
> +
> +       dev_load(ifr->ifr_name);
> +
> +#ifdef CONFIG_WIRELESS_EXT
> +       rtnl_lock();
> +       /* Follow me in wext-old.c */
> +       ret =3D wireless_process_ioctl(ifr, cmd);
> +       rtnl_unlock();
> +
> +       if (ret =3D=3D 0 && IW_IS_GET(cmd) &&
              ^^^^^^^^^^^^

That's the bug. That test must be removed.

johannes

--=-RQe52Q3pitg1qMgJ8/5C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFzxZ5/ETPhpq3jKURAlQxAJ9LhKPo/5errAOf1aLxAFf2FYBkngCcDe62
KQjVzz1c7oxvcuhvDfXj2YY=
=4Y4x
-----END PGP SIGNATURE-----

--=-RQe52Q3pitg1qMgJ8/5C--


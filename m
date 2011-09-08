Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smp.if.uj.edu.pl ([149.156.82.206]:49476 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1IHXTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 19:19:38 -0400
Date: Thu, 8 Sep 2011 18:57:30 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Michael Witten <mfwitten@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mac80211: fix suspend/resume races with unregister hw
Message-ID: <20110908165730.GD9104@smp.if.uj.edu.pl> (sfid-20110909_011942_653072_F8D32331)
References: <1313150459-13234-1-git-send-email-sgruszka@redhat.com>
 <d9f6472975e34cb294831e32c8ce2346-mfwitten@gmail.com>
 <20110908064410.GA2195@redhat.com>
 <CAMOZ1BvsPok-AZVCwKnv0hWWXyV+np+nARjGRqwqsvC-du_GAw@mail.gmail.com>
 <20110908162605.GD2195@redhat.com>
 <CAMOZ1Bs_DesZoyYw6yzC8CdqR3yLgXXpBzxvsEsQ0eX4L6Vw+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-6859-1315501052-0001-2"
In-Reply-To: <CAMOZ1Bs_DesZoyYw6yzC8CdqR3yLgXXpBzxvsEsQ0eX4L6Vw+A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-6859-1315501052-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09-08 16:41, Michael Witten wrote:
>=20
> Interestingly, though, `lsmod' shows the following:
>=20
>   Module                  Size  Used by
>   ...
>   ipw2200               109206  0
>   ...
>=20
> even when the wireless network is up and running; I would have
> expected the `Used by' column to show that `ipw2200' is being used by
> at least something else; the consequence is that I am able to run
> `rmmod' on `ipw2200' while the wireless network is up and running,
> which seems odd (though it causes no discernible error).

Hi.

I think this was always so. I just checked other system
with vanila 3.0.0 kernel, and it also says "Used by" =3D=3D 0
I do not remember exactly, but I think it was always saying zero.
You can actually always rmmod ipw220, regardles
whetever network interface is used, opened, up, or whetever.
I guess hot plug is important here.

Regards,
Witek

--=20
Witold Baryluk

--=_smp.if.uj.edu.pl-6859-1315501052-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5o8/oACgkQ7ZLFFOttZ4JGYgCeJSAGJrXhprl9AS7LhMGBeGwL
Y6sAn3lcoXHfM/n1IfXRG0KACQUYinLd
=VPwZ
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-6859-1315501052-0001-2--

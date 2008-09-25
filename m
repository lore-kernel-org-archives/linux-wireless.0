Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYIYEuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 00:50:09 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1222317983.10563.20.camel@johannes.berg> (sfid-20080925_064714_797821_C549800C)
References: <>  <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20080925_010455_582253_D66BE03B)  <1222317983.10563.20.camel@johannes.berg>
	 (sfid-20080925_064714_797821_C549800C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sXLl36xhQnr4nb4TWDcp"
Date: Thu, 25 Sep 2008 06:49:17 +0200
Message-Id: <1222318157.10563.22.camel@johannes.berg> (sfid-20080925_065014_111217_733CD989)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sXLl36xhQnr4nb4TWDcp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 06:46 +0200, Johannes Berg wrote:

> > +	essid_len =3D min(essid_len, (u8) IW_ESSID_MAX_SIZE);
> > +	while (essid_len--) {
> > +		if (*s =3D=3D '\0') {
> > +			*d++ =3D '\\';
> > +			*d++ =3D '0';
> > +			s++;
> > +		} else {
> > +			*d++ =3D *s++;
> > +		}
> > +	}
> > +	*d =3D '\0';
> > +	return escaped;
> > +}
> > +EXPORT_SYMBOL(escape_essid);

Also, it seems like this should escape any non-printable characters, not
just NUL?

johannes

--=-sXLl36xhQnr4nb4TWDcp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2xhJAAoJEKVg1VMiehFYrSIP/1O7SjKApTldVXKbfwnXHaOj
DC8jsHWs7p3pPOHyuvITcIh+/TeSsGp7h5Q0kYl2OGMM6MHatUzEkn5Bken7gFuO
wuepZsjPKzqfqFvppuVEFX/ux/eNjFXwm4YnzmMsd25cHoOk0/nuT9VHX0I5cwKO
ODcYta3SGu5CwyHKc6HFm2CYVPvdteCAkROS/q76HzQuCvsPWUaavpRlHRcr50Nv
QS5u1CWynDCoKvW30IiPfoFdU2YCUKkv8EZBUB++v3tzh+e6/i+KgubGs80vCQn7
7WFthGNdaBLPJWk1/dSxxo592bobRMGbfqf0vj8xs59Zrp3ee7WYwJHapqus+3p6
rU1AlRyiqb57DAt1HOn47cHYwJc/CA33RBq+qRwVEopNuUYlAbq8W1M8cYTxDezI
7Ff35Rd2YEvv2yasIF5MkghErS4hvGLnmpa0KyGkmeIXSwse0CB4FnbuL+8gCYLE
LWCqPRHy6ivkEdiHdtYt9hVQsLwzhXr2mRcYhlnHqE07hcIQBLo6C8Iob98wE9Ki
Q4WgGUbxct1IC/ElWnH2pd/aS7WX23Xp+VtUxM3VL8fq72WMWMyDq4mbjTKL9EHe
wGTTQGOJXVBp2lkGeGHzlSLdLSFwCd14UEkbY0oVl0OVGbHTyaPDzTZ/pWHHaRyt
eC1bLjSnpFvRPF9kRkCO
=Qy7k
-----END PGP SIGNATURE-----

--=-sXLl36xhQnr4nb4TWDcp--


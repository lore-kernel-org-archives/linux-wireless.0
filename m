Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:44008 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752355AbXIXTVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:21:52 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd1211 config operation problem
Date: Mon, 24 Sep 2007 15:20:41 -0400
Cc: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200709231648.17107.mb@bu3sch.de> <200709241841.50232.mb@bu3sch.de> <1190654401.18521.272.camel@johannes.berg>
In-Reply-To: <1190654401.18521.272.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5248511.BxdtLLhSiX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709241520.50411.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5248511.BxdtLLhSiX
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 24 September 2007 13:20, Johannes Berg wrote:
> On Mon, 2007-09-24 at 18:41 +0200, Michael Buesch wrote:
> > -	if (local->ops->config)
> > +	if (local->open_count)
> >  		ret =3D local->ops->config(local_to_hw(local), &local->hw.conf);
> Isn't this racy?
>
Shouldn't be. Some callers are holding rtnl (ieee80211_open,=20
ieee80211_ioctl*). Other callers (in ieee80211_sta.c) cannot run if the=20
device is down.

=2DMichael Wu

--nextPart5248511.BxdtLLhSiX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG+A4ST3Oqt9AH4aERAmD6AKC+DXMQpHMAPN2YKe2/t4F2ihkiogCfXT+W
1FZyAboocazu07qQqqOM5K4=
=oQ1O
-----END PGP SIGNATURE-----

--nextPart5248511.BxdtLLhSiX--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

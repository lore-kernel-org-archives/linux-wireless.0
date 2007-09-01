Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:30095 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbXIAAcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 20:32:16 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/6] adm8211: Switch to eeprom_93cx6
Date: Fri, 31 Aug 2007 20:30:14 -0400
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200708310055.37580.flamingice@sourmilk.net> <200708312340.52730.IvDoorn@gmail.com>
In-Reply-To: <200708312340.52730.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16983435.J2nlOLkpmG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708312030.19046.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart16983435.J2nlOLkpmG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 31 August 2007 17:40, Ivo van Doorn wrote:
> > +	ADM8211_CSR_WRITE(SPR, reg);
> > +	ADM8211_CSR_READ(SPR);		// eeprom_delay
> > +}
> Is this extra delay needed? eeprom_93cx6 also performs
> a ndelay(450) during each pulse
>
It's required to ensure the data reaches the card, at the very least. I'm n=
ot=20
sure if the read causes the hardware to do any sort of delay, if that's=20
possible, but the previous eeprom reading code indicated that it did and=20
didn't bother to do any actual delays.

=2DMichael Wu

--nextPart16983435.J2nlOLkpmG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG2LKbT3Oqt9AH4aERAmD5AJ9+WktUl1qZu/i/Ycrkc5vT/fybBwCgnetk
4CE3NNjf75MDjosxNA9uGhA=
=L/yC
-----END PGP SIGNATURE-----

--nextPart16983435.J2nlOLkpmG--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

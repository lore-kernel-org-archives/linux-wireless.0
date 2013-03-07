Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:54486 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab3CGSOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 13:14:12 -0500
Date: Thu, 7 Mar 2013 19:14:05 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de, johannes@sipsolutions.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: Question regarding minstrel(_ht) and retry limits
Message-ID: <20130307181405.GB31210@pandem0nium> (sfid-20130307_191416_729381_882B6102)
References: <20130307153100.GA30608@pandem0nium>
 <20130307154045.GB29428@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
In-Reply-To: <20130307154045.GB29428@magnum.frso.rivierawaves.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2013 at 04:40:45PM +0100, Karl Beldan wrote:
> On Thu, Mar 07, 2013 at 04:31:00PM +0100, Simon Wunderlich wrote:
> > Hello list,
> >=20
> > as you might be aware, it is possible to set short and long retry limits
> > to specify how often a frame should be retransmitted before getting dro=
pped.
> >=20
> > However, it appears that minstrel completely ignores any retry limit, a=
nd it is
> > also not applied later in the code path. I've hacked minstrel_ht a litt=
le bit
> > to apply the retry limits in minstrel_get_rate() before returning the r=
ates
> > (i.e. just cutting retries at the end from the struct ieee80211_tx_rate=
 array).
> >=20
> > This worked for me, but is probably not clean either and might disturb =
minstrel
> > operation. Also minstrel uses much more retries than default retry limi=
ts
> > (short: 7, long: 4), so this patch might introduce behaviour changes.
> >=20
> > What is your opinion on this? Can we get it properly supported? Does it=
 hurt
> > to just use the first $retry_limit retries, and cut the rest at other r=
ates
> > at the end?
> >=20
> BTW, it also ignores max_rate_tries < 3 and rts thresholds.

Yup, regarding RTS we had a long discussion some time ago:

 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/84459

regarding max_rate_tries, I guess this comes from the hardware? Does it hurt
to ignore it (as drivers will cut it anyway)?

Cheers,
	Simon

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlE42O0ACgkQrzg/fFk7axaTrQCg36d4Gr3mRXmwats/4p8smZSt
5KYAn3U/jPexIyoZIYX7Gs71wnUWEMUt
=D6MA
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--

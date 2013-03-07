Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:53381 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3CGSGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 13:06:43 -0500
Date: Thu, 7 Mar 2013 19:06:35 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de,
	johannes@sipsolutions.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: Question regarding minstrel(_ht) and retry limits
Message-ID: <20130307180635.GA31210@pandem0nium> (sfid-20130307_190647_928136_9E22F729)
References: <20130307153100.GA30608@pandem0nium>
 <5138B69C.4000102@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
In-Reply-To: <5138B69C.4000102@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Felix,

On Thu, Mar 07, 2013 at 04:47:40PM +0100, Felix Fietkau wrote:
> On 2013-03-07 4:31 PM, Simon Wunderlich wrote:
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
> I think simply cutting off from the end of the retry chain is a bad idea
> - if there are too many scheduled retries in the max throughput rate, it
> will not make it to the fallback to a reliable rate if that fails. A
> better approach is to make minstrel use fewer retries per rate.
>=20
> - Felix
>=20

Are there any theoritical constraints to consider? I don't know too much
about minstrel theory, but from what I understand:

The ieee80211_tx_rate array has 4 entries with rate + count number, where
the last entries may be empty (count =3D 0).

Would you suggest to decrease the count numbers of each array entry uniform=
ly
to meet the limit requirement? From what I've seen, minstrel assigns more t=
han
7 tries in total quite often - will it be problematic if we decrease the co=
unt
number uniformally? And finally, is there any more elegant way than adjusti=
ng
to the limits just before returning and after minstrel made all its choices?
This is how I've implemented the cutting as described above, but it appears
that there are some limits in minstrel too ... not sure if they can be used
to enforce the total count limit though. :)

Thanks,
	Simon

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlE41ysACgkQrzg/fFk7axYhJwCfWYnw//0d/ap9JBsewHYJCiUY
dyYAoJXxyBrRwoKk4e9zbAIOqk8U1Nmf
=5lyX
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--

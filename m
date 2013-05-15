Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:53384 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab3EOUYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 16:24:42 -0400
Date: Wed, 15 May 2013 22:24:35 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv2 00/18] Add support for 5 and 10 MHz channels
Message-ID: <20130515202435.GB23922@pandem0nium> (sfid-20130515_222445_989046_6A5C2E26)
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2013 at 04:18:51PM +0200, Simon Wunderlich wrote:
> This patchset adds support for 5 and 10 MHz in nl80211/cfg80211/mac80211
> and enables support in ath5k and ath9k, which already support this feature
> on the driver side. 5 and 10 MHz wide channels might be useful for:
>=20
>  * long shot links, as the transmissions are more robust
>  * future support for 802.11y which allows some 5 and 10 MHz channels in
>    3.6 GHz range
>  * future support for 802.11p which uses 10 MHz in 5.9 GHz range
>  * ... and more "special" applications.
>=20
> This patchset enables 5 and 10 MHz channels only for OFDM, and without
> HT/MIMO/aggregation (for now). Support may be added later.
>=20
> Changes to PATCHv1:
>  * the actual datarates are handled, not the corresponding 20MHz rates
>    as before. This should make it compatible to freebsd, although I was
>    informed that some other implementors might still use the corresponding
>    20MHz rates. Anyway, from looking at the standard using the actual rat=
es
>    should be the right thing to do.

Johannes and me agreed that these bitrates tables are rather ugly, and I'll
rework the patchset to use rate flags instead of these bitrate_half/bitrate=
_quarter
tables as introduced in this patchset. This will not neccesarily make the m=
ac80211
changes smaller but should avoid this bloat and make the driver implementat=
ions
nicer too. I'll post PATCHv3 soon.

Cheers,
	Simon

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGT7wIACgkQrzg/fFk7axYhowCdHGu0MzO4fG1/eg04pJVsbjUo
XggAoNbdLDwww3VM+SyAaOu/f55HrtRP
=yyuT
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41565 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab2LMOIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:02 -0500
Date: Thu, 13 Dec 2012 15:07:53 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, nbd@openwrt.org, jonbither@gmail.com,
	jouni@qca.qualcomm.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121213140753.GA26868@pandem0nium> (sfid-20121213_154331_521846_653BED14)
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey there,

just to bump the issue again - isn't there anyone here who can answer
some of these questions?

Adrian gave me some hints, but the FFT format is still completely unclear
- I would really like to integrate/fix things before bringing this patch(se=
t)
to the next level.

I'm begging all the Qualcomm/Atheros-affiliated guys on the list to have
a look on the questions below and help me out here. :)

Thanks a lot!
	Simon

On Thu, Dec 06, 2012 at 05:36:07PM +0100, Simon Wunderlich wrote:
> This patch(set) is the second iteration of the request for comments for
> upcoming spectral scan feature. It adds spectral scan control and dump
> features to debugfs. When the open questions regarding interpretation
> are answered, I would like to build an interface to nl80211/mac80211.
> Please see the open questions below, every hint is kindly appreciated. :)
>=20
> This feature has been enabled for AR92xx and AR93xx based chipsets.
> We've also written a visual evaluation program for these samples (see
> screenshot [1] and sourcecode [2]).
>=20
> Many details are not known due to the fact that I don't have access to
> Atheros specifications and details. Many things are done by guessing
> and might be wrong. I'm therefore requesting help from Qualcomm/Atheros
> guys to confirm or correct my findings. Apart from that, after
> discussion I think we could integrate this patchset to allow other
> people to work on this as well, even if it is experimental now.
>=20
> Questions from my end:
>  1. There are many TODOs/Comments in the patches regarding details,
>     please answer if you can. :)

See code comments, e.g. regarding phy error type which are not defined
in the headers, etc.

>  2. The output format is very Atheros-dependent. If my finding that=20
>     byte n-4 is some kind of offset/exponent, I'd integrate this in
>     the debugfs output as well

still unclear.

>  3. The data length varies pretty much, there might be some false
>     positives/PHY errors which are not FFT data - what should be
>     the correct length?

still unclear.

>  4. Is there any special handling for HT40? At least the proprietary
>     driver symbol names suggest so [3]

-> this one is solved: yes, there is. it has more FFT bins. Although
I didn't see that yet (I doubt they are the "small" variations I have seen,
like up to 4 byte, I'd expect like double frame size).

>=20
> (Possible) further work:
>  1. Integrate this patchset, confirm/correct findings
>  2. If anyone would like: Atheros proprietary driver seems to
>     support some kind of classification [3] (is this microwave? cordless
>     phone? whatever?)
>  3. If other devices also offer spectral scan support: define a
>     common interface to use it (not debugfs).
>=20
> Changes to RFCv1:
>  * remove nl80211/mac80211 stuff for now, to build a proper interface
>    after intepretation/output stabilized
>  * split spectral scan call into config, trigger and wait call, which can
>    be called as desired (or depending on the mode)
>  * use relay(fs) to stream spectral scan results (thanks for the hint Fel=
ix),
>    this seems to be much cleaner - as long as we stay in debugfs
>=20
> [1] http://packetmixer.de/sdl_spec_scan2.png
> [2] https://github.com/simonwunderlich/FFT_eval
> [3] http://www.wehavemorefun.de/fritzbox/Ath_spectral.ko#Symbole
>=20
> Simon Wunderlich (1):
>   ath9k: add spectral scan feature
>=20
>  drivers/net/wireless/ath/ath9k/ar9002_phy.c |   52 ++++++++++
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   52 ++++++++++
>  drivers/net/wireless/ath/ath9k/ath9k.h      |   36 +++++++
>  drivers/net/wireless/ath/ath9k/debug.c      |  148 +++++++++++++++++++++=
++++++
>  drivers/net/wireless/ath/ath9k/debug.h      |    5 +
>  drivers/net/wireless/ath/ath9k/hw.h         |   26 +++++
>  drivers/net/wireless/ath/ath9k/init.c       |    6 ++
>  drivers/net/wireless/ath/ath9k/mac.h        |    7 +-
>  drivers/net/wireless/ath/ath9k/main.c       |   97 ++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/recv.c       |   28 +++++
>  10 files changed, 455 insertions(+), 2 deletions(-)
>=20
> --=20
> 1.7.10.4
>=20
>=20

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDJ4TgACgkQrzg/fFk7axYatgCg10/zGJCdSJLInX/UcgYE62jT
rAAAnRLJpgwRLAt6NisxzHrWwXZs9yjO
=qqOO
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

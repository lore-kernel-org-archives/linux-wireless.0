Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:50907 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab3E1KlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 06:41:12 -0400
Date: Tue, 28 May 2013 12:41:02 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv3 00/18] Add support for 5 and 10 MHz channels
Message-ID: <20130528104102.GA13489@pandem0nium> (sfid-20130528_124130_599990_BCF85662)
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
In-Reply-To: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

just to bump here - this patchset is idling around for quite some time now.
I can integrate Felix suggestions easily if not a maintainer would like to =
do
that. Any further comments/suggestions?

Thanks,
	Simon

On Thu, May 16, 2013 at 01:00:27PM +0200, Simon Wunderlich wrote:
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
> Changes to PATCHv2:
>  * instead of introducing new bitrate tables, use bitrate flags which mark
>    the bitrate with support for 5/10 MHz. All bitrates have then to be
>    calculated manually.
> --> this saves a few changes where we only operate on indexes anyway,
>     but requires some more checking at other parts where it is required
>     to see if the rate is supported in 5/10 MHz. At least it is not
>     that ugly and bloaty, and also saves a lot of code in drivers.
> * various DIV_ROUND_UP()s have been used instead of manual conversions
> --> this was squashed with the "big" bitrate adjustment patch (-1 patch)
> * found a bug in the rate mask matching code, which is fixed (+1 patch)
> * fixed a few bugs I introuced myself. :)
>=20
> As always, any comments are appreciated!
> Cheers,
>         Simon
>=20
> Simon Wunderlich (18):
>   nl80211/cfg80211: add 5 and 10 MHz defines and wiphy flag
>   nl80211: add rate flags for 5/10 Mhz channels
>   mac80211: Fix rate control mask matching call
>   mac80211: fix various components for the new 5 and 10 MHz widths
>   mac80211: fix timing for 5 MHz and 10 MHz channels
>   mac80211: select and adjust bitrates according for channel mode
>   mac80211: add radiotap flag and handling for 5/10 MHz
>   cfg80211/mac80211: use reduced txpower for 5 and 10 MHz
>   mac80211: change IBSS channel state to chandef
>   nl80211: allow 5 and 10 MHz channels for IBSS
>   ath9k: always use SIFS times from OFDM for 5/10 MHz
>   ath9k: use chandef instead of channel_type
>   ath9k: report 5/10 MHz channels
>   ath9k: set 5/10 MHz supported channels and fix bitrate
>   ath9k: announce that ath9k supports 5/10 MHz
>   ath5k: report 5/10 MHz channels
>   ath5k: set 5/10 MHz supported channels and fix duration
>   ath5k: enable support for 5 MHz and 10 MHz channels
>=20
>  drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
>  drivers/net/wireless/ath/ath5k/base.c         |   59 ++++++++--
>  drivers/net/wireless/ath/ath5k/base.h         |    2 +-
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
>  drivers/net/wireless/ath/ath5k/pcu.c          |    2 +
>  drivers/net/wireless/ath/ath5k/qcu.c          |   25 +++-
>  drivers/net/wireless/ath/ath9k/common.c       |   67 +++++++----
>  drivers/net/wireless/ath/ath9k/common.h       |    3 +-
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
>  drivers/net/wireless/ath/ath9k/hw.c           |    5 +-
>  drivers/net/wireless/ath/ath9k/init.c         |   29 +++--
>  drivers/net/wireless/ath/ath9k/main.c         |    8 +-
>  drivers/net/wireless/ath/ath9k/rc.c           |   10 +-
>  drivers/net/wireless/ath/ath9k/recv.c         |   11 ++
>  include/net/cfg80211.h                        |   55 +++++++++
>  include/net/ieee80211_radiotap.h              |    4 +
>  include/net/mac80211.h                        |    5 +-
>  include/uapi/linux/nl80211.h                  |    4 +
>  net/mac80211/cfg.c                            |   36 +++++-
>  net/mac80211/ibss.c                           |  101 +++++++++++-----
>  net/mac80211/ieee80211_i.h                    |   45 ++++++-
>  net/mac80211/iface.c                          |    2 +-
>  net/mac80211/main.c                           |    2 +-
>  net/mac80211/mesh.c                           |    4 +-
>  net/mac80211/mesh_plink.c                     |    8 +-
>  net/mac80211/mlme.c                           |   99 ++++++++++++----
>  net/mac80211/rate.c                           |   60 +++++-----
>  net/mac80211/rc80211_minstrel.c               |   29 ++++-
>  net/mac80211/rc80211_minstrel_ht.c            |   11 +-
>  net/mac80211/rx.c                             |   28 +++--
>  net/mac80211/status.c                         |   17 ++-
>  net/mac80211/tx.c                             |   16 ++-
>  net/mac80211/util.c                           |  157 +++++++++++++++++++=
------
>  net/wireless/chan.c                           |   57 +++++++--
>  net/wireless/nl80211.c                        |   23 +++-
>  35 files changed, 761 insertions(+), 231 deletions(-)
>=20
> --=20
> 1.7.10.4
>=20

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGkib4ACgkQrzg/fFk7axaqigCbBoVGw4XBmhJrvduKcQ/kAAYv
cpQAoOMzNeLwzxH5z8hshPFHBFh6y2d8
=5bpb
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

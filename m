Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:35163 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2IGPrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:47:23 -0400
Date: Fri, 7 Sep 2012 17:47:31 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v3 0/7] nl/cfg/mac80211: add DFS master ability
Message-ID: <20120907154731.GA20961@pandem0nium> (sfid-20120907_174726_352444_1B196338)
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

what is the status of this patchset? There have not been any major change
requests, nor promises to send a revised patchset. On the other hand it
hast not yet been merged into wireless testing.

Can anyone give us a status update? Maybe I'm missing something ... :)

Thanks,
	Simon


On Wed, Aug 08, 2012 at 02:53:36PM +0300, Victor Goldenshtein wrote:
> v3:
> =09
>  Rebased to "wireless-testing".
>=20
>=20
>  nl80211/cfg80211: add radar detection command/event
> 	Added units documentation to "radar_detect_timeout".
> 	Added "cac_type" - which indicates that CAC is started for this channel =
type.
> 	Added NL80211_ATTR_WIPHY_CHANNEL_TYPE.=20
> 	Fixed merge problem.
> 	Removed "!!" in nl80211_start_radar_detection.
> 	Return -EBUSY in start_radar_detection if detection already started for =
this specific channel.
> =09
> =09
>  mac80211: add radar detection command/event
> 	Added tracer to ieee80211_radar_detected().
> 	Changed freq argument in ieee80211_radar_detected() to "struct ieee80211=
_channel *chan"
> 	Reset CAC during interface down.
>=20
>=20
>  nl80211/cfg80211: add ability to enable TX on op-channel
> 	Removed "!!" in nl80211_dfs_en_tx().
> 	Typo fix in the documentation.
> 	Added additional check to validate that we're on NL80211_CHAN_HT20 chann=
el, otherwise return -EPERM.
> =09
> =09
>  nl80211/cfg80211: add ap channel switch command/event
> 	Moved struct ieee80211_ap_ch_switch from mac to cfg + pass it as argumen=
t in ap_channel_switch()
> 	Add "if (ch_type !=3D NL80211_CHAN_NO_HT) return -EOPNOTSUPP"
> 	Changed freq argument in ap_ch_switch_complete_notify() to "struct ieee8=
0211_channel *chan"
>=20
>=20
>  mac80211: add ap channel switch command/event
> 	Renamed ieee80211_ap_ch_switch_complete_notify to ieee80211_ap_ch_switch=
_done.=20
> 	Removed the freq argument in ieee80211_ap_ch_switch_done().
> 	Save the target channel in new "local->next_ap_channel" and update the o=
perational channel in ieee80211_ap_ch_switch_done.
> 	Add tracer to ieee80211_ap_ch_switch_done().
> 	Updated commit log message.
> 	Added sanity checks in ap_channel_switch() + ieee80211_ap_ch_switch_comp=
lete
>=20
>=20
>  mac80211: add DFS support to monitor interface
> 	Removed "!!" in ieee80211_monitor_start_xmit().
>=20
> Victor Goldenshtein (7):
>   nl80211/cfg80211: add radar detection command/event
>   mac80211: add radar detection command/event
>   nl80211/cfg80211: add ability to enable TX on op-channel
>   mac80211: add ability to enable TX on op-channel
>   nl80211/cfg80211: add ap channel switch command
>   mac80211: add ap channel switch command/event
>   mac80211: add DFS support to monitor interface
>=20
>  include/linux/nl80211.h   |   42 +++++++++++
>  include/net/cfg80211.h    |   63 +++++++++++++++++
>  include/net/mac80211.h    |   37 ++++++++++
>  net/mac80211/cfg.c        |   50 +++++++++++++
>  net/mac80211/driver-ops.h |   38 ++++++++++
>  net/mac80211/iface.c      |    7 ++
>  net/mac80211/main.c       |    3 +
>  net/mac80211/mlme.c       |   32 +++++++++
>  net/mac80211/trace.h      |   87 +++++++++++++++++++++++
>  net/mac80211/tx.c         |   13 ++--
>  net/wireless/core.h       |    4 +
>  net/wireless/mlme.c       |   38 ++++++++++
>  net/wireless/nl80211.c    |  171 +++++++++++++++++++++++++++++++++++++++=
++++++
>  net/wireless/nl80211.h    |    6 ++
>  14 files changed, 585 insertions(+), 6 deletions(-)
>=20
> --=20
> 1.7.5.4
>=20
>=20

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBKFxMACgkQrzg/fFk7axaccgCeKXDPhdCS3NJOY4GgkJG4Pslz
32cAoMPpGcJo0bL/bNei9rSrSExoOmb7
=aIpV
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--

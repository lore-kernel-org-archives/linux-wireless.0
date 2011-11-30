Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:57030 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab1K3Lcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 06:32:36 -0500
Date: Wed, 30 Nov 2011 12:32:31 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 0/4] add HT support for IBSS
Message-ID: <20111130113231.GA14184@pandem0nium> (sfid-20111130_123240_924329_C17591C8)
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
In-Reply-To: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey there,

thanks for the comments so far. I'll send the scan request patch again sepa=
rately.

Furthermore, I have to apologize: I've accidently messed up the author flag=
 of
Alex' Patches, therefore as they are, they look like I'm the original author
now (at least for the git attributes and the cover letter). I'm really sorry
about this and will fix it in a v2.

Thanks,
	Simon

On Mon, Nov 28, 2011 at 06:55:12PM +0100, Simon Wunderlich wrote:
> This patch set adds support for HT datarates in IBSS. It is based on Alex=
ander
> Simons previous work. The changes can be found in the individual patch me=
ssages.
>=20
> The first patch fixes probe requests sending no rates supported (at least
> wireshark does not find this funny). The second patch adds support for nl=
80211.
> Feature checking is implicitly performed through rdev_freq_to_chan(), whi=
ch
> denies the configuration if HT support is not available. The third patch =
adds
> the mac80211 ibss support. Finally, further IEEE 802.11 standard compatib=
ility
> questions are adressed in the fourth patch.
>=20
> The HT configuration set through nl80211 is not adopted from other STAs a=
s the
> standard (10.3.2.2.2/11.14.2) suggests - after several discussion with ot=
her
> developers, we agreed that this may lead to unpredictable behaviour. We p=
refer
> to keep the local configuration and adapt the HT parameters for transmiss=
ion
> to other STAs individually.=20
>=20
> For further standard compatibility (see fourth patch):
>  * 9.13.3.1: IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED is set and may
>    be used, so far only a few drivers consider it (iwl*, rt2x00, wl12xx,
>    brcm80211, mwl8k)
>  * 9.13.3.1: IEEE80211_HT_PARAM_RIFS_MODE is set and may be used, so far
>    no driver seems to consider it.
>  * 11.5.1.1: BA is only allowed when we previously received a probe respo=
nse
>    or beacon with HT information. Therefore, this is partially implemented
>    - we don't implement a probe request. However, this should serve the s=
ame
>    purpose IMHO and and avoids sending the ADDBA requests to legacy stati=
ons.
>=20
> I have tested this feature in an IBSS of two ath9k and one ath5k device. =
The
> devices join the cell succesfully and the ath9k use HT40 if the configura=
tion
> matches (I've measured 70 Mbit/s) or HT20 (~40 Mbit/s) if it does not.=20
> Also the (legacy) communication to ath5k works.
>=20
> There is an iw patch as well to make use of this feature.
>=20
> It should apply well on the latest wireless-testing kernel.
>=20
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
>=20
> Simon Wunderlich (4):
>   mac80211: fill rate filter for internal scan requests
>   nl80211: Parse channel type attribute in an ibss join request
>   mac80211: Add HT operation modes for IBSS
>   mac80211: handle protection mode, RIFS and ADDBA for HT IBSS
>=20
>  include/net/cfg80211.h     |   11 +++++
>  net/mac80211/agg-rx.c      |    2 +
>  net/mac80211/agg-tx.c      |   26 +++++++++++-
>  net/mac80211/ht.c          |    2 +
>  net/mac80211/ibss.c        |  101 ++++++++++++++++++++++++++++++++++++++=
++----
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/main.c        |    6 +++
>  net/mac80211/rx.c          |    3 +-
>  net/mac80211/util.c        |    3 +
>  net/wireless/chan.c        |   12 +++--
>  net/wireless/nl80211.c     |   27 +++++++++++-
>  11 files changed, 176 insertions(+), 18 deletions(-)
>=20
> --=20
> 1.7.7.3
>=20
>=20

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7WFE8ACgkQrzg/fFk7axbqZwCgk8g0g+0Jo4Idit/B4QzPw+9i
3bgAoOly+GKmsx8o5IvwH9vBtouzHRwp
=qv4c
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

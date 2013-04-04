Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:36767 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764374Ab3DDSW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 14:22:29 -0400
Date: Thu, 4 Apr 2013 20:22:19 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
Message-ID: <20130404182219.GA24704@pandem0nium> (sfid-20130404_202233_898049_86C7B214)
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1364993200.8351.35.camel@jlt4.sipsolutions.net>
 <515D8259.1030208@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
In-Reply-To: <515D8259.1030208@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 04, 2013 at 03:38:33PM +0200, Zefir Kurtisi wrote:
> On 04/03/2013 02:46 PM, Johannes Berg wrote:
> > On Tue, 2013-04-02 at 18:39 +0200, Simon Wunderlich wrote:
> >> local->hw.conf maybe not be synced when recalcing whether radar is
> >> enabled, sometimes leaving radar enabled even if it's not neccesary
> >> anymore.
> >=20
> > I don't really see how, can you explain more?

As far as I see, the problem happens when changing from a DFS to a non-DFS
channel. local->hw.conf.radar_enabled is true from the last (DFS) channel,
but the channel gets released when stopping the AP, and the channel context
is freed. Then when changing to the new channel, what happens is:

1. ieee80211_vif_use_channel() creates a new channel context. This channel
contxt has chanctx->conf.radar_enabled =3D false by default.

2. ieee80211_recalc_radar_chanctx() is called, and finds that no radar is
currently enabled =3D> local radar_enabled =3D false

3. ieee80211_recalc_radar_chanctx() checks if=20
chanctx->conf.radar_enabled =3D=3D radar_enabled and both are false, and
returns
 =3D> but local->hw.conf.radar_enabled would be changed later in this funct=
ion
    and is therefore not updated.

Therefore I'm removing the check to always update the hw.conf.radar_enabled
field, to be safe in any case.

> >=20
> > johannes
> >=20
>=20
> You seem to be right, the patch does not resolve the observed problem.
>=20
> I am not deep enough in the DFS master code and its integration to resolv=
e it
> myself. What I see is that ath9k_config() is called with a non-DFS channe=
l but
> with ieee80211_hw->conf.radar_enabled set. For ath9k that's no problem at=
 all
> (radar pulse detection can be enabled on any channel), but indicates a pr=
oblem in
> the channel context handling for DFS.
>=20
> To reproduce, start an AP on a DFS channel, wait until CAC is finished an=
d fire a
> radar. hostapd will switch to a non-DFS channel with the radar_enabled fl=
ag set.

So the patch does not resolve the problem for you? I've checked it again wi=
th
a little printk in ath9ks config function.

With the patch the radar_enabled flag gets disabled when changing the chann=
el (5500 -> 5200).
If I don't apply the patch, it stays enabled. I did the same thing (start h=
ostapd on
channel 5500, wait for CAC, echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k=
/simulate_radar).

Maybe I'm missing something?

Cheers,
	Simon



--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlFdxNsACgkQrzg/fFk7axYihACePihpZxQPDg/moF0vbFuc69HW
/2sAn2FqfBoMhIVjW/kii7/y5c0dMgnN
=xKnU
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--

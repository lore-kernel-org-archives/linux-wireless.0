Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33617 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3ABPGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 10:06:06 -0500
Date: Wed, 2 Jan 2013 16:05:55 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 6/8] nl80211/cfg80211: add ap channel switch command
Message-ID: <20130102150555.GC7794@pandem0nium> (sfid-20130102_160614_036539_FD080FB0)
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1355407113-27006-7-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357134319.9839.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
In-Reply-To: <1357134319.9839.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 02:45:19PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
> > From: Victor Goldenshtein <victorg@ti.com>
> >=20
> > Add NL80211_CMD_AP_CH_SWITCH command which
> > triggers an AP channel switch process.
> >=20
> > Usermode notified about channel switch complete
> > event with NL80211_CMD_CH_SWITCH_NOTIFY.
> >=20
> > Usermode (hostapd) is responsible to update the
> > channel switch announcement IE in the beacon
> > prior and after the channel switch operation.
>=20
> So ... hostapd is also responsible for counting down the "count"? This
> didn't seem to be the case last I asked?

No, the idea is that hostapd just provides the CSA IE. Decrementing
the TBTT before each beacon should be performed by the low level driver,
as it's the only one which can do that (IMHO). Userspace can't do that.

There is no difference here to Victors proposal.

>=20
> Then why is it responsible for creating the CSA IE? Should that be in
> the kernel maybe? Or the IE be given to this command?

Right now, hostapd creates the whole beacon, so we consider it responsible
for doing changes. Or is there any common implemented infrastructure in the
kernel right now to modify the beacon? As far as I know, Mesh and IBSS crea=
te=20
new beacons on their own (but do not modify them), and APs beacon is suppli=
ed by
userspace.

>=20
> And then maybe the post-switch beacon IEs should be given to the command
> as well, to avoid races as well as making it easier to manage this with
> smarter firmware (say full-MAC drivers)?

That's not a bad idea actually ...

>=20
> Also, we already have an event to notify of an AP channel change, maybe
> that should be used? If not, why not?

The NL80211_CMD_CH_SWITCH_NOTIFY event is already present and not introduced
with this patch, but reused for AP. Which other event do you mean for this
purpose?

Thanks,
	Simon

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDkTNMACgkQrzg/fFk7axZW0ACg5YrgIFn8Ye2ftFe8TvEoBEG7
rzcAniK4/DZ1bXq3/HKZl2zwHXIaACfG
=Y7Jj
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--

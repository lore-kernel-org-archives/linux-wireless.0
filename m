Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:60705 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3ACHhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:37:01 -0500
Date: Thu, 3 Jan 2013 08:36:54 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 4/8] mac80211: add radar detection command/event
Message-ID: <20130103073654.GB20780@pandem0nium> (sfid-20130103_083704_545651_70050046)
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1355407113-27006-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357134029.9839.28.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
In-Reply-To: <1357134029.9839.28.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 02:40:29PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
>=20
> > +	int (*start_radar_detection)(struct ieee80211_hw *hw,
> > +				     struct ieee80211_vif *vif,
> > +				     struct ieee80211_channel *chan);
>=20
> pass a chandef?

Good idea, will change that.

> > +void ieee80211_radar_detected(struct ieee80211_vif *vif,
> > +			      struct ieee80211_channel *chan, gfp_t gfp);
>=20
> Here you probably don't need to pass the channel, once the tracking in
> cfg80211 moves into the sdata (or even local) struct the same can happen
> in mac80211.

Yep, we should change this depending on the result of the discussion whether
we want to change the tracking.

Cheers,
	Simon

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDlNRYACgkQrzg/fFk7axYVogCgxryCbPWAyhCzJu3ZrRWsxsiL
MpAAn1Xk7yB8PaZOVIMdN/UZ7y++9Kng
=xqDZ
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--

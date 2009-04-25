Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZDYHNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 03:13:01 -0400
Subject: Re: [PATCH 0/5] mac80211, iwlwifi, ath9k: Fix rate scaling for
 IEEE80211_TX_CTL_NO_ACK packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Jouni Malinen <j@w1.fi>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <49F1F789.6090307@openwrt.org>
References: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com>
	 <20090423180928.GA22426@jm.kir.nu>  <49F1F789.6090307@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y1gkP5wwTg3XQSR1htkj"
Date: Sat, 25 Apr 2009 09:12:52 +0200
Message-Id: <1240643572.18031.49.camel@johannes.local> (sfid-20090425_091317_319661_2D11A17C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y1gkP5wwTg3XQSR1htkj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 19:31 +0200, Felix Fietkau wrote:

> > While this may be the case with the current rate control
> > implementations, this is not a good assumption to make.
> > Multicast/broadcast frames could (and often really should) be
> > transmitted at higher rate, i.e., the rate control algorithm could
> > figure out that all associated STAs should be able to receive frames at
> > a higher basic rate.
> Good idea. I should implement this in minstrel and use the minimum value
> of max_prob_rate for all stations as multicast rate ;)
>=20
> Johannes: Can you think of a good way to fit this into the API?

Not really... We haven't exported station iterators (for a vif) yet,
which you would need (though I would recalculate only when a station is
removed, when adding you can use min(current,new))

johannes

--=-Y1gkP5wwTg3XQSR1htkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8rfwAAoJEKVg1VMiehFYamYP/j9aVNFQVOcTsb9quBLwOAJY
kfyW0jJMoElMOI0drq3Unq0cqXhkWg2GTW7zciBxDEIWBnuKFgFiImvAZglrTQuS
nXa2/YjWztvhN6wNDX2Vx0ePHseP+8pgxCKmJj6rsXDtP6NX0gZHeZboscSX6WxT
ub88DogB7b4VTF2Q0WPtwGMfkuGBo897vBly5NdGn+E9lorh6tU+sfLiF573NGhU
H17c8NZz8yRfysGYR3n9+Pzn4t2BHYV20VxNyDkMXO5KYZwx9qJfgoUiaHwBMZco
IaTTk+CQs5QR8DB2ybYWN6PIjYuc3Bixt8vD0HQ08r9jVvMuz8JbZlBCHrsIJhPd
3r3PUp6+hddnQ2nbvpDOvU+Oc3yprR4UcrYGrSw3A3PL9Q/dSqduGl/fZhlrShU6
D0enbnTF/g6wytuZoQnStu4/Lmr9rGHOr5/z/TUX+Ik6mXShmFN7cgGZCzdfY05U
sOQ/aNTS+txIWMPEKaOmXfqoVtaVDBS1eMqeRWMCfO83Dw2STa46wAi8gADbLT1+
yGFaRIszzTALWkkxhec+BkrD2iPRc+hwyAVilOkq3he/OpzMVQG5ZjqDP1i9V3Rc
+TZDvOJgSQgaMUd8UaF+xRMKhIxM3l/kVlgIjMCP1Uunr4VKBP+NvA9ou8OnbiJ7
N/BMN4dkcm8KWCeVKqkx
=FtYe
-----END PGP SIGNATURE-----

--=-Y1gkP5wwTg3XQSR1htkj--


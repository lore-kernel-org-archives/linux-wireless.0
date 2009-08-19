Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZHSTh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 15:37:57 -0400
Subject: Re: [RFC 5/5] cfg80211: scan before connect if we don't have the
 bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A8C52BD.5070609@gmail.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
	 <1250640253-18434-6-git-send-email-kilroyd@googlemail.com>
	 <1250668113.16393.25.camel@johannes.local>  <4A8C52BD.5070609@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V0dtG0D3tvhYjXW9BaBS"
Date: Wed, 19 Aug 2009 21:37:28 +0200
Message-Id: <1250710648.8073.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V0dtG0D3tvhYjXW9BaBS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-19 at 20:30 +0100, Dave wrote:

> > Hmm. What if the bssid isn't set? Then the card might select a differen=
t
> > BSS than the one we have on the scan list.
>=20
> That's correct. For the Agere driver that's also true when bssid is set
> - we can't specify which AP the firmware connects to.

Ok. We may want a feature flag for the latter case so we know what's
going on, and reject a BSSID setting.

> >> +		} else {
> >> +			cfg80211_put_bss(bss);
> >=20
> >>  		err =3D rdev->ops->connect(&rdev->wiphy, dev, connect);
> >=20
> > And it's all racy too -- by the time the driver calls connect_result(),
> > the BSS might have expired after it was found here now.
>=20
> Agreed, but with a 15s expiry period I wouldn't expect this to be a
> problem in practice.

Well, the user could scan, take 12 seconds to pick out the AP manually,
enter the paramters in another 2.5 seconds, and then it would already
happen, I think?

> > I don't think this is really feasible to implement in cfg80211.
>=20
> cfg80211 seemed like the appropriate place because it avoids different
> (fullmac) drivers having to re-implement this.

True.

> > Couldn't
> > the driver do a probe to the BSS that the device selected, and report
> > that before the connect result?
>=20
> Yes, that's possible. If we went this way it would make sense to encode
> this in the interface by changing the cfg80211_connect_result prototype t=
o:
>=20
> void cfg80211_connect_result(struct net_device *dev,
>                              const struct bss *bss,
> 			     const u8 *req_ie, size_t req_ie_len,
> 			     const u8 *resp_ie, size_t resp_ie_len,
> 			     u16 status, gfp_t gfp);
>=20
> So on connecting:
>=20
>  * the driver has to call cfg80211_get_bss() to get the bss pointer.
>=20
>  * if it is not available, scan/probe to get the information, call
> cfg80211_inform_bss(), and then use the returned pointer in the
> cfg80211_connect_result call.
>=20
> This means the driver may have to hold onto the IE info to use after the
> scan returns.

Indeed, that would work, although it seems somewhat pointless to pass
around the BSS pointer and require the driver to do the lookup, but it
nicely avoids any races that we have even now.

> Another alternative is for cfg80211_connect_result to trigger the scan
> if it doesn't have the bss, and only complete the connect when the scan
> returns. I think I like the sound of this best.

Good option too, though then it would be useful to pass the channel
pointer if available to scan only on that channel. Of course, if it
still can't be found things are really amiss and we should probably
disconnect and send a failed event to userspace.

johannes

--=-V0dtG0D3tvhYjXW9BaBS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjFR1AAoJEODzc/N7+QmaqfcP/AlnRR7gqXTfVBR/R997vXqJ
jPlIyLmnKTQV0IFCXC4XZL4qSHQl81Mkhzs7VFEIhVanDIkuDPenMSkJJs42qA9H
8doMlC6085uIO5UW1ILMmVuNsZAgCjExV7Ke2LCMlDH00XEbe2S/SI36wPcqsD9o
vURG9k4i0ycQQsuuRmqPYwBhSo5EDUVh6ARm37OTYVOflsTpyPriSwjE5JM1EWvs
MJfvZBJiaVwCgA0p7ok135so3D6CZsDjRr5P2ND0bo39IZH5S10Or8x4l2Jm4ib0
qub/h/FelITjvhzVukgMarTcaNWOC4P06vDxtQzPQcDm/+LasQLKEs8DBFLNik7a
S+nVxoi9Fyg+J1VLOtu/F3WskvPvkTUhoaLKRD+h5E3zEp4zSXCZFNl83rc1e8TT
m44sDw1c0UpN6eqL6KGEL4dphqklZ6Y141CwllMt4AakMNjJLdJIgxzcJHeQgXvH
CxMjMO8+l4CP6Ssfo6fh0TbrqEZg96jjWDnqUM9RFpade0NE9pGN1DprWOZ8SUQY
n90mCr6SGilVoaJRp7s26Qp/TXloHNxv+wqDvghFKdhKpUjEsfdM33bM4QTMgA0Q
G/Gz5z4XrqhP0xXMc0FhswcUBy8OJhJDtTQMdkI01J/kq0bKNHqzbkF354SaORCs
2K+kspb7gs51gL9Vn8CZ
=DhNB
-----END PGP SIGNATURE-----

--=-V0dtG0D3tvhYjXW9BaBS--


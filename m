Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYGCMZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 08:25:05 -0400
Subject: Re: [PATCH stable] b43: Do not return TX_BUSY from op_tx
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200807031031.45955.mb@bu3sch.de> (sfid-20080703_141240_408789_D701059A)
References: <200807030104.30100.mb@bu3sch.de> <87y74jtqz8.fsf@nokia.com>
	 <200807031031.45955.mb@bu3sch.de> (sfid-20080703_141240_408789_D701059A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XBMWd7fHKVY+HMw7IckD"
Date: Thu, 03 Jul 2008 14:24:13 +0200
Message-Id: <1215087853.9975.9.camel@johannes.berg> (sfid-20080703_142510_768586_A60EFF6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XBMWd7fHKVY+HMw7IckD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 10:31 +0200, Michael Buesch wrote:
> On Thursday 03 July 2008 08:35:23 Kalle Valo wrote:
> > Michael Buesch <mb@bu3sch.de> writes:
> >=20
> > > +drop_packet:
> > > +	/* We can not transmit this packet. Drop it. */
> > > +	dev_kfree_skb_any(skb);
> > >  	return NETDEV_TX_OK;
> >=20
> > So no need to call ieee80211_tx_status() in this case? I'm just
> > curious about this, nothing else.
>=20
> I don't think we must call tx_status for dropped or lost packets.

That's a bit of a corner case really. If you call tx-status then the
rate control algorithm will adjust to something that hasn't happened,
and if you don't then the packet won't be on the monitor interface.

In practice, it doesn't really matter because so far this only happens
during resume and that'll hopefully get fixed.

johannes

--=-XBMWd7fHKVY+HMw7IckD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbMTqAAoJEKVg1VMiehFYgbAQAL5Ro+3XCnIj4wSc52LLSps+
N4m2z1qYAgUQ0PId/3ICEULGPt5MW+7NOtzDgoWZYFhj48n8euONPHMbU6DdF3j9
2aa03EL8tdC/TSBUsBO33+WusdOgUk5WUg62kMyTiDflwWi/D+7FZjZa6ZGWGrNP
DGlFFBMGtxfTvk+vp156iTWdWzXrrU0kGoTcHckgWtiLaVnS0eqEZcqbiLqe4oYs
MZ8I80HdF9/iruL8S+/QOLME+OGGrIceFTymH/ZAN6mffXV68H78mfLiqqBtYgQM
+Nbc/FDpGZOaogJ1TpK4T3iwnfFA1UM0mjs75YIqnuBx+N5uTsaXHjP6irzHLyDY
fG04UJfTOFj6nSeDESqz0MKOY5WB0RxOQgDY8NWibPm2SMRZHbIIJ6EZGg/eQoFV
cYDnI9r/AhFMMhwgMZOb/UbEvfT/f4fse1iN0wvKa6tZ9p1R5zKM5uN+XJpRLH7s
TfEGFIDQCz/9n1+TCDritYf5GwNUYA2X5VNtHggzeINArVEosI0vmFOyQVGdAhvM
mxQdb7++cUf08v3WvLgcAzQsV51IE7vpYgRUiuLW1zFnNnjfGkZ4ASrVlBZICkPX
MWQIyxEu2m8m6I1eWN1sWrSRZVrPR2hsQW3vemxb1/yqERfyPXgKD4lvmIxqnsh7
FVAElky+JlTK1BEoChJe
=egG9
-----END PGP SIGNATURE-----

--=-XBMWd7fHKVY+HMw7IckD--


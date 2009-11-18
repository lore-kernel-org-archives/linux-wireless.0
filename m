Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215AbZKRVLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:11:48 -0500
Subject: Re: [RFC] mac80211: move TX status processing to process context
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091118210654.GI6581@tux>
References: <1258571772.30511.54.camel@johannes.local>
	 <20091118195339.GB25188@bombadil.infradead.org>
	 <1258574517.30511.61.camel@johannes.local> <20091118202334.GG6581@tux>
	 <1258576479.30511.65.camel@johannes.local>  <20091118210654.GI6581@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Pt1ybiqFwMmI6U5ImOFn"
Date: Wed, 18 Nov 2009 22:11:22 +0100
Message-ID: <1258578682.30511.82.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pt1ybiqFwMmI6U5ImOFn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 13:06 -0800, Luis R. Rodriguez wrote:

> OK, but can't you still have a driver spam mac80211 with a lot of
> ieee80211_tx_status_irqsafe() calls in soft irq context with the final
> skb requiring the tx complete, in that case the queue *will* get stuffed
> and you could potentially free more if so desired.

But it'll get stuffed one by one, and we free them as we stuff the
queue, so it can't ever loop :)

> Also, if our goal is to just avoid adding the skb if it does not require
> a tx complete and our queue size is too large
>=20
> 	if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) &&
> 	    num + 1 > IEEE80211_TX_STATUS_QUEUE_LIMIT)
> 		dev_kfree_skb_irq(skb);
> 	else
> 		skb_queue_tail(&local->skb_queue)

No, we actually want to drop the older ones in that case.

> > However ... right now we never use _any_ unreliable at all, but I
> > suspect we will want to change that again at some point.
>=20
> Just curious -- what would be a use case for that?

Any time we don't need TX status for rate control it'd be OK to drop
frames that we don't need the status for. For example the hw-rc case my
patch from yesterday introduced.

johannes

--=-Pt1ybiqFwMmI6U5ImOFn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBGL3AAoJEODzc/N7+QmaFW0P/0KdjE6Dn36NeEwvLEGFMKol
HJSe2dtMbOk7XZ0GkvVJDHuBj9aXlVwukROUGPcfeHHZO7fK/3byY8vAJhiw3lLe
a7maDVfFaehiYUAcTjxjpKE0q0UrrjBXfm4WA7E2BE3rdglv9lgyNVffGiMVCy5l
fcO7hLwvOgYYPkv12hkD52ojZQ7l6ng3655Z2fBlZFsFBYkdHmwPbfkP5WBNKTCV
2JbHdoBi7xHAC394dPgmk4ZhAPWHZ4v+xn7QdycvSC411lrpKuWyJdWExdg8Qhex
rN1KZDTK8YKLoG4/8Kx0SFhbu8NNxmosmg6+he/3yk+aM1DW6ST90gL/B5ZRMTea
vAzuUaGpYRjWEC1WjHVcpXC3PIteZgOj5C7jHMziw7SdcFNwZ/Zu8n8lJytpp9/Z
rfBOLiNGXqReTH9G/AbVbGW5WyUy0/5xIwut0dxGI0XfavF11kgFshN/Shff6UUC
U6GxUpUagZwzlWUPyNvlYNLh3GnmDueaRYexEy4nZSVxlR1x6nYswyO2R9ztqQJw
rlFO4mR+4198RaFz9eGtDsc3QZVvDTvRUxEQ/3kcX9YylH8l1mIGbZZyYooqesbB
A7+W2rvqanPk+lCrxFELkBhyLMZtVk9tcXhd4WxyEQU7JsZhQLaEW8kO3kS++lrb
XfNGEVElhNroob7jHNF5
=WkvX
-----END PGP SIGNATURE-----

--=-Pt1ybiqFwMmI6U5ImOFn--


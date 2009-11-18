Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbZKRVOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:14:03 -0500
Subject: Re: [RFC] mac80211: move TX status processing to process context
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091118211201.GJ6581@tux>
References: <1258571772.30511.54.camel@johannes.local>
	 <20091118195339.GB25188@bombadil.infradead.org>
	 <1258574517.30511.61.camel@johannes.local> <20091118202334.GG6581@tux>
	 <1258576479.30511.65.camel@johannes.local> <20091118210654.GI6581@tux>
	 <20091118211201.GJ6581@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HlfC6IuGtnrliRDV9vqh"
Date: Wed, 18 Nov 2009 22:13:37 +0100
Message-ID: <1258578817.30511.83.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HlfC6IuGtnrliRDV9vqh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 13:12 -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 18, 2009 at 01:06:54PM -0800, Luis Rodriguez wrote:
> >=20
> > OK, but can't you still have a driver spam mac80211 with a lot of
> > ieee80211_tx_status_irqsafe() calls in soft irq context with the final
> > skb requiring the tx complete, in that case the queue *will* get stuffe=
d
> > and you could potentially free more if so desired.
> >=20
> > Also, if our goal is to just avoid adding the skb if it does not requir=
e
> > a tx complete and our queue size is too large
>=20
> Hit send too early, I meant if our goal is to avoid adding the skb
> if we've reached our limit why not just ree it immediately instead
> of queing it and dequeing it. Wouldn't we even be able to just
> return and not bother mac80211 about it at all?
>=20
> >=20
> >         if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) &&
> >             num + 1 > IEEE80211_TX_STATUS_QUEUE_LIMIT)
> 		{
> >                 dev_kfree_skb_irq(skb);
> 		return;
> 	}
> >         else
> >                 skb_queue_tail(&local->skb_queue)
>=20

Ah. Well, then we still would like them for rate control, just if we
can't keep up we drop older ones.

Not that it makes a whole lot of sense ... if you can't keep up with TX
status how did you manage to TX them to start with?

johannes

--=-HlfC6IuGtnrliRDV9vqh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBGN9AAoJEODzc/N7+QmaGPQP/AhrS8a99UiMn4wRx/d8DLhB
x7UUjm1+AsvO07xGKlk4LEHhE4QDmK00Y6Hsyag8rZ8OzKYYh6BiKoWGg7CzTz9t
waZUk0UOAyWPGeGRDl3Sw+1l/TLoAJ7zzZrcgv59VUp838SCtYRJYUyr1xNW7cPd
05+ybQl1HN87AS1UgkYWtlUWgAP5i9ZFWUBXF+QnpKA4ULT+fjm+GZ+0L1PQX+e8
qxXgnWN8FbeDlrBr6spm5wGuahyneZicgCNM1bTdrJ11XyO0cGiYvAB5G80vCesv
A0zYo98ofQypOns+teEwnJIVsXy7KKpTdFmJCoGUXqfvuflvSUW20UWr0DXL1hEu
j2/lC69tLaWD41eyRj+09xcFH0L4nCzpxHG5tq8uZszCiAYL7QT1/TWUhMVyusen
5ndNYbvA1RTq7DVc3M62PNq0WKw7rzUs8ZGXTpXEg9IBOaXCas1lI+SHtXb6fnKm
/or4/A+MjGX3Moan9W8WQZe65hRrYGVmdSuyQTQzS4lZb+bqQfXtm0ef0VmZrI8+
ggb9nUniQovK0G2G5CkOz2sZRgEjlzKzWcYU1G34wxH0l/L1BCkLAkX0XuMCjsxk
jVPx3E68ANvFChgHtyld22YR6xjBGbUhb+MUDn43KL35N3asmJEp+7z3yQb/mTVZ
Q+jxX5n4+6or72qQ5OkM
=jcvh
-----END PGP SIGNATURE-----

--=-HlfC6IuGtnrliRDV9vqh--


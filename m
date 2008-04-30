Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYD3Opx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:45:53 -0400
Subject: Re: [RFC/RFT 4/4] mac80211: use multi-queue master netdevice
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
In-Reply-To: <200804301637.35170.IvDoorn@gmail.com> (sfid-20080430_163342_355628_E937360B)
References: <20080430124055.091382000@sipsolutions.net>
	 <20080430130051.397094000@sipsolutions.net>
	 <200804301637.35170.IvDoorn@gmail.com>
	 (sfid-20080430_163342_355628_E937360B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-imN2dvKJc6VX7f+fpBLZ"
Date: Wed, 30 Apr 2008 16:45:43 +0200
Message-Id: <1209566743.18659.30.camel@johannes.berg> (sfid-20080430_164546_219685_FBEE97F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-imN2dvKJc6VX7f+fpBLZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

> Overall the rt2x00 changes are good, but I have a few suggestions :)

> >  	struct rt2x00_dev *rt2x00dev =3D hw->priv;
> >  	struct ieee80211_hdr *ieee80211hdr =3D (struct ieee80211_hdr *)skb->d=
ata;
> > -	enum data_queue_qid qid =3D mac80211_queue_to_qid(control->queue);
> > +	enum data_queue_qid qid =3D skb_get_queue_mapping(skb);
> >  	struct data_queue *queue;

> >  		if (rt2x00queue_available(queue) <=3D 1) {
> > -			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> > +			ieee80211_stop_queue(
> > +				rt2x00dev->hw, skb_get_queue_mapping(skb));
>=20
> ieee80211_stop_queue(rt2x00dev->hw, qid);
> The result of skb_get_queue_mapping(skb) was already stored in the
> 'qid' variable at the start of the function. And since this is a 1-1 mapp=
ing
> from skb queue to rt2x00 queue, it is safe to use 'qid' directly in all i=
nstances.

Heh, good point, changed that. Will probably generate the same code
since get_queue_mapping is a static inline, but hey, much nicer to read
that way :)

johannes

--=-imN2dvKJc6VX7f+fpBLZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBiGFqVg1VMiehFYAQL5vA//W/YdlFInCa+hd+cyqCwwgybS6lsQkonH
EP28dMcfq+zse+s6YJoPZtciMheA8qZ14ykVV2DgO6dO2vl1IOCYLxP2XtiSYe8H
8XetC3OQdqADxKVkmH7fy6hsQC/2IlRqWZLn7wgh3uPgjqLM6+vQ+HXJob7vKAla
MOwjiSEYIuAQMHMj/VU4LLRcbJ+gh+4Sphjcqfq1ojKzEnHc19KHjKPVYYdGd4/a
bTuk7yiW+j0Dsibh/ecoZAQ1ZMQhZJtCJ0OoEIpafUDcPGLdHVALG4q5p8JNM580
wcxuHRNWt1PT5KvLfeBtjYdh3nCM+KO+I1z/0Jn4AtZmcC9NvKo29bNANLSjkNwY
6clXF3jhwz4RVTJBkvAwWHsyel1ESjeroQ53MuvIt57x/UMbMyRSTMIyss7r3iyF
sLNW2Q5u7CDjzKLXp+OGJ04+cMTdnwfKVVUdF8pl/jvBiJlE2ojb9xC2spoNC9rr
uQwbLyssWekZHbNb9r8q3UE2bIZybZL4zOB4TAs3Da85IOTE7NHJH4MfU8Tes1Iv
VsYoT3TwxrPZHgGNpvaRpvBxCO6CJCgYDpDOxR66ST+P9rzEjky4fy3cPZIjix9V
Gam0x6YgVwi0od98PRP6We8cBd3m+f3UUSwK8LyHWDs/uvuw4waGUOZuZ2yCIcra
tg2v+XNKRP0=
=Abmj
-----END PGP SIGNATURE-----

--=-imN2dvKJc6VX7f+fpBLZ--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZINRno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 13:43:44 -0400
Subject: Re: A station can't reconnect after it wakes up
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Igor Perminov <igor.perminov@inbox.ru>,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	hostap@lists.shmoo.com, Artur Skawina <art.08.09@gmail.com>
In-Reply-To: <20090914125008.GA15494@jm.kir.nu>
References: <1248969930.29068.224.camel@sunlight>
	 <4A7318E6.3000004@gmail.com> <1249312925.8515.187.camel@sunlight>
	 <1252620184.26765.65.camel@sunlight>
	 <1252767513.23427.26.camel@johannes.local>
	 <1252799481.26765.145.camel@sunlight> <87my4z0w53.fsf@litku.valot.fi>
	 <1252927472.26765.202.camel@sunlight>  <20090914125008.GA15494@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oblMKWb0X1AIyqWpxOOF"
Date: Mon, 14 Sep 2009 10:42:44 -0700
Message-Id: <1252950164.23427.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oblMKWb0X1AIyqWpxOOF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-14 at 15:50 +0300, Jouni Malinen wrote:

> Taken into account that the AP can even change the Association ID for
> the STA during reassociation, I would be fine with dropping the buffered
> frames and clearing the PS state when association is completed
> successfully (the STA ACKs the (Re)Association Response frame that had
> status code 0). I would hope that the authentication frame sequence or
> failed (re)association would not touch the PS buffer or state.
>=20
> The real time when the association state changes in the AP is when the
> ACK frame is received for (Re)Association Response frame. Of the options
> you listed, this would be bit after (B), i.e., (C) might be needed to
> get the exact timing right. However, I could probably live with (B),
> too, in practice.



> > But I think, we shouldn't call ap_sta_ps_end as is done for normal PS
> > state switching, because that leads to sending buffered frames if any,
> > which is undesirable in our case. Instead, we should simply purge of
> > buffered frames and clear WLAN_STA_PS.
>=20
> This is a very good point and we much indeed make sure we do not end up
> sending the buffered frames out based on a new authentication or
> association frame. This is especially important for the case when the
> frames were buffered in RSNA,

Given all this, I still think it would be a lot simpler to just have
hostapd remove the station once.

johannes

--=-oblMKWb0X1AIyqWpxOOF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKroCRAAoJEODzc/N7+Qma5nAQAKOdN0gZXqAcIgsd+MgLSPlQ
Cud2pmnAlDRwhuZJeHX3MRdHPfaeU6hOWZn6fgmBA8T48ltbWnxfafSipHCK2Wq/
IGPUoD4R8QXoE9EXVxkmdkn46iNdFBnx10zEtDUy29Qt/H/W6k8fJ3FwwHEfGznH
a/WncasNoX6R7po+mVi+2iKz+GnEloXaT2jwTt840W7Qtl9qaV8Rc+rxtpQFoGaV
o5fxqZpd/tnF0Apgwx7fvpSjugz7wMhL30jvFWZioYqPrH8i5YH2DPgtCrZ5WyPD
9BXZMeIsuzYzWWEEiAwHhSnEhic3mFy7dI5PsLYS05XHMOwctgjanMx3Z+WFsCG9
l+qznnwO/iBHqMMMyZdXOFBROo+ifklviR+K/bBP0CftjwOJxdC/+GE0fvRZHZN2
D7zeEL1K59jPs7qMrNUyUgX5XHyvkHryKzzxDKfgtnpNa9B3HE30GfoAGGhvlnFR
EySkqz05uiEDKslTpxi6o6x1uIGYTKv/uN8rVcG6xQLQEVV6cpIAvqv39o37cZx5
Lr70dfpoytoHrhtXP2Uk/7Ef74ShumYJbzkulsuF0Nfg08492o6o80oMGwfeKg7G
hYLlGEE0AKjpol+A8EEqLimMPvBu17p3dsUky2iiTibt3gcR2Ti1w6aMzjL1zTZZ
dKI+voTP/IXF7C+ktR6A
=HezV
-----END PGP SIGNATURE-----

--=-oblMKWb0X1AIyqWpxOOF--


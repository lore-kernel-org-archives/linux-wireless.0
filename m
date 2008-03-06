Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYCFRUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 12:20:51 -0500
Subject: Re: [RFC] mac80211: handling Qdisc issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	root <root@localhost.localdomain>
In-Reply-To: <200803061815.31398.mb@bu3sch.de>
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061815.31398.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-diDJ/z76l1L1MifhwJrS"
Date: Thu, 06 Mar 2008 18:20:08 +0100
Message-Id: <1204824008.25502.123.camel@johannes.berg> (sfid-20080306_172111_123073_F7EB8389)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-diDJ/z76l1L1MifhwJrS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  		/* Decide by priority where to put this frame. */
> > -		ring =3D priority_to_txring(dev, ctl->queue);
> > +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> > +		ring =3D priority_to_txring(dev, skb->queue_mapping);
> > +#else
> > +		/* XXX: b43 qos needs a lot of work */
> > +		ring =3D 1;
> > +#endif
> >  	}
>=20
> ehm, this won't compile.
> And did you see the patches I recently submitted?

That's my old patch, I think Ron doesn't know anything about b43 :) And
my patch was based before your QoS support patches.

johannes

--=-diDJ/z76l1L1MifhwJrS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9Anx6Vg1VMiehFYAQI06Q//eo7G41x1orMCr/XPDpSGHYGtBkXJAtY0
2y857J0dbJY1ZqekwVS/Y0jvOMIqonZvQSIZNVQ4tn0Rd4SzhHVOB+au/r9myT84
qXisMdglhJD2fW8N5niUJjAHTs+TpcYiM+NqeygeGSKNk7+H5HMv1QCEC4l1H0c+
gM0oxp9wl1BKyn3VARZqTdOB+Kg04DphtpHfIZlQlH+5tj4UPey+PonLtouGGDmk
O/KxeqCQYDC9ERvOZRkjjns2BriDrLriiJHBXAM7cyMN4pwQNEhFlHBuDaHSIcBm
P7kCBqQdOPPhXC+hpA5klrJV+a+K9BzRCnih7FTpDnfIpQ1dE0zOtDk3j/I2jE+Q
AoRWeROtHP203E6NqkMENEoYcT8kEy9l/ZFssL+kJSEvOg8SqkfDf7f/lZ1pNQq7
Kri2YVZbAi+PonwpUKUIuu6mk6GVqC7EL+vAR0MPCxth6EFrCnr1j+Dftkh6zxsw
1Xk/MupfbwQyNpBRl5JTJXiuST38qbF9BJ6KODoIH8Jt+dI88QMekour6OH+dseY
y2TQh4yCt7GSTHt6s5/J4w8ndmZ7jWYwMxVHKkpaYTQWh9pD97qJyuiHAzA0yVm8
1DmHum7xbkU0Iy+gTJDxI47JIwKJnyYncPeNRUtpRPqPQj8aKGQE0kjHw9wRlyMq
rkp+LpDa3jM=
=fCsY
-----END PGP SIGNATURE-----

--=-diDJ/z76l1L1MifhwJrS--


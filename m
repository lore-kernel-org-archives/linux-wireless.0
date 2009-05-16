Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbZEPM5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:57:41 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
	 <1242334636.4227.134.camel@localhost.localdomain>
	 <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com>
	 <43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-K2KPZ0oeP6VTsddVlS/F"
Date: Sat, 16 May 2009 14:57:37 +0200
Message-Id: <1242478657.10005.72.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K2KPZ0oeP6VTsddVlS/F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-15 at 23:12 -0700, Luis R. Rodriguez wrote:

> > I think this is a good idea, although it wouldn't solve anything for
> > people stuck on old userspace (my oldest target is distributions
> > releases circa 2.6.27). Not sure what is best for that case. The
> > kernel could be informed of the lack of userspace regulating this and
> > then take some reasonable action. What the reasonable action and the
> > terms for that remain unclear to me.
>=20
> OK so what if we just let let old wext scan be just a dump of the
> current bss list provided we do selective scanning once per channel
> throughout a period of time.

Hmm, no. I don't think we want to scan automatically. On the other hand,
a scan that the user triggered could be spread out over more time like I
just wrote in the other mail.

> For new userspace can obviously do whatever we like but since we'd
> implement the above we could just let this automatic scanning can be
> tweaked for roaming purpose with exposed knobs. That is -- make the
> code so that it can be tweaked to act like a regular good old scan or
> take breaks throughout.
>=20
> If you're already associated it makes little sense to be scanning all
> over. If you're not associated it makes sense to do the good old scan
> we're used to. Of course this would just be fof mac80211 and cfg80211
> drivers, old wext will obviously still behave the same for old
> hardware.

Ick.

[other mail]

> Additionally we could add Kconfig for SMART_WEXT or whatever, and old
> configs would behave the same. However users of old distributions
> wanting new shiny drivers with new shiny benefits can enable it -- and
> it would still work with old userspace.

How complicated do you want to make it?

No, I just think we should, if associated, spread out the scan a little
more, and not change anything in the userspace API at all, just change
the time it takes to do the scan and allow data to pass by going back to
the operational channel.

Now, I'm not saying this is easy, it can be almost arbitrarily tricky,
but I still think we should do it. One thing for example could be if
we're scanning the operational channel then the only thing we do is send
probe requests, nothing more.

The other thing to notice is that there's a race between RX and channel
switch that I pointed out before -- and not all hardware is capable of
closing that race. Atheros hardware for example doesn't seem to contain
the channel the frame was received on in the RX information, so that the
driver fills that in based on the current operating channel, which means
that in order to report that correctly you have to flush RX...

Then again I don't quite see why we discard frames received during a
scan even if they were for us.

Anyway, bottom line is that I don't think we should change the APIs in
any way, we should instead make the scan smarter by spreading it out if
we're active. This even applies to scanning while in an IBSS -- stop
beaconing, then go scan etc.

johannes


--=-K2KPZ0oeP6VTsddVlS/F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDrg9AAoJEODzc/N7+QmagIMP/jSzQtj4RWS3w1oP6VgABNeb
Ny8JaeVvoIyutvFhpy81qYZ+us+EAccVKeYyLgd3MtXrtGUKMnymPl53I2gwQ7hG
vSK5cnhPKKA0Si7t5qfU/zLOc0tEb6YwPFgI04OScwq9+5KoZvMaMAeTMd6GDdML
1IZeEaaCtdWLLrjqcVN2chiIt12FElzLVZVfe/Ts7SIQV0/uQWhqJrayfdMZxQ9p
PqtIOeI2z80erJynPH/z8HLGp/Y9sgeHfSHK/6K8Th9gp1AII/sum5zlj7Rd8z8U
MzteBhlnMqGFU9whCJa/d4BP+zRsV4LTxHR34GfcDoeVBDIE/v0e8DD25RfAt8CG
xwFlgQaN8C/jpcTUq91G8gzU0bqFJbO0BwJIkEKtGADDxH65pgiAsVkvY5SnGHgF
Mladi3s22DpCSQu6PuC/lkTEqa9WSY3D0WxTIrdXMqfi9Mz5JE6orUQGTzv0Ah4x
aJ+iftQMuFU/GJN+gc+r0vQv9ZsJVtXvcpzSzrLmkA4kBFxivHuxlz9iwnEZncPH
kK2xYjqPR2K2RhLRM2h/rlUThlI2ZQ2INbXqiP/5LW/OTbr1SngRG2wBEJq7659m
nkUJx+l3R5Pm5JMXw6v8OPkD6PN7ETnTx5F5YztrV89/o5h/phiFTbO8fOtdpCrN
+qlfe4I6ROboIB2OConL
=IPs3
-----END PGP SIGNATURE-----

--=-K2KPZ0oeP6VTsddVlS/F--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYIXP7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 11:59:51 -0400
Subject: Re: [RFC v2] basic background scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809241755.15950.hschaa@suse.de>
References: <200809241636.38762.hschaa@suse.de>
	 <200809241719.28983.hschaa@suse.de>
	 <1222270421.4257.37.camel@johannes.berg>
	 <200809241755.15950.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O9x5pAea8vQdPg7ct82F"
Date: Wed, 24 Sep 2008 17:59:01 +0200
Message-Id: <1222271941.4257.40.camel@johannes.berg> (sfid-20080924_175955_060975_E6DFB89F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O9x5pAea8vQdPg7ct82F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 17:55 +0200, Helmut Schaa wrote:

> > What I meant to say is that it'll give problems with drivers that don't
> > do status reporting properly, and what are you going to do when one of
> > them fails anyway? retry it? how long? assume the connection was lost i=
f
> > it isn't acked? I see little point in it to start with.
>=20
> The main reason why I'd like to know when the frame was acked is that it =
might=20
> happen (and it did happen in my tests already) that the frame notifying t=
he=20
> AP about entering power save state wasn't send before switching to anothe=
r=20
> channel. Hence the AP won't buffer any frames for us.

We should make these frames able to "skip the queue" so to speak, that
would be smarter either way.

> > > > > +				netif_tx_wake_all_queues(sdata->dev);
> > > >
> > > > This is worsening a problem we already have -- you can enable queue=
s
> > > > that the driver asked to be disabled. Until we fix that, I don't th=
ink
> > > > we should tempt our luck even more.
> > >
> > > I see! That's really problematic.
> > > Do you have already an idea on how to fix it?
> >
> > Not really; introduce bits somewhere to keep track of who wants to
> > enable/disable queues I guess.
>=20
> A first trivial solution would be to just store which queues are active
> when the scan is started and restarting only these queues after the scan
> completed.

Actually, well, you have to deal with drivers like adm8211 that
stop/start the queues for each packet...

johannes

--=-O9x5pAea8vQdPg7ct82F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2mPBAAoJEKVg1VMiehFYciUQAIr6vseTsCkLBOgDR9mZcQYH
sJ45TAkxDikFR5gKtc3BR2kW2ITQwrZ9crZ03e5BCfHGIBqJDqzkEUur6K+lYTAl
xM7+7e4bCrqWSrBVHxFLXABJzYam1DimxQx7RTj7XLasLplfzMWqjV2zC5OBnRZG
WvWZ5t7erVbdrJ95R/Yt4EjFrakt3M60UwcGw+CdcD7lxb1eJbWG5yLOoFI5FmXc
19beJC8xnZBULLsk3esN3DiXAcPR9e+L157EnIBNVP3CBgcM7mSC/vMK6WQyXFmd
SmSTuNvaH7H9EeDahzJNNWGZjgz8UuioCGyopH/Wer+XutXFgChuuSKkSRiKxkSN
th3Mh6HBPbEe2QZn5I04t7IW1LTlPnFf/JC9UJn2RSHgfonURsQxs/O59sHIvop4
3Y1pUKXJ0lDrujxG68hHM5QVq1b2ScFL3/C+9RDkIe4VElcf9lAUO2BhmMq7SUsR
xkoqHJ3VQ/EL3WfGc+QC434kmx3l+ndLRVZLGf2aZnshURjYLlnJjktrYUVnBK/9
ogmYpNtACohSxNADdg64YxcV1HgtEBUAFpgudBbnEf+9CT7+cBBr6ueCiBqce72W
BjYgoStn3o3CNzGb9XzdxmEGEcVKWxKwvUjQBdslyLFfhykjYlbC8X8IU8peHjN2
sl40lRB/CSWptMsYE6HU
=2odz
-----END PGP SIGNATURE-----

--=-O9x5pAea8vQdPg7ct82F--


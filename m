Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYG3NTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:19:15 -0400
Subject: RE: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Friedrich.Beckmann@infineon.com
Cc: tomasw@gmail.com, linux-wireless@vger.kernel.org, j@w1.fi
In-Reply-To: <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 (sfid-20080729_175540_513294_CB416055) <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SfB6kio3nTaQCDjFfTKW"
Date: Wed, 30 Jul 2008 15:19:08 +0200
Message-Id: <1217423948.10489.121.camel@johannes.berg> (sfid-20080730_151919_709365_48316EB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SfB6kio3nTaQCDjFfTKW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> from my understanding the reason for hardware aggregation
> queues is not a different priority level as for the AC queues.
> But there are two things that make hardware aggregation queues
> reasonable:
>=20
> a) Packets which are aggregated must be in sequence and they
> must belong to the same RA/TID. So if you mix packets which
> belong to that aggregation process with packets which do no
> not belong to that RA/TID, then you must either break the
> aggregation process or you must somehow "jump" over the
> packets to find suitable canditates for aggregation.

Yes, I know this.

> I think a random access to a queue makes it really
> difficult to handle the hardware queues as it is done
> today, because today it is assumed that packets are
> dequeued in the order in that they are enqueued.
>=20
> Therefore it is more likely that you have to break the
> aggregation process when you find a packet that does not
> fit to the current aggregation process.

Well other drivers would have to handle the aggregation in software,
obviously, and only put the packets onto the queue once enough have been
collected.

I'm fairly do understand what's going on.

How does the hardware make the scheduling decision between the regular
and a-mpdu queue? If it sends out a bunch of aggregated frames whenever
there are enough, how is that _not_ unfair to non-agg stations?

The way I would implement it (and I guess atheros/broadcom do) is to
queue up frames for a station like NAPI does: either for a certain time
(low traffic, and ampdu will be disabled again) or until the txop window
is full, and then queue all of them to the right fifo/hw queue. Which,
in my software design, simply means deferring them a bit inside the
driver. Or for your driver, sticking them into a separate queue. But if
they don't come in via the same qdisc, I don't see how it can be fair.
Please let's get the upper layer considerations before we talk about the
implementation though. Do you not agree that giving an aggregation flow
a separate qdisc is unfair within that AC?

johannes

--=-SfB6kio3nTaQCDjFfTKW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkGpJAAoJEKVg1VMiehFYligP/27Y9c/3sgGxOt/iZTDzpCY6
LnU3hwiGo7SewYDwp5CVnyAdSVZ6NPdUCG9BVl6JOX7+hZIaDT37m4tviiUxLAwJ
L0AuTmkb1SFqN/vk7fJrRAPLatZH77EtDpM1Qnn7wSa/dE/OCJVzqeNlTaWE9Kyw
Z9yF+KKGqQSWvqrZHT+lCR73IwCWBOTf1RJ4MGPX0xwSgyBbm2DC7z3Uu1rSXa8L
VKAAOsmC5UllRgYQHSXtLQMO+AGZnhzXbMNGpUcC262JnGoAguN1lwWsLEJbfIGN
M6dUajpLMWXhhJaGv5FHSdCLtiGShbJTiLAJLnpjXX9K4fElKB1bJXJfdIG1I+9L
TWTsLeUGTTneMVmSEGJfOqtlVpaAsg1k+HW+78iXSbeSnfcrbEWPwxJ3wP6Ourm7
ndWytPlXB1M0Lqk33Ek85t4lKP24zy1TwmS5Q5HSef50oqNt0D7Q0R6EVBcblApw
aRa1LNGiKl0vlT9f1lMAXskPpBzZ50FcVlUwtKabwufHd7NtqIDGNiLXd11CcRJD
3xrIB4Ww5H7f/S3WjhbQI8bBIFis2p11GI6bxSxiLt6OvUhX0WBzcjYsX0VHYwvM
b0xRIGMd9t5KmwGpxoz8clvTueQKXPrLQniWE1ZZ9o592k/w8xhaEL/9oxSV9fm+
PLmZ9uMYE2VsOcbu53ml
=fiiD
-----END PGP SIGNATURE-----

--=-SfB6kio3nTaQCDjFfTKW--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYG2NXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 09:23:43 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com> (sfid-20080729_151827_983097_67E7956D)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 (sfid-20080729_151827_983097_67E7956D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gTutBhme3iB3pJRcPsUy"
Date: Tue, 29 Jul 2008 15:23:39 +0200
Message-Id: <1217337819.10489.57.camel@johannes.berg> (sfid-20080729_152346_507427_BDE96943)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gTutBhme3iB3pJRcPsUy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 16:18 +0300, Tomas Winkler wrote:

> This will require another queueing under what we already have. You
> still need ability to stop and start the packet stream.
> At that time it seems to be stupid not to reuse queueing.

That's where you're actually wrong. If the aggregation queue is full,
since they both go to the same FIFO, we should actually stop the queue
that corresponds to the AC the aggregation goes into, otherwise we
favour stations that enable aggregation over those who don't and they
unfairly get more downstream throughput (if we are the AP).

johannes

--=-gTutBhme3iB3pJRcPsUy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjxnYAAoJEKVg1VMiehFYtrQP/0d35UrzlwSSOWjsX4t4ezAo
NDSeKdjP29CfH2/UEdm845LHwF5QsyMJIqYlxKuQB6BClXnyV1MHcgxi68Wq2jWT
e6jmpx5i8v8+ly2XbWD7RDB3otrnhxwtzdvDxI+U2Cb/CHkT2RAWy/a/GpOu32K3
TTB+lXcndFR83BbDzojQXIXGWWGUa399dT/ypmVVTnIPe47mlVlKstT3qS6GLWgd
Iv1/Y8rdoRtMrfe1FU9fzbBxlQ78HTNmUKeBZo/Dc9yOHafv6JJDDN4mMkYPFEJ0
Z4GB0hPYgTqRgkSjlWf6rP3vNF5ErsbLpaQuGFG34ntio/xJy9cxdS7Hbbj7BP3L
8hprLke9++BQGzT3wwmPMkv6W7DAAqSrcHJLolIEOKfUqeeKOQetkAckCa0nOND7
zitXnAOTYkh52GdunwkigETtiiDmC4jJivcCvXapm9w4Myq/Yo7MGfrrTHweB4s6
l/4+Aw5HbY5ZOTeejOIqKzsbdEOcfAgI+p0ZI98hpvgZpaogtgwOfZPGj6o/Ilxs
B+PiDCZdlrFe/KIA8Yc6AorjAl3QANqIQi2FOna0ZkwOT5vWQVD2MPx0MBp8QTvQ
FVjvN0T3JfrkV/T36LQ9DVkwCCxBIp8abgVhFzx2W7zJlzi3lU2WuXE++i4GMxzw
ltRPlhytZGoAqSwpilrg
=8wKV
-----END PGP SIGNATURE-----

--=-gTutBhme3iB3pJRcPsUy--


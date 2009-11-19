Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZKSK5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 05:57:03 -0500
Subject: Re: scanning question
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <8999a3120911181742y364c763j3b5b88e50890332c@mail.gmail.com>
References: <8999a3120911181742y364c763j3b5b88e50890332c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BFu1m9MPKmtoNeEzhjQa"
Date: Thu, 19 Nov 2009 11:56:37 +0100
Message-ID: <1258628197.7094.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BFu1m9MPKmtoNeEzhjQa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 17:42 -0800, Chuck Tuffli wrote:
> I'm implementing a mac80211 driver and have a question about the
> expected behavior during software based scanning. Can the driver
> assume that mac80211 won't start a scan until all previous TX
> complete? If not, what is the expected behavior of the driver? Finish
> current TX before starting the scan? Drop current TX? Something else?
> TIA!

No, you can't assume that right now, unfortunately. We've been wanting
to implement a flush_tx() callback for a long time now but nobody did so
far. Some drivers might flush in the pre_scan() callback, but I think
that isn't actually correct because the nullfunc frame we might send
might pass other frames on the hw queues/fifos.

johannes

--=-BFu1m9MPKmtoNeEzhjQa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBSRiAAoJEODzc/N7+QmaUL8P/2HVjadAfBnhv9eH3m1Cj/4+
IT8RPjzCZlTXAXhUZmVZ7nr+rKxBYl4fVeLGQG+8UHmYeX6itMQC+z8EP0PQkUUc
TA61ySyFxRqWmnw9npzFY1wJn23Pgy0u2VgoyjPpTUR8nJe3QJONfU/d3rFfoC+x
+m4LQi69dHMssKoZr9rxoyszzWN5IFR3MMiDuRt/4/qfJ/jZ2LuwQvbtMpJZolty
nUpgs7GDHWk8IKqP87jQC2dayv0BgWERR6wyNRdtCtuyA+4dI58vFyt07itSEllt
Dt7p7Kb/FZfuqEAKoITMM5CIrftSIr+AqZptCWoXHJvOYXrY+QAm9vYxdFHaDN00
wykodMJm6Te1s4Lroe+iQhA8hEHB0G2YZ7+QbEE8M4BEkM0bRY6g62XA2FNPDkQT
MQpO13shUj7UT6czR03t5E89i1yCTmI3Bwa82mbtg7u/xg3br1f6ao/xx9AMdAc/
xb4zbbNHpvBjioY1qDD9CBz9fR+V9LyLrZ6pk3n/bU62K0yor4KP/l2ZiRH0ueM+
eOfkHbD1gl/VZklNNlvV4bY4hkHU9yH1rNIDGfhnUDGcXWCXZfKAywV4jfcvBnfX
At1xUQAOTV7fSL6twGdqLUhMkn4Vlz69XIa0+en3vdhu7gQ0+Dq7htK86JkhMj0D
8fdEEs7HtI+nsPyDkGn4
=mz1s
-----END PGP SIGNATURE-----

--=-BFu1m9MPKmtoNeEzhjQa--


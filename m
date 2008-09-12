Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYILMwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 08:52:10 -0400
Subject: rate control vs. bands
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Tomas Winkler <tomas.winkler@intel.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zIzkw/x3WVidf4DHYoti"
Date: Fri, 12 Sep 2008 14:51:30 +0200
Message-Id: <1221223890.11204.33.camel@johannes.berg> (sfid-20080912_145214_760432_1456136F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zIzkw/x3WVidf4DHYoti
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

During my rate control work I noticed that the band handling there is
somewhat awkward, and I wanted to collect opinions.

Currently, much of the code assumes that neither we nor station in our
bSS change bands; the PID algorithm even says:

        /* We can safely assume that sband won't change unless we get
         * reinitialized. */

which doesn't really seem true.

For the rate control algorithms, I was just thinking about removing the
rate_init() callback because this can just as well be done when
allocating the station. However, currently we don't pass the band to the
alloc_sta function, so that isn't possible right now.


It seems like it's well possible that say in an IBSS we have two
stations both dual-band capable and one manually switches them to a
different channel on a different band. This seems to totally throw off
everything we do, it'll be beaconing with an entirely bogus supported
rate set etc. However, it seems that it might also crash the rate
control algorithms.

Any ideas? Should we remove the rate_init function entirely and require
the RC algorithm to initialise for bands the hardware supports? (Those
can be checked via the 'hw' pointer argument we give to the alloc()
callback on the RC API.)

I'm currently leaning towards that, but what about HT stuff? Will that
change between bands? Is there anything band-specific? Why doesn't
anybody but me think about these corner cases?

johannes

--=-zIzkw/x3WVidf4DHYoti
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIymXPAAoJEKVg1VMiehFYtx4P/jJke9lstKnrGtxMGI3cU11N
6Cox6NhYzgYCsv9kYmWCX+sjXrzoK6isKs71SUv/zZf2fqs/DThEdDJp5ZAfCzxx
ADd6vvITC0p89ORK981MUhJEl9Zg7SrzZSxJIs7UYbKrQhRG9O6Ge7mcPS6+vH1r
lJtXTETxmgbOuG8G+mcwM85lNUOmpK58O18PVsfXkccAAy+PX+1CwJmnMZAMcitr
qzfAiuvOfvP/q+EUGZV1qbkkmeZGTHjFIypxMvRlBco6jwRxZgc1wyR9CtZvPSt/
oBQCsC77qZEQvCzVb+eLD4B9AJi4YzA7evr/er3Isr7kCoCW5gc3VBZCcoOjP4hG
lUrNTtw+DzY1HDAbTcE1UTnhlaz185LiRxcLoNdy3h9OJU2oTK5ln8QoTZ1ClsaE
XBjngSME3k4aEK8KzMHPitSqjvcD41MOy7Sds4QWjtRnxf+bR02XB+sNKpZwF0rs
VsvZwrxYJ1rBF3C4r074MnMTjrlPy72Cf0bp/FcZJz2otXrJZGoh+PxmWxSKngBL
3pLQ0xDap3gLt8DB3aYstseJga6OYMQSEVtnmlf6czAeVPhU662ygAnLFp5HneUL
RXfQ2hbpdrzgcpZwqIaVeHM5d7KESos3fpOh7X1SNefAeX3a9EpYbNjTF+JBPLcc
O2jBPv9fWF11wK4RHiFS
=5lC5
-----END PGP SIGNATURE-----

--=-zIzkw/x3WVidf4DHYoti--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZDPORe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 10:17:34 -0400
Subject: roaming/scan/beacon filter braindump
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4kcWry4JemGwKor/MgN/"
Date: Thu, 16 Apr 2009 16:17:00 +0200
Message-Id: <1239891420.8338.10.camel@johannes.local> (sfid-20090416_161738_308502_4A905038)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4kcWry4JemGwKor/MgN/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just so that I don't forget, and others are informed too... :) GSoC
students take notes!

After my beacon filter patch, the scan results you get with iwconfig or
iw no longer update the signal strength while you're associated.
However, currently without any efficient roaming that signal strength is
only useful after a scan anyway, so it doesn't matter.

If you want to know the connection quality, you should use

	iw dev wlan0 station get <bssid>

instead. However, that is only updated when there's traffic. This is the
same information as /sbin/iwconfig prints.

Now, you may want to roam before losing the connection completely while
there's no traffic, so you have a good connection for when there's
traffic again. In order to do that, you need to watch the beacon signal
strength, and inform userspace (the roaming algorithm) of changes.
However, this isn't via the scanning -- it's via the station info.

So:
 * need method for userspace to register what kind of signal changes it
   is interested in (low/high threshold?)
 * need signal change event for the AP station as multicast

johannes

--=-4kcWry4JemGwKor/MgN/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5z3ZAAoJEKVg1VMiehFYU0IQAJLhI2UToDhk4uS9YPmcuDG6
by+JhgLdSfwQu1JD5LeRw9EgCIaug0Qz9hwBR6JYUtTzTAML1ERSyXT8afYUXNUh
wTeCd9pPf1sJvf9rhjtbuDE2b7j72WsNYKTXS3x1DqrLt+8WSJO87l2bCK17+RU+
35OGBfnlWdBU1LwdZQewiSdFIqpSnDgISSwf904Q5F0VGC3z0ZeGwk4Ay8iAlKdE
taqp279ZZqEWa1ptksgyEinxryqmC0utKJDCLuq37mqPZMPRk8yI5pw/NljmP6q8
rcjoRDudqIrcP9BoLQ/i/57FNgouR/qCWWj0dvCAg+qv3LVIL5T0V0iGXl39pfMv
mIzDmTdObxoEfmbr2BmkwrGc1ZgNqE8aayCRfMTOs10iR1YJhv6cCta5CjOZx+gj
KYVGrF2LwbrJQcYfr408mA1Xx+S2SVlA02rXryMqPOoANLR0cwH4v1oeXSnTagCg
x7QqCU2cIN4P0YfJmrxJlFQP5Rlk8Eu9sF7maMxkhbuDnMA7ic/d8FaVMkWoMv5M
dMFFt9GJZco/T4+GS2ohRmJgkhEb2srOYeYvtZNZem7bn+UoKXySYNdfQci4QA+i
3mmcERfP0GHTh3/nhv17roxEPBXfFcywytNdQYGVc29O1160IM1f8ekjAeevS/qK
jos7wq43PSYR3EfDBRXj
=ogSL
-----END PGP SIGNATURE-----

--=-4kcWry4JemGwKor/MgN/--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab0AJNlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 08:41:08 -0500
Subject: Re: [PATCH] mac80211: flush workqueue before calling driver
 ->stop() method
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <201001101435.26235.mb@bu3sch.de>
References: <20100110130752.GG1735@mail.wantstofly.org>
	 <201001101435.26235.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wwzVHT1GJjvstFFdKJvN"
Date: Sun, 10 Jan 2010 14:40:39 +0100
Message-ID: <1263130839.7773.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wwzVHT1GJjvstFFdKJvN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-10 at 14:35 +0100, Michael Buesch wrote:
> On Sunday 10 January 2010 14:07:53 Lennert Buytenhek wrote:
> > Since commit "mwl8k: handle station database update for AP's sta
> entry
> > via ->sta_notify()", mwl8k every now and then gets a command timeout
> > when ifconfig'ing a STA interface down.  This turns out to be due to
> > mwl8k_stop() being called while the work queue item that was
> scheduled
> > by mwl8k_sta_notify() to remove the STA entry for the associated AP
> is
> > still queued, and the former disables interrupts so that when the
> > latter eventually runs, a command completion interrupt is never
> seen.
> >=20
> > Fix this by changing ieee80211_stop_device() so that the workqueue
> is
> > flushed before drv_stop() is called, instead of doing it the other
> way
> > around as is done now.  (As ->stop() is allowed to sleep, there
> isn't
> > any reason for drivers to queue work from within it.)
>=20
> This smells like we should either:
> o Add an assertion that checks whether the driver queued work although
> it was forbidden.
> or
> o Call flush_workqueue twice. Once before and once after drv_stop.

I don't think we need to do either.

See, it's not strictly forbidden to queue work, there's just no
guarantee when it will be executed. But since the driver is already
stopped, what kind of guarantee should it get anyway? And destroying the
workqueue will flush it anyway, if this is part of the unregistration
procedure. So, the driver would be stupid to queue work there that did
anything to the hw, but if it has some work that's purely software state
it shouldn't matter at all.

johannes

--=-wwzVHT1GJjvstFFdKJvN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLSdjUAAoJEODzc/N7+Qma4uAP/AgTu55rKOodpFNjtASEH4B/
XcCq+mX/bvj7FE1ycl2Dl4uADMSJ50Inkx/a3TpCiYiUrV26wZ1ObD3RKgm6N2yI
8P2jaMOZGNApAIztQfLpc3p9yhoRuirutHNmewzQ5yxfK0ZgDXT7EBFMvwxrHUg2
KBLYQujRk9bLegug6O8Zb5tmkHS9Pd8WWLdITk0DqEgmlBxMFhRy3G8UAYpIg4Ox
r4xmt55qfwBDsK4W5BBBVrQdRapUsratcDaa6yq6Yyeli649frJaKHxresBWLKw+
Jptmaek1tE4CD6IqDHmn5WDcz5T9+Fe0Ex+6WTgw8n1qQinIzJ5S1AIu7LkuRaom
Bo0wUcbBhCop3Vg/sFSpeoE4Lw+NaJ/1lFytw0iFtLI6QCHrkf144Y06neybkjco
M8qSHkQi6WAmP2V5YtqpJjjOr1mn1DatFX4L6dua8X0l7BxPPnmRex2KuQrTPxSi
RBYoii1xRKbMsOFGl1tp+abvB5GuWwqJTOQTTnKZ6/+6r2ZX37Cx8SByyBQv5Zrn
lOjAzUfDUl7BtX7CMEP8vru472eNIehFIkzk8a3zdFnR3NFi0QkPN9iJ/PCrhtSu
y2AqC+5y99DArAuFRHx9ClGnfPMvo9MmjaGNC6jH7yECfTccvGDsndssuuXzt9Eq
cIcaCB5ZTAuxbmppdh2U
=zU1X
-----END PGP SIGNATURE-----

--=-wwzVHT1GJjvstFFdKJvN--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZHYJ2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 05:28:42 -0400
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Johannes Berg <johannes@sipsolutions.net>
To: htl10@users.sourceforge.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <950315.98615.qm@web23105.mail.ird.yahoo.com>
References: <950315.98615.qm@web23105.mail.ird.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zs1KzhIa+UMZm+akdKaD"
Date: Tue, 25 Aug 2009 11:27:57 +0200
Message-Id: <1251192477.10667.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zs1KzhIa+UMZm+akdKaD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-25 at 06:51 +0000, Hin-Tak Leung wrote:

> dmesg and rfkill/state corresponds exactly to what the sliding switch
> does (in the on position, dmesg says it is on, states says 2, in the
> off position, dmesg says it is off, state says 1). NM basically
> ignores rfkill/state, and just if'up the device whenever it notices
> the device has gone down.

NM can't ignore the state since cfg80211 enforces it.

Can you please use rfkill (http://git.sipsolutions.net/rfkill.git) to
see what's going on? Like print out events while you slide the button
and use NM etc.

One thing that would be possible -- does your poll callback work while
the interface is down? Try to tell NM to turn off the wireless network,
and see whether the state ever changes with your slider.

johannes

--=-zs1KzhIa+UMZm+akdKaD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKk66XAAoJEODzc/N7+QmaD5gP+wezvZjR05RtOT56XQTHrDgR
JbZ6NgL9GZy9Jn9/GVyAuHV3Vpd6XRN+ec+TwMLfRwvejhJ7JFr/4Dj+V1XtfMda
JcmRnwtn42dQaesi14S7Hxo82uLV2U3a50AI7Nt1sPenu5BA2U6HBqZrxjccw1Xn
A6+qG9blxgmJY/T9EL38xZ9lUVWGqahAzav83PEwxraB0FrN/6bFmhGgo2CIbW/H
HZDQq8PuLVVDYO9NdWmst0mGkiluUwN3b4vKZDBcprWfDShJy+1fGNjtC2gU2O34
xV/F4PZLk+KhhsvPAPLSwGb72hPQKGWTzQD2fBooRWkMcIsZfP9Nfd0aoS0v3np9
ISjyV4T8AVzfdTroGkrEJgEDE8uxZx2/a1mhAY4usQ3DH7RMPtPt7n4ujAdLrPC0
8390Ycyk/XlxgifFxan+7HgAM7dG3zmLHfGRAfOzZfWGHCIDKnQqKOhDMbTvI0+q
/qkfja/S327/xTmj36LHyIcF+zS657bKhnq1OxRXiWi9P3TM6v4v1DWIlASyCF9q
AVWIJuNCIMqi7hhAe4Z4A1Ruy3fP79NVys8ZUX5Q1OINsFCmk9fcD082XOw4+8hU
IYfCbz46MKymD63TX28juIgjaNgJA+PeoCF+zqMfQmOwV0nXLozR26kVGnmLMxik
dJmwShVivxBeBuiq5xkY
=u04u
-----END PGP SIGNATURE-----

--=-zs1KzhIa+UMZm+akdKaD--


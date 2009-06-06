Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZFFRhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:37:31 -0400
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <4A299E57.4020007@lwfinger.net>
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
	 <200906052101.47168.mb@bu3sch.de> <4A298C37.9030503@lwfinger.net>
	 <200906052338.05653.mb@bu3sch.de>  <4A299E57.4020007@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FQ/9NITDIypTmUcj2zch"
Date: Sat, 06 Jun 2009 19:37:28 +0200
Message-Id: <1244309848.17485.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FQ/9NITDIypTmUcj2zch
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-05 at 17:38 -0500, Larry Finger wrote:

> > No. If the device is down, then it _is_ down. There won't be an rfkill =
thing
> > trying to bring it up again although the interface is down.
>=20
> But in the current driver, turning the radio switch off only shuts
> down the radio. The rest of the interface is still up.

Correct. However, we have a lot of problems with this since we will try
to connect while the radio is off, etc. So I integrated it with cfg80211
to turn off interfaces while rfkilled.

> I don't know what was intended in the new rfkill method. Remember, I
> don't read those E-mails either, but what I observe is that cfg80211
> calls the stop callback when the switch goes from on to off, but the
> start callback is not called when the off to on transition occurs.
> That may be a bug - I don't know. Johannes, is there a simple
> explanation as to why the start routine is not called? If that were to
> happen, the rfkill poll routine would happily exit immediately if the
> interface were down.

Most devices don't require to be fully up to poll rfkill. There have
been bugs in iwlwifi wrt. this (not noticing rfkill presses while
interfaces down) that have been fixed a long time ago, just nobody cared
about b43 enough I guess.

> I think rfkill should just be a means of letting drivers know that the
> user wants the radio off, either by turning off a switch, or by
> setting some software flag from userland, and the driver should honor
> those wishes.

That's what we're really doing though. Except we're also doing a logical
interface down in addition so that users don't think they can still
connect to a network.

johannes

--=-FQ/9NITDIypTmUcj2zch
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKqlVAAoJEODzc/N7+QmazIcP/AsKcwd21PDKRaPWxKlYfWLj
UNHL/sv4GplK1Vp84JUqKwHqtgPjbRsOQPLSNsCIP0NQPNY1kcOI+p4XF2BfY73E
it/p8yG0STF2WljHbar7TinEcyP5pkMGw5QqzfvSG2QrG22Fva4tuVkkTsyK8+TB
wH1RGXL4cuEEIt/pW7nVs99mkRlHtaZHjgUoeulv922EsyjfN0KAUIClUNiLj13U
SQjbYcjCZlrwn7F/mTUZVEUIT7u/AnkoFWQEANh2jVtGI0PMi+4/tJZTcRLsWcya
fxlIM2tyrQIojh/TKNUWf1yHG5kugNjcJS9pBc5o6+yjlivZm7GtEKkYjF156bu/
WjS5v1pfwPhcE6+Dk6LB6Wts3D+QsBfKMq7Ncg80TOcWufs1AbEegF/eXXQUh889
rZM2BWgJZpChzYPrbVttr0OvQPwVxPwfeTXyQqBHxrllhPMSJ8dewtueW4IW+yWv
uFB/nGQ1HWIGMzNWE3ND4Huk5FXQjDnB6FcrJSjWktk+vjX0w/zUcTBH9SORmVwP
NuoswG5f9j77J30sYRbYbI3k1K2IFPpDRfK7+Bcor8GMbY8CCA3KKnqzQ5GsAv++
YF3KDhzsPzWOXHcqbFqoAjM173e/NUkgA4PPjFECpntL7rJX14NvBmTzBw80rCcu
y707ppxQrACHykLSPyrK
=lVZV
-----END PGP SIGNATURE-----

--=-FQ/9NITDIypTmUcj2zch--


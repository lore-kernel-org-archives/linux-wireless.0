Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZFDPMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 11:12:23 -0400
Subject: Re: [PATCH] rfkill: always init poll delayed work
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4A27DF95.50603@lwfinger.net>
References: <1244015729.7176.28.camel@johannes.local>
	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>
	 <4A27DF95.50603@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UGh71wspd+ta5MthGudV"
Date: Thu, 04 Jun 2009 17:12:17 +0200
Message-Id: <1244128337.22576.81.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UGh71wspd+ta5MthGudV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 09:52 -0500, Larry Finger wrote:

> I have not made much progress in sorting this out. When I turn the
> switch off, I see RFKILL_STATE in /sys/class/rfkill/rfkill0/uevent go
> from unblocked to hw_blocked. It does not change when the switch is
> turned on.
>=20
> I have verified that b43_rfkill_poll(), the polling callback routine
> is being executed, but that the hardware bit in the interface is never
> being set again. Whichever part of the old rfkill_input code that made
> that change seems not to be functioning.
>=20
> What diagnostics would be helpful?

Could you try, without the patch in question, what happens in terms of
uevents
 * have everything on
 * press rfkill button (expect -> hw_blocked transition)
 * put interface down
 * press rfkill button (expect -> unblocked transition)
 * put interface up

please?

johannes

--=-UGh71wspd+ta5MthGudV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ+ROAAoJEODzc/N7+QmaL/oQAMxQCMlVc+bfhkxzkjkq6mwo
aCq5cxLNGN7kfcVDp/3XszkzvqlTPpOo9tdVudCxdRQyhiYhQwJnMkqyxKjEpKeM
bRuD3og5pQcLoCM3g91bMNh9xjaRZ7LMA1tS3AnMIMD4FjQiUIRUIv+nRGt8uEsu
UUzbUlhBgBqTKtoINwebocqzz/64TCPXI3Yvz57HWjBa9Cr0Zz4j6ZhvgYBXWA+A
Y+VV1e53oUpJRvb9igRQplRyyyUsO36kbQiBxPLed0ERV/bNvmg8eDc5KT9rYzwV
tYN5YJxMDVOdgKtWM6KNKJR4plvDfKkOhz8Rz1sB3WGq5ohEu+fQXvxlPKn/bH4c
hL9Zy+TnXhSWOIVPDdylkvJkb1330wLrtVf7XRzXf1F+NqjukCBk0wzeM52Z7Ug7
8Z5Nug09q26F2CSo7s1LInmBTWdeD3uUmEGMOm8vLBmICY6g4tkyXw7zJARHPcjU
5f+sYeu7CIwVypYORfrNRqgfN46Djq/0v0aL9XiclEDK7Ol7Ag28mhpE4Vr4qx9Y
vW38zXJDptgl1pM+XywYW6OgUIxmoZbsy56YzdRttiaoMe4xGdzwgo6wjs1rKezR
yuV770lTFODj3fgvvz0X7et8spV89s3BwRotXCu7lMV7tnIAGBnnHUZDRUmo+FFT
zgluHfUVXjRK3ikD4Da8
=d0eU
-----END PGP SIGNATURE-----

--=-UGh71wspd+ta5MthGudV--


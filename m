Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZDNMom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 08:44:42 -0400
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Forest Bond <forest@alittletooquiet.net>, Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <1239712106.11795.21.camel@violet>
References: <20090414105200.GE25746@storm.local.network>
	 <1239707258.4778.3.camel@johannes.local>
	 <20090414113928.GA20470@storm.local.network>
	 <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PbJHPF3NfIYtAWGiIyCx"
Date: Tue, 14 Apr 2009 14:43:54 +0200
Message-Id: <1239713034.17109.10.camel@johannes.local> (sfid-20090414_144446_137532_54F46AB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PbJHPF3NfIYtAWGiIyCx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> just to document the irony here. Two or three years ago at OLS, Kyle and
> Greg were making fun of Ubuntu merging its 5th wireless stack into their
> kernel. Now the staging crap is doing exactly the same.

:)

Actually, last I counted it was already 7 or 8 stacks in staging _only_.
This (and the other patch) will add two more. Not to mention that of
course we already have something like two and a half stacks in the
kernel tree (mac80211, in hostapd, and libipw [former ieee80211]).

> At some point I like to see some proper future development/cleanup
> planning for drivers in the staging area. Dumping stuff in there doesn't
> help at all and personally I don't see anybody cleaning up this mess.

Which is why, for all wireless "drivers" but agnx and stlc45xx in
staging I have requested that the linux-wireless list not be copied on
any of the "patches" for those drivers. All of these other drivers are,
in my opinion, entirely pointless and need to be rewritten from scratch
using the current infrastructure. No amount of cleanup will help --
there is a _fundamental_ design difference. Compare ar9170 (rewritten)
with otus (vendor) for an example.

Mind you, there don't seem to be many developers capable of doing that,
and therefore all these drivers will never "make it". All wireless
patches in staging, that haven't been proposed by people very familiar
with the wireless code, have so far been in the "brain-dead cleanup"
category.

> Do we have an option to taint the kernel when a staging driver is used.
> Similar to what we do with binary drivers or ndiswrapper?

It's already doing that. FWIW, I trust many of those staging drivers a
lot _less_ than, for instance, Broadcom's binary-only wl.ko driver.

johannes

--=-PbJHPF3NfIYtAWGiIyCx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5IUGAAoJEKVg1VMiehFYfS0QAKuOv+GBZSXovdBoQGGZksIK
ZOFn+Q9ydHChIfT/ANJwqnWjGes7BQRAa2As7cZ24KHzFVh4eWMHWQy/qFpOiL95
PG74c1HdtpXICbF3Ddw4yDuo6jAKkicOWvb/oA3+ogxDz9b7RRC9aA6nW9l/Qcxa
aQAWyQqFZcbwc5fpi7QHB7yz3AFrNj3zpoQaBWpD2GoisS9nbXet6xDnaU3TkfHF
3WCm5SD1P3I3pDEp6mtDjLV6Q6fcGHb5h9dnmbjWIxH8BqBb5+r54AZExJd0kLwd
vRt0yRSBwJb8iLgdsv6WuHEH1t0FQ1xQmNTceqlAubR3xqI1JnNIa0r9qHYq3cDR
RtTNk8/pD+cmk8SBW/57ilekLzHhdgwcRhHj/5YFSEF2u+brrMNA9BjgfZDGsmK3
3AFY22ZzskfPPd7LiOoaE19gH+VejBQqf+B/MTOyTwkFgqia0g1VZbbdVWCe691I
x9AKTcgINeV5YRnG5JpQDCSEshVHu6DAnlU6dlPbhCjhsiMm1GugpOYhWEOaUVl6
POOH+4d+0125t8ZDYmwubKNTNc5nFgQCQuBMAgbbtvrJ9/yAeCHyIYgkwq2jIKQY
jlqXPwibA21lSK1O9AbhxDMGwrMgj5GXjzWtA02AxwHN8ZIvds7tVK3YPVlqHHuz
77FWj9nv/TGiTX1C/TxN
=HY9x
-----END PGP SIGNATURE-----

--=-PbJHPF3NfIYtAWGiIyCx--


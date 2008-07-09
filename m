Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYGIWZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 18:25:38 -0400
Subject: Re: iwlwifi workaround for mac80211 sequence number bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunksi <ron.rindjunski@intel.com>
In-Reply-To: <1ba2fa240807091517y40f6ab8cscc352bfdaa0d715@mail.gmail.com> (sfid-20080710_001755_843107_650682D8)
References: <1215641485.3246.72.camel@johannes.berg>
	 <1ba2fa240807091517y40f6ab8cscc352bfdaa0d715@mail.gmail.com>
	 (sfid-20080710_001755_843107_650682D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XgmXE1MIuzjlXn1HKABL"
Date: Thu, 10 Jul 2008 00:24:51 +0200
Message-Id: <1215642292.3246.79.camel@johannes.berg> (sfid-20080710_002541_544861_780AF5A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XgmXE1MIuzjlXn1HKABL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-10 at 01:17 +0300, Tomas Winkler wrote:

> This is not a bug in mac.
> The sequence number can be committed only if the packet is not dropped
> somewhere in the driver. See lower in the function.. There are plenty
> of  places on the TX path when packet can be dropped this it's last
> station.  There is no reason to pushing this into mac

I don't see it that way. In fact, in the code I'm looking at, there is
nothing that drops the frame before committing the sequence number
change after assigning it.

And all the cases where it drops the frame _before_ the piece of code I
quoted don't actually matter, the first bunch of those are bugs and the
not associated one is strange but most likely doesn't matter either (if
we're not associated sequence numbers don't matter), and the
"destination STA entry not found" one doesn't matter either since that
means there's some disconnect/bug between iwlwifi and mac80211 since
they should synchronise via sta_notify().

Which particular item do you see as problematic?

johannes

--=-XgmXE1MIuzjlXn1HKABL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdTqwAAoJEKVg1VMiehFYLL0P/RxnMp1YKsNtakv7ddkxdEzb
uWbMhyaTm5a0Uy3pJUnFgUvt7GVNZOjQe2L7NxGvoP7am2miH0czHuxefZicmdc0
FAYAbVa+fW5pFLfDZI7tRglJ5VKzj5/2AF6qkwWN6/Yeuj/umC+C3QtOTDxUfUaS
V99cMcGeunFmYUqV6xgcregt8eNBp8uJ3gNzcwG/pboBolk37qzeCbe/linpsUJZ
bdUrHufJX3MfRJopdrn2QzATHvaUd1QXAQT4MLEDOsh+n/6JfZW7I0sm2AJzoqoj
0B8VIX/j6sX/ZyR3953BfIZGmhpEKhF9oKDjTRxop/b/pycUTIXl88pWaYW174l3
x15tSz8+0iQKTWgKtLcqvFb8SVCxXxUwi1fGX03idMdh2pBjINmiH9Cr1yRA/J1G
BhxbQVR8vIjnUzSPWBozfNIcRENxlsyNU+Nlse5kEpBfH75t22uB3nJ8ZyLiRpJO
cC3nBAcPROQK9K9WuhAGoYInnIVD5Qrt4qaoa8HOvxkEuMoRJVPz2UiGVAGsiEQC
byykQY+yEdwmaKISuCnSXAP0kUXWu+FI1s+1KxbPqa079987eamGaVp6fLIAf9RR
z8riCOLGlssqogyn7JooCNh7x2SZm3GEDfL97px4CdlfKfZOk92HKXMY3cN3hEc9
a7w+szLikrpnKiFlmho0
=klOO
-----END PGP SIGNATURE-----

--=-XgmXE1MIuzjlXn1HKABL--


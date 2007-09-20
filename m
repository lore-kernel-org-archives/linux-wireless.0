Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbXITQ7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:59:54 -0400
Subject: Re: wext 64-bit: network manager and wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070920165545.GA29452@bougret.hpl.hp.com>
References: <1190292526.18521.52.camel@johannes.berg>
	 <20070920165545.GA29452@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I7rjyGv3GOAdiGHWa8Zx"
Date: Thu, 20 Sep 2007 19:01:09 +0200
Message-Id: <1190307669.18521.94.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I7rjyGv3GOAdiGHWa8Zx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> 	You know that I don't have any 64 bit box, so I can't really
> test it. I did extensive work with people of Gentoo and Debian to make
> sure that my fix in Wireless Extension works both with 32 bits
> userspace on 64 bits kernel and 64 bits userspace on 64 bits
> kernels. The versions that are fully fixed are 29-pre20 and later.

Ok. Sounds good.

> 	Then, I modified NetworkManaged to use libiw for scan
> parsing. The idea was to simplify NetworkManager and fix the 32-64 bit
> bug, plus a few other potential gotchas. The first version of
> NetworkManager to include that fix is 0.6.5. But, I've just realised
> that I did not convert event parsing, which could be an issue, I'll
> try to work on that.
> 	Note that the other big issue is that, if wpa_supplicant is
> present, NetworkManager will request the scan from it, and won't use
> its internal code, so all those fixes are useless. Maybe there should
> be a control to force NetworkManager to use its own scan code when
> needed.

Does NM always use wpa_supplicant even in 0.6.5? I thought only later
versions deferred everything to it.

> 	As far as I know, Debian testing (Lenny) has those
> packages. Of course, I would not mind if you could test all this,
> verify that the packages are the right version and that iwlist works
> properly. If iwlist does not work, the rest will never works.

iwlist works fine on my quad G5 box, but NM doesn't. I suppose then it
does use wpa_supplicant.

> 	With respect to wpa_supplicant. Well, I sent multiple e-mail
> to Jouni to inform him about this. My personaly inclination would be
> to rip the custom parsing code of wpa_supplicant and use libiw
> instead, but Jouni will never accept that. Maybe you should use
> xsupplicant instead.

Can't really use xsupplicant, since NM relies on it and we want the
kernel to rely more on wpa_supplicant (or another userspace MLME
implementation). Is it really hard to fix the parsing code in
wpa_supplicant? I'm not familiar with the workaround at all.

> 	Ok, I see what's happening. That would just prevent you to set
> authentication information, but that is not the root caause of your
> problems. I'll puch a fix ASAP to John.

Not sure, this seems to make wpa_supplicant unhappy enough to not even
start doing anything. But then I configured it for WPA.

johannes

--=-I7rjyGv3GOAdiGHWa8Zx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8qdV/ETPhpq3jKURAkF/AJ9Qoz9Mp+VD6e+mwLKjkvTC5O7jVACfaWZP
JQNR3CXhNuksqkjVMgkHLQQ=
=aFxT
-----END PGP SIGNATURE-----

--=-I7rjyGv3GOAdiGHWa8Zx--


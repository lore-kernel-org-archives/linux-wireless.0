Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011AbXCVKEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:04:41 -0400
Subject: Re: [PATCH 3/4] mac80211: Monitor mode radiotap injection docs
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070320104104.575903961@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.575903961@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l7Pewzk8gNnW0oVsLLhI"
Date: Wed, 21 Mar 2007 19:15:50 +0100
Message-Id: <1174500950.3944.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l7Pewzk8gNnW0oVsLLhI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-20 at 10:39 +0000, andy@warmcat.com wrote:

> +++ b/Documentation/networking/mac80211-injection.txt

This needs to be for cfg80211.

> +Radiotap headers are variable-length and extensible, you can get most of=
 the
> +information you need to know on them from:
> +
> +./include/net/ieee80211_radiotap.h
> +
> +But note: all fields in the radiotap header are *little endian*.
> +
> +There is a fixed portion at the start which contains a u32 bitmap that d=
efines
> +if the possible argument is present or not.  At the moment there are onl=
y 13
> +possible arguments defined, but in case we run out of space in the u32 i=
t is
> +defined that b31 set indicates that there is another u32 bitmap followin=
g, and
> +the start of the arguments is moved forward 4 bytes each time.

Drop all that, it's generic radiotap description. Put it into another
file if you want.

> +After the fixed part of the header, the arguments follow.
> +
> + - the arguments are all little-endian!

duplicated information.

> +The ieee80211 header follows immediately afterwards, looking for example=
 like
> +this:
> +
> +	0x08, 0x01, 0x00, 0x00,
> +	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
> +	0x13, 0x22, 0x33, 0x44, 0x55, 0x66,
> +	0x13, 0x22, 0x33, 0x44, 0x55, 0x66,
> +	0x10, 0x86
> +
> +Then lastly there is the payload.

Scratch that, somebody who doesn't know how a IEEE 802.11 header looks
like has no business reading that file anyway ;)

> Libpcap can also be used,
> +(which is easier than doing the work to bind the socket to the right
> +interface), along the following lines:
> +
> +	ppcap =3D pcap_open_live(szInterfaceName, 800, 1, 20, szErrbuf);
> +...
> +	r =3D pcap_inject(ppcap, u8aSendBuffer, nLength);
> +
> +You can also find sources for a complete inject test applet here:
> +
> +http://penumbra.warmcat.com/_twk/tiki-index.php?page=3Dpacketspammer

Is it big enough to warrant being elsewhere? I don't see how an example
program can be more than a few lines of code and then it could be
included here as a C file.

johannes

--=-l7Pewzk8gNnW0oVsLLhI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAXZW/ETPhpq3jKURAnFuAKCgiUgQOgSETOE7j04bjdrjRWoUNACfQc1Q
XVk2sYfnD5JcpmelBJ2LTQU=
=6l//
-----END PGP SIGNATURE-----

--=-l7Pewzk8gNnW0oVsLLhI--


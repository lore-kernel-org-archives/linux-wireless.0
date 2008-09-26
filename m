Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYIZO5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 10:57:25 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1222361863.14444.18.camel@localhost.localdomain> (sfid-20080925_185851_642978_A90BDB40)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com>
	 <200809250834.07781.hs4233@mail.mn-solutions.de>
	 (sfid-20080925_083440_223989_866F07A7)  <1222332205.10563.26.camel@johannes.berg>
	 <1222361863.14444.18.camel@localhost.localdomain>
	 (sfid-20080925_185851_642978_A90BDB40)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k5ssRSW4nwKNfRawFEZ8"
Date: Fri, 26 Sep 2008 16:57:14 +0200
Message-Id: <1222441034.3798.6.camel@johannes.berg> (sfid-20080926_165728_974534_CE4E2F24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k5ssRSW4nwKNfRawFEZ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 12:57 -0400, Dan Williams wrote:

Let me elaborate a bit on what my patch does

> 2) common GIWSCAN processing function that takes a list of common BSS
> structures that the driver stores internally.  The common BSS structure
> would have a "void *driver_data" pointer in which the driver could keep
> driver-specific data items,=20

I actually am allocating space for it in the same struct, rather small
difference though.

> but the driver would be responsible for
> setting all available information in the common BSS structure when the
> firmware provides scan results.  lib80211 provides common allocation,
> deallocation, bss entry aging, ref/unref, and free-list fetching.

What cfg80211 with my patch does is bind it to the wiphy, which you
really want to have anyway when taking advantage of the regulatory stuff
etc. It's currently not providing any deallocation function, but is
providing allocation (currently only based on a beacon/proberesp frame
but a new version can be provided), entry aging, ref/unref. List
fetching is notably absent, I was thinking an iterator function should
be provided if at all necessary, maybe the "find me an entry with these
characteristics" functions should just be expanded to have more optional
parameters. Then again, you may need to make decisions based on security
etc.

I have not so far thought about splitting out the information and
stuffed it all into an information element list that I'm internally
handling, for speed the SSID IE should probably be pointered explicitly
though.

johannes

--=-k5ssRSW4nwKNfRawFEZ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3PhFAAoJEKVg1VMiehFYzz0P/j9QXqwNPSnpLO5SjPP2oFXl
3K7fFccXAZAWA3yPmX5aOs9B2vHIsvuNnBJCk4accvOzXMiH0VjeQXif9JkKzkUE
/bMWfTUmJIeUSDv4QpwriRJrl6yIyV1V72/MEieexrKbdXdXYq2swbfnJ/3rufNS
/MvGLjPCNxpvKTdnfDuXQ3Ey9nvKA8gw7rvk0pt3OEVekyEldzOiasCAF1Lp94C/
fP4ZzFok6JXtdPamBQCzTlpOgklG7WCSBtSj6fHxUmzR1mreOju5GgcV60sQnE9G
8hDmp0YJCqR2YGNbZpJKvWVGcuh4xGW5EfT9BNEdmuS4RsgacWuC0q+WHStkKUXL
LhfuB614FuIK/IygYchY5BcJaLBNr6IxDnkAkyPsBf4LcjboXabTnTybVHcIg33I
tqIvrJDlQIFIwHitIluwPRINCoThq6ebwORhff29gU5DLdQVkqZU3fXFdCfW2Oej
k9A3P5l8CeQKsEJ/3q9KX38Uzp/yro6MQozR9lLlkQRKVyEMYZVkAXExsIktcbBr
AEMMkeyMeRdSjt6Pxe1ybc9nFuzPdhM0785MeAtWAjkn/T3ARQCA4jKgp7Em7Bl+
LEt3FDv1B8ZO97ac1ZjLSyxYxQ+t8MN/tqqxJZfiBV4BNEsXhyh2Q27PBUr0XEDn
FnCCmIce1gsbNVAFtYgL
=nC6z
-----END PGP SIGNATURE-----

--=-k5ssRSW4nwKNfRawFEZ8--


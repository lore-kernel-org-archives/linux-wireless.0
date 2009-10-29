Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZJ2S6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 14:58:52 -0400
Subject: Re: [PATCH] mac80211: make align adjustment code support paged SKB
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <43e72e890910291152g5325718ah1c55912e928896e3@mail.gmail.com>
References: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
	 <43e72e890910290918v1ca66bbdk4270eabcae6f5798@mail.gmail.com>
	 <43e72e890910291152g5325718ah1c55912e928896e3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QtcsgfggvEtkoS/Ltp7m"
Date: Thu, 29 Oct 2009 19:58:48 +0100
Message-ID: <1256842728.3865.128.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QtcsgfggvEtkoS/Ltp7m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-29 at 11:52 -0700, Luis R. Rodriguez wrote:

> > Can you elaborate on the planned paged skb support on mac80211 you
> > have. Do you have any queued up patches I can look at this point?
>=20
> OK I see git show 924e10
>=20
> Anyone taking the mac80211 paged skb support on? Any idea how long it
> may take to complete?

It's not very hard.

Step 1)
  fix a few corner cases other drivers might have, and stick the bit of
  code iwlwifi has right before passing the frame to mac80211 into
  mac80211 as the first thing it does with the frame

Step 2)
  Look through rx.c and check how much stuff it really needs linearised,
  and where. I suspect that most of the time it _only_ needs the first
  two bytes, until it comes to actually passing the frame up.

Step 3)
  After the audit, push down the linearizing to where needed, i.e.
  management frames completely, other frames up to and including the
  ethernet header, software decryption all of the frame

Step 4)
  make software decryption aware of paged SKBs, and remove the
  linearising in that case

johannes

--=-QtcsgfggvEtkoS/Ltp7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6eXiAAoJEODzc/N7+Qma08kP/iEY81c5SV84LDBwYRwrY/tt
+GR4Lw2eM4B9pKBhMdro1Ei7R1jXdDPuCpqBYJQzvBENuJj5w2sT1t1yVvkg6QX7
Gt6errQR16v06E0uMknNFIPcwnlQk5ZSHncdHR0jI8ccBya5UW1IQzxc8GtjX+Ko
90FHD4L3jWXIj/dG3C4+P3URnoZoY2yauSAxD95LrBy58uHdCgKXA3WeODGpire5
w2L8HXsaf46+1O8kCUdCt1JzeljZuryhI6S/9iMEFfyyHOJF2d2dMVyTbTGZppiJ
xNJfIxyFxjStxalsjMFOAmEgeEQSsxwEODciuZXh1xc1jfU96srLRL9kC5m9Nrq+
iVUPNslRu5jgz/W1MCRhdSkTgCNyDF4pwLxeSyHGDDGtnMIzNOzWu7luiOMdctIy
Rd4f+NRABtNWFARWw0fqcOvYhn7D+AVtvWJSG/aPDclzO2P3BEFi/4kwcLUFIY7o
H7lx8sjB9/X62GUGfUlX9bS6oV3onaEDVhIjAK/ahhhG6SMi44fDprGzRI5j1I0E
aGiq2Pc5fQU5TLqRxaX+xOYRSBRceTZxOJ1fXFKL/He5pw4Ud5fsKY9zQ3WTd6eb
iacpPKIvqdTkGhCXEceEZzMBqSUBTWrhkEdWep6TGggujNvhBGEA9qdhRyhaYQCA
UvtKJAFEmSUZZ9O5ZjsO
=5K89
-----END PGP SIGNATURE-----

--=-QtcsgfggvEtkoS/Ltp7m--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZCNQBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 12:01:48 -0400
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL in
	iwl_adjust_beacon_interval
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <1237046388.5235.82.camel@johannes.local> (sfid-20090314_170011_179754_8AED8D0E)
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com>
	 <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk>
	 <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>
	 <20090221003133.GB3890@tuxdriver.com>
	 <1235443093.4455.77.camel@johannes.local>
	 <20090225014454.GA3577@tuxdriver.com>
	 <1237046388.5235.82.camel@johannes.local>
	 (sfid-20090314_170011_179754_8AED8D0E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+f0SDuZACC5X7uATUizz"
Date: Sat, 14 Mar 2009 17:01:43 +0100
Message-Id: <1237046503.5235.84.camel@johannes.local> (sfid-20090314_170156_240214_C3852A75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+f0SDuZACC5X7uATUizz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 16:59 +0100, Johannes Berg wrote:

> Sorry for the delay. Reinette made me aware that I'd missed to work on
> this! Unfortunately, I don't see anything going wrong.

Scratch that, I did see something going wrong ;)


> In any case, the proper solution here would be to internally keep a
> reference in mac80211 to the "current BSS" struct, and hang on to it
> (ie. increase the refcount, and never use the lookup function but the
> pointer we have gotten)...

Also, moving assoc/auth stuff to cfg80211 _properly_ will require doing
that in cfg80211, and as such would fix this problem too. I'm inclined
to wait for that.

johannes

--=-+f0SDuZACC5X7uATUizz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu9TkAAoJEKVg1VMiehFYhdIQAJQf7nvRfR5VYInrHOyzsAtt
0aHZA/O5Z/NRXWNCt1mERmvbafjW3LAsk59D9aZzUVHalmX1MaG3XKSUbAZAdJu/
QaifVy49aBgp+w3mv4uLTg/IYwQEtk6sCGRkEttmxBEXeMxoBWCMhw5xhBepmSQb
pRxmienQ29hE1ULXInapBbJ8Pu0vA5B3ONlsqztVv7Y+21Dvo8LY88RXYJSZaIAC
6ZTaNtB9/Z39zRRfOCON++akGB1MFffhWXT2mC3FjylVRGthwAx/3fB9fySV66hg
9HPJYfHJc5PEG9xpc5CRJJi/63VktRUObxwGqkfg02EYhMoMkwifmkoCxlHWiCsj
MFfdMU5nH+EM9fR581dYWu8FlysSp61tt6/rDBSLXStKX6s2f1s2LUsjrx/WAYCW
H0B/uQ9dRqx9KzjOKcuL+iw/spTV7caS1SCXk+WsJ7XfNUs0HyiNxGs+i0ZUkPnW
ohjEMAFYBlFfFPSMPMfuokXOdjX3uI0JMHhcwMJwbuMO6XoAG09xOoal38BxVm1J
qB9eyWkRm262bTDpyDOKpvjzU2lyzoWVpoQj+cQCR/j4aF3AcVCVNqRmVNFQg92y
PULWffdmRzEo3qNCOo9RmrTQAR4rqFaqcZy20mOi80oeTg8g+VOiK+2wlF6550AT
XcO+8zBSioyA35TvN9jl
=hs6w
-----END PGP SIGNATURE-----

--=-+f0SDuZACC5X7uATUizz--


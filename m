Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZCNROk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:14:40 -0400
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL
	in	iwl_adjust_beacon_interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49BBE4A0.3060901@nokia.com>
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com>
	 <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk>
	 <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>
	 <20090221003133.GB3890@tuxdriver.com>
	 <1235443093.4455.77.camel@johannes.local>
	 <20090225014454.GA3577@tuxdriver.com>
	 <1237046388.5235.82.camel@johannes.local>  <49BBE4A0.3060901@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TyXZoO3e8LyaxiKiNsi9"
Date: Sat, 14 Mar 2009 18:14:32 +0100
Message-Id: <1237050872.5235.95.camel@johannes.local> (sfid-20090314_181443_644180_9430A1EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TyXZoO3e8LyaxiKiNsi9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 19:08 +0200, Kalle Valo wrote:
> Johannes Berg wrote:
> > Kalle, I suspect that your beacon offload will require something like
> > holding on to BSS structs too, is that correct?
>=20
> My current solution is just to disable beacon filtering (and power save)=20
> whenever we are scanning. That way beacon filtering doesn't interfere=20
> scanning in anyway.

That makes sense, but disabling beacons means that

	iwlist wlan0 scan last

will not show _any_ BSS while associated, but it should really show the
BSS we're associated to. This is the problem I was referring to.

johannes

--=-TyXZoO3e8LyaxiKiNsi9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu+X1AAoJEKVg1VMiehFYK3sP/1u3kyLI1GneBrkCzEtu85j6
0MtAjF/fQfa6wYxLrYGh70nWp5f93P3OUw/8V26Pw4XfDouL4hXiOnK7XayMY2m2
GORjxr1fqtJLDnJVBMJGHOP9fXevYx+793o19MB+xj0YiNRZ6FTxLtxq4o7d/Myd
BYTXJOqH3X6oIej4oxwQW4GjaHsqeEVTQNRvSL8gsWHAaYvL4zqB/CIEYS87ivHE
W7xV5u74zY6iJjiBBpvD1Lzuys4c+gQFaVMWzjy3hw8/NO/5GMo0GVjOj1laLqcg
df4c4YdZEJtjT2DiW25qrIkC0FpGyI1J2WkpZzHrALCQ1kBV985j/+gZGkrxuIQL
jqpwQl84BMO/tf8IILcSzhhrfKgAx9EmYQcO1z+mxAaOWPH5o0mxZgKsjtEJyt7f
nnE0vvcFpJ4K+eG+yUf/zbqDRQkHPar87rN1o0oQ6GJxwnYc5SZLMIiZ5nhSnP4Z
KafV14N5DjRfnltDOSbnsBrHHTGV+hyt/7JWl5BmLjMCacXjFCowxYjukb4z85T6
S836AWA8L9MNW+yIDSLAAKw6lFbTNoo3/PZHN4fJHfIWQtHUS7+2kwOKb+48PFG8
CMhO5GICnhmrnRRHUagSutsT/v+paIiBdzhg7k1hQHXVdGzpJwwcXQnCHAPWorZ1
KlUfAgdcIQE/dajqjgdb
=ELB0
-----END PGP SIGNATURE-----

--=-TyXZoO3e8LyaxiKiNsi9--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZAXOwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:52:38 -0500
Subject: Re: [PATCH] mac80211: change workqueue back to non-freezeable
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090124144630.GA14662@hash.localnet>
References: <20090124041229.GA13712@hash.localnet>
	 <1232806437.4036.5.camel@johannes.local>
	 <20090124144630.GA14662@hash.localnet>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j1Zj9t8sEnorUAclMhoK"
Date: Sat, 24 Jan 2009 15:52:27 +0100
Message-Id: <1232808747.4036.20.camel@johannes.local> (sfid-20090124_155242_198154_27B392A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j1Zj9t8sEnorUAclMhoK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-24 at 09:46 -0500, Bob Copeland wrote:
> > Good catch! Do we have to freeze the workqueue ourselves manually or
> > something, to avoid drivers adding work to it?
>=20
> Yeah I guess so - it would only matter if they add work in one
> of the callbacks we use to remove keys, interfaces, etc.   This
> might be a good case for the in_suspend flag.  Or, we could just=20
> flush the workqueue again at the end of suspend to make sure=20
> nothing was added.

True, just flushing it again is probably better. Best do it before the
->stop() call so the driver doesn't try to bang dead hardware... just in
case it's broken and assumes work structs will run before ->stop().

> The other thing I don't get is why STR works fine but STD hangs,
> from my reading of stuff in kernel/power they should be the same
> with respect to order of task-freeze and suspend. =20

Indeed, that is a little odd. But I think this patch is correct, and the
question is why the incorrect code doesn't break in one case. Maybe not
something to worry about too much?

johannes

--=-j1Zj9t8sEnorUAclMhoK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeysoAAoJEKVg1VMiehFYyLcP/2vqsCGxqg8Umj8LaX5+n9zA
Ro6lGgX0SZcubrHggrxrk9RGdYBju0XE3AH79G7Y/Z6FPBaOp3tUWywBqTu40vod
Z2RHdE1DGLeavrKan75NmXoSUmy9jxVICKQSdIsyw4JLSiI8RywoTh6IF/fagrkM
uQ5YJM0Y5yz0rxX+dc13OUiC/qNhaU/sxsy3Eb8/V1hpCdzKdRo99wNhGzbnureC
fFTd3cRTBdZRVlielYSo6ab0Ed3+bvZWHszQHEhjJWw7wJ48qcTfXr9UDcK76xBf
oaglqk6vzmVJC4NA0N0q4rdGjabS/shD2MWLBywlx7fABvHUrX9Tu+HHttoclI6E
PP47VF96Rcibgirez7pMTdx2VBFUhaaViaiYqmQkaGyAWBgoK0ytdOM2mQMRUtZD
LSB5QiHCznYyr40wvOd/m/8YC0q3zeJ05IB8UEx08gB0zipZz7ZY2oOFwNk1OZ8X
SzV6JMT7orJjxH1pnaygMplObxtWHqMAi+ueHySVyYcvVtsQsZHNgIxJbOkvrAEj
6Ap46FWPq08RvIYF0ZJNCWnK60as/LebpA00oIyx0PCXV/H2xalXbVXteUQCjnMh
oSv7CK8Un+b5YPm6oFTzk5/EpB53Z5YXHTgRKGxX9C7m+4mNQgDSVznsl6/ePTXt
DxngKemJfONhhwFAZSS/
=0Mdp
-----END PGP SIGNATURE-----

--=-j1Zj9t8sEnorUAclMhoK--


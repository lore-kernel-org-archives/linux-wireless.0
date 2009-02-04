Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZBDXc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:32:29 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233789496.5559.10.camel@californication>
References: <20090204150857.GA5069@sortiz.org>
	 (sfid-20090204_160640_465532_8378EED5)  <1233760201.3992.20.camel@johannes.local>
	 <1233789496.5559.10.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FpG5kCqf0V1SqJDwKFdg"
Date: Thu, 05 Feb 2009 00:31:42 +0100
Message-Id: <1233790302.7390.19.camel@johannes.local> (sfid-20090205_003233_604362_2B350B78)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FpG5kCqf0V1SqJDwKFdg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Module parameter, hard-coded filter, just to work around wext crap. Eww=
.
> > NACK.
>=20
> we are perfectly aware that this is ugly and trust me, that nobody of us
> wants to do it. However we do have these setups and they happen in real
> life. I have been in a couple of locations where I ran into this problem
> and in that cases there is no way for me to establish any kind of WiFi
> connection at all, because the buffers are just too small. And that is
> with a laptop. Then just think about a mobile phone running mac80211
> where the memory is limited.

That's a straw-man. Your applications are _artificially_ limiting the
wext buffer size, to something well below your mobile phone's memory.

> So WEXT is crap and everybody agrees, but until we can use cfg80211 for
> scanning, we need something to make this work. So if this patch is not
> acceptable, then do we get scanning support via cfg80211 for 2.6.30? You
> were always marking your patches as development/RFC.

This patch is _certainly_ not acceptable. You know that just as well as
I do. And of course you can get scanning with cfg80211/nl80211 in
2.6.30. You just have to help make it work. The patch below has one
major flaw: it keeps all BSSes in a doubly-linked list. That gives
horrible lookup behaviour. So I set about to fix it:

http://johannes.sipsolutions.net/patches/kernel/all/LATEST/029-b%2btree.pat=
ch
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/030-cfg80211-sca=
n-btree.patch

but the b+tree was pretty much rejected, and I don't currently have time
to spend on investigating other types of trees (rbtrees, ...) or hash
tables. Without that, it's going to suck, especially on the embedded
devices you mention.

> > Go for
> > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/028-cfg80211=
-scan.patch
>=20
> Return a 404 btw.

Yeah, so I rebased and it's now at
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/024-cfg80211-sca=
n.patch

johannes

--=-FpG5kCqf0V1SqJDwKFdg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJiiVbAAoJEKVg1VMiehFYNoYP/29NRohTqpMjfdVRLQIQWSBr
/FVF83DeYe1oavaBuUtP4t+OMEo65INTEO5KL/hvuqBggeOMPoaHn2c2mLoaLe4Y
5aPyuOHh1mTkpXYL4aO8+x2AOpVinbfpC/fVj5tOijZCUdsjDD+5nImkbqKAzSyG
mQu2xx4IbK61+UNZ+65qeSP5PfkVsn03FK+/PksH5XIfK0QYMlvGpbzZTQsFLHCv
BjP4dWp32czlfuBIYQBcSZJN6s+ORJH1QAIo0H3aFeDOCDgBpgmAI+6qBS+zoQJm
prN2SF3T7rPjnluvHhVsfU/h3fC33Wi5izgFhbJR3uaYxSWoZZlGg87VLAcVgtxl
Kfy/fb8YkfjPpVFC9W9c7rwAuhFvuwbeWyNTA4f/T0BtGdgQFbiXE8odqamr7hzK
H2h8e+PTyoBBZPmpqWXTbpESYGsXU/aIqnKW17MVJxBcz3CgDqNvNKKQWE+qUNBy
9+hxKtGulyDkPgn5NFsoef+M/JwJZBZ2djncHR/qD8j1YXRZrEgg1cAyArc1O1pp
8YTZfR9hsxenJ3WDp5rtrK1ZunfT15aAjotXk+dArOVt6OSAiXoU1vijlYdzyc1C
PSxrXA7XVay1/qc2wqZAc67kXzGGpbvbQiWRBDdsdw2+6UFcS7PvJg+1JeouXvlr
1R4/lVR63/oJ79tMFy0Z
=QNMT
-----END PGP SIGNATURE-----

--=-FpG5kCqf0V1SqJDwKFdg--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZFWLxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:53:05 -0400
Subject: Re: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090623114917.GB5349@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
	 <1245697719.4184.1.camel@johannes.local> <20090623114917.GB5349@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rcuNjeqnKBTGJ7ikqcMS"
Date: Tue, 23 Jun 2009 13:53:04 +0200
Message-Id: <1245757984.21314.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rcuNjeqnKBTGJ7ikqcMS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-23 at 13:49 +0200, Samuel Ortiz wrote:

> > One question I just had -- if bssid is NULL, and the card selects the
> > BSSID, I suppose it will also roam by itself if it can [1]. Don't we
> > need a "roamed" event for that then, even if we're not yet adding a
> > ->roam() call?
> I guess userspace will get 2 events: a disconnect one and then a connect =
one.
> Not exactly a "roamed" event though, I agree.

Ok, I guess then it needs to distinguish between a disconnect that it
caused locally (or some other userspace tool), and a disconnect that the
AP caused.

OTOH, I don't think this is appropriate. I think after a disconnect
event, the kernel/device should stop doing _anything_. Otherwise we'll,
on a smaller scale, repeat the wext problem where you don't know whether
the device is currently doing something or not.

johannes

--=-rcuNjeqnKBTGJ7ikqcMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQMIcAAoJEODzc/N7+QmajxQP/3G3Gdftu4zrsGxo/7oRHG/r
tMzRfboNasjjEfYNGPOfHf3XqgFhbZN5+gd8eiG6OoAbxwcc4oV6/g5RUD5k8Ead
Z6M2VHYEu1nPYjR8y+w12jc/5/f2mPwScKei5eHaU9VGi+3N0pTr8nRWPnIqgAt+
iWoJA3Jd/tBkfq/PFoqneDb016S3rDltaejr6PpKiDlUbrh04Zi3anBXKTQZdotb
5x3C2dmXcqOsqVeTyKJU6Xo+qsDMANlERgK8ti/eFdCcv22E3MioiVwrKMMgjyrn
RwdJHUCcjIk5yC/l/vvR799Rz7KUqg3HzSQ390ZtHKDY2b6VaPPpJAFPXNPuALA/
IT/cAUDPi/yJUetleR+MJFFoI/ZpkWTxavMzA1ZMFCcVCtsKOVWjV8QHTbuBNUEB
vj6yR2E7HQtKuXSOuj/uFnVUDu704zMqsd2LrM53T8HdbYrVHfdlmsS0CB6xdcq9
vr/9afk3EpTzeREVswVoRpKLJLChJR+u6t6rDA5ggIuABQxLxt+lQF5iT6dOuYlT
OigdjMW5UW+LJvsKjJ5UG/9bqf25KzTCULKjAgC6aLsMbTLg52rA3GZW/xABDEco
qIkZMwtqIUSmVelrRVfaWHtKQlZ8m36NtEqMSMKNARZum1595AV+tjzoD2NXBdvf
yYajIyd4apdgC4QzkE2x
=hxAf
-----END PGP SIGNATURE-----

--=-rcuNjeqnKBTGJ7ikqcMS--


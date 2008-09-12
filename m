Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbYILNJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 09:09:43 -0400
Subject: Re: rate control vs. bands
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Tomas Winkler <tomas.winkler@intel.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1221223890.11204.33.camel@johannes.berg> (sfid-20080912_145214_760432_1456136F)
References: <1221223890.11204.33.camel@johannes.berg>
	 (sfid-20080912_145214_760432_1456136F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n4mzVXd/jI7/5DZlfkb9"
Date: Fri, 12 Sep 2008 15:09:07 +0200
Message-Id: <1221224947.11204.44.camel@johannes.berg> (sfid-20080912_150946_708211_6C1D1B78)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n4mzVXd/jI7/5DZlfkb9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 14:51 +0200, Johannes Berg wrote:

> For the rate control algorithms, I was just thinking about removing the
> rate_init() callback because this can just as well be done when
> allocating the station. However, currently we don't pass the band to the
> alloc_sta function, so that isn't possible right now.

Oh, and for anyone thinking about enabling mesh with a driver that
doesn't use the default PID RC algorithm -- there's a problem in that
rate_init isn't called for mesh peers at all, hence you'll want to fix
that problem in mac80211 if you really want to do it right now... I
guess it mostly works now for PID because index 0 is a valid supported
rate all the time.

johannes

--=-n4mzVXd/jI7/5DZlfkb9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIymnvAAoJEKVg1VMiehFYiqoP/08M3dcLH9I5ScwS26gyYlKj
fCLmh1tXygcoOdeVdG+7O7BA0co7wWYIgRjbWYJ5pzuyiJKrob/r9omwjiBPPV9h
R2JoFqoqJyrqfGWjc5VRdoja1rNMV4CsqfjQIUoIPgCk/GQwjyHHLQxLSuogY6Pd
nh+8rRrO0SuMrq1CW5MXjT2vwRqDihni/Apud5xeyPYiwCzbABGIo2+GG3OmXEcS
dpffnKpC87Wg+ehboZTarksSS5DxuBZJrGxJ4BPQSWICrNcxv2hZx+yNIYDlk9BU
n4G6Ps+DfOlH8tSrGDo70Tuk0pnlw1EqUBt3lBTKJFkAc1i0KXODQdSSQnMHshgy
5YmcUZxabs9DdmfVXY0XK3SuTZsYNdrOTE+zdWHxZwb26+F6ngPQOeVfOSIDLnji
Smob/9avObSjbFxpKVvZzoasSO1M+3eU/uFqWddBoKw1Upl88oiDC8epO+CIz7U3
XZhlJHQMrv8DUrWsW+8/LGWoHUZSaJTw6tEVr3HRxmL2fFSemsS/ZXxy0NkBzxnU
3BMU1sA66Lc2NjWYmjYliovfrWpG3vzL/RsBLBNo9nCiGRabbbuL/vQb6msaRtLM
zlsITfFb2Lxe5apYjvgeG6de7SHp4UfgZ2aTWE8NDowKZk5TtUZeKgiDKmXXA0NQ
fDdiCDk1En+a9dQ4puug
=D/c3
-----END PGP SIGNATURE-----

--=-n4mzVXd/jI7/5DZlfkb9--


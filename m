Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYLHTxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 14:53:45 -0500
Subject: Re: [PATCH 1/6 v2.2] mac80211: add sta_notify_ps callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
In-Reply-To: <200812081520.20666.chunkeey@web.de>
References: <200811292232.56550.chunkeey@web.de>
	 <200812021655.53141.chunkeey@web.de>
	 <1228731369.22164.70.camel@johannes.berg>
	 <200812081520.20666.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d/wjMj/P64K+VxcYr5RV"
Date: Mon, 08 Dec 2008 20:53:10 +0100
Message-Id: <1228765990.22164.119.camel@johannes.berg> (sfid-20081208_205347_744900_3A8F8AE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d/wjMj/P64K+VxcYr5RV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 15:20 +0100, Christian Lamparter wrote:
> On Monday 08 December 2008 11:16:09 Johannes Berg wrote:
> > On Tue, 2008-12-02 at 16:55 +0100, Christian Lamparter wrote:
> >=20
> > > Do you think "This callback is optional. Only use it, if your hardwar=
e/
> > > firmware really implements a station filter table" is enough (and cor=
rect spelled btw?)
> > > Or do you volunteer for adding one or two DOC entries about APs, BC &=
 MC Buffering,
> > > TIM and station filters mechanism, caveats, and available callbacks o=
r solutions?
> >=20
> > Incidentally, I was entirely wrong about the sta_notify callback being
> > allowed to sleep, it's not, it's under a spinlock, and, more
> > importantly, RCU read lock for station removal (and this cannot be
> > changed). Must have been wishful thinking...
> >=20
> So?
> can I move the notification enums STA_NOTIFY_SLEEP/STA_NOTIFY_AWAKE
> to the sta_notify callback again, or is this wishful thinking as well?
> After all, sta_notify wasn't intended to be used to tell the driver about
> power state transitions but it does fit the bill...

Don't bother, I just wanted to point out I had been wrong.

johannes

--=-d/wjMj/P64K+VxcYr5RV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPXsjAAoJEKVg1VMiehFYIaAP/2SXiRFJy2+PfcqckujvtVD2
yRSHjYnLfVTFabtjk6zqPTJExNoeshZWpoFGgzbb0L4t+Cxp2IZ05qvEqD8ml0aL
94F/+PCjUCPb6VkNLBtsFiU/DCVgefRNmSLKn8fKEZP7GE40gIdGh6TWaPT4zgCx
BARk+ZvLMIinvjN4m/zneN80xzT+nHnLG3aCYr1f/2XHEa4nh+/GACR0qhUEOxwM
4hFrzNPLjIv+/wkHV5t4y0+Gl51VGHkDIqg+YDsa96VfBBXE0cKOUJAl4J84DZKc
eOidontufcDR9c+a7yF/+jyUMKvxtwydeMXL2Btpq7ik0w0o150VkPeI9J9RXk+o
JRfRdqOq/RPANw2bPivHS85mRnUkIcrJNKE8kmA0gggvOY4Vfka2FvEMCFW5yXfE
Os8tz1rk+kap8KdzL53Ir9HlE9iEpfYtUeDFFR+gKtmLZ/vm6KjYBpdmtfd+iGfn
KqTiIJicq2QAC2NTLtHa5fgHLYW5ABkwrSpeCoDLOvnsJqWPNMdk77TsvdFw0jiF
3UbdXE5wQNfHD881M7hqXryVGGmoJYdMqxV8j963gyjuOSvUzVnBW6pFq/Oz4WlW
qONjcuUuuoRrCsNXHhr3FnFsRT6VJ7Md+7iGw792GIyRaVBiKOCy77JFyHk0MYCq
wi9uQl/6tXiIq3cVFY89
=/ak6
-----END PGP SIGNATURE-----

--=-d/wjMj/P64K+VxcYr5RV--


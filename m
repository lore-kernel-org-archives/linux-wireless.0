Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470AbZGMQRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 12:17:46 -0400
Subject: Re: [RFC/RFT] rtl8187: Fix for kernel oops when unloading with
 LEDs enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: netrolller.3d@gmail.com,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4a5b563e.AuhPXmHA0dUFYtzx%Larry.Finger@lwfinger.net>
References: <4a5b563e.AuhPXmHA0dUFYtzx%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-La8BKVfGcq5197EMfxwG"
Date: Mon, 13 Jul 2009 18:16:52 +0200
Message-Id: <1247501812.4166.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-La8BKVfGcq5197EMfxwG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 10:43 -0500, Larry Finger wrote:
> When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
> may oops when the module is unloaded as the workqueue for led_on was
> not being cancelled. To prevent interference between cfg80211 and rtl8187=
,
> a separate workqueue has also been established.

It doesn't seem like a separate workqueue should be necessary -- why is
it? Might make more sense to fix cfg80211 or mac80211 instead.

johannes

--=-La8BKVfGcq5197EMfxwG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW13xAAoJEODzc/N7+QmakxQP/juo1YPcJSfVawFLlRWDNNhp
HC7jqGOdBQJ2s0RHmLksm8fvXFM/XxCYuVK5CIo/HQJNWIdyU5lvn19PDMk0NO5f
5q/16qVtE0mIDnymxdNV7AaLuv+UoyEMRlO8+oD+X2+0IpZS8JOZPKLTJnAON4UV
jlA65FRjd5hE9RNTy0hjRZam7wlm04mRnLucQBqLTOBot03CQ6l6MKvNKOG0BDvR
TG3y9sH+YVLkEC6IuedAY08Tez+RyYbWorptx+RaH9MRRrcx3CiS9EHDFEFQ6gLP
Yu/pD8X/rUF1llTSku7LJ0N13zbgN/onWmRsx/cP7cgMCinOYql3G8eyKL3uaXCR
mE14glAQV12MQ69qF87+57k0uccrAGIhf8fmI/qUFLAvIGbylznwjF5mYeP3veuX
gIUxeE8QnvdeLCUatHfANLSLDf1HR0T2hCOW1dUxP7iBMHrQ/LJObjOQ+brQHj3c
t5AuAG0qb8jO9V+cVNHwxFCLXFPFHF2mPG9mT6wmqgaxcfTUcedoz7Ci2UuMx1BC
gRsWacf4jApoZvoWJPm9mmQO9g2mesir09zOsT12vaItb1UsheEzpPpSvJVVfm6U
96V9FYj8NQYOxSwTS3L+WLRYC/dneKChKYH34LxH9egZvZ+Upa2YGI0YM/p16Eqi
9GD40v2+tGczIhLT33eD
=+qgf
-----END PGP SIGNATURE-----

--=-La8BKVfGcq5197EMfxwG--


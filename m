Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYLHNBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:01:12 -0500
Subject: Re: [PATCH 1/6 v2.2] mac80211: add sta_notify_ps callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
In-Reply-To: <200812021655.53141.chunkeey@web.de>
References: <200811292232.56550.chunkeey@web.de>
	 <200811300048.42352.chunkeey@web.de> <20081201191723.GI5992@tesla>
	 <200812021655.53141.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Tu0ZkapIKuh9hvWZV315"
Date: Mon, 08 Dec 2008 11:16:09 +0100
Message-Id: <1228731369.22164.70.camel@johannes.berg> (sfid-20081208_140116_647590_4C0A7894)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Tu0ZkapIKuh9hvWZV315
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-02 at 16:55 +0100, Christian Lamparter wrote:

> Do you think "This callback is optional. Only use it, if your hardware/
> firmware really implements a station filter table" is enough (and correct=
 spelled btw?)
> Or do you volunteer for adding one or two DOC entries about APs, BC & MC =
Buffering,
> TIM and station filters mechanism, caveats, and available callbacks or so=
lutions?

Incidentally, I was entirely wrong about the sta_notify callback being
allowed to sleep, it's not, it's under a spinlock, and, more
importantly, RCU read lock for station removal (and this cannot be
changed). Must have been wishful thinking...

johannes

--=-Tu0ZkapIKuh9hvWZV315
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPPPlAAoJEKVg1VMiehFYQfcP/0lKNOZ1+ENukit31dp/bwZi
eiYrq1sjVThWVFmTtUGq3zVna3n+k3If0DUfeBjza+ayWsTzqNY8BmxyN+6neALl
1O6R/4l4aySQAvALf4p8lYbooLJCAeaUSH58/Rs4QsZQ0+C5emV+vRtJbIK4dOGi
tQpadNyNYNxsThVHBdCDdqDrEjHh2xEjZD0afv8210MBt9KGPFT4/siu2ags7LMU
oHCD/KknAcfJNMxwztNfSjvJvATJMahSUrEZJsdpc2M3RpiMkmSRzA85QYRvzlht
IVku3xUw1tHNvIQz/FdCM5WQTIBgJHSjsJ7RPpdYW6VjZWS9OUKaZ20GBO6PtL+I
LLTO4qOuTK2h1nU6BklcnC8WJAIJzjB2N2teh7ymrbmoI+K9SYHlB7rbVPaI7gT7
by2PjaxJIZvDhazH2Fla896SXUmS/uODvtOH/JnzpdphGpUYHz8GZpIhbqq1vSCS
qf/o9Xs6iSIkV/KHEqciwfcM1b4lb+ywPawyPVGGm5feOg/t+MufeCVGTwWYju8m
jUujZ4kMS2cTfMICvk6Mdv5/ZJgm9/3Ew0obj7CeKijF0GhMVAw2CfbYdDgESz6I
zsy0ddn9v+i2XYU63/tF7uHxasrqoys4rI6bNMbumLdZPMd2A7evFNHImgN0MIwl
DNzV30nODs7uLtOuPFpo
=kSM+
-----END PGP SIGNATURE-----

--=-Tu0ZkapIKuh9hvWZV315--


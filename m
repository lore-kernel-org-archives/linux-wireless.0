Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYKSMeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 07:34:01 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1ba2fa240811190422o4eebb26ai17ea12825ae8e708@mail.gmail.com> (sfid-20081119_132259_432501_DF04DFBB)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227021904.4014.58.camel@johannes.berg>
	 <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com>
	 <1227094594.26243.6.camel@johannes.berg>
	 <1ba2fa240811190422o4eebb26ai17ea12825ae8e708@mail.gmail.com>
	 (sfid-20081119_132259_432501_DF04DFBB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-COMhdIac1SKYgyBPgRqn"
Date: Wed, 19 Nov 2008 13:33:13 +0100
Message-Id: <1227097994.26243.33.camel@johannes.berg> (sfid-20081119_133405_721470_4082DCD2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-COMhdIac1SKYgyBPgRqn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 14:22 +0200, Tomas Winkler wrote:

> > Yeah, it's weird, and it doesn't even seem to solve it for everyone. So
> > there must be another thing too.
>=20
> It seems that your wrong command queue problem is no the same root
> cause  we see on x86 platforms they have just same phenomena, because
> there is 0xff data on the RX buffer.

Well we've seen at one report that it helps, on x86. And the alignment
thing is definitely a bug, so fixing it had to help somewhere. But yes,
it looks like there's a different bug leading to the same symptoms
elsewhere...

Here's a thought: iwl_rx_queue_update_write_ptr doesn't synchronise the
pointer rxq->bd memory to the device. So if you have a platform that's
not cache coherent for IO devices (mine is) that might be a problem.

johannes

--=-COMhdIac1SKYgyBPgRqn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJAeGAAoJEKVg1VMiehFYBIYP/10qZwjzpeBh3kkPmHVD+FtK
Opv7ypd0Lb1WNPB1Yulzs6VHzmrYFlN8TozcpCTGjRYh+DJgDc/1jfZDJUetQmfK
R7e32tBsED/YitU95sKa7LYGBbHAnY7LlLPWd6Ym/VhzsMrDktXHvxwC1zIYj7C/
xmwIQjNOsgJsxv6P1ePB/JmCR0nrdYgUoF0QrBIOnXBkjZ/6iJWcs2AGf3XA3Krs
7xzVGm7f/UUkPl6eu0SZ7ftptgRDZ5MZctXjkbkmllRzFA/cqUDEFIL+YeAdy582
w4U/hWosc13yRXkNmhKE2GbWC5UK8VpNsWguiUu9rUyRzzDoh8hdpsGWwRDAblQe
VDTNtsMqnsQSrVj6+OajWI5rL5yp9ObeJXg9SE24GY8pdteVb3QUmWDRehGZaqRb
xsVAtuvOYmPuFzXvWcCwktuO+BDj1itMnSuGDzQ1s3M5+ucndyuu4dl/t1ADsUjs
SgDtiHs5K9bDNMVmWGiGs09ppMpVbDMi3kOTTCh2vPaknbC8MF3MdOFLtia01Ua8
LmBGIrsS+XxiF5MUKRrOtk5YrzSj7/ThhS6JCAiKWM+IRYhp1zIVusQBrYg7ChNR
4aUfOSayvUz1UJR5R9v4Rfj/B0sg9lLCz0ri6KCAnnI3Sp4SG+ANZyVxFIFLZ1zK
n/YyQUZnM3hi0x/h01Ck
=NuxJ
-----END PGP SIGNATURE-----

--=-COMhdIac1SKYgyBPgRqn--


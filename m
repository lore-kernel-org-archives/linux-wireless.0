Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbXJOLpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 07:45:05 -0400
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <35945.80.169.182.16.1192448277.squirrel@www.dactylis.com>
References: <fdqhn4$qab$1@sea.gmane.org>
	 <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
	 <1192094159.4770.21.camel@johannes.berg>
	 <200710112005.56101.IvDoorn@gmail.com>
	 <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com>
	 <1192216713.4770.58.camel@johannes.berg>
	 <1192217047.4770.61.camel@johannes.berg>
	 <56412.80.169.182.16.1192431887.squirrel@www.dactylis.com>
	 <1192437157.3349.7.camel@johannes.berg>
	 <35945.80.169.182.16.1192448277.squirrel@www.dactylis.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IqatTf8WkZ/6mFCCiiOz"
Date: Mon, 15 Oct 2007 13:45:23 +0200
Message-Id: <1192448723.3349.32.camel@johannes.berg> (sfid-20071015_124509_371173_CA0FA3F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IqatTf8WkZ/6mFCCiiOz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-15 at 13:37 +0200, Marcus Better wrote:
> Johannes Berg wrote:
> > On Mon, 2007-10-15 at 09:04 +0200, Marcus Better wrote:
> >> The new patch doesn't seem to solve the problem either. I get the same
> >> association failure as before.
>=20
> Update: on my second recompile (after adding the printks) it started
> working. I'm not sure why it failed the first time.

Buggy recompile? No idea really.

> However there is a huge performance regression. "tptest" shows a TCP
> throughput of under 300 kbit for the driver version 2.0.9 (current
> wireless-2.6), compared to 7 Mbit for version 2.0.7 (with kernel
> 2.6.23-rc3). The UDP speed was also affected but not as much, down from
> around 5-10 Mbit to 1 Mbit.

I don't think this would be related to mac80211, I'll let Ivo handle the
rest of this.

> > Can you add back your printk patch and check what type 'channel' was an=
d
> > maybe print channel->channel?
>=20
> With the printks below I get the following:
>=20
> Oct 15 13:14:43 better kernel: selected mode 2
> Oct 15 13:14:43 better kernel: selected channel 8

Looks good, 2 is G mode.

johannes

--=-IqatTf8WkZ/6mFCCiiOz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxNS0aVg1VMiehFYAQJFPg//eTGWkrIl7ZLeU1oEiLV3Z/YSCr1VqSi8
HbZYyUJN6QC+Toz/2Wddhm0FSRSqM+NXRcogIw2LFy+psrlk+qndAbGITHtDk4Xz
WNElE9fnJJyovGEfYqLmPcQY5G4M9yLvHw89KJXmFOohrCvDCmdEVREbh/kY07Zw
cOkR0OU/dZwSVRxo1JUQ38SQA6AxzLFWCNn0wgDIAwUWEDZQ99VASN2cTYxuYBeL
mFghBjyj2/AdtCpxqkTUcNlwP+X+1PcYhcY9HlUmCjpwkWVe6DvhwnmnHCLSdZTV
OqcOUuOaIC7ak6/Zo+ae4HWf+EnsVHzM8DCTQI77Y4OlBBj8tFg3hRGokRZL23LJ
fPl8lFSGwygB43h/ICqZm/KxW3cvc73nTwahGU8B1JinuTwAEJ2bUh8Rx6MCoELi
FMxjo87E/fM7nRpDX4eGgJHiTMkhBDN70NYr//oUh2zcKKSDoP8ehM5Epx1n/Ewq
meyzkfrB1NNWk1FguYxZde2QBrJaZLr7OxjXnuHLIOq9qYXcxu2Isjz9BbquU1Le
GIN4NAzSCfv/w4WH+d+HyjkeXJe0EBvBRKEtB46ph6iS1RnLSj9U7pX2J6CR4B7R
Mi82A8vb/LsAsMS+E1vm87oBMm+Kco0NNAowEWNxVVAQRIp4gM1GlcsPNHJMr1Y/
xF/bKcIjWgo=
=t94a
-----END PGP SIGNATURE-----

--=-IqatTf8WkZ/6mFCCiiOz--


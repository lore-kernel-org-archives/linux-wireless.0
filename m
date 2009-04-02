Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZDBB4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 21:56:03 -0400
Subject: Re: Fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <86201b3f0904011355p788ee867p300b5be24569e46b@mail.gmail.com> (sfid-20090401_225534_289155_7CA4C47F)
References: <86201b3f0904011355p788ee867p300b5be24569e46b@mail.gmail.com>
	 (sfid-20090401_225534_289155_7CA4C47F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Yv+pX/crq/+yHrlAzlza"
Date: Thu, 02 Apr 2009 03:55:29 +0200
Message-Id: <1238637329.4141.7.camel@johannes.local> (sfid-20090402_035608_720401_A79ABAC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yv+pX/crq/+yHrlAzlza
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Charles,

> I'm working on a driver which will use mac80211.  My hardware cannot
> transmit a frame larger than 1792 bytes, or receive frames larger than
> 2048 bytes.  Right now I am relying on the fragmentation routines
> built into mac80211.  Is there a way for my driver to tell mac80211
> what the maximum transmit and receive frame sizes are?  Do I need to
> implement my own fragmentation code to handle this?

Using fragmentation for this is not a good plan -- better adjust the
maximum MTU. We currently cannot do that because mac80211 assumes that
all devices actually conform to the 802.11 standard wrt. this... Clearly
your device does not -- 2048 bytes is much too small, and you cannot
force the remote peer to send smaller frames than that (though in
practise it they will be smaller most of the time).

I would suggest that for now you don't worry about it at all -- the
default MTU is 1500 matching ethernet, so the largest frame that
mac80211 will give you by default is much smaller than 1792 bytes. Then,
once you release your driver under GPL and post it for inclusion into
our tree we can think about adding a new hardware capability to mac80211
that restricts users from increasing the MTU above 1792-30-2-8-4 (or
something like that).

johannes

--=-Yv+pX/crq/+yHrlAzlza
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1BsPAAoJEKVg1VMiehFYP0IP/RGnUldYRsYNeciV5M1hOk5l
W0JPPkJcPhQRdihGUkDrYXp6ymr7rbNtIwWN4vTImNbUmTDnOkzBR+yfZFw2oNR8
DOt9jKDNY0e1nyEakT050IgoPes7QPl2sBdGkytJKQ3bFQ/AJm46OLsU2W5syYCr
f0B5HkSubE6AaWOcPC7xSy1ln4wwk6n/KtE6DhvbudxAxhwmsqn/Qd537pwXNwfv
8XlmkH6vL6IMRRaTiBqeYHr5q0o3LG5PRzeh83yCkJmM59ck9BzGMBwAm/44VMMA
AWzBs44qYy2yhbW5w4elU53tOx2c1FcrqiYIjcz7KDqMrCi2k+Al4bbYDutDpnCd
MugUmeGFK7EQRax9z1JbFW/Tgi/erTXEpLWf1o9b504nqEoZDIOeASwXrg0YkqGx
VQVKzj5bSKZDXMhkXjZ0y6tpV1nZLmnlyohxWZl2Z0vnhLy9XU7gVCXA+6p5eEIz
kiqZWP9HyaYPtV/Dx+qslwkNOXSsNIRJ/gWMC2lG5eXlUp9MVKUGjCOooUhg6b07
cEjy0To/P5RTtWCRcSy33ZYa9oMltbGEsiEGpAnXGj/u5oNpc20PV/+PjmpB+/YH
bVU8y1gQuI+aXVUO3wBqS5vuh+5Va6au7JDRLItYL0oTsd4CGTx6BfgRCKv6XK87
4Rm35uYRlnpYRJB42w7n
=u6Pw
-----END PGP SIGNATURE-----

--=-Yv+pX/crq/+yHrlAzlza--


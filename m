Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZKJKjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 05:39:37 -0500
Subject: Re: ar9170 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Holger Schurig <holgerschurig@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4AF88505.2060802@web.de>
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi>
	 <4AF6CC02.8080204@web.de> <m3639k9kq4.wl%holgerschurig@gmail.com>
	 <87ocncdrfz.fsf@purkki.valot.fi> <20091109141458.GA2805@tuxdriver.com>
	 <4AF88505.2060802@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OjoYU17FAxYiF4nQmC4u"
Date: Tue, 10 Nov 2009 11:39:02 +0100
Message-ID: <1257849542.7037.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OjoYU17FAxYiF4nQmC4u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 22:09 +0100, Jan Kiszka wrote:

> Could someone briefly explain how the firmware is supposed to handle
> this case? By scanning outgoing frames for multicast addresses? Should
> the DTIM condition be detected and reported (via beacon) only by the
> firmware, or would the driver be involved to some degree? If we handle
> this transparently in the firmware, I guess that it would have to buffer
> not only a single multicast frame, right? Do we have enough memory for
> this on the chip?

The driver is always involved in some way, cf.
IEEE80211_TX_CTL_SEND_AFTER_DTIM and
IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING in mac80211.h

As to what the right thing with ar9170 is -- I don't know. Maybe the
firmware could buffer a few frames, and the driver can push the
remaining frames down once the device tells it the beacon was sent. Or
maybe it's OK, although not perfect, if we simply send the frames once
the device says the beacon was sent... I've never understood how the QoS
implementation in this thing works, and that's kinda related.

johannes

--=-OjoYU17FAxYiF4nQmC4u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+ULCAAoJEODzc/N7+QmaCwAP/2lB2b4pN0HVeICrE4XVTKIC
xvLN1WvekpwvTkMU3yGX4pKrywsG5U3MMNakVzVmwpLoG+IaHF9GsRwX08MnwcjQ
EwTK4hCUFp6pz5q+qiUOwu09oXUK20nAcl4uApsqUd9C/HnBLjMbOsTt+DArwnAq
cgoNUqW1ryUH5orpfy5aHbar37DuvppgDrDFjsbdB9ZBdUAfnjSKtFFInfhnY8IP
/9o4pyg3MtcSDYRiEnO6A7EJcBxbRPiPsPfk0KjQqtB6vSjp8A0WHRaOXGooQZeZ
SKSi7yP4OK9EmSGFSAgnbEJ4wyl8VLa4oTKVlreA1tYpC12nu0LSOqGMaX5cl3WR
o7VkfyEQ5vXziPcggOiV+nXOQz1JJ2jILV6slDrTCxh4E283epVEwPPRsziI5fd2
kH+ehzY4eJfTxiMMOlOl9o+XiWjh1fiKgVcrz8mz48oS4MjtPW/vNC2jjvTODMBh
6eU0btg1xVMnaiV/N5n3uBuhsBTa2RCOlb9IcItsd1E3TCB5v1RXRFry6T/bAgut
H5rjBvJFhyqMzNZXptIEJsPJO4CoOQA/zU8FZv4b6U48ZVpbtI9t3ideZug28ADw
nB3u1yyrkQ0MRaKXFt9N/XE4HZABBHOw1pnfls16gOJXZXNE+D61SnkWxwhyXZzY
Y4VhbeixCTK6y/EMIRks
=Kgev
-----END PGP SIGNATURE-----

--=-OjoYU17FAxYiF4nQmC4u--


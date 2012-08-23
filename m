Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dd27218.kasserver.com ([85.13.142.250]:58272 "EHLO
	dd27218.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab2HWSwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 14:52:08 -0400
Received: from hermes.localnet (p4FD7B460.dip.t-dialin.net [79.215.180.96])
	by dd27218.kasserver.com (Postfix) with ESMTPSA id BADCC2EA09F5
	for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 20:52:05 +0200 (CEST)
From: Andreas Messer <andi@bastelmap.de>
To: linux-wireless@vger.kernel.org
Subject: Re: rt73usb not working since linux 3.4
Date: Thu, 23 Aug 2012 20:51:59 +0200
Message-ID: <2175505.7MyGkZApGB@hermes> (sfid-20120823_205215_885600_8DD7777A)
In-Reply-To: <1994279.EoVfTdb8RL@hermes>
References: <1364831.ftJE0YjeaD@proton> <20120626171835.GB32503@tuxdriver.com> <1994279.EoVfTdb8RL@hermes>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3936373.OXCd43NFtt"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3936373.OXCd43NFtt
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hey there,

Am Dienstag, 24. Juli 2012, 19:33:34 schrieb Andreas Messer:
> Hello Again,
> 
> Am Dienstag, 26. Juni 2012, 13:18:35 schrieb John W. Linville:
> > On Tue, Jun 26, 2012 at 06:03:56PM +0200, Andreas Messer wrote:
> > > Dear all,
> > > 
> > > updating my pc from linux kernel 3.3 to linux kernel 3.4 broke my wlan.

I have spent some more time on investigating the cause of the bug and found 
the problem. Actually I'm not sure which is the right solution. The problem is 
caused by the following points:

1) The rt73 hardware registers are not initialized before bringing the 
   corresponding network interface up ('ifconfig wlan0 up')

2) Bringing the interface up is not possible because of the kill switch

3) The GPIO input pin for the kill switch is still in 'output mode' (the
   default power on value), therefore the register will always read 
   'killswitch on'

So something like a deadlock. While looking through the code, I have seen, 
that the whole rt2xx driver uses here the same concept, that the hardware 
register initialization and firmware-download does not happen before the
interface is brought up. Im not sure if that is the right concept, shouldn't 
be the hardware initialized properly on loading the driver already? I mean, if 
values are read from the hardware in order to e.g. read the kill switch state 
shouldn't bethe hardware in a defined state before that? Anyway, it would be 
possible to solve this bug easily by only setting up the correct value of the 
CSR13 register right after reading the eeprom. For simple testing I have 
written the correct gpio mask to CSR13 using the debugfs interface and the 
wlan interface immediately was brought up and connected successfully with my 
Network.

So which is the right solution? I could make & test a patch for the simple 
solution easily.

Cheers
Andreas 
--nextPart3936373.OXCd43NFtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlA2e9MACgkQkLO6qowrr1HvMQCgtVhqzzAqe13vj3pIjSGQEZpK
pKwAnRxtEf5d7B2Xya9GmtqGj0dqkkZC
=LiGB
-----END PGP SIGNATURE-----

--nextPart3936373.OXCd43NFtt--


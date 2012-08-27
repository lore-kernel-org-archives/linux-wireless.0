Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dd27218.kasserver.com ([85.13.142.250]:58053 "EHLO
	dd27218.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2H0Qd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 12:33:59 -0400
From: Andreas Messer <andi@bastelmap.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt73usb not working since linux 3.4
Date: Mon, 27 Aug 2012 18:33:48 +0200
Message-ID: <4808588.cxLuFoSN6l@proton> (sfid-20120827_183403_172070_EBB94C36)
In-Reply-To: <503A6980.6070004@gmail.com>
References: <1364831.ftJE0YjeaD@proton> <2175505.7MyGkZApGB@hermes> <503A6980.6070004@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1464277.3rY7Abp2KK"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1464277.3rY7Abp2KK
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hey Gertjan,

Am Sonntag, 26. August 2012, 20:22:56 schrieb Gertjan van Wingerde:
> Hi Andreas,
> 
> On 08/23/12 20:51, Andreas Messer wrote:
> > Hey there,
> > 
> > Am Dienstag, 24. Juli 2012, 19:33:34 schrieb Andreas Messer:
> >> Hello Again,
> >> 
> >> Am Dienstag, 26. Juni 2012, 13:18:35 schrieb John W. Linville:
> >>> On Tue, Jun 26, 2012 at 06:03:56PM +0200, Andreas Messer wrote:
> >>>> Dear all,
> >>>> 
> >>>> updating my pc from linux kernel 3.3 to linux kernel 3.4 broke my wlan.
> > 
> > I have spent some more time on investigating the cause of the bug and
> > found
> > the problem. Actually I'm not sure which is the right solution. The
> > problem is caused by the following points:
> > 
> > 1) The rt73 hardware registers are not initialized before bringing the
> > 
> >    corresponding network interface up ('ifconfig wlan0 up')
> > 
> > 2) Bringing the interface up is not possible because of the kill switch
> > 
> > 3) The GPIO input pin for the kill switch is still in 'output mode' (the
> > 
> >    default power on value), therefore the register will always read
> >    'killswitch on'
> > 
> > [...] 
> [...]
> The reason why we do most of the initialization at interface up is that
> that is the earliest possible time we can get the firmware image from
> userspace. A lot of the register programming we have to do for
> initialization depend on the firmware being uploaded and running, hence
> we initialize most at interface up time.
> [...]

Thanks for that explanation. Didn't know that about the firmware.

> Find attached a patch that does this for all the rt2x00 devices. I hope
> you are able to test whether this patch fixes the problem for you.

Yep, the patch works fine for me. (Tested on latest git snapshot)

Cheers
Andreas
--nextPart1464277.3rY7Abp2KK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlA7oXMACgkQkLO6qowrr1EbYQCdHl0H9qyms6zWkAdLlUwyVV38
BxcAoNOZgVTkZOUBtWnmUOohPBA12ndz
=9gqC
-----END PGP SIGNATURE-----

--nextPart1464277.3rY7Abp2KK--


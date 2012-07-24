Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dd27218.kasserver.com ([85.13.142.250]:33304 "EHLO
	dd27218.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2GXRdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 13:33:51 -0400
Received: from hermes.localnet (p4FD7952E.dip.t-dialin.net [79.215.149.46])
	by dd27218.kasserver.com (Postfix) with ESMTPSA id 2B7162EA1831
	for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 19:33:49 +0200 (CEST)
From: Andreas Messer <andi@bastelmap.de>
To: linux-wireless@vger.kernel.org
Subject: Re: rt73usb not working since linux 3.4
Date: Tue, 24 Jul 2012 19:33:34 +0200
Message-ID: <1994279.EoVfTdb8RL@hermes> (sfid-20120724_193355_407764_3CA77BA8)
In-Reply-To: <20120626171835.GB32503@tuxdriver.com>
References: <1364831.ftJE0YjeaD@proton> <20120626171835.GB32503@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1778129.Mby04e7a8Q"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1778129.Mby04e7a8Q
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hello Again,

Am Dienstag, 26. Juni 2012, 13:18:35 schrieb John W. Linville:
> On Tue, Jun 26, 2012 at 06:03:56PM +0200, Andreas Messer wrote:
> > Dear all,
> > 
> > updating my pc from linux kernel 3.3 to linux kernel 3.4 broke my wlan.
> > I'm
> > using rt2571 based wlan module from qcom: LR802UKG, which is wired to an
> > internal usb port of my media center pc. The rfkill switch is hardwired to
> > make wlan active all the time. This setup is (almost) properly working
> > since about three years now. (If i ignore the occasional
> > vendor_request_error things)
> > The wlan device now refuses to go
> > online, saying that the kill switch is active, which of course can not be
> > as it is working with linux kernel 3.3.
> > [...]
> > So, what can I do to track down the problem?
> 
> Andreas,
> 
> Hmmm...well, perhaps you can start by doing a git bisect to narrow-down
> the commit that started this problem for you?  It may take serveral
> iterations, if you can only narrow it down to 3.3 working and 3.4 not
> working.  But, at least that should point us in the right direction.
> 
> John

first of all, sorry for the long delay. After some hours of compiling and 
checking, I have found the following things: The problem is introduced 
somewhere between v3.3.8 and v3.4, actually the commit 7e29629 already shows 
the problem. So range is v3.3.8...7e29629. I thing there is something wrong 
with initialization of the chip because of the following behaviour: If I boot 
from power-off into 7e29629 the kill switch reports to be in state 1 
(/sys/../hard = 1). If I first boot into 3.3.8 and afterwards re-boot into 
7e29629, the kill switch reports to be in state 0 and the WLAN connection 
builds up properly.
Hope that helps somehow.

Cheers,
Andreas
--nextPart1778129.Mby04e7a8Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlAO3HUACgkQkLO6qowrr1GjTgCgmHBcqJVbD9auMjH9D1ePVhos
JFEAn0dPCA0CcogSNhZvWhd1KaZaEcl/
=ddCT
-----END PGP SIGNATURE-----

--nextPart1778129.Mby04e7a8Q--


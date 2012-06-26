Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dd27218.kasserver.com ([85.13.142.250]:51440 "EHLO
	dd27218.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab2FZQLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 12:11:42 -0400
Received: from proton.localnet (p4FD79DFA.dip.t-dialin.net [79.215.157.250])
	by dd27218.kasserver.com (Postfix) with ESMTPSA id D9AB12EA188C
	for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 18:04:01 +0200 (CEST)
From: Andreas Messer <andi@bastelmap.de>
To: linux-wireless@vger.kernel.org
Subject: rt73usb not working since linux 3.4
Date: Tue, 26 Jun 2012 18:03:56 +0200
Message-ID: <1364831.ftJE0YjeaD@proton> (sfid-20120626_181146_731057_B582BF78)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3020572.pXkr0TspJv"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3020572.pXkr0TspJv
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Dear all,

updating my pc from linux kernel 3.3 to linux kernel 3.4 broke my wlan. I'm 
using rt2571 based wlan module from qcom: LR802UKG, which is wired to an 
internal usb port of my media center pc. The rfkill switch is hardwired to 
make wlan active all the time. This setup is (almost) properly working since 
about three years now. (If i ignore the occasional vendor_request_error 
things)
When I use kernel 3.4., i get a lot of additional devices reported by the 
kernel - three leds and a rfkill switch which have not been there before. (or 
at least I did not notice them) The wlan device now refuses to go online, 
saying that the kill switch is active, which of course can not be as it is 
working with linux kernel 3.3. Furthermore, the driver reports three leds, but 
my wlan device has only one, so probably a bad eeprom? i dont know...
Anyway, I noticed, that when I set the radio led to brightness 255, which 
takes a lot of time and gives me some vendor_request_errors, the rfkill switch 
gets turned off (sys/class/rfkill/../hard = 0). Unfortunately, this doesn't 
help to bring the interface online: After doing that I get frequent 
vendor_request_failed messages, even the PC becomes stuck on shutdown. 
(Probably NetworkManager waiting for something...)
So, what can I do to track down the problem?

Cheers,
Andreas
--nextPart3020572.pXkr0TspJv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAk/p3XAACgkQkLO6qowrr1E9XQCfffimhVTIYV8OAO+GSMt8hW20
nTIAn2ixuVuFTaauQp9d3s8S7VjM7+q4
=gHGg
-----END PGP SIGNATURE-----

--nextPart3020572.pXkr0TspJv--


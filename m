Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:53453 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194AbXCQHUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 03:20:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cbit.net.au (Postfix) with ESMTP id 15F0C1080AD
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 18:20:38 +1100 (EST)
Received: from mail.cbit.net.au ([127.0.0.1])
	by localhost (betty [127.0.0.1]) (amavisd-new, port 10024) with LMTP
	id 27417-02-13 for <linux-wireless@vger.kernel.org>;
	Sat, 17 Mar 2007 18:20:37 +1100 (EST)
Received: from keitarou.bubblesworth.net (unknown [202.55.155.91])
	by mail.cbit.net.au (Postfix) with ESMTP id 66A46108077
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 18:20:37 +1100 (EST)
Date: Sat, 17 Mar 2007 18:20:32 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and IPv6 Duplicate Address Detection (Was: prism54pci fails to read eeprom on PowerPC, then bugs in pci code)
Message-ID: <20070317072032.GC5954@keitarou>
References: <20070317034607.GA1522@keitarou> <200703170037.14875.flamingice@sourmilk.net> <1174107032.17023.14.camel@dv> <20070317065242.GB5954@keitarou>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KN5l+BnMqAQyZLvT"
In-Reply-To: <20070317065242.GB5954@keitarou>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--KN5l+BnMqAQyZLvT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 17, 2007 at 05:52:43PM +1100, Paul TBBle Hampson wrote:
> Mar 17 17:47:00 su kernel: wlan1: duplicate address detected!

OK, I've confirmed that I still get the above with both dadwifi and
bcm43xx-mac80211

A tcpdump indicates that my laptop sees its own neighbour-announce come
back, and assumes that's a different machine sending it, failing the
duplicate address detection.

A tcdump against the ethernet device (or bcm43xx from 2.6.20) does not
see the neighbour-announce come back, and so passes the duplicate
address detection, and gets an autoconfig IPv6 address.

I thought it might be the lack of IFF_BROADCAST which was fixed a while
ago, but it's still there.

kernel 2.6.20 from debian, patched with get_order() fix from 2.6.20.2
modular mac80211 stack from intel's 4.0.4 tarball, patched into kernel
bcm43xx-mac80211 from wireless-dev
dadwifi from madwifi.org subversion repository

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.Com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--KN5l+BnMqAQyZLvT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+5bAexDuohKLFuARAmxGAJ9rNObAgiR6GLsuwhJXxdYQrRFH2wCeIGs8
RjnQ+OwbCjbPQjSlpTPOJ8E=
=CEvl
-----END PGP SIGNATURE-----

--KN5l+BnMqAQyZLvT--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

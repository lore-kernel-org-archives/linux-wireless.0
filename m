Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58161 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1HHMKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 08:10:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QqOen-00068S-CK
	for linux-wireless@vger.kernel.org; Mon, 08 Aug 2011 14:10:09 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 14:10:09 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 14:10:09 +0200
To: linux-wireless@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: WDS link predictably and reproducibly dropping packets
Date: Mon, 08 Aug 2011 08:04:30 -0400
Message-ID: <j1ojcf$3t4$1@dough.gmane.org> (sfid-20110808_141013_498124_575BCA52)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA08568B533416A1D8C219A3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA08568B533416A1D8C219A3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a WDS link set up between two OpenWRT routers (both running linux
2.6.32.27) which is working 99.5% of the time.

What I have observed though is that for a certain traffic pattern, some
packets from the WDS "client" to the WAP will be dropped.  And the same
packets are dropped every time for the same, repeated traffic pattern.

To demonstrate, observe the following two tcpdump outputs.  The first
one is on the wlan0 interface of the WAP that has the machine 10.75.22.8
attached to it:

07:52:22.384590 ARP, Request who-has 10.75.22.3 tell 10.75.22.7, length 4=
6
07:52:22.386280 ARP, Reply 10.75.22.3 is-at 00:1f:c6:c4:92:6a, length 46
07:52:50.886934 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:50.898629 IP 10.75.22.7.5061 > 10.75.22.8.5060: SIP, length: 405
07:52:51.237342 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:51.248542 IP 10.75.22.7.5060 > 10.75.22.8.5060: SIP, length: 406
07:52:51.886604 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:51.898423 IP 10.75.22.7.5061 > 10.75.22.8.5060: SIP, length: 405
07:52:52.236755 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:52.248264 IP 10.75.22.7.5060 > 10.75.22.8.5060: SIP, length: 406
07:52:52.889511 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:52.900097 IP 10.75.22.7.5061 > 10.75.22.8.5060: SIP, length: 405
07:52:53.237169 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:53.248262 IP 10.75.22.7.5060 > 10.75.22.8.5060: SIP, length: 406
07:52:53.886426 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:53.898475 IP 10.75.22.7.5061 > 10.75.22.8.5060: SIP, length: 405
07:52:54.236719 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:54.248371 IP 10.75.22.7.5060 > 10.75.22.8.5060: SIP, length: 406
07:52:55.893321 ARP, Request who-has 10.75.22.8 tell 10.75.22.7, length 4=
6
07:52:55.894993 ARP, Reply 10.75.22.8 is-at 00:1f:c6:c4:92:6a, length 46
07:53:03.900624 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:53:03.911426 IP 10.75.22.7.5061 > 10.75.22.8.5060: SIP, length: 405
07:53:04.251006 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:53:04.261785 IP 10.75.22.7.5060 > 10.75.22.8.5060: SIP, length: 406

This second dump is the WDS client which has 10.75.22.7 attached to it.

07:52:22.395846 ARP, Request who-has 10.75.22.3 tell 10.75.22.7, length 4=
6
07:52:22.396162 ARP, Reply 10.75.22.3 is-at 00:1f:c6:c4:92:6a, length 46
07:52:50.896432 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:51.246838 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:51.896097 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:52.246233 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:52.895512 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:53.246649 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:53.895898 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:52:53.909528 IP 10.75.22.7.5061 > 10.75.22.8.5060: SIP, length: 405
07:52:54.246180 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:52:54.259596 IP 10.75.22.7.5060 > 10.75.22.8.5060: SIP, length: 406
07:52:55.904269 ARP, Request who-has 10.75.22.8 tell 10.75.22.7, length 4=
6
07:52:55.904553 ARP, Reply 10.75.22.8 is-at 00:1f:c6:c4:92:6a, length 46
07:53:03.909995 IP 10.75.22.8.5060 > 10.75.22.7.5061: SIP, length: 546
07:53:03.922490 IP 10.75.22.7.5061 > 10.75.22.8.5060: SIP, length: 405
07:53:04.260380 IP 10.75.22.8.5060 > 10.75.22.7.5060: SIP, length: 548
07:53:04.272948 IP 10.75.22.7.5060 > 10.75.22.8.5060: SIP, length: 406

10.75.22.8 and 10.75.22.3 are the same machine, just using multiple IP
addresses as "service" addresses.

So as you can see in the first two packets of both dumps, there is a
successful round trip across the WDS link.  A number of seconds later,
10.75.22.8 sends some packets across the WDS link to 10.75.22.7 which
are all successfully received across the link and 10.75.22.7 responds to
them, trying to send packets back to 10.75.22.8 but those fail to reach
the WAP where 10.75.22.8 is.  This happens 6 times, and then magically,
the 7th time, the return traffic makes it and then it continues to make
it fully round trip until this pattern starts all over again,

It is worth mentioning that this period of time where those packets are
being dropped, other traffic between those two hosts is wholly
successful.  While this packet dropping is happening, 10.75.22.3 is
successfully pinging 10.75.22.7 at a 1 second interval and not a single
ICMP packet is dropped.

Any thoughts as to what is going on with this specific traffic being
dropped?

Thanx,
b.


--------------enigBA08568B533416A1D8C219A3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4/0M4ACgkQl3EQlGLyuXAuFACgvkctsnPcHw6oiBZgLzhR3DMZ
WE0AoMxLvsuJZCxi11BOdaeO3bxW4uiU
=6HFH
-----END PGP SIGNATURE-----

--------------enigBA08568B533416A1D8C219A3--


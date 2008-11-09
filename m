Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbYKIJDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 04:03:55 -0500
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Shaddy Baddah <shaddy_baddah@hotmail.com>
In-Reply-To: <1226220992.3614.16.camel@johannes.berg> (sfid-20081109_095632_336911_F61525F4)
References: <4902DEBB.3050205@hotmail.com>
	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>
	 <200810251325.07916.mb@bu3sch.de>
	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com>
	 <1226149894.3610.8.camel@johannes.berg>  <491653A6.20705@hotmail.com>
	 <1226220992.3614.16.camel@johannes.berg>
	 (sfid-20081109_095632_336911_F61525F4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F1TwtxbyhoobVSKzW1IS"
Date: Sun, 09 Nov 2008 10:03:58 +0100
Message-Id: <1226221438.3614.20.camel@johannes.berg> (sfid-20081109_100411_082442_8D83DAEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F1TwtxbyhoobVSKzW1IS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-09 at 09:56 +0100, Johannes Berg wrote:

> I think you forgot to attach the patch.

Sorry, I missed your second mail. (btw, if you generate patches with -p
in diff arguments it helps a bit reading them)

Ok so it looks like the buffer you're getting is unaligned. This is
strange, but I'm too unfamiliar with the code. It seems that there's the
PLCP 5 byte header in front. Well, try the printk I asked for, because
at that point zd1211 should avoid "leaking" the alignment problem.

johannes

--=-F1TwtxbyhoobVSKzW1IS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFqd6AAoJEKVg1VMiehFYjPEP/RHiun3+FrYP8SCICMu9h6PR
mncGFR5XVjpAMB+PHZvcawAanADMkoDD4j7hHNFS/rLBFsIODN1n57z3iVnPHCc9
35Nc8a1DKMF9kVxWvRGrFceW70oGqc/PmtbYOawUSP3ibtW0wS9FodE8kJBCWirr
JyHSaN8l+833rGlEesTqa9Mz/Y+CFIBtDrpr3mUxAxA8kZhAPPBKiJ9cHtNCZRDD
jnOXOpk3yp+rp2m8yN93JcJmn+lgH1Vv+kq4VDwQ1FNdhna2gqzvZDT1GWJ9648U
RzscXiYotWnLDWlohvu1KaNPc5ZVTFvgbl8qyeHy8gl9IdfTvc3p3udLyAEm1NUx
6F3TYV98hHEG6p4JZTqsnr0nJDxSKOXXjLBZgsTI4NlB5ajETd1TutMdAtYOCQ9H
zuCswpuitj8BML5bzyUXm0xAuTboALXKv2p12WqKqBNUNf3mwCM8VjOJkTcqukco
U3Y111Rorhwq/zWRBB6gilEhj+qcPIbjlbLdbs/P15nP21oF6+RdqsaoFhsFUD2T
oJathrt+Bt7jexn0TkYzsl/VB6LKvHq4BvMbB2GB6yzQ25XUq7pbO0z2vC8cAO7I
ie64G718F/H5FFjP+oTRFsXh8cICA8R6ptXPTXKN5j5KI1qX0rTEwRD5WxSpqtze
+UULMVYu+QEMZeduP3jM
=oQMm
-----END PGP SIGNATURE-----

--=-F1TwtxbyhoobVSKzW1IS--


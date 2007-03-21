Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934013AbXCVKEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:04:39 -0400
Subject: Re: [PATCH 0/4] Try #5: Radiotap on Monitor Mode interfaces for rx  and tx
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070320103955.600509703@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jfgMJmcyyTaUmyonbLH/"
Date: Wed, 21 Mar 2007 19:10:37 +0100
Message-Id: <1174500637.3944.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jfgMJmcyyTaUmyonbLH/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-20 at 10:39 +0000, andy@warmcat.com wrote:

> For injecting packets, the you issue a packet using libpcap or a SOCK_PAC=
KET
> socket down an interface to the wireless device that is in Monitor Mode.

Ok so people don't want to have this in cfg80211, all the better for me
since it's less work.

I urge you to solve the issues with this injection interface, we've
established that you can use packet filters to grab only management
frames but monitor interfaces definitely still interact very badly with
power management, and when the hardware has a BSS filter then this will
also be disabled with a monitor interface (if monitor during operation
is supported) which again puts more load on the host.

I have previously suggested to use the IFF_PROMISC bit for this, but
this will also need good driver/stack API since currently drivers that
support monitor during operation will just turn off BSS filters and such
when a monitor interface is added. That will have to be changed in
drivers as well.

Also, and I'm going to reply to your patches as well, this is not
something that should be restricted to mac80211 since cfg80211
generically supports virtual interfaces and anybody could in theory use
a userspace MLME even with a full-mac card given a special no-management
firmware mode. Hence, this should be documented for cfg80211 users.

Please work out these issues before adding this interface to the kernel.

johannes

--=-jfgMJmcyyTaUmyonbLH/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAXUd/ETPhpq3jKURAmLKAKCNQ9KWBUllg6NR7lL65GWTSF4nCgCfUHPl
+pgfWzBLiw/qci2euqIpuBI=
=N1nA
-----END PGP SIGNATURE-----

--=-jfgMJmcyyTaUmyonbLH/--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27131 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750712AbXGCEJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 00:09:31 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
Date: Mon, 2 Jul 2007 21:09:19 -0700
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707022235.38791.mb@bu3sch.de>
In-Reply-To: <200707022235.38791.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8053767.VcrBqebTsS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707022109.23527.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8053767.VcrBqebTsS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 02 July 2007 13:35, Michael Buesch wrote:
> +	netif_tx_lock_bh(mdev);
>  	for (i =3D 0; i < hw->queues; i++)
>  		ieee80211_stop_queue(hw, i);
> +	netif_tx_unlock_bh(mdev);
Well, looks like this will break stopping all tx queues from the tx handler=
 by=20
deadlocking. It may be useless for bcm43xx to call ieee80211_stop_queue, bu=
t=20
there are other drivers which rely on it.

I would prefer to guarantee that the stack will not allow any more frames t=
o=20
be queued before calling stop/remove_interface on the last virtual interfac=
e.=20
That should be true right now since the master interface is taken down befo=
re=20
calling stop and remove_interface, so ieee80211_stop_queues shouldn't be=20
necessary on device down. If this isn't the case, it should be fixed.

Of course, the ieee80211_stop_queue deadlock should still get fixed=20
eventually..

=2DMichael Wu

--nextPart8053767.VcrBqebTsS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGicvzT3Oqt9AH4aERAn1RAJ44+yJtR6aYJaIhPVuXmW6ile7jjgCeIpfS
mLCp2MFNKStiqVraiMgtQiU=
=TkiJ
-----END PGP SIGNATURE-----

--nextPart8053767.VcrBqebTsS--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

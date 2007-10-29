Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from duky.chevillot.net ([213.41.185.64]:33589 "EHLO
	gaia.chevillot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbXJ2NGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 09:06:16 -0400
Date: Mon, 29 Oct 2007 13:55:41 +0100
From: Guillaume Chevillot <guillaume@chevillot.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap <hostap@shmoo.com>, Chuck Tuffli <CTuffli@dspg.com>,
	Guillaume Chevillot <guillaume@chevillot.net>,
	Alexander Kotelnikov <sacha@myxomop.com>
Subject: Re: [FYI] hostapd state with mac80211 on linux
Message-ID: <20071029125541.GA4304@chevillot.net> (sfid-20071029_130625_292586_78932220)
References: <1193338400.4406.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
In-Reply-To: <1193338400.4406.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> hostapd works with
>  - kernel 2.6.24-rc1
>  - plus my patches from http://johannes.sipsolutions.net/patches/kernel/all/
>  - plus the commit 5c58298c2536252ab95aa2b1497ab47eb878ca5d from net-2.6
>    ([NETLINK]: Fix ACK processing after netlink_dump_start)
>  - my hostapd patches from http://johannes.sipsolutions.net/patches/hostap/all/
I tried with a kernel downloaded from git (so with the netlink commit
already merge into) without success.

Some code of the old interface has been removed so I had to apply some
of your patches manually and tried to reinsert the removed code to be able
to compile. I did this quickly so I suppose I forgot to re-add some
code.

After compiling kernel and hostapd, hostapd complains the same that
before with this error message more :
rmdir[ctrl_interface]: No such file or directory

And stops here.

So I think, you will have to do one more patch for the rc2, ...

Tell me if I am wrong, but your patches "just" keep the old interface,
master mode code and others previously removed. So, new code will have
to be done to re-enable master mode and a driver_mac80211.c (rather than
a driver_deviscape.c) will have to be done for hostapd ?

Regards,
Guillaume

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJdhNPULMpKkMZuMRApEhAJ9lPtdX9Y/iNaNbbFB3sNzwMEy5nQCgskid
NMwHrmv15SVBLbx7r6GjKHY=
=GIk4
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--

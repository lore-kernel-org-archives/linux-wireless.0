Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:38868 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762258AbXFAUhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 16:37:19 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 13:36:54 -0700
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <200706011204.23666.flamingice@sourmilk.net> <46605814.1090806@linux.intel.com>
In-Reply-To: <46605814.1090806@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3486580.e1rQiJ6WLn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706011337.00087.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3486580.e1rQiJ6WLn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 01 June 2007 10:32, James Ketrenos wrote:
> We definitely need to wake the queue outside of open/stop/tx.  If you stop
> the queue due to the HW ring being full, you won't be able to wake the
> queue until the HW has asynchronously freed a Tx slot.
>
Yeah, there are other safe (and correct) places like interrupt handlers. If=
=20
you're not seeing hard freezes with a lot of data transfer, you're probably=
=20
fine. I still need to investigate why bcm43xx can't do it.. I'm not sure=20
what's going on yet.

=2DMichael Wu

--nextPart3486580.e1rQiJ6WLn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGYINsT3Oqt9AH4aERAmhvAKCZGVHVivwnduz/XgqYTG0WCaePCgCg0Gfo
qGC/La7yA+yaQQQ2gC/nsxg=
=8QKR
-----END PGP SIGNATURE-----

--nextPart3486580.e1rQiJ6WLn--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

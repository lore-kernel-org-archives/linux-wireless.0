Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61934 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbXD0Ob6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 10:31:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Date: Fri, 27 Apr 2007 10:27:40 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704262023.52833.flamingice@sourmilk.net> <46319E31.4090101@linux.intel.com>
In-Reply-To: <46319E31.4090101@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1681113.Z7GisItH0B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704271027.44363.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1681113.Z7GisItH0B
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 27 April 2007 02:54, James Ketrenos wrote:
> Anyway, I ran a quick test of using hw_scan enabled and disabled on a
> system with 15 active and 17 passive channels.
>
> 	hw scan: 2.2s
> 	sw scan: 4.7s
>
> So the SW scan wasn't the 10s that I stated before (although it sure felt
> like 10s before I ran it with 'time')  But anyway... the hw scan is
> currently beating out sw scanning by ~54%, at least here.
>
Ok. Let's try interpreting these numbers.

The current settings in mac80211 give each active scan channel 1/33rd of a=
=20
second to send a probe request and another 1/33rd of a second to listen for=
=20
any replies. That means, at the very minimum, an active scan will take a bi=
t=20
over 60 ms to complete per channel. For passive scans, each channel gets=20
1/5th of a second, so that's 200 ms right there. With all this, we get:

=2E06 (s/channel) * 15 channels + .2 (s/channel) * 17 channels =3D 4.3 s

So, 91% of the time that software scan takes is just.. waiting. HW scan=20
simply "wins" by default because it doesn't wait as long. These numbers say=
=20
nothing about the actual overhead of using SW vs. HW scanning. Can you=20
provide more details on the delays that iwlwifi uses so we can do a proper=
=20
comparison?

=2DMichael Wu

--nextPart1681113.Z7GisItH0B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMghgT3Oqt9AH4aERAsTFAKDViKL3bsP/rK28ja/6sMOkzdFU8gCggpk/
93FL/1VpDe+to2plyHtQYuw=
=T1np
-----END PGP SIGNATURE-----

--nextPart1681113.Z7GisItH0B--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

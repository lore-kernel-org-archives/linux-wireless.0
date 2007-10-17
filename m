Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36739 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758412AbXJQDUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 23:20:22 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: make ieee802_11_parse_elems return void
Date: Tue, 16 Oct 2007 23:17:30 -0400
Cc: linux-wireless@vger.kernel.org
References: <1192588723322-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1192588723322-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1883843.kKTeMcvcgY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710162317.34856.flamingice@sourmilk.net> (sfid-20071017_042026_213331_8471ABFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1883843.kKTeMcvcgY
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 16 October 2007 22:38:43 John W. Linville wrote:
> Some APs send management frames with junk padding after the last IE.
> We already account for a similar problem with some Apple Airport
> devices, but at least one device is known to send more than a single
> extra byte.  The device in question is the Draytek Vigor2900:
>
> 	http://www.draytek.com.au/products/Vigor2900.php
>
> The junk in question looks like an IE that runs off the end of the
> frame.  This cause us to return ParseFailed.  Since the frame in
> question is an association response, this causes us to fail to associate
> with this AP.
>
> The return code from ieee802_11_parse_elems is superfluous.
> All callers still check for the presence of the specific IEs that
> interest them anyway.  So, remove the return code so the parse never
> "fails".
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Michael Wu <flamingice@sourmilk.net>

-Michael Wu

--nextPart1883843.kKTeMcvcgY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHFX7OT3Oqt9AH4aERAnd9AKCoK5F8GPMduW8b+s+HjZ4jThfAIQCcDQmL
9rvwWCKX5jroXEeko6EMFSE=
=uLjT
-----END PGP SIGNATURE-----

--nextPart1883843.kKTeMcvcgY--

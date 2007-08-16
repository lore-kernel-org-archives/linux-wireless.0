Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:38768 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752810AbXHPEu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 00:50:57 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 17/20] mac80211: avoid copying packets to interfaces that are down
Date: Wed, 15 Aug 2007 21:48:53 -0700
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
References: <20070815144920.135826000@sipsolutions.net> <20070815145048.965414000@sipsolutions.net>
In-Reply-To: <20070815145048.965414000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1623326.xXRjpqutYi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708152148.58436.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1623326.xXRjpqutYi
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 15 August 2007 07:49, Johannes Berg wrote:
> Is there a possibility of a race condition here? If the interface is
> brought down right after this check the SKB could be copied to that
> interface after the skb queue has been flushed.
>
Yeah. This can be avoided by holding a write lock on the subif lock while=20
flushing the skb queue. Not sure how much I like doing that, but it should=
=20
work.

=2DMichael Wu

--nextPart1623326.xXRjpqutYi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGw9c6T3Oqt9AH4aERApviAJ9Z5mO2i8WN6yRrLTYZQhT3ReWgBQCgpad8
LyHJ0MP0J4AbUCNLLvMqccw=
=cG3v
-----END PGP SIGNATURE-----

--nextPart1623326.xXRjpqutYi--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

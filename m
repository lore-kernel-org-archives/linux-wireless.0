Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25251 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753716AbXCQD6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 23:58:06 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
Date: Fri, 16 Mar 2007 23:57:18 -0400
Cc: Hong Liu <hong.liu@intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1174015698.3408.41.camel@devlinux-hong> <200703161328.41006.flamingice@sourmilk.net> <1174103177.3026.8.camel@localhost.localdomain>
In-Reply-To: <1174103177.3026.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2047727.n9sggcVzvy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703162357.22669.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2047727.n9sggcVzvy
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 16 March 2007 23:46, Dan Williams wrote:
> I think you're misreading the patch?  It looks correct to me.  The
> second check for (erq->flags & IW_ENCODE_RESTRICTED) should ensure that
> Shared Key is only selected when the userspace program requested it.
>
This breaks authentication algorithm fallback for sure.

> Not quite.  Somewhere along the line WEXT turned ENCODE_RESTRICTED into
> the selector for Shared Key, while ENCODE_OPEN is Open System.  Arguably
> there's a larger need to specifying auth mode than rejecting unencrypted
> associations.  Most drivers do it this way, with the exception of
> madwifi because they like to be irritatingly different.  Nobody ever
> really used the 'don't accept unencrypted' thing anyway in the old days,
> plus ENCODEEXT has a separate flag for this.
>
Even if it got redefined along the way, mac80211 has no need for that=20
particular definition since it can automatically cycle between authenticati=
on=20
algorithms. Besides, "its meaning depends on the card used" according to th=
e=20
iwconfig man page.

> So I think the patch is correct.  Ideally all this gets fixed and all
> the overloaded meanings go away with cfg80211 :)
>
> Acked-by: Dan Williams <dcbw@redhat.com>
>
NACK. It is not useful and if implemented, gives the user an unnecessary=20
choice that can only cause more problems.

=2DMichael Wu

--nextPart2047727.n9sggcVzvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF+2ciT3Oqt9AH4aERAmjOAKCZGJxvmvzsf8dEFxI5ClnHmjH1CACgi0Tj
x7aKM5sPtcQ1u+D8Heri/Wc=
=/6cZ
-----END PGP SIGNATURE-----

--nextPart2047727.n9sggcVzvy--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

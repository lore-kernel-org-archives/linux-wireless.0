Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:56262 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933345AbXCQE6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 00:58:44 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
Date: Sat, 17 Mar 2007 00:57:51 -0400
Cc: Hong Liu <hong.liu@intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1174015698.3408.41.camel@devlinux-hong> <200703162357.22669.flamingice@sourmilk.net> <1174106316.3026.19.camel@localhost.localdomain>
In-Reply-To: <1174106316.3026.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1890557.HEnJBvgkg0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703170058.01020.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1890557.HEnJBvgkg0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 17 March 2007 00:38, Dan Williams wrote:
> On Fri, 2007-03-16 at 23:57 -0400, Michael Wu wrote:
> > On Friday 16 March 2007 23:46, Dan Williams wrote:
> > > I think you're misreading the patch?  It looks correct to me.  The
> > > second check for (erq->flags & IW_ENCODE_RESTRICTED) should ensure th=
at
> > > Shared Key is only selected when the userspace program requested it.
> >
> > This breaks authentication algorithm fallback for sure.
>
> Well, then it's broken in most of the non mac80211 drivers then.
>
Why is that? The reason this breaks mac80211 is because auth_algs is a=20
bitfield which indicates what authentication algorithms can be used. This=20
patch makes it so that if a user chooses an authentication algorithm, that =
is=20
the only one that will ever be used.

> Well, if mac80211 can cycle (is this like airo's auto_wep?) then I guess
> we don't care about the auth mode.  As long as we don't break userspace
> programs that try to set the auth mode, I'm fine with that.
>
mac80211 should just ignore the bits. Airo's auto_wep appears to cycle thro=
ugh=20
different encryption keys while mac80211 does not.

=2DMichael Wu

--nextPart1890557.HEnJBvgkg0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF+3VYT3Oqt9AH4aERAtc9AJ9Dw6LFY4TJmK9/dgvo/7xKA80X3wCfVDf4
xOT8kb0ShkmcodfOio4MZAQ=
=pFuw
-----END PGP SIGNATURE-----

--nextPart1890557.HEnJBvgkg0--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52434 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754913AbXEXHlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 03:41:39 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
Date: Thu, 24 May 2007 00:39:53 -0700
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
References: <20070514051526.GA25582@mail.intel.com> <200705232342.31882.flamingice@sourmilk.net> <1179992075.6150.30.camel@debian.sh.intel.com>
In-Reply-To: <1179992075.6150.30.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2144698.i31T9CEaG9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705240039.57564.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2144698.i31T9CEaG9
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 24 May 2007 00:34, Zhu Yi wrote:
> > > + if (dls_link_status(&sdata->u.sta, hdr.addr1) =3D=3D DLS_STATUS_OK){
> >
> > How is this line suppose to work? I don't see hdr.addr1 initialized at
> > any point before this.
>
> DLS must be setup before it can be used. The addr1 is inserted into the
> dls hash table when the QSTA received a successful DLS response or
> accepted a DLS request.
>
AFAICT, dls_link_status uses the second argument to look up the dls entry f=
or=20
the destination address. At this point, hdr.addr1 is not initialized to=20
anything, so something is wrong here.

=2DMichael Wu

--nextPart2144698.i31T9CEaG9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGVUFNT3Oqt9AH4aERApCcAJ0WawW5EZfzSEDm+GPenY9lmcH/awCgxclK
1jOwVubgTXdpN5dqu0bI8/A=
=eEFv
-----END PGP SIGNATURE-----

--nextPart2144698.i31T9CEaG9--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

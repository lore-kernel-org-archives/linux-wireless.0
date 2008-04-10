Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537AbYDJPrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 11:47:39 -0400
Subject: Re: [PATCH, take 3] libertas: convert RSSI to a direct command
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <20080410154341.GB6741@dmt> (sfid-20080410_164056_881366_0CEE42F7)
References: <200803261021.48470.hs4233@mail.mn-solutions.de>
	 <1206653042.21106.10.camel@localhost.localdomain>
	 <20080401031530.GA14633@dmt>
	 <200804010848.48789.hs4233@mail.mn-solutions.de>
	 <20080410154341.GB6741@dmt> (sfid-20080410_164056_881366_0CEE42F7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kDvOZuPbG88IBd4iwETW"
Date: Thu, 10 Apr 2008 17:47:21 +0200
Message-Id: <1207842441.13354.9.camel@johannes.berg> (sfid-20080410_164746_538361_8D42ADCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kDvOZuPbG88IBd4iwETW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-10 at 12:43 -0300, Marcelo Tosatti wrote:
> On Tue, Apr 01, 2008 at 08:48:48AM +0200, Holger Schurig wrote:
> > > Won't this call block? You can't block in the get_wireless
> > > handler (it holds the rtnl lock). See wext_handle_ioctl.
> >=20
> > Yes, this blocks.
> >=20
> > So you mean that when I cannot get a current RSSI value at this=20
> > time I have to re-use some old value?
>=20
> All I mean is that get_wireless_stats should not schedule() because it
> holds the rtnl_lock. You get ugly hangs doing that.

Of course you can schedule with the rtnl held. It's a mutex, after all.

johannes

--=-kDvOZuPbG88IBd4iwETW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/42h6Vg1VMiehFYAQLbmQ//ZZRQRRJbcz+cUD0WtQe4uNP204fROTBb
q9uUrrSqUA97zczLW7CvhM15XcS4lyQofdODGFQ9okYkBs3fUj0lmm7QKxrS0flV
ZQG4pUnmKNFsY5ciCXwm7inej/PrNVU82fuxWlQ47C/sfTG+ZdakI1Bi+Q13Ysyl
JTeV0vro2OgnHiifJoM+RfL3Rfw/ZPgH/HMt04iuSFx0F5GwV7v8ZJPYkXW8prCD
kCGZY3m8V6pTMjl0/as55co3v90JtBQHE6HqfdxdhzR4aFY5u6iKz39hcsmA07yc
KEP936rmRFTzqSPjdX9TK0sU86OG0TookVqvhTAFXTSuZNUUlgetSB5jWAv77a4h
TpAMm3Yv4GMiWFv57/P75C48VquGtj2yOpAebn8jn6EL5Up0L91ghOQOmT/W8Teb
2wDhRD1RFtiIhJ6N2xqrrxcExflsDexPs76m98Dpx/e2nTxYHeoSbkHw9RlG3VWZ
1b7xC29UnwQn5BONQBlipVYJbdUC249uZd6dIXm4xaNjlnYmdFYhrKpk1Nu4/mRU
qP0XdZvhGGax8BngRbnbbbI1e/P2SVfsFui8Qir5TPJUvC2erCnReRnSA6ZmD+cI
Ilf0trBdqKVggbqYkPxvyPmBU3M1lo+hmAxT1N+Peg7OSK60USOrYnUfANNw+JrF
VeBa2pEip3A=
=l22z
-----END PGP SIGNATURE-----

--=-kDvOZuPbG88IBd4iwETW--


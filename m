Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYJNV2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:28:21 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081014211912.GF3349@tuxdriver.com>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-haQ59EmlWF8TuIwPN0vG"
Date: Tue, 14 Oct 2008 23:27:42 +0200
Message-Id: <1224019662.3027.13.camel@johannes.berg> (sfid-20081014_232841_290207_EB710FAB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-haQ59EmlWF8TuIwPN0vG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 17:19 -0400, John W. Linville wrote:
> On Tue, Oct 14, 2008 at 11:15:57PM +0200, Johannes Berg wrote:
> > On Tue, 2008-10-14 at 16:35 -0400, John W. Linville wrote:
> >=20
> > > That doesn't sound like quite the correct behavior.  If a channel is
> > > excluded for regulatory reasons, then I suspect that should govern
> > > everyone.  But if one card just doesn't support a band, I don't see
> > > why any other cards should be limited by that.
> > >=20
> > > Did I miss something?
> >=20
> > Well, the thing is that the iwlwifi drivers pretend to know the
> > regulatory domain; thus when a single-band card registers the regulator=
y
> > domain, it gets set to just a domain with the single band.
>=20
> Ah, now I see what this is about...thanks!
>=20
> Should there be an "I make no representation of authority" flag in
> the regulatory maps?

The only reasonable solution I can come up with is have it make separate
hints for 2.4 and 5 GHz and then a single-band card won't say anything
about 5 GHz so the dual-band gets to set that part. But OTOH I don't see
a reasonable use-case for this whole thing so far---we really only added
this after discussions with Marcel at OLS so embedded systems can
function w/o crda, but who would build an embedded system with two
different cards like that?

johannes

--=-haQ59EmlWF8TuIwPN0vG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9Q7LAAoJEKVg1VMiehFYuwwP+weBFCyKnfWpxctjOn2p9gxL
kZyFiDKzBkfS1QJsala2VTsOnbO+JLTkPTVM9KFlYR78plCLkpgzfVuj+VWbO9h/
vHBPQG70x6X+n3phEYgOVZhsU5jIPC4A7777t+R6GDkNLBklYcOJpNyguvoW6sXS
rrjnPPMMeXOAYYoMt8rqsugJmCcva2SnAEdrsQ185QE1lMkGK9BSMXQerA4J2Imr
UWnZ3Zr8CTkKdquH9CjW2vUAlxA8Pj+tpWJUxmZTNhDliIkMd4pUsdQ/g0ztVWq+
+Awy6HugaQk10iYw3JpbFciYQ+0B6TM26+tgMDBTBpIZWhiVrRXmVU6W7i1v8s4B
K0BOb7P2O5RDWVgTVhRoYsQwv4PKX3J0ZExW5V5Jc04pC+MwfEBG30HL9CfsPDTk
ogs3zmArBRWAMa2oOkJguygV5wQMucRiWp1Yb+KCeE9vmHaHlqYeT8WtrhqZbLPP
qtyHvgfHExJ5wCzNViSLbhgvbVg5uX/9IsgCDD3HRS6iQ9wDqoSbqjObEvfDG7eb
8HeX7jJBtNq40LDfSAL83Cay6tPtgIFVeACCeorRHMD1adDQ2luRVoTwsJbCt3sc
9h1XzozkrCEXer7pWbjLBQ+rya6QeD4Q0FHRi52bnx7/yRP+Y1CVtCzwSL7gsKj/
VfyblwKhg7Jcc/WQnQ3f
=Y/3P
-----END PGP SIGNATURE-----

--=-haQ59EmlWF8TuIwPN0vG--


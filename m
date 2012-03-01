Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49090 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2CAG6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:58:05 -0500
Date: Thu, 1 Mar 2012 09:58:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/4] rndis_wlan: integer overflows in
 rndis_wlan_do_link_up_work()
Message-ID: <20120301065807.GG1003@mwanda> (sfid-20120301_075811_895306_32D50135)
References: <20120229063555.GC18031@elgon.mountain>
 <4F4DE009.7010808@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
In-Reply-To: <4F4DE009.7010808@bfs.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 29, 2012 at 09:21:29AM +0100, walter harms wrote:
> >  			resp_ie_len =3D le32_to_cpu(info->resp_ie_length);
> > +			if (resp_ie_len > CONTROL_BUFFER_SIZE)
> > +				resp_ie_len =3D CONTROL_BUFFER_SIZE;
> >  			if (resp_ie_len > 0) {
> >  				offset =3D le32_to_cpu(info->offset_resp_ies);
> >=20
>=20
>=20
> hi dan,
> the check below  "if (resp_ie_len > 0)" looks strange for an unsigned.
>=20

Good point.  I'll resend.

regards,
dan carpenter


--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTx3/AAoJEOnZkXI/YHqRY3IP/jmxr/N3sG3RVdQAY0cMD7xu
H6WmC4LZKxqF29I2lILe42g4MdmTsLasTnyS/qdsp+Na3YyUnMOPHMWSrqI83z4d
LTfxINxLnV2wkvN6gtTHzRIWnVtfzqUWkqxhPcSfU9ppF+uls3CcsAaROlELUm1V
RZ/CEl5YLhhgpA2KvO6+vjKmX5vYmh/Ihw1FYBEjy5wslt4Kl47TM01krBAKieaJ
MOip/dwiPN59LLk5OyEMnriCEKUksPpJp82aqdFN/+nKcVRTs97nrqt/J9WymJ4/
XKx+YM/Ijv9NBnLLbGloIdyOW4CxxnIPw3k3yMSTx+8tdz3nvip+97MNyRiizYku
YQ/kO2EHj+Edo0WjydNFAP4dLJIf+wEDu2G3r3BsBZSHAQ8v1eQF2aNZbtus4Av+
PY+jxjWXyP2MmQaWfmTmSYsS1Jgn0WskFfWlncCt132dvcM40qovBJbn7cNVPass
PJEwMJ1Ayly1LGFoCg2EmUKqtwhazYtLs4YY9ylZ6C5W7ppPnr68e4PMJbM/91uD
cmM1F3FeP1CgXEADpgxTeDyNWdfakrorW1Br97qv9xOkjer9U3c9PhPjf7noQdDy
mrKh84EBtUPnhtXP9EJZRkb5Hwq0sUC6D9GSbwjxMMxZFgYr5GwUEHw220ipDdJL
FXq8d+qrQL9e7TKO8z64
=3Wok
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--

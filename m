Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36469 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2AMKfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 05:35:31 -0500
Date: Fri, 13 Jan 2012 13:36:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ipw2x00: signedness bug handling frame length
Message-ID: <20120113103624.GK16258@mwanda> (sfid-20120113_113536_440601_34D976CD)
References: <20120112063449.GA2408@elgon.mountain>
 <20120113102908.GB2214@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XjbSsFHOHxvQpKib"
In-Reply-To: <20120113102908.GB2214@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XjbSsFHOHxvQpKib
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2012 at 11:29:09AM +0100, Stanislaw Gruszka wrote:
> On Thu, Jan 12, 2012 at 09:34:50AM +0300, Dan Carpenter wrote:
> > This is basically just a cleanup.  Large positive numbers get counted as
> > negative but then get implicitly cast to positive again for the checks
> > that matter.
> >=20
> > This does make a small difference in ipw_handle_promiscuous_rx() when we
> > test "if (unlikely((len + IPW_RX_FRAME_SIZE) > skb_tailroom(rxb->skb)))"
> > It should return there, but we don't return until a couple lines later
> > when we test "if (len > IPW_RX_BUF_SIZE - sizeof(struct ipw_rt_hdr)) {".
> > The difference is that in the second test the sizeof() means that there
> > is an implied cast to unsigned.
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> Not sure if making it "unsinged int" would be better, but this change is
> fine to me as is too.

Yeah.  You're probably right...  Next time, I'll do it that way.  ;)

regards,
dan carpenter


--XjbSsFHOHxvQpKib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPEAknAAoJEOnZkXI/YHqRkH8P/16SU28cpziNrPU8kLP+KqyS
eFjRGlY/gyx3JUrwJh5J4HHwo2c7JVA5tZP9D1XQZRzbuM0PfAOKgZ7reKmnMB+e
Lx5B5guFA+IeoJ71Rhy6S1HAtmZ7SgmyESWRljbMBgbzdiiAh6NgwVB1b5uJpW1Y
2n4YF8dLU584L8u6cH0Brtjd4L4uZ6/UKWDN6u0E5rFgx+T+VjSkTH+lQPJZXyX2
G/jNCn3Odrwp8ABUgA0HIew3KVnAmvQ3yeGQtL/OXBtXcfZN3AZapvBAZlhlqma4
FOHVQ8hTqp/iYbURSw1JNIYC4eievrYwc9ggEf5fjaj8xavQRTHsUD4wgigYQBAV
sGFr6mdvrTPuGPhVxuiyNWiubyNo8J2qVNyS/ZMWzukcfFIjBUb1+Ce0bBGvAVF8
azk5QW/rHqXjq9OUlqpFBDEoivMC/gjYxydJbGcv46oR4gT4iqXHK6o7iVJOXm+N
/uCqS77dgRQxRyvjS6zoImjgCWVnegA+1d5bCWyMwbFzgYZPM24CMZFVmgDlWIMF
ZJ2Ud0lxg01F0GJ9XaCrkv43Prq/3S40qqYeETGivAIJ3O0MV8mwdpSAuEUiO3L/
36g+RkMFrm/PdreKtViGr2j7nxC4VidS1AublNkdQ+E/vCdSw1bi4+4zhnEMdW8N
8TC9Asau7MWesRClPbtB
=k/hW
-----END PGP SIGNATURE-----

--XjbSsFHOHxvQpKib--

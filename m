Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:43337 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZDXOzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 10:55:14 -0400
Date: Fri, 24 Apr 2009 10:54:32 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090424145432.GK2830@storm.local.network> (sfid-20090424_165519_189986_C5534D4D)
References: <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network> <20090419170950.GA28885@storm.local.network> <49EB8119.1020402@lwfinger.net> <20090419200146.GB28885@storm.local.network> <20090419223218.GA30599@kroah.com> <20090424110329.GJ2830@storm.local.network> <49F1D036.6080607@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqNl6FRZtoRUn5bW"
In-Reply-To: <49F1D036.6080607@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--NqNl6FRZtoRUn5bW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 24, 2009 at 09:44:06AM -0500, Larry Finger wrote:
> Forest Bond wrote:
> >=20
> > The following git repository has a vt6655 branch and a vt6656 branch:
> >=20
> >   http://www.alittletooquiet.net/media/code/vt665x.git
> >=20
> > The vt6655 branch contains pretty much all of the work I'll likely be a=
ble to do
> > for that driver.  The vt6656 branch needs more work.  I've not gone far=
ther than
> > build-testing either, at this point.
>=20
> It would be a little easier for looking at the code if both vt6655 and vt=
6656
> directories were in the same branch of the git repo, but it's not a big d=
eal.
>=20
> > As I've mentioned before, some of this kind of work is really a bit out=
side my
> > usual domain, so if you do look at it, I'd appreciate feedback.
>=20
> There are a number of warnings when compiling the vt6655 driver on x86_64
> architecture that arise from pointers having 64 bits while integers have =
32
> bits. I think the warnings will not cause any problems.

I'll have a closer look at the warnings.

> There is, however, one error, namely:
>=20
>   CC [M]  drivers/staging/vt6655/device_main.o
> drivers/staging/vt6655/device_main.c:347: error: initializer element is n=
ot constant
> drivers/staging/vt6655/device_main.c:347: error: (near initialization for
> =E2=80=98device_id_table[0].driver_data=E2=80=99)

Hm, didn't see this on my system.  Not sure why.  Thanks for the patch.

> Driver vt6656 also does not build, but that does not seem to be 64-bit re=
lated.
> If it builds on your system, let me know and I'll send you the error mess=
ages.

No, I haven't gotten that in a good state yet.

> I didn't look that thoroughly at the code, but I did notice one thing. The
> constructions like "#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)" are =
in the
> code so that it can build on a number of different kernels. Once it is in
> staging, it only has to build on the current kernel and you can trim out =
those
> conditionals.

Right, my intention was to look at those once the major build issues were s=
orted
out.

Were you able to look over my changes for net device private data accesses =
in
the vt6655 driver?  That is what I'm most concerned about.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--NqNl6FRZtoRUn5bW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8dKnRO4fQQdv5AwRApuVAKCiQ2+EqC6YpTbZAUPSTRU43c9SPQCfd2nN
tbnZui4uzt/0uc6wywtX0vc=
=S5r/
-----END PGP SIGNATURE-----

--NqNl6FRZtoRUn5bW--

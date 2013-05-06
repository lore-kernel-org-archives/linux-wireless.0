Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121Ab3EFNZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 09:25:12 -0400
Message-ID: <1367846698.4131.65.camel@deadeye.wl.decadent.org.uk> (sfid-20130506_152517_379556_36E2FE83)
Subject: Re: linux-firmware: pull-request TI wireless firmwares 2012-04-29
From: Ben Hutchings <ben@decadent.org.uk>
To: Luciano Coelho <coelho@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
Date: Mon, 06 May 2013 14:24:58 +0100
In-Reply-To: <1367821181.23730.5.camel@cumari.coelho.fi>
References: <1367229856.30716.22.camel@cumari.coelho.fi>
	 <1367811576.4131.39.camel@deadeye.wl.decadent.org.uk>
	 <1367821181.23730.5.camel@cumari.coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eLKEmGxbmJRtTwPUZVZ7"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eLKEmGxbmJRtTwPUZVZ7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-05-06 at 09:19 +0300, Luciano Coelho wrote:
> On Mon, 2013-05-06 at 04:39 +0100, Ben Hutchings wrote:
> > On Mon, 2013-04-29 at 13:04 +0300, Luciano Coelho wrote:
> > > Hi Ben,
> > >=20
> > > Here are some updates to our wireless firmwares.  Updated the firmwar=
es
> > > for WiLink 6 and 7 and added a new version of the firmware for WiLink=
 8
> > > and a binary configuration file.  Also updated the WHENCE file
> > > accordingly.
> > >=20
> > > Please let me know if there are any more problems.
> > [...]
> > > diff --git a/WHENCE b/WHENCE
> > > index 4726742..257f24e 100644
> > > --- a/WHENCE
> > > +++ b/WHENCE
> > > @@ -1681,11 +1681,11 @@ Version: 6.5.2.0.15 (Multi-role)
> > >  File: ti-connectivity/wl127x-fw-4-plt.bin
> > >  Version: 6.3.5.0.98 (PLT-only)
> > >  File: ti-connectivity/wl127x-fw-5-sr.bin
> > > -Version: 6.3.10.2.115 (Single-role)
> > > +Version: 6.3.10.0.133 (Single-role)
> > >  File: ti-connectivity/wl127x-fw-5-mr.bin
> > > -Version: 6.5.7.0.27 (Multi-role)
> > > +Version: 6.5.7.0.42 (Multi-role)
> > >  File: ti-connectivity/wl127x-fw-5-plt.bin
> > > -Version: 6.3.10.2.115 (PLT-only)
> > > +Version: 6.3.10.0.133 (PLT-only)
> > > =20
> > >  File: ti-connectivity/wl128x-fw.bin
> > >  Version: 7.1.5.50.74 (STA-only)
> > > @@ -1702,11 +1702,11 @@ Version: 7.5.2.0.15 (Multi-role)
> > >  File: ti-connectivity/wl128x-fw-4-plt.bin
> > >  Version: 7.3.5.0.98 (PLT)
> > >  File: ti-connectivity/wl128x-fw-5-sr.bin
> > > -Version: 7.3.10.2.115 (Single-role)
> > > +Version: 7.3.10.0.133 (Single-role)
> > >  File: ti-connectivity/wl128x-fw-5-mr.bin
> > > -Version: 7.5.7.0.27 (Multi-role)
> > > +Version: 7.5.7.0.42 (Multi-role)
> > >  File: ti-connectivity/wl128x-fw-5-plt.bin
> > > -Version: 7.3.10.2.115 (PLT-only)
> > > +Version: 7.3.10.2.133 (PLT-only)
> > > =20
> > >  File: ti-connectivity/wl127x-nvs.bin
> > >  File: ti-connectivity/wl128x-nvs.bin
> > [...]
> >=20
> > The commit message for this bit says:
> >=20
> >     Update the wl127x and wl128x firmwares to *.3.10.0.133 for single-r=
ole
> >     and *.5.7.0.42 for multi-role.
> >=20
> > But for ti-connectivity/wl127x-fw-5-sr.bin,
> > ti-connectivity/wl127x-fw-5-plt.bin and
> > ti-connectivity/wl128x-fw-5-sr.bin this means the version is now *lower=
*
> > than before.  For ti-connectivity/wl128x-fw-5-plt.bin the version is
> > incremented to end in 2.133, but this is contrary to the commit message=
.
> >=20
> > Are some of these firmware images being downgraded?  Should the version
> > numbers really end in 2.133 or 0.133?
>=20
> No, they are not being downgraded.  They are actually being upgraded.
> The firmware versioning is rather weird.  The second last value is not
> incremental, it specifies a project.  0 is the multichannel support
> project.
>
> The driver was changed a while back to take this version structure into
> consideration.  Take a look at this patch:
>=20
> af4e94c wlcore: change way of checking the firmware version
>=20
> I hope this clarifies.

OK, I've pulled these changes.  But I think it would be helpful to
change that project code to be non-numeric, to avoid such confusion.

Ben.

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.

--=-eLKEmGxbmJRtTwPUZVZ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUYevKue/yOyVhhEJAQrG8BAAlBvpUmpiMU1bvFnjSuXL2edaJCOtdVCy
wuywqp0CBrWe7leKu/dHOBb3phMld/2VU2xjAndkn452pErmQ6tA1MhhtSBKx8pB
5NcPIaNH1kM2WFOy1ana7zv0A0Brcgv0mzu6c3eA6p64r/r0xXTMW2DhdqhJ3kYc
keHve1xGOPf6bYyxmZaUol1t+UbrptBCM0Zu3+fzfOa7SZCA5iKaGB1SbJxwqm1i
HAvSh+j+Qx1bwYdsZLI2MI6TI2UyqaQVGPt7pZpkjOt/bsz3xXMTdEUo1ky/hemv
xS76oDGJ/kuVjwznerlAVUgurY9LJhT1B+U3AQ4hub5E3YdWts+J2ddMooyYax/T
11iCRcirjoPNJu4XdMffyPdD40FaPfmJ7YC+m/Lu6WwhXT4yXICCP0M31NkuOKcP
y41O/UAO3fq1erfgGYnZJxenmsF2z9Geww6Sso6BXKI23HEIHC15H+FK1hIDOnab
hArLp6xYZQIY2uiLabNvgETrH8VBFuWQTKpOYOxOixXmlT9gtjXd9wab2Ky9Aen5
c4WDVqcIxtBZijhRYxCNh5Fb2wyW6l15w/9ot4mC8rawNC0A9l+wehy7bdsdVqoG
g7GOspNpprVWswH8K0rGX48AxeRSX0X3HpHh44pmnZu5XZOsI2L1KI6DrmFi/HvZ
AFEXMlkPI9Q=
=43BY
-----END PGP SIGNATURE-----

--=-eLKEmGxbmJRtTwPUZVZ7--

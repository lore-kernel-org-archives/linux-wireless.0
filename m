Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:49497 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2GLSRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 14:17:52 -0400
Date: Thu, 12 Jul 2012 14:17:51 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Anyone using rtl8192de with 2.4GHz 802.11g?
Message-ID: <20120712181751.GB9489@alittletooquiet.net> (sfid-20120712_201756_808068_59AD65B4)
References: <20120712002149.GA14850@alittletooquiet.net>
 <4FFE211C.3020506@lwfinger.net>
 <20120712013216.GB14850@alittletooquiet.net>
 <4FFE2F38.7030604@lwfinger.net>
 <20120712152545.GA9489@alittletooquiet.net>
 <4FFEF9F8.5060106@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
In-Reply-To: <4FFEF9F8.5060106@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Larry,

On Thu, Jul 12, 2012 at 11:23:20AM -0500, Larry Finger wrote:
> On 07/12/2012 10:25 AM, Forest Bond wrote:
> >On Wed, Jul 11, 2012 at 08:58:16PM -0500, Larry Finger wrote:
> >>On 07/11/2012 08:32 PM, Forest Bond wrote:
> >>>On Wed, Jul 11, 2012 at 07:58:04PM -0500, Larry Finger wrote:
> >>>>On 07/11/2012 07:21 PM, Forest Bond wrote:
> >>>>>The rtl8192de driver is working fine for me at 5GHz, but I am having=
 trouble
> >>>>>getting scan results for 2.4GHz 802.11g networks.  I have been doing=
 a lot of
> >>>>>debugging but am not making much progress.  I suspect the 802.11 b/g=
/n phy is
> >>>>>not being initialized correctly, but I'm pretty far outside my domai=
n on this
> >>>>>one.
> >>>>>
> >>>>>Is anyone successfully using this driver with a 2.4GHz 802.11g netwo=
rk?
> >>>>
> >>>>I have several different models - some work better than others. What
> >>>>is the PCI ID for yours?
> >>>
> >>>This is the one I have:
> >>>
> >>>02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Dev=
ice [10ec:8193]
> >>>02:00.1 Network controller [0280]: Realtek Semiconductor Co., Ltd. Dev=
ice [10ec:8193] (rev 01)
> >>
> >>It turns out that both kinds have the same ID. I think one of them
> >>is a prototype, while the other is probably a production unit.
> >>Obviously, bitrot has set in while I wasn't testing. With the kernel
> >>driver, neither unit can even scan in the 2.4 GHz band. Using the
> >>latest version of the vendor driver, the production version connects
> >>with APs running WEP, WPA, or WPA2. The prototype can only handle
> >>WEP.
> >>
> >>Obviously, I have some work to do. In the meantime, I will send you
> >>a tarball containing the vendor driver - privately so as not to spam
> >>the list.
> >
> >Thank you, I appreciate that.
> >
> >Of course, my preference would be to fix up the kernel driver.  I don't =
mind
> >doing some manual bisection with compat-wireless releases unless you thi=
nk that
> >would be a total waste of time.  Do you have any sense for what the last=
 working
> >kernel version would have been?
> >
> >As you suggest, we may need to use the vendor driver in the meantime.  T=
hanks
> >again for sending it over (although I suspect it is the same version I
> >downloaded from Realtek's web site).
>=20
> It started with the Realtek version, but has some important bug
> fixes that I wanted you to have.

Thanks, that's really helpful.

> Of course, we want to fix the kernel version, but if you want to
> bisect compat-wireless, that would be a big help. In the meantime, I
> will try bisecting wireless-testing when I get a chance.

I have begun disecting compat-wireless releases.  3.1.1-1 works, 3.2.5-1
doesn't.  I'm going to try to identify the commit that broke things by appl=
ying
patches to 3.1.1-1.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk//FM8ACgkQRO4fQQdv5AzAzQCcDxYjp8DisFgcETMsLg0Lu/qM
ZpYAn20w2dSiQexWGa0SrC3Ycdaxz69E
=WgtQ
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:33236
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753720Ab3KGXCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 18:02:33 -0500
Date: Thu, 7 Nov 2013 18:02:15 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131107230215.GF12612@shaftnet.org> (sfid-20131108_000236_618052_CBCBE2FF)
References: <20131107160522.GA12612@shaftnet.org>
 <527BC04F.2080000@lwfinger.net>
 <20131107163719.GC12612@shaftnet.org>
 <20131107175201.GA2002@tuxdriver.com>
 <20131107185714.GD12612@shaftnet.org>
 <20131107191122.GD2002@tuxdriver.com>
 <20131107194641.GE12612@shaftnet.org>
 <1383863100.2391.5.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
In-Reply-To: <1383863100.2391.5.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2013 at 04:25:00PM -0600, Dan Williams wrote:
> > At this point it's a more modern driver than the ones already in the=20
> > kernel, and I'm willing to maintain it if there's a point to doing so.
>=20
> What's the delta in device support between prism2_usb and the hostap
> driver's USB subdriver?  Is there any overlap?

Given that there never was a hostap_usb, there's no overlap at all.  If=20
you have a prism2.5/3 USB widget, you'll need prism2_usb to make it more=20
than a lousy paperweight.

Way back in the day I'd advocated for doing a USB port of hostap rather=20
than mainlining prism2_usb, strictly on a ROI basis, but the boots on=20
the ground chose the latter.  Given that prism2_usb has slowly been=20
improved since then and hostap has largely been ignored, IMO the right=20
thing here is to get it out of staging by taking care of any outstanding=20
problems.

On a strict feature basis, hostap has the advantage of supporting AP=20
operation and WPA -- For the latter, prism2_usb just needs the cfg80211=20
and crypto layer hooks since it needs to be handled in software anyway. =20
As for AP operation -- Intersil never officially supported AP mode on=20
the USB devices, and while it worked unofficially, it wasn't terribly=20
stable.  The same stabilitiy problems plagued monitor operation; my=20
theory at the time was that their USB "glue" silicon simply couldn't=20
keep up with the load.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSfBv3PuLgii2759ARAj1+AKCL6AFzAY0vo2aBQuKeHxhVztDBgwCg41l+
2KzfmR2olnrfIma3d+x9114=
=fZC5
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--

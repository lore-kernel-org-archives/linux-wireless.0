Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53882 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758969Ab2EQRHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 13:07:36 -0400
Message-ID: <4FB53054.9070309@imap.cc> (sfid-20120517_190747_132379_6F19250A)
Date: Thu, 17 May 2012 19:07:32 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Hansjoerg Lipp <hjlipp@web.de>,
	linux-bluetooth@vger.kernel.org,
	gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com
Subject: Re: [RFC 13/13] USB: Disable hub-initiated LPM for comms devices.
References: <cover.1337203535.git.sarah.a.sharp@linux.intel.com> <3c634afbbe15598cdcbf77bb9393d22ad4bfa373.1337203535.git.sarah.a.sharp@linux.intel.com>
In-Reply-To: <3c634afbbe15598cdcbf77bb9393d22ad4bfa373.1337203535.git.sarah.a.sharp@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB1133729D4FC7A3C4EB0E715"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB1133729D4FC7A3C4EB0E715
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 16.05.2012 23:55, schrieb Sarah Sharp:
> Set the disable_hub_initiated_lpm flag for for all USB communications
> drivers.  I know there aren't currently any USB 3.0 devices that
> implement these class specifications, but we should be ready if they do=
=2E

I follow the argument for class drivers. But this patch also
modifies drivers for specific existing USB 2.0 only devices
which are unlikely to ever grow USB 3.0 support, such as the
Gigaset ISDN driver:

>  drivers/isdn/gigaset/bas-gigaset.c            |    1 +
>  drivers/isdn/gigaset/usb-gigaset.c            |    1 +

What is the interest of setting the disable_hub_initiated_lpm
flag for these?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
In theory there is no difference between theory and practice.
In practice there is. (Yogi Berra)


--------------enigB1133729D4FC7A3C4EB0E715
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+1MFQACgkQQ3+did9BuFtEjQCghpEKnCJ4LI0vjWtFhiOSuLxp
6h0AnjwiirhAQDf2qjydFRszMK1aywSt
=nhOe
-----END PGP SIGNATURE-----

--------------enigB1133729D4FC7A3C4EB0E715--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZHCIrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 04:47:55 -0400
Subject: Re: ar9170usb crashes during iwconfig for ad-hoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Albert <jal2@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249289084.2007.54.camel@johannes.local>
References: <4A759341.1090006@gmx.de>  <4A7612F8.80802@gmx.de>
	 <1249289084.2007.54.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mjwbgvGaI8S6iU0y/oWu"
Date: Mon, 03 Aug 2009 10:47:54 +0200
Message-Id: <1249289274.4561.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mjwbgvGaI8S6iU0y/oWu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-03 at 10:44 +0200, Johannes Berg wrote:

> > >     ifconfig wlan1 down
> > >     iwconfig wlan1 mode managed essid huhu
> > >     ifconfig wlan1 up
> > >     ifconfig wlan1 down
> > >     iwconfig wlan1 mode ad-hoc essid huhu_a channel 1

> No, it's a bug in cfg80211 :)

But it's not making sense to me. I'll have to try to reproduce it. In
any case, we shouldn't be calling in to mac80211 from cfg80211 while the
interface is down.

johannes

--=-mjwbgvGaI8S6iU0y/oWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdqQ2AAoJEODzc/N7+Qma5WUQAKl5VsfbdRXJn681M352BedU
6wDW15CnkA6ZHSG57liIqK6YoF2eCLFwk1dhWW0+pxl/hwr35PghsZpjMk8LhBwD
bJYTfykAk7PnfwNLbqpOWiXYmDUef4i4OIy4LNDlLoJXuj4qXWa1237oXItxy4JL
eJRGKgzu9RB/cV4VClU76QiB+FtrnZ8+0EBchgl5/uzQND5+Fa5R6KJW9x4M/+0r
sFgX9p43cW7fY3m9WHlTTBJeleqVFlONFWrOLtgqvRi8+/zeb/4mHlhsNeTeNC/F
CZ2H7oyA4X9/vWNKxDpzjYV4l1EOzLhih6ZHhjEoK3GKw6kJC6vxDHljHvfzRM1B
KTCeNvE9KhXdFNmA02epdLXNKu2kugOEdCHI7W82P62xtLArIHkqk2nKuOdqovyj
esVTgZeaGKmlyXtktH96G6UxRFHlaTExz9AMDC08rh4ZWUxJ7qAXMfYf6YoC3vuo
l0oHv0AUzNxKFBw9F1NWZ9Nn+TBaPZwuTYuZQiTrKotuu8pBapwGMVXU+fLO/m2/
Ik8wp/3rnFhcYF2iBn9QGj1eIcqS0gFuCXMLVJGPD5wq6kTsPdbQkut+csTbryBE
Uvw2cS8Je/MXep1hBlYEOs3RSq7a+E8SY1XaDQTK58/jV+CpU6cbnVpA67crvZY8
tZnvGUmxT9nNGT12EBTT
=Yga2
-----END PGP SIGNATURE-----

--=-mjwbgvGaI8S6iU0y/oWu--


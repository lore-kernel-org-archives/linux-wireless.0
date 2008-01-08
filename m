Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:22635 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753570AbYAHD0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 22:26:25 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] cfg80211 API for channels/bitrates, mac80211 and driver conversion
Date: Mon, 7 Jan 2008 22:27:20 -0500
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1198448108.4103.6.camel@johannes.berg> <200712231850.37136.flamingice@sourmilk.net> <1199484080.4172.173.camel@johannes.berg>
In-Reply-To: <1199484080.4172.173.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1436108.fnELgt7Bek";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200801072227.27222.flamingice@sourmilk.net> (sfid-20080108_032630_817461_49A0DB68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1436108.fnELgt7Bek
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 04 January 2008 17:01:20 Johannes Berg wrote:
> > > + * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
> > > + *	Hardware is not capable of receiving frames with short preamble on
> > > + *	the 2.4 GHz band.
> >
> > Let's add it when we actually find hardware that needs it.
>
> I disagree. It's literally two lines of code (one defining it and one
> using it) and makes things more easy to discover when writing a driver.
>
Yeah but it's never ever going to get used. Bet you 10 us pesos on it. So=20
what's the point? If you feel this makes mac80211 better fit the theory,=20
well.. whatever..

> > > +	strcpy(name, "mac80211");
> > >
> > >  	return 0;
> > >  }
> >
> > It's simple, sure, but no. Let's not change userspace facing behavior if
> > we can. If you really need to, use "IEEE 802.11".
>
> It's pretty dumb to indicate the mode that way, but I changed it to just
> "IEEE 802.11" now.
>
I'm not even sure what the intention of this ioctl is suppose to be (verify=
=20
presence of WE? there are WE implemented ioctls that can be used for that=20
trick..) but it does indicate it's not for saying what the name of the driv=
er=20
is and I don't think driver subsystem names count either.=20

Indicating mode this way is dumb for sure but it fits with the examples giv=
en=20
for the ioctl. Doubt anyone is counting on that though since this ioctl has=
=20
been abused already (eg. association status in ipw2200) so "IEEE 802.11"=20
should be fine.

Thanks,
=2DMichael Wu

--nextPart1436108.fnELgt7Bek
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHgu2fT3Oqt9AH4aERApKZAKDFXtPdvFQ+RNZEI2ueN2mFWmyIYACgowiV
dODWmXFeRGgML1QpHYiV8z0=
=sbrA
-----END PGP SIGNATURE-----

--nextPart1436108.fnELgt7Bek--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbYADWBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 17:01:36 -0500
Subject: Re: [RFC] cfg80211 API for channels/bitrates, mac80211 and driver
	conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200712231850.37136.flamingice@sourmilk.net>
References: <1198448108.4103.6.camel@johannes.berg>
	 <200712231850.37136.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QGh3GDkmW0jymcRexlQo"
Date: Fri, 04 Jan 2008 23:01:20 +0100
Message-Id: <1199484080.4172.173.camel@johannes.berg> (sfid-20080104_220144_319723_37095265)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QGh3GDkmW0jymcRexlQo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > + * @power_dBm: requested transmit power
> > + * @max_antenna_gain_dBi: maximum antenna gain
> Mixed case is bad.

changed.

> > + * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
> > + *	Hardware is not capable of receiving frames with short preamble on
> > + *	the 2.4 GHz band.
> Let's add it when we actually find hardware that needs it.

I disagree. It's literally two lines of code (one defining it and one
using it) and makes things more easy to discover when writing a driver.

> > + * @max_antenna_gain_dBi: maximum antenna gain in dBi
> > + * @max_power_dBm: maximum transmission power
> Again, no mixed case.

changed too

> > +extern int ieee80211_frequency_to_channel(int freqMhz);
> Mixed case again. Do you really need to add units to these names? They sh=
ould=20
> just be all the same throughout the code.

Ok, changed.

> > +	strcpy(name, "mac80211");
> >
> >  	return 0;
> >  }
> It's simple, sure, but no. Let's not change userspace facing behavior if =
we=20
> can. If you really need to, use "IEEE 802.11".

It's pretty dumb to indicate the mode that way, but I changed it to just
"IEEE 802.11" now.

Will repost later.

johannes

--=-QGh3GDkmW0jymcRexlQo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR36srqVg1VMiehFYAQKqLg//WdC0G48AR2oEuy3/CuDC0UGBxKd1JYYn
8SOv6wpOu2DWvokYERmwnW7LKv8Ofo0kX0AOHfg9uhR6jNhFK34I3qvjjAqngtew
ENhjMLaOTVFR3sPfT5OjHpmN6P8i7DiuzZ4vcwGZfTRP0ONN6HamyvvDsghI8OFK
iS8CD+2W+/eoSlsUUdzza6lI0cieJyl4QgjjiF3MSQSEBhh3H1cBPfJYHKaW4oJk
G+fGEBo+GBNyeku2pcddrqM+lcd/0Fo4LTdR1kHmUu89CBE/E0Qcqyv5w6bteZ1T
tGC7AQ8fsHhGseiSVIYQhLNtVban71w8155f3eflXKCJT8FJ+CQ9lKzbK4azJKRM
HQMVE++yQrIbPsQH7VDzBCLeywyMDjcl26LYEMWbbg0B1ffIamXsP/o6+rNIUb7j
HmliP83B44aiG+N5G7YyugDeZTFJ6+r/WuvTVCXkjp4kNVClC9E1RQ5LMPKY+NcV
K5q8rB5lvOzXmOSLx3tWF5C5TI2I20rVE+7Imgi+De0L+8qPUyTXIX61jfFyE0T+
VCXZepgswzqJiEnoXoKn07Q68dBKQPB4+CiCf+YrWwvDY0RUKm4+O8tL0baBbnhQ
N7UNtczcI2fxT5U6Nw3nk6KnzTolTlbIBRqJjG8G96KQ1H8Uxewww7cdcKBVLTyA
drkM+1FuLnY=
=SXfd
-----END PGP SIGNATURE-----

--=-QGh3GDkmW0jymcRexlQo--


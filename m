Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFDSCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 14:02:54 -0400
Subject: Re: [PATCH] rfkill: always init poll delayed work
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4A2809F8.6020006@lwfinger.net>
References: <1244015729.7176.28.camel@johannes.local>
	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>
	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>
	 <4A27EF6C.8000208@lwfinger.net> <1244132396.22576.82.camel@johannes.local>
	 <4A27F649.9080203@lwfinger.net> <1244133087.22576.86.camel@johannes.local>
	 <4A27FB8D.5000605@lwfinger.net> <1244134635.22576.88.camel@johannes.local>
	 <4A2809F8.6020006@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q30pq/nZPABojBHsfmCc"
Date: Thu, 04 Jun 2009 20:02:52 +0200
Message-Id: <1244138572.22576.90.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q30pq/nZPABojBHsfmCc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 12:52 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> >=20
> > Right. So we already have the problem in the old code, we just don't
> > notice much... can we take the core up, check, and put it down again? O=
r
> > I think it's GPIOs, can we query those via chipcommon when the 802.11
> > core is down?
>=20
> If you mean the check for the switch, that is an MMIO access. I think
> that we can access it even if the 802.11 core is down.

I do mean that, but I don't think you can access the 802.11 core's MMIO
while it's down. I'm out of ideas expect taking the core up, checking,
and down again periodically.

johannes

--=-Q30pq/nZPABojBHsfmCc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKAxJAAoJEODzc/N7+QmaB78P/R07UaTRi9rBA4nVv/6k6hm3
7KqUuZg13Rc15g6LaytRNEaH5Rx9VdX91VXsam6YRFvoHFnBFwp1Aao3V1mBmqRm
v2q8TX9OOzhZUc5iHTE2znDLMebHgiPDVU7io9ofXY4ynwglmVEbr7czUjX/OnJy
O/xsZfkiC5ZuBrqNFzUrwNXxiD3pVb7D5r4T1DrPabmYBgkHX6YMgrwjCgUZMRRS
m/FKcos9m7/yk0OpSP/f++4Ij3y5mSbtxiXXBs0RRyJb+RsquBaBvDNKDktwPNQh
dHQcYMlEOUPY03d4SZpHxLLrrqlBy6t2an0yjf66oYJ9AOahQzuJsGjnS5C577Gb
zbgcSttO59tvVMCNA2nv33LIp3T2+vBDjiHyDqQc4sz3V/rMOmVC2JRlFvbAjGPd
IUPP6iWtOLSNvbPL5kP5h6tlIivl+HGE4qkegIDAlgwasignoOHXZzvY8z9DHc37
0ed4OIS4PBQWnP2gkdblVAA/lkfS8Am611orbgMtmT3axcE+Z/2qcoYRQRhJ3HVY
XSun258s3wkHiNWPIA2WVb/3+6O3AzE0AOnU6j/T5UZqNxpcnd8nTGoh7CahgV7e
xFsA4nOKlPibwWvlBB+f7oAUUyIg74mhVVpjoFeXgxzVo2VuvVeL7SqT4om9mDiO
hH8TR6fEKl4e7waF/3AL
=ixHD
-----END PGP SIGNATURE-----

--=-Q30pq/nZPABojBHsfmCc--


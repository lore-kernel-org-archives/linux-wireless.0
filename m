Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbZGOQXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:23:47 -0400
Subject: Re: Unable to load iwlagn module: Failed to register hw (error -17)
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Ranson <ranson@analager.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1247674573.17896.1989.camel@rc-desk>
References: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
	 <1247673740.17896.1983.camel@rc-desk>
	 <1247674310.10754.19.camel@johannes.local>
	 <1247674573.17896.1989.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0HsDu6NYuIEFLOjgsJdx"
Date: Wed, 15 Jul 2009 18:21:20 +0200
Message-Id: <1247674880.10754.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0HsDu6NYuIEFLOjgsJdx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 09:16 -0700, reinette chatre wrote:

> > -EEXIST should only happen if something has already claimed something i=
n
> > sysfs, but not with netdevs (i.e. wlan0 would just be renamed to wlan1)
> > and phy0 is numbered all the time so that can't be it either. I don't
> > know.
>=20
> fyi ... I based my response on register_netdevice() being able to return
> -EEXIST at the time it checks for the existence of "name".

Yes, it does that, but we don't ask it for a fixed name -- we allocate
"wlan%d" and in the same rtnl-locked section register it, so we should
always get a new number and be able to register that number.

johannes

--=-0HsDu6NYuIEFLOjgsJdx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXgH9AAoJEODzc/N7+Qma4DAP/jxQIsoCN4YISdXHlUP/+RT9
1wysxmiQrGm6HQiy4zfnjJT0Dsa0HwKvsHswmkLamaW5karvT1yQxk1O53dGOpFq
Clcugv10uWisI+oONtGb12q8liqpQw3Fz8tjnR8fKixdZxL28nSCRl3BcxvTYe5v
BMqJdzjspOWS6F/rG4xQWHeqsWYyr1aj74IoGpCglL0/ygsL7KjU4eteGPuab7QN
G2lJGsyAJQT1tSrlbz6q55q0YbjkdVTs6WclX+7BmQAqAoJLVM907pdYsujWmW0e
bmDTMoBhNefOGxoIGeHwLeqPr2fHl5KUZ2u3NgmbXi4LHXaXn8sAFqdMQfrgg7sV
d1bYB4yf1kpw44nMwl8RuvxdxIyHuluXZBMy8lTKzKNs+W5YFlQwlu/wECqChSau
TMo0RwI27+lc6zJIgoUFv0X6AJJtUmjIs+LrzXHfnC1w7sjZmmasPukcmGGw63Iw
AfrfJts3u5IR9w8aq27iOuJX1S3Qg+JEvd8S+VLgjj5Hv7UkzfYDoKfrsoekMQ21
ktC62F4RjcdxVUBkNZJOy+qrlDpf9jLFzTus53WQBtJKmdysooJwDm+JhEP6/gEi
KVfmhXz1ttcu2cR9eiHygSJ9RutIB91cCFSJjTzDEyc5sP7ETfHSxMj+PnODs+Ds
VTQwWhruZdycs62lIaRK
=utxw
-----END PGP SIGNATURE-----

--=-0HsDu6NYuIEFLOjgsJdx--


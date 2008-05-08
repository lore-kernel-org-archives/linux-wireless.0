Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762766AbYEHWLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 18:11:11 -0400
Subject: Re: iwlwifi and tx info in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com> (sfid-20080509_000624_162294_5A80849B)
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 <1210255522.3547.48.camel@johannes.berg>
	 <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com>
	 (sfid-20080509_000624_162294_5A80849B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ObmSmRyRb0L251KCmTE4"
Date: Fri, 09 May 2008 00:10:56 +0200
Message-Id: <1210284656.3547.76.camel@johannes.berg> (sfid-20080509_001007_903840_EE924F56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ObmSmRyRb0L251KCmTE4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > Currently we actively use 2 of them. First for TX command second for
> >  > actual frame.  It would be even worth if we need to expand
> >  > each packet also for TX command.
> >
> >  We will no longer do that after davem and I figure out those allocatio=
n
> >  patches.
>=20
> Not sure these things are connected. TX command is allocated fixed for ea=
ch TFD.

Ah, no, I misread that. Well, I think it might still help to say you
need N bytes headroom and use those since you wouldn't have to allocate
an extra skb.

> >  You should implement TCP checksumming in the hardware. *that* would he=
lp
> >  a lot.
>=20
> There is already pretty much deal of link layer in software to reduce
> the cost and the complexity of the HW for these softmac NICs so
> this would be kind of strange investment...but I didn't invest much
> thoughts into yet.
> There are probably other means to utilize scatter gather DMA then TCP
> off loading. Are they any other source of scattered packets maybe
> iovec?

Well as far as I know those too would be zero-copy IO which only works
if you have TCP checksumming in hardware.

johannes

--=-ObmSmRyRb0L251KCmTE4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCN6b6Vg1VMiehFYAQKv+Q//U2o2IF2BFWvx6KizALx9ueo3ZoelKcqq
9xLDgwxqjTWhUdgPkOMEp57tHKX4XK9UAybVou57sHk19bE1fM55bHtJ3h+YIuUU
F5Iev8yH79oGG7EjzAAG/9+fSli8+2pcdNBz5ES+rrc8d2wa/nN9TJKDlHOg6JTY
DeHe3Z5HxDmuD0TfXNirrClJ4xEDSOKZL7BMo2R57B7aZ4Y8dDtoJTXchGxbfCpv
TaY1Zr1R/EXtKEw+lBd6qbXBcY0klRhcZWMVIr8gZ+oqnNgJe6M6IGb+ndgBzjgF
kTgwim3jLWnzBbKnrcXpybMUjGIkt8gV0rCrS+vn8ak2pREUte3PRQ7nCnOvm8wd
KdfiSKBm7tIp+dEB13dtOk4QLUVxpASr9aB+oIbo1JqFQxf/0fCHYLQBEDHXOVjQ
mNmFOKpJYKyY+PU+FbOIK+dd5xnYzJQOObJ50N9EQk0VlmlCr9ZJVlS5kQ0em8ro
QmyaNyvFAl30iYVZOayxLita5AWipn6U2o4IC+GSTSOAf6o45ntcDl4C5L1lgWnW
1v4I9MhciHAnuFnRa2PSSIkWcSueahFE1Y6agtamlnSfiUCLHIEHXBbaQjXX0XHp
DvmsLA6mbPLoGzN+kWKx6rSwF6vetWSlsW05ze6YzXp/4zqbrqfH9n+aoTAo57yF
CJdD5cVECh8=
=1Eu+
-----END PGP SIGNATURE-----

--=-ObmSmRyRb0L251KCmTE4--


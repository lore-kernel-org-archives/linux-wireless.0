Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbYFQSfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:35:48 -0400
Subject: Re: [RFC PATCH 7/7] 802.11w: Configuration of MFP
	disabled/optional/required
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617181805.GE4974@jm.kir.nu>
References: <20080617154008.883383150@localhost>
	 <20080617160027.897662688@localhost>
	 <1213722570.3803.92.camel@johannes.berg>  <20080617181805.GE4974@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NHAuRztPSDeywGAF2wr3"
Date: Tue, 17 Jun 2008 20:34:58 +0200
Message-Id: <1213727698.3803.110.camel@johannes.berg> (sfid-20080617_203552_246732_720D895A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NHAuRztPSDeywGAF2wr3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > --- wireless-testing.orig/net/mac80211/wext.c
> > > +++ wireless-testing/net/mac80211/wext.c
> > > +	case IW_AUTH_MFP:
> > > +		if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA ||
> > > +		    sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS)
> > > +			sdata->u.sta.mfp =3D data->value;
> >=20
> > and shouldn't that be used somewhere?
>=20
> Well, yes. This is still somewhat unclear area to me and in particular,
> I'm not sure whether the IW_AUTH_MFP parameter will end up being used in
> mac80211. It would be used if the kernel code (or firmware in fullmac
> designs) would select the AP. mac80211 may need another configuration
> item to set whether MFP was actually negotiated during association. This
> has changed a bit in the latest 802.11w draft and I haven't yet updated
> my implementation to use the new mechanism. For the time being,
> sdata->u.sta.mfp is more or less a placeholder for something that may
> disappear or change to something else..

Ok, yeah, that explains why I wasn't really able to see how it
determined whether MFP was optional/required for a certain association
etc.

johannes

--=-NHAuRztPSDeywGAF2wr3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWAPPAAoJEKVg1VMiehFYSnkP/160hGTFp1fcx4/hApw8Re27
019aSEXw6UUONMcJzhuhbJWqET3omkKHhE8KwJtmoPrDUcUEWxJYGebEfGgxo0y+
u5vpHnYANiUHc5csgzp/znNnFviQ7uyNk3lfUJNr7jL2bNUcJqKbZ3XVfm48D3tH
pZJcWsEajPixN+YhnfNt3H/TyrSR2MB9WU3gRo0ph/RzfLx/ISLIKYkgS2quzOSO
G/nsNhqN9sEjrE9ja4ItOwdlSAebnJngXI+qeht2OEjDhz4LEq8ieI7UJ0IYl/dJ
adL66t7Ry+i2ISwwNqKNsFxkpHUulrD4stwgipZfAmRkctowG3q+UdNO0ztwzdWF
a8EDx06gwTwAcLJXmGqTKofwGVy0aiLvczJRzpr+SUU720pYtfHj6+5lEEmY/ME9
sMo6mFD27TVtRog2271YuCARYHSy6M1nIsWUrBELfyH+gVlBSVqMveF8JCjDBT1F
f7uoHU6Xg4lW+9oUyx3Qr5NjBem9hN6k7AGJE4AWBCcwSOKt55MRi3AA66OeC6bU
vOpVUZTpXhMQdwxVV/s6VjEOuuetmdc3Jpn7dvHIpO1ysVkO9F23lrbXZwNv6v4F
OePkh0mOs8AQq30Fsj6GlrxD4CoiuGjKZ9Tp/Srpf59HiNmxJjTM/1pXyNZTKv4Z
/v1lSTJwlwMYGCF1K4WO
=m2Dw
-----END PGP SIGNATURE-----

--=-NHAuRztPSDeywGAF2wr3--


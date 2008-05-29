Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYE2Voe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 17:44:34 -0400
Subject: Re: [PATCH 15/37] wireless: use get/put_endian helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1212096945.28403.141.camel@brick> (sfid-20080529_233551_020981_7B2BB967)
References: <1212092308.28403.117.camel@brick>
	 (sfid-20080529_221900_617991_210BEC75)  <1212096681.10109.0.camel@johannes.berg>
	 <1212096945.28403.141.camel@brick> (sfid-20080529_233551_020981_7B2BB967)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LpfWgCpNxnWXeObMqQZN"
Date: Thu, 29 May 2008 23:43:31 +0200
Message-Id: <1212097411.10109.3.camel@johannes.berg> (sfid-20080529_234438_717996_78572848)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LpfWgCpNxnWXeObMqQZN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-29 at 14:35 -0700, Harvey Harrison wrote:
> On Thu, 2008-05-29 at 23:31 +0200, Johannes Berg wrote:
> > > -	ADM8211_CSR_WRITE(BSSID0, le32_to_cpu(*(__le32 *)bssid));
> > > +	ADM8211_CSR_WRITE(BSSID0, get_le32((__le32 *)bssid));
> >=20
> > Maybe I'm stupid, but isn't this the same as le32_to_cpup? Or does
> > get_le32 handle unaligned values?

> You're not stupid, but there is a new put_le32 as well that takes
> aligned values similar to the put_unaligned_le32, so get_le32 was
> added to have an analog to get_unaligned_le32 as well.

So this is just to make the API "complete"? Are we removing le32_to_cpup
and the associated API then?

johannes

--=-LpfWgCpNxnWXeObMqQZN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD8jgqVg1VMiehFYAQLhDRAAkEaiwtxYPGM7jDowDVrE+ihwLxeHMe8H
ez3jzTrEbssDshZ3bU3SiTKhVWgKEndC7fv3rXeC+sYAvT1hN6DV0+MUEDzpYMN1
2sMrJ5QtIvBKnF9e3hdKoasEeNFJYWjpwH56EcC05s20lWz5mfDdSP6eQZmnei5e
q8ByxAyenR+PJFNxMNZBsVRK86KbVFQGrzfb6xLLe0G8ZuG8lEdRtEM/9MQ02GBw
CtYaVgKJqaCHwQsZd1Wpy3ur+XOVe5yuKl7Drk7/55Z5WXC9oxgrJigPE8YgS05b
sHC+1ToIkCyxYL1SBR62ZaUaMDQLNm5rphhGOza7uy4dvftmmkS6lOFO85tR0pNy
mSOZHku+iGgV1PpNMhghvs5bwzIrjf+WbEpJPaQSBuBEUDWU31bPNY7Cg4naGLjg
ZY17xSvG21l49sfkfNkyJ4C89AgPPXyroNoWNNgFc5so3GVpL9xhJm5keDv8oEdB
NXoS/emFYWLjuMSVli6CYchBSdXaJsRQG10kr9sRP2qJ2boAwU4DlcZy2Oba+Lu1
XzesS+zNstBKZoDtud6qn336boZNpl1ZRAr26G3iSMMOIRmHSjS8keUKymOaHZsA
Qa9HPMNGnjYpWnNrlceAfYIY/8+/r2RDEh2VSkqp3Yicm+4UAuzyQvrNKBtu7Bzb
AfuLRtVBExo=
=sQVV
-----END PGP SIGNATURE-----

--=-LpfWgCpNxnWXeObMqQZN--


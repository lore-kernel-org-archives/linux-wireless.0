Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760195AbZFWQzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 12:55:16 -0400
Subject: Re: [PATCH v2] mac80211: fix todo lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0906230951v9766914vdc1d76f85eb62feb@mail.gmail.com>
References: <1245751007.4184.17.camel@johannes.local>
	 <1245766038.21314.24.camel@johannes.local> <4A40F856.2010501@openwrt.org>
	 <b6c5339f0906230951v9766914vdc1d76f85eb62feb@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Yy4VHp8kv+dxYqqmTKNY"
Date: Tue, 23 Jun 2009 18:55:14 +0200
Message-Id: <1245776114.21314.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yy4VHp8kv+dxYqqmTKNY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-23 at 12:51 -0400, Bob Copeland wrote:
> 2009/6/23 Gabor Juhos <juhosg@openwrt.org>:
> > Johannes Berg =C3=ADrta:
> >> The key todo lock can be taken from different locks
> >> that require it to be _bh to avoid lock inversion
> >> due to (soft)irqs.
> >>
> >> This should fix the two problems reported by Bob and
> >> Gabor:
> >> http://mid.gmane.org/20090619113049.GB18956@hash.localnet
> >> http://mid.gmane.org/4A3FA376.8020307@openwrt.org
>=20
> Hmm, I applied the patch, started hostapd, hit ctrl-c to
> kill it, and got instant lockup.

Strange, but I can't imagine it's due to this patch since it just
changes locking in one place, which must be harmless (and I also tested
this patch).

johannes

--=-Yy4VHp8kv+dxYqqmTKNY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQQjvAAoJEODzc/N7+QmaAH0P/A6j3adCPI4oqejrhZR5FGDd
+SbO6A1WmRfUQzyYaU7JD2jYn60hFowkgNN3RBsHmvUDKNXhBKPtPY9sgQFQXHaU
RFfCnPBXsKZyme/N9mNPCv0BGdDOCPKds76ocOw7jMOZapyC2YH7YQTfNXBl7pRV
kma4dWmtuaGRbXt98Pzfzucdp+zRyVVjGCkEkAXZe2tGzB6SAFPqXRlZfmhW88vo
ldsTOFANQCcoWPplmdmL+isc+4j1l6rDR418nWQgW1mRs2GVjzXfbZ0D2v7Mfrai
Upv7IUMIjhzPF+XSu4al/8B/4CJIWD1YhyF8LVEAqFBOnILti8Tk14XJ4BvL22KF
UrpjErq/If1u2JrWXNi6GMdVUwkBDXSdxcrOOwiFVR6qikNVlzx0of93ay4ZZqz9
9I1Bwy++oaY/nfx67LglfEM895pxQhue2dz7XFEg7GB9QwIgzM6L1U5UWrX5+K3V
5NEo/foWpdU9iOn3ppJPwpxzi2pz9/6AJRGr6vpmbAnYhlpmcaxKsKl7tPocv1Dx
c6H1l2eZWo20JKgh1dOOFpuFISU9ZQyE8h/1TlhV2xwICCMDwVdJyNf3ZtWCKRPF
1rzvt/il2sYvmU5vyHFNUBGZnOG/+lt24i7V3GdasLZ8duJZkv8mIhiZDMRMQxHA
zsNeuQUd6MiydKnAbBhE
=oSrA
-----END PGP SIGNATURE-----

--=-Yy4VHp8kv+dxYqqmTKNY--


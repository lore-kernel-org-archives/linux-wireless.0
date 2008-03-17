Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYCQU7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 16:59:17 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com> (sfid-20080317_202759_492040_74BFA2FD)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
	 <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com>
	 <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com>
	 <1205784255.16475.33.camel@johannes.berg>
	 <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
	 (sfid-20080317_202759_492040_74BFA2FD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v55DBw2296JkpnQpi8By"
Date: Mon, 17 Mar 2008 21:59:01 +0100
Message-Id: <1205787541.16475.40.camel@johannes.berg> (sfid-20080317_205922_303025_EFB38191)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v55DBw2296JkpnQpi8By
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  Well, you were suggesting the use of multiple SSIDs, which we don't
> >  support, we only support VLANs within a BSS/single SSID. Not that I've
> >  been able to test it, hostapd needs radius stuff set up for VLANs...
>=20
> I think it's transparent since it's handled by MLME in hostapd so
> multiple SSID is supported
> Maybe we did some minor changes in mac to support that.. Will check again=
.
> I think it's always done by means of VLANs

Oh, hm, could be true.

> >  Right. I was just saying that the way it currently is I think you coul=
d
> >  detect it that way. b43 simply assumes WEP keys are always 'static'
> >  which seems to mostly work well in practice.
> >  I suppose then set_key needs a new argument key_type:
> >
> >  enum ieee80211_key_type {
> >         KEY_TYPE_PAIRWISE,
> >         KEY_TYPE_GROUP,
> >         KEY_TYPE_TXONLY,        /* group key in an AP */
>=20
> Can we drop it? Hm still not sure why you like it so much.

Well, we don't want an AP to actually decrypt things, so we need to
distinguish between these things so that the driver doesn't somehow try
to use that key for decryption.

> >         KEY_TYPE_STATIC,
> >  }
> >
> >  where the MAC address pointer would only be non-NULL when the key type
> >  is PAIRWISE, and STATIC can only be used for WEP keys.
> >
>=20
>=20
> Do you know anything about mesh security are we breaking here anything?

No, Javier, any comments? I think basically you have peer links that are
encrypted, which is just pairwise keys.

johannes

--=-v55DBw2296JkpnQpi8By
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR97blKVg1VMiehFYAQJNyxAAhbM6wkfnA8NU1U+Yozahos1J4yRiiyOn
LqKRcjFcQpWasfr9NadJsLT7QA+aar/mLpuFJeL6qU870AwLuK3KxdSnSEyXnFYw
iapq+0k6WFkg9Irs4OYJiy0cTa85V36CdTh2etzn190DlT0ZiM3zzoyuQe1pNJzJ
pQbwgp4PjmWBLTEfRF0oXHCcp4KXsE/uwmDoPgE989tGauO2bgQw0eQDI4mXfOIV
i8PxF28xV0b5ZcchbsLyQfsvBkezGCjK9ddsH8vSXmaX/z94sB6NolhYdPhD65+a
W/rgIB8WKROoE3YfRzZZ7NmMxfAF8nqi6Pqm9iyJNrtFd8BwmT3LLlldBXAWYMjn
io+HKMSA9NtCvsm5FHquZ8UBFtL71bdOkUj1G+v7qI3pVGejs1M5KqKSM130Z5kN
JIqDcdItoU0vNO62i6iIQ3UDX3gNyUFvqZNakoBdqmUuuIm4l7HCuL8TDpaDve4e
w65Vpzonwi9bfMlffJjqvidwqcYsdCNqQXaf5gxQuV2FkirsQSgnYnSWoTLmBLy+
NwziNDFuSyTzfH9+BAQrVrAKtmLVsRrjlqLcok/0lxX64uxZpnxHUh/jkuu4Ls00
bO5fByppSRCbSp8Sz9MFDM7EnfBdL3iPZnmr/00Dq3cJfnI9xczoHhB0MAasfhka
PZBij48SDQY=
=yVCp
-----END PGP SIGNATURE-----

--=-v55DBw2296JkpnQpi8By--


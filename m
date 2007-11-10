Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbXKJKRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 05:17:32 -0500
Subject: Re: [PATCH 4/4] o80211s: (zd1211rw-mac80211) support for mesh
	interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <473516f2.15528c0a.7196.3372@mx.google.com> (sfid-20071110_022703_924708_89D9D43C)
References: <473516f2.15528c0a.7196.3372@mx.google.com>
	 (sfid-20071110_022703_924708_89D9D43C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nLJ8TLer8y1r5QWnLfHE"
Date: Sat, 10 Nov 2007 11:18:54 +0100
Message-Id: <1194689934.7258.66.camel@johannes.berg> (sfid-20071110_101735_349961_AA100628)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nLJ8TLer8y1r5QWnLfHE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +		{ CR_CAM_MODE,			MODE_AP_WDS},

Shouldn't that depend on the interface type? I.e. set it for WDS/MESH
but clear it for station so that the station won't ack WDS frames? OTOH,
it may just as well ack WDS frames for itself...
=20

> +		associated =3D true ;

too much whitespace

> +			zd_mac_config_beacon(hw, conf->beacon);
> +			kfree_skb(conf->beacon);
> +			zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS | 100);

Does that mean you're hardcoding the beacon interval here while before
you confused me how we should handle that setting in userspace? :)

johannes

--=-nLJ8TLer8y1r5QWnLfHE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzWFjaVg1VMiehFYAQIOMw//aw56GLqoCF5Dz5CFpf0B4CuVU9TP/MfI
d826noOjTYsoMJjHfBIKbQtj+YjpDcQ0qJlSYbVQHPcMsVhJA8Lk7apYR82nYEtr
oFYeADVQ9lZ1YM0UvJpckcsQnMWNkQyWtxvQnjkeZy52WJ27y/f/KOITrA+v8Nze
sQtjv0h15jPqYgjpUGBas+VmRuCNDpWkf/vCAPmmV5qF1jjjEw25ZrjBBUPMYsub
TR8M3zSrzxRo3ORsJBuoVZ9GAdmBkC4vzsypVbjB8kSPQ/4NP6IrxAwn+0GcZG4m
J48py/EZJOBZ7CyT21vdl/c3tXNabIcn21IYSTKkx+0vXFVyxm1y0yBRQpaBffna
bKior5hZbQnPoXRB0WcldGcGBtl3+XxCPumSovkcab8OdiOUt4v2uZcuXcy8qan3
llgc/KKjUI7UlEF05X/obWScSpJT04oDPkUw66OYS+SVyrti7YwB+6hvf/nO6bg/
iGJPSgg0HubHpzl5DNkLyEXOd1TPsoL85OvucI0yLP5T0v3DgRK298XNx8UvQ9St
dM+vDHXeqlLBj73VZXpxfkKEtKWRRjjAOVGlndWIWPAY229ZApQGSawRoKA3V/Bn
Rafqy4kN4ttzTSaUyNXrRTXxJtimVfLscjdXFVwM+gpWy+AdAL/BsyRzDH6U1EoF
3mQDcHHMWP8=
=uLbQ
-----END PGP SIGNATURE-----

--=-nLJ8TLer8y1r5QWnLfHE--


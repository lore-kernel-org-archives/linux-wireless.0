Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXKLQIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:08:42 -0500
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <445f43ac0711101603s18cd70a7lb70dedea8cc5c3c0@mail.gmail.com> (sfid-20071111_000348_884788_D104D28E)
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 <1194689500.7258.61.camel@johannes.berg>
	 <445f43ac0711101603s18cd70a7lb70dedea8cc5c3c0@mail.gmail.com>
	 (sfid-20071111_000348_884788_D104D28E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nCxiRAid7HjEH+MNjiot"
Date: Mon, 12 Nov 2007 12:14:32 +0100
Message-Id: <1194866072.5229.8.camel@johannes.berg> (sfid-20071112_160846_372927_2F5E07DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nCxiRAid7HjEH+MNjiot
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> A mesh AP would have two interfaces, each with a different MAC
> address.  One IF_TYPE_MESH, the other IF_TYPE_AP.  Support for MAP, as
> you suggested, would be implemented in hostapd.

As far as I understand the specification, this is not required. Since we
currently have no drivers supporting multi-MAC operation, this is quite
a severe limitation and the draft seems to allow MAP operation with a
single address, cf. the description of the SSID element in 7.2.3.1
(Beacon frame format). ("Note: the SSID is a required IE in beacon
frames. To avoid having non-mesh STAs [...]")

Therefore, I think that having a separate MAP type device would be
beneficial because that allows hostapd to generate a beacon including an
SSID, respond to probe requests and still be a mesh point on the same
interface. The only way hostapd would have to be aware of this is that
it needs to create a different type of interface and include the mesh
information in the beacon.

Do you see anything precluding such operation? Some more logic would
have to be provided to achieve the appropriate mesh broad/multicast vs.
AP broad/multicast behaviour, of course, as described elsewhere wrt.
mesh broad/multicast frames being broad/multicast to associated STAs.

johannes

--=-nCxiRAid7HjEH+MNjiot
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzg1l6Vg1VMiehFYAQJmlRAAo7EnmxrOXA+r5WvSYZD1PsyGZlLUeUw0
Ylf8bnDrxpEWT0LUtV+i5TEJK/HlnahB8tiTVcLNw22pVavQEgtMGEe8wUcUWE3E
gfTBu335fA4ymjBMSCV+K+iOrPXGGg6IM64BNVc3FGOJg/JdetpZTul87bbc5YYo
BNjyd35yCSe5cm9pnRvNU5Hn1oSH/o8osw+yVeded4R/vmwOVHTMqyjHOC8YG+xt
khoKbDUcJbU5AUJ9INu1z6fYLBQAoWIQ6/QUELy06/zXiuhZ1GpThjbwaY8JmYbp
+V3DYqi0vZAPdmPqEN0HjFbsvA2R41BJFvt76zK6KX3wplpMF6B/6qp/SJ9n1RNy
GFJEXKOAHha6AMyQ8TtNDcyiPdWlpaFCCKzYGId/1skZpCeGTCCF/uip8ydX+7hq
8FNez0zs0/7SvyiSR8n/1QD5ECf7FSkYfhlRKWpFQj+guA+z70eJY/uRHhqhh/Pk
2b5zkv1rua6+XRqyTq+OStTAOZPWwa1naHHb8eumYG2QP7BLQvrrZC2z9gHIgk+c
LtNliM0b9gRYukcGfdCTROR8jy303J6Qk6XchiSjUF7EFBYrmw4Uaed87rmeW8S1
deTGLVW2aC9/f3UlMNtqY22qbeEcqN92ltTkNQopOyvJlgsrCKPfcgDFit5BcLmH
R/2GhRf6MEA=
=e9m1
-----END PGP SIGNATURE-----

--=-nCxiRAid7HjEH+MNjiot--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57362 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183AbbJRRrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 13:47:21 -0400
Message-ID: <1445190425.31451.70.camel@decadent.org.uk> (sfid-20151018_194726_500754_8E48065A)
Subject: [PATCH] iwlwifi: Fix module firmware information for 3160
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 18 Oct 2015 18:47:05 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bBTaOPSelQc003azFW3M"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bBTaOPSelQc003azFW3M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

IWL3160_UCODE_API_OK is no longer defined, so we end up with this
in the module information:

firmware:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi-3160-IWL3160_UCO=
DE_API_OK.ucode

It looks like IWL7260_UCODE_API_OK should be used instead now.

Fixes: ed65918735a5 ("iwlwifi: 7000: modify the firmware name for 3165")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
=C2=A0drivers/net/wireless/iwlwifi/iwl-7000.c | 2 +-
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless=
/iwlwifi/iwl-7000.c
index cc35f79..d7acbd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -348,6 +348,6 @@ const struct iwl_cfg iwl7265d_n_cfg =3D {
=C2=A0};
=C2=A0
=C2=A0MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
+MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
=C2=A0MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
=C2=A0MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
--=20
Ben Hutchings
A free society is one where it is safe to be unpopular. - Adlai Stevenson
--=-bBTaOPSelQc003azFW3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAViPbGee/yOyVhhEJAQoKEw/8CfyWWD8ZaP4qxTg3XjCj23DCN6lvWjBR
QsGkAdqIOng1Dm1Ig5YqSe+hTZCM2+tHkU1EjgdEHFa3JKkLRZxwUgl8qZwP0FhJ
BZEInFbcQPXUtpu+i73EKzSQZgSt8VTFAFAqtOfcFMiNOUbYx9s05U7M6AE7Yw+B
zSSMQ9D2FmN26tIaB3JJQRlSVhfjhy7izV6ug0IsmSGlKCwUIKLyqyRu3K1TqCGH
05VBm5Z7PFvGOHCuasSpOvPfKeS15l45o6Yvh3CMsNfzH7yXMyS+FOquEhqcw+nX
nYeZLYCZ40JHh22dh1fmOi/7DN5xUd4fg0EoBvTudxIgBkYFTlF35wQoz6a3XDdU
EdM/vPklxnFMOo49WUOrcXUqb2Ghhtk6fXGUGdAJuqO5UB+YFNFYryNvjAg+ASX4
9GZ8XbxYvjfmf354o5MRzm+p0BhtrcYoF06aOuB60wcvM0Nvf/YBMjwoqQ1tf4EE
NiTMRwmdj/x2OPGRityxPDDu0O18pQm2hX8xxtEkg652sK404wopcoSVwxe5yVyi
zApJkMsApFR/YXp8f01PqKASTbE0nlhFCvOuZh2UuN+fpN9v4W0GDl/6CQqKbGCq
UXjA3MpysjrF0fifezPeX50Saz3ki5lSh17tS9lGvYFo69xCzvqOjmb9K9/7U603
T/vnKkgtatk=
=RDYD
-----END PGP SIGNATURE-----

--=-bBTaOPSelQc003azFW3M--

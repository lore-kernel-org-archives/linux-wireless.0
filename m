Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46604 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdJLROl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 13:14:41 -0400
Date: Thu, 12 Oct 2017 18:14:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20171012171424.435b2cwnixnkl72r@sirena.co.uk> (sfid-20171012_191547_513914_EAFDD658)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m75tuv6t7oylusqm"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--m75tuv6t7oylusqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c

between commit:

  44fd09dad5d2b78e ("iwlwifi: nvm: set the correct offsets to 3168 series")

=66rom the wireless-drivers tree and commit:

  a2ff48af65ad661a ("iwlwifi: remove redundant reading from NVM file")

=66rom the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index c3a5d8ccc95e,d9a2ea9dd93f..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@@ -75,9 -75,10 +75,10 @@@
  #include "iwl-prph.h"
  #include "iwl-io.h"
  #include "iwl-csr.h"
+ #include "fw/acpi.h"
 =20
  /* NVM offsets (in words) definitions */
 -enum wkp_nvm_offsets {
 +enum nvm_offsets {
  	/* NVM HW-Section offset (in words) definitions */
  	SUBSYSTEM_ID =3D 0x0A,
  	HW_ADDR =3D 0x15,
@@@ -89,13 -90,6 +90,9 @@@
  	SKU =3D 2,
  	N_HW_ADDRS =3D 3,
  	NVM_CHANNELS =3D 0x1E0 - NVM_SW_SECTION,
 +
- 	/* NVM calibration section offset (in words) definitions */
- 	NVM_CALIB_SECTION =3D 0x2B8,
- 	XTAL_CALIB =3D 0x316 - NVM_CALIB_SECTION,
-=20
 +	/* NVM REGULATORY -Section offset (in words) definitions */
 +	NVM_CHANNELS_SDP =3D 0,
  };
 =20
  enum ext_nvm_offsets {
@@@ -758,15 -745,8 +755,12 @@@ iwl_parse_nvm_data(struct iwl_trans *tr
  			kfree(data);
  			return NULL;
  		}
 +
 +		ch_section =3D cfg->nvm_type =3D=3D IWL_NVM_SDP ?
 +			     &regulatory[NVM_CHANNELS_SDP] :
 +			     &nvm_sw[NVM_CHANNELS];
 +
- 		/* in family 8000 Xtal calibration values moved to OTP */
- 		data->xtal_calib[0] =3D *(nvm_calib + XTAL_CALIB);
- 		data->xtal_calib[1] =3D *(nvm_calib + XTAL_CALIB + 1);
  		lar_enabled =3D true;
 -		ch_section =3D &nvm_sw[NVM_CHANNELS];
  	} else {
  		u16 lar_offset =3D data->nvm_version < 0xE39 ?
  				 NVM_LAR_OFFSET_OLD :

--m75tuv6t7oylusqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnfou8ACgkQJNaLcl1U
h9AD1gf/fMtJnh6026YmxZ+l00iLKo/ScFYrdDhfOHhVIMISR3wxEyJCya6adqdq
e+ddDsBCGkA7KJqgdzOLKm2u9iigj6K+8kc/KL1dbjbvG1h9BSLEVJIa7TCU7Ai7
3CHSq9IvRNlhqxcqLb8Cgjx3Lo1pWuVDfvoogsr6axLtckFPN5A7Q5ptbORgIyna
5f5pa1AleypTKvzLIBb2fhDMJg9frs8nv+BP7a5UyHNWVL9cFfXXOkHazqsyc9tS
0Vju/gd+yMPIyctgzx3DZRif+CNtoze6io14/nmDEXHOICh5z4r9FvBY4SeM6YbH
MyovWIyjPwunICOsNamVbK/fIl7ENQ==
=/nmY
-----END PGP SIGNATURE-----

--m75tuv6t7oylusqm--

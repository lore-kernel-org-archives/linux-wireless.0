Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:57306 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757206AbdJLRVE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 13:21:04 -0400
Date: Thu, 12 Oct 2017 18:20:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20171012172053.3lrrstim7a2xg57o@sirena.co.uk> (sfid-20171012_192223_248855_BFF7E97C)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jo25remj2oo7eet5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jo25remj2oo7eet5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/cfg/a000.c

between commit:

  44fd09dad5d2b78ef ("iwlwifi: nvm: set the correct offsets to 3168 series")

=66rom the wireless-drivers tree and commit:

   dd05f9aab4426ff1 ("iwlwifi: pcie: dynamic Tx command queue size")

=66rom the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index a440140ed8dd,076f8d6d1124..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
@@@ -133,17 -133,18 +133,18 @@@ static const struct iwl_ht_params iwl_a
  	.use_tfh =3D true,						\
  	.rf_id =3D true,							\
  	.gen2 =3D true,							\
 -	.ext_nvm =3D true,						\
 +	.nvm_type =3D IWL_NVM_EXT,					\
- 	.dbgc_supported =3D true
+ 	.dbgc_supported =3D true,						\
+ 	.tx_cmd_queue_size =3D 32
 =20
  const struct iwl_cfg iwla000_2ac_cfg_hr =3D {
- 		.name =3D "Intel(R) Dual Band Wireless AC a000",
- 		.fw_name_pre =3D IWL_A000_HR_FW_PRE,
- 		IWL_DEVICE_A000,
- 		.ht_params =3D &iwl_a000_ht_params,
- 		.nvm_ver =3D IWL_A000_NVM_VERSION,
- 		.nvm_calib_ver =3D IWL_A000_TX_POWER_VERSION,
- 		.max_ht_ampdu_exponent =3D IEEE80211_HT_MAX_AMPDU_64K,
+ 	.name =3D "Intel(R) Dual Band Wireless AC a000",
+ 	.fw_name_pre =3D IWL_A000_HR_FW_PRE,
+ 	IWL_DEVICE_A000,
+ 	.ht_params =3D &iwl_a000_ht_params,
+ 	.nvm_ver =3D IWL_A000_NVM_VERSION,
+ 	.nvm_calib_ver =3D IWL_A000_TX_POWER_VERSION,
+ 	.max_ht_ampdu_exponent =3D IEEE80211_HT_MAX_AMPDU_64K,
  };
 =20
  const struct iwl_cfg iwla000_2ac_cfg_hr_cdb =3D {

--jo25remj2oo7eet5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnfpHUACgkQJNaLcl1U
h9CgaQf9EhmgoNwaAh8MUww2PhAUrreLv7A7kdLO2qHeXzhdG1mWmVHKSzxIRL9q
FQ8tA4SNQ+NIgj8fO7CzeyII5ePHolYh/ERtZIeFfEwftZfpjVxhhBUlqNaPgLNI
DBQkpH+CvLA2SRh1C5ZRisiBKclsrMZ3sDz7asE8LFiep2JPpThX1H2yd1spmnmE
qRr7ivBxnBWWR6Z3NCWiZWVNBONXWGIgeFZbzKbR9+D7Rkl4gQxEt7Seu6xMoO2C
YBlN+ATA9dX5uBHohEvxt6j9FhkCjnRt4qeEgR/Of3m+6dLtRq+RTO/Bj4f3dDyl
eGQyf+XGOf5IN+BtGBvgLbfOjOhtBQ==
=aCiN
-----END PGP SIGNATURE-----

--jo25remj2oo7eet5--

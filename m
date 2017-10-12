Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:36220 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbdJLRZU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 13:25:20 -0400
Date: Thu, 12 Oct 2017 18:25:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk> (sfid-20171012_192627_202184_B716AB75)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r72ubnno7js4rha6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--r72ubnno7js4rha6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/iwl-config.h

between commit:

   dd05f9aab4426f ("iwlwifi: pcie: dynamic Tx command queue size")

=66rom the wireless-drivers tree and commit:

   44fd09dad5d2b7 ("iwlwifi: nvm: set the correct offsets to 3168 series")

=66rom the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 71cb1ecde0f7,b9f3b350fe34..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@@ -332,7 -320,9 +332,9 @@@ struct iwl_pwr_tx_backoff=20
   * @integrated: discrete or integrated
   * @gen2: a000 and on transport operation
   * @cdb: CDB support
 - * @ext_nvm: extended NVM format
 + * @nvm_type: see &enum iwl_nvm_type
+  * @tx_cmd_queue_size: size of the cmd queue. If zero, use the same value=
 as
+  *	the regular queues
   *
   * We enable the driver to be backward compatible wrt. hardware features.
   * API differences in uCode shouldn't be handled here but through TLVs
@@@ -382,7 -371,9 +384,8 @@@ struct iwl_cfg=20
  	    use_tfh:1,
  	    gen2:1,
  	    cdb:1,
 -	    ext_nvm:1,
  	    dbgc_supported:1;
+ 	u16 tx_cmd_queue_size;
  	u8 valid_tx_ant;
  	u8 valid_rx_ant;
  	u8 non_shared_ant;

--r72ubnno7js4rha6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnfpXcACgkQJNaLcl1U
h9AVsAf9FiGOCXuWpZs+zaxLvjlp7xRF2PvtmTrUevbD9KqGbdckPXbCXyWfA1Up
apZgjzxcP3Fz8325ktILoQ1E4yaTC3rhHVzoM2GqtZ+WJGfyoiOWADREWTYTbUzw
h5/t9O+1c9awFSj6BC9CYl6ODNf9eVRtZ7g7USdJTH5EgCpHgjYhHCBw4ZAgEkxT
FWWDdD5HWgH3RXzABAy0Lcj5jG2W3bemqib6sZrctmnjQROLxQoZ6LOfLDcfltBP
uXpP6TUOqC6xToyQWUlZLcHF7Cn3mKvb8WyrbERK181tH1YJLRCGBeQTj5Zo3r73
tSNnK91UjJqW8WpWIuOyyuJX7Xy34w==
=truS
-----END PGP SIGNATURE-----

--r72ubnno7js4rha6--

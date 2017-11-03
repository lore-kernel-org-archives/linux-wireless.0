Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43800 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754593AbdKCKCs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 06:02:48 -0400
Message-ID: <1509703364.4492.350.camel@coelho.fi> (sfid-20171103_110308_461074_4EBA067C)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Fri, 03 Nov 2017 12:02:44 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-INNn6a456rVJM7SU2P70"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-11-03
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-INNn6a456rVJM7SU2P70
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's the final set of patches intended for v4.15.  It's not too
important to get them into v4.15 if there is no time anymore.  There
are a few new PCI IDs that can be added in the rc series or stable
(they need to go to other stable releases anyway).  And there's also
one bugfix that I could also send to rc.  The rest are just cleanups,
improvements or related to the A000 series.  Let me know how it goes
and I'll adapt if needed.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit e226fb5affccca98c405de80527180224d93d251=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2017-11-02 19:48:25 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-11-03

for you to fetch changes up to 57b36f7fcb39c5eae8c1f463699f747af69643ba:

  iwlwifi: add new cards for a000 series (2017-11-03 11:56:10 +0200)

----------------------------------------------------------------
iwlwifi updates

* Some new PCI IDs;
* A bunch of cleanups;
* The timers update by Kees;
* Add more register dump call-sites;
* A fix for a locking issue in the TX flush code;
* Actual implementation of the TX flush code for A000;
* An optimization to drop RX frames during restart to avoid BA issues;

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: mvm: rs: remove the ANT C from the toogle antenna logic
      iwlwifi: remove dead code for internal devices only
      iwlwifi: remove host assisted paging

Ihab Zhaika (3):
      iwlwifi: add new cards for 8260 series
      iwlwifi: add new cards for 8265 series
      iwlwifi: add new cards for a000 series

Kees Cook (1):
      iwlwifi: mvm: Convert timers to use timer_setup()

Kirtika Ruchandani (1):
      iwlwifi: Add more call-sites for pcie reg dumper

Liad Kaufman (1):
      iwlwifi: mvm: reset seq num after restart

Luca Coelho (1):
      iwlwifi: mvm: hold mutex when flushing in iwl_mvm_flush_no_vif()

Sara Sharon (6):
      iwlwifi: mvm: use RS macro instead of duplicating the code
      iwlwifi: mvm: cleanup references to aggregation count limit
      iwlwifi: mvm: improve latency when there is a reorder timeout
      iwlwifi: fix multi queue notification for a000 devices
      iwlwifi: mvm: refactor iwl_mvm_flush_no_vif
      iwlwifi: mvm: add missing implementation of flush for a000 devices

Shahar S Matityahu (1):
      iwlwifi: drop RX frames during hardware restart

 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |  51 -----------------=
--------------------------------
 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h |  24 -----------------=
------
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   8 --------
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     | 103 ++++++++++++-----=
---------------------------------------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   3 ---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 --
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   6 ------
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  42 +++++++++++------=
-----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  15 ---------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  62 +++++++++++++++++=
+++++++++++++-----------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  10 +++-------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  23 +++++++++++++++++=
+++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  50 +++++++++++++++++=
+++++++++++--------------------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   7 ++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   1 +
 20 files changed, 127 insertions(+), 300 deletions(-)
--=-INNn6a456rVJM7SU2P70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAln8PsQACgkQoUecoho8
xfp9fQ//WQ0OxRc6g3ujjNkX0Ge7fOnvliruiI7FPcoehEuNb8Y8OsE8BYPxvkTt
E81aYc0s1d8anjcDK9EUjSd18/Vg9gvtDY1vHkNw0NlOSza1cYuhaDzYzYHQ+Zwf
FjeQqT8vqDJDnvFcQGpLJzwZM5K77/gcJ+5L9E0NMImBT2VeSsoOEVzj9gUZ4JNg
N05EojCayUA1pRNvcl/sZGh3BXoB/akopHdlcqEmymIeVNcq0QI/EL0UuSE9XfgI
AJ/lE9T1Pn2/T5PiqMq+g3JofcD1f/p9+DeLd/XIOJTbha6MkmLp2Es/SKA3oknl
bWbOwU0AQ4bv8IsP96kuHCoRO5atBHqTY0j6Q57/jybt8ZooD1b+Sa/2IH7PEtLA
CYnpOyKOOvtgiPK8SrcdDk8oanU4UTXS8G/goJZmU+46dNLqELd/1LbBPFRNvsFt
igkbyu+VI5h0L2sK8dWsKFor2Mk8r0GjdXfEeFunCK56qLtraLXUhEpk5zS7GLcA
/XjXhVpVMc/2XHO83ecUaOFp5ZuUSCNqLMfgEpLKW6MVjIqWy6Zx2Q4LJa9OSv7U
vmojIUSug/oewMSeVmUBLY/WVX85hgLVY+wtSy/iRIZXlnxrpHokHYMlP/WIIzT5
dY7lWJGpTQN4HlIyqsFnVc6CaKTDfpdAllrRvtLX+IGlgUpKVyo=
=Ylw7
-----END PGP SIGNATURE-----

--=-INNn6a456rVJM7SU2P70--

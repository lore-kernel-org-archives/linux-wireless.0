Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54228 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751184AbdIOLrY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 07:47:24 -0400
Message-ID: <1505476034.5400.291.camel@coelho.fi> (sfid-20170915_134736_469816_E12A1A24)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 15 Sep 2017 14:47:14 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LTBGvC2OuSCZWitxf1Qu"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-09-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LTBGvC2OuSCZWitxf1Qu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is the first set of fixes for 4.14.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 2eabc84d2f8e4f36d3719eeb6a330e10c46c8da7=
:

  iwlwifi: mvm: only send LEDS_CMD when the FW supports it (2017-09-07 19:4=
0:09 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-09-15

for you to fetch changes up to 5f90472c00ddf1e64c2865f71cced297bd5f80a2:

  iwlwifi: mvm: fix reorder buffer for 9000 devices (2017-09-08 11:52:51 +0=
300)

----------------------------------------------------------------
First set of fixes for 4.14

* A couple of bugzilla bugs related to multicast handling;
* Two fixes for WoWLAN bugs that were causing queue hangs and
  re-initialization problems;
* Two fixes for potential uninitialized variable use reported by Dan
  Carpenter in relation to a recently introduced patch;
* A fix for buffer reordering in the newly supported 9000 device
  family;
* Fix a race when starting aggregation;
* Small fix for a recent patch to wake mac80211 queues;
* Send non-bufferable management frames in the generic queue so they
  are not sent on queues that are under power-save;

----------------------------------------------------------------
Avraham Stern (2):
      iwlwifi: mvm: send all non-bufferable frames on the probe queue
      iwlwifi: mvm: wake the correct mac80211 queue

David Spinadel (1):
      iwlwifi: mvm: Flush non STA TX queues

Luca Coelho (4):
      iwlwifi: mvm: use IWL_HCMD_NOCOPY for MCAST_FILTER_CMD
      iwlwifi: mvm: handle FIF_ALLMULTI when setting multicast addresses
      iwlwifi: mvm: initialize status in iwl_mvm_add_int_sta_common()
      iwlwifi: mvm: set status before calling iwl_mvm_send_cmd_status()

Matt Chen (1):
      iwlwifi: mvm: fix wowlan resume failed to load INIT ucode

Naftali Goldstein (1):
      iwlwifi: mvm: change state when queueing agg start work

Sara Sharon (1):
      iwlwifi: mvm: fix reorder buffer for 9000 devices

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 62 +++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |  7 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  8 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 10 +++++-----
 9 files changed, 80 insertions(+), 17 deletions(-)
--=-LTBGvC2OuSCZWitxf1Qu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlm7vcIACgkQoUecoho8
xfqnQw//VZ4TeU3TIvEpTYFAcaHJIygxrG/fXeWBLgD1xur05t+cUWbnv+ofkSil
LwtcKISMXB5/WpHCWHnk9uhxwgIgowk0/WFey9B6BSATjt/BqAezao7SLUyN8VTL
HrzWpEBie5LcDfKMxheMhzfeK3UN9V62UtTNJPc10fk2hdO9BeZidioTSei555wJ
4nNIVx4V9WobXCB41if52TOyzCoBMVeWMhCGdRm/UoO72J0M0ouABzkfJZCGcCkv
erYF3p6Vg69gXHFp8VKvBG8ypwa0aY7ZW8Psi9Gq4aJM0iIQ5x30c3zKuEPU7iap
NjDcqK1hnvqiyTS/OBGY2YNKJSof9SgXwiQwBvUVQoQAoerCY+ml0VWE+b3KjSjv
PWk4rgMnitL7b+x3Cg3VNAkJS5hLeGH+GJ3NXFYG8z9i+5zx9n9A62MSuDiUzBRq
WH5i1bDKTQq2j59Yp1hyMtJwJLdZ3DmE3rFxT5R/O5f26rCs7BVdtTMRtLBFkzKG
Gt6m/IEn4yx8LuOtKQNPGFZhO5IMURnHsAJfHlL0vFE0WrSNgla1Jz1vMyaKyoWw
b4xymF13jR16cOVObDn8NI0sIjjWfndOgu8gSZB1uRyJPYrMT6SGq8XgJ13hYEIq
T7YpFTzisbGjmqltnEKOEPD8i1Ry7c9diulJZmgSd3ZahuyPimU=
=pHAg
-----END PGP SIGNATURE-----

--=-LTBGvC2OuSCZWitxf1Qu--

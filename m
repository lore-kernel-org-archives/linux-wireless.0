Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49168 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752312AbdLETKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 14:10:24 -0500
Message-ID: <1512501020.4827.197.camel@coelho.fi> (sfid-20171205_201029_036567_6AFFD2A9)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Date: Tue, 05 Dec 2017 21:10:20 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-kQ5p+XFQsxXasBA6BhVp"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-12-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kQ5p+XFQsxXasBA6BhVp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is my second batch of patches intended for v4.16.  As I mentioned
in the patchset thread, I moved patches 5/15 and 6/16 to iwlwifi-fixes.=20
Otherwise nothing major here, just the usual continued development.
More details about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 80b0ebd488b3edaf3e5ed08c34a952c804e3a635=
:

  Merge tag 'iwlwifi-next-for-kalle-2017-11-29' of git://git.kernel.org/pub=
/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2017-12-02 15:22:54 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-12-05

for you to fetch changes up to 0190ff24e55efd3e02479537c2d91835602fffa3:

  iwlwifi: mvm: request statistics when reading debugfs (2017-12-05 21:01:4=
3 +0200)

----------------------------------------------------------------
Second batch of iwlwifi updates for v4.16

* Initial work for rate-scaling offload;
* Support for new FW API version;
* Some fixes here and there;

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: add WFA vendor specific TPC report IE to probe request

Emmanuel Grumbach (1):
      iwlwifi: mvm: remove set but unused variable in iwl_mvm_roc_done_wk

Gregory Greenman (7):
      iwlwifi: mvm: rs: introduce new API for rate scaling
      iwlwifi: mvm: rs: add ops for the new rate scaling in the FW
      iwlwifi: mvm: rs: add basic implementation of the new RS API handlers
      iwlwifi: mvm: rs: new rate scale API - add FW notifications
      iwlwifi: mvm: rs: new rate scale API - add debugfs hooks
      iwlwifi: mvm: rs: add size checks when printing to a buffer
      iwlwifi: mvm: rs: add sanity check when sending LQ command

Johannes Berg (1):
      iwlwifi: mvm: request statistics when reading debugfs

Liad Kaufman (1):
      iwlwifi: mvm: make init_dbg effective only on failure

Luca Coelho (1):
      iwlwifi: bump FW API to 36 for 8000 and up

Sara Sharon (1):
      iwlwifi: mvm: avoid dumping assert log when device is stopped

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h |  15 +++++
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h       | 262 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |  79 +++++++++++++++=
+++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |   8 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  13 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  10 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |   9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c       | 314 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c          | 230 +++++++++++++++=
+++++++++++++++++++++++---------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h          |  48 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c        |  35 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         |  19 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h         |   7 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c  |   9 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |   8 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  14 ++++-
 23 files changed, 952 insertions(+), 144 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
--=-kQ5p+XFQsxXasBA6BhVp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlom7xwACgkQoUecoho8
xfrFPQ//fRGRCDysGkn5dzwCdpeeqRDqWcsDln5driTgwtuNSYL0+/pjZezoLjns
n0S7eNLzyxrjc4gCkvWQxwpmTsuR8M8YAeQVuadgWapgSkETDmUyBBXYSDf9zvDw
qlHi8EizwLxPoXk2fs09TEeugeEgSg1JnpIMDJPyXyp7FhaHyNV3GfS1RPkk2B46
wMwoVU1c5M2jANyf0s5eitsDDy7f00udv/5Y1O8Im1S7Pi5DfbHruIlE/yjfbkWz
SB8YwKG3/DcHGgV2lVG3bYLVSvCxZItbItVzS3alPf/HMHmREHkP7zlreJQWNn7D
YDr7+8JlX+gBMU5VykYtR/pvlAsCQiIOeSHneb6MnxfHeAvUZsxPT/mXK3YpZJoI
4iJT6rhn8PsqZFZlj0f1XWa4saZygKktUbQioWT2fQziIgRUw9+Am79eKkOiLZdL
6UVg9mJJERYjjjCZITld0jy1eivtD53Wmc/KdD50grQeGXnkcFho5fuTrbqEY85Z
+LG6aZQ3kqr5Ccctvq0ZeRufrt+amABqd2wGEe65XiVTc5S0M6HnqUSYMC6bl5Da
gwhhGt+xZUH7YdRqpNeHVudot4Pp54ecZhzOr/0TnPXsP45HgnQrw1NPuA+sOop/
5DUHgo4hbYilRpbLxxq8dPQddpdYFebEkHvQXgZSh8eijkvdu9E=
=ndD6
-----END PGP SIGNATURE-----

--=-kQ5p+XFQsxXasBA6BhVp--

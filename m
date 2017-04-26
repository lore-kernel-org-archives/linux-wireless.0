Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54610 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751100AbdDZI0o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:26:44 -0400
Message-ID: <1493195190.14233.2.camel@coelho.fi> (sfid-20170426_102652_874880_DC33D07A)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Wed, 26 Apr 2017 11:26:30 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xtTAR4bNhn8tn3XfYckd"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-04-26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xtTAR4bNhn8tn3XfYckd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's another pull-request intended for v4.12.=C2=A0 This is generic
development work, nothing really stands out.=C2=A0 More=C2=A0details in the=
 tag
description.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit a0597834dc0e1af68f48f92b31617b360a14dfc8=
:

  rt2800: fix mt7620 E2 channel registers (2017-04-20 14:00:54 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-04-26

for you to fetch changes up to 291084951825e1efca081926b10bf3ff7e872476:

  iwlwifi: adjust NVM parsing APIs for new a000 method (2017-04-25 23:08:32=
 +0300)

----------------------------------------------------------------
One more pull-request intended for 4.12.  These are the changes:

 * The firmware for 7265D and 3168 NICs is frozen at version 29;
 * Sari continues working heavily on support for A000 series;
 * A bunch of fixes;
 * Some cleanups here and there;

----------------------------------------------------------------
Dor Shaish (1):
      iwlwifi: mvm: freeze 7265D and 3168 on API version 29

Haim Dreyfuss (1):
      iwlwifi: mvm: Ignore wifi mcc update in the driver while associated

Johannes Berg (6):
      iwlwifi: mvm: make iwl_run_unified_mvm_ucode() static
      iwlwifi: mvm: avoid variable shadowing
      iwlwifi: pcie: remove superfluous trans->dev assignment
      iwlwifi: don't leak memory on allocation failure
      iwlwifi: remove module loading failure message
      iwlwifi: pcie: apply no-reclaim logic only to group 0

Liad Kaufman (2):
      iwlwifi: pcie: support debug applying on a000 hw
      iwlwifi: gen2: support nmi triggering from host

Mordechai Goodstein (1):
      iwlwifi: mvm: scan: avoid "big" prints

Sara Sharon (12):
      iwlwifi: mvm: support new rate flags
      iwlwifi: mvm: don't reserve queue in TVQM mode
      iwlwifi: mvm: map cab_queue to different txq_id
      iwlwifi: mvm: move internally to use bigger INVALID_TXQ
      iwlwifi: mvm: remove color definition
      iwlwifi: mvm: use defines instead of variables for shared dwell times
      iwlwifi: mvm: remove references to queue_info in new TX path
      iwlwifi: mvm: support station type API
      iwlwifi: move to 512 queues
      iwlwifi: rename wait_for_tx_queues_empty
      iwlwifi: mvm: memset binding before setting values
      iwlwifi: adjust NVM parsing APIs for new a000 method

Sharon Dvir (2):
      iwlwifi: mvm: check if returned value is NULL
      iwlwifi: mvm: handle possible BIOS bug

 drivers/net/wireless/intel/iwlwifi/dvm/lib.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c        |  15 ++---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-io.c         |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c  |  32 +++++------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h  |  16 +++++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h      |  10 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h  |  28 ++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h |  38 +++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c         | 161 ++++++++++++++++=
++++++++++++-------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   |  11 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |  37 ++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  10 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c        |   9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        |   9 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c         |  11 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c         |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c       |  86 ++++++++--------=
------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c        | 229 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h        |   7 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c         |  13 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c      |  96 ++++++++++++++++=
++++++----------
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c |   4 ++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h  |   7 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     |   5 +-
 34 files changed, 521 insertions(+), 350 deletions(-)
--=-xtTAR4bNhn8tn3XfYckd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlkAWbYACgkQoUecoho8
xfrFOBAAu76TQ1hbSTV7Uru7AzcKQbH/kDtZCYW5lVmtQ6jN15gQA7ef2N8wbtwp
TgMM8aLAgj/S/Qq3PoMJZwTX/U9grkWzqJaRY85zd6vc+K4/wuFYz5WIpkNFxH/3
Yd8m8yTmObOwij3hpo3qUchrvOOuv9fqjN7LNenqBDOC3zgi8yjdKnzJLSwknSUk
BVFF+4Z01wJvtk98cT1kt3WNffyUvM0x8RFM07JayMUaVYCKMO15WEc/mNsVG1Qo
mLLSr0zdz2Rje1OWTeYSaD8iiK4s+5xOaaDJsTMehUQhWD/IqAVYwkDYl7i1M0GZ
E4GdsX/1vj+5uu9kqigmVy9QAF4PQRwDxsua5EC/TVe/SQ7tx/o0MfTzYainFlvq
rA3kvMvZtZwh2TDbEo63FmugGmDHPcGvlLc/wR+fVURKf1irKU0T8Wq/fkZzToBO
YOzx3iodDOZ3cWUhDHHhiZvCyFijufH6MpyuVzFyJfgSWP9pANkpz3z7EGklnfCx
gx6bT4+tRXFKcST9mTRkBuPwOheiKKCOXn4A9xxWagLrVYju0Ad8Ow7L8xZHpjWz
rBqFAiOG9UvNccaTP8epfn5j797zhkNKqs4l2S9+3fv9ZIJh8DufTpgRjpWaj67q
3p+FPQv6kDYI+V8+w6N9qw1BsTk2PQJDG0/9x4rvQO0gG27SSgU=
=EHo1
-----END PGP SIGNATURE-----

--=-xtTAR4bNhn8tn3XfYckd--

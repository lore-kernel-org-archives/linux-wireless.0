Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37170 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753047AbeC1UCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 16:02:55 -0400
Message-ID: <1522267371.3786.294.camel@coelho.fi> (sfid-20180328_220259_285286_72055975)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Date: Wed, 28 Mar 2018 23:02:51 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ON/fOrqkQawDzbopbeoO"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-03-28
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ON/fOrqkQawDzbopbeoO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is a batch of patches intended for v4.17.  Nothing major here,
just the usual continued development, bugfixes, new FW APIs and some
minor features.  More details about the contents in the tag
description.

The commit messages you commented on have been fixed, as you can see in
v2 of those patches that I sent to the list.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 6b7d5c0745905b71127d0c1ae6eeddc09bbdaad8=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-driver=
s.git (2018-03-28 11:57:34 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-03-28

for you to fetch changes up to 378c8931342f99c5a6fce21e38ef46ac39395464:

  iwlwifi: wrt: add fw force restart via triggers (2018-03-28 22:43:40 +030=
0)

----------------------------------------------------------------
iwlwifi patches for 4.14

* Fix a UBSAN warning;
* Improvement in the net-stack/driver log syncing
* An RCU lock fix in the new rate-scaling code;
* Support for new PCI IDs for the 9000 family;
* Support for a new API version;
* Initial work for supporting the new ETSI rules;
* Support for advanced dwell in scanning;
* Support for OCE in scanning;
* Some debugging improvements;
* Other small improvements and cleanups here and there.

----------------------------------------------------------------
Ayala Beker (1):
      iwlwifi: fw api: support the new scan request FW API version

Emmanuel Grumbach (1):
      iwlwifi: bump the max API version for 9000 and 22000 devices

Haim Dreyfuss (1):
      iwlwifi: api: Add geographic profile information to MCC_UPDATE_CMD

Ilan Peer (1):
      iwlwifi: mvm: Allow iwl_mvm_mac_mgd_prepare_tx() when associated

Luca Coelho (2):
      iwlwifi: mvm: check if mac80211_queue is valid in iwl_mvm_disable_txq
      iwlwifi: add a bunch of new 9000 PCI IDs

Mordechay Goodstein (1):
      iwlwifi: set default timstamp marker cmd

Sara Sharon (4):
      iwlwifi: mvm: flip AMSDU addresses only for 9000 family
      iwlwifi: mvm: take RCU lock before dereferencing
      iwlwifi: mvm: move TSO segment to a separate function
      iwlwifi: mvm: save low latency causes in an enum

Shahar S Matityahu (1):
      iwlwifi: wrt: add fw force restart via triggers

Zamir, Roee (2):
      iwlwifi: mvm: add adaptive dwell support
      iwlwifi: mvm: add support for oce

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h  |  20 ++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h     |  73 +++++++++++++++=
++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          |  10 +++++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c      |  24 +++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h      |   5 +++
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |  16 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |  11 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  15 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  48 +++++++++++++++=
+++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c       |   6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |  25 ++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c        | 199 +++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          | 158 +++++++++++++++=
+++++++++++++++++++++++++-------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  19 ++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        | 157 +++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 18 files changed, 600 insertions(+), 196 deletions(-)
--=-ON/fOrqkQawDzbopbeoO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlq79OsACgkQoUecoho8
xforeg//QfFd+4PEFOQSP0beVz7A4sLqK0N9MKoRvMiSzwXjlWoEl1hvdX2SwBtN
HrpIrAQ/ZSBgEljtcnETFLpKh/oebAN6qdxdZMOP2r/jqu3breAB2ARoxwmAXtX1
cHis4j82ZtVKnd1jFoVacse5lq1+Bo6fiTl67OWFyTNF8S2LVyKb5TBZ55rbZJP3
9kz8srLWDTH7aYO7M5t5CcuZErOCJkpXgdJZdUiJblElm9/CeJkqAh+1aR9kYyYE
2wQJ75uTG3/Poj/dk72GIbDoNwlnlyWB8VUE3RRGjRafCF/+eO/YziWwKO8F32Sq
3/VD6KtLgeW7U8+i41+8ygG9pn6iZmDMKAcQMJe6nLuu5A9c/JwLVmqySl6+7o9I
qe2hqEGK9zqweqhjZ5EVdjMEgLiDb5tGQkdnu6Bo5GduCCm8rnfSmlmOCnzqx7tc
eiJu/bm/x08acSgaW8ruEkEm7boPc3I9lRxynzNyLaWKvCWQUmAjeV9cvEngPdyQ
TQvSYXGj1rpfcvasn6NU/N8wS5GgGB8yzU5gYpCavSw5Md0grqFd/SxGv4/MyuTj
rHuTQZTIcrg54x0izyXrncm6yxgvjA+K2Ocyk421XRKzeJZ4m3xKnVpgSERHcEd/
LMdKY9zc9zh6yD622IanOlqq+gkUlkNVRulGUF/uXbapK9vFpsw=
=pTSE
-----END PGP SIGNATURE-----

--=-ON/fOrqkQawDzbopbeoO--

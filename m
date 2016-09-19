Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56108 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932705AbcISIuQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:50:16 -0400
Message-ID: <1474275007.5664.96.camel@coelho.fi> (sfid-20160919_105213_141675_581C4C70)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Mon, 19 Sep 2016 11:50:07 +0300
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-95UmMXKWEJ7BNT6hk6Kk"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-09-19-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-95UmMXKWEJ7BNT6hk6Kk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Please drop my previous pull-request. =C2=A0There was a compilation error
that I missed to due a missing flag in my .config. =C2=A0I fixed it now and
this is the new pull request that includes the fix.

Here we go again, now I'm almost catching up with the pending stuff in
our internal tree, just in time for 4.9.=C2=A0=C2=A0This pull contains a bu=
nch of
fixes to DQA and new HW support code, a few new features and some
cleanups.=C2=A0=C2=A0More details in the tag description.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 80ba4f1d365af206b9e818d17d22fed02fe5def0=
:

  mwifiex: fix null pointer deference when adapter is null (2016-09-17 18:2=
6:32 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2016-09-19-2

for you to fetch changes up to 0979a913f879ea39504200d83fb9f275a555a58d:

  iwlwifi: pcie: use LIST_HEAD() macro (2016-09-19 11:29:35 +0300)

----------------------------------------------------------------
* added support for MU-MIMO sniffer
* added support for RRM by scan
* added support for packet injection
* migrate to devm memory allocation handling
* some fixes, mostly in DQA and new HW support
* other generic cleanups

----------------------------------------------------------------
Arik Nemtsov (1):
      iwlwifi: move BIOS MCC retrieval to common code

Aviya Erenfeld (1):
      iwlwifi: mvm: add support for MU-MIMO air sniffer

Avrahams Stern (1):
      iwlwifi: mvm: Add support for RRM by scan

Emmanuel Grumbach (1):
      iwlwifi: don't export trace points that are used in iwlwifi only

Haim Dreyfuss (1):
      iwlwifi: check for valid ethernet address provided by OEM

Ido Yariv (1):
      iwlwifi: mvm: Add mem debugfs entry

Johannes Berg (6):
      iwlwifi: mvm: compare full command ID
      iwlwifi: mvm: make iwl_mvm_update_sta() an inline
      iwlwifi: mvm: document passing unexpected Block Ack Request frames
      iwlwifi: mvm: move AP-specific code to right function
      iwlwifi: mvm: use LIST_HEAD() macro
      iwlwifi: pcie: use LIST_HEAD() macro

Liad Kaufman (1):
      iwlwifi: mvm: remove variable shadowing

Oren Givon (1):
      iwlwifi: add new 8265 series PCI ID

Roee Zamir (1):
      iwlwifi: mvm: Add debugfs function for clocks diff

Sara Sharon (9):
      iwlwifi: pcie: fix typo in struct name for a000 devices
      iwlwifi: mvm: cleanup skb queue functions use
      iwlwifi: mvm: fix DQA AP mode station assumption
      iwlwifi: mvm: support BAR in reorder buffer
      iwlwifi: mvm: support packet injection
      iwlwifi: pcie: log full command sequence
      iwlwifi: move to wide ID for all commands
      iwlwifi: mvm: disable P2P queue on mac context release
      iwlwifi: mvm: set HCMD_NAME for PHY_DB as well

Sharon Dvir (1):
      iwlwifi: migrate to devm_* API

 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c    |   3 --
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h     |   5 ++
 drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c  |   8 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   | 104 +++++++++++++++=
+++++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h   |  20 +++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c       |  11 ++---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |  26 +++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     | 184 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h |  20 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h      |  52 +++++++++++++++=
+++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |  47 ++++++++++-----=
----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  18 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |   7 +++
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c         |  93 +--------------=
----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  32 +++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |  30 ++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c        |  61 +++++++++++++++=
+++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         |  13 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h         |  11 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |  35 +++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  22 +++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |   2 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c         |   9 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  84 ++++++++++++++-=
-------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |   2 +-
 28 files changed, 655 insertions(+), 252 deletions(-)
--=-95UmMXKWEJ7BNT6hk6Kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJX36a/AAoJEKFHnKIaPMX636YP/iqhkm0hseSsMQ6HXATf9y5m
DagY71uPYzjQI77VHTLWXAxWK1Zp1kt0b0CosK641ZJ5tPYbHWe6Sjt51BT7NxXt
7iapnv48V+c712ys+cKqitNk8x6FR8YDXj2NHO5r64110LUDUrXUTtWghz8W+fZf
XNc2JlMMY/e9tkXOeu8iP9sUisAEoMGh3M0bsSYu7qW/S8y2RbJIZn1X4OFepRt+
BMsHlnBLb+PHWn1+FjU6r0MWBmbfUg1iYX1SXqF1ojT+oRaQ5kJCTYJOUNomheRB
/sD40s6yy1A7ggTgr17A78as+t3F1fj8ruVE+unde9dsLt4sPzxyeP4puHTkziEi
tLtWW6rXclvTuRf61xD+hLJcsasg99DlHWT5t2bd/3ntfLcI8+1C40CsmU2zX2TE
zHnloazqrxG8eABLeyjbn2x9LX9BIpN2L4afei89grFygVZCaNVlpt+TydQSlCxn
ayPiS1vOWZq/kEfOOMejmcdP36Fqg2cLfGMt3mY28LRR3q9HuchBK71d+D13s0Lr
5pDW7Z8GRbGprnp5Fe5aSoY9oW2vyg5iXhQ1e8vBo+h4bCgf6sOs2eoa3QT3P6xt
QGxznPA6MmMT71x5D3srpWR3qADYpnpJs8yhw+0pTQ2usDPLR0xUAozmKhwB/no5
ig5oQGXBfJKfYRUFUU4x
=UqwQ
-----END PGP SIGNATURE-----

--=-95UmMXKWEJ7BNT6hk6Kk--

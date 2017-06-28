Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35570 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750829AbdF1KPY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 06:15:24 -0400
Message-ID: <1498644916.22048.99.camel@coelho.fi> (sfid-20170628_121529_768305_B0DF0AD5)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Jun 2017 13:15:16 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9LsPC4aGoQbDb2ER9h6x"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-06-28
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9LsPC4aGoQbDb2ER9h6x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my second pull-request intended for v4.13.=C2=A0 Again, this pull-
request includes the last two patchsets I sent out.=C2=A0 It contains=C2=A0=
generic
development work, with improvements, bug fixes and cleanup all around.=C2=
=A0
More=C2=A0details in the tag description.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 52f8c9380f2eb051581628782a4917f2c3f9751f=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2017-06-22 16:29:52 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-06-28

for you to fetch changes up to 6d759b02f4121595bf4212662e73c26573dab61a:

  iwlwifi: mvm: support TX on MONITOR iface (2017-06-23 12:27:52 +0300)

----------------------------------------------------------------
More iwlwifi patches for 4.13

* Some changes in suspend/resume handling to support new FWs;
* A bunch of RF-kill related fixes;
* Continued work towards the A000 family;
* Support for a new version of the TX flush FW API;
* Some fixes in monitor interfaces;
* A few fixes in the recovery flows;
* Johannes' documentation fixes and FW API struct cleanups continue;
* Remove some noise from the kernel logs;
* Some other small improvements, fixes and cleanups;

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: set assoc_beacon_arrive_time

Chaya Rachel Ivgi (1):
      iwlwifi: mvm: fix typo in CTDP_CMD_OPERATION_REPORT description

David Spinadel (1):
      iwlwifi: mvm: Enable security on new TX API

Emmanuel Grumbach (6):
      iwlwifi: mvm: avoid unnecessary cache trashing in Tx path
      iwlwifi: mvm: fix the recovery flow while connecting
      iwlwifi: mvm: don't mark TIDs that are not idle wrt BA as inactive
      iwlwifi: add a W/A for a scheduler hardware bug
      iwlwifi: mvm: reset the fw_dump_desc pointer after ASSERT
      iwlwifi: pcie: delete the Tx queue timer earlier upon firmware crash

Gregory Greenman (1):
      iwlwifi: mvm: rs: add logs for the wrong antenna case

Johannes Berg (25):
      iwlwifi: remove resp_pkt NULL checks
      iwlwifi: mvm: remove pointless num_stored condition
      iwlwifi: pcie: fix TVQM queue ID range check
      iwlwifi: mvm: avoid variable shadowing
      iwlwifi: mvm: use scnprintf() instead of snprintf()
      iwlwifi: use bitfield.h for some registers
      iwlwifi: mvm: track and report IBSS manager status to mac80211
      iwlwifi: mvm: make iwl_mvm_update_mcc() easier to follow
      iwlwifi: pcie: pull out common rfkill IRQ handling code
      iwlwifi: pcie: add fake RF-kill to debugfs
      iwlwifi: mvm: don't warn in queue sync on RF-kill
      iwlwifi: pcie: don't report RF-kill enabled while shutting down
      iwlwifi: pcie: remove pointless debugfs parsing for csr file
      iwlwifi: mvm: document status bits
      iwlwifi: pcie: use kstrtou32_from_user()
      iwlwifi: mvm: better link scan notification results length
      iwlwifi: simplify data tracepoint
      iwlwifi: fix TX tracing for non-linear SKBs
      iwlwifi: pcie: fix command completion name debug
      iwlwifi: mvm: docs: fix enum link, provide TX response link
      iwlwifi: mvm: disentangle union in TX status struct
      iwlwifi: mvm: add documentation for enum iwl_debug_cmds
      iwlwifi: document transmit buffer bits better
      iwlwifi: pcie: make iwl_pcie_apm_stop_master() return void
      iwlwifi: pcie: work around suspend/resume issue

Liad Kaufman (5):
      iwlwifi: mvm: remove txq EMPTYING_DELBA state for DQA
      iwlwifi: mvm: disable dbg data collect when fw isn't alive
      iwlwifi: mvm: support aggregations on A000 HW
      iwlwifi: mvm: fix fw monitor 7000 HW recollecting
      iwlwifi: mvm: support TX on MONITOR iface

Luca Coelho (9):
      iwlwifi: mvm: make D0I3_END_CMD sync during system resume
      iwlwifi: mvm: support D0I3_END_CMD at the start of resume
      iwlwifi: remove useless iwl_free_nvm_data() function
      iwlwifi: mvm: fix nvm_data leak
      iwlwifi: pcie: don't disable bh when handling FW errors
      iwlwifi: mvm: reset the HW before dumping if HW error is detected
      iwlwifi: mvm: document assoc_beacon_arrive_time
      iwlwifi: mvm: print base HW address during init
      iwlwifi: pcie: reduce unwanted noise in the logs

Mordechai Goodstein (2):
      iwlwifi: mvm: change the firmware name loading
      iwlwifi: mvm: support new flush API

 drivers/net/wireless/intel/iwlwifi/dvm/main.c             |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c             |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h           |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h              |   4 ++
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h    |  11 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h |  19 ++++---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h     |   9 ---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h               |  28 ++++++---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h          |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c        |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h             |  17 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c            |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h            |  19 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c               |  39 ++++++----=
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c      |  22 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c          |  19 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h        |  89 ++++++++++=
++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h           |  23 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c           |  10 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c         |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         |  63 ++++++++++=
++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              |  30 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c              |  43 +++++++---=
----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              |  39 +++++++++-=
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c               |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c             |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              | 212 ++++++++++=
+++++++++++++++++++++++++++++++++++++----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h              |   8 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c               |  70 ++++++++++=
++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c            |  93 ++++++++++=
++++++++++----------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c             |  12 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h        |  18 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c              | 116 ++++++++++=
++++++++--------------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c      |  28 ++-------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c           | 168 ++++++++++=
++++++++++++++++++++++++++------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c         |  14 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c              |  43 +++++++++-=
----
 39 files changed, 845 insertions(+), 450 deletions(-)
--=-9LsPC4aGoQbDb2ER9h6x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAllTgbQACgkQoUecoho8
xfqJGw/6A45uT0z3Fpu32yu3UTzYLU0Tud9zXO09WuzTscX06vUZRwjfMFD0Yn47
TLJkoErlkguG1fjn0uOEZnG13t6+cmOeepvHEs1Qy48F35XdkJMU0dVL/t912Frb
HI1gpmffp5I2BX1BiTnpvCcaptcXEkNJXlZLAi/iuDijN5ObbaixikPpn49++rdC
TrXxiA0L3XV8UlA5UbfOK/izxtzDwZgBbbJYL1fV6vOMeUIM8UTjsYip2/cjvJma
MBhJrIgKoH9h6TOQNaJr7AcSETharXM4DUxDl5k9noXFXhcmcoxyEzHNJ66Ud0wW
jtdnK2eOHCKH6NK9eOv7RtUPxJFBxKwOViCPFbMYxxomtkdwa/UngcykZNfVt2uf
ie1/Nagbfk/c8J0MRxKJaz/yfUHQk6teL0PgT8QSscjTYkDDhGg3lR7o8J2oBrEr
irpZtWZBJN3rJy3ZOtC+M4NSApxLmvqJ8SSeDXA+xJRI2vTavV6tEfLPCdt1Om71
D4uL3QO7L60XOzMWF9t81EpS1xJK0zdPTjbtnM6HljU4WDrQ+xOj1vlRF3jqAGHp
KaJc7cnLjvUmRlDRtCgOqzR91695ItIrLPFM9W8mi1h8yBwMZtAlXgPEBhX+JJb5
1BNQn5DqqDlr/G+zwtreq9fVvS1J8H/dG9mKxqgbEMozRwe+/6M=
=kABr
-----END PGP SIGNATURE-----

--=-9LsPC4aGoQbDb2ER9h6x--

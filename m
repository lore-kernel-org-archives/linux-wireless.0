Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45506 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727462AbeHaM4n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:56:43 -0400
Message-ID: <ffddd3d6188213b090659d13dc216fe483f6c8ea.camel@coelho.fi> (sfid-20180831_105036_555867_D793CD14)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date: Fri, 31 Aug 2018 11:50:14 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-8mlA6JXOVMdSfzdWy0WL"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-08-31
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8mlA6JXOVMdSfzdWy0WL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is first batch of patches intended for v4.20.  This includes the
last 3 patchsets I sent.  Usual development work, with focus on HE and
bugfixes, and some other small fixes and improvements.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 9cac6a9b629739537d7792898cc0d401ae020205=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2018-08-28 19:39:22 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-08-31

for you to fetch changes up to ab27926d9e4ae23df4f4d98e31f067c8b486bb4f:

  iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules (2018-=
08-31 11:38:42 +0300)

----------------------------------------------------------------
iwlwifi patches for 4.20

* One fix for channel-switch handling;
* Some improvements in the HE code;
* New FW API handling;
* Improvements in the debugging code;
* Some improvements in the PCI recovery mechanism;
* Support for a few FW API changes;
* Enable a new scanning feature;
* Continued work on HE (mostly radiotap);
* Some fixes in the FW rate-scaling implementation;
* Other clean-ups and small fixes and improvements;

----------------------------------------------------------------
Avraham Stern (2):
      iwlwifi: set the tid for non-QOS frames to zero
      iwlwifi: mvm: Send LQ command as async when necessary

Ayala Beker (2):
      iwlwifi: mvm: skip EBS in low latency mode while fragmented scan isn'=
t supported
      iwlwifi: mvm: activate fragmented EBS in case of fragmented scan

Emmanuel Grumbach (2):
      iwlwifi: improve the flow when a NIC is disconnected
      iwlwifi: mvm: send BCAST management frames to the right station

Erel Geron (1):
      iwlwifi: mvm: support Coex Schema 2

Golan Ben Ami (7):
      iwlwifi: add required include to iwl-fh.h
      iwlwifi: pcie: allow using tx init for other queues but the command q=
ueue
      iwlwifi: pcie: make non-static hcmd and rx code
      iwlwifi: remove FSF's address from the license notice
      iwlwifi: pcie: store the default rxq number
      iwlwifi: pcie: make gen2 of apm_init non-static
      iwlwifi: refactor txq_alloc for supporting more command type

Gregory Greenman (1):
      iwlwifi: mvm: add NOA and CSA to a probe response

Haim Dreyfuss (1):
      iwlwifi: mvm: support new reduce tx power FW API.

Ido Yariv (1):
      iwlwifi: Add missing 11n disable module parameter check

Johannes Berg (9):
      iwlwifi: remove dump_regs() from transport ops
      iwlwifi: don't WARN on trying to dump dead firmware
      iwlwifi: mvm: implement extended HE-MU sniffer API
      iwlwifi: mvm: put LTF symbol size into HE radiotap
      iwlwifi: mvm: properly decode HE GI duration
      iwlwifi: mvm: report # of LTF symbols for extended range SU PPDUs
      iwlwifi: mvm: remove channel 2 from HE radiotap if not applicable
      iwlwifi: mvm: decode HE TB PPDU data
      Revert "iwlwifi: allow memory debug TLV to specify the memory type"

Liad Kaufman (2):
      iwlwifi: mvm: add bss color to radiotap
      iwlwifi: mvm: add support for RX_AMPDU_EOF bit for HE SU

Luca Coelho (6):
      iwlwifi: remove unused TLC debugging commands
      iwlwifi: mvm: remove duplicate if in iwl_mvm_setup_connection_keep()
      iwlwifi: mvm: protect D0i3 code behind CONFIG_PM
      iwlwifi: mvm: support new WoWLAN status FW API
      iwlwifi: remove all occurrences of the FSF address paragraph
      iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules

Matt Chen (1):
      iwlwifi: pcie: avoid unnecessary work if NIC is disconnected

Mordechay Goodstein (3):
      iwlwifi: turn timestamp marker cmd off by default
      iwlwifi: enable reading the value of delay in timestamp_marker cmd
      iwlwifi: add 80211 hdr offset to trace data

Naftali Goldstein (4):
      iwlwifi: runtime: avoid calling debugfs read functions more than once
      iwlwifi: mvm: always init rs_fw with 20MHz bandwidth rates
      iwlwifi: rs-fw: enable STBC in he correctly
      iwlwifi: rs-fw: support dcm

Sara Sharon (6):
      iwlwifi: mvm: move he RX handling to a separate function
      iwlwifi: mvm: move he RX handling to a separate function
      iwlwifi: drop packets with bad status in CD
      iwlwifi: mvm: fix BAR seq ctrl reporting
      iwlwifi: mvm: avoid sending too many BARs
      iwlwifi: pcie: set interrupt coalescing also for gen2

Shahar S Matityahu (3):
      iwlwifi: add d3 debug data support
      iwlwifi: change monitor DMA to be coherent
      iwlwifi: avoid code duplication in stopping fw debug data recording

 drivers/net/wireless/intel/iwlwifi/cfg/1000.c             |   4 -
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c             |   4 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c            |  69 ++++++++-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c             |   4 -
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c             |   4 -
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c             |   5 -
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c             |   5 -
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c             |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h              |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c            |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/calib.h            |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h         |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c          |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h              |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c          |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.c              |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.h              |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c              |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c         |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c             |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/power.c            |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/power.h            |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c               |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h               |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c               |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c             |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c             |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c              |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c               |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.h               |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c               |   5 -
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c            |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c              |   3 -
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h              |   3 -
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h          |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h      |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h            |  89 ++++++++++=
+-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h       |  49 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h         |  30 +++-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h            |  78 ++--------
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h            | 199 ++++++++++=
+++++++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h          |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h            |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c               | 120 ++++++++--=
------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h               |  23 +--
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c           | 124 ++++++++++=
++----
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h           |   3 -
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h        |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h              |  30 ++--
 drivers/net/wireless/intel/iwlwifi/fw/img.h               |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c        |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h        |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h           |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h           |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h           |  18 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h              |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c            |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h            |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h    |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h      |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h     |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h   |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c         |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h         |  22 +--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c              |  24 +---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h              |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c     |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h     |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c      |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h      |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h               |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c               |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-io.h               |   4 -
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h        |   3 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c        |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h        |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h          |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c           |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h           |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h             |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h              |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c            |   5 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h            |  24 +---
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c          |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c             |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h        |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c               | 162 ++++++++++=
+++++------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c      |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c          |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h          |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h           |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c               |  28 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/led.c              |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c         |  66 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         |  49 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              |  34 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c              |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/offloading.c       |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              |  49 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c            |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c            |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c            |  35 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c               |  20 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h               |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c               |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c             | 711 ++++++++++=
++++++++++++++++++++++++++++++++++++++++++++-------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c             |  26 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c               |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c             |   3 -
 drivers/net/wireless/intel/iwlwifi/mvm/testmode.h         |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h       |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c              |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h              |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c               |   5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c               | 115 ++++++++++=
++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c            |  26 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c             |  60 ++++----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h        |  94 ++++------=
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c              |  20 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c      |   9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c           |  88 ++++------=
--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c         | 124 ++++++++++=
------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c              |  16 ++-
 125 files changed, 1726 insertions(+), 1343 deletions(-)

--=-8mlA6JXOVMdSfzdWy0WL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAluJAUYACgkQoUecoho8
xfpFdA//ZKMkMT1payUHSapKcFJRRMnbPrzmDINX0yJznaOPkUBHZ4FH8xkEG1rx
NjNWAwc3Q0NsyEATHxH9qxX7u+RPCzhqCg/hnX5u472Ibfz3/E8jhYvJaK9CfO2r
2fmLQpwYANIc0EqIYkWQ3mWE4xe9R8mKWK+57Ytxm0UKfeIyt6P5wW0uMhgzXOJc
N6M9gexCcVBxWth7VCpFk6Tr/+/uFgWfV9wIpa/hUuhvSCSndcgPV2Yeq7nX0DZ6
YaVwGzOz0wB3Bjh+zjBrhnmIoTtotY39Q+gNbfeFwWC/adDLiNOzvE4MjP5LcQE7
zSuLjW1Q9P3Yj/UVMmpJYlyS1PGDIdNIVujUpdYFA5eytCX/H4dGcsUX9vO3QC8F
OyOThTPsBR4S4x3y1ddvHn3XTi3dzamwA91xnqvWREhbkGkzwfmP/URc3QqkYR+Y
rxn9vug+KqhwOfqDYfTl3r6v49cG7oFZH84C/pY+1tyA1epM2B1GUdGgKemr7WvH
TCrJhMELOGUtr5bx8n6XNRG/h22dPo7BRMqaMrgJODy0Qvfo7ZBl3umM7huzCgGj
q51usgjWmL2Yok3aANdO9ue4O/rTiOBTU/fUcd9+v115vOs63fH9T7/uyWo8qk5J
bWm3dBh5LyPXycpn1IN74q7hfGKE0xp+al8yj5ci8p4YzuJYB34=
=AxT7
-----END PGP SIGNATURE-----

--=-8mlA6JXOVMdSfzdWy0WL--

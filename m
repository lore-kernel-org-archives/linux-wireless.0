Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60380 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3LaROV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:14:21 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so5616151eae.41
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:14:20 -0800 (PST)
Message-ID: <52C2FB68.2010708@gmail.com> (sfid-20131231_181444_155408_30AC17FB)
Date: Tue, 31 Dec 2013 19:14:16 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2013_12_31
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BUr092qtLENchxLohV0jUFBGQQSAX7vg7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BUr092qtLENchxLohV0jUFBGQQSAX7vg7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is probably the last pull request for 3.14.

I have here a rework of the interrupt handling to meet RT kernel
requirements - basically we don't take any lock in the primary interrupt
handler. This gave me a good reason to clean things up a bit on the way.
There is also a fix of the QoS mapping along with a few workarounds for
hardware / firmware issues that are hard to hit.
Three fixes suggested by static analyzers, and other various stuff.
Most importantly, I update the Copyright note to include the new year.

I know it is quite late in the cycle (and probably not the best period
to expect responsiveness:)) but I want to hope that this it will still
make it to 3.14.

The following changes since commit cf4ef65446443eb485afe9419ea82b2efbe582=
a7:

  iwlwifi: mvm: rs: fix variable shadowing (2013-12-17 22:32:57 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to 14648d6534477952633ee3ecadb31cf227414f13:

  iwlwifi: mvm: fix coccinelle warnings (2013-12-31 19:03:53 +0200)

----------------------------------------------------------------
Arik Nemtsov (1):
      iwlwifi: mvm: squash a spurious warning on chnctx change

Emmanuel Grumbach (20):
      iwlwifi: pcie: clean up ICT allocation code
      iwlwifi: pcie: track interrupt mask in SW
      iwlwifi: pcie: re-organize the PCIe ISR code
      iwlwifi: pcie: move the ICT / non-ICT handling functions
      iwlwifi: pcie: read the interrupt cause from the handler
      iwlwifi: pcie: determine the interrupt type in the handler
      iwlwifi: pcie: return inta from iwl_pcie_int_cause_{non_}ict
      iwlwifi: pcie: no need to save inta in trans_pcie
      iwlwifi: pcie: move interrupt prints to the common handler
      iwlwifi: pcie: use don't disable interrupt when irq_lock is taken
      iwlwifi: pcie: use don't disable interrupt when rxq->lock is taken
      iwlwifi: mvm: fix AC / FIFO mapping
      iwlwifi: pcie: keep the NIC awake when commands are in flight
      iwlwifi: pcie: don't update the op_mode if rfkill hasn't changed
      iwlwifi: pcie: allow the op_mode to call stop_device whenever it wa=
nts
      iwlwifi: mvm: disable the device as soon as RFKILL fires
      iwlwifi: mvm: fix harmless smatch / coccinelle warnings
      iwlwifi: mvm: BT Coex - update channel inihibition for channel 14
      iwlwifi: mvm: dump to debugfs the SRAM as binary
      iwlwifi: Update Copyright to 2014

Eran Harary (1):
      iwlwifi: pcie: Fix CSR_RESET operation access type

Eyal Shapira (1):
      iwlwifi: mvm: rs: fix a potential NULL deref

Eytan Lifshitz (1):
      iwlwifi: mvm: fix possible memory leak

Fengguang Wu (1):
      iwlwifi: mvm: fix coccinelle warnings

Ilan Peer (3):
      iwlwifi: mvm: Add a missed beacons threshold
      iwlwifi: mvm: change the parameters for calculating an AP TBTT
      iwlwifi: mvm: dynamically update tsf_id

 drivers/net/wireless/iwlwifi/dvm/agn.h            |    4 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c          |    4 +-
 drivers/net/wireless/iwlwifi/dvm/calib.h          |    4 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h       |    4 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/led.c            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/led.h            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c       |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/power.c          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/power.h          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tt.h             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-config.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    7 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-io.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   11 +-
 drivers/net/wireless/iwlwifi/mvm/binding.c        |    4 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        |    8 +-
 drivers/net/wireless/iwlwifi/mvm/constants.h      |    4 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c             |    4 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c    |    4 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c        |   53 ++-
 drivers/net/wireless/iwlwifi/mvm/debugfs.h        |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h      |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h     |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h   |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h      |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h    |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h     |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h      |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c             |    4 +-
 drivers/net/wireless/iwlwifi/mvm/led.c            |    6 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c       |  160 ++++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |   24 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |    7 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c            |   15 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c            |    6 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c       |    4 +-
 drivers/net/wireless/iwlwifi/mvm/power.c          |    4 +-
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c   |    4 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c          |    4 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c             |   13 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h             |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c             |    4 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c           |   13 +-
 drivers/net/wireless/iwlwifi/mvm/sf.c             |    4 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c            |    4 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h            |    4 +-
 drivers/net/wireless/iwlwifi/mvm/testmode.h       |    4 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c     |    4 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h     |    4 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c             |    4 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c             |    4 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c          |    4 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c           |    4 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h      |   40 ++-
 drivers/net/wireless/iwlwifi/pcie/rx.c            |  400
+++++++++------------
 drivers/net/wireless/iwlwifi/pcie/trans.c         |   79 ++--
 drivers/net/wireless/iwlwifi/pcie/tx.c            |  106 ++++--
 101 files changed, 653 insertions(+), 577 deletions(-)


--BUr092qtLENchxLohV0jUFBGQQSAX7vg7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSwvtoAAoJEC0Llv5uNjIBKqgQAIedM/gXjVhJvq6XgQb9rsyq
aHm26XloijISOUh7EgtcNukAoQyHBpTPmvVGR5jB5vDSvTN2PvhJLboHGEWSvOIW
u159p7KNpTT07cA3AaI1QAqne2OzHdS2tASNzIVHp0TUORkANv68nSTgr2Sndr9j
ZcAa9mv+lUPm8+CieM5g51qcgnOMDcjINuERjpMzXgoyhjaR6WSsYutdTWmKZNSO
CulYZBXDimB/TVc9q6O+uHW1HtwF8OPR4UD9Hrn3qhCKP/MFkeyzoUXUngmdKm7h
UP5OdF7EPYjZtJhPGvDTbNe/7ku7q0t9bGXeqFjG2+5QQ85w5kfNUV7Ty9Cxm3RZ
kbDbukxoVAzOphaJseXzSDHAzoIKtTW87Hz6Kndid1LwF3of2RRVT/ayWMapWZ6D
30YtYVg+1dE8fFUHDLv2XlFZLOHkokma2ZWQmO73NGYCmM2NfPwKRth/c24eVj1F
izdCueDbNSIWkQ1U9ZhRhZ1wL6fNuGAQtE36phPhD/DMwWYjXKByGdro4wfxi2p/
yuNlvODOj49tF+Sn2UDYjq9bCJG6YTrUrTUEsfhJ3MQPj55ilUcNm+jFHlDB3/b+
aiwZQc3EgTMecxv1hXTszpGawczQwgE4qQzxPS8SRHRKMb8rCtkS0P4izR2n6s4p
uGdNrwjXL6Kj8WR9xaan
=1vsH
-----END PGP SIGNATURE-----

--BUr092qtLENchxLohV0jUFBGQQSAX7vg7--

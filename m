Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42958 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3LQUmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:42:31 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so3121695ead.22
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:42:30 -0800 (PST)
Message-ID: <52B0B72A.5070704@gmail.com> (sfid-20131217_214236_374548_29630C4E)
Date: Tue, 17 Dec 2013 22:42:18 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi-next 2013-12-17
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eVRX1RqOc1LNbIjkcjP0AgQVEAW8fDsSu"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eVRX1RqOc1LNbIjkcjP0AgQVEAW8fDsSu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

here is another batch for 3.14.

I have hear quite a few things. Alex continues his work on power
management. Arik is reworking the transport API by unifying redudant
APIs and making error handling more generic. Eyal keeps on digging in
the rate scaling code.
We also have two new features - Max is using the brand new generic
cipher infrastructure in mac80211, and Lilach implements the smart fifo
which allows to save power by making interrupt coalescing smarter.

Let me know about issues you might have (hopefully none)!

The following changes since commit 9d10849e4ea8bf9d8da80afa73918a9fe45c09=
ef:

  iwlwifi: mvm: rs: fix compilation without CONFIG_MAC80211_DEBUGFS
(2013-12-09 22:29:49 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to cf4ef65446443eb485afe9419ea82b2efbe582a7:

  iwlwifi: mvm: rs: fix variable shadowing (2013-12-17 22:32:57 +0200)

----------------------------------------------------------------
Alexander Bondar (6):
      iwlwifi: mvm: Add uAPSD misbehaving AP notification handling
      iwlwifi: mvm: Change power management dependency on multi MAC
      iwlwifi: mvm: Disable power save for monitor interface
      iwlwifi: mvm: Enable power save on a single P2P client interface
      iwlwifi: mvm: add per-vif power debugfs hooks
      iwlwifi: mvm: Add and examine TLV flag for P2P client uAPSD support=


Arik Nemtsov (6):
      iwlwifi: trans: divide stop_hw into stop_device/op_mode_leave
      iwlwifi: trans: use a unified transport status
      iwlwifi: trans: prevent tx and cmds during FW error
      iwlwifi: trans: prevent reprobe on repeated FW errors before restar=
t
      iwlwifi: trans: clear FW_ERROR status in common code
      iwlwifi: trans: turn set_pmi into an optional callback

Eliad Peller (3):
      iwlwifi: mvm: add multicast filtering support
      iwlwifi: mvm: configure phy_ctxt with min_def
      iwlwifi: mvm: check iwl_nvm_init return value

Emmanuel Grumbach (4):
      iwlwifi: mvm: don't send SMPS action frame with single RX antenna
      iwlwifi: mvm: move iwl_mvm_set_tx_power to PHY area
      iwlwifi: remove pointer to transport from op_mode
      iwlwifi: mvm: fixup Makefile

Eyal Shapira (12):
      iwlwifi: publish STBC support in HT
      iwlwifi: set VHT beamformee STS cap correctly
      iwlwifi: publish Tx STBC support in VHT
      iwlwifi: mvm: rs: move rs_program_fix_rate to cleanup ifdefs
      iwlwifi: mvm: rs: refactor building the LQ command
      iwlwifi: mvm: rs: avoid recalc of supported legacy rate mask
      iwlwifi: mvm: rs: improve rates table algo
      iwlwifi: mvm: rs: remove unnecessary debug logs
      iwlwifi: mvm: rs: refactor rate scale action decision
      iwlwifi: mvm: rs: disable MCS9 Tx workaround
      iwlwifi: mvm: set highest rate in VHT MCS Set
      iwlwifi: mvm: rs: fix RTS protection being set indefinitely

Ilan Peer (1):
      iwlwifi: mvm: Do not allow AP MAC context update if not active

Johannes Berg (2):
      iwlwifi: mvm: clarify smps_requests documentation
      iwlwifi: mvm: rs: fix variable shadowing

Lilach Edelstein (1):
      iwlwifi: mvm: Add Smart FIFO support

Max Stepanov (1):
      iwlwifi: mvm: add a generic cipher scheme support

 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |    6 -
 drivers/net/wireless/iwlwifi/dvm/main.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-config.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-drv.c          |   39 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |    7 +
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   46 ++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |   15 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   66 ++-
 drivers/net/wireless/iwlwifi/mvm/Makefile       |    3 +-
 drivers/net/wireless/iwlwifi/mvm/binding.c      |   16 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c  |  353 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |   16 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h   |   10 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h    |    1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |   65 +++
 drivers/net/wireless/iwlwifi/mvm/fw.c           |   28 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |  252 ++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |   45 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c          |   20 +-
 drivers/net/wireless/iwlwifi/mvm/power.c        |  395 ++++++++-----
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  686
++++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/rs.h           |    2 -
 drivers/net/wireless/iwlwifi/mvm/rx.c           |    6 +
 drivers/net/wireless/iwlwifi/mvm/sf.c           |  291 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.c          |   21 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c           |    2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c           |    3 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c        |    5 +
 drivers/net/wireless/iwlwifi/pcie/internal.h    |   33 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c          |   35 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c       |   86 ++-
 drivers/net/wireless/iwlwifi/pcie/tx.c          |   37 +-
 35 files changed, 1837 insertions(+), 766 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/sf.c


--eVRX1RqOc1LNbIjkcjP0AgQVEAW8fDsSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSsLczAAoJEC0Llv5uNjIBzT0P/jPHxxBP8fQUgmAdarqE9Iri
bz6CjRPrCoXWfW1PnpWK7UGrxxhs0OaNTRplIj/Iu38SIV+vppNzE7TmlUfNlKEh
hXu9BDgCF/aQFP74Pl7u9ODxlagdRbuO6GwhcLnO492+W/Z/V4v9P1EoOf88RrKK
gHyLoMWiLSrEEDY5MwuctmQXRIqY3Z03EmSgOsn1sK9saFMyO4GsBp+p67SooaHZ
xQPtJA3hVOoLrKdYyU3mKGx34hIhYoaW4rshe3qany0LKJUmJYUG/VMFdhtU3O/+
lr884toskpcaSJaawdh3RDpp/Snq5iHgY38JRNWkanRNswQKPL76LBdQQhRvYyMt
IQW0Ucy5flW5BQLM+pMKBxSdR3YX/vsFvhWMXrz5cLjLbgioGxYlN1VJdY3OqEsv
ODLNtD/0nNgvGludBcUNIYtdEZhsUg0G9+AtMwpvNian546u6zoJ7taa80QCRPMF
470FaEPR+3gvIinDyzBxu6GGIMwNTL84HCu5ZptGutO3gg0Y4y46RHu2pcaXnys6
dTW5HT5IdH/+z21NadCqj0/+Fv5DYkFVpIvVLQk88EZCxM9fIYhzEUn6Cn1VqjYk
Tn2QzRdLg6GeB8fNDpUWT5XZ7athmfEtUWQB87ZjWQRcKDkxUqi4uQOwSSqwJ5uk
6DEMvQUCe9hHrceh9et0
=NlPt
-----END PGP SIGNATURE-----

--eVRX1RqOc1LNbIjkcjP0AgQVEAW8fDsSu--

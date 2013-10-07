Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3JGJ4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 05:56:37 -0400
Message-ID: <1381139793.13586.18.camel@jlt4.sipsolutions.net> (sfid-20131007_115641_213838_DC2EAF34)
Subject: pull-request: iwlwifi-next 2013-10-07
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 07 Oct 2013 11:56:33 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-IdLtFfppyncXONudRhqU"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IdLtFfppyncXONudRhqU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Also the first pull request for iwlwifi-next, also quite late, sorry.

We have a collection of things all over, with two bigger things standing
out: a rather big Bluetooth coexistence update and VHT support in rate
scaling.

Let me know if there's any problem.

johannes


The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f=
:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 07ad72f761482a0b59a946efe0c6290e0858057f:

  iwlwifi: mvm: add support for NICs which have only 16 Tx queues. (2013-10=
-02 18:00:49 +0200)

----------------------------------------------------------------
Alexander Bondar (2):
      iwlwifi: mvm: Adjust some power management constants
      iwlwifi: mvm: Add device wide power command

Andrei Otcheretianski (1):
      iwlwifi: mvm: Implement BT coex notifications

David Spinadel (3):
      iwlwifi: mvm: implement NoA testing using testmode cmd
      iwlwifi: mvm: add no_basic_ssid option
      iwlwifi: mvm: support sched scan if supported by the fw

Djalal Harouni (1):
      iwlwifi: mvm: make debugfs write() operations write up to count bytes

Emmanuel Grumbach (13):
      iwlwifi: mvm: use CTS to Self if firmware allows it
      iwlwifi: pcie: clean RFKILL interrupt in AMPG
      iwlwifi: mvm: don't sleep while allocating in atomic context
      iwlwifi: mvm: new BT Coex API
      iwlwifi: mvm: BT Coex - no need to send envelopes
      iwlwifi: mvm: BT Coex - use data from firmware
      iwlwifi: mvm: don't use reduced Tx power when not applicable
      iwlwifi: mvm: BT Coex - adapt debugfs to new API
      iwlwifi: mvm: BT Coex - Correctly enable and treat rssi events
      iwlwifi: pcie: dump_stack upon timeout of SYNC cmd
      iwlwifi: mvm: BT Coex - don't limit agg size in loose scheme
      iwlwifi: mvm: BT Coex - set the proper LUT for single ant devices
      iwlwifi: pcie: restart the driver when a command times out

Eyal Shapira (5):
      iwlwifi: mvm: remove rs FSM actions relevant only for 3 antennas
      iwlwifi: mvm: fix switch from shared antenna in case of BT load
      iwlwifi: mvm: update expected tpt tables for VHT
      iwlwifi: mvm: support VHT in rs
      iwlwifi: mvm: remove GF support in rs

Eytan Lifshitz (3):
      iwlwifi: mvm: change the name of init_ucode_run flag
      iwlwifi: mvm: prevent the NIC to be powered at driver load time.
      iwlwifi: mvm: add support for NICs which have only 16 Tx queues.

Jingoo Han (1):
      wireless: iwlwifi: remove unnecessary pci_set_drvdata()

Johannes Berg (5):
      iwlwifi: mvm: implement beacon filtering testmode command
      iwlwifi: mvm: query firmware for non-QoS seqno
      iwlwifi: mvm: give client MACs time to synchronise during restart
      iwlwifi: mvm: fix locking in iwl_mvm_bt_rssi_event()
      iwlwifi: mvm: implement new IPv6 offload API

Max Stepanov (1):
      iwlwifi: mvm: split ADD_STA and ADD_STA_KEY in firmware API

Oren Givon (1):
      iwlwifi: mvm: debugfs: add an option to set antennas for scan command

 drivers/net/wireless/iwlwifi/iwl-fw.h             |  18 +
 drivers/net/wireless/iwlwifi/iwl-prph.h           |   2 +
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        | 598 ++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/constants.h      |   4 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c             | 138 +++-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c        | 197 ++++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h | 145 +++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h      |  44 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h   |  29 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h      |  21 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h    |  34 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h     |  55 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |  16 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c             |  23 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c       |  18 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       | 177 ++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |  67 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c            |  99 ++-
 drivers/net/wireless/iwlwifi/mvm/ops.c            |  60 +-
 drivers/net/wireless/iwlwifi/mvm/power.c          |  70 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c          |  34 +
 drivers/net/wireless/iwlwifi/mvm/rs.c             | 758 ++++++++++++------=
----
 drivers/net/wireless/iwlwifi/mvm/rs.h             | 154 +++--
 drivers/net/wireless/iwlwifi/mvm/rx.c             |  21 +
 drivers/net/wireless/iwlwifi/mvm/scan.c           | 456 ++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/sta.c            | 192 ++++--
 drivers/net/wireless/iwlwifi/mvm/sta.h            |   4 -
 drivers/net/wireless/iwlwifi/mvm/testmode.h       |  95 +++
 drivers/net/wireless/iwlwifi/mvm/time-event.c     |   5 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h     |   4 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c             |  49 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c          |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c           |   3 -
 drivers/net/wireless/iwlwifi/pcie/trans.c         |   3 +
 drivers/net/wireless/iwlwifi/pcie/tx.c            |   3 +
 35 files changed, 2716 insertions(+), 882 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/testmode.h


--=-IdLtFfppyncXONudRhqU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSUoVRAAoJEDBSmw7B7bqrrckP+wY10Up7Vxhz9oiBHuqXTzIn
ficLQgeDaYB9mwY8fSC7iMlxhABiwEpwKSC3JAo/LUruk5c39q+o6OXiA/z+YM6p
kNRXqNeXiu0ytuoOQnKm8kWGnH9afdak+5iZ288Q16WUoAY4vUjq1iVZXdiW6wdL
CdA14G2dJ3QS6Cr46w7SpfBgnTer1tbjnWDWN/ZQjVukwKUI7B/myKy0d7sXoSSa
cgAcV+IuhX3sspJX3XzMRZG0urEmxiBoY85zmzUShbaLB6vMCgr1mkwrlo000s4T
YQ2266xJKgMr9XbC7CqJu1LTYCPve4caIwh1W6+XtbFnyvLhJOKdyj02wjiB95mC
sECcORrDAPo56SnMYQCIuawDeLJE03UAOlO4NPv14n/JDyroz0nMSpgnFvgOm7jo
uHpVkgdQr+97csPobBIWWKWN0qW1how7sBJIHysaFT/OIfcHC3HG10MXwRmEiB8o
w9yExNY3Vw/QR49yTBQrWYX8BFmZ+jb6eHag3w+vQD7J+HRHalWze1/VP2LkKZO9
/yPJ+sO/XPnxNONaA1K1doaNLVhqy5BCbrKup4ob2Zpgg/iLZjLwNkA29K1Z8QaQ
kDEj0azwi0F7zLhaBrGo6u60qn8gM3P8pfMSJo08ZDB6lHa6w9L8aldrA7xd003w
7RT4oVyPKtZh/prBrux3
=xlSl
-----END PGP SIGNATURE-----

--=-IdLtFfppyncXONudRhqU--


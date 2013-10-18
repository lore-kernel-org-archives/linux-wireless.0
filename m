Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3JROVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 10:21:34 -0400
Message-ID: <1382106086.14393.10.camel@jlt4.sipsolutions.net> (sfid-20131018_162146_538570_A732D882)
Subject: pull-request: iwlwifi-next 2013-10-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 Oct 2013 16:21:26 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0ai1fTjzaLcpm7I3w3mH"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0ai1fTjzaLcpm7I3w3mH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And for iwlwifi-next ... This is bigger. I guess -next stuff can wait
until after KS though. Also, I think there might be a merge conflict
hidden here, don't really remember.

For this round, I have a lot of changes:
 * power management improvements
 * BT coexistence improvements/updates
 * new device support
 * VHT support
 * IBSS support (though due to a small bug it requires new firmware)
 * various other fixes/improvements.

Sorry to concentrate it all into one pull request, I was holding for a
small bugfix that turned out to be much more difficult than I expected,
but also not needed yet (so this code has a known bug with -8 firmware,
but we'll fix it before the driver gets updated to use that firmware.)

Let me know if there's any problem.

johannes


The following changes since commit e25aa82a89db9e3b09d02b5481aa375c7712a10d=
:

  rt2x00: rt2800lib: fix VGC adjustment for RT3572 and RT3593 (2013-10-10 1=
3:53:07 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 246dd9922e859768aa522daa6c1c601785e57e0c:

  iwlwifi: mvm: fix operator precedence (2013-10-18 16:02:38 +0200)

----------------------------------------------------------------
Alexander Bondar (2):
      iwlwifi: mvm: Adjust some power management constants
      iwlwifi: mvm: Add device wide power command

Andrei Otcheretianski (1):
      iwlwifi: mvm: Implement BT coex notifications

David Spinadel (4):
      iwlwifi: mvm: implement NoA testing using testmode cmd
      iwlwifi: mvm: add no_basic_ssid option
      iwlwifi: mvm: support sched scan if supported by the fw
      iwlwifi: mvm: fix operator precedence

Djalal Harouni (1):
      iwlwifi: mvm: make debugfs write() operations write up to count bytes

Emmanuel Grumbach (20):
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
      iwlwifi: mvm: BT Coex - track bandwidth changes in HT
      iwlwifi: mvm: BT Coex - tune SMPS parameters
      iwlwifi: mvm: BT Coex - start AMPDU even when BT is active
      iwlwifi: mvm: BT Coex - remove duplicate code in rate control
      iwlwifi: mvm: BT Coex - update integration with rate control
      iwlwifi: mvm: BT Coex - always set mandatory fields
      iwlwifi: mvm: BT Coex - enable Tx power based on BT status

Eran Harary (2):
      iwlwifi: Support 7265 devices
      iwlwifi: support Signed firmware image and Dual CPUs

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

Idan Kahlon (1):
      iwlwifi: mvm: NVM - increase max section size

Jingoo Han (1):
      wireless: iwlwifi: remove unnecessary pci_set_drvdata()

Johannes Berg (8):
      iwlwifi: mvm: implement beacon filtering testmode command
      iwlwifi: mvm: query firmware for non-QoS seqno
      iwlwifi: mvm: give client MACs time to synchronise during restart
      iwlwifi: mvm: fix locking in iwl_mvm_bt_rssi_event()
      iwlwifi: mvm: implement new IPv6 offload API
      Merge remote-tracking branch 'wireless-next/master' into HEAD
      iwlwifi: mvm: keep connection to AP after WoWLAN
      iwlwifi: mvm: add IBSS support

Luciano Coelho (1):
      iwlwifi: mvm: fix fw_rx_stats debugfs entry

Max Stepanov (1):
      iwlwifi: mvm: split ADD_STA and ADD_STA_KEY in firmware API

Oren Givon (1):
      iwlwifi: mvm: debugfs: add an option to set antennas for scan command

 drivers/net/wireless/iwlwifi/iwl-7000.c           |  14 +
 drivers/net/wireless/iwlwifi/iwl-config.h         |   1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h            |  32 +
 drivers/net/wireless/iwlwifi/iwl-drv.c            |  37 +
 drivers/net/wireless/iwlwifi/iwl-fw-file.h        |   4 +
 drivers/net/wireless/iwlwifi/iwl-fw.h             |  26 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |   2 +
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        | 632 ++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/constants.h      |   4 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c             | 515 ++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c        | 206 ++++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h | 149 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h      |  69 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h     |  11 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h   |  29 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h      |  21 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h    |  34 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h     |  55 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |  16 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c             |  23 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c       |  75 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       | 242 ++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |  88 ++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c            | 101 ++-
 drivers/net/wireless/iwlwifi/mvm/ops.c            |  60 +-
 drivers/net/wireless/iwlwifi/mvm/power.c          |  70 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c          |  42 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c             | 793 +++++++++++-------=
----
 drivers/net/wireless/iwlwifi/mvm/rs.h             | 154 +++--
 drivers/net/wireless/iwlwifi/mvm/rx.c             |  21 +
 drivers/net/wireless/iwlwifi/mvm/scan.c           | 456 ++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/sta.c            | 206 ++++--
 drivers/net/wireless/iwlwifi/mvm/sta.h            |   4 -
 drivers/net/wireless/iwlwifi/mvm/testmode.h       |  95 +++
 drivers/net/wireless/iwlwifi/mvm/time-event.c     |   5 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h     |   4 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c             |  49 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c          |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c           |   8 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c         | 127 +++-
 drivers/net/wireless/iwlwifi/pcie/tx.c            |   3 +
 41 files changed, 3484 insertions(+), 1001 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/testmode.h


--=-0ai1fTjzaLcpm7I3w3mH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSYUPmAAoJEDBSmw7B7bqrJw4P/0MwztxWaIlUknxOVBYP2X+Q
JiRww914EKySR7iHxcvNlz8Ei7IENa9Zl7YHyuWqMAT01bsKRsM3nPpFMeLtkPzJ
btNs3r0PGs3/Xo0/nQp6j52HuG1XV74BXGQVsHgeedpUQZam9NIHsJC46XHZqZFs
jcrcs2MMl36o8LOOSneOVf5nzAqMDpGo9LciH0I9BoGWKGp+Haxgf/AEB0tCrTSg
Bwd8PM5DfU9O+qOQssxCCkFy3PfKawA49wde1QE4wggQ70e9qck0RvSR+QTXMzz2
wW0UG/EDWObk7eBQbva9HnuzyVNPnmym+pFFZ/rafaEWBgYbjluxNm6wppGmoIW0
xXbupoZ5Bxl+SChde4hraLJEttaN8F/3g8Yon9UROsZJL1m1LWPZ4zv2Pz7GNyTb
UHYQyWMErnooO9ui/5rb/+qaah7Ng8TTcB3j6f/poWGP23qwOHov/5yrB45hVV1u
Q1k6SsgBuG5VbwTRi+CtlpfdxQAAWjNHlepUL0dKCPg4K/ECSlwpVO6m9BX/FwjM
SdtBODRQnrc2DjC2cPixSkF9lBDRfb+2cQikYP/DsuoqG+aOwXbUw+gOBZbPB5zl
7RiwOTBk4U0GzJq6oGxkn5KBcd+IyMXBGzRx2WUEELaweKX5mlsHBLVYn+3NVDmg
Cxpj8dENmTXqADXS0dLT
=2g4k
-----END PGP SIGNATURE-----

--=-0ai1fTjzaLcpm7I3w3mH--


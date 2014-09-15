Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65281 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaIOFIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:08:52 -0400
Received: by mail-wg0-f52.google.com with SMTP id x13so3283488wgg.35
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:08:50 -0700 (PDT)
Message-ID: <5416742C.3070804@gmail.com> (sfid-20140915_070900_504237_68FDFC11)
Date: Mon, 15 Sep 2014 08:07:56 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: john Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2014-09-15
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="JctDeaarP1lBl1bO6r6GQ3ONEImcmtnFu"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JctDeaarP1lBl1bO6r6GQ3ONEImcmtnFu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request for 3.18. I have a few more patches for 3.18 that =
are not included here.
This pull request was big enough without them, and they rely on mac80211 =
patches that are not
in wireless-next yet. In my master branch, I merged Johannes's tag on mac=
80211-next to be able
to apply these patches, I'll send you another pull request once you'll pu=
ll from Johannes. Let
me know if you prefer me to merge wireless-next rather than mac80211-next=
=2E I just found it easier
for me.
I also merged iwlwifi-fixes to avoid minor conflicts.

I fix here dvm which was broken by my last pull request. Arik continues t=
o work on TDLS
and Luca solved a few issues in CT-Kill. Eyal keeps digging into rate sca=
ling code, more
to come soon. Besides this, nothing really special here.

Please pull, thanks!

The following changes since commit 712b24adc105518f7cbbb6f9f353efea48954b=
b9:

  iwlwifi: mvm: clean up AUX station handling (2014-09-03 22:49:13 +0300)=


are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to f991e17ba2584e2be66476cc468f19769efd55cc:

  iwlwifi: mvm: align CSA GO NOA time event naming with the firmware (201=
4-09-14 22:02:24 +0300)

----------------------------------------------------------------
Arik Nemtsov (2):
      iwlwifi: mvm: move TDLS code to separate file
      iwlwifi: mvm: fix PSM disable during TDLS

Avri Altman (2):
      iwlwifi: mvm: remove unused static inline function
      iwlwifi: mvm: Fix skip over dtim configuration in d0i3

David Spinadel (1):
      iwlwifi: mvm: reduce active dwell time

Eliad Peller (2):
      iwlwifi: increase DEFAULT_MAX_TX_POWER
      iwlwifi: mvm: move IWL_MVM_UAPSD_QUEUES to constants.h

Emmanuel Grumbach (8):
      iwlwifi: mvm: enable scheduled scan on newest firmware
      iwlwifi: mvm: fix endianity issues with Smart Fifo commands
      iwlwiwi: mvm: use bss_conf->dtim_period instead of conf.ps_dtim_per=
iod
      iwlwifi: dvm: disable power save by default
      Merge remote-tracking branch 'iwlwifi-fixes/master' into NEXT
      iwlwifi: trans: don't configure the set_active in SCD for dvm
      iwlwifi: define the non shared antenna per hardware
      iwlwifi: mvm: allow to collect debug data when restart is disabled

Eran Harary (1):
      iwlwifi: mvm: allow preventing dummy notifications

Eyal Shapira (6):
      iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate
      iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength
      iwlwifi: mvm: add LDPC support
      iwlwifi: enable LDPC in 8000 chip family
      iwlwifi: mvm: rs: remove max_rate_idx
      iwlwifi: mvm: rs: don't zero tx stats after idle

Johannes Berg (9):
      iwlwifi: mvm: BT Coex - remove shadowing variable
      iwlwifi: mvm: correctly handle PM/QoS changes from mac80211
      iwlwifi: mvm: BT Coex - always initialize smps_mode
      iwlwifi: mvm: disable aggregation queues in station DB in FW
      iwlwifi: pcie: clear command data on freeing
      iwlwifi: mvm: don't update quota in firmware too often
      iwlwifi: mvm: update d0i3 debugfs
      iwlwifi: mvm: fix quota update avoidance
      iwlwifi: mvm: update QoS parameters when they change

Liad Kaufman (1):
      iwlwifi: make hw rev checking more readable

Luciano Coelho (5):
      iwlwifi: mvm: set MAC_FILTER_IN_BEACON correctly for STA/P2P client=

      iwlwifi: mvm: reset ucode_loaded flag when mac80211 stop is called
      iwlwifi: mvm: fail temp test enabling if the ucode is not loaded
      iwlwifi: mvm: use the firmware to get the temperature during CT kil=
l
      iwlwifi: mvm: align CSA GO NOA time event naming with the firmware

Max Stepanov (1):
      iwlwifi: mvm: add MVM_FW_MCAST_FILTER_PASS_ALL option

Oren Givon (2):
      iwlwifi: add PCI IDs and add then new 3165 series
      iwlwifi: add and edit 8000 series PCI IDs

Toralf F=EF=BF=BD=C2=B6rster (1):
      iwlwifi/iwl-drv.c: fix typo defualt -> default

 drivers/net/wireless/iwlwifi/Kconfig            |   2 -
 drivers/net/wireless/iwlwifi/dvm/power.c        |   2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  12 ++++++
 drivers/net/wireless/iwlwifi/iwl-7000.c         |  35 +++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-8000.c         |  16 ++++++-
 drivers/net/wireless/iwlwifi/iwl-config.h       |   9 ++++
 drivers/net/wireless/iwlwifi/iwl-csr.h          |  10 +++++
 drivers/net/wireless/iwlwifi/iwl-drv.c          |   2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |   3 ++
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   2 +
 drivers/net/wireless/iwlwifi/iwl-io.c           |   2 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |   7 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   8 +---
 drivers/net/wireless/iwlwifi/mvm/Makefile       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c         |  13 +++---
 drivers/net/wireless/iwlwifi/mvm/constants.h    |   8 ++++
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c  |   3 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  15 +++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  40 ++++++++++++++++--=

 drivers/net/wireless/iwlwifi/mvm/fw.c           |   3 ++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |  20 ++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 175 ++++++++++++++++++=
++++++----------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  30 +++++++++----
 drivers/net/wireless/iwlwifi/mvm/nvm.c          |   3 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  18 ++++++++
 drivers/net/wireless/iwlwifi/mvm/power.c        |  67 +++++++++++++++---=
-----------
 drivers/net/wireless/iwlwifi/mvm/quota.c        |  32 +++++++++++---
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  68 +++++++++++++-----=
------------
 drivers/net/wireless/iwlwifi/mvm/rs.h           |  10 +++--
 drivers/net/wireless/iwlwifi/mvm/rx.c           |   6 +--
 drivers/net/wireless/iwlwifi/mvm/scan.c         |   4 +-
 drivers/net/wireless/iwlwifi/mvm/sf.c           |   6 ++-
 drivers/net/wireless/iwlwifi/mvm/sta.c          |  12 +++++-
 drivers/net/wireless/iwlwifi/mvm/tdls.c         | 149 ++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/time-event.c   |  10 ++---
 drivers/net/wireless/iwlwifi/mvm/time-event.h   |   8 ++--
 drivers/net/wireless/iwlwifi/mvm/tt.c           | 326 ++++++++++++++++++=
++++++++++++++++---------------------------------------------------------=
--------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/tx.c           |  10 +++--
 drivers/net/wireless/iwlwifi/pcie/drv.c         |   8 ++++
 drivers/net/wireless/iwlwifi/pcie/internal.h    |   2 +
 drivers/net/wireless/iwlwifi/pcie/rx.c          |   2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c       |   3 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c          |  12 +++---
 43 files changed, 649 insertions(+), 526 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tdls.c


--JctDeaarP1lBl1bO6r6GQ3ONEImcmtnFu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUFnROAAoJEC0Llv5uNjIBDT0QAJXB6Sn0wvvO5k49wyirJRlB
lXjXD43KFFLub8Hlz5ZmyARuF39+fX2fmYpGiwAxOx1Io/9jauhURDXWAFEQUs3X
lZM+ogudJZ26dF+fxQwh0R4P/+8pj1tB8oROAUf3x1DGN/Ht7nrCcNpLarxSKInA
uSeR8cS11p7SGwr5HfSxwzI0ZygPKzy4lLaHSjO5+2uvkELW0yNTlWWKC+P5KHwV
D5RqNFb1DD7B6/YrdbFtdeRa35BKhVFIBQD8sSmsxhyr8jfCO4tU8ozS1Oku29vD
Qe8VRSwibNL/JBbThMxZiPoLOJYUpYU/fnPaUzK7lTSO7HV32EoRG4R1V5Jj6Qrh
Yq/e3+JIpVgXINCAzqaxZDwP6+NDQVTVs4h4sD84Qmcw/A7Ipv0/hsORr3dJbNLG
UhjM9uKgnV1ZAdzy69DvNyJ5hsbWrEjZ6cextZuJocu3gi1bKQyG8kA84qUUK0Us
1j3eVCiOBGZwqFHIACKBHkPmynJfi88l+0QzkTP49fEMJYgFoBqJH7cRNv8ag516
EXo1mkKRUOVI/LVTBBR+Df5n39KfCjauFjMKYnvEPdT8NoSMxnjgEhCJ1lO+psLr
39ru7SFcjWY+L+CXuYzNe25gCLEfyUJZ1i2ByLbKQQR6Y4IUFMS1kXuL7pCMIRtt
GfuAs2dtUQdM0QfmQeXE
=mc/k
-----END PGP SIGNATURE-----

--JctDeaarP1lBl1bO6r6GQ3ONEImcmtnFu--

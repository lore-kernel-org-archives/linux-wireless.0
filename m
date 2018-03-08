Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754184AbeCHPSd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:18:33 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-03-08
Date: Thu, 08 Mar 2018 17:18:29 +0200
Message-ID: <87muzifvei.fsf@kamboji.qca.qualcomm.com> (sfid-20180308_161848_372580_AF59B0C6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's a pull requsest to net tree for 4.16. Since the merge window I
have had some clannges to keep up with some patches but catching up now.

There should be nothing special here but please let me know if you have
any problems.

Kalle

The following changes since commit 7ac8ff95f48cbfa609a060fd6a1e361dd62feeb3:

  mvpp2: fix multicast address filter (2018-02-11 22:37:04 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-03-08

for you to fetch changes up to 455f3e76cfc0d893585a5f358b9ddbe9c1e1e53b:

  brcmfmac: fix P2P_DEVICE ethernet address generation (2018-03-07 16:36:41 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.16

Quote a few fixes as I have not been able to send a pull request
earlier. Most of the fixes for iwlwifi but also few others, nothing
really standing out though.

iwlwifi

* fix a bogus warning when freeing a TFD

* fix severe throughput problem with 9000 series

* fix for a bug that caused queue hangs in certain situations

* fix for an issue with IBSS

* fix an issue with rate-scaling in AP-mode

* fix Channel Switch Announcement (CSA) issues with count 0 and 1

* some firmware debugging fixes

* remov a wrong error message when removing keys

* fix a firmware sysassert most usually triggered in IBSS

* a couple of fixes on multicast queues

* a fix with CCMP 256

rtlwifi

* fix loss of signal for rtl8723be

brcmfmac

* add possibility to obtain firmware error

* fix P2P_DEVICE ethernet address generation

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Fix channel switch for count 0 and 1

Arend Van Spriel (2):
      brcmfmac: add possibility to obtain firmware error
      brcmfmac: fix P2P_DEVICE ethernet address generation

Emmanuel Grumbach (1):
      iwlwifi: pcie: don't warn if we use all the transmit pointers

Haim Dreyfuss (1):
      iwlwifi: Cancel and set MARKER_CMD timer during suspend-resume

Ilan Peer (2):
      iwlwifi: mvm: Direct multicast frames to the correct station
      iwlwifi: mvm: Correctly set the tid for mcast queue

Kalle Valo (2):
      Merge tag 'iwlwifi-for-kalle-2018-02-16-2' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2018-03-02' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Larry Finger (1):
      rtlwifi: rtl8723be: Fix loss of signal

Naftali Goldstein (1):
      iwlwifi: mvm: always init rs with 20mhz bandwidth rates

Sara Sharon (5):
      iwlwifi: mvm: fix security bug in PN checking
      iwlwifi: mvm: fix IBSS for devices that support station type API
      iwlwifi: mvm: fix TX of CCMP 256
      iwlwifi: mvm: fix assert 0x2B00 on older FWs
      iwlwifi: mvm: fix "failed to remove key" message

Shaul Triebitz (2):
      iwlwifi: align timestamp cancel with timestamp start
      iwlwifi: avoid collecting firmware dump if not loaded

Ulf Magnusson (1):
      iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM default

 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 10 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  3 ++
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 24 +++++------
 drivers/net/wireless/intel/iwlwifi/Kconfig         |  1 -
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 13 +++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  3 ++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    | 18 ++++++++
 drivers/net/wireless/intel/iwlwifi/fw/init.c       | 12 ++++--
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  7 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  8 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  5 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 49 +++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 10 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 28 +++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 39 ++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 33 ++++++++-------
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 13 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  3 +-
 25 files changed, 212 insertions(+), 88 deletions(-)

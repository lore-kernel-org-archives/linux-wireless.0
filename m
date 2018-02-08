Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751988AbeBHRyU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 12:54:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-02-08
Date: Thu, 08 Feb 2018 19:54:15 +0200
Message-ID: <87shabe5a0.fsf@kamboji.qca.qualcomm.com> (sfid-20180208_185436_776830_897AF178)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

first set of fixes for 4.16, unusually many when the merge window hasn't
even closed yet. Especially the ssb fix is important so I hope there's
still time to get this to 4.16-rc1. As you can see from the diffstat
there's one PCI id addition but that has been acked by Bjorn.

Please let me know if you have any problems.

Kalle

The following changes since commit f813614f531114db796ad66ced75c5dc8db7aa3a:

  ibmvnic: Wait for device response when changing MAC (2018-01-29 18:03:24 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-02-08

for you to fetch changes up to 99ffd198f07f46f3a8e64399249a8333c09063df:

  Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-02-08 19:28:49 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.16

The most important here is the ssb fix, it has been reported by the
users frequently and the fix just missed the final v4.15. Also
numerous other fixes, mt76 had multiple problems with aggregation and
a long standing unaligned access bug in rtlwifi is finally fixed.

Major changes:

ath10k

* correct firmware RAM dump length for QCA6174/QCA9377

* add new QCA988X device id

* fix a kernel panic during pci probe

* revert a recent commit which broke ath10k firmware metadata parsing

ath9k

* fix a noise floor regression introduced during the merge window

* add new device id

rtlwifi

* fix unaligned access seen on ARM architecture

mt76

* various aggregation fixes which fix connection stalls

ssb

* fix b43 and b44 on non-MIPS which broke in v4.15-rc9

----------------------------------------------------------------
Felix Fietkau (4):
      mt76: implement AP_LINK_PS
      mt76: implement processing of BlockAckReq frames
      mt76: avoid re-queueing A-MPDU rx reorder work if no frames are pending
      mt76: do not set status->aggr for NULL data frames

Kalle Valo (2):
      Merge git://git.kernel.org/.../kvalo/wireless-drivers.git
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Larry Finger (1):
      rtlwifi: rtl8821ae: Fix connection lost problem correctly

Oleksij Rempel (1):
      ath9k_htc: add Altai WA1011N-GU

Ryan Hsu (1):
      Revert "ath10k: add sanity check to ie_len before parsing fw/board ie"

Sven Joachim (1):
      ssb: Do not disable PCI host on non-Mips

Tobias Schramm (2):
      PCI: Add Ubiquiti Networks vendor ID
      ath10k: add support for Ubiquiti rebranded QCA988X v2

Wojciech Dubowik (1):
      ath9k: Fix get channel default noise floor

Yu Wang (2):
      ath10k: correct the length of DRAM dump for QCA6174 hw3.x/QCA9377 hw1.1
      ath10k: fix kernel panic issue during pci probe

 drivers/net/wireless/ath/ath10k/core.c             | 43 +++++++++++++++---
 drivers/net/wireless/ath/ath10k/coredump.c         |  3 +-
 drivers/net/wireless/ath/ath10k/debug.c            | 12 ++++-
 drivers/net/wireless/ath/ath10k/hw.h               |  1 +
 drivers/net/wireless/ath/ath10k/pci.c              |  6 +++
 drivers/net/wireless/ath/ath9k/calib.c             |  2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  1 +
 drivers/net/wireless/mediatek/mt76/agg-rx.c        | 40 ++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mac80211.c      | 52 +++++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h          | 10 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   | 28 ++++++------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  5 ++-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  1 +
 drivers/ssb/Kconfig                                |  2 +-
 include/linux/pci_ids.h                            |  2 +
 18 files changed, 181 insertions(+), 32 deletions(-)

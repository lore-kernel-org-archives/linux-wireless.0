Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755172AbeASI7h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 03:59:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-01-19
Date: Fri, 19 Jan 2018 10:59:33 +0200
Message-ID: <873732b4wa.fsf@kamboji.qca.qualcomm.com> (sfid-20180119_100105_277514_71428966)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

a pull request to net-next tree for 4.16. This should be the last pull
request in this cycle, unless Linus releases -rc9 of course. Only few
patches so should be an easy one. Please let me know if there are any
problems.

Kalle

The following changes since commit 79d891c1bbb6573cef31dbc2030fba61cfa1df6d:

  Merge tag 'linux-can-next-for-4.16-20180105' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next (2018-01-15 16:13:34 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-01-19

for you to fetch changes up to 5f9066930b5da506b38be895b956ac5f854c374b:

  rtlwifi: Support A-MSDU in A-MPDU capability (2018-01-18 15:27:11 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.16

Final few patches before the merge window, nothing really special.

ath9k

* add MSI support (not enabled by default yet)

rtlwifi

* support A-MSDU in A-MPDU aggregation

----------------------------------------------------------------
AceLan Kao (1):
      ath9k: add a quirk to set use_msi automatically

Brian Norris (2):
      Revert "mwifiex: cancel pcie/sdio work in remove/shutdown handler"
      mwifiex: resolve reset vs. remove()/shutdown() deadlocks

Colin Ian King (3):
      ath10k: fix spelling mistake: "addrress" -> "address"
      ath10k: remove redundant -ve check against u32 integer size
      rtlwifi: btcoexist: remove redundant variable fw_ps_state

Kalle Valo (2):
      ath10k: fix recently introduced checkpatch warnings
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Larry Finger (1):
      rtlwifi: btcoex: Remove typedef statements

Lorenzo Bianconi (2):
      mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
      mt76: fix possible NULL pointer dereferencing in mt76x2_mac_write_txwi()

Maya Erez (1):
      MAINTAINERS: wireless: update wil6210 maintainer entry

Ping-Ke Shih (7):
      rtlwifi: Use mutex to replace spin_lock to protect IPS and LPS
      rtlwifi: fix scan channel 1 fail after IPS
      rtlwifi: btcoex: Add power_on_setting routine
      rtlwifi: btcoex: Remove global variables from btcoex
      rtlwifi: btcoex: Add common function for qeurying BT information
      rtlwifi: btcoex: add rfe_type parameter to btcoex
      rtlwifi: Support A-MSDU in A-MPDU capability

Russell Hu (1):
      ath9k: add MSI support

Ryan Hsu (1):
      ath10k: add sanity check to ie_len before parsing fw/board ie

Tsang-Shian Lin (1):
      rtlwifi: unlink bss when un-association

 MAINTAINERS                                        |   4 +-
 drivers/net/wireless/ath/ath10k/ce.h               |   1 +
 drivers/net/wireless/ath/ath10k/core.c             |  14 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   1 +
 drivers/net/wireless/ath/ath10k/pci.c              |   5 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  33 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   3 +
 drivers/net/wireless/ath/ath9k/init.c              |  57 +++
 drivers/net/wireless/ath/ath9k/mac.c               |  47 +++
 drivers/net/wireless/ath/ath9k/pci.c               |  21 +-
 drivers/net/wireless/ath/ath9k/reg.h               |  15 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   7 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 -
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |   4 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   7 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 401 +++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 178 +++++----
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 234 ++++++++++--
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   4 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  18 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   5 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  29 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  16 +-
 25 files changed, 875 insertions(+), 234 deletions(-)

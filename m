Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33588 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754116AbeDZKNB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:13:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-04-26
Date: Thu, 26 Apr 2018 13:12:54 +0300
Message-ID: <87h8ny6ztl.fsf@kamboji.qca.qualcomm.com> (sfid-20180426_121356_990089_1C8B4584)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's a pull request to net tree, more info below. Please let me know
if you have any problems.

Kalle

The following changes since commit 4608f064532c28c0ea3c03fe26a3a5909852811a:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next (2018-04-03 14:08:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-04-26

for you to fetch changes up to af8a41cccf8f469165c6debc8fe07c5fd2ca501a:

  rtlwifi: cleanup 8723be ant_sel definition (2018-04-24 13:15:08 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.17

A few fixes for 4.17 but nothing really special. The new ETSI WMM
parameter support for iwlwifi is not technically a bugfix but
important for regulatory compliance.

iwlwifi

* use new ETSI WMM parameters from regulatory database

* fix a regression with the older firmware API 31 (eg. 31.560484.0)

brcmfmac

* fix a double free in nvmam loading fails

rtlwifi

* yet another fix for ant_sel module parameter

----------------------------------------------------------------
Arend Van Spriel (1):
      brcmfmac: fix firmware request processing if nvram load fails

Haim Dreyfuss (1):
      iwlwifi: mvm: query regdb for wmm rule if needed

Luca Coelho (1):
      iwlwifi: mvm: fix old scan version sizes

Ping-Ke Shih (1):
      rtlwifi: cleanup 8723be ant_sel definition

 .../broadcom/brcm80211/brcmfmac/firmware.c         |  36 ++++---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  13 +--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 111 ++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  15 ---
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  11 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   5 +
 8 files changed, 138 insertions(+), 62 deletions(-)

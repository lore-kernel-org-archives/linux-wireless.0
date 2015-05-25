Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49393 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbEYMB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 08:01:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2015-05-25
Date: Mon, 25 May 2015 15:01:19 +0300
Message-ID: <87siak3lyo.fsf@kamboji.qca.qualcomm.com> (sfid-20150525_140156_432768_2BCB9225)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's hopefully the last wireless-drivers pull request for 4.1. Mostly
iwlwifi fixes this time. Please let me know if there are any problems.

Kalle

The following changes since commit f673821864899153142365aca888435815ac93f0:

  ath9k: fix per-packet tx power configuration (2015-05-03 23:54:38 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2015-05-25

for you to fetch changes up to aefa441b150279dd8d25658e018898a3fe9a6769:

  Merge tag 'iwlwifi-for-kalle-2015-05-21' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2015-05-22 10:47:02 +0300)

----------------------------------------------------------------

iwlwifi:

* fix firmware name and other things to enable 3165
* fix bad APMG configuration for 8000 (no AMPG on these devices)
* fix MAC address assignment for 8000
* fix firmware debugging triggers (MLME)
* fix several bugs in low power states code (net-detect, d0i3)

ssb:

* fix reboot after device reset for WRT350N v1

----------------------------------------------------------------
Avri Altman (1):
      iwlwifi: pcie: don't disable the busmaster DMA clock for family 8000

Eliad Peller (1):
      iwlwifi: mvm: avoid use-after-free on iwl_mvm_d0i3_enable_tx()

Emmanuel Grumbach (4):
      iwlwifi: mvm: forbid MIMO on devices that don't support it
      iwlwifi: 7000: modify the firmware name for 3165
      iwlwifi: mvm: fix MLME trigger
      iwlwifi: mvm: BT Coex - duplicate the command if sent ASYNC

Haim Dreyfuss (1):
      iwlwifi: mvm: Free fw_status after use to avoid memory leak

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2015-05-21' of https://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Liad Kaufman (1):
      iwlwifi: nvm: force mac from otp in case nvm mac is reserved

Luciano Coelho (2):
      iwlwifi: mvm: take the UCODE_DOWN reference when resuming
      iwlwifi: mvm: clean net-detect info if device was reset during suspend

Rafał Miłecki (1):
      ssb: extend fix for PCI related silent reboots to all chipsets

 drivers/net/wireless/iwlwifi/Kconfig            |    1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c         |   16 ++++++------
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |    5 ++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |    3 +++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |   30 +++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c  |    2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c           |   22 ++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |    3 ---
 drivers/net/wireless/iwlwifi/mvm/ops.c          |    6 +++--
 drivers/net/wireless/iwlwifi/mvm/rs.c           |    3 +++
 drivers/net/wireless/iwlwifi/pcie/trans.c       |    8 +++---
 drivers/ssb/driver_pcicore.c                    |    7 +++---
 12 files changed, 73 insertions(+), 33 deletions(-)

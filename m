Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34126 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdKVP10 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 10:27:26 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2017-11-22
Date: Wed, 22 Nov 2017 17:27:22 +0200
Message-ID: <87mv3ebag5.fsf@kamboji.qca.qualcomm.com> (sfid-20171122_162749_936739_216272B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's the first pull request to net tree for 4.15. Please let me know
if there are any problems.

Kalle

The following changes since commit 32a72bbd5da2411eab591bf9bc2e39349106193a:

  net: vxge: Fix some indentation issues (2017-11-20 11:36:30 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2017-11-22

for you to fetch changes up to ed59b7d53c95548d83d4e7e1bc5edafcdcad09c9:

  Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2017-11-21 11:52:18 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.15

First set of fixes for 4.15. Most important here is the iwlwifi fix
for scan command firmware interface change.

ath10k

* fix CCMP-256, GCMP and GCMP-256 in raw mode, it was never working

wcn36xx

* fix device tree node search

iwlwifi

* fix a regression with firmware API change of scan cmd (introduced in
  firmware version 34)

* add a bunch of PCI IDs and fix configuration structs for A000 devices

* fix the exported firmware name strings for 9000 and A000 devices

----------------------------------------------------------------
Johan Hovold (1):
      wcn36xx: fix iris child-node lookup

Kalle Valo (2):
      Merge tag 'iwlwifi-for-kalle-2017-11-19' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Luca Coelho (2):
      iwlwifi: mvm: support version 7 of the SCAN_REQ_UMAC FW command
      iwlwifi: fix PCI IDs and configuration mapping for 9000 series

Thomas Backlund (1):
      iwlwifi: fix firmware names for 9000 and A000 series hw

Vasanthakumar Thiagarajan (1):
      ath10k: fix data rx for CCMP-256, GCMP and GCMP-256 in raw mode

 drivers/net/wireless/ath/ath10k/htt_rx.c         |  51 ++++++---
 drivers/net/wireless/ath/wcn36xx/main.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c    |  73 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c    |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h |  59 +++++++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h  |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |   6 ++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c    |  86 +++++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c    | 132 ++++++++++++++++++-----
 10 files changed, 335 insertions(+), 90 deletions(-)

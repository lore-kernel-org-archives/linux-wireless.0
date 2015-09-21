Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45709 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753540AbbIUUzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:55:43 -0400
Message-ID: <1442868938.27148.361.camel@coelho.fi> (sfid-20150921_225546_907630_2A0FF6CD)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: egrumbach@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Sep 2015 23:55:38 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: pull request: iwlwifi-next 2015-09-21
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is our first pull request for 4.4.  This is also my first pull
-request for iwlwifi, so bear with me and let me know if there are any
issues.  And please don't come here to beat me up physically if I did
something wrong (it's scary to send pull requests to maintainers that
are just a couple of hours drive away). :)

Luca.

The following changes since commit 5865f3658ba37c54e346b0fdee08a1c7a152681b:

  iwlwifi: mvm: bump firmware API to 17 (2015-08-23 12:54:16 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2015-09-21

for you to fetch changes up to 7c014e35a018187462f2cd6c85259e080663ba2d:

  iwlwifi: mvm: add debug print for d0i3 exit indication (2015-09-21 18:08:46 +0300)

----------------------------------------------------------------
* some debugfs improvements;
* fix signedness in beacon statistics;
* deinline some functions to reduce size when device tracing is enabled;
* filter beacons out in AP mode when no stations are associated;
* deprecate firmwares version -12;
* fix a runtime PM vs. legacy suspend race;
* one-liner fix for a ToF bug;
* clean-ups in the rx code;
* small debugging improvement;
* fix WoWLAN with new firmware versions;

----------------------------------------------------------------
Eliad Peller (2):
      iwlwifi: mvm: configure wowlan configuration only if connected
      iwlwifi: mvm: add debug print for d0i3 exit indication

Emmanuel Grumbach (8):
      iwlwifi: mvm: add debugfs hook to send ECHO_CMD to the firmware
      iwlwifi: Deinline iwl_{read,write}(8,32}
      iwlwifi: mvm: don't load -12.ucode anymore
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_HDC_PHASE_0 TLV flag
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_TX_POWER_DEV TLV flag
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_SINGLE_SCAN_EBS TLV flag
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_ASYNC_DTM TLV flag
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_STATS_V10 TLV flag

Gregory Greenman (1):
      iwlwifi: mvm: don't ask for beacons when AP vif and no assoc sta

Johannes Berg (6):
      iwlwifi: mvm: don't NUL-terminate low-latency debugfs file
      iwlwifi: mvm: make sure AP is operating for ToF
      iwlwifi: mvm: remove useless debug message from RX
      iwlwifi: mvm: remove pointless cfg_phy_cnt length check
      iwlwifi: mvm: remove some unused defines from RX API
      iwlwifi: mvm: move RX API into its own file

Liad Kaufman (1):
      iwlwifi: mvm: remove SCD_QUEUE_CONFIG TLV flag

Luciano Coelho (2):
      iwlwifi: mvm: remove netdetect debugfs entry
      iwlwifi: mvm: make sure d0i3 exit work runs before suspending

Sara Sharon (1):
      iwlwifi: mvm: fix statistics variables type

 drivers/net/wireless/iwlwifi/iwl-7000.c         |   6 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c         |   6 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  13 -----
 drivers/net/wireless/iwlwifi/iwl-io.c           |  23 ++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h           |  21 +------
 drivers/net/wireless/iwlwifi/mvm/d3.c           |   3 +
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c  |   3 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      | 129 +++++-------------------------------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-rx.h    | 238 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h |  41 ++------------
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       | 186 +------------------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  16 ------
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |  21 +++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |  26 +++------
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  21 +++----
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  23 +++++---
 drivers/net/wireless/iwlwifi/mvm/rx.c           |  63 ++++++---------------
 drivers/net/wireless/iwlwifi/mvm/scan.c         |   2 -
 drivers/net/wireless/iwlwifi/mvm/sta.c          |   5 ++
 drivers/net/wireless/iwlwifi/mvm/tof.c          |   3 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c        |  11 ----
 21 files changed, 369 insertions(+), 491 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-rx.h

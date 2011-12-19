Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58934 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab1LSWnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 17:43:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/6] update for 3.3: iwlwifi 2011-12-19
Date: Mon, 19 Dec 2011 13:43:07 -0800
Message-Id: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111219_234348_299181_BD98A5CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We addess a throughput dropping issue caused by mis-configure the calibration
We make changes for testmode commands to better align with wiphy interface

Johannes Berg (2):
  iwlagn: add IRQ tracing
  iwlagn: finer-grained HT disable

Venkataraman, Meenakshi (1):
  iwlwifi: Execute runtime calibration always

Wey-Yi Guy (3):
  iwlwifi: deliver hw version in both string and u32 format
  iwlwifi: set hw_version in wiphy
  iwlwifi: use bus_get_hw_id for IWL_TM_CMD_APP2DEV_GET_DEVICE_ID

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn.c           |   14 +++++----
 drivers/net/wireless/iwlwifi/iwl-bus.h           |   16 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h      |   29 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    6 ++++
 drivers/net/wireless/iwlwifi/iwl-pci.c           |   10 ++++++-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   11 +++++---
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |   13 ++-------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   32 ++++++++++++++-------
 9 files changed, 96 insertions(+), 37 deletions(-)


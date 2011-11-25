Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1KYUIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:08:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/7] update for 3.3
Date: Fri, 25 Nov 2011 11:11:41 -0800
Message-Id: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111125_210821_353767_868C3543)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We remove the calibration knowledge from driver since it is uCode functions
We adding new testmode command to help test and validation the uCode

Emmanuel Grumbach (1):
  iwlwifi: help to debug AGG SM inconsistencies

Hsu, Kenny (1):
  iwlwifi: add tm commands for indirect register access

Johannes Berg (3):
  iwlagn: remove calibration knowledge
  iwlagn: dynamically allocate & reflect calibration data
  iwlagn: allow up to uCode API 6 for 6000 devices

Wey-Yi Guy (2):
  iwlwifi: show command string for REPLY_D3_CONFIG
  iwlwifi: show the configuration option

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-1000.c       |    9 ---
 drivers/net/wireless/iwlwifi/iwl-2000.c       |   14 -----
 drivers/net/wireless/iwlwifi/iwl-5000.c       |   16 +------
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   22 ++------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c  |   66 ++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c  |   48 +++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   34 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h        |   24 ++-------
 drivers/net/wireless/iwlwifi/iwl-shared.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-sv-open.c    |   40 +++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-testmode.h   |   20 +++++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   12 ++++-
 15 files changed, 157 insertions(+), 159 deletions(-)


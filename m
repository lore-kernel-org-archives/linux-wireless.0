Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258Ab2DXXv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/11] update for 3.5: iwlwifi 2012-04-24
Date: Tue, 24 Apr 2012 16:45:53 -0700
Message-Id: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015154_140360_C5BBD394)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add reduce tx power feature for bluetooth coex
We also add new module parameter for disable 5GHz band

Emmanuel Grumbach (2):
  iwlwifi: use IWL_* instead of dev_printk when possible
  iwlwifi: don't init trans->reg_lock from the op_mode

Stanislaw Gruszka (1):
  iwlwifi: add option to disable 5GHz band

Wey-Yi Guy (8):
  iwlwifi: remove unused macros
  iwlwifi: add BT reduced tx power flag
  iwlwifi: add checking for the condition to reduce tx power
  iwlwifi: add reduced tx power threshold define
  iwlwifi: small define change
  iwlwifi: send reduce tx power info in command
  iwlwifi: change kill mask based on reduce power state
  iwlwifi: add loose coex lut

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |  153 ++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   15 ++-
 drivers/net/wireless/iwlwifi/iwl-commands.h   |   21 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c        |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-modparams.h  |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 7 files changed, 108 insertions(+), 97 deletions(-)


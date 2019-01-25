Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E1BC282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7F5218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfAYUNO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:13:14 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50760 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbfAYUNO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:13:14 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qh-00010a-2o; Fri, 25 Jan 2019 22:13:11 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:48 +0200
Message-Id: <20190125201305.5616-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/17] iwlwifi: updates intended for v5.1 2019-01-25
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the third set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* A bunch of fixes for issues found with static analyzers;
* Relicense the pcie submodule to dual GPL/BSD;
* Some more cleanups for the device configuration refactoring;
* Other cleanups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Johannes Berg (5):
  iwlwifi: mvm: fix %16 to %016 print format
  iwlwifi: mvm: read IWL_RX_MPDU_PHY_SHORT_PREAMBLE only for CCK
  iwlwifi: pcie: align licensing to dual GPL/BSD
  iwlwifi: mvm: clean up LDBG config command usage
  iwlwifi: move iwl_enable_{rx,tx}_ampdu to iwl-modparams.h

Liad Kaufman (1):
  iwlwifi: mvm: remove sta key on wep ap

Luca Coelho (5):
  iwlwifi: mvm: save and export regdb blob from the NVM
  iwlwifi: make iwl_fw_dbg_start_stop_hcmd() inline
  iwlwifi: mvm: pre-initialize alive_data in wait_alive()
  iwlwifi: calculate pointers from out_cmd instead of out_cmd->hdr
  iwlwifi: make sure cur_fw_img is valid before accessing img

Sara Sharon (3):
  iwlwifi: pcie: fix the use of a wrong define
  iwlwifi: pcie: add prints to track virtual ID
  iwlwifi: mvm: add an option to dereference vif by id

Shahar S Matityahu (1):
  iwlwifi: monitor dumping flow cleanup

Shaul Triebitz (2):
  iwlwifi: iwlmvm: ignore HE PPDU type regarding EOF
  iwlwifi: iwlmvm: in monitor NDP notif take the NSS from rx_vec

 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |  23 +---
 .../net/wireless/intel/iwlwifi/fw/api/debug.h |  33 +++---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  12 +--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  17 +--
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  41 ++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |  38 ++++++-
 .../wireless/intel/iwlwifi/iwl-modparams.h    |  18 ++++
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  46 +-------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 101 ++++++++----------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  36 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  15 +++
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c  |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  38 ++++---
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  24 ++---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  44 +++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  52 ++++++++-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  18 +---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  44 +++++++-
 22 files changed, 380 insertions(+), 241 deletions(-)

-- 
2.20.1


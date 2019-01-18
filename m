Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBBCC5AC81
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644832086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbfARTAR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:17 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48302 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728989AbfARTAQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:16 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNE-0004cj-Sn; Fri, 18 Jan 2019 21:00:13 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:48 +0200
Message-Id: <20190118190004.22270-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/16] iwlwifi: updates intended for v4.21 2019-01-18
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the first set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Preparations for improvements in the device selection code;
* Some new PCI IDs;
* Support for TWT;
* Debugging infrastructure work;
* Other cleanups and small fixes;

I'm using some new scripts I wrote that automate the removal of tags,
cherry-picking, squashing etc.  Please let me know if you see anything
weird, since I'm automating more and doing less manual checks, and the
scripts may have let something go through.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Colin Ian King (1):
  iwlwifi: pcie: make array 'prop' static, shrinks object size

Emmanuel Grumbach (3):
  iwlwifi: mvm: advertise support for TWT in the Extended Capability IE
  iwlwifi: mvm: rely on mac80211 to configure TWT support
  iwlwifi: mvm: fix firmware statistics usage

Ihab Zhaika (2):
  iwlwifi: correct one of the PCI struct names
  iwlwifi: add new cards for 22560, 9260 and killer series

Johannes Berg (1):
  iwlwifi: mvm: make NVM access actually fail on failures

Luca Coelho (5):
  iwlwifi: add PCI IDs for the 22260 device series
  iwlwifi: pcie: recognize NICs with hw_rev 0x364 correctly
  iwlwifi: remove support for 9000 A-step devices
  iwlwifi: pcie: remove unnecessary iwl_pcie_enable_rx_wake() function
  iwlwifi: pcie: remove suspend/resume workaround for 9000A devices

Sara Sharon (1):
  iwlwifi: mvm: support mac80211 TXQs model

Shahar S Matityahu (2):
  iwlwifi: wrt: add to dump number of lmacs, lmac1 and umac error id
  iwlwifi: wrt: add 22000 device familiy prph dump support

Shaul Triebitz (1):
  iwlwifi: mvm: fix wrong DCM TLC config

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  68 +++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c | 110 ++----
 .../net/wireless/intel/iwlwifi/fw/api/stats.h |  15 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 176 +++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   5 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  11 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   3 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  27 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   5 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  94 +----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 135 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  54 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  87 +++--
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 360 +++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  71 +---
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  13 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  86 ++++-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   2 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  26 --
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  25 +-
 27 files changed, 727 insertions(+), 700 deletions(-)

-- 
2.20.1


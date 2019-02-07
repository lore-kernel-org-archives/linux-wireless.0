Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9751BC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F06C2173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfBGWgh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56548 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726622AbfBGWgh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHY-0002II-LQ; Fri, 08 Feb 2019 00:36:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:05 +0200
Message-Id: <20190207223622.9642-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/17] iwlwifi: updates intended for v5.1 2019-02-07
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the seventh set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Work on the new debugging infrastructure continues;
* FTM (Fine Timing Measurement) initiator and responder implementation;
* Support for a new device family started;
* Bump supported FW API to 45;
* General bugfixes;
* Other cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: Fix possible NULL pointer dereference

Ido Yariv (1):
  iwlwifi: mvm: don't require WOWLAN images when unified

Johannes Berg (3):
  iwlwifi: mvm: support FTM responder
  iwlwifi: mvm: support FTM initiator
  iwlwifi: mvm: clean up NO_PSDU case

Luca Coelho (1):
  iwlwifi: bump FW API to 45 for 9000 and 22000 series

Mordechay Goodstein (1):
  iwlwifi: add FW recovery flow

Sara Sharon (4):
  iwlwifi: pcie: fix emergency path
  iwlwifi: dvm: don't use IWL_DL_FW_ERRORS
  iwlwifi: pcie: add TPT oriented prints
  iwlwifi: mvm: support beacon IE injection

Shahar S Matityahu (4):
  iwlwifi: dbg_ini: implement monitor sram memory dump
  iwlwifi: dbg_ini: implement monitor dram memory dump
  iwlwifi: receive umac and lmac error table addresses from TLVs
  iwlwifi: dbg_ini: rewrite trigger flow and align to FW API changes

Shaul Triebitz (2):
  iwlwifi: introduce device family AX210
  iwlwifi: do not fail on large amount of channels

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  49 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  14 +-
 .../net/wireless/intel/iwlwifi/fw/api/alive.h |  48 +-
 .../wireless/intel/iwlwifi/fw/api/commands.h  |   5 +
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  11 +-
 .../wireless/intel/iwlwifi/fw/api/location.h  |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 221 +++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  27 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  16 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  12 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  12 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  12 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   7 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |   5 +
 .../net/wireless/intel/iwlwifi/iwl-debug.h    |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  49 ++
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   6 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  10 +
 .../net/wireless/intel/iwlwifi/mvm/Makefile   |   1 +
 .../wireless/intel/iwlwifi/mvm/constants.h    |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 106 ++++
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 459 ++++++++++++++++++
 .../intel/iwlwifi/mvm/ftm-responder.c         | 244 ++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  77 ++-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  22 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 154 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  41 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  27 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |   3 +-
 .../wireless/intel/iwlwifi/mvm/time-event.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  12 +-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   8 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  42 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |   7 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  17 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  12 +-
 include/linux/ieee80211.h                     |   2 +
 41 files changed, 1629 insertions(+), 153 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c

-- 
2.20.1


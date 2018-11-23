Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1B0C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 344F5206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 344F5206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394349AbeKWWKb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:31 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38228 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388128AbeKWWKa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:30 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bY-0008GU-1z; Fri, 23 Nov 2018 13:26:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:16 +0200
Message-Id: <20181123112631.29360-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/15] iwlwifi: updates intended for v4.21 2018-11-23
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the third set of patches intended for v4.21.  It's the usual
development, with some small new features, cleanups and bugfixes.

The changes are:

* Some cleanups in the HW configuration structures;
* More work on the debugging infrastructure;
* Fixes related to 802.11ax;
* Other cleanups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: force TCM re-evaluation on TCM resume

Emmanuel Grumbach (1):
  iwlwifi: mvm: don't check if a pointer is set if it can't be unset

Luca Coelho (5):
  iwlwifi: move common 9000 cfg parameters to common macro
  iwlwifi: don't define OTP_LOW_IMAGE_SIZE per family, but per size
  iwlwifi: remove useless NVM_HW_SECTION_NUM_FAMILY_* macros
  iwlwifi: move iwl_nvm_check_version() into dvm
  iwlwifi: remove all unnecessary occurrences of nvm_calib_ver

Sara Sharon (5):
  iwlwifi: dbg: dump data according to the new ini TLVs
  iwlwifi: add support for triggering ini triggers
  iwlwifi: mvm: activate apply points
  iwlwifi: pcie: fix erroneous print
  iwlwifi: pcie: set cmd_len in the correct place

Shaul Triebitz (3):
  iwlwifi: mvm: change PHY data RX for HE radiotap
  iwlwifi: mvm: add L-SIG length to radiotap
  iwlwifi: mvm: radiotap: remove UL_DL bit in HE TRIG_BASED

 drivers/net/wireless/intel/iwlwifi/cfg/1000.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c |   4 +-
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  10 +-
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c |  27 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |  11 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  85 +---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  17 +
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 190 +++++----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 322 +++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  41 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  17 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   8 +-
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.c |  19 -
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.h |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |   6 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  20 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   2 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  37 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 394 +++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |   2 +
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  14 +
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |  13 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |   2 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   5 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  71 +++-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  10 +-
 31 files changed, 872 insertions(+), 498 deletions(-)

-- 
2.19.1


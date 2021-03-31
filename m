Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D38C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Mar 2021 09:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C27E61582
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Mar 2021 09:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhCaJPC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:15:02 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43724 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234673AbhCaJOz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Mar 2021 05:14:55 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lRWw8-00087q-ER; Wed, 31 Mar 2021 12:14:54 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 31 Mar 2021 12:14:40 +0300
Message-Id: <20210331091452.543321-1-luca@coelho.fi>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/12] iwlwifi: updates intended for v5.13 2021-03-31
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for v5.13.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* One fix in PMF;
* Some new regulatory features;
* Support for passive scan in 6GHz;
* Some improvements in the sync queue implementation;
* Support for new devices;
* Some other small fixes, clean-ups and improvements.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: when associated with PMF, use protected NDP ranging
    negotiation

Harish Mitty (1):
  iwlwifi: mvm: refactor ACPI DSM evaluation function

Ilan Peer (1):
  iwlwifi: mvm: Add support for 6GHz passive scan

Johannes Berg (3):
  iwlwifi: mvm: write queue_sync_state only for sync
  iwlwifi: mvm: clean up queue sync implementation
  iwlwifi: pcie: try to grab NIC access early

Miri Korenblit (2):
  iwlwifi: mvm: enable PPAG in China
  iwlwifi: mvm: support BIOS enable/disable for 11ax in Ukraine

Mordechay Goodstein (1):
  iwlwifi: move iwl_configure_rxq to be used by other op_modes

Ravi Darsi (1):
  iwlwifi: mvm: Use IWL_INFO in fw_reset_handshake()

ybaruch (2):
  iwlwifi: add ax201 killer device
  iwlwifi: add new so-gf device

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   4 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |  84 ++++++-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  13 +-
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   |   3 +
 .../net/wireless/intel/iwlwifi/fw/api/power.h |  22 +-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  30 ---
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |   8 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |  59 +++++
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   2 +
 .../wireless/intel/iwlwifi/mvm/constants.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   2 +
 .../intel/iwlwifi/mvm/ftm-initiator.c         |   9 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 209 +++++-------------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  49 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  58 +----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 128 +++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |  38 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  29 ++-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |   4 +-
 23 files changed, 491 insertions(+), 287 deletions(-)

-- 
2.31.0


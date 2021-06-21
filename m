Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC45C49EA2
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jun 2021 07:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C48860FDC
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jun 2021 07:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFUHkD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jun 2021 03:40:03 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:48400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229651AbhFUHkC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jun 2021 03:40:02 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lvEV4-001aFa-P0; Mon, 21 Jun 2021 10:37:44 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon, 21 Jun 2021 10:37:31 +0300
Message-Id: <20210621073740.1105911-1-luca@coelho.fi>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/9] iwlwifi: updates intended for v5.14 2021-06-21
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth set of patches intended for v5.14.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Updates in the WoWLAN FW commands;
* Add one new device to the PCI ID lists;
* Support reading PNVM from a UEFI variable;
* Bump the supported FW API version;
* Some other small fixes, clean-ups and improvements.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (3):
  iwlwifi: mvm: update iwl_wowlan_patterns_cmd
  iwlwifi: mvm: introduce iwl_wowlan_kek_kck_material_cmd_v4
  iwlwifi: mvm: introduce iwl_wowlan_get_status_cmd

Johannes Berg (2):
  iwlwifi: move error dump to fw utils
  iwlwifi: fw: dump TCM error table if present

Luca Coelho (3):
  iwlwifi: move UEFI code to a separate file
  iwlwifi: support loading the reduced power table from UEFI
  iwlwifi: bump FW API to 64 for AX devices

ybaruch (1):
  iwlwifi: add 9560 killer device

 drivers/net/wireless/intel/iwlwifi/Makefile   |   3 +-
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   6 +-
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    |  31 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  38 --
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c  | 418 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c  | 120 ++---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  | 262 +++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h  |  42 ++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   2 +
 .../intel/iwlwifi/iwl-context-info-gen3.h     |  16 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  11 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  20 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  74 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   8 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 310 -------------
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |  34 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   2 +
 .../wireless/intel/iwlwifi/pcie/internal.h    |   1 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   7 +
 22 files changed, 962 insertions(+), 459 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/dump.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/uefi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/uefi.h

-- 
2.32.0


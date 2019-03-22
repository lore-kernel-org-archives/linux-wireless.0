Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C26C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0F00218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfCVN7O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46052 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727487AbfCVN7O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:14 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7KhS-0000bK-DU; Fri, 22 Mar 2019 15:59:11 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:39 +0200
Message-Id: <20190322135903.10631-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/24]  iwlwifi: updates intended for v5.2 2019-03-22
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the third set of patches intended for v5.2.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Work on the new debugging infra continues;
* Fixes for the 22000 series;
* Support for some new FW API changes;
* Work on new hardware continues;
* Some debugfs cleanups by Greg-KH;
* General bugfixes;
* Other cleanups;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: use correct GP2 register address for 22000 family

Greg Kroah-Hartman (2):
  iwlwifi: mvm: no need to check return value of debugfs_create
    functions
  iwlwifi: pcie: no need to check return value of debugfs_create
    functions

Ihab Zhaika (1):
  iwlwifi: remove misconfigured pci ids from 22260 series

Johannes Berg (2):
  iwlwifi: mvm: IBSS: use BE FIFO for multicast
  iwlwifi: mvm: remove buggy and unnecessary hw_queue initialization

Liad Kaufman (1):
  iwlwifi: mvm: fix pointer reference when setting HE QAM thres

Sara Sharon (1):
  iwlwifi: mvm: support HE context cmd API change

Shahar S Matityahu (14):
  iwlwifi: dbg_ini: support HW error trigger
  iwlwifi: dbg_ini: enforce always on domain checking
  iwlwifi: dbg_ini: fix iwl_dump_ini_dev_mem_iter memory base address
  iwlwifi: dbg_ini: add memory offset to the base address of a memory
    region
  iwlwifi: dbg_ini: add version to dump header
  iwlwifi: dbg_ini: add region id to the region dump
  iwlwifi: dbg_ini: add registers addresses in fifo dump
  iwlwifi: dbg_ini: change memory range base address to u64
  iwlwifi: dbg_ini: fix the dram monitor header size
  iwlwifi: dbg_ini: add monitor header to smem monitor
  iwlwifi: dbg_ini: remove redundant curly brackets from trigger
    collection flow
  iwlwifi: dbg_ini: remove redundant type argument from iwl_dump_ini_mem
  iwlwifi: dbg_ini: apply rx fifo offset after reading the region
    registers
  iwlwifi: dbg: fill radio registers data regardless of fifos data
    dumping

Shaul Triebitz (2):
  iwlwifi: trust calling function
  iwlwifi: set 512 TX queue slots for AX210 devices

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  13 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  10 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   |  77 +++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 237 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  10 +
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  33 ++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   3 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   8 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |   7 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   2 +
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  |  17 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  89 +++----
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  40 +--
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  11 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |   1 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |   6 +-
 25 files changed, 403 insertions(+), 263 deletions(-)

-- 
2.20.1


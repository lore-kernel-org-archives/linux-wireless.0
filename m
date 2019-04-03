Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B707C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15BE621473
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfDCJWd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:22:33 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49684 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725907AbfDCJWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:22:33 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6I-0007aR-QB; Wed, 03 Apr 2019 12:22:31 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:11 +0300
Message-Id: <20190403092224.815-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/13] iwlwifi: updates intended for v5.2 2019-04-03
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth set of patches intended for v5.2.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Bump the 20000-series FW API version supported;
* Work on the new debugging infra continues;
* One clean-up to prevent a bogus warning with clang;
* A small cleanup in the PCI ID list;
* Work on new hardware continues;
* RTT confidence indication support for FTM;
* An improvement in HE rate-scaling;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (1):
  iwlwifi: mvm: support rtt confidence indication

Gregory Greenman (1):
  iwlwifi: rs: consider LDPC capability in case of HE

Luca Coelho (2):
  iwlwifi: bump FW API to 47 for 22000 series
  iwlwifi: remove unused 0x40C0 PCI device IDs

Nathan Chancellor (1):
  iwlwifi: mvm: Change an 'else if' into an 'else' in
    iwl_mvm_send_add_bcast_sta

Shahar S Matityahu (6):
  iwlwifi: dbg_ini: support notification and dhc regions type parsing
  iwlwifi: add FW_INFO debug level
  iwlwifi: dbg_ini: add debug prints to the ini flows
  iwlwifi: dbg: add periphery memory dumping support to ax210 device
    family
  iwlwifi: dbg: add lmac and umac PC registers to periphery dump
  iwlwifi: dbg_ini: set dump bit only when trigger collection is certain

Shaul Triebitz (2):
  iwlwifi: mvm: set 512 TX queue slots for AX210 devices
  iwlwifi: unite macros with same meaning

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  19 +--
 .../wireless/intel/iwlwifi/fw/api/location.h  |  77 ++++++++++-
 .../net/wireless/intel/iwlwifi/fw/api/txq.h   |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 123 ++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   1 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   1 -
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-debug.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   8 +-
 .../intel/iwlwifi/mvm/ftm-initiator.c         |  13 +-
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |  16 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  11 +-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |   3 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   5 -
 .../wireless/intel/iwlwifi/pcie/internal.h    |   4 -
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |   7 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |   8 +-
 19 files changed, 230 insertions(+), 81 deletions(-)

-- 
2.20.1


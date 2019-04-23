Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83796C282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FCEC20685
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfDWIuU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 04:50:20 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:42836 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726618AbfDWIuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 04:50:20 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIr86-0000YC-M0; Tue, 23 Apr 2019 11:50:18 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 0/8] iwlwifi: updates intended for v5.2 2019-04-23
Date:   Tue, 23 Apr 2019 11:50:06 +0300
Message-Id: <20190423085014.15390-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fifth set of patches intended for v5.2.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Fix a bug we introduced in the RX path in a previous patch;
* Add command version parsing from the FW TLVs;
* Some fixes and improvements in the new debugging framework;
* One tiny janitorial fix to remove a stray character;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.



Andrei Otcheretianski (1):
  iwlwifi: mvm: Don't sleep in RX path

Johannes Berg (1):
  iwlwifi: parse command version TLV

Luca Coelho (1):
  iwlwifi: pcie: remove stray character in iwl_pcie_rx_alloc_page()

Shahar S Matityahu (5):
  iwlwifi: dbg_ini: add lmac and umac error tables dumping support
  iwlwifi: dbg_ini: add periodic trigger support
  iwlwifi: dbg: replace dump info device family with HW type
  iwlwifi: avoid allocating memory for region with disabled domain
  iwlwifi: dbg_ini: check for valid region type during regions parsing

 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  4 ++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 70 ++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  3 +
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  | 17 +++++
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  7 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |  2 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 18 +++++
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 +
 .../wireless/intel/iwlwifi/mvm/time-event.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  2 +-
 14 files changed, 118 insertions(+), 16 deletions(-)

-- 
2.20.1


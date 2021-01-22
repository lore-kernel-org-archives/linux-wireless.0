Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B66C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 12:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7555E230FC
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 12:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbhAVMxu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Jan 2021 07:53:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41624 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726282AbhAVMxb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jan 2021 07:53:31 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l2vvf-003vnH-Dq; Fri, 22 Jan 2021 14:52:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Jan 2021 14:52:35 +0200
Message-Id: <20210122125242.107146-1-luca@coelho.fi>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH for v5.11 0/7] iwlwifi: fixes intended for v5.11 2021-01-22
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the second patchset with fixes for v5.11.

The changes are:

* Some HW matching fixes;
* A fix for DSM methods reading;
* Some memory leak fixes;
* Other important fixes here and there.

As usual, I'm pushing this to a pending branch, for kbuild bot.  And
since these are fixes for the rc series, please take them directly to
wireless-drivers.git, as we agreed.

Cheers,
Luca.


Gregory Greenman (1):
  iwlwifi: mvm: invalidate IDs of internal stations at mvm start

Johannes Berg (2):
  iwlwifi: mvm: guard against device removal in reprobe
  iwlwifi: queue: bail out on invalid freeing

Luca Coelho (1):
  iwlwifi: pcie: add rules to match Qu with Hr2

Matt Chen (1):
  iwlwifi: mvm: fix the return type for DSM functions 1 and 2

Matti Gottlieb (1):
  iwlwifi: Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.

Shaul Triebitz (1):
  iwlwifi: mvm: clear IN_D3 after wowlan status cmd

 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 25 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 65 ++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  7 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 25 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  6 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 10 +++
 drivers/net/wireless/intel/iwlwifi/queue/tx.c |  6 +-
 10 files changed, 125 insertions(+), 39 deletions(-)

-- 
2.29.2


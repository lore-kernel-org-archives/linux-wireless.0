Return-Path: <SRS0=sCwD=42=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CB2C10F27
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Mar 2020 07:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E6C520728
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Mar 2020 07:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgCIHQc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Mar 2020 03:16:32 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725796AbgCIHQc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Mar 2020 03:16:32 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1jBCeL-0007CP-Q9; Mon, 09 Mar 2020 09:16:30 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon,  9 Mar 2020 09:16:06 +0200
Message-Id: <20200309071619.670108-1-luca@coelho.fi>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/13] iwlwifi: updates intended for v5.7 2020-03-09
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the first set of patches intended for v5.7.  This time there are only some changes I made in the device configuration selection algorithms.

The changes are:

* Refactoring of the device selection algorithms;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.




Luca Coelho (13):
  iwlwifi: move the remaining 0x2526 configs to the new table
  iwlwifi: combine 9260 cfgs that only change names
  iwlwifi: add mac/rf types and 160MHz to the device tables
  iwlwifi: add GNSS differentiation to the device tables
  iwlwifi: add Pu/PnJ/Th device values to differentiate them
  iwlwifi: map 9461 and 9462 using RF type and RF ID
  iwlwifi: move TH1 devices to the new table
  iwlwifi: convert the 9260-1x1 device to use the new parameters
  iwlwifi: remove 9260 devices with 0x1010 and 0x1210 subsytem IDs
  iwlwifi: move pu devices to new table
  iwlwifi: move shared clock entries to new table
  iwlwifi: remove trans entries from COMMON 9260 macro
  iwlwifi: move AX200 devices to the new table

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  47 +--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c | 161 +-------
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  59 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 355 ++++++++----------
 4 files changed, 241 insertions(+), 381 deletions(-)

-- 
2.25.1


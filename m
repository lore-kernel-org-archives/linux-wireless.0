Return-Path: <SRS0=C9SN=YM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B58CA9EAB
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Oct 2019 10:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43C5021D7C
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Oct 2019 10:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfJSKDi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Oct 2019 06:03:38 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50500 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbfJSKDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Oct 2019 06:03:38 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iLlaC-0002jL-4f; Sat, 19 Oct 2019 13:03:36 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 19 Oct 2019 13:03:26 +0300
Message-Id: <20191019100331.21322-1-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/5] iwlwifi: fixes intended for 5.4 2019-10-19
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

This is my third patchset with fixes for v5.4.  This time I have five
important fixes.

The changes are:

* Fix a bogus queue number when allocation fails;
* A few PCI ID mapping fixes;
* A workaround to force power gating in integrated 22000 devices.

As usual, I'm pushing this to a pending branch, for kbuild bot.  As we
agreed, please apply them directly to wireless-drivers (after
reviewing, obviously). ;)

Cheers,
Luca.


Johannes Berg (1):
  iwlwifi: mvm: handle iwl_mvm_tvqm_enable_txq() error return

Luca Coelho (4):
  iwlwifi: pcie: fix PCI ID 0x2720 configs that should be soc
  iwlwifi: pcie: fix all 9460 entries for qnj
  iwlwifi: pcie: add workaround for power gating in integrated 22000
  iwlwifi: pcie: 0x2720 is qu and 0x30DC is not

 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 140 +++++++++++-------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 125 ++++++++--------
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  25 ++++
 5 files changed, 177 insertions(+), 119 deletions(-)

-- 
2.23.0


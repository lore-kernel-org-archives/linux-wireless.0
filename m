Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4501C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 11:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6A064DDA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 11:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBJL73 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Feb 2021 06:59:29 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:44946 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229761AbhBJL50 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Feb 2021 06:57:26 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l9o6o-0049Ur-Ad; Wed, 10 Feb 2021 13:56:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 10 Feb 2021 13:56:25 +0200
Message-Id: <20210210115637.276676-1-luca@coelho.fi>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 00/12] iwlwifi: updates intended for v5.12 2021-02-07
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

In v2:

* Rebased on top of "iwlwifi: add new cards for So and Qu family",
  which wasn't taken to v5.11.


Here's the fifth set of patches intended for v5.12.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Add some device IDs that got lost in a rebase;
* A bunch of fixes in the PPAG code;
* Some other small fixes, clean-ups and improvements.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: mvm: enhance a print in CSA flows
  iwlwifi: pcie: NULLify pointers after free

Johannes Berg (2):
  iwlwifi: pcie: don't disable interrupts for reg_lock
  iwlwifi: mvm: remove useless iwl_mvm_resume_d3() function

Luca Coelho (6):
  iwlwifi: pcie: add a few missing entries for So with Hr
  iwlwifi: acpi: fix PPAG table sizes
  iwlwifi: mvm: fix the type we use in the PPAG table validity checks
  iwlwifi: mvm: store PPAG enabled/disabled flag properly
  iwlwifi: mvm: send stored PPAG command instead of local
  iwlwifi: mvm: assign SAR table revision to the command later

Matti Gottlieb (1):
  iwlwifi: pcie: Change Ma device ID

Mordechay Goodstein (1):
  iwlwifi: when HW has rate offload don't look at control field

 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  7 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 45 ++++++++++++-------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 22 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 10 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  3 ++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 19 ++++----
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  5 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 22 ++++-----
 10 files changed, 80 insertions(+), 60 deletions(-)

-- 
2.30.0


Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5E1C4338F
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 18:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995AE60F9C
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 18:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhHBS7L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Aug 2021 14:59:11 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50994 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229899AbhHBS7K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Aug 2021 14:59:10 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mAd9N-001ySl-Lv; Mon, 02 Aug 2021 21:58:59 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon,  2 Aug 2021 21:58:46 +0300
Message-Id: <20210802185856.175567-1-luca@coelho.fi>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/10] iwlwifi: updates intended for v5.15 2021-08-02 part 3
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the third set of patches intended for v5.15.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Support for a new hardware family (Bz);
* Small fix in the scan code;
* Support a new version of a command in the FW API;
* Some other small fixes, clean-ups and improvements.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Ilan Peer (1):
  iwlwifi: mvm: Fix umac scan request probe parameters

Johannes Berg (8):
  iwlwifi: split off Bz devices into their own family
  iwlwifi: give Bz devices their own name
  iwlwifi: read MAC address from correct place on Bz
  iwlwifi: pcie: implement Bz device startup
  iwlwifi: implement Bz NMI behaviour
  iwlwifi: pcie: implement Bz reset flow
  iwlwifi: mvm: support new station key API
  iwlwifi: mvm: simplify __iwl_mvm_set_sta_key()

Mukesh Sisodiya (1):
  iwlwifi: yoyo: cleanup internal buffer allocation in D3

 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 74 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  2 +-
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  2 -
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |  6 +-
 .../net/wireless/intel/iwlwifi/fw/api/sta.h   |  8 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  | 22 ++++--
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |  3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 22 ++++--
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 10 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 57 ++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  8 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  | 42 +++++++++--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 38 +++++++---
 15 files changed, 216 insertions(+), 92 deletions(-)

-- 
2.32.0


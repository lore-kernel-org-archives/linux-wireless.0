Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC63C43612
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830892080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbeLNU3x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:29:53 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41924 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730709AbeLNU3w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5m-0002RG-4e; Fri, 14 Dec 2018 22:29:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:27 +0200
Message-Id: <20181214202945.32375-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/18] iwlwifi: updates intended for v4.21 2018-12-14
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fourth set of patches intended for v4.21.  It's the usual
development, with support for a new FW version, some small new
features, cleanups and bugfixes.

The changes are:

* Support for FW version 43 for 9000 and 22000 series;
* A couple of janitorial fixes from the community;
* More fixes in the 802.11ax code;
* Other cleanups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.
y

Colin Ian King (1):
  iwlwifi: mvm: fix spelling mistake "Recieved" -> "Received"

Emmanuel Grumbach (1):
  iwlwifi: mvm: set TWT responder capability bit in 11AX SoftAP mode

Gustavo A. R. Silva (1):
  iwlwifi: mvm: d3: use struct_size() in kzalloc()

Luca Coelho (3):
  [BUGFIXiwlwifi: make MVM and DVM depend on MAC80211
  iwlwifi: remove unused and wrong PHY_CFG_* macros
  iwlwifi: bump the API version to 43 for 9000 and 22000

Naftali Goldstein (1):
  iwlwifi: mvm: fix setting HE ppe FW config

Sara Sharon (8):
  iwlwifi: pcie: use iwl_tx_cmd_gen2 and not iwl_tx_cmd
  iwlwifi: mvm: remove dead code
  iwlwifi: mvm: remove pointless NULL assignment
  iwlwifi: mvm: cleanup iwl_mvm_tx_skb_non_sta
  iwlwifi: mvm: take station lock later in the code
  iwlwifi: pcie: lock txq a bit later in reclaim code
  iwlwifi: mvm: clean up SSN incrementation
  iwlwifi: dbg: add debug data to warning

Shahar S Matityahu (1):
  iwlwifi: wrt: add rt status and num of rx/tx fifos to dump

Shaul Triebitz (2):
  iwlwifi: split HE capabilities between AP and STA
  iwlwifi: mvm: handle RX no data notification

 drivers/net/wireless/intel/iwlwifi/Kconfig    |   4 +-
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   2 +-
 .../wireless/intel/iwlwifi/fw/api/config.h    |  13 +-
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |   5 +
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  49 +++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   1 +
 .../wireless/intel/iwlwifi/fw/error-dump.h    |   3 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 290 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   6 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 126 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  56 ++--
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |   3 +
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |   3 +-
 22 files changed, 427 insertions(+), 169 deletions(-)

-- 
2.19.2


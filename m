Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7B4C4361A
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Dec 2020 09:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7F922E00
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Dec 2020 09:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgLEJFs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Dec 2020 04:05:48 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34462 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727855AbgLEJDx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Dec 2020 04:03:53 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1klTSv-0039ST-Lk; Sat, 05 Dec 2020 11:02:54 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat,  5 Dec 2020 11:02:50 +0200
Message-Id: <20201205090252.337391-1-luca@coelho.fi>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/2] iwlwifi: updates intended for v5.11 2020-12-05
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for v5.11.  This time it's
only support for 6GHz and one dependency patch.

This is the work of several developers, I just aggregated everything
into a single patch.  The following developers were involved in either
initial development or bugfixes:

Haim Dreyfuss <haim.dreyfuss@intel.com>
Ilan Peer <ilan.peer@intel.com>
Tova Mussai <tova.mussai@intel.com>
Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Tali Levi Rovinsky <Tali.Levi-rovinsky@intel.com>
Avraham Stern <avraham.stern@intel.com>
Ayala Beker <ayala.beker@intel.com>

Some other developers may have been involved in a more indirect way.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Johannes Berg (1):
  iwlwifi: copy iwl_he_capa for modifications

Luca Coelho (1):
  iwlwifi: mvm: add support for 6GHz

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   3 +-
 .../wireless/intel/iwlwifi/fw/api/phy-ctxt.h  |   1 +
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   5 +
 .../wireless/intel/iwlwifi/iwl-eeprom-parse.h |  11 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 104 +++++-
 .../wireless/intel/iwlwifi/mvm/constants.h    |   1 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  17 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   2 +
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |  12 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 296 +++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  11 +
 14 files changed, 466 insertions(+), 10 deletions(-)

-- 
2.29.2


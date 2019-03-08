Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E1DC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 146EE20854
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbfCHKJB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:09:01 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41386 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725975AbfCHKJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:09:00 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2CR0-0006tZ-7l; Fri, 08 Mar 2019 12:08:58 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Mar 2019 12:08:41 +0200
Message-Id: <20190308100848.13188-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/7] iwlwifi: fixes intended for 5.1 2019-03-08
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the first patchset with fixes for 5.1.  If you can still
include them in a pull request during the merge window, fine, but it's
not necessary, they can as well go to the -rc series.

The changes are:

    * add some new PCI IDs (plus a struct name change they depend on);
    * fix crypto with new devices, namely 22560 and above;
    * a bunch of fixes (and a dependency) for the new debugging infra;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Ihab Zhaika (2):
  iwlwifi: rename structs to fit the new names
  iwlwifi: add new 0x2723/0x2080 card for 22000

Johannes Berg (1):
  iwlwifi: mvm: fix TX crypto on 22560+ devices

Shahar S Matityahu (4):
  iwlwifi: add sync_nmi to trans ops
  iwlwifi: dbg_ini: in case of region dump failure set memory to 0
  iwlwifi: dbg_ini: fix bad dump size calculation
  iwlwifi: use sync nmi in case of init flow failure

 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 12 ++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 34 +++-------
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |  1 -
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 12 ++--
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 64 +++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 41 +-----------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |  7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 13 ++--
 .../wireless/intel/iwlwifi/pcie/internal.h    |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  7 +-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  2 +-
 14 files changed, 54 insertions(+), 146 deletions(-)

-- 
2.20.1


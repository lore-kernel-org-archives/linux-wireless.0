Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89ADC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B2020855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbfA3Lzq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:46 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52706 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727878AbfA3Lzq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:46 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT2-0003x8-4C; Wed, 30 Jan 2019 13:55:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:11 +0200
Message-Id: <20190130115528.19922-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/17] iwlwifi: updates intended for v5.1 2019-01-30
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fifth set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Work on the new debugging infrastructure continues;
* Support for new FW version 44;
* A couple of new FW API changes;
* A bunch of fixes for static analyzer reported issues;
* General bugfixes;
* Other cleanups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: mvm: support new format for the beacon notification
  iwlwifi: mvm: fix AP mode in WEP

Luca Coelho (3):
  iwlwifi: bump FW API to 44 for 9000 and 22000 series
  iwlwifi: dvm: fix some fall through warnings
  iwlwifi: mvm: add fall through comments where needed

Sara Sharon (2):
  iwlwifi: mvm: simplify some return conditions
  iwlwifi: mvm: support CHANNEL_SWITCH_TIME_EVENT_CMD command

Shahar S Matityahu (9):
  iwlwifi dbg_ini: update ini structs doc
  iwlwifi: dbg_ini: fix iwl_fw_ini_buffer_location field enum bad naming
  iwlwifi: dbg_ini: give better naming to region struct fields
  iwlwifi: fix bad dma handling in page_mem dumping flow
  iwlwifi: differentiate between alive timeout and alive flow failure
  iwlwifi: dbg_ini: update ini triggers enum
  iwlwifi: dbg_ini: update max region id num to  support 64 regions
  iwlwifi: Fix pre operational dumping flows
  iwlwifi: fix fallthrough comment in iwl-dnt-cfg.c

YueHaibing (1):
  iwlwifi: mvm: remove duplicated include from ops.c

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   |   6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c |   3 +-
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 140 ++++++++---------
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   |  27 ++++
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    |  18 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 110 ++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   5 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |   3 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 -
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  13 ++
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c  |   3 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  91 +++++++----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 102 +++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   6 +-
 .../net/wireless/intel/iwlwifi/mvm/phy-ctxt.c |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 141 ++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   3 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   4 -
 28 files changed, 464 insertions(+), 275 deletions(-)

-- 
2.20.1


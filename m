Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E80C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 622FB20657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 622FB20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbeKBUOx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:14:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33966 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726008AbeKBUOx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:14:53 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJ7-0007MW-NZ; Fri, 02 Nov 2018 13:08:06 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:45 +0200
Message-Id: <20181102110800.29817-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/15] iwlwifi: updates intended for v4.21 2018-11-02
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the first set of patches intended for v4.21.  It's the usual
development, with some small new feauters, cleanups and bugfixes.

The changes are:

* PCI IDs for some new 9000-series cards;
* Improve antenna usage on connection problems;
* Some improvements in the debugging code;
* Other clean-ups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Andrei Otcheretianski (1):
  iwlwifi: mvm: Send non offchannel traffic via AP sta

Avraham Stern (2):
  iwlwifi: mvm: switch management tx antenna only on tx failure
  iwlwifi: mvm: toggle tx antenna if tx fails during connection
    establishment

Emmanuel Grumbach (1):
  iwlwifi: mvm: remove unused conversion table

Ihab Zhaika (1):
  iwlwifi: add new cards for 9560, 9462, 9461 and killer series

Johannes Berg (2):
  iwlwifi: mvm: synchronize TID queue removal
  iwlwifi: mvm: remove queue_info_lock

Naftali Goldstein (2):
  iwlwifi: fw: do not set sgi bits for HE connection
  iwlwifi: mvm: add description to a few generic assert numbers

Sara Sharon (4):
  iwlwifi: pcie: don't reset TXQ write pointer
  iwlwifi: dbg: avoid passing trigger around
  iwlwifi: dbg: use helper to check if debug type is set
  iwlwifi: fw: use helper to determine whether to dump paging

Shahar S Matityahu (1):
  iwlwifi: trans: Clear persistence bit when starting the FW

Tova Mussai (1):
  iwlwifi: mvm: enable low latency for soft ap

 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 109 +++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  18 ++-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |   7 ++
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   2 +-
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  |  14 +--
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  27 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  17 +--
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 114 ++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  83 +++++++++----
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  54 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  50 ++++++++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  16 ++-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   3 +-
 20 files changed, 313 insertions(+), 240 deletions(-)

-- 
2.19.1


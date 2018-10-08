Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81754C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 747D92087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 747D92087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbeJHP2N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:13 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56276 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726096AbeJHP2N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:13 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9QjU-0003w6-9f; Mon, 08 Oct 2018 11:17:40 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:17 +0300
Message-Id: <20181008081735.3401-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/18] iwlwifi: updates intended for v4.20 2018-10-08
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the seventh set of patches intended for v4.20.  It's the usual
development, the majority of the changes are cleanups in the queue
lifetime management code by Johannes, and also some improvements,
debugging and bugfixes again.

The changes are:

* Support for a new scan type;
* Clean-up in the queue handling code;
* A few bug fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Ayala Beker (2):
  iwlwifi: mvm: introduce a new fragmented scan type: fast balance
  iwlwifi: mvm: use fast balance scan in case of DCM mode with P2P GO

Johannes Berg (11):
  iwlwifi: mvm: give TX queue info struct a name
  iwlwifi: mvm: move queue management into sta.c
  iwlwifi: mvm: remove per-queue hw refcount
  iwlwifi: mvm: clean up iteration in iwl_mvm_inactivity_check()
  iwlwifi: mvm: move queue reconfiguration into new function
  iwlwifi: mvm: reconfigure queues during inactivity check
  iwlwifi: mvm: remove RECONFIGURING queue state
  iwlwifi: mvm: make queue TID change more explicit
  iwlwifi: mvm: make iwl_mvm_scd_queue_redirect() static
  iwlwifi: mvm: move iwl_mvm_sta_alloc_queue() down
  iwlwifi: mvm: kill INACTIVE queue state

Sara Sharon (3):
  iwlwifi: mvm: don't send keys when entering D3
  iwlwifi: pcie: don't pad AMSDU packets
  iwlwifi: trace: change trace to trace one TB at a time

Shahar S Matityahu (2):
  iwlwifi: dump debug data before stop device
  iwlwifi: mvm: move rt status check to the start of the resume flow

 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  27 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   1 +
 .../intel/iwlwifi/iwl-devtrace-data.h         |  30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  64 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  54 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 115 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 837 +++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   8 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  34 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 420 +--------
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  28 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  29 +-
 13 files changed, 825 insertions(+), 831 deletions(-)

-- 
2.19.0


Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B643C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5872A2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5872A2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbeJASru (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:47:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54296 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728999AbeJASru (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:47:50 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1m-0006wq-KF; Mon, 01 Oct 2018 15:10:19 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:09:54 +0300
Message-Id: <20181001121010.29684-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/16] iwlwifi: updates intended for v4.20 2018-10-01
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the sixth set of patches intended for v4.20.  It's the usual
development, some improvements, debugging and bugfixes.

The changes are:

* Bumped the FW API version supported after the last API change for
  this release;
* Debugging improvements;
* A few bug fixes;
* Other small improvements, cleanups and fixes.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.



Haim Dreyfuss (1):
  iwlwifi: mvm Support new MCC update response

Johannes Berg (6):
  iwlwifi: pcie gen2: check iwl_pcie_gen2_set_tb() return value
  iwlwifi: add fall through comment
  iwlwifi: pcie: check iwl_pcie_txq_build_tfd() return value
  iwlwifi: bump firmware API version for 9000 and 22000 series devices
  iwlwifi: mvm: decode HE information for MU (without ext info)
  iwlwifi: mvm: show more HE radiotap data for TB PPDUs

Naftali Goldstein (1):
  iwlwifi: nvm: get num of hw addresses from firmware

Sara Sharon (3):
  iwlwifi: dbg: make iwl_fw_dbg_no_trig_window trigger agnostic
  iwlwifi: dbg: decrement occurrences for all triggers
  iwlwifi: dbg: make trigger functions type agnostic

Shahar S Matityahu (3):
  iwlwifi: add dump collection in case alive flow fails
  iwlwifi: runtime: add send host command op to firmware runtime op
    struct
  iwlwifi: add debugfs to send host command

Shaul Triebitz (1):
  iwlwifi: pcie: avoid empty free RB queue

Yisheng Xie (1):
  iwlwifi: mvm: use match_string() helper

 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  2 +-
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   | 81 ++++++++-----------
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  8 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 64 ++++++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 15 ++--
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   | 64 +++++++++++++++
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  7 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  1 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 10 ++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 13 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c  | 25 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 17 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 70 ++++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 32 +++++---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  2 +
 20 files changed, 269 insertions(+), 152 deletions(-)

-- 
2.19.0


Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E20DC282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44EFB2084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfAUHue (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:34 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727882AbfAUHue (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:34 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULn-0006cr-T4; Mon, 21 Jan 2019 09:50:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:10 +0200
Message-Id: <20190121075026.25059-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/16] iwlwifi: updates intended for v4.21 2019-01-21
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for v5.1.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Some updates in the documentation;
* A bunch of fixes for issues found with static analyzers;
* A couple of janitorial fixes from the community;
* Some fixes in P2P;
* Support for mac80211 AMSDU handling;
* Other cleanups and small fixes;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Colin Ian King (1):
  iwlwifi: fix spelling mistake "registrating" -> "registering"

Ilan Peer (3):
  iwlwifi: mvm: Flush transmit queues on P2P Device ROC done
  iwlwifi: mvm: Set Tx rate and flags when there is not station
  iwlwifi: mvm: Do not set RTS/CTS protection for P2P Device MAC

Johannes Berg (2):
  iwlwifi: fw api: remove unused/deprecated filter status
  iwlwifi: fw api: document WoWLAN patterns command

Liad Kaufman (4):
  iwlwifi: update hcmds documentation
  iwlwifi: mvm: make num_active_macs unsigned
  iwlwifi: tighten boundary checks
  iwlwifi: memcpy from dev_cmd and not dev_cmd->hdr

Luca Coelho (1):
  iwlwifi: mvm: fix values in the table example

Mordechay Goodstein (2):
  iwlwifi: mvm: avoid possible access out of array.
  iwlwifi: avoid access out of memory allocated

Sara Sharon (2):
  iwlwifi: mvm: support mac80211 AMSDU
  iwlwifi: mvm: bring back mvm GSO code

YueHaibing (1):
  iwlwifi: use kmemdup in iwl_parse_nvm_mcc_info()

 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  2 +-
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  8 +-
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    | 10 +++
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  4 -
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  8 ++
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  4 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 -
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 33 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 14 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   | 26 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c   |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 19 ++--
 .../wireless/intel/iwlwifi/mvm/time-event.c   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 90 +++++++++++--------
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 10 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  3 +-
 17 files changed, 173 insertions(+), 68 deletions(-)

-- 
2.20.1


Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9A7C48BDF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jun 2021 08:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E696961164
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jun 2021 08:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhFRIFD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jun 2021 04:05:03 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:48048 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232749AbhFRIDm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jun 2021 04:03:42 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lu9RJ-001YIf-Vl; Fri, 18 Jun 2021 11:01:23 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Fri, 18 Jun 2021 11:01:11 +0300
Message-Id: <20210618080121.588233-1-luca@coelho.fi>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/10] iwlwifi: updates intended for v5.14 2021-06-18
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the thjird set of patches intended for v5.14.  It's the usual
development, new features, cleanups and bugfixes.

The changes are:

* Some fixes in IML (image loader) DMA handling;
* Fixes in WoWLAN;
* Some other small fixes, clean-ups and improvements.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.



Emmanuel Grumbach (2):
  iwlwifi: mvm: support LONG_GROUP for WOWLAN_GET_STATUSES version
  iwlwifi: mvm: introduce iwl_proto_offload_cmd_v4

Ilan Peer (1):
  iwlwifi: mvm: Explicitly stop session protection before unbinding

Johannes Berg (4):
  iwlwifi: pcie: free IML DMA memory allocation
  iwlwifi: pcie: fix context info freeing
  iwlwifi: mvm: fill phy_data.d1 for no-data RX
  iwlwifi: pcie: free some DMA memory earlier

Luca Coelho (1):
  iwlwifi: fix NUM_IWL_UCODE_TLV_* definitions to avoid sparse errors

Naftali Goldstein (2):
  iwlwifi: mvm: don't request mac80211 to disable/enable sta's queues
  iwlwifi: support ver 6 of WOWLAN_CONFIGURATION and ver 10 of
    WOWLAN_GET_STATUSES

 .../net/wireless/intel/iwlwifi/fw/api/d3.h    | 28 +++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h  | 14 +++---
 .../intel/iwlwifi/iwl-context-info-gen3.h     |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 44 ++++++++++++-------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  1 -
 .../wireless/intel/iwlwifi/mvm/offloading.c   | 26 ++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 10 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  8 +++-
 .../wireless/intel/iwlwifi/mvm/time-event.c   | 41 ++++++++++++-----
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 28 ++++++++----
 .../wireless/intel/iwlwifi/pcie/internal.h    |  3 ++
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  7 ++-
 12 files changed, 148 insertions(+), 66 deletions(-)

-- 
2.32.0


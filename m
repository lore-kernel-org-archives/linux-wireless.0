Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBF1C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 459702172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 459702172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbeI1Oow (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:44:52 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53362 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727389AbeI1Oow (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:44:52 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2R-0004tY-S9; Fri, 28 Sep 2018 11:22:16 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:21:52 +0300
Message-Id: <20180928082210.20762-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/18] wlwifi: updates intended for v4.20 2018-09-28
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the fifth set of patches intended for v4.20.  It's the usual
development, mostly focused on radiotap HE, debugging and bugfixes.

The changes are:

* Fix for a race condition that caused the FW to crash;
* HE radiotap cleanup and improvements;
* Reorder channel optimization for scans;
* Some cleanups in preparation for a new implementation;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

I still have a bunch of pending patches in our internal tree, so I'll
try to send one or two more patchsets before sending the pull-request.

Please review.

Cheers,
Luca.


Ayala Beker (1):
  iwlwifi: mvm: allow channel reorder optimization during scan

Emmanuel Grumbach (1):
  iwlwifi: mvm: clear HW_RESTART_REQUESTED when stopping the interface

Johannes Berg (10):
  iwlwifi: mvm: remove unnecessary overload variable
  iwlwifi: mvm: minor cleanups to HE radiotap code
  iwlwifi: mvm: put HE SIG-B symbols/users data correctly
  iwlwifi: mvm: pull some he_phy_data decoding into a separate function
  iwlwifi: mvm: clean up HE radiotap RU allocation parsing
  iwlwifi: mvm: move HE-MU LTF_NUM parsing to he_phy_data parsing
  iwlwifi: mvm: add TXOP to HE radiotap data
  iwlwifi: mvm: add LDPC-XSYM to HE radiotap data
  iwlwifi: mvm: add more information to HE radiotap
  iwlwifi: mvm: set max TX/RX A-MPDU subframes to HE limit

Luca Coelho (1):
  iwlwifi: mvm: check for n_profiles validity in EWRD ACPI

Sara Sharon (5):
  iwlwifi: dbg: move debug data to a struct
  iwlwifi: dbg: refactor dump code to improve readability
  iwlwifi: dbg: split iwl_fw_error_dump to two functions
  iwlwifi: dbg: dump memory in a helper function
  iwlwifi: dbg: group trigger condition to helper function

 .../net/wireless/intel/iwlwifi/fw/api/scan.h  |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 347 ++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  30 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  41 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  76 ++--
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  12 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  42 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 377 ++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |   3 +
 .../wireless/intel/iwlwifi/mvm/time-event.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  15 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  16 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   2 +-
 17 files changed, 530 insertions(+), 512 deletions(-)

-- 
2.19.0


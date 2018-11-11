Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E44C43610
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 831612080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 831612080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbeKLF5J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:09 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35904 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730957AbeKLF5I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:08 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1B-0000JG-1Q; Sun, 11 Nov 2018 22:07:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:16 +0200
Message-Id: <20181111200732.8159-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/16]  iwlwifi: updates intended for v4.21 2018-11-11
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's the second set of patches intended for v4.21.  It's the usual
development, with some small new features, cleanups and bugfixes.

The changes are:

* New FW debugging infrastructure;
* Some more work on 802.11ax;
* Improve support for multiple RF modules with 22000 devices;
* Remove an unused FW parameter;
* Other debugging improvements;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: mvm: remove assignment of the reciprocal
  iwlwifi: mvm: add support for TWT capabilities

Lior Cohen (2):
  iwlwifi: add fw dump upon RT ucode start failure
  iwlwifi: add debugfs file to read fw debug data recording

Luca Coelho (1):
  iwlwifi: fix cfg structs for 22000 with different RF modules

Sara Sharon (8):
  iwlwifi: dbg: don't limit dump decisions to all or monitor
  iwlwifi: dbg: split fifos dump
  iwlwifi: fw: add FW API of new TLV infrastructure
  iwlwifi: trans: parse and store debug ini TLVs
  iwlwifi: trans: support loading ini TLVs from external file
  iwlwifi: dbg: disable triggers for ini
  iwlwifi: dbg: add apply point logic
  iwlwifi: fw: support API change to debug TLVs

Shaul Triebitz (3):
  iwlwifi: mvm: set MAC_FILTER_IN_11AX in AP mode
  iwlwifi: mvm: send the STA_HE_CTXT command in AP mode
  iwlwifi: mvm: set HW capability VHT_EXT_NSS_BW

 drivers/net/wireless/intel/iwlwifi/Makefile   |   1 +
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   1 -
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 401 ++++++++++++++++++
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   |  39 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 277 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  22 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   7 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  26 ++
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   3 +
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 230 ++++++++++
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.h  |  87 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  24 +-
 .../wireless/intel/iwlwifi/iwl-modparams.h    |   2 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   5 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  39 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   1 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   2 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  44 ++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 213 +++++++++-
 21 files changed, 1374 insertions(+), 77 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h

-- 
2.19.1


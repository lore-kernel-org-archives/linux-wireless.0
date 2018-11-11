Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933D4C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AE2620866
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AE2620866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbeKKUOo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 15:14:44 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35796 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727344AbeKKUOo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 15:14:44 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLmwq-00007G-ME; Sun, 11 Nov 2018 12:26:33 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 12:26:22 +0200
Message-Id: <20181111102627.18461-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/5] iwlwifi: fixes intended for 4.20 2018-11-11
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is my first batch of fixes inteded for 4.20.

These are the fixes:

* fix statistics collection with older FWs (was causing issues on userspace);
* fix a problem with regulatory after FW restart (bugzilla fix)
* fix a problem related to SAR with buggy BIOSes;
* fix geographic SAR parsing of ACPI entries;
* fix a memory leak in debug code;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Emmanuel Grumbach (2):
  iwlwifi: mvm: support sta_statistics() even on older firmware
  iwlwifi: mvm: fix regulatory domain update when the firmware starts

Luca Coelho (1):
  iwlwifi: mvm: don't use SAR Geo if basic SAR is not used

Matt Chen (1):
  iwlwifi: fix wrong WGDS_WIFI_DATA_SIZE

Shahar S Matityahu (1):
  iwlwifi: fix D3 debug data buffer memory leak

 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  4 ++-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  6 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 33 ++++++++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c  |  5 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 ++
 6 files changed, 42 insertions(+), 20 deletions(-)

-- 
2.19.1


Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12672C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8512070D
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbfCVMrx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:47:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46012 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733117AbfCVMrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 08:47:51 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7JaO-0000ZZ-UA; Fri, 22 Mar 2019 14:47:49 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 14:47:41 +0200
Message-Id: <20190322124744.17924-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/3] iwlwifi: fixes intended for 5.1 2019-03-22
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the second patchset with fixes for 5.1.

The changes are:

* fix for a potential deadlock in the TX path;
* a fix for offloaded rate-control;
* support new PCI HW IDs which use a new FW;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Johannes Berg (2):
  iwlwifi: mvm: avoid possible deadlock in TX path
  iwlwifi: mvm: update offloaded rate control on changes

Luca Coelho (1):
  iwlwifi: add support for quz firmwares

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 18 ++++++++++++++++--
 .../net/wireless/intel/iwlwifi/iwl-config.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h   |  1 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c  |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   |  2 ++
 .../net/wireless/intel/iwlwifi/pcie/trans.c    |  4 ++++
 6 files changed, 31 insertions(+), 2 deletions(-)

-- 
2.20.1


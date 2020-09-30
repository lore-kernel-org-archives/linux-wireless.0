Return-Path: <SRS0=j1Uz=DH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C5CC4741F
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Sep 2020 16:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B63F420759
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Sep 2020 16:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgI3QUJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Sep 2020 12:20:09 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53424 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731218AbgI3QUI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Sep 2020 12:20:08 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kNepp-002MPc-L4; Wed, 30 Sep 2020 19:20:06 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 30 Sep 2020 19:19:51 +0300
Message-Id: <iwlwifi.20200930191738.71aacc1a0358.Ie53f7ab07b42e6a5223f33e201b0f862ebda8986@changeid>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930161959.983283-1-luca@coelho.fi>
References: <20200930161959.983283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/12] iwlwifi: mvm: clear all scan UIDs
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ayala Beker <ayala.beker@intel.com>

In case of nic restart flow is called in the middle of scan abort
flow, aborted scan UIDs might not be cleared.

Fix it and clean these UIDs as well.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 02e3b70b36dd..05e0686ff4e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2628,6 +2628,15 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 			mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
 			mvm->scan_uid_status[uid] = 0;
 		}
+		uid = iwl_mvm_scan_uid_by_status(mvm,
+						 IWL_MVM_SCAN_STOPPING_REGULAR);
+		if (uid >= 0)
+			mvm->scan_uid_status[uid] = 0;
+
+		uid = iwl_mvm_scan_uid_by_status(mvm,
+						 IWL_MVM_SCAN_STOPPING_SCHED);
+		if (uid >= 0)
+			mvm->scan_uid_status[uid] = 0;
 
 		/* We shouldn't have any UIDs still set.  Loop over all the
 		 * UIDs to make sure there's nothing left there and warn if
-- 
2.28.0


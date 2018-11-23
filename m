Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF36C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB0E206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAB0E206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503788AbeKWWKi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38304 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409641AbeKWWKh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bf-0008GU-Ug; Fri, 23 Nov 2018 13:26:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:25 +0200
Message-Id: <20181123112631.29360-10-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/15] iwlwifi: mvm: force TCM re-evaluation on TCM resume
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

When traffic load is not low or low latency is active, TCM schedules
re-evaluation work so in case traffic stops TCM will detect that
traffic load has become low or that low latency is no longer active.
However, if TCM is paused when the re-evaluation work runs, it does
not re-evaluate and the re-evaluation work is no longer scheduled.
As a result, TCM will not indicate that low latency is no longer
active or that traffic load is low when traffic stops.

Fix this by forcing TCM re-evaluation when TCM is resumed in case
low latency is active or traffic load is not low.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 3761fbfff292..5ad352ef8e9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1378,6 +1378,7 @@ void iwl_mvm_pause_tcm(struct iwl_mvm *mvm, bool with_cancel)
 void iwl_mvm_resume_tcm(struct iwl_mvm *mvm)
 {
 	int mac;
+	bool low_latency = false;
 
 	spin_lock_bh(&mvm->tcm.lock);
 	mvm->tcm.ts = jiffies;
@@ -1389,10 +1390,23 @@ void iwl_mvm_resume_tcm(struct iwl_mvm *mvm)
 		memset(&mdata->tx.pkts, 0, sizeof(mdata->tx.pkts));
 		memset(&mdata->rx.airtime, 0, sizeof(mdata->rx.airtime));
 		memset(&mdata->tx.airtime, 0, sizeof(mdata->tx.airtime));
+
+		if (mvm->tcm.result.low_latency[mac])
+			low_latency = true;
 	}
 	/* The TCM data needs to be reset before "paused" flag changes */
 	smp_mb();
 	mvm->tcm.paused = false;
+
+	/*
+	 * if the current load is not low or low latency is active, force
+	 * re-evaluation to cover the case of no traffic.
+	 */
+	if (mvm->tcm.result.global_load > IWL_MVM_TRAFFIC_LOW)
+		schedule_delayed_work(&mvm->tcm.work, MVM_TCM_PERIOD);
+	else if (low_latency)
+		schedule_delayed_work(&mvm->tcm.work, MVM_LL_PERIOD);
+
 	spin_unlock_bh(&mvm->tcm.lock);
 }
 
-- 
2.19.1


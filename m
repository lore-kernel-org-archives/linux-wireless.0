Return-Path: <SRS0=g1I5=CU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA377C433E2
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 17:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9000821D79
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 17:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgIKRyQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Sep 2020 13:54:16 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50242 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725945AbgIKRxF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Sep 2020 13:53:05 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2020 13:53:04 EDT
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kGn6L-0028eU-Vk; Fri, 11 Sep 2020 20:44:46 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 11 Sep 2020 20:44:33 +0300
Message-Id: <iwlwifi.20200911204056.8a8481c60663.I353ab6f1bc04c7fdf873dead59f483454e2425ba@changeid>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911174439.163225-1-luca@coelho.fi>
References: <20200911174439.163225-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/11] iwlwifi: sta: defer ADDBA transmit in case reclaimed SN != next SN
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

This avoids cases that we have a lot of packets in the queue and until we
are able to transmit SSN packet the other side sends DELBA due to timeout.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9e124755a3ce..fc45ef4f6951 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2863,7 +2863,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		ret = IEEE80211_AMPDU_TX_START_IMMEDIATE;
 	} else {
 		tid_data->state = IWL_EMPTYING_HW_QUEUE_ADDBA;
-		ret = 0;
+		ret = IEEE80211_AMPDU_TX_START_DELAY_ADDBA;
 	}
 
 out:
-- 
2.28.0


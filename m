Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C800C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 06:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE1E920652
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 06:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE1E920652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbeJMOWO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 10:22:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:57996 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726312AbeJMOWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 10:22:13 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gBDgj-0008TE-0y; Sat, 13 Oct 2018 09:46:13 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
Date:   Sat, 13 Oct 2018 09:46:08 +0300
Message-Id: <20181013064608.31952-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH] iwlwifi: mvm: check return value of rs_rate_from_ucode_rate()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

The rs_rate_from_ucode_rate() function may return -EINVAL if the rate
is invalid, but none of the callsites check for the error, potentially
making us access arrays with index IWL_RATE_INVALID, which is larger
than the arrays, causing an out-of-bounds access.  This will trigger
KASAN warnings, such as the one reported in the bugzilla issue
mentioned below.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=200659

Cc: stable@vger.kernel.org
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 24 ++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 2c75f51a04e4..089972280daa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1239,7 +1239,11 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	rs_rate_from_ucode_rate(tx_resp_hwrate, info->band, &tx_resp_rate);
+	if (rs_rate_from_ucode_rate(tx_resp_hwrate, info->band,
+				    &tx_resp_rate)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* Disable last tx check if we are debugging with fixed rate but
@@ -1290,7 +1294,10 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	 */
 	table = &lq_sta->lq;
 	lq_hwrate = le32_to_cpu(table->rs_table[0]);
-	rs_rate_from_ucode_rate(lq_hwrate, info->band, &lq_rate);
+	if (rs_rate_from_ucode_rate(lq_hwrate, info->band, &lq_rate)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 
 	/* Here we actually compare this rate to the latest LQ command */
 	if (lq_color != LQ_FLAG_COLOR_GET(table->flags)) {
@@ -1392,8 +1399,12 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		/* Collect data for each rate used during failed TX attempts */
 		for (i = 0; i <= retries; ++i) {
 			lq_hwrate = le32_to_cpu(table->rs_table[i]);
-			rs_rate_from_ucode_rate(lq_hwrate, info->band,
-						&lq_rate);
+			if (rs_rate_from_ucode_rate(lq_hwrate, info->band,
+						    &lq_rate)) {
+				WARN_ON_ONCE(1);
+				return;
+			}
+
 			/*
 			 * Only collect stats if retried rate is in the same RS
 			 * table as active/search.
@@ -3260,7 +3271,10 @@ static void rs_build_rates_table_from_fixed(struct iwl_mvm *mvm,
 	for (i = 0; i < num_rates; i++)
 		lq_cmd->rs_table[i] = ucode_rate_le32;
 
-	rs_rate_from_ucode_rate(ucode_rate, band, &rate);
+	if (rs_rate_from_ucode_rate(ucode_rate, band, &rate)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 
 	if (is_mimo(&rate))
 		lq_cmd->mimo_delim = num_rates - 1;
-- 
2.19.1


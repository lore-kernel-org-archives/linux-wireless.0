Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC5BC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36C12084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B36C12084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbeJASs1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:48:27 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729111AbeJASs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:48:27 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1x-0006wq-8t; Mon, 01 Oct 2018 15:10:29 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:07 +0300
Message-Id: <20181001121010.29684-14-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/16] iwlwifi: dbg: make iwl_fw_dbg_no_trig_window trigger agnostic
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

As preparation for new trigger format, make the function
agnostic to the trigger fomat. Instead it gets the relevant
parameters - id and delay.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 0f09a2128ad2..bee7a938a721 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -154,12 +154,9 @@ iwl_fw_dbg_trigger_stop_conf_match(struct iwl_fw_runtime *fwrt,
 }
 
 static inline bool
-iwl_fw_dbg_no_trig_window(struct iwl_fw_runtime *fwrt,
-			  struct iwl_fw_dbg_trigger_tlv *trig)
+iwl_fw_dbg_no_trig_window(struct iwl_fw_runtime *fwrt, u32 id, u32 dis_ms)
 {
-	unsigned long wind_jiff =
-		msecs_to_jiffies(le16_to_cpu(trig->trig_dis_ms));
-	u32 id = le32_to_cpu(trig->id);
+	unsigned long wind_jiff = msecs_to_jiffies(dis_ms);
 
 	/* If this is the first event checked, jump to update start ts */
 	if (fwrt->dump.non_collect_ts_start[id] &&
@@ -179,7 +176,8 @@ iwl_fw_dbg_trigger_check_stop(struct iwl_fw_runtime *fwrt,
 	if (wdev && !iwl_fw_dbg_trigger_vif_match(trig, wdev))
 		return false;
 
-	if (iwl_fw_dbg_no_trig_window(fwrt, trig)) {
+	if (iwl_fw_dbg_no_trig_window(fwrt, le32_to_cpu(trig->id),
+				      le16_to_cpu(trig->trig_dis_ms))) {
 		IWL_WARN(fwrt, "Trigger %d occurred while no-collect window.\n",
 			 trig->id);
 		return false;
-- 
2.19.0


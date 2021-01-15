Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833BEC433DB
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Jan 2021 11:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C1BC23730
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Jan 2021 11:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbhAOLcE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Jan 2021 06:32:04 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:40398 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725910AbhAOLcE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jan 2021 06:32:04 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l0Mvj-003hBK-Fu; Fri, 15 Jan 2021 13:06:11 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Jan 2021 13:05:57 +0200
Message-Id: <iwlwifi.20210115130253.621c948b1fad.I3ee9f4bc4e74a0c9125d42fb7c35cd80df4698a1@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115110558.1248847-1-luca@coelho.fi>
References: <20210115110558.1248847-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH for v5.11 11/12] iwlwifi: pcie: use jiffies for memory read spin time limit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to use ktime_get() since we don't need any better
precision than jiffies, and since we no longer disable interrupts
around this code (when grabbing NIC access), jiffies will work fine.
Use jiffies instead of ktime_get().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 285e0d586021..e3760c41b31e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2107,7 +2107,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 
 	while (offs < dwords) {
 		/* limit the time we spin here under lock to 1/2s */
-		ktime_t timeout = ktime_add_us(ktime_get(), 500 * USEC_PER_MSEC);
+		unsigned long end = jiffies + HZ / 2;
 
 		if (iwl_trans_grab_nic_access(trans, &flags)) {
 			iwl_write32(trans, HBUS_TARG_MEM_RADDR,
@@ -2118,11 +2118,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 							HBUS_TARG_MEM_RDAT);
 				offs++;
 
-				/* calling ktime_get is expensive so
-				 * do it once in 128 reads
-				 */
-				if (offs % 128 == 0 && ktime_after(ktime_get(),
-								   timeout))
+				if (time_after(jiffies, end))
 					break;
 			}
 			iwl_trans_release_nic_access(trans, &flags);
-- 
2.29.2


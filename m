Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE73C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15BCB218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfCVOAY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:24 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46270 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727994AbfCVOAY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:24 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khf-0000bK-4E; Fri, 22 Mar 2019 15:59:23 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:52 +0200
Message-Id: <20190322135903.10631-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/24] iwlwifi: mvm: fix pointer reference when setting HE QAM thres
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

Pointer referencing when setting HE QAM thresholds (when nominal
packet padding bit is on) caused kernel crash due to bad
referencing. Fix that.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1cad9238e45a..ed866deddb5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2339,16 +2339,18 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 
 		/* Set the PPE thresholds accordingly */
 		if (low_th >= 0 && high_th >= 0) {
-			u8 ***pkt_ext_qam =
-				(void *)sta_ctxt_cmd.pkt_ext.pkt_ext_qam_th;
+			struct iwl_he_pkt_ext *pkt_ext =
+				(struct iwl_he_pkt_ext *)&sta_ctxt_cmd.pkt_ext;
 
 			for (i = 0; i < MAX_HE_SUPP_NSS; i++) {
 				u8 bw;
 
 				for (bw = 0; bw < MAX_HE_CHANNEL_BW_INDX;
 				     bw++) {
-					pkt_ext_qam[i][bw][0] = low_th;
-					pkt_ext_qam[i][bw][1] = high_th;
+					pkt_ext->pkt_ext_qam_th[i][bw][0] =
+						low_th;
+					pkt_ext->pkt_ext_qam_th[i][bw][1] =
+						high_th;
 				}
 			}
 
-- 
2.20.1


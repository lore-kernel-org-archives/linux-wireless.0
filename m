Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3822C282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95B992146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfA0KTj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:39 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51386 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726816AbfA0KTi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:38 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXI-0001vC-W5; Sun, 27 Jan 2019 12:19:33 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:00 +0200
Message-Id: <20190127101908.6428-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/21] iwlwifi: mvm: document monitor mode reorder buffer bypass
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The reorder buffer is bypassed because the firmware won't have
any BA sessions, document this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7b6f4585fec9..9fde322904f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -658,6 +658,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	 * This also covers the case of receiving a Block Ack Request
 	 * outside a BA session; we'll pass it to mac80211 and that
 	 * then sends a delBA action frame.
+	 * This also covers pure monitor mode, in which case we won't
+	 * have any BA sessions.
 	 */
 	if (baid == IWL_RX_REORDER_DATA_INVALID_BAID)
 		return false;
-- 
2.20.1


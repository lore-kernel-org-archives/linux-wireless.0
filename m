Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295ADC3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 07:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A4662053B
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 07:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfICHh5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 03:37:57 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:40334 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725888AbfICHh5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 03:37:57 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1i53Ng-0004Cd-QA; Tue, 03 Sep 2019 10:37:37 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue,  3 Sep 2019 10:37:08 +0300
Message-Id: <20190903073714.32278-16-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190903073714.32278-1-luca@coelho.fi>
References: <20190903073714.32278-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/21] iwlwifi: mvm: don't log un-decrypted frames
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Sometimes the firmware won't be able to decrypt frames
because the keys were not installed yet or other scenarios.
The firmware will soon stop dropping multicast frames when
MAC_FILTER_ACCEPT_GRP is not set. The firmware will simply
always pass multicast frame in.

In order to avoid logging any such frame coming in when we
don't have the keys, drop the print.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c48d6fb16408..77b03b757193 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -377,8 +377,16 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 		stats->flag |= RX_FLAG_DECRYPTED;
 		return 0;
 	default:
-		/* Expected in monitor (not having the keys) */
-		if (!mvm->monitor_on)
+		/*
+		 * Sometimes we can get frames that were not decrypted
+		 * because the firmware didn't have the keys yet. This can
+		 * happen after connection where we can get multicast frames
+		 * before the GTK is installed.
+		 * Silently drop those frames.
+		 * Also drop un-decrypted frames in monitor mode.
+		 */
+		if (!is_multicast_ether_addr(hdr->addr1) &&
+		    !mvm->monitor_on && net_ratelimit())
 			IWL_ERR(mvm, "Unhandled alg: 0x%x\n", status);
 	}
 
-- 
2.23.0.rc1


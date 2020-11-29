Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7752EC3E8C5
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Nov 2020 13:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A4F20719
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Nov 2020 13:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgK2NRP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 29 Nov 2020 08:17:15 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:33488 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727073AbgK2NRP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Nov 2020 08:17:15 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kjMXV-0035gF-Kf; Sun, 29 Nov 2020 15:14:53 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 29 Nov 2020 15:14:42 +0200
Message-Id: <iwlwifi.20201129151117.9c66af9f5dda.I86867c273bb3d00e31e13857d4a013f5503c17ea@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201129131442.1857561-1-luca@coelho.fi>
References: <20201129131442.1857561-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/12] iwlwifi: mvm: set station HE capabilities before authentication
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

Some 11ax APs send the authentication response frame as a HE frame.
Since the MAC_FILTER_IN_11AX flag is only set on association, the
frame is being filtered out and the association fails.
Fix it by setting the station HE capabilities before authentication.
This will result in setting the MAC_FILTER_IN_11AX flag for HE
stations before authentication and filtering in the authentication
response.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 688c1125e67b..62e884f3e29e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3127,6 +3127,9 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 			goto out_unlock;
 		}
 
+		if (vif->type == NL80211_IFTYPE_STATION)
+			vif->bss_conf.he_support = sta->he_cap.has_he;
+
 		if (sta->tdls &&
 		    (vif->p2p ||
 		     iwl_mvm_tdls_sta_count(mvm, NULL) ==
-- 
2.29.2


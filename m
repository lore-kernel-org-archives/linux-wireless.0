Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7083EC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D5BA218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfAYUWC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:22:02 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50920 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfAYUWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:22:02 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qs-00010a-Sp; Fri, 25 Jan 2019 22:13:23 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:13:03 +0200
Message-Id: <20190125201305.5616-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/17] iwlwifi: mvm: remove sta key on wep ap
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

If WEP is used, no one removes the STA key upon STA
removal, leading to a situation where after 16
connect/disconnects - the AP could no longer decrypt
incoming data frames since iwl_mvm_set_fw_key_idx()
called from iwl_mvm_set_sta_key() during association
returns STA_KEY_IDX_INVALID, thus not setting the key
for that connecting STA.

Fix this by removing the key in the driver when the
STA is removed.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 78b35c9595a3..b4a55349336f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3091,6 +3091,16 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 			iwl_mvm_tdls_check_trigger(mvm, vif, sta->addr,
 						   NL80211_TDLS_DISABLE_LINK);
 		}
+
+		/* Remove STA key if this is an AP using WEP */
+		if (vif->type == NL80211_IFTYPE_AP && mvmvif->ap_wep_key) {
+			int rm_ret = iwl_mvm_remove_sta_key(mvm, vif, sta,
+							    mvmvif->ap_wep_key);
+
+			if (!ret)
+				ret = rm_ret;
+		}
+
 	} else {
 		ret = -EIO;
 	}
-- 
2.20.1


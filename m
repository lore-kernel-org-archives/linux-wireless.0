Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB7EC282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E1592146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfA0KUE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:20:04 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51430 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726487AbfA0KUE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:20:04 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXL-0001vC-6N; Sun, 27 Jan 2019 12:19:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:03 +0200
Message-Id: <20190127101908.6428-17-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/21] iwlwifi: mvm: update firmware when MU EDCA params change
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

When MU EDCA params change, resend the STA_HE_CTXT command
updating the MU EDCA params.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 531d2de131da..c9effd7f0ef8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2252,6 +2252,12 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
 	}
 
+	/* Update MU EDCA params */
+	if (changes & BSS_CHANGED_QOS && mvmvif->associated &&
+	    bss_conf->assoc && vif->bss_conf.he_support &&
+	    !iwlwifi_mod_params.disable_11ax)
+		iwl_mvm_cfg_he_sta(mvm, vif, mvmvif->ap_sta_id);
+
 	/*
 	 * If we're not associated yet, take the (new) BSSID before associating
 	 * so the firmware knows. If we're already associated, then use the old
-- 
2.20.1


Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5DAC433E8
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Mar 2021 10:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60C9061A48
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Mar 2021 10:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCZKbT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Mar 2021 06:31:19 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43334 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229946AbhCZKao (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Mar 2021 06:30:44 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lPjjl-0003EY-Fl; Fri, 26 Mar 2021 12:30:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Mar 2021 12:30:35 +0200
Message-Id: <20210326103035.206088-8-luca@coelho.fi>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326103035.206088-1-luca@coelho.fi>
References: <20210326103035.206088-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH for v5.12 7/7] iwlwifi: mvm: fix beacon protection checks
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately, since beacon protection isn't fully available
yet, we didn't notice that there are problems with it and
that the replay detection isn't working correctly. We were
relying only on mac80211, since iwl_mvm_rx_crypto() exits
when !ieee80211_has_protected(), which is of course true for
protected (but not encrypted) management frames.

Fix this to properly detect protected (but not encrypted)
management frames and handle them - we continue to only care
about beacons since for others everything can and will be
checked in mac80211.

Change-Id: I09c262a8f6f9852cc8f513cdcb31a7f8f87dd8af
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: b1fdc2505abc ("iwlwifi: mvm: advertise BIGTK client support if available")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c21736f80c29..af5a6dd81c41 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -272,10 +272,10 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 	rx_status->chain_signal[2] = S8_MIN;
 }
 
-static int iwl_mvm_rx_mgmt_crypto(struct ieee80211_sta *sta,
-				  struct ieee80211_hdr *hdr,
-				  struct iwl_rx_mpdu_desc *desc,
-				  u32 status)
+static int iwl_mvm_rx_mgmt_prot(struct ieee80211_sta *sta,
+				struct ieee80211_hdr *hdr,
+				struct iwl_rx_mpdu_desc *desc,
+				u32 status)
 {
 	struct iwl_mvm_sta *mvmsta;
 	struct iwl_mvm_vif *mvmvif;
@@ -285,6 +285,9 @@ static int iwl_mvm_rx_mgmt_crypto(struct ieee80211_sta *sta,
 	u32 len = le16_to_cpu(desc->mpdu_len);
 	const u8 *frame = (void *)hdr;
 
+	if ((status & IWL_RX_MPDU_STATUS_SEC_MASK) == IWL_RX_MPDU_STATUS_SEC_NONE)
+		return 0;
+
 	/*
 	 * For non-beacon, we don't really care. But beacons may
 	 * be filtered out, and we thus need the firmware's replay
@@ -356,6 +359,10 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	    IWL_RX_MPDU_STATUS_SEC_UNKNOWN && !mvm->monitor_on)
 		return -1;
 
+	if (unlikely(ieee80211_is_mgmt(hdr->frame_control) &&
+		     !ieee80211_has_protected(hdr->frame_control)))
+		return iwl_mvm_rx_mgmt_prot(sta, hdr, desc, status);
+
 	if (!ieee80211_has_protected(hdr->frame_control) ||
 	    (status & IWL_RX_MPDU_STATUS_SEC_MASK) ==
 	    IWL_RX_MPDU_STATUS_SEC_NONE)
@@ -411,7 +418,7 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		stats->flag |= RX_FLAG_DECRYPTED;
 		return 0;
 	case RX_MPDU_RES_STATUS_SEC_CMAC_GMAC_ENC:
-		return iwl_mvm_rx_mgmt_crypto(sta, hdr, desc, status);
+		break;
 	default:
 		/*
 		 * Sometimes we can get frames that were not decrypted
-- 
2.31.0


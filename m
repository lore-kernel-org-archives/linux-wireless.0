Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFD4C0044C
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 657AD208A3
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 657AD208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbeKKUOq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 15:14:46 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35808 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727344AbeKKUOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 15:14:46 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLmws-00007G-JW; Sun, 11 Nov 2018 12:26:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 12:26:24 +0200
Message-Id: <20181111102627.18461-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111102627.18461-1-luca@coelho.fi>
References: <20181111102627.18461-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/5] iwlwifi: mvm: support sta_statistics() even on older firmware
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The oldest firmware supported by iwlmvm do support getting
the average beacon RSSI. Enable the sta_statistics() call
from mac80211 even on older firmware versions.

Fixes: 33cef9256342 ("iwlwifi: mvm: support beacon statistics for BSS client")
Cc: stable@vger.kernel.org # 4.2+
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 505b0385d800..7c09ce20e8b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4444,10 +4444,6 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG);
 	}
 
-	if (!fw_has_capa(&mvm->fw->ucode_capa,
-			 IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
-		return;
-
 	/* if beacon filtering isn't on mac80211 does it anyway */
 	if (!(vif->driver_flags & IEEE80211_VIF_BEACON_FILTER))
 		return;
-- 
2.19.1


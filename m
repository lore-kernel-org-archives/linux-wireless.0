Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E11FC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4057C20657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4057C20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbeKBUPZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:15:25 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34092 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726528AbeKBUPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:15:25 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJH-0007MW-8a; Fri, 02 Nov 2018 13:08:15 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:56 +0200
Message-Id: <20181102110800.29817-12-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/15] iwlwifi: mvm: Send non offchannel traffic via AP sta
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

TDLS discovery response frame is a unicast direct frame to the peer.
Since we don't have a STA for this peer, this frame goes through
iwl_tx_skb_non_sta(). As the result aux_sta and some completely
arbitrary queue would be selected for this frame, resulting in a queue
hang.  Fix that by sending such frames through AP sta instead.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5bdc638fc999..55b965629e33 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -809,6 +809,21 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	    !ieee80211_is_bufferable_mmpdu(hdr->frame_control))
 		sta = NULL;
 
+	/* If there is no sta, and it's not offchannel - send through AP */
+	if (info->control.vif->type == NL80211_IFTYPE_STATION &&
+	    info->hw_queue != IWL_MVM_OFFCHANNEL_QUEUE && !sta) {
+		struct iwl_mvm_vif *mvmvif =
+			iwl_mvm_vif_from_mac80211(info->control.vif);
+		u8 ap_sta_id = READ_ONCE(mvmvif->ap_sta_id);
+
+		if (ap_sta_id < IWL_MVM_STATION_COUNT) {
+			/* mac80211 holds rcu read lock */
+			sta = rcu_dereference(mvm->fw_id_to_mac_id[ap_sta_id]);
+			if (IS_ERR_OR_NULL(sta))
+				goto drop;
+		}
+	}
+
 	if (sta) {
 		if (iwl_mvm_defer_tx(mvm, sta, skb))
 			return;
-- 
2.19.1


Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CAEC43612
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D4832080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbeLNU3z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:29:55 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41936 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730123AbeLNU3y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:54 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5o-0002RG-06; Fri, 14 Dec 2018 22:29:52 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:29 +0200
Message-Id: <20181214202945.32375-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/18] iwlwifi: mvm: remove dead code
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

In iwl_mvm_tx_skb_non_sta(), in case of managed interface,
the AP station was supposed to be used for multicast frames
instead of the auxiliary station to avoid frames possibly
sent to an absent P2P GO. However, when moving to DQA mode,
this was broken as no valid queue was assigned. This is fixed
by a recent patch that directs all non-offchannel traffic to
ap station earlier in the TX path. However, the broken, and
now dead code, remained. Remove it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 09cabf336310..7a9ec6810395 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -763,12 +763,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 							   hdr->frame_control);
 			if (queue < 0)
 				return -1;
-		} else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
-			   is_multicast_ether_addr(hdr->addr1)) {
-			u8 ap_sta_id = READ_ONCE(mvmvif->ap_sta_id);
-
-			if (ap_sta_id != IWL_MVM_INVALID_STA)
-				sta_id = ap_sta_id;
 		} else if (info.control.vif->type == NL80211_IFTYPE_MONITOR) {
 			queue = mvm->snif_queue;
 			sta_id = mvm->snif_sta.sta_id;
-- 
2.19.2


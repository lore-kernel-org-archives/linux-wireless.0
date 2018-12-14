Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFE4C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74EAD2080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbeLNU35 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:29:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41952 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730766AbeLNU3z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:55 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5p-0002RG-Ju; Fri, 14 Dec 2018 22:29:54 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:31 +0200
Message-Id: <20181214202945.32375-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/18] iwlwifi: mvm: cleanup iwl_mvm_tx_skb_non_sta
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Make the coupling of station id and queue id clear. Group code
together. Remove outdated comment. Never use an undefined hw
queue as given from mac80211.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 42 +++++++++------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2738cd307765..4ebfd41dadc9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -708,22 +708,12 @@ static void iwl_mvm_probe_resp_set_noa(struct iwl_mvm *mvm,
 int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_info info;
 	struct iwl_device_cmd *dev_cmd;
 	u8 sta_id;
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	__le16 fc = hdr->frame_control;
-	int queue;
-
-	/* IWL_MVM_OFFCHANNEL_QUEUE is used for ROC packets that can be used
-	 * in 2 different types of vifs, P2P & STATION. P2P uses the offchannel
-	 * queue. STATION (HS2.0) uses the auxiliary context of the FW,
-	 * and hence needs to be sent on the aux queue
-	 */
-	if (skb_info->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
-	    skb_info->control.vif->type == NL80211_IFTYPE_STATION)
-		skb_info->hw_queue = mvm->aux_queue;
+	int queue = -1;
 
 	memcpy(&info, skb->cb, sizeof(info));
 
@@ -735,18 +725,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			  info.hw_queue != info.control.vif->cab_queue)))
 		return -1;
 
-	queue = info.hw_queue;
-
-	/*
-	 * If the interface on which the frame is sent is the P2P_DEVICE
-	 * or an AP/GO interface use the broadcast station associated
-	 * with it; otherwise if the interface is a managed interface
-	 * use the AP station associated with it for multicast traffic
-	 * (this is not possible for unicast packets as a TLDS discovery
-	 * response are sent without a station entry); otherwise use the
-	 * AUX station.
-	 */
-	sta_id = mvm->aux_sta.sta_id;
 	if (info.control.vif) {
 		struct iwl_mvm_vif *mvmvif =
 			iwl_mvm_vif_from_mac80211(info.control.vif);
@@ -761,14 +739,28 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 
 			queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info,
 							   hdr->frame_control);
-			if (queue < 0)
-				return -1;
+
 		} else if (info.control.vif->type == NL80211_IFTYPE_MONITOR) {
 			queue = mvm->snif_queue;
 			sta_id = mvm->snif_sta.sta_id;
+		} else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
+			   info.hw_queue == IWL_MVM_OFFCHANNEL_QUEUE) {
+			/*
+			 * IWL_MVM_OFFCHANNEL_QUEUE is used for ROC packets
+			 * that can be used in 2 different types of vifs, P2P &
+			 * STATION.
+			 * P2P uses the offchannel queue.
+			 * STATION (HS2.0) uses the auxiliary context of the FW,
+			 * and hence needs to be sent on the aux queue.
+			 */
+			sta_id = mvm->aux_sta.sta_id;
+			queue = mvm->aux_queue;
 		}
 	}
 
+	if (queue < 0)
+		return -1;
+
 	if (unlikely(ieee80211_is_probe_resp(fc)))
 		iwl_mvm_probe_resp_set_noa(mvm, skb);
 
-- 
2.19.2


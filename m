Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3CEC282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 271DE2146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfA0KUX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:20:23 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51454 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726839AbfA0KUX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:20:23 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXJ-0001vC-Lq; Sun, 27 Jan 2019 12:19:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:01 +0200
Message-Id: <20190127101908.6428-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/21] iwlwifi: mvm: include configured sniffer AID in radiotap
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In order to make more sense out of the captured radiotap data e.g.
when the configured AID changes, add the currently configured AID
to the radiotap data as a vendor extension field.

This is made race-free by updating the included value from inside
the RX path (using a notification wait) for the command response
from the firmware, which thus means it's serialized with frame RX.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 44 ++++++++++++++++++-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 39 ++++++++++++++--
 4 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 91b46361ac9f..e136475a34f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1682,11 +1682,33 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
 	return ret ?: count;
 }
 
+struct iwl_mvm_sniffer_apply {
+	struct iwl_mvm *mvm;
+	u16 aid;
+};
+
+static bool iwl_mvm_sniffer_apply(struct iwl_notif_wait_data *notif_data,
+				  struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_mvm_sniffer_apply *apply = data;
+
+	apply->mvm->cur_aid = cpu_to_le16(apply->aid);
+
+	return true;
+}
+
 static ssize_t
 iwl_dbgfs_he_sniffer_params_write(struct iwl_mvm *mvm, char *buf,
-			size_t count, loff_t *ppos)
+				  size_t count, loff_t *ppos)
 {
+	struct iwl_notification_wait wait;
 	struct iwl_he_monitor_cmd he_mon_cmd = {};
+	struct iwl_mvm_sniffer_apply apply = {
+		.mvm = mvm,
+	};
+	u16 wait_cmds[] = {
+		iwl_cmd_id(HE_AIR_SNIFFER_CONFIG_CMD, DATA_PATH_GROUP, 0),
+	};
 	u32 aid;
 	int ret;
 
@@ -1702,10 +1724,30 @@ iwl_dbgfs_he_sniffer_params_write(struct iwl_mvm *mvm, char *buf,
 
 	he_mon_cmd.aid = cpu_to_le16(aid);
 
+	apply.aid = aid;
+
 	mutex_lock(&mvm->mutex);
+
+	/*
+	 * Use the notification waiter to get our function triggered
+	 * in sequence with other RX. This ensures that frames we get
+	 * on the RX queue _before_ the new configuration is applied
+	 * still have mvm->cur_aid pointing to the old AID, and that
+	 * frames on the RX queue _after_ the firmware processed the
+	 * new configuration (and sent the response, synchronously)
+	 * get mvm->cur_aid correctly set to the new AID.
+	 */
+	iwl_init_notification_wait(&mvm->notif_wait, &wait,
+				   wait_cmds, ARRAY_SIZE(wait_cmds),
+				   iwl_mvm_sniffer_apply, &apply);
+
 	ret = iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(HE_AIR_SNIFFER_CONFIG_CMD,
 						   DATA_PATH_GROUP, 0), 0,
 				   sizeof(he_mon_cmd), &he_mon_cmd);
+
+	/* no need to really wait, we already did anyway */
+	iwl_remove_notification(&mvm->notif_wait, &wait);
+
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d4b05caabc74..531d2de131da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1167,6 +1167,8 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	iwl_mvm_stop_device(mvm);
 
+	mvm->cur_aid = 0;
+
 	mvm->scan_status = 0;
 	mvm->ps_disabled = false;
 	mvm->calibrating = false;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 5c9adf72691f..ac526b412aa6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1164,6 +1164,10 @@ struct iwl_mvm {
 
 	/* does a monitor vif exist (only one can exist hence bool) */
 	bool monitor_on;
+
+	/* sniffer data to include in radiotap */
+	__le16 cur_aid;
+
 #ifdef CONFIG_ACPI
 	struct iwl_mvm_sar_profile sar_profiles[ACPI_SAR_PROFILE_NUM];
 	struct iwl_mvm_geo_profile geo_profiles[ACPI_NUM_GEO_PROFILES];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 9fde322904f4..79860f6ac7ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -192,11 +192,40 @@ static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
 	}
 }
 
+static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
+					    struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_vendor_radiotap *radiotap;
+	int size = sizeof(*radiotap) + sizeof(__le16);
+
+	if (!mvm->cur_aid)
+		return;
+
+	radiotap = skb_put(skb, size);
+	radiotap->align = 1;
+	/* Intel OUI */
+	radiotap->oui[0] = 0xf6;
+	radiotap->oui[1] = 0x54;
+	radiotap->oui[2] = 0x25;
+	/* radiotap sniffer config sub-namespace */
+	radiotap->subns = 1;
+	radiotap->present = 0x1;
+	radiotap->len = size - sizeof(*radiotap);
+	radiotap->pad = 0;
+
+	/* fill the data now */
+	memcpy(radiotap->data, &mvm->cur_aid, sizeof(mvm->cur_aid));
+
+	rx_status->flag |= RX_FLAG_RADIOTAP_VENDOR_DATA;
+}
+
 /* iwl_mvm_pass_packet_to_mac80211 - passes the packet for mac80211 */
 static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 					    struct napi_struct *napi,
 					    struct sk_buff *skb, int queue,
-					    struct ieee80211_sta *sta)
+					    struct ieee80211_sta *sta,
+					    bool csi)
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 
@@ -465,7 +494,7 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 		while ((skb = __skb_dequeue(skb_list))) {
 			iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb,
 							reorder_buf->queue,
-							sta);
+							sta, false);
 			reorder_buf->num_stored--;
 		}
 	}
@@ -1304,6 +1333,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		.d4 = desc->phy_data4,
 		.info_type = IWL_RX_PHY_INFO_TYPE_NONE,
 	};
+	bool csi = false;
 
 	if (unlikely(test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)))
 		return;
@@ -1599,7 +1629,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	iwl_mvm_create_skb(skb, hdr, len, crypt_len, rxb);
 	if (!iwl_mvm_reorder(mvm, napi, queue, sta, skb, desc))
-		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
+		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue,
+						sta, csi);
 out:
 	rcu_read_unlock();
 }
@@ -1732,7 +1763,7 @@ void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
 		rx_status->rate_idx = rate;
 	}
 
-	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
+	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta, false);
 out:
 	rcu_read_unlock();
 }
-- 
2.20.1


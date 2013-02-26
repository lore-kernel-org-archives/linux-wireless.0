Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759965Ab3BZV2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:28:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] iwlwifi: fix wakeup status query and packet reporting
Date: Tue, 26 Feb 2013 22:27:56 +0100
Message-Id: <1361914077-18749-3-git-send-email-johannes@sipsolutions.net> (sfid-20130226_222808_680974_2FBF6182)
In-Reply-To: <1361914077-18749-1-git-send-email-johannes@sipsolutions.net>
References: <1361914034.8440.27.camel@jlt4.sipsolutions.net>
 <1361914077-18749-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The wakeup packet in the status response is padded out
to a multiple of 4 bytes by the firmware for transfer
to the host, take that into account when checking the
length of the command.

Also, the reported wakeup packet includes the FCS but
the userspace API doesn't, so remove that. If it is a
data packet it is reported as an 802.3 packet but I
forgot to take into account and remove the encryption
head/tail, fix all of that as well.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c  | 103 ++++++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/mvm.h |   4 ++
 2 files changed, 80 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index c64d864..9f0a611 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -192,6 +192,11 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 					   sizeof(wkc), &wkc);
 		data->error = ret != 0;
 
+		mvm->ptk_ivlen = key->iv_len;
+		mvm->ptk_icvlen = key->icv_len;
+		mvm->gtk_ivlen = key->iv_len;
+		mvm->gtk_icvlen = key->icv_len;
+
 		/* don't upload key again */
 		goto out_unlock;
 	}
@@ -304,9 +309,13 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 	 */
 	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
 		key->hw_key_idx = 0;
+		mvm->ptk_ivlen = key->iv_len;
+		mvm->ptk_icvlen = key->icv_len;
 	} else {
 		data->gtk_key_idx++;
 		key->hw_key_idx = data->gtk_key_idx;
+		mvm->gtk_ivlen = key->iv_len;
+		mvm->gtk_icvlen = key->icv_len;
 	}
 
 	ret = iwl_mvm_set_sta_key(mvm, vif, sta, key, true);
@@ -649,6 +658,11 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	/* We reprogram keys and shouldn't allocate new key indices */
 	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
 
+	mvm->ptk_ivlen = 0;
+	mvm->ptk_icvlen = 0;
+	mvm->ptk_ivlen = 0;
+	mvm->ptk_icvlen = 0;
+
 	/*
 	 * The D3 firmware still hardcodes the AP station ID for the
 	 * BSS we're associated with as 0. As a result, we have to move
@@ -783,7 +797,6 @@ static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	struct iwl_wowlan_status *status;
 	u32 reasons;
 	int ret, len;
-	bool pkt8023 = false;
 	struct sk_buff *pkt = NULL;
 
 	iwl_trans_read_mem_bytes(mvm->trans, base,
@@ -824,7 +837,8 @@ static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	status = (void *)cmd.resp_pkt->data;
 
 	if (len - sizeof(struct iwl_cmd_header) !=
-	    sizeof(*status) + le32_to_cpu(status->wake_packet_bufsize)) {
+	    sizeof(*status) +
+	    ALIGN(le32_to_cpu(status->wake_packet_bufsize), 4)) {
 		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
 		goto out;
 	}
@@ -836,61 +850,96 @@ static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 		goto report;
 	}
 
-	if (reasons & IWL_WOWLAN_WAKEUP_BY_MAGIC_PACKET) {
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_MAGIC_PACKET)
 		wakeup.magic_pkt = true;
-		pkt8023 = true;
-	}
 
-	if (reasons & IWL_WOWLAN_WAKEUP_BY_PATTERN) {
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_PATTERN)
 		wakeup.pattern_idx =
 			le16_to_cpu(status->pattern_number);
-		pkt8023 = true;
-	}
 
 	if (reasons & (IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON |
 		       IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH))
 		wakeup.disconnect = true;
 
-	if (reasons & IWL_WOWLAN_WAKEUP_BY_GTK_REKEY_FAILURE) {
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_GTK_REKEY_FAILURE)
 		wakeup.gtk_rekey_failure = true;
-		pkt8023 = true;
-	}
 
-	if (reasons & IWL_WOWLAN_WAKEUP_BY_RFKILL_DEASSERTED) {
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_RFKILL_DEASSERTED)
 		wakeup.rfkill_release = true;
-		pkt8023 = true;
-	}
 
-	if (reasons & IWL_WOWLAN_WAKEUP_BY_EAPOL_REQUEST) {
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_EAPOL_REQUEST)
 		wakeup.eap_identity_req = true;
-		pkt8023 = true;
-	}
 
-	if (reasons & IWL_WOWLAN_WAKEUP_BY_FOUR_WAY_HANDSHAKE) {
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_FOUR_WAY_HANDSHAKE)
 		wakeup.four_way_handshake = true;
-		pkt8023 = true;
-	}
 
 	if (status->wake_packet_bufsize) {
-		u32 pktsize = le32_to_cpu(status->wake_packet_bufsize);
-		u32 pktlen = le32_to_cpu(status->wake_packet_length);
+		int pktsize = le32_to_cpu(status->wake_packet_bufsize);
+		int pktlen = le32_to_cpu(status->wake_packet_length);
+		const u8 *pktdata = status->wake_packet;
+		struct ieee80211_hdr *hdr = (void *)pktdata;
+		int truncated = pktlen - pktsize;
+
+		/* this would be a firmware bug */
+		if (WARN_ON_ONCE(truncated < 0))
+			truncated = 0;
+
+		if (ieee80211_is_data(hdr->frame_control)) {
+			int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+			int ivlen = 0, icvlen = 4; /* also FCS */
 
-		if (pkt8023) {
 			pkt = alloc_skb(pktsize, GFP_KERNEL);
 			if (!pkt)
 				goto report;
-			memcpy(skb_put(pkt, pktsize), status->wake_packet,
-			       pktsize);
+
+			memcpy(skb_put(pkt, hdrlen), pktdata, hdrlen);
+			pktdata += hdrlen;
+			pktsize -= hdrlen;
+
+			if (ieee80211_has_protected(hdr->frame_control)) {
+				if (is_multicast_ether_addr(hdr->addr1)) {
+					ivlen = mvm->gtk_ivlen;
+					icvlen += mvm->gtk_icvlen;
+				} else {
+					ivlen = mvm->ptk_ivlen;
+					icvlen += mvm->ptk_icvlen;
+				}
+			}
+
+			/* if truncated, FCS/ICV is (partially) gone */
+			if (truncated >= icvlen) {
+				icvlen = 0;
+				truncated -= icvlen;
+			} else {
+				icvlen -= truncated;
+				truncated = 0;
+			}
+
+			pktsize -= ivlen + icvlen;
+			pktdata += ivlen;
+
+			memcpy(skb_put(pkt, pktsize), pktdata, pktsize);
+
 			if (ieee80211_data_to_8023(pkt, vif->addr, vif->type))
 				goto report;
 			wakeup.packet = pkt->data;
 			wakeup.packet_present_len = pkt->len;
-			wakeup.packet_len = pkt->len - (pktlen - pktsize);
+			wakeup.packet_len = pkt->len - truncated;
 			wakeup.packet_80211 = false;
 		} else {
+			int fcslen = 4;
+
+			if (truncated >= 4) {
+				truncated -= 4;
+				fcslen = 0;
+			} else {
+				fcslen -= truncated;
+				truncated = 0;
+			}
+			pktsize -= fcslen;
 			wakeup.packet = status->wake_packet;
 			wakeup.packet_present_len = pktsize;
-			wakeup.packet_len = pktlen;
+			wakeup.packet_len = pktlen - truncated;
 			wakeup.packet_80211 = true;
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4e339cc..537711b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -327,6 +327,10 @@ struct iwl_mvm {
 	struct led_classdev led;
 
 	struct ieee80211_vif *p2p_device_vif;
+
+#ifdef CONFIG_PM_SLEEP
+	int gtk_ivlen, gtk_icvlen, ptk_ivlen, ptk_icvlen;
+#endif
 };
 
 /* Extract MVM priv from op_mode and _hw */
-- 
1.8.0


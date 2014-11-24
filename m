Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61946 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbaKXOgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:01 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so9052095wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:00 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/75] iwlwifi: mvm: pull crypto header into skb->head
Date: Mon, 24 Nov 2014 16:34:15 +0200
Message-Id: <1416839691-28533-39-git-send-email-egrumbach@gmail.com> (sfid-20141124_153902_854416_60D3298D)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we pre-populate the skb->head for the stack, we only pull
in the 802.11 header (assuming the packet isn't short enough to
be in there completely.) This is fine, but in many cases we'll
pull in the crypto headers pretty much immediately afterwards,
so to avoid that pull in the crypto header early.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: IdoX Yariv <ido@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 57052e6..69fa765 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -98,16 +98,16 @@ int iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 					    struct sk_buff *skb,
 					    struct ieee80211_hdr *hdr, u16 len,
-					    u32 ampdu_status,
+					    u32 ampdu_status, u8 crypt_len,
 					    struct iwl_rx_cmd_buffer *rxb)
 {
 	unsigned int hdrlen, fraglen;
 
 	/* If frame is small enough to fit in skb->head, pull it completely.
-	 * If not, only pull ieee80211_hdr so that splice() or TCP coalesce
-	 * are more efficient.
+	 * If not, only pull ieee80211_hdr (including crypto if present) so
+	 * that splice() or TCP coalesce are more efficient.
 	 */
-	hdrlen = (len <= skb_tailroom(skb)) ? len : sizeof(*hdr);
+	hdrlen = (len <= skb_tailroom(skb)) ? len : sizeof(*hdr) + crypt_len;
 
 	memcpy(skb_put(skb, hdrlen), hdr, hdrlen);
 	fraglen = len - hdrlen;
@@ -174,7 +174,8 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 					struct ieee80211_hdr *hdr,
 					struct ieee80211_rx_status *stats,
-					u32 rx_pkt_status)
+					u32 rx_pkt_status,
+					u8 *crypt_len)
 {
 	if (!ieee80211_has_protected(hdr->frame_control) ||
 	    (rx_pkt_status & RX_MPDU_RES_STATUS_SEC_ENC_MSK) ==
@@ -194,12 +195,14 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 
 		stats->flag |= RX_FLAG_DECRYPTED;
 		IWL_DEBUG_WEP(mvm, "hw decrypted CCMP successfully\n");
+		*crypt_len = IEEE80211_CCMP_HDR_LEN;
 		return 0;
 
 	case RX_MPDU_RES_STATUS_SEC_TKIP_ENC:
 		/* Don't drop the frame and decrypt it in SW */
 		if (!(rx_pkt_status & RX_MPDU_RES_STATUS_TTAK_OK))
 			return 0;
+		*crypt_len = IEEE80211_TKIP_IV_LEN;
 		/* fall through if TTAK OK */
 
 	case RX_MPDU_RES_STATUS_SEC_WEP_ENC:
@@ -207,6 +210,9 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 			return -1;
 
 		stats->flag |= RX_FLAG_DECRYPTED;
+		if ((rx_pkt_status & RX_MPDU_RES_STATUS_SEC_ENC_MSK) ==
+				RX_MPDU_RES_STATUS_SEC_WEP_ENC)
+			*crypt_len = IEEE80211_WEP_IV_LEN;
 		return 0;
 
 	case RX_MPDU_RES_STATUS_SEC_EXT_ENC:
@@ -241,6 +247,7 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	u32 ampdu_status;
 	u32 rate_n_flags;
 	u32 rx_pkt_status;
+	u8 crypt_len = 0;
 
 	phy_info = &mvm->last_phy_info;
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
@@ -263,7 +270,8 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	/*
 	 * drop the packet if it has failed being decrypted by HW
 	 */
-	if (iwl_mvm_set_mac80211_rx_flag(mvm, hdr, rx_status, rx_pkt_status)) {
+	if (iwl_mvm_set_mac80211_rx_flag(mvm, hdr, rx_status, rx_pkt_status,
+					 &crypt_len)) {
 		IWL_DEBUG_DROP(mvm, "Bad decryption results 0x%08x\n",
 			       rx_pkt_status);
 		kfree_skb(skb);
@@ -393,7 +401,8 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	iwl_mvm_update_frame_stats(mvm, &mvm->drv_rx_stats, rate_n_flags,
 				   rx_status->flag & RX_FLAG_AMPDU_DETAILS);
 #endif
-	iwl_mvm_pass_packet_to_mac80211(mvm, skb, hdr, len, ampdu_status, rxb);
+	iwl_mvm_pass_packet_to_mac80211(mvm, skb, hdr, len, ampdu_status,
+					crypt_len, rxb);
 	return 0;
 }
 
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19845 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0CXCxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 22:53:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/2] iwlwifi: remove skb_linearize for rx frames
Date: Wed, 24 Mar 2010 10:57:43 +0800
Message-Id: <1269399463-5244-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove skb_linearize in the driver since mac80211 now supports
paged rx SKBs.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    7 -------
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   30 +-----------------------------
 2 files changed, 1 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e847e61..c2b907d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -363,13 +363,6 @@ enum {
 
 #define DEF_CMD_PAYLOAD_SIZE 320
 
-/*
- * IWL_LINK_HDR_MAX should include ieee80211_hdr, radiotap header,
- * SNAP header and alignment. It should also be big enough for 802.11
- * control frames.
- */
-#define IWL_LINK_HDR_MAX 64
-
 /**
  * struct iwl_device_cmd
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b6a64d8..05dd057 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1075,7 +1075,6 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 					struct ieee80211_rx_status *stats)
 {
 	struct sk_buff *skb;
-	int ret = 0;
 	__le16 fc = hdr->frame_control;
 
 	/* We only process data packets if the interface is open */
@@ -1090,45 +1089,18 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
-	skb = alloc_skb(IWL_LINK_HDR_MAX * 2, GFP_ATOMIC);
+	skb = dev_alloc_skb(128);
 	if (!skb) {
 		IWL_ERR(priv, "alloc_skb failed\n");
 		return;
 	}
 
-	skb_reserve(skb, IWL_LINK_HDR_MAX);
 	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
 
-	/* mac80211 currently doesn't support paged SKB. Convert it to
-	 * linear SKB for management frame and data frame requires
-	 * software decryption or software defragementation. */
-	if (ieee80211_is_mgmt(fc) ||
-	    ieee80211_has_protected(fc) ||
-	    ieee80211_has_morefrags(fc) ||
-	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG ||
-	    (ieee80211_is_data_qos(fc) &&
-	     *ieee80211_get_qos_ctl(hdr) &
-	     IEEE80211_QOS_CONTROL_A_MSDU_PRESENT))
-		ret = skb_linearize(skb);
-	else
-		ret = __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, len)) ?
-			 0 : -ENOMEM;
-
-	if (ret) {
-		kfree_skb(skb);
-		goto out;
-	}
-
-	/*
-	 * XXX: We cannot touch the page and its virtual memory (hdr) after
-	 * here. It might have already been freed by the above skb change.
-	 */
-
 	iwl_update_stats(priv, false, fc, len);
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(priv->hw, skb);
- out:
 	priv->alloc_rxb_page--;
 	rxb->page = NULL;
 }
-- 
1.6.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56072 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaEORE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:04:56 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so4567832wiv.15
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:04:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/24] iwlwifi: dvm: don't use _ni mac80211's callbacks
Date: Thu, 15 May 2014 20:04:19 +0300
Message-Id: <1400173481-9047-2-git-send-email-egrumbach@gmail.com> (sfid-20140515_190500_779766_6D2A3A4C)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is not needed since the PCIe layer disables the
bottom halves before it calls the op_mode.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rx.c | 2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index cd83773..debec96 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -786,7 +786,7 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
-	ieee80211_rx_ni(priv->hw, skb);
+	ieee80211_rx(priv->hw, skb);
 }
 
 static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 5b88ca7..3255a17 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1271,7 +1271,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 
 	while (!skb_queue_empty(&skbs)) {
 		skb = __skb_dequeue(&skbs);
-		ieee80211_tx_status_ni(priv->hw, skb);
+		ieee80211_tx_status(priv->hw, skb);
 	}
 
 	return 0;
@@ -1411,7 +1411,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 	while (!skb_queue_empty(&reclaimed_skbs)) {
 		skb = __skb_dequeue(&reclaimed_skbs);
-		ieee80211_tx_status_ni(priv->hw, skb);
+		ieee80211_tx_status(priv->hw, skb);
 	}
 
 	return 0;
-- 
1.8.3.2


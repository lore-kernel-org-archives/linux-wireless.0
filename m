Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:6888 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYFFR7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 13:59:45 -0400
Received: by py-out-1112.google.com with SMTP id p76so875712pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 10:59:45 -0700 (PDT)
Subject: [PATCH 2/7] mac80211: replace ieee80211_get_morefrag with
	ieee80211_has_morefrags
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:51:11 -0700
Message-Id: <1212774671.6340.76.camel@brick> (sfid-20080606_195949_779335_CCCCC9BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.c   |    2 +-
 drivers/net/wireless/rtl8187_dev.c          |    2 +-
 include/linux/ieee80211.h                   |   13 -------------
 5 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index cfe6f4b..b22dc54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -595,7 +595,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 

 	tx_cmd->sta_id = std_id;
-	if (ieee80211_get_morefrag(hdr))
+	if (ieee80211_has_morefrags(hdr->frame_control))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
 	if (ieee80211_is_qos_data(fc)) {
@@ -952,7 +952,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
 
-	if (!ieee80211_get_morefrag(hdr)) {
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
 		if (qc)
 			priv->stations[sta_id].tid[tid].seq_number = seq_number;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 72279e0..77a0113 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2448,7 +2448,7 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 	}
 
 	cmd->cmd.tx.sta_id = std_id;
-	if (ieee80211_get_morefrag(hdr))
+	if (ieee80211_has_morefrags(hdr->frame_control))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
 	if (ieee80211_is_qos_data(fc)) {
@@ -2732,7 +2732,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
 	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 
-	if (!ieee80211_get_morefrag(hdr)) {
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
 		if (qc) {
 			priv->stations[sta_id].tid[tid].seq_number = seq_number;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e69ef4b..95ed617 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -91,7 +91,7 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	/*
 	 * Check if more fragments are pending
 	 */
-	if (ieee80211_get_morefrag(hdr)) {
+	if (ieee80211_has_morefrags(hdr->frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
 		__set_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags);
 	}
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 0078c7e..c553b82 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -181,7 +181,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
 
 	flags |= ieee80211_get_tx_rate(dev, info)->hw_value << 24;
-	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
+	if (ieee80211_has_morefrags(((struct ieee80211_hdr *)skb->data)->frame_control)
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		flags |= RTL8187_TX_FLAG_RTS;
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 5773c62..9496bea 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -651,17 +651,4 @@ static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 		return hdr->addr1;
 }
 
-/**
- * ieee80211_get_morefrag - determine whether the MOREFRAGS bit is set
- *
- * This function determines whether the "more fragments" bit is set
- * in the frame.
- *
- * @hdr: the frame
- */
-static inline int ieee80211_get_morefrag(struct ieee80211_hdr *hdr)
-{
-	return ieee80211_has_morefrags(hdr->frame_control);
-}
-
 #endif /* IEEE80211_H */
-- 
1.5.6.rc1.257.gba91d



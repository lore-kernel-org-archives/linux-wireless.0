Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:2940 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYFKVWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:22:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3278785wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:22:00 -0700 (PDT)
Subject: [PATCHv2 02/11] mac80211: remove ieee80211_get_morefrag
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 14:21:56 -0700
Message-Id: <1213219316.5974.175.camel@brick> (sfid-20080611_232210_536260_F606DD18)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replaced by the new helper ieee80211_has_morefrags which is
more consistent with the intent of the function.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.c   |    2 +-
 drivers/net/wireless/rtl8187_dev.c          |    2 +-
 include/linux/ieee80211.h                   |   14 --------------
 5 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3850cb2..78b331a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -595,7 +595,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 

 	tx_cmd->sta_id = std_id;
-	if (ieee80211_get_morefrag(hdr))
+	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
 	if (ieee80211_is_data_qos(fc)) {
@@ -951,7 +951,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
 
-	if (!ieee80211_get_morefrag(hdr)) {
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
 		if (qc)
 			priv->stations[sta_id].tid[tid].seq_number = seq_number;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 265d65a..cbb69df 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2448,7 +2448,7 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 	}
 
 	cmd->cmd.tx.sta_id = std_id;
-	if (ieee80211_get_morefrag(hdr))
+	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
 	if (ieee80211_is_data_qos(fc)) {
@@ -2731,7 +2731,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
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
index 0078c7e..bec96d7 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -181,7 +181,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
 
 	flags |= ieee80211_get_tx_rate(dev, info)->hw_value << 24;
-	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
+	if (ieee80211_has_morefrags(((struct ieee80211_hdr *)skb->data)->frame_control))
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		flags |= RTL8187_TX_FLAG_RTS;
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1711a00..c346cdd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -955,18 +955,4 @@ static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
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
-	__le16 fc = hdr->frame_control;
-	return !!(fc & cpu_to_le16(IEEE80211_FCTL_MOREFRAGS));
-}
-
 #endif /* IEEE80211_H */
-- 
1.5.6.rc2.261.ga8fbe



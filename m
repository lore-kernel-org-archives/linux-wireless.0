Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:56675 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYGHUrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 16:47:31 -0400
Received: by yx-out-2324.google.com with SMTP id 8so687174yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 13:47:31 -0700 (PDT)
Subject: [PATCH 4/6] iwlwifi: use le16 frame control directly, use QOS
	symbolic constant mask
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 13:47:23 -0700
Message-Id: <1215550044.476.42.camel@brick> (sfid-20080708_224734_281651_865D465D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 032641d..21fd4d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -819,7 +819,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(fc));
+	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl_get_sta_id(priv, hdr);
@@ -835,7 +835,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & 0xf;
+		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f27c9fd..59c3997 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2623,7 +2623,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(fc));
+	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl3945_get_sta_id(priv, hdr);
@@ -2639,7 +2639,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & 0xf;
+		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
@@ -2759,7 +2759,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 			   sizeof(out_cmd->cmd.tx));
 
 	iwl3945_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
-			   ieee80211_get_hdrlen(le16_to_cpu(fc)));
+			   ieee80211_hdrlen(fc));
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-- 
1.5.6.1.322.ge904b



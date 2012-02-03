Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab2BCMIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 11/25] iwlegacy: get rid of mcast_queue
Date: Fri,  3 Feb 2012 13:07:11 +0100
Message-Id: <1328270845-16891-12-git-send-email-sgruszka@redhat.com> (sfid-20120203_130823_464680_674CF75C)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   17 ++++-------------
 drivers/net/wireless/iwlegacy/common.h   |    3 ---
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 3209970..ecb7b54 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1708,19 +1708,10 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		il4965_sta_modify_sleep_tx_count(il, sta_id, 1);
 	}
 
-	/*
-	 * Send this frame after DTIM -- there's a special queue
-	 * reserved for this for contexts that support AP mode.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
-		txq_id = ctx->mcast_queue;
-		/*
-		 * The microcode will clear the more data
-		 * bit in the last frame it transmits.
-		 */
-		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	} else
-		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
+	/* FIXME: remove me ? */
+	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
+
+	txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
 
 	/* irqs already disabled/saved above when locking il->lock */
 	spin_lock(&il->sta_lock);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 8df2286..89922e0 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1157,7 +1157,6 @@ struct il_rxon_context {
 
 	const u8 *ac_to_fifo;
 	const u8 *ac_to_queue;
-	u8 mcast_queue;
 
 	/*
 	 * We could use the vif to indicate active, but we
@@ -1166,8 +1165,6 @@ struct il_rxon_context {
 	 */
 	bool always_active, is_active;
 
-	bool ht_need_multiple_chains;
-
 	u32 interface_modes, exclusive_interface_modes;
 
 	struct il_qos_info qos_data;
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62102 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1BQWsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:48:01 -0500
Received: by qyj19 with SMTP id 19so5415821qyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 14:48:00 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org
Subject: [PATCH V2 2/3] mwl8k: Tell mac80211 we have rate adaptation in FW
Date: Thu, 17 Feb 2011 14:45:17 -0800
Message-Id: <1297982718-20377-2-git-send-email-thomas@cozybit.com>
In-Reply-To: <1297982718-20377-1-git-send-email-thomas@cozybit.com>
References: <1297982718-20377-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

All mwl8k parts perform rate control in firmware.  Make this known to
mac80211 so that it does not launch minstrel.  Also, because actual tx
rate information is not available from the firmware, invalidate the
rate status before returning the skb to mac80211.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f79da1b..44355f7 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1535,6 +1535,13 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 
 		info = IEEE80211_SKB_CB(skb);
 		ieee80211_tx_info_clear_status(info);
+
+		/* Rate control is happening in the firmware.
+		 * Ensure no tx rate is being reported.
+		 */
+                info->status.rates[0].idx = -1;
+                info->status.rates[0].count = 1;
+
 		if (MWL8K_TXD_SUCCESS(status))
 			info->flags |= IEEE80211_TX_STAT_ACK;
 
@@ -4764,7 +4771,7 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	hw->queues = MWL8K_TX_QUEUES;
 
 	/* Set rssi values to dBm */
-	hw->flags |= IEEE80211_HW_SIGNAL_DBM;
+	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_HAS_RATE_CONTROL;
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
 
-- 
1.7.0.4


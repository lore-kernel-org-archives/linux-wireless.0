Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58956 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0BYGMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:18 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/7] iwmc3200wifi: typo fix and code cleanup
Date: Thu, 25 Feb 2010 14:15:31 +0800
Message-Id: <1267078531-9817-8-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1267078531-9817-7-git-send-email-yi.zhu@intel.com>
References: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-3-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-4-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-5-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-6-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix wrong IWM_RX_TICKET_DROP_REASON_MSK macro define, typo and other
small cleanups.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c       |    7 +++----
 drivers/net/wireless/iwmc3200wifi/tx.c       |    7 +++----
 drivers/net/wireless/iwmc3200wifi/umac.h     |    2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 9ef4fd0..b5cbd2b 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -506,7 +506,7 @@ static int iwm_target_read(struct iwm_priv *iwm, __le32 address,
 		return ret;
 	}
 
-	/* When succeding, the send_target routine returns the seq number */
+	/* When succeeding, the send_target routine returns the seq number */
 	seq_num = ret;
 
 	ret = wait_event_interruptible_timeout(iwm->nonwifi_queue,
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index c8a31be..5090a8a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -869,16 +869,15 @@ static int iwm_mlme_remove_bss(struct iwm_priv *iwm, u8 *buf,
 	int i;
 
 	for (i = 0; i < le32_to_cpu(bss_rm->count); i++) {
-		table_idx = (le16_to_cpu(bss_rm->entries[i])
-			     & IWM_BSS_REMOVE_INDEX_MSK);
+		table_idx = le16_to_cpu(bss_rm->entries[i]) &
+			    IWM_BSS_REMOVE_INDEX_MSK;
 		list_for_each_entry_safe(bss, next, &iwm->bss_list, node)
 			if (bss->bss->table_idx == cpu_to_le16(table_idx)) {
 				struct ieee80211_mgmt *mgmt;
 
 				mgmt = (struct ieee80211_mgmt *)
 					(bss->bss->frame_buf);
-				IWM_DBG_MLME(iwm, ERR,
-					     "BSS removed: %pM\n",
+				IWM_DBG_MLME(iwm, ERR, "BSS removed: %pM\n",
 					     mgmt->bssid);
 				list_del(&bss->node);
 				kfree(bss->bss);
diff --git a/drivers/net/wireless/iwmc3200wifi/tx.c b/drivers/net/wireless/iwmc3200wifi/tx.c
index 406615c..a20b936 100644
--- a/drivers/net/wireless/iwmc3200wifi/tx.c
+++ b/drivers/net/wireless/iwmc3200wifi/tx.c
@@ -451,7 +451,6 @@ void iwm_tx_worker(struct work_struct *work)
 int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(netdev);
-	struct net_device *ndev = iwm_to_ndev(iwm);
 	struct wireless_dev *wdev = iwm_to_wdev(iwm);
 	struct iwm_tx_info *tx_info;
 	struct iwm_tx_queue *txq;
@@ -518,12 +517,12 @@ int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 
 	queue_work(iwm->txq[queue].wq, &iwm->txq[queue].worker);
 
-	ndev->stats.tx_packets++;
-	ndev->stats.tx_bytes += skb->len;
+	netdev->stats.tx_packets++;
+	netdev->stats.tx_bytes += skb->len;
 	return NETDEV_TX_OK;
 
  drop:
-	ndev->stats.tx_dropped++;
+	netdev->stats.tx_dropped++;
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/wireless/iwmc3200wifi/umac.h b/drivers/net/wireless/iwmc3200wifi/umac.h
index 7f54a14..0cbba3e 100644
--- a/drivers/net/wireless/iwmc3200wifi/umac.h
+++ b/drivers/net/wireless/iwmc3200wifi/umac.h
@@ -362,7 +362,7 @@ struct iwm_udma_out_wifi_hdr {
 #define IWM_RX_TICKET_SPECIAL_SNAP_MSK    0x4
 #define IWM_RX_TICKET_AMSDU_MSK           0x8
 #define IWM_RX_TICKET_DROP_REASON_POS       4
-#define IWM_RX_TICKET_DROP_REASON_MSK (0x1F << RX_TICKET_FLAGS_DROP_REASON_POS)
+#define IWM_RX_TICKET_DROP_REASON_MSK (0x1F << IWM_RX_TICKET_DROP_REASON_POS)
 
 #define IWM_RX_DROP_NO_DROP                          0x0
 #define IWM_RX_DROP_BAD_CRC                          0x1
-- 
1.6.0.4


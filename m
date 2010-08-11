Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25394 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab0HKOzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 10:55:45 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Aug 2010 07:55:45 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: fix panic on packet injection using airbase-ng tool.
Date: Wed, 11 Aug 2010 20:27:43 +0530
Message-ID: <1281538663-14475-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix the oops which occurs during the packet injection
on monitor interface.

EIP is at ath9k_htc_tx_start+0x69/0x220 [ath9k_htc]
 [<f84dc8ea>] ? invoke_tx_handlers+0xa5a/0xee0 [mac80211]
 [<f82c84f4>] ? ath9k_htc_tx+0x44/0xe0 [ath9k_htc]
 [<f84db7b8>] ? __ieee80211_tx+0xf8/0x190 [mac80211]
 [<f84dce0d>] ? ieee80211_tx+0x9d/0x1a0 [mac80211]
 [<f84dcfac>] ? ieee80211_xmit+0x9c/0x1c0 [mac80211]
 [<f84dd1b5>] ? ieee80211_monitor_start_xmit+0x85/0xb0 [mac80211]
 [<c04c30cd>] ? dev_hard_start_xmit+0x1ad/0x210
 [<c04b97c2>] ? __alloc_skb+0x52/0x130
 [<c04d7cd5>] ? sch_direct_xmit+0x105/0x170
 [<c04c5e9f>] ? dev_queue_xmit+0x37f/0x4b0
 [<c0567e1e>] ? packet_snd+0x21e/0x250
 [<c05684a2>] ? packet_sendmsg+0x32/0x40
 [<c04b4c63>] ? sock_aio_write+0x113/0x130
 [<c0207934>] ? do_sync_write+0xc4/0x100
 [<c0167740>] ? autoremove_wake_function+0x0/0x50
 [<c02f4414>] ? security_file_permission+0x14/0x20
 [<c0207ad4>] ? rw_verify_area+0x64/0xe0
 [<c01e6458>] ? handle_mm_fault+0x338/0x390
 [<c0207cd5>] ? vfs_write+0x185/0x1a0
 [<c058db20>] ? do_page_fault+0x160/0x3a0
 [<c0208512>] ? sys_write+0x42/0x70
 [<c01033ec>] ? syscall_call+0x7/0xb

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bd0b4ac..2a6e45a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -78,18 +78,23 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ath9k_htc_sta *ista;
-	struct ath9k_htc_vif *avp;
 	struct ath9k_htc_tx_ctl tx_ctl;
 	enum htc_endpoint_id epid;
 	u16 qnum;
 	__le16 fc;
 	u8 *tx_fhdr;
-	u8 sta_idx;
+	u8 sta_idx, vif_idx;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	fc = hdr->frame_control;
 
-	avp = (struct ath9k_htc_vif *) tx_info->control.vif->drv_priv;
+	if (tx_info->control.vif &&
+			(struct ath9k_htc_vif *) tx_info->control.vif->drv_priv)
+		vif_idx = ((struct ath9k_htc_vif *)
+				tx_info->control.vif->drv_priv)->index;
+	else
+		vif_idx = priv->nvifs;
+
 	if (sta) {
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
 		sta_idx = ista->index;
@@ -106,7 +111,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		memset(&tx_hdr, 0, sizeof(struct tx_frame_hdr));
 
 		tx_hdr.node_idx = sta_idx;
-		tx_hdr.vif_idx = avp->index;
+		tx_hdr.vif_idx = vif_idx;
 
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			tx_ctl.type = ATH9K_HTC_AMPDU;
@@ -169,7 +174,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		tx_ctl.type = ATH9K_HTC_NORMAL;
 
 		mgmt_hdr.node_idx = sta_idx;
-		mgmt_hdr.vif_idx = avp->index;
+		mgmt_hdr.vif_idx = vif_idx;
 		mgmt_hdr.tidno = 0;
 		mgmt_hdr.flags = 0;
 
-- 
1.7.2.1


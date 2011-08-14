Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1HNKRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:11 -0400
Received: by wwf5 with SMTP id 5so4060970wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:10 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 04/40] wl12xx: temporarily disable advanced ap functions
Date: Sun, 14 Aug 2011 13:17:03 +0300
Message-Id: <1313317059-16567-5-git-send-email-eliad@wizery.com> (sfid-20110814_121715_557616_4534AE93)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to keep to driver compiling during the patchset,
while avoiding one-huge-patch, temporarily disable some
advanced ap functions.

These changes will be reverted later in the patchset, as
part of the patches for advanced ap functions support.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: don't disable 11n

 drivers/net/wireless/wl12xx/main.c |    4 ++++
 drivers/net/wireless/wl12xx/tx.c   |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7b29573..4fa7602 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -770,12 +770,13 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	kfree(wl->target_mem_map);
 	wl->target_mem_map = NULL;
 
 	return ret;
 }
 
+#if 0
 static void wl1271_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_blks)
 {
 	bool fw_ps;
 
 	/* only regulate station links */
 	if (hlid < WL1271_AP_STA_HLID_START)
@@ -820,12 +821,13 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
 		wl->links[hlid].allocated_blks -= cnt;
 
 		wl1271_irq_ps_regulate_link(wl, hlid,
 					    wl->links[hlid].allocated_blks);
 	}
 }
+#endif
 
 static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_full_status *full_status)
 {
 	struct wl1271_fw_common_status *status = &full_status->common;
 	struct timespec ts;
@@ -858,13 +860,15 @@ static void wl1271_fw_status(struct wl1271 *wl,
 	}
 
 	wl->tx_allocated_blocks -= freed_blocks;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		/* Update num of allocated TX blocks per link and ps status */
+#if 0
 		wl1271_irq_update_links_status(wl, &full_status->ap);
+#endif
 		wl->tx_blocks_available += freed_blocks;
 	} else {
 		int avail = full_status->sta.tx_total - wl->tx_allocated_blocks;
 
 		/*
 		 * The FW might change the total number of TX memblocks before
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index c67340f..938af1d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -108,12 +108,13 @@ static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 	hdr = (struct ieee80211_hdr *)(skb->data +
 				       sizeof(struct wl1271_tx_hw_descr));
 	if (ieee80211_is_auth(hdr->frame_control))
 		wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
 }
 
+#if 0
 static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 {
 	bool fw_ps;
 	u8 tx_blks;
 
 	/* only regulate station links */
@@ -127,12 +128,13 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 	 * if in FW PS and there is enough data in FW we can put the link
 	 * into high-level PS and clean out its TX queues.
 	 */
 	if (fw_ps && tx_blks >= WL1271_PS_STA_MAX_BLOCKS)
 		wl1271_ps_link_start(wl, hlid, true);
 }
+#endif
 
 u8 wl1271_tx_get_hlid(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
 
 	if (control->control.sta) {
@@ -381,13 +383,15 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 		return ret;
 
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
+#if 0
 		wl1271_tx_regulate_link(wl, hlid);
+#endif
 	} else {
 		wl1271_tx_update_filters(wl, skb);
 	}
 
 	/*
 	 * The length of each packet is stored in terms of
-- 
1.7.6.401.g6a319


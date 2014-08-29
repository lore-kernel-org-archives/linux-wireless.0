Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:47758 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaH2J24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 05:28:56 -0400
Received: by mail-lb0-f180.google.com with SMTP id w7so2231747lbi.25
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2014 02:28:54 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: don't access tx_info while overwriting it
Date: Fri, 29 Aug 2014 11:19:03 +0200
Message-Id: <1409303943-1452-1-git-send-email-michal.kazior@tieto.com> (sfid-20140829_112859_700795_A97C3DC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nothing important was being overwritten so it
didn't yield any bugs yet.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b858c82..cdadfef 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1863,11 +1863,10 @@ static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
 	return ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 }
 
-static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
-				  struct ieee80211_tx_info *info)
+static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar, struct ieee80211_vif *vif)
 {
-	if (info->control.vif)
-		return ath10k_vif_to_arvif(info->control.vif)->vdev_id;
+	if (vif)
+		return ath10k_vif_to_arvif(vif)->vdev_id;
 
 	if (ar->monitor_started)
 		return ar->monitor_vdev_id;
@@ -2323,7 +2322,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
-	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, info);
+	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 
 	/* it makes no sense to process injected frames like that */
 	if (vif && vif->type != NL80211_IFTYPE_MONITOR) {
-- 
1.8.5.3


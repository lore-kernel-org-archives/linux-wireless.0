Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34618 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdALO1S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:27:18 -0500
Received: by mail-lf0-f53.google.com with SMTP id v186so14091000lfa.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 06:27:17 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        mohammed@qti.qualcomm.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: prevent skb/txq mismatch
Date: Thu, 12 Jan 2017 15:28:41 +0100
Message-Id: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com> (sfid-20170112_152721_701014_6C9D03BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Station structure is considered as not uploaded
(to driver) until drv_sta_state() finishes. This
call is however done after the structure is
attached to mac80211 internal lists and hashes.
This means mac80211 can lookup (and use) station
structure before it is uploaded to a driver.

If this happens (structure exists, but
sta->uploaded is false) fast_tx path can still be
taken. Deep in the fastpath call the sta->uploaded
is checked against to derive "pubsta" argument for
ieee80211_get_txq(). If sta->uploaded is false
(and sta is actually non-NULL) ieee80211_get_txq()
effectively downgraded to vif->txq.

At first glance this may look innocent but coerces
mac80211 into a state that is almost guaranteed
(codel may drop offending skb) to crash because a
station-oriented skb gets queued up on
vif-oriented txq. The ieee80211_tx_dequeue() ends
up looking at info->control.flags and tries to use
txq->sta which in the fail case is NULL.

It's probably pointless to pretend one can
downgrade skb from sta-txq to vif-txq.

Only drivers using wake_tx_queue were affected.

Example crash dump before fix:

 Unable to handle kernel paging request at virtual address ffffe26c
 PC is at ieee80211_tx_dequeue+0x204/0x690 [mac80211]
 [<bf4252a4>] (ieee80211_tx_dequeue [mac80211]) from
 [<bf4b1388>] (ath10k_mac_tx_push_txq+0x54/0x1c0 [ath10k_core])
 [<bf4b1388>] (ath10k_mac_tx_push_txq [ath10k_core]) from
 [<bf4bdfbc>] (ath10k_htt_txrx_compl_task+0xd78/0x11d0 [ath10k_core])
 [<bf4bdfbc>] (ath10k_htt_txrx_compl_task [ath10k_core])
 [<bf51c5a4>] (ath10k_pci_napi_poll+0x54/0xe8 [ath10k_pci])
 [<bf51c5a4>] (ath10k_pci_napi_poll [ath10k_pci]) from
 [<c0572e90>] (net_rx_action+0xac/0x160)

Reported-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/tx.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4dea18be385c..c77fcf83d004 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1244,13 +1244,16 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 
 static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 					  struct ieee80211_vif *vif,
-					  struct ieee80211_sta *pubsta,
+					  struct sta_info *sta,
 					  struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_txq *txq = NULL;
 
+	if (sta && !sta->uploaded)
+		return NULL;
+
 	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
@@ -1258,10 +1261,10 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	if (!ieee80211_is_data(hdr->frame_control))
 		return NULL;
 
-	if (pubsta) {
+	if (sta) {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
-		txq = pubsta->txq[tid];
+		txq = sta->sta.txq[tid];
 	} else if (vif) {
 		txq = vif->txq;
 	}
@@ -1504,23 +1507,17 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	struct fq *fq = &local->fq;
 	struct ieee80211_vif *vif;
 	struct txq_info *txqi;
-	struct ieee80211_sta *pubsta;
 
 	if (!local->ops->wake_tx_queue ||
 	    sdata->vif.type == NL80211_IFTYPE_MONITOR)
 		return false;
 
-	if (sta && sta->uploaded)
-		pubsta = &sta->sta;
-	else
-		pubsta = NULL;
-
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
 
 	vif = &sdata->vif;
-	txqi = ieee80211_get_txq(local, vif, pubsta, skb);
+	txqi = ieee80211_get_txq(local, vif, sta, skb);
 
 	if (!txqi)
 		return false;
-- 
2.1.4

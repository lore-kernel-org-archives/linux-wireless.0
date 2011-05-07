Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39986 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab1EGJVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 05:21:45 -0400
Received: by fxm17 with SMTP id 17so2791461fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 02:21:42 -0700 (PDT)
Message-Id: <882b3dbce3a3c6fa33ce02130d6bbf5fee348dfb.1304759993.git.chunkeey@googlemail.com> (sfid-20110507_112202_656629_C7499628)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 7 May 2011 11:13:37 +0200
Subject: [PATCH 1/2] carl9170: fix -Wunused-but-set-variable warnings
MIME-Version: 1.0
Content-Type: text/plain;
  charset=UTF-8
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx.c: In function ‘carl9170_tx_accounting_free’:
tx.c:159:28: warning: variable ‘txinfo’ set but not used
tx.c: In function ‘carl9170_tx_status_process_ampdu’:
tx.c:383:27: warning: variable ‘ar_info’ set but not used
tx.c: In function ‘__carl9170_tx_process_status’:
tx.c:626:27: warning: variable ‘arinfo’ set but not used
tx.c: In function ‘carl9170_tx_ampdu_queue’:
tx.c:1324:15: warning: variable ‘max’ set but not used

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index bf2eff9..e94084f 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -156,10 +156,8 @@ out_rcu:
 
 static void carl9170_tx_accounting_free(struct ar9170 *ar, struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *txinfo;
 	int queue;
 
-	txinfo = IEEE80211_SKB_CB(skb);
 	queue = skb_get_queue_mapping(skb);
 
 	spin_lock_bh(&ar->tx_stats_lock);
@@ -380,7 +378,6 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 {
 	struct _carl9170_tx_superframe *super = (void *) skb->data;
 	struct ieee80211_hdr *hdr = (void *) super->frame_data;
-	struct carl9170_tx_info *ar_info;
 	struct ieee80211_sta *sta;
 	struct carl9170_sta_info *sta_info;
 	struct carl9170_sta_tid *tid_info;
@@ -391,8 +388,6 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 	   (!(super->f.mac_control & cpu_to_le16(AR9170_TX_MAC_AGGR))))
 		return;
 
-	ar_info = (void *) txinfo->rate_driver_data;
-
 	rcu_read_lock();
 	sta = __carl9170_get_tx_sta(ar, skb);
 	if (unlikely(!sta))
@@ -623,7 +618,6 @@ static void __carl9170_tx_process_status(struct ar9170 *ar,
 {
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *txinfo;
-	struct carl9170_tx_info *arinfo;
 	unsigned int r, t, q;
 	bool success = true;
 
@@ -639,7 +633,6 @@ static void __carl9170_tx_process_status(struct ar9170 *ar,
 	}
 
 	txinfo = IEEE80211_SKB_CB(skb);
-	arinfo = (void *) txinfo->rate_driver_data;
 
 	if (!(info & CARL9170_TX_STATUS_SUCCESS))
 		success = false;
@@ -1321,7 +1314,6 @@ static bool carl9170_tx_ampdu_queue(struct ar9170 *ar,
 	struct carl9170_sta_info *sta_info;
 	struct carl9170_sta_tid *agg;
 	struct sk_buff *iter;
-	unsigned int max;
 	u16 tid, seq, qseq, off;
 	bool run = false;
 
@@ -1331,7 +1323,6 @@ static bool carl9170_tx_ampdu_queue(struct ar9170 *ar,
 
 	rcu_read_lock();
 	agg = rcu_dereference(sta_info->agg[tid]);
-	max = sta_info->ampdu_max_len;
 
 	if (!agg)
 		goto err_unlock_rcu;
-- 
1.7.5.1


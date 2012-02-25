Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59382 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2B0PGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:06:13 -0500
Received: by bkcik5 with SMTP id ik5so325975bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 07:06:12 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 25 Feb 2012 21:36:36 +0100
Subject: [PATCH -wt] carl9170: fix frame delivery if sta is in powersave mode
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Nicolas.Cavallari@lri.fr
Message-Id: <20120227150559.10F46100171@blech.mobile> (sfid-20120227_160617_466308_947BBE12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Cavallari discovered that carl9170 has some
serious problems delivering data to sleeping stations.

It turns out that the driver was not honoring two
important flags (IEEE80211_TX_CTL_NO_PS_BUFFER and
IEEE80211_TX_CTL_CLEAR_PS_FILT) which are set on
frames that should be sent although the receiving
station is still in powersave mode.

Reported-by: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
John, to make your life a little bit easier, I rebased my
patch on top of Johannes' 
[PATCH] mac80211: handle non-bufferable MMPDUs correctly.

changes:
	IEEE80211_TX_CTL_POLL_RESPONSE was renamed to
	IEEE80211_TX_CTL_NO_PS_BUFFER (johannes patch)
---
 drivers/net/wireless/ath/carl9170/tx.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 8d52ddd..aed3051 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1236,6 +1236,7 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_sta *sta;
 	struct carl9170_sta_info *sta_info;
+	struct ieee80211_tx_info *tx_info;
 
 	rcu_read_lock();
 	sta = __carl9170_get_tx_sta(ar, skb);
@@ -1243,12 +1244,13 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
 		goto out_rcu;
 
 	sta_info = (void *) sta->drv_priv;
-	if (unlikely(sta_info->sleeping)) {
-		struct ieee80211_tx_info *tx_info;
+	tx_info = IEEE80211_SKB_CB(skb);
 
+	if (unlikely(sta_info->sleeping) &&
+	    !(tx_info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
+				IEEE80211_TX_CTL_CLEAR_PS_FILT))) {
 		rcu_read_unlock();
 
-		tx_info = IEEE80211_SKB_CB(skb);
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
 			atomic_dec(&ar->tx_ampdu_upload);
 
-- 
1.7.9.1


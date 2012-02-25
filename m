Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44898 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2BYUgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 15:36:42 -0500
Received: by eekc41 with SMTP id c41so190293eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Feb 2012 12:36:40 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: [PATCH -stable] carl9170: fix frame delivery if sta is in powersave mode
Date: Sat, 25 Feb 2012 21:36:36 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr> <201202231752.44125.chunkeey@googlemail.com> <4F46771F.9000200@lri.fr>
In-Reply-To: <4F46771F.9000200@lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201202252136.37255.chunkeey@googlemail.com> (sfid-20120225_213645_792074_50D94329)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Cavallari discovered that carl9170 has some
serious problems delivering data to sleeping stations.

It turns out that the driver was not honoring two
important flags (IEEE80211_TX_CTL_POLL_RESPONSE and
IEEE80211_TX_CTL_CLEAR_PS_FILT) which are set on
frames that should be sent although the receiving
station is still in powersave mode.

Cc: stable <stable@vger.kernel.org>
Reported-by: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
> Part of the reason i wrote this, is because, while this patch fixes the
> memory accounting problem and prevent the AP from stopping working, the
> powersaving station sometimes cannot communicate with the AP anymore
> (other stations can). The station uses ath9k, and is just really doing a
> background scan. The first traces that i have just indicate that the
> station entered powersave mode, then sends probe requests and probe
> requests directed to the AP, then sends authentication requests to the
> AP (?), but the AP does not respond to any of them...
>
Ok, I think this patch [on top of yours] should fix the problem.
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 771e1a9..0f00721 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1236,6 +1236,7 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_sta *sta;
 	struct carl9170_sta_info *sta_info;
+	struct ieee80211_tx_info *tx_info;
 
 	rcu_read_lock();
 	sta = __carl9170_get_tx_sta(ar, skb);
@@ -1243,17 +1244,18 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
 		goto out_rcu;
 
 	sta_info = (void *) sta->drv_priv;
-	if (unlikely(sta_info->sleeping)) {
-		struct ieee80211_tx_info *tx_info;
+	tx_info = IEEE80211_SKB_CB(skb);
 
+	if (unlikely(sta_info->sleeping) &&
+	    !(tx_info->flags & (IEEE80211_TX_CTL_POLL_RESPONSE |
+				IEEE80211_TX_CTL_CLEAR_PS_FILT))) {
 		rcu_read_unlock();
 
-		tx_info = IEEE80211_SKB_CB(skb);
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
 			atomic_dec(&ar->tx_ampdu_upload);
 
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 		carl9170_release_dev_space(ar, skb);
 		carl9170_tx_status(ar, skb, false);
 		return true;
 	}

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33610 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2B2URC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 15:17:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] carl9170: fix breakage from "mac80211: handle non-bufferable MMPDUs correctly"
Date: Wed, 29 Feb 2012 15:11:45 -0500
Message-Id: <1330546305-26773-1-git-send-email-linville@tuxdriver.com> (sfid-20120229_211710_789404_8C6CE13B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That commit intended for 3.4 renamed IEEE80211_TX_CTL_POLL_RESPONSE as
IEEE80211_TX_CTL_NO_PS_BUFFER.  Meanwhile, "carl9170: fix frame delivery
if sta is in powersave mode" added a reference to
IEEE80211_TX_CTL_POLL_RESPONSE in the fixes stream for 3.3.  This simple
patch fixes that merge boo-boo.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/carl9170/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 0f00721..aed3051 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1247,7 +1247,7 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
 	tx_info = IEEE80211_SKB_CB(skb);
 
 	if (unlikely(sta_info->sleeping) &&
-	    !(tx_info->flags & (IEEE80211_TX_CTL_POLL_RESPONSE |
+	    !(tx_info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
 				IEEE80211_TX_CTL_CLEAR_PS_FILT))) {
 		rcu_read_unlock();
 
-- 
1.7.4.4


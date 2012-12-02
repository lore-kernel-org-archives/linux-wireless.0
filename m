Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34399 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2LBKmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 05:42:49 -0500
Date: Sun, 2 Dec 2012 13:42:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] carl9170: remove unneeded NULL check
Message-ID: <20121202104238.GB16078@elgon.mountain> (sfid-20121202_114253_888155_3E54C982)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "sta" variable is not checked for NULL consistently and it makes the
static checkers complain.  I asked Christian Lamparter about this and
it turns out the check is not needed.  "In fact, in order to set up a
ampdu session, the stack would call the driver's op_ampdu_action
callback which always needs a station."

I have removed the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 84377cf..23d33c3 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1463,6 +1463,7 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sta *sta = control->sta;
+	struct carl9170_sta_info *stai;
 	bool run;
 
 	if (unlikely(!IS_STARTED(ar)))
@@ -1479,10 +1480,8 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 	 * all ressouces which are associated with the frame.
 	 */
 
-	if (sta) {
-		struct carl9170_sta_info *stai = (void *) sta->drv_priv;
-		atomic_inc(&stai->pending_frames);
-	}
+	stai = (void *) sta->drv_priv;
+	atomic_inc(&stai->pending_frames);
 
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 		run = carl9170_tx_ampdu_queue(ar, sta, skb);

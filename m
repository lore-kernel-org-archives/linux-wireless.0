Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45794 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYJ0RRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 13:17:31 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 10:17:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: use ETH_P_PAE
Date: Mon, 27 Oct 2008 10:17:29 -0700
Message-ID: <1225127849-15188-1-git-send-email-lrodriguez@atheros.com> (sfid-20081027_181736_160590_45935B15)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was being discussed where we would put this, but now it found a home
so use its define.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index ec5ae30..f7fd34b 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -177,8 +177,8 @@ static void fill_min_rates(struct sk_buff *skb, struct ath_tx_control *txctl)
 		txctl->min_rate = tx_info_priv->min_rate;
 	} else if (ieee80211_is_data(fc)) {
 		if (ieee80211_is_nullfunc(fc) ||
-			/* Port Access Entity (IEEE 802.1X) */
-			(skb->protocol == cpu_to_be16(0x888E))) {
+				/* Port Access Entity (IEEE 802.1X) */
+				(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 			txctl->use_minrate = 1;
 			txctl->min_rate = tx_info_priv->min_rate;
 		}
-- 
1.5.6.rc2.15.g457bb.dirty


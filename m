Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:54768 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab2BWPxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 10:53:46 -0500
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: chunkeey@googlemail.com, linux-wireless@vger.kernel.org
Subject: [RFC] carl9170: Fix memory accounting when sta is in power-save mode.
Date: Thu, 23 Feb 2012 16:53:34 +0100
Message-Id: <1330012414-26559-1-git-send-email-cavallar@lri.fr> (sfid-20120223_165349_593726_E38FA373)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Access Point mode, when transmitting a packet, if the destination
station is in powersave mode, we abort transmitting the packet to the
device queue, but we do not reclaim the allocated memory.  Given enough
packets, we can go in a state where there is no packet on the device
queue, but we think the device has no memory left, so no packet gets
transmitted, connections breaks and the AP stops working.

This undo the allocation done in the TX path when the station is in
power-save mode.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
While this seems to fix my problem, there could still be problems remaining
in this code path.  Particularly, carl9170_tx_status will do lots of things
like incrementing counters and waking up mac80211 queues...

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 771e1a9..8d52ddd 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1253,6 +1253,7 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
 			atomic_dec(&ar->tx_ampdu_upload);
 
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+		carl9170_release_dev_space(ar, skb);
 		carl9170_tx_status(ar, skb, false);
 		return true;
 	}
-- 
1.7.9


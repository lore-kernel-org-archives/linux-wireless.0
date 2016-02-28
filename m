Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46020 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbcB1OT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 09:19:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix AP buffered multicast frames with queue control and txq
Date: Sun, 28 Feb 2016 15:19:53 +0100
Message-Id: <1456669193-56860-1-git-send-email-nbd@openwrt.org> (sfid-20160228_152001_754897_D993D9CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Buffered multicast frames must be passed to the driver directly via
drv_tx instead of going through the txq, otherwise they cannot easily be
scheduled to be sent after DTIM.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a7475f..b294820 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1247,7 +1247,8 @@ static void ieee80211_drv_tx(struct ieee80211_local *local,
 	struct txq_info *txqi;
 	u8 ac;
 
-	if (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)
+	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
+	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		goto tx_normal;
 
 	if (!ieee80211_is_data(hdr->frame_control))
-- 
2.2.2


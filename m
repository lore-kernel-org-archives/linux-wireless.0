Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34808 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbcAUNWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:22:00 -0500
Received: by mail-lb0-f174.google.com with SMTP id cl12so23080537lbc.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:21:59 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] mac80211: fix txq queue related crashes
Date: Thu, 21 Jan 2016 14:23:07 +0100
Message-Id: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com> (sfid-20160121_142203_456286_FD7808D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver can access the queue simultanously
while mac80211 tears down the interface. Without
spinlock protection this could lead to corrupting
sk_buff_head and subsequently to an invalid
pointer dereference.

Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 33ae3c81bfc5..0451f120746e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -977,7 +977,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.txq) {
 		struct txq_info *txqi = to_txq_info(sdata->vif.txq);
 
+		spin_lock_bh(&txqi->queue.lock);
 		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
+		spin_unlock_bh(&txqi->queue.lock);
+
 		atomic_set(&sdata->txqs_len[txqi->txq.ac], 0);
 	}
 
-- 
2.1.4


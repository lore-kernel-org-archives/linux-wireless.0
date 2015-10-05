Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:33309
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbbJEWQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 18:16:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: add missing struct ieee80211_txq tid field initialization
Date: Tue,  6 Oct 2015 00:16:53 +0200
Message-Id: <1444083413-39885-1-git-send-email-nbd@openwrt.org> (sfid-20151006_001703_706442_A1E938CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 60c4dbf..fb6e511 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3301,9 +3301,11 @@ void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		txqi->txq.sta = &sta->sta;
 		sta->sta.txq[tid] = &txqi->txq;
+		txqi->txq.tid = tid;
 		txqi->txq.ac = ieee802_1d_to_ac[tid & 7];
 	} else {
 		sdata->vif.txq = &txqi->txq;
+		txqi->txq.tid = 0;
 		txqi->txq.ac = IEEE80211_AC_BE;
 	}
 }
-- 
2.2.2


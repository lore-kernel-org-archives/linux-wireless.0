Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:42038
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753148AbbIXM74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 08:59:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 4.3 1/2] mac80211: fix tx sequence number assignment with software queue + fast-xmit
Date: Thu, 24 Sep 2015 14:59:48 +0200
Message-Id: <1443099589-69793-1-git-send-email-nbd@openwrt.org> (sfid-20150924_145959_372488_3B4C55F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using software queueing, tx sequence number assignment happens at
ieee80211_tx_dequeue time, so the fast-xmit codepath must not do that.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 84e0e8c..af058eb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2767,7 +2767,8 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		*ieee80211_get_qos_ctl(hdr) = tid;
-		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
+		if (!sta->sta.txq[0])
+			hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
 	} else {
 		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(sdata->sequence_number);
-- 
2.2.2


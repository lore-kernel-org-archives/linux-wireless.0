Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:57259 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab2CPOa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 10:30:59 -0400
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH] mac80211: end service period only after sending last buffered frame
Date: Fri, 16 Mar 2012 15:30:26 +0100
Message-Id: <1331908226-6694-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20120316_153104_695060_A088C5D3)
In-Reply-To: <1331905240.6753.14.camel@jlt3.sipsolutions.net>
References: <1331905240.6753.14.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/sta_info.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f468eb1..9b63cd7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1257,13 +1257,15 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			    ieee80211_is_qos_nullfunc(hdr->frame_control))
 				qoshdr = ieee80211_get_qos_ctl(hdr);
 
-			/* set EOSP for the frame */
-			if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
-			    qoshdr && skb_queue_empty(&frames))
-				*qoshdr |= IEEE80211_QOS_CTL_EOSP;
-
-			info->flags |= IEEE80211_TX_STATUS_EOSP |
-				       IEEE80211_TX_CTL_REQ_TX_STATUS;
+			/* end service period after last frame */
+			if (skb_queue_empty(&frames)) {
+				if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
+				    qoshdr)
+					*qoshdr |= IEEE80211_QOS_CTL_EOSP;
+
+				info->flags |= IEEE80211_TX_STATUS_EOSP |
+					       IEEE80211_TX_CTL_REQ_TX_STATUS;
+			}
 
 			if (qoshdr)
 				tids |= BIT(*qoshdr & IEEE80211_QOS_CTL_TID_MASK);
-- 
1.7.5.4


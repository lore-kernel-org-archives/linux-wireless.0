Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:40752 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbYDATpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 15:45:20 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 5D514D722D50
	for <linux-wireless@vger.kernel.org>; Tue,  1 Apr 2008 21:45:19 +0200 (CEST)
Received: from [91.22.247.48] (helo=debian64.daheim)
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1JgmQ3-0002oF-00
	for linux-wireless@vger.kernel.org; Tue, 01 Apr 2008 21:45:19 +0200
Received: from localhost ([127.0.0.1] ident=chuck)
	by debian64.daheim with esmtpa (Exim 4.69)
	(envelope-from <chunkeey@web.de>)
	id 1JgmQ2-00025z-P5
	for linux-wireless@vger.kernel.org; Tue, 01 Apr 2008 21:45:18 +0200
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: add station aid into ieee80211_tx_control
Date: Tue, 1 Apr 2008 21:45:18 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ODp8H+47GzjqeFw"
Message-Id: <200804012145.18294.chunkeey@web.de> (sfid-20080401_204526_683133_262D4EC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_ODp8H+47GzjqeFw
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch is necessary for the upcoming Accesspoint patch for p54.

Signed-off-by: Christian Lamparter <chunkeey@web.de>

--Boundary-00=_ODp8H+47GzjqeFw
Content-Type: text/x-diff;
  charset="us-ascii";
  name="mac80211-station-aid-in-tx-control.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mac80211-station-aid-in-tx-control.diff"

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 48428a6..b428472 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -287,6 +287,7 @@ struct ieee80211_tx_control {
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 queue;		/* hardware queue to use for this frame;
 				 * 0 = highest, hw->queues-1 = lowest */
+	u16 aid;		/* Station AID */
 	int type;	/* internal */
 };
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 80f4343..ea3fa0f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -741,6 +741,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 	}
 
 	if (tx->sta) {
+		control->aid = tx->sta->aid;
 		tx->sta->tx_packets++;
 		tx->sta->tx_fragments++;
 		tx->sta->tx_bytes += tx->skb->len;

--Boundary-00=_ODp8H+47GzjqeFw--

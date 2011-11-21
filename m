Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:60237 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1KUUfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 15:35:01 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH] mac80211: fix duration calculation for QoS NOACK frames
Date: Mon, 21 Nov 2011 21:34:30 +0100
Message-Id: <1321907670-22247-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111121_213506_322618_BB4BEAB5)
In-Reply-To: <1321622446-2477-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321622446-2477-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/tx.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f632690..8b8952a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -150,11 +150,15 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 		rate = mrate;
 	}
 
-	/* Time needed to transmit ACK
-	 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
-	 * to closest integer */
-
-	dur = ieee80211_frame_duration(local, 10, rate, erp,
+	/* Don't calculate ACKs for QoS Frames with NoAck Policy set */
+	if (ieee80211_is_data_qos(hdr->frame_control) &&
+	    *(ieee80211_get_qos_ctl(hdr)) | IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
+		dur = 0;
+	else
+		/* Time needed to transmit ACK
+		 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
+		 * to closest integer */
+		dur = ieee80211_frame_duration(local, 10, rate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 
 	if (next_frag_len) {
-- 
1.7.7.3


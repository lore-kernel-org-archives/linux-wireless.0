Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.uniroma2.it ([160.80.6.23]:33869 "EHLO smtp.uniroma2.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab2E1MZw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 08:25:52 -0400
From: Claudio Pisa <claudio.pisa@uniroma2.it>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix flag check for QoS NOACK frames
Date: Mon, 28 May 2012 13:06:25 +0100
Message-Id: <1338206785-3222-1-git-send-email-claudio.pisa@uniroma2.it> (sfid-20120528_142556_354416_E63A45FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Claudio Pisa <claudio.pisa@uniroma2.it>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d67d36f..cb17497 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -153,7 +153,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 
 	/* Don't calculate ACKs for QoS Frames with NoAck Policy set */
 	if (ieee80211_is_data_qos(hdr->frame_control) &&
-	    *(ieee80211_get_qos_ctl(hdr)) | IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
+	    *(ieee80211_get_qos_ctl(hdr)) & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
 		dur = 0;
 	else
 		/* Time needed to transmit ACK
-- 
1.7.10.1


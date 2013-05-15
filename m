Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40283 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab3EOOTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:37 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 14/18] ath9k: report 5/10 MHz channels
Date: Wed, 15 May 2013 16:19:05 +0200
Message-Id: <1368627549-22518-15-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_161944_384279_DF55332C)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/recv.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 9e7c929..697d7f2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -872,6 +872,17 @@ static int ath9k_process_rate(struct ath_common *common,
 					   &bitrates, &n_bitrates)))
 		return 0;
 
+	switch (hw->conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+		rxs->flag |= RX_FLAG_5MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		rxs->flag |= RX_FLAG_10MHZ;
+		break;
+	default:
+		break;
+	}
+
 	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
 		rxs->flag |= RX_FLAG_HT;
-- 
1.7.10.4


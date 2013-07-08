Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38356 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3GHO4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:56:21 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 13/18] ath9k: report 5/10 MHz channels
Date: Mon,  8 Jul 2013 16:56:01 +0200
Message-Id: <1373295366-12823-14-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_165629_652944_006E879B)
In-Reply-To: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/recv.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 865e043..0b0bc9d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -865,6 +865,17 @@ static int ath9k_process_rate(struct ath_common *common,
 	band = hw->conf.chandef.chan->band;
 	sband = hw->wiphy->bands[band];
 
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


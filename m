Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19930 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaLRSN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 13:13:56 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: set phymode to 11b when NO_OFDM flag set
Date: Thu, 18 Dec 2014 10:13:00 -0800
Message-ID: <1418926380-22206-1-git-send-email-poh@qca.qualcomm.com> (sfid-20141218_191400_601410_DAFD66E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

phymode should use 11b only if NO_OFDM flags is set.
Hence check up channel flag for NO_OFDM and set to
11b.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 42f6a4d..c68beac 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -269,7 +269,10 @@ chan_to_phymode(const struct cfg80211_chan_def *chandef)
 	case IEEE80211_BAND_2GHZ:
 		switch (chandef->width) {
 		case NL80211_CHAN_WIDTH_20_NOHT:
-			phymode = MODE_11G;
+			if (chandef->chan->flags & IEEE80211_CHAN_NO_OFDM)
+				phymode = MODE_11B;
+			else
+				phymode = MODE_11G;
 			break;
 		case NL80211_CHAN_WIDTH_20:
 			phymode = MODE_11NG_HT20;
-- 
1.9.1


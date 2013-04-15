Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52915 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3DOPOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 11:14:11 -0400
Received: by mail-wi0-f180.google.com with SMTP id c10so1665818wiw.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 08:14:10 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 2/2] mac80211_hwsim: handle VHT rates in rx_status
Date: Mon, 15 Apr 2013 17:09:30 +0200
Message-Id: <1366038570-12457-2-git-send-email-karl.beldan@gmail.com> (sfid-20130415_171420_258504_F1948F3E)
In-Reply-To: <1366038570-12457-1-git-send-email-karl.beldan@gmail.com>
References: <1366038570-12457-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b5117f5..7ede240 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -718,9 +718,17 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	rx_status.flag |= RX_FLAG_MACTIME_START;
 	rx_status.freq = chan->center_freq;
 	rx_status.band = chan->band;
-	rx_status.rate_idx = info->control.rates[0].idx;
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
-		rx_status.flag |= RX_FLAG_HT;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_VHT_MCS) {
+		rx_status.rate_idx =
+			ieee80211_rate_get_vht_mcs(&info->control.rates[0]);
+		rx_status.vht_nss =
+			ieee80211_rate_get_vht_nss(&info->control.rates[0]);
+		rx_status.flag |= RX_FLAG_VHT;
+	} else {
+		rx_status.rate_idx = info->control.rates[0].idx;
+		if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
+			rx_status.flag |= RX_FLAG_HT;
+	}
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		rx_status.flag |= RX_FLAG_40MHZ;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
-- 
1.8.2


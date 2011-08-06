Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:39337 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab1HFUHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 16:07:17 -0400
Date: Sat, 6 Aug 2011 23:07:00 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Fix RX status reporting for HT
Message-ID: <20110806200700.GA13221@jm.kir.nu> (sfid-20110806_220724_927097_CF02E140)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX_FLAG_HT must be included when reporting MCS rates. Without
this, mac80211 ended up dropping any frame sent at MCS index 12
or higher and that resulted in oddly random looking errors in
mac80211_hwsim tests.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 drivers/net/wireless/mac80211_hwsim.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 031cd89..34b79fc 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -612,6 +612,12 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	rx_status.freq = data->channel->center_freq;
 	rx_status.band = data->channel->band;
 	rx_status.rate_idx = info->control.rates[0].idx;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
+		rx_status.flag |= RX_FLAG_HT;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		rx_status.flag |= RX_FLAG_40MHZ;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+		rx_status.flag |= RX_FLAG_SHORT_GI;
 	/* TODO: simulate real signal strength (and optional packet loss) */
 	rx_status.signal = data->power_level - 50;
 
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA

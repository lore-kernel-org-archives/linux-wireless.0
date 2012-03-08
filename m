Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47671 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2CHR1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 12:27:46 -0500
Received: by yhmm54 with SMTP id m54so369057yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 09:27:45 -0800 (PST)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH] mac80211_hwsim: Fix set mactime on receiver hwsim radio
Date: Thu,  8 Mar 2012 09:27:34 -0800
Message-Id: <1331227654-27575-1-git-send-email-ashok@cozybit.com> (sfid-20120308_182805_160369_B023B5CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211_hwsim:  Add tsf to beacons, probe responses and radiotap
header" was setting the mactime on wrong hwsim radio. This patch fixes it.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b4f6cb3..b7ce6a6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -639,7 +639,6 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	}
 
 	memset(&rx_status, 0, sizeof(rx_status));
-	rx_status.mactime = le64_to_cpu(__mac80211_hwsim_get_tsf(data));
 	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
 	rx_status.freq = data->channel->center_freq;
 	rx_status.band = data->channel->band;
@@ -684,6 +683,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 
 		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
 			ack = true;
+		rx_status.mactime =
+			le64_to_cpu(__mac80211_hwsim_get_tsf(data2));
 		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
 		ieee80211_rx_irqsafe(data2->hw, nskb);
 	}
-- 
1.7.5.4


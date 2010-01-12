Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58840 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0ALMs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:48:57 -0500
Date: Tue, 12 Jan 2010 13:48:56 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 09/17] mwl8k: properly set receive status rate index on 5 GHz receive
Message-ID: <20100112124856.GY1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mwl8k firmware uses indices into the 2.4 GHz band rate table for
the receive descriptor channel field even if the packet was received
on a 5 GHz channel, while mac80211 expects an index into the 5 GHz
band rate table when packets are received on the 5 GHz band, which
presents a mismatch as the 5 GHz band rate table lacks the five
non-OFDM rates that the 2.4 GHz rate table starts with.

To handle this properly, we need to substract 5 from the rate index
field if the packet was received on a 5 GHz channel (and was not
received at an MCS rate).

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 13dded4..cc2ce61 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -759,7 +759,13 @@ mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 		}
 	}
 
-	status->band = IEEE80211_BAND_2GHZ;
+	if (rxd->channel > 14) {
+		status->band = IEEE80211_BAND_5GHZ;
+		if (!(status->flag & RX_FLAG_HT))
+			status->rate_idx -= 5;
+	} else {
+		status->band = IEEE80211_BAND_2GHZ;
+	}
 	status->freq = ieee80211_channel_to_frequency(rxd->channel);
 
 	*qos = rxd->qos_control;
@@ -850,7 +856,13 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 	if (rate_info & MWL8K_STA_RATE_INFO_MCS_FORMAT)
 		status->flag |= RX_FLAG_HT;
 
-	status->band = IEEE80211_BAND_2GHZ;
+	if (rxd->channel > 14) {
+		status->band = IEEE80211_BAND_5GHZ;
+		if (!(status->flag & RX_FLAG_HT))
+			status->rate_idx -= 5;
+	} else {
+		status->band = IEEE80211_BAND_2GHZ;
+	}
 	status->freq = ieee80211_channel_to_frequency(rxd->channel);
 
 	*qos = rxd->qos_control;
-- 
1.5.6.4

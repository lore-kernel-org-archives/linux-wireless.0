Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1828 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3BEJsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 04:48:39 -0500
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] ath6kl: provide 64-bit per-station byte counters
Date: Tue, 5 Feb 2013 11:48:34 +0200
Message-ID: <2048635.6ZmWB80Td6@lx-vladimir> (sfid-20130205_104850_199818_135BE6C7)
In-Reply-To: <1359978792-7121-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1359978792-7121-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 04, 2013 01:53:12 PM Vladimir Kondratiev wrote:
> Internally, 64-bit byte counters maintained for per-station
> statistics. Tell to the netlink that full 64-bit value provided
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---

With changes by Johannes, this patch need to be updated.
It becomes a bit smaller :) Patch follows. Please use this one.




>From 9cdc3aa790fb469ae60671796b2391465d5640c4 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 5 Feb 2013 11:44:48 +0200
Subject: [PATCH] ath6kl: provide 64-bit per-station byte counters

Internally, 64-bit byte counters maintained for per-station
statistics. Tell to the netlink that full 64-bit value provided

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4225cca..259c433 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1778,14 +1778,14 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->target_stats.rx_byte) {
 		sinfo->rx_bytes = vif->target_stats.rx_byte;
-		sinfo->filled |= STATION_INFO_RX_BYTES;
+		sinfo->filled |= STATION_INFO_RX_BYTES64;
 		sinfo->rx_packets = vif->target_stats.rx_pkt;
 		sinfo->filled |= STATION_INFO_RX_PACKETS;
 	}
 
 	if (vif->target_stats.tx_byte) {
 		sinfo->tx_bytes = vif->target_stats.tx_byte;
-		sinfo->filled |= STATION_INFO_TX_BYTES;
+		sinfo->filled |= STATION_INFO_TX_BYTES64;
 		sinfo->tx_packets = vif->target_stats.tx_pkt;
 		sinfo->filled |= STATION_INFO_TX_PACKETS;
 	}
-- 
1.7.10.4



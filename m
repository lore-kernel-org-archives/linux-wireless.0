Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25944 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3BDLx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 06:53:29 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/2] ath6kl: provide 64-bit per-station byte counters
Date: Mon, 4 Feb 2013 13:53:12 +0200
Message-ID: <1359978792-7121-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130204_125344_517706_2C8473F1)
In-Reply-To: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Internally, 64-bit byte counters maintained for per-station
statistics. Tell to the netlink that full 64-bit value provided

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4225cca..90b1a93 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1778,14 +1778,16 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->target_stats.rx_byte) {
 		sinfo->rx_bytes = vif->target_stats.rx_byte;
-		sinfo->filled |= STATION_INFO_RX_BYTES;
+		sinfo->filled |= STATION_INFO_RX_BYTES |
+				 STATION_INFO_RX_BYTES64;
 		sinfo->rx_packets = vif->target_stats.rx_pkt;
 		sinfo->filled |= STATION_INFO_RX_PACKETS;
 	}
 
 	if (vif->target_stats.tx_byte) {
 		sinfo->tx_bytes = vif->target_stats.tx_byte;
-		sinfo->filled |= STATION_INFO_TX_BYTES;
+		sinfo->filled |= STATION_INFO_TX_BYTES |
+				 STATION_INFO_TX_BYTES64;
 		sinfo->tx_packets = vif->target_stats.tx_pkt;
 		sinfo->filled |= STATION_INFO_TX_PACKETS;
 	}
-- 
1.7.10.4


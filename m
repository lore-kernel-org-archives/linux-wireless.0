Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:51718 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161299Ab2CPDwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 23:52:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/5] mwifiex: support STATION_INFO_SIGNAL_AVG
Date: Thu, 15 Mar 2012 20:51:50 -0700
Message-Id: <1331869911-10624-5-git-send-email-bzhao@marvell.com> (sfid-20120316_045239_181190_8A2CB64D)
In-Reply-To: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
References: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch adds the support for updating average signal information
in dump_station().

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9cf8d53..96c1e3b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -519,9 +519,9 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	struct mwifiex_rate_cfg rate;
 
 	sinfo->filled = STATION_INFO_RX_BYTES | STATION_INFO_TX_BYTES |
-		STATION_INFO_RX_PACKETS |
-		STATION_INFO_TX_PACKETS
-		| STATION_INFO_SIGNAL | STATION_INFO_TX_BITRATE;
+			STATION_INFO_RX_PACKETS | STATION_INFO_TX_PACKETS |
+			STATION_INFO_TX_BITRATE |
+			STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
 
 	/* Get signal information from the firmware */
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_RSSI_INFO,
@@ -555,6 +555,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 	}
 
+	sinfo->signal_avg = priv->bcn_rssi_avg;
 	sinfo->rx_bytes = priv->stats.rx_bytes;
 	sinfo->tx_bytes = priv->stats.tx_bytes;
 	sinfo->rx_packets = priv->stats.rx_packets;
-- 
1.7.0.2


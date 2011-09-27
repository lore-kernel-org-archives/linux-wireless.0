Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:37942 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751979Ab1I0DiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 23:38:09 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: fix Tx data rate display issue
Date: Mon, 26 Sep 2011 20:37:25 -0700
Message-Id: <1317094646-7718-3-git-send-email-bzhao@marvell.com> (sfid-20110927_053813_213142_5F8280AD)
In-Reply-To: <1317094646-7718-1-git-send-email-bzhao@marvell.com>
References: <1317094646-7718-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

"iw dev mlan0 link" shows wrong data rate, because data rate is
not sent properly to cfg80211 stack. Also stack is not updated
with mcs and Tx data flags information.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 5550741..c429661 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -543,12 +543,28 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 		ret = -EFAULT;
 	}
 
+	/*
+	 * Bit 0 in tx_htinfo indicates that current Tx rate is 11n rate. Valid
+	 * MCS index values for us are 0 to 7.
+	 */
+	if ((priv->tx_htinfo & BIT(0)) && (priv->tx_rate < 8)) {
+		sinfo->txrate.mcs = priv->tx_rate;
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+		/* 40MHz rate */
+		if (priv->tx_htinfo & BIT(1))
+			sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+		/* SGI enabled */
+		if (priv->tx_htinfo & BIT(2))
+			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	}
+
 	sinfo->rx_bytes = priv->stats.rx_bytes;
 	sinfo->tx_bytes = priv->stats.tx_bytes;
 	sinfo->rx_packets = priv->stats.rx_packets;
 	sinfo->tx_packets = priv->stats.tx_packets;
 	sinfo->signal = priv->qual_level;
-	sinfo->txrate.legacy = rate.rate;
+	/* bit rate is in 500 kb/s units. Convert it to 100kb/s units */
+	sinfo->txrate.legacy = rate.rate * 5;
 
 	return ret;
 }
-- 
1.7.0.2


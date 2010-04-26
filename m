Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34504 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0DZUK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] p54: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:26 -0400
Message-Id: <1272312566-22812-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/p54/txrx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 2ceff54..4e68910 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -350,7 +350,6 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 		rx_status->flag |= RX_FLAG_MMIC_ERROR;
 
 	rx_status->signal = p54_rssi_to_dbm(priv, hdr->rssi);
-	rx_status->noise = priv->noise;
 	if (hdr->rate & 0x10)
 		rx_status->flag |= RX_FLAG_SHORTPRE;
 	if (priv->hw->conf.channel->band == IEEE80211_BAND_5GHZ)
-- 
1.6.6.1


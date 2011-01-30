Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:40136 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1A3TL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:28 -0500
Message-ID: <4D45B7CE.7070705@davizone.at>
Date: Sun, 30 Jan 2011 20:11:10 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 12/18] wl1251: set rate index and preamble flag on received
 packets
References: <4D45A5E7.1040202@davizone.at>
In-Reply-To: <4D45A5E7.1040202@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the rate index rate_idx and preamble flag RX_FLAG_SHORTPRE on received
packets.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/rx.c |   46 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/rx.c b/drivers/net/wireless/wl1251/rx.c
index 99308af..c9396b5 100644
--- a/drivers/net/wireless/wl1251/rx.c
+++ b/drivers/net/wireless/wl1251/rx.c
@@ -96,8 +96,52 @@ static void wl1251_rx_status(struct wl1251 *wl,
 	if (unlikely(!(desc->flags & RX_DESC_VALID_FCS)))
 		status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
+	switch (desc->rate) {
+		/* skip 1 and 12 Mbps because they have same value 0x0a */
+	case RATE_2MBPS:
+		status->rate_idx = 1;
+		break;
+	case RATE_5_5MBPS:
+		status->rate_idx = 2;
+		break;
+	case RATE_11MBPS:
+		status->rate_idx = 3;
+		break;
+	case RATE_6MBPS:
+		status->rate_idx = 4;
+		break;
+	case RATE_9MBPS:
+		status->rate_idx = 5;
+		break;
+	case RATE_18MBPS:
+		status->rate_idx = 7;
+		break;
+	case RATE_24MBPS:
+		status->rate_idx = 8;
+		break;
+	case RATE_36MBPS:
+		status->rate_idx = 9;
+		break;
+	case RATE_48MBPS:
+		status->rate_idx = 10;
+		break;
+	case RATE_54MBPS:
+		status->rate_idx = 11;
+		break;
+	}
+
+	/* for 1 and 12 Mbps we have to check the modulation */
+	if (desc->rate == RATE_1MBPS) {
+		if (!(desc->mod_pre & OFDM_RATE_BIT))
+			/* CCK -> RATE_1MBPS */
+			status->rate_idx = 0;
+		else
+			/* OFDM -> RATE_12MBPS */
+			status->rate_idx = 6;
+	}
 
-	/* FIXME: set status->rate_idx */
+	if (desc->mod_pre & SHORT_PREAMBLE_BIT)
+		status->flag |= RX_FLAG_SHORTPRE;
 }
 
 static void wl1251_rx_body(struct wl1251 *wl,
-- 
1.7.0.4



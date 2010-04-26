Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34496 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0DZUK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1251: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:28 -0400
Message-Id: <1272312568-22894-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/wl1251_rx.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index b567322..295203a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -73,12 +73,6 @@ static void wl1251_rx_status(struct wl1251 *wl,
 
 	status->signal = desc->rssi;
 
-	/*
-	 * FIXME: guessing that snr needs to be divided by two, otherwise
-	 * the values don't make any sense
-	 */
-	status->noise = desc->rssi - desc->snr / 2;
-
 	status->freq = ieee80211_channel_to_frequency(desc->channel);
 
 	status->flag |= RX_FLAG_TSFT;
-- 
1.6.6.1


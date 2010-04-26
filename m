Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34497 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0DZUK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwl8k: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:16 -0400
Message-Id: <1272312556-22525-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwl8k.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4e58ebe..9af6c94 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -749,7 +749,6 @@ mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	memset(status, 0, sizeof(*status));
 
 	status->signal = -rxd->rssi;
-	status->noise = -rxd->noise_floor;
 
 	if (rxd->rate & MWL8K_8366_AP_RATE_INFO_MCS_FORMAT) {
 		status->flag |= RX_FLAG_HT;
@@ -851,7 +850,6 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 	memset(status, 0, sizeof(*status));
 
 	status->signal = -rxd->rssi;
-	status->noise = -rxd->noise_level;
 	status->antenna = MWL8K_STA_RATE_INFO_ANTSELECT(rate_info);
 	status->rate_idx = MWL8K_STA_RATE_INFO_RATEID(rate_info);
 
-- 
1.6.6.1


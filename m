Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26529 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031049AbbEEMbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 08:31:10 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix survey information reporting
Date: Tue, 5 May 2015 18:00:48 +0530
Message-ID: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150505_143115_472270_DDA3ABBE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx clear count reported in wmi_chan_info_event is actually channel_busy_count
not rx_frame_count. Send rx_clear_count through time_busy of survey_info
and set SURVEY_INFO_TIME_BUSY in filled.

iw wlan0 survey dump

urvey data from wlan0
        frequency:                      5180 MHz [in use]
        noise:                          -103 dBm
        channel active time:            150 ms
        channel busy time:              22 ms
Survey data from wlan0
        frequency:                      5200 MHz
        noise:                          -102 dBm
        channel active time:            146 ms
        channel busy time:              0 ms

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ebaa096..0fabe68 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1645,10 +1645,10 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 
 		survey = &ar->survey[idx];
 		survey->time = WMI_CHAN_INFO_MSEC(cycle_count);
-		survey->time_rx = WMI_CHAN_INFO_MSEC(rx_clear_count);
+		survey->time_busy = WMI_CHAN_INFO_MSEC(rx_clear_count);
 		survey->noise = noise_floor;
 		survey->filled = SURVEY_INFO_TIME |
-				 SURVEY_INFO_TIME_RX |
+				 SURVEY_INFO_TIME_BUSY |
 				 SURVEY_INFO_NOISE_DBM;
 	}
 
-- 
1.9.1


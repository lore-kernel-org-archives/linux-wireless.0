Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56154 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbbDMSDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 14:03:47 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath10k: use MAC clock rate same as FW uses for survey accuracy
Date: Mon, 13 Apr 2015 11:01:20 -0700
Message-ID: <6a113cdb1b0dbbb6d98ab6b363b4912474c32bac.1428701627.git.poh@qca.qualcomm.com> (sfid-20150413_200350_413923_343C06B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WLAN survey data provides several informative values on each channels
such as noise, active time, transmit time, and etc.
Regarding the channel activity time data, it is reported from firmware
in different form which is number of cycles instead of time itself.
Hence host driver converts it to time unit by dividing it by clock rate
that is used at baseband MAC.

Using difference clock rate from that actual HW is using will result in
inaccurate survey data. For instance, channel active time can be reported
with bigger than 150ms even though we set Dwell time to 150ms.
Therefore set the clock rate to 88000 (88 MHz) which is ath10k baseband
MAC is using.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d0942b0..2c03496 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4653,9 +4653,7 @@ struct wmi_peer_sta_kickout_event {
 } __packed;
 
 #define WMI_CHAN_INFO_FLAG_COMPLETE BIT(0)
-
-/* FIXME: empirically extrapolated */
-#define WMI_CHAN_INFO_MSEC(x) ((x) / 76595)
+#define WMI_CHAN_INFO_MSEC(x) ((x) / 88000)
 
 /* Beacon filter wmi command info */
 #define BCN_FLT_MAX_SUPPORTED_IES	256
-- 
1.9.1


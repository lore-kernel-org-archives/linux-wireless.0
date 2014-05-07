Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45939 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaEGPwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 11:52:24 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so900518eei.14
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 08:52:23 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 2/4] rtl8180: report mac80211 short preamble RX flag
Date: Wed,  7 May 2014 17:52:16 +0200
Message-Id: <1399477936-26317-1-git-send-email-andrea.merello@gmail.com> (sfid-20140507_175232_073494_CFE1915D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch make it possible to mac80211 to know whether a frame
has been received with short preamble.

It simply checks for the "splcp" flag in the RX status
descriptor, and eventually set RX_FLAG_SHORTPRE in mac80211
rx status structure.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 50d69b1..8d07df2 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -284,6 +284,8 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			rx_status.band = dev->conf.chandef.chan->band;
 			rx_status.mactime = tsft;
 			rx_status.flag |= RX_FLAG_MACTIME_START;
+			if (flags & RTL818X_RX_DESC_FLAG_SPLCP)
+				rx_status.flag |= RX_FLAG_SHORTPRE;
 			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 
-- 
1.8.3.2


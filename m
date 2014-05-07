Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:51585 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbaEGPv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 11:51:59 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so919969eek.9
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 08:51:58 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 1/4] rtl8187: report mac80211 short preamble RX flag
Date: Wed,  7 May 2014 17:51:43 +0200
Message-Id: <1399477903-26278-1-git-send-email-andrea.merello@gmail.com> (sfid-20140507_175208_600979_B4B07758)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch make it possible to mac80211 to know whether a frame
has been received with short preamble.

It simply checks for the "splcp" flag in the RX status
descriptor, and eventually set RX_FLAG_SHORTPRE in mac80211
rx status structure.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 0ca17cd..6e4b177 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -381,6 +381,8 @@ static void rtl8187_rx_cb(struct urb *urb)
 	rx_status.freq = dev->conf.chandef.chan->center_freq;
 	rx_status.band = dev->conf.chandef.chan->band;
 	rx_status.flag |= RX_FLAG_MACTIME_START;
+	if (flags & RTL818X_RX_DESC_FLAG_SPLCP)
+		rx_status.flag |= RX_FLAG_SHORTPRE;
 	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
-- 
1.8.3.2


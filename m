Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49882 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYJGTr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 15:47:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: normalize quality measurment for 100-point scale
Date: Tue,  7 Oct 2008 15:31:54 -0400
Message-Id: <1223407914-23971-1-git-send-email-linville@tuxdriver.com> (sfid-20081007_214728_723690_57E54FC3)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, we get values like "133/100" for quality output from
iwconfig. :-(

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This is currently untested, but it seems reasonable to me...any takers?  :-)

 drivers/net/wireless/rtl8180_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index b7172a1..e9edcaa 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -132,7 +132,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 
 			rx_status.antenna = (flags2 >> 15) & 1;
 			/* TODO: improve signal/rssi reporting */
-			rx_status.qual = flags2 & 0xFF;
+			rx_status.qual = ((flags2 & 0xFF) * 100) / 256;
 			rx_status.signal = (flags2 >> 8) & 0x7F;
 			/* XXX: is this correct? */
 			rx_status.rate_idx = (flags >> 20) & 0xF;
-- 
1.5.4.3


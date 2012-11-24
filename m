Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40550 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2KXNbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 08:31:39 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3776243eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 05:31:38 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 24 Nov 2012 14:23:25 +0100
Subject: [PATCH] p54: improve TSF timestamp precision
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1TcFpW-00056n-QB@debian64.localnet> (sfid-20121124_143155_900305_79B9F2F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LMAC API states that the TSF clock value of
every rx'ed frame is a "usec accurate timestamp
of the hardware clock at the end of frame
(before OFDM SIFS EOF padding)".

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/txrx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 8ae982b..12f0a34 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -369,7 +369,11 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 	rx_status->mactime = ((u64)priv->tsf_high32) << 32 | tsf32;
 	priv->tsf_low32 = tsf32;
 
-	rx_status->flag |= RX_FLAG_MACTIME_START;
+	/* LMAC API Page 10/29 - s_lm_data_in - clock
+	 * "usec accurate timestamp of hardware clock
+	 * at end of frame (before OFDM SIFS EOF padding"
+	 */
+	rx_status->flag |= RX_FLAG_MACTIME_END;
 
 	if (hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		header_len += hdr->align[0];
-- 
1.7.10.4


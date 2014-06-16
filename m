Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56741 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPOOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:14:04 -0400
Received: by mail-pa0-f53.google.com with SMTP id ey11so1089651pad.12
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:14:04 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id wn7sm69551192pab.18.2014.06.16.07.14.02
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:14:03 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 09/16] rsi: Use SGI if configured for fixed rate transmission.
Date: Mon, 16 Jun 2014 19:43:54 +0530
Message-Id: <1402928034-4018-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161409_949447_AB5DFFA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use SGI if configured while sending data packets at a fixed rate.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_pkt.c |    6 ++++++
 drivers/net/wireless/rsi/rsi_mgmt.h    |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 8e48e72..229ef3a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -81,6 +81,12 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		/* Send fixed rate */
 		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
 		frame_desc[4] = cpu_to_le16(common->min_rate);
+		if (common->vif_info[0].sgi) {
+			if (common->min_rate & 0x100) /* Only MCS rates */
+				frame_desc[4] |=
+					cpu_to_le16(ENABLE_SHORTGI_RATE);
+		}
+
 	}
 
 	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 6ccf9d9..8bff664 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -69,6 +69,7 @@
 
 #define RSI_LMAC_CLOCK_80MHZ            0x1
 #define RSI_ENABLE_40MHZ                (0x1 << 3)
+#define ENABLE_SHORTGI_RATE		BIT(9)
 
 #define RX_BA_INDICATION                1
 #define RSI_TBL_SZ                      40
-- 
1.7.1


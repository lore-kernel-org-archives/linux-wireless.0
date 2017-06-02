Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33593 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdFBOPu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 10:15:50 -0400
Received: by mail-pf0-f196.google.com with SMTP id f27so11918329pfe.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 07:15:50 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 4/6] rsi: receive path enhancement for RS9113
Date: Fri,  2 Jun 2017 19:43:03 +0530
Message-Id: <1496412785-8720-5-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170602_161553_068373_FBF36E5B)
In-Reply-To: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

RS9113 chipset supports Coex feature. Initial frame exchanges during
device initialization happens on coex queue. This patch adds the
handling for coex queue.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 9 ++++++++-
 drivers/net/wireless/rsi/rsi_main.h     | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 8810862..f1cde0c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -123,9 +123,16 @@ int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
 
 		queueno = rsi_get_queueno(frame_desc, offset);
 		length = rsi_get_length(frame_desc, offset);
-		extended_desc = rsi_get_extended_desc(frame_desc, offset);
+
+		/* Extended descriptor is valid for WLAN queues only */
+		if (queueno == RSI_WIFI_DATA_Q || queueno == RSI_WIFI_MGMT_Q)
+			extended_desc = rsi_get_extended_desc(frame_desc,
+							      offset);
 
 		switch (queueno) {
+		case RSI_COEX_Q:
+			rsi_mgmt_pkt_recv(common, (frame_desc + offset));
+			break;
 		case RSI_WIFI_DATA_Q:
 			skb = rsi_prepare_skb(common,
 					      (frame_desc + offset),
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 74ae0ac..f12e5d9 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -63,6 +63,7 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define MAX_CONTINUOUS_VI_PKTS          4
 
 /* Queue information */
+#define RSI_COEX_Q			0x0
 #define RSI_WIFI_MGMT_Q                 0x4
 #define RSI_WIFI_DATA_Q                 0x5
 #define IEEE80211_MGMT_FRAME            0x00
-- 
2.7.4

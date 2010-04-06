Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22583 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0DFJho (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:37:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 02:37:44 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19387.1463.310224.890658@gargle.gargle.HOWL>
Date: Tue, 6 Apr 2010 15:28:15 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/5] ath9k_htc: Fix module unloading issue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The maximum number of packets in a single buffer in
stream mode is 10. The driver currently uses 8 - which
caused stack corruption, in the absence of any kind
of OOB checking.

Fixing this to the correct value of 10 fixes the module
unload issue.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 4528df4..69bef1d 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -324,7 +324,7 @@ static struct ath9k_htc_hif hif_usb = {
 static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				    struct sk_buff *skb)
 {
-	struct sk_buff *nskb, *skb_pool[8];
+	struct sk_buff *nskb, *skb_pool[MAX_PKT_NUM_IN_TRANSFER];
 	int index = 0, i = 0, chk_idx, len = skb->len;
 	int rx_remain_len = 0, rx_pkt_len = 0;
 	u16 pkt_len, pkt_tag, pool_index = 0;
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index ed9708c..179cea4 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -34,6 +34,7 @@
 
 #define MAX_RX_URB_NUM  8
 #define MAX_RX_BUF_SIZE 16384
+#define MAX_PKT_NUM_IN_TRANSFER 10
 
 #define MAX_REG_OUT_URB_NUM  1
 #define MAX_REG_OUT_BUF_NUM  8
-- 
1.7.0.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:33573 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1DTF2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 01:28:54 -0400
Received: by mail-px0-f179.google.com with SMTP id 2so318654pxi.10
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 22:28:53 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19886.28589.429644.634493@gargle.gargle.HOWL>
Date: Wed, 20 Apr 2011 11:01:25 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 5/5] ath9k_htc: Remove unused macros and structures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h     |    3 ---
 drivers/net/wireless/ath/ath9k/htc_hst.h |   11 -----------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index af90829..55f4bb3 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -66,8 +66,6 @@ enum htc_opmode {
 	HTC_M_WDS	= 2
 };
 
-#define ATH9K_HTC_HDRSPACE sizeof(struct htc_frame_hdr)
-
 #define ATH9K_HTC_AMPDU  1
 #define ATH9K_HTC_NORMAL 2
 #define ATH9K_HTC_BEACON 3
@@ -75,7 +73,6 @@ enum htc_opmode {
 
 #define ATH9K_HTC_TX_CTSONLY      0x1
 #define ATH9K_HTC_TX_RTSCTS       0x2
-#define ATH9K_HTC_TX_USE_MIN_RATE 0x100
 
 struct tx_frame_hdr {
 	u8 data_type;
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index cb9174a..91a5305 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -83,21 +83,10 @@ struct htc_ep_callbacks {
 	void (*rx) (void *, struct sk_buff *, enum htc_endpoint_id);
 };
 
-#define HTC_TX_QUEUE_SIZE 256
-
-struct htc_txq {
-	struct sk_buff *buf[HTC_TX_QUEUE_SIZE];
-	u32 txqdepth;
-	u16 txbuf_cnt;
-	u16 txq_head;
-	u16 txq_tail;
-};
-
 struct htc_endpoint {
 	u16 service_id;
 
 	struct htc_ep_callbacks ep_callbacks;
-	struct htc_txq htc_txq;
 	u32 max_txqdepth;
 	int max_msglen;
 
-- 
1.7.4.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47163 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0LAHAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:00:30 -0500
Received: by ywl5 with SMTP id 5so3214962ywl.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:00:30 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19701.62073.158585.669243@gargle.gargle.HOWL>
Date: Wed, 1 Dec 2010 12:30:09 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ath9k_htc: Remove unused structures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.h |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 6fc1b21..ecd0187 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -77,20 +77,6 @@ struct htc_config_pipe_msg {
 	u8 credits;
 } __packed;
 
-struct htc_packet {
-	void *pktcontext;
-	u8 *buf;
-	u8 *buf_payload;
-	u32 buflen;
-	u32 payload_len;
-
-	int endpoint;
-	int status;
-
-	void *context;
-	u32 reserved;
-};
-
 struct htc_ep_callbacks {
 	void *priv;
 	void (*tx) (void *, struct sk_buff *, enum htc_endpoint_id, bool txok);
@@ -123,11 +109,6 @@ struct htc_endpoint {
 #define HTC_CONTROL_BUFFER_SIZE	\
 	(HTC_MAX_CONTROL_MESSAGE_LENGTH + sizeof(struct htc_frame_hdr))
 
-struct htc_control_buf {
-	struct htc_packet htc_pkt;
-	u8 buf[HTC_CONTROL_BUFFER_SIZE];
-};
-
 #define HTC_OP_START_WAIT           BIT(0)
 #define HTC_OP_CONFIG_PIPE_CREDITS  BIT(1)
 
-- 
1.7.3.2


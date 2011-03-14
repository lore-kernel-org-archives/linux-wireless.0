Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20486 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035Ab1CNR7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 16/38] ath6kl: remove-typedef HTC_CONTROL_BUFFER
Date: Mon, 14 Mar 2011 10:58:50 -0700
Message-ID: <1300125552-24422-17-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_CONTROL_BUFFER \
	"struct htc_control_buffer" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/htc_internal.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index 8bc3162..e3857cf 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -99,10 +99,10 @@ typedef struct _HTC_ENDPOINT {
 #define NUM_CONTROL_TX_BUFFERS  2
 #define NUM_CONTROL_RX_BUFFERS  (NUM_CONTROL_BUFFERS - NUM_CONTROL_TX_BUFFERS)
 
-typedef struct HTC_CONTROL_BUFFER {
+struct htc_control_buffer {
     HTC_PACKET    HtcPacket;
     u8 *Buffer;
-} HTC_CONTROL_BUFFER;
+};
 
 #define HTC_RECV_WAIT_BUFFERS        (1 << 0)
 #define HTC_OP_STATE_STOPPING        (1 << 0)
@@ -110,7 +110,7 @@ typedef struct HTC_CONTROL_BUFFER {
 /* our HTC target state */
 typedef struct _HTC_TARGET {
     HTC_ENDPOINT                EndPoint[ENDPOINT_MAX];
-    HTC_CONTROL_BUFFER          HTCControlBuffers[NUM_CONTROL_BUFFERS];
+    struct htc_control_buffer          HTCControlBuffers[NUM_CONTROL_BUFFERS];
     HTC_ENDPOINT_CREDIT_DIST   *EpCreditDistributionListHead;
     HTC_PACKET_QUEUE            ControlBufferTXFreeList;
     HTC_PACKET_QUEUE            ControlBufferRXFreeList;
-- 
1.7.4.15.g7811d


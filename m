Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29957 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab1CKC4T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/20] ath6kl: remove-typedef AR6K_ASYNC_REG_IO_BUFFER
Date: Thu, 10 Mar 2011 18:55:35 -0800
Message-ID: <1299812147-12069-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6K_ASYNC_REG_IO_BUFFER \
	"struct ar6k_async_reg_io_buffer" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 19d8e70..e0c3926 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -89,12 +89,12 @@ typedef PREPACK struct _AR6K_GMBOX_CTRL_REGISTERS {
 #define AR6K_MIN_TRANSFER_SIZE_PER_SCATTER      4*1024
 
 /* buffers for ASYNC I/O */
-typedef struct AR6K_ASYNC_REG_IO_BUFFER {
+struct ar6k_async_reg_io_buffer {
     HTC_PACKET    HtcPacket;   /* we use an HTC packet as a wrapper for our async register-based I/O */
     u8 _Pad1[A_CACHE_LINE_PAD];
     u8 Buffer[AR6K_REG_IO_BUFFER_SIZE];  /* cache-line safe with pads around */
     u8 _Pad2[A_CACHE_LINE_PAD];
-} AR6K_ASYNC_REG_IO_BUFFER;
+};
 
 typedef struct _AR6K_GMBOX_INFO { 
     void        *pProtocolContext;
@@ -119,7 +119,7 @@ typedef struct _AR6K_DEVICE {
     HIF_PENDING_EVENTS_FUNC     GetPendingEventsFunc;
     void                        *HTCContext;
     HTC_PACKET_QUEUE            RegisterIOList;
-    AR6K_ASYNC_REG_IO_BUFFER    RegIOBuffers[AR6K_MAX_REG_IO_BUFFERS];
+    struct ar6k_async_reg_io_buffer    RegIOBuffers[AR6K_MAX_REG_IO_BUFFERS];
     void                        (*TargetFailureCallback)(void *Context);
     int                    (*MessagePendingCallback)(void *Context,
                                                           u32 LookAheads[],
-- 
1.7.4.15.g7811d


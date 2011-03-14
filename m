Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21168 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab1CNSF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:05:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:05:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 25/38] ath6kl: remove-typedef HTC_RX_PACKET_INFO
Date: Mon, 14 Mar 2011 10:58:59 -0700
Message-ID: <1300125552-24422-26-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_RX_PACKET_INFO \
	"struct htc_rx_packet_info" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/htc_packet.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/include/htc_packet.h b/drivers/staging/ath6kl/include/htc_packet.h
index ca23efd..b6ecf7e 100644
--- a/drivers/staging/ath6kl/include/htc_packet.h
+++ b/drivers/staging/ath6kl/include/htc_packet.h
@@ -59,11 +59,11 @@ typedef struct _HTC_TX_PACKET_INFO {
 #define HTC_TX_PACKET_TAG_INTERNAL     1                                /* internal tags start here */
 #define HTC_TX_PACKET_TAG_USER_DEFINED (HTC_TX_PACKET_TAG_INTERNAL + 9) /* user-defined tags start here */
 
-typedef struct _HTC_RX_PACKET_INFO {
+struct htc_rx_packet_info {
     u32 ExpectedHdr;        /* HTC internal use */
     u32 HTCRxFlags;         /* HTC internal use */
     u32 IndicationFlags;    /* indication flags set on each RX packet indication */
-} HTC_RX_PACKET_INFO;
+};
 
 #define HTC_RX_FLAGS_INDICATE_MORE_PKTS  (1 << 0)   /* more packets on this endpoint are being fetched */
 
@@ -92,7 +92,7 @@ struct htc_packet {
     int        Status;         /* completion status */
     union {
         HTC_TX_PACKET_INFO  AsTx;   /* Tx Packet specific info */
-        HTC_RX_PACKET_INFO  AsRx;   /* Rx Packet specific info */
+        struct htc_rx_packet_info  AsRx;   /* Rx Packet specific info */
     } PktInfo;
 
     /* the following fields are for internal HTC use */
-- 
1.7.4.15.g7811d


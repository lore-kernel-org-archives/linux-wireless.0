Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53042 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab0JIXwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 19:52:00 -0400
Received: by fxm14 with SMTP id 14so1077586fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 16:51:59 -0700 (PDT)
Message-Id: <99eecb7f981fa142324542af768ba8640c7828e1.1286667826.git.chunkeey@googlemail.com>
In-Reply-To: <75b38fb7faac45360bf016016144b15752af07ce.1286667826.git.chunkeey@googlemail.com>
References: <75b38fb7faac45360bf016016144b15752af07ce.1286667826.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 9 Oct 2010 22:23:37 +0200
Subject: [PATCH 2/3] carl9170: remove stale rx error path
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The total/fatal error bit was erroneously prefixed
with AR9170_RX_ERROR instead of AR9170_RX_STATUS.
Luckily, the hardware specification confirmed that
the 0x80 flag will never be set for mac->error.
So, it was always just a dead branch.

This patch also imports the latest version of
shared wlan.h header from the firmware git.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c   |    3 ---
 drivers/net/wireless/ath/carl9170/wlan.h |   14 +++++++++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 31287e0..256dd42 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -604,9 +604,6 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	mpdu_len = len - sizeof(*mac);
 
 	mac = (void *)(buf + mpdu_len);
-	if (unlikely(mac->error & AR9170_RX_ERROR_FATAL))
-		goto drop;
-
 	switch (mac->status & AR9170_RX_STATUS_MPDU) {
 	case AR9170_RX_STATUS_MPDU_FIRST:
 		/* Aggregated MPDUs start with an PLCP header */
diff --git a/drivers/net/wireless/ath/carl9170/wlan.h b/drivers/net/wireless/ath/carl9170/wlan.h
index 48ead22..24d63b5 100644
--- a/drivers/net/wireless/ath/carl9170/wlan.h
+++ b/drivers/net/wireless/ath/carl9170/wlan.h
@@ -74,6 +74,9 @@
 #define	AR9170_RX_STATUS_MPDU_MIDDLE		0x30
 #define	AR9170_RX_STATUS_MPDU_LAST		0x10
 
+#define	AR9170_RX_STATUS_CONT_AGGR		0x40
+#define	AR9170_RX_STATUS_TOTAL_ERROR		0x80
+
 #define	AR9170_RX_ERROR_RXTO			0x01
 #define	AR9170_RX_ERROR_OVERRUN			0x02
 #define	AR9170_RX_ERROR_DECRYPT			0x04
@@ -81,7 +84,6 @@
 #define	AR9170_RX_ERROR_WRONG_RA		0x10
 #define	AR9170_RX_ERROR_PLCP			0x20
 #define	AR9170_RX_ERROR_MMIC			0x40
-#define	AR9170_RX_ERROR_FATAL			0x80
 
 /* these are either-or */
 #define	AR9170_TX_MAC_PROT_RTS			0x0001
@@ -329,13 +331,15 @@ struct _carl9170_tx_superframe {
 
 #define	CARL9170_TX_SUPERDESC_LEN		24
 #define	AR9170_TX_HWDESC_LEN			8
-#define	AR9170_TX_SUPERFRAME_LEN		(CARL9170_TX_HWDESC_LEN + \
-						 AR9170_TX_SUPERDESC_LEN)
+#define	CARL9170_TX_SUPERFRAME_LEN		(CARL9170_TX_SUPERDESC_LEN + \
+						 AR9170_TX_HWDESC_LEN)
 
 struct ar9170_rx_head {
 	u8 plcp[12];
 } __packed;
 
+#define	AR9170_RX_HEAD_LEN			12
+
 struct ar9170_rx_phystatus {
 	union {
 		struct {
@@ -350,12 +354,16 @@ struct ar9170_rx_phystatus {
 	u8 phy_err;
 } __packed;
 
+#define	AR9170_RX_PHYSTATUS_LEN			20
+
 struct ar9170_rx_macstatus {
 	u8 SAidx, DAidx;
 	u8 error;
 	u8 status;
 } __packed;
 
+#define	AR9170_RX_MACSTATUS_LEN			4
+
 struct ar9170_rx_frame_single {
 	struct ar9170_rx_head phy_head;
 	struct ieee80211_hdr i3e;
-- 
1.7.1


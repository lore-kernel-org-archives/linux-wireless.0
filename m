Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58160 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbbFHMij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:38:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/4] brcmfmac: Update msgbuf read pointer quicker.
Date: Mon, 8 Jun 2015 14:38:32 +0200
Message-ID: <1433767115-8136-2-git-send-email-arend@broadcom.com> (sfid-20150608_143845_903831_CE2C1EF2)
In-Reply-To: <1433767115-8136-1-git-send-email-arend@broadcom.com>
References: <1433767115-8136-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On device to host data using msgbuf the read pointer gets updated
once all data is processed. Updating this pointer more frequently
allows the firmware to add more data quicker. This will result in
slightly higher and more stable throughput on CPU bounded host
processors.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/commonring.c | 19 ++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/commonring.h |  3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c     | 12 +++++++++++-
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/commonring.c b/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
index 26c6587..7b0e521 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
@@ -223,8 +223,6 @@ void brcmf_commonring_write_cancel(struct brcmf_commonring *commonring,
 void *brcmf_commonring_get_read_ptr(struct brcmf_commonring *commonring,
 				    u16 *n_items)
 {
-	void *ret_addr;
-
 	if (commonring->cr_update_wptr)
 		commonring->cr_update_wptr(commonring->cr_ctx);
 
@@ -235,19 +233,18 @@ void *brcmf_commonring_get_read_ptr(struct brcmf_commonring *commonring,
 	if (*n_items == 0)
 		return NULL;
 
-	ret_addr = commonring->buf_addr +
-		   (commonring->r_ptr * commonring->item_len);
-
-	commonring->r_ptr += *n_items;
-	if (commonring->r_ptr == commonring->depth)
-		commonring->r_ptr = 0;
-
-	return ret_addr;
+	return commonring->buf_addr +
+	       (commonring->r_ptr * commonring->item_len);
 }
 
 
-int brcmf_commonring_read_complete(struct brcmf_commonring *commonring)
+int brcmf_commonring_read_complete(struct brcmf_commonring *commonring,
+				   u16 n_items)
 {
+	commonring->r_ptr += n_items;
+	if (commonring->r_ptr == commonring->depth)
+		commonring->r_ptr = 0;
+
 	if (commonring->cr_write_rptr)
 		return commonring->cr_write_rptr(commonring->cr_ctx);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/commonring.h b/drivers/net/wireless/brcm80211/brcmfmac/commonring.h
index 3d40401..b850336 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/commonring.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/commonring.h
@@ -62,7 +62,8 @@ void brcmf_commonring_write_cancel(struct brcmf_commonring *commonring,
 				   u16 n_items);
 void *brcmf_commonring_get_read_ptr(struct brcmf_commonring *commonring,
 				    u16 *n_items);
-int brcmf_commonring_read_complete(struct brcmf_commonring *commonring);
+int brcmf_commonring_read_complete(struct brcmf_commonring *commonring,
+				   u16 n_items);
 
 #define brcmf_commonring_n_items(commonring) (commonring->depth)
 #define brcmf_commonring_len_item(commonring) (commonring->item_len)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 1b47de0..898c380 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -75,6 +75,8 @@
 
 #define BRCMF_MSGBUF_DELAY_TXWORKER_THRS	96
 #define BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS	32
+#define BRCMF_MSGBUF_UPDATE_RX_PTR_THRS		48
+
 
 struct msgbuf_common_hdr {
 	u8				msgtype;
@@ -1257,19 +1259,27 @@ static void brcmf_msgbuf_process_rx(struct brcmf_msgbuf *msgbuf,
 {
 	void *buf;
 	u16 count;
+	u16 processed;
 
 again:
 	buf = brcmf_commonring_get_read_ptr(commonring, &count);
 	if (buf == NULL)
 		return;
 
+	processed = 0;
 	while (count) {
 		brcmf_msgbuf_process_msgtype(msgbuf,
 					     buf + msgbuf->rx_dataoffset);
 		buf += brcmf_commonring_len_item(commonring);
+		processed++;
+		if (processed == BRCMF_MSGBUF_UPDATE_RX_PTR_THRS) {
+			brcmf_commonring_read_complete(commonring, processed);
+			processed = 0;
+		}
 		count--;
 	}
-	brcmf_commonring_read_complete(commonring);
+	if (processed)
+		brcmf_commonring_read_complete(commonring, processed);
 
 	if (commonring->r_ptr == 0)
 		goto again;
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48618 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2FKPAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:00:08 -0400
Received: by weyu7 with SMTP id u7so2135606wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 08:00:07 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wlcore: avoid using NET_IP_ALIGN for RX alignment
Date: Mon, 11 Jun 2012 17:59:55 +0300
Message-Id: <1339426795-6526-1-git-send-email-eyal@wizery.com> (sfid-20120611_170012_989774_AE827EAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NET_IP_ALIGN can be overriden on different architectures
and therefore cannot be used in the RX path to account
for the 2 bytes added for alignment (either by the FW
in the case of 18xx or by the host for 12xx).
Instead use an internal define.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/ti/wlcore/rx.c |    4 ++--
 drivers/net/wireless/ti/wlcore/rx.h |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 78200dc..a1db4e0 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -127,7 +127,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	}
 
 	if (rx_align == WLCORE_RX_BUF_UNALIGNED)
-		reserved = NET_IP_ALIGN;
+		reserved = RX_BUF_ALIGN;
 
 	/* the data read starts with the descriptor */
 	desc = (struct wl1271_rx_descriptor *) data;
@@ -175,7 +175,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	 */
 	memcpy(buf, data + sizeof(*desc), pkt_data_len);
 	if (rx_align == WLCORE_RX_BUF_PADDED)
-		skb_pull(skb, NET_IP_ALIGN);
+		skb_pull(skb, RX_BUF_ALIGN);
 
 	*hlid = desc->hlid;
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index 9be7801..4324a42 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -103,6 +103,12 @@
 /* If set, the buffer was padded by the FW to be 4 bytes aligned */
 #define RX_BUF_PADDED_PAYLOAD        BIT(30)
 
+/*
+ * Account for the padding inserted by the FW in case of RX_ALIGNMENT
+ * or for fixing alignment in case the packet wasn't aligned.
+ */
+#define RX_BUF_ALIGN                 2
+
 /* Describes the alignment state of a Rx buffer */
 enum wl_rx_buf_align {
 	WLCORE_RX_BUF_ALIGNED,
-- 
1.7.4.1


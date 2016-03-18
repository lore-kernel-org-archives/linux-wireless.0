Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34470 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbcCRCXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:23:00 -0400
Received: by mail-pf0-f179.google.com with SMTP id x3so145814193pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:23:00 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Alexander Tsoy <alexander@tsoy.me>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 06/19] ath9k_htc: Delete unnecessary variable initialisation
Date: Fri, 18 Mar 2016 13:22:52 +1100
Message-Id: <c05b18eb32ba150a16d5a1260832d0e57affb955.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032304_292068_A1272EA1)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

In ath9k_hif_usb_rx_stream(), i is initialised in the for loop it's
used in.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Oleksij Rempel <linux@rempel-privat.de>
[Rewrote commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8cbf490..e1c338c 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -527,7 +527,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				    struct sk_buff *skb)
 {
 	struct sk_buff *nskb, *skb_pool[MAX_PKT_NUM_IN_TRANSFER];
-	int index = 0, i = 0, len = skb->len;
+	int index = 0, i, len = skb->len;
 	int rx_remain_len, rx_pkt_len;
 	u16 pool_index = 0;
 	u8 *ptr;
-- 
2.7.0


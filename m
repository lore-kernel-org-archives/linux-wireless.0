Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34862 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeH2Muh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 08:50:37 -0400
From: Siva Rebbagondla <siva8118@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        Sasidhar Mudigonda <sasidhar.mudigonda@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Subject: [PATCH] Bluetooth: btrsi: fix bt tx timeout issue
Date: Wed, 29 Aug 2018 14:28:31 +0530
Message-Id: <1535533111-18301-1-git-send-email-siva8118@gmail.com> (sfid-20180829_105457_213053_27EE03CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>

observed sometimes data is coming with unaligned address from kernel
BT stack. If unaligned address is passed, some data in payload is
stripped when packet is loading to firmware and this results, BT
connection timeout is happening.

sh# hciconfig hci0 up
Can't init device hci0: hci0 command 0x0c03 tx timeout

Fixed this by moving the data to aligned address.

Signed-off-by: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/bluetooth/btrsi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
index 60d1419..3951f7b 100644
--- a/drivers/bluetooth/btrsi.c
+++ b/drivers/bluetooth/btrsi.c
@@ -21,8 +21,9 @@
 #include <net/rsi_91x.h>
 #include <net/genetlink.h>
 
-#define RSI_HEADROOM_FOR_BT_HAL	16
+#define RSI_DMA_ALIGN	8
 #define RSI_FRAME_DESC_SIZE	16
+#define RSI_HEADROOM_FOR_BT_HAL	(RSI_FRAME_DESC_SIZE + RSI_DMA_ALIGN)
 
 struct rsi_hci_adapter {
 	void *priv;
@@ -70,6 +71,16 @@ static int rsi_hci_send_pkt(struct hci_dev *hdev, struct sk_buff *skb)
 		bt_cb(new_skb)->pkt_type = hci_skb_pkt_type(skb);
 		kfree_skb(skb);
 		skb = new_skb;
+		if (!IS_ALIGNED((unsigned long)skb->data, RSI_DMA_ALIGN)) {
+			u8 *skb_data = skb->data;
+			int skb_len = skb->len;
+
+			skb_push(skb, RSI_DMA_ALIGN);
+			skb_pull(skb, PTR_ALIGN(skb->data,
+						RSI_DMA_ALIGN) - skb->data);
+			memmove(skb->data, skb_data, skb_len);
+			skb_trim(skb, skb_len);
+		}
 	}
 
 	return h_adapter->proto_ops->coex_send_pkt(h_adapter->priv, skb,
-- 
2.7.4

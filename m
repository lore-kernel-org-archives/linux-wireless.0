Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41258 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1177005AbdDYJKP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 05:10:15 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] ath6kl: assure headroom of skbuff is writable in .start_xmit()
Date: Tue, 25 Apr 2017 10:10:08 +0100
Message-Id: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170425_111023_664975_69BF9232)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An issue was found brcmfmac driver in which a skbuff in .start_xmit()
callback was actually cloned. So instead of checking for sufficient
headroom it should also be writable. Hence use skb_cow_head() to
check and expand the headroom appropriately.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

Did a recursive grep in drivers/net/wireless and found a similar
case in ath6kl. I do not have the hardware to test so this is
only compile tested.

Regards,
Arend
---
 drivers/net/wireless/ath/ath6kl/txrx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a531e0c..e6b2517 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -399,15 +399,10 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			csum_dest = skb->csum_offset + csum_start;
 		}
 
-		if (skb_headroom(skb) < dev->needed_headroom) {
-			struct sk_buff *tmp_skb = skb;
-
-			skb = skb_realloc_headroom(skb, dev->needed_headroom);
-			kfree_skb(tmp_skb);
-			if (skb == NULL) {
-				dev->stats.tx_dropped++;
-				return 0;
-			}
+		if (skb_cow_head(skb, dev->needed_headroom)) {
+			dev->stats.tx_dropped++;
+			kfree_skb(skb);
+			return 0;
 		}
 
 		if (ath6kl_wmi_dix_2_dot3(ar->wmi, skb)) {
-- 
1.9.1

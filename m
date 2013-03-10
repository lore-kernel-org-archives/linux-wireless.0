Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:57207 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3CJFvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 00:51:43 -0500
Subject: [PATCH 2/2] ath6kl: remove false check from ath6kl_rx()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sun, 10 Mar 2013 07:51:39 +0200
Message-ID: <20130310055139.18916.39967.stgit@localhost6.localdomain6> (sfid-20130310_065151_872622_880E4447)
In-Reply-To: <20130310055129.18916.96742.stgit@localhost6.localdomain6>
References: <20130310055129.18916.96742.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan found a check from ath6kl_rx() which doesn't make any sense at all:

"  1327          if (status || !(skb->data + HTC_HDR_LENGTH)) {
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^
skb->data is a pointer.  This pointer math is always going to be false.
Should it be testing "packet->act_len < HTC_HDR_LENGTH" or something?"

I don't know what the check really was supposed to do, but I think Dan's guess
is right. Fix it accordingly.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 43dbdaa..ebb2404 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1327,7 +1327,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		   __func__, ar, ept, skb, packet->buf,
 		   packet->act_len, status);
 
-	if (status || !(skb->data + HTC_HDR_LENGTH)) {
+	if (status || packet->act_len < HTC_HDR_LENGTH) {
 		dev_kfree_skb(skb);
 		return;
 	}


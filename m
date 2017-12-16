Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36596 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756815AbdLPToc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Dec 2017 14:44:32 -0500
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] NFC: Handle return value of skb_dequeue()
Date: Sun, 17 Dec 2017 01:14:20 +0530
Message-Id: <8a2fd474b3c7a14e13852f0947544aad8f0ae169.1513453148.git.arvind.yadav.cs@gmail.com> (sfid-20171216_204457_908236_704518D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb_dequeue() will return NULL for an empty list or a pointer
to the head element.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 net/nfc/rawsock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index e2188de..c6de1ac 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -201,6 +201,10 @@ static void rawsock_tx_work(struct work_struct *work)
 	}
 
 	skb = skb_dequeue(&sk->sk_write_queue);
+	if (!skb) {
+		rawsock_write_queue_purge(sk);
+		return;
+	}
 
 	sock_hold(sk);
 	rc = nfc_data_exchange(dev, target_idx, skb,
-- 
2.7.4

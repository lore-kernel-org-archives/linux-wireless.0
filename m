Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20323 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1LPU0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 15:26:22 -0500
Date: Fri, 16 Dec 2011 23:26:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] NFC: use kfree_skb() for sk_buffs
Message-ID: <20111216202600.GB18570@elgon.mountain> (sfid-20111216_212627_520186_E63B86C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a struct sk_buff pointer and it should be freed with kfree_skb()
instead of kfree().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index f99d6b4..1d32680 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -954,7 +954,7 @@ void nfc_llcp_unregister_device(struct nfc_dev *dev)
 	skb_queue_purge(&local->tx_queue);
 	destroy_workqueue(local->tx_wq);
 	destroy_workqueue(local->rx_wq);
-	kfree(local->rx_pending);
+	kfree_skb(local->rx_pending);
 	kfree(local);
 }
 
